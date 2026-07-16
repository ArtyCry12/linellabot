# Repo intake — detect GitHub/path/zip in prompt

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

$matched = $false
$target = ""

if ($prompt -match '(https?://(?:github|gitlab)\.com/[^\s\)>]+)') {
    $matched = $true
    $target = $Matches[1]
}
elseif ($prompt -match '(https?://[^\s\)>]+\.git\b)') {
    $matched = $true
    $target = $Matches[1]
}
elseif ($prompt -match '@([A-Za-z]:\\[^\s\)>]+)') {
    $matched = $true
    $target = $Matches[1]
}
elseif ($prompt -match '([A-Za-z]:\\[^\s\)>]+\.zip)') {
    $matched = $true
    $target = $Matches[1]
}
elseif ($prompt -match '(?i)\b(?:repository|repo)\b') {
    if ($prompt -match '(https?://\S+)') {
        $matched = $true
        $target = $Matches[1]
    }
}

if (-not $matched) { exit 0 }

$auto = $false
if ($prompt -match '(?i)!auto|/autopilot') { $auto = $true }

$block = @"
[REPO INTAKE] Target: $target
Skill: skills/repo-intake/SKILL.md
Scout README → classify → menu A/B/C → wait for A/B/C.
"@

if ($auto) {
    $block += " Autopilot: if HIGH confidence execute A."
}

$out = @{
    hookSpecificOutput = @{
        hookEventName     = "UserPromptSubmit"
        additionalContext = $block
    }
} | ConvertTo-Json -Compress -Depth 4

Write-Output $out
exit 0
