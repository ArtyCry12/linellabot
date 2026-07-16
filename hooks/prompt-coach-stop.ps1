# Session end — mini prompt score (compact)

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

$waterNote = ""
if ($recent.PSObject.Properties.Name -contains "waterLevel") {
    $wl = [int]$recent.waterLevel
    if ($wl -ge 4) {
        $waterNote = " Water was $wl/5 - suggest shorter prompt if score <8."
    }
}

$msg = "[PROMPT COACH] One line: **Промт X/10** — short RU reason.$waterNote Log via Register-MiniScore. Lesson? humanizer + TTS + Notion preview."

$out = @{ followup_message = $msg } | ConvertTo-Json -Compress -Depth 3
Write-Output $out
exit 0
