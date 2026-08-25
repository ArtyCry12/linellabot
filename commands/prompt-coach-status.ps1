param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [switch]$Json
)

$ErrorActionPreference = "Stop"
. (Join-Path $HubRoot "lib/prompt-coach/PromptCoach.ps1")

$r = Get-CoachReadiness -HubRoot $HubRoot

if ($Json) {
    $r | ConvertTo-Json -Depth 4
    exit 0
}

Write-Host "=== Prompt Engineering Coach ===" -ForegroundColor Cyan
Write-Host "Lessons written: $($r.LessonsWritten)"
Write-Host "Last lesson:     $(if ($r.LastLessonAt) { $r.LastLessonAt } else { '(none)' })"
Write-Host "Your prompts since last lesson: $($r.PromptsSince) / $($r.MinPrompts) needed"
Write-Host "Days since lesson: $($r.DaysSinceLesson) (min $($r.MinDays))"
Write-Host ""
if ($r.Ready) {
    Write-Host "READY for new lesson - agent may write brief to ai-tracking/prompt-lessons/" -ForegroundColor Green
} else {
    Write-Host "Not ready yet: $($r.Reasons)" -ForegroundColor Yellow
}
Write-Host ""
Write-Host "Notion hub: $($r.NotionHub)"
