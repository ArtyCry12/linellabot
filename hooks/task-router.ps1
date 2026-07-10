# Task Router hook — inject skill/MCP/subagent route on every user prompt
# Runs on UserPromptSubmit via hooks.json (beforeSubmitPrompt)

$ErrorActionPreference = "Stop"
$inputRaw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputRaw)) { exit 0 }

try {
    $data = $inputRaw | ConvertFrom-Json
} catch {
    exit 0
}

$prompt = ""
if ($data.prompt) { $prompt = [string]$data.prompt }
elseif ($data.user_message) { $prompt = [string]$data.user_message }
elseif ($data.message) { $prompt = [string]$data.message }

if ([string]::IsNullOrWhiteSpace($prompt)) { exit 0 }

$hubRoot = Split-Path $PSScriptRoot -Parent
$resolver = Join-Path $hubRoot "lib/task-router/Resolve-TaskRoute.ps1"
if (-not (Test-Path $resolver)) { exit 0 }

. $resolver
$result = Resolve-TaskRoute -Prompt $prompt -HubRoot $hubRoot
$block = Format-TaskRouteContext -ResolveResult $result

if ([string]::IsNullOrWhiteSpace($block)) { exit 0 }

$out = @{
    hookSpecificOutput = @{
        hookEventName     = "UserPromptSubmit"
        additionalContext = $block
    }
} | ConvertTo-Json -Compress -Depth 4

Write-Output $out
exit 0
