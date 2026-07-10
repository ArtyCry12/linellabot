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

$block = @"
[AUTOPILOT MODE — user granted full automation rights]

- Execute end-to-end without per-step approval; use shell, MCP, skills, subagents as needed.
- Ask only on real blockers; put questions and improvement ideas at the END.
- No commits/deploy unless explicitly requested in the task.
- Respect DEC-004: Squad stays 10 agents; agency max 2/session.

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
