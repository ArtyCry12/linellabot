# Task Router hook — UserPromptSubmit → [TASK ROUTE] + optional advisor flag
# Fail-open: any error exits 0 without blocking the chat.

$ErrorActionPreference = 'Stop'

try {
    [Console]::InputEncoding = [Text.UTF8Encoding]::new($false)
    [Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
    $inputRaw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($inputRaw)) { exit 0 }

    try {
        $data = $inputRaw | ConvertFrom-Json
    }
    catch { exit 0 }

    $prompt = ''
    if ($data.prompt) { $prompt = [string]$data.prompt }
    elseif ($data.user_message) { $prompt = [string]$data.user_message }
    elseif ($data.message) { $prompt = [string]$data.message }

    if ([string]::IsNullOrWhiteSpace($prompt)) { exit 0 }

    $hubRoot = Split-Path $PSScriptRoot -Parent
    $resolver = Join-Path $hubRoot 'lib/task-router/Resolve-TaskRoute.ps1'
    if (-not (Test-Path -LiteralPath $resolver)) { exit 0 }

    . $resolver
    $extra = Get-TaskRouterPlanExtraText -Prompt $prompt -HubRoot $hubRoot
    $result = Resolve-TaskRoute -Prompt $prompt -ExtraText $extra -HubRoot $hubRoot -Source 'user'
    $block = Format-TaskRouteContext -ResolveResult $result

    if ([string]::IsNullOrWhiteSpace($block)) { exit 0 }

    $out = @{
        hookSpecificOutput = @{
            hookEventName     = 'UserPromptSubmit'
            additionalContext = $block
        }
    } | ConvertTo-Json -Compress -Depth 6

    Write-Output $out
    exit 0
}
catch {
    exit 0
}
