# Task Router — preToolUse Task/Subagent: inject [TASK ROUTE] into subagent prompt
# Fail-open. Residual: some Cursor builds historically ignored updated_input for Task.

$ErrorActionPreference = 'Stop'

function Register-TaskRouterBackgroundAgent {
    param([string]$HubRoot, [string]$SessionId, [int]$Limit = 3, [int]$WindowSec = 120)
    if ([string]::IsNullOrWhiteSpace($SessionId)) {
        $SessionId = if ($env:TASK_ROUTER_BUDGET_FALLBACK_SESSION) {
            [string]$env:TASK_ROUTER_BUDGET_FALLBACK_SESSION
        }
        else { "global-fallback" }
    }
    $mutex = New-Object Threading.Mutex($false, "Local\CursorTaskRouterBudget")
    $locked = $mutex.WaitOne(2000)
    if (-not $locked) {
        $mutex.Dispose()
        return $false
    }
    try {
        $bytes = [Text.Encoding]::UTF8.GetBytes($SessionId)
        $sha = [Security.Cryptography.SHA256]::Create()
        try {
            $sessionHash = ([BitConverter]::ToString($sha.ComputeHash($bytes)) -replace "-", "").Substring(0, 16)
        }
        finally { $sha.Dispose() }
        $dir = Join-Path $HubRoot ".cache/task-router"
        if (-not (Test-Path -LiteralPath $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        $statePath = Join-Path $dir "agent-budget-$sessionHash.json"
        $now = [DateTime]::UtcNow
        $count = 0
        if (Test-Path -LiteralPath $statePath) {
            try {
                $state = Get-Content $statePath -Raw -Encoding UTF8 | ConvertFrom-Json
                $age = ($now - [DateTime]::Parse(
                    [string]$state.at,
                    $null,
                    [Globalization.DateTimeStyles]::RoundtripKind
                )).TotalSeconds
                if ($age -ge 0 -and $age -lt $WindowSec) {
                    $count = [int]$state.count
                }
            }
            catch { $count = 0 }
        }
        if ($count -ge $Limit) { return $false }
        [PSCustomObject]@{
            count = $count + 1
            at = $now.ToString("o")
        } | ConvertTo-Json -Compress | Set-Content $statePath -Encoding UTF8
        return $true
    }
    finally {
        $mutex.ReleaseMutex()
        $mutex.Dispose()
    }
}

try {
    [Console]::InputEncoding = [Text.UTF8Encoding]::new($false)
    [Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
    $inputRaw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($inputRaw)) { exit 0 }

    try {
        $data = $inputRaw | ConvertFrom-Json
    }
    catch { exit 0 }

    $toolName = ''
    if ($data.tool_name) { $toolName = [string]$data.tool_name }
    elseif ($data.toolName) { $toolName = [string]$data.toolName }
    elseif ($data.tool) { $toolName = [string]$data.tool }
    if ($toolName -and $toolName -notmatch '(?i)^(Task|Subagent)$') { exit 0 }

    $toolInput = $null
    if ($data.tool_input) { $toolInput = $data.tool_input }
    elseif ($data.toolInput) { $toolInput = $data.toolInput }
    elseif ($data.input) { $toolInput = $data.input }
    if (-not $toolInput) { exit 0 }

    $prompt = ''
    if ($toolInput.prompt) { $prompt = [string]$toolInput.prompt }
    if ([string]::IsNullOrWhiteSpace($prompt)) { exit 0 }

    # Already routed or advisor spawn — do not re-resolve / loop
    if ($prompt -match '\[TASK ROUTE\]' -or $prompt -match 'route-advisor' -or $prompt -match 'advisor=1') {
        exit 0
    }

    $hubRoot = Split-Path $PSScriptRoot -Parent
    $background = [bool]($toolInput.run_in_background -or $toolInput.runInBackground)
    $sessionId = ""
    if ($data.conversation_id) { $sessionId = [string]$data.conversation_id }
    elseif ($data.conversationId) { $sessionId = [string]$data.conversationId }
    elseif ($data.session_id) { $sessionId = [string]$data.session_id }
    elseif ($data.sessionId) { $sessionId = [string]$data.sessionId }
    if ($background -and
        -not (Register-TaskRouterBackgroundAgent -HubRoot $hubRoot -SessionId $sessionId)) {
        @{
            permission = "deny"
            message = "Task Router Max: maximum three background agents per launch window."
        } | ConvertTo-Json -Compress | Write-Output
        exit 0
    }
    $resolver = Join-Path $hubRoot 'lib/task-router/Resolve-TaskRoute.ps1'
    if (-not (Test-Path -LiteralPath $resolver)) { exit 0 }

    . $resolver
    $result = Resolve-TaskRoute -Prompt $prompt -HubRoot $hubRoot -Source 'task'
    $block = Format-TaskRouteContext -ResolveResult $result
    if ([string]::IsNullOrWhiteSpace($block)) { exit 0 }

    # Do not nest advisor flag into Task prompts (parent-only)
    $block = ($block -split "`n" | Where-Object {
        $_ -notmatch 'TASK ROUTE - advisor' -and
        $_ -notmatch 'Parent (MAY|MUST) spawn route-advisor'
    }) -join "`n"
    $block = $block -replace '(?i)(,\s*)?route_advisor(,\s*)?', ', '
    $block += @"

[EPHEMERAL AGENT CONTRACT]
No nested subagents. Return: GOAL, EVIDENCE, DECISION, RISKS, FILES, NEXT_ACTION.
Use only routed capabilities; if intent is still ambiguous, return a blocker instead of improvising.
"@
    if ([string]::IsNullOrWhiteSpace($block)) { exit 0 }

    $newPrompt = "$block`n`n$prompt"

    # Merge updated_input: keep other Task fields
    $updated = @{}
    foreach ($p in $toolInput.PSObject.Properties) {
        $updated[$p.Name] = $p.Value
    }
    $updated['prompt'] = $newPrompt

    $out = @{
        permission    = 'allow'
        updated_input = $updated
    } | ConvertTo-Json -Compress -Depth 8

    Write-Output $out
    exit 0
}
catch {
    exit 0
}
