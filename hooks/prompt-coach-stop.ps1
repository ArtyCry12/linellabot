# Session end — remind agent: mini prompt score (DEC-059)

$ErrorActionPreference = "Stop"
$hubRoot = Split-Path $PSScriptRoot -Parent
$lib = Join-Path $hubRoot "lib/prompt-coach/PromptCoach.ps1"
if (-not (Test-Path $lib)) { exit 0 }

. $lib
$paths = Get-CoachPaths -HubRoot $hubRoot
$state = Get-CoachState -Paths $paths

$captures = @(Get-CapturesSinceLesson -Paths $paths -State $state)
$recent = $captures | Select-Object -Last 1
if (-not $recent) { exit 0 }

$msg = @"
[PROMPT COACH — end of session]
Give ONE line mini-score for the user's main prompt this session (not a full lesson):
Format: **Промт X/10** — <one short reason in plain Russian>.
Then ask once: «Опубликовать урок в Notion?» only if you wrote a lesson this session.
Log via: Register-MiniScore in lib/prompt-coach/PromptCoach.ps1 when score assigned.
"@

$out = @{ followup_message = $msg } | ConvertTo-Json -Compress -Depth 3
Write-Output $out
exit 0
