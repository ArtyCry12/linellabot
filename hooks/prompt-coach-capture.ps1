# Capture substantive user prompts for prompt-engineering coach (DEC-058)

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

if ($prompt -match '<user_query>\s*([\s\S]*?)\s*</user_query>') {
    $prompt = $Matches[1]
}

$hubRoot = Split-Path $PSScriptRoot -Parent
$lib = Join-Path $hubRoot "lib/prompt-coach/PromptCoach.ps1"
if (-not (Test-Path $lib)) { exit 0 }

. $lib
Add-PromptCapture -Prompt $prompt -HubRoot $hubRoot | Out-Null
exit 0
