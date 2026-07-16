# Autopilot hook — inject full-automation context on short trigger
# Triggers: !auto, /autopilot, Cyrillic shortcut via char codes

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

$trimmed = $prompt.Trim()
$lower = $trimmed.ToLowerInvariant()

$matched = $false
$task = ""

if ($lower.StartsWith('!auto')) {
    $matched = $true
    $task = $trimmed.Substring(5).Trim()
}
elseif ($lower.StartsWith('/autopilot')) {
    $matched = $true
    $task = $trimmed.Substring(11).Trim()
}
else {
    $cyrPrefix = [string][char]0x0021 + [char]0x0430 + [char]0x0432 + [char]0x0442 + [char]0x043E
    if ($trimmed.StartsWith($cyrPrefix)) {
        $matched = $true
        $task = $trimmed.Substring($cyrPrefix.Length).Trim()
    }
}

if (-not $matched) { exit 0 }

$hubRoot = Split-Path $PSScriptRoot -Parent
$profileLib = Join-Path $hubRoot "lib\user-profile\UserProfile.ps1"
$profileNote = ""
if (Test-Path $profileLib) {
    . $profileLib
    $prof = Get-UserProfile -HubRoot $hubRoot
    if ($prof -and $prof.automationPrefs) {
        $profileNote = "`nPrefs: auto=research/lint/docs/tests; ask=commit/push/deploy/delete/secrets. Questions only at START."
    }
}

$contractBlock = "`nContract if mega-task: Deliverables / Do-not-touch / Done-when"

$block = @"
[AUTOPILOT]
Full automation. Ask only on blockers; questions at END.
No commit/deploy unless task says so. Squad=10; agency max 2/session.
$profileNote
$contractBlock
"@

if ($task) {
    $block += "Task after trigger: $task`n"
}

$out = @{
    hookSpecificOutput = @{
        hookEventName     = "UserPromptSubmit"
        additionalContext = $block
    }
} | ConvertTo-Json -Compress -Depth 4

Write-Output $out
exit 0
