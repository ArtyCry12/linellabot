param(
    [int]$Last = 20
)

$ErrorActionPreference = "Stop"
$HubRoot = Split-Path $PSScriptRoot -Parent
. (Join-Path $HubRoot "lib/prompt-coach/PromptCoach.ps1")

$r = Get-PromptWaterReport -Last $Last -HubRoot $HubRoot
Write-Output "Prompt water report (last $($r.Count) captures)"
Write-Output ("Avg water level: {0}/5 (1=lean, 5=verbose)" -f $r.AvgWater)
Write-Output ("High water (4-5): {0}" -f $r.HighWater)
Write-Output ""
Write-Output "Tip: use Deliverables / !auto / shorter goal-first prompts to reduce water."

if ($r.Count -eq 0) {
    Write-Output "No metrics yet. Captures flow via hooks/prompt-coach-capture.ps1"
}
