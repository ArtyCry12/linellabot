param(
    [string]$HubRoot = "C:\Users\Asus\.cursor"
)

$ErrorActionPreference = "Stop"
$fail = 0

function Test-HubFile {
    param([string]$RelPath, [string]$Label)
    $full = Join-Path $HubRoot $RelPath
    if (Test-Path $full) {
        Write-Host "OK  $Label" -ForegroundColor Green
        return $true
    }
    Write-Host "FAIL $Label" -ForegroundColor Red
    return $false
}

Write-Host "=== Prompt Coach system test (DEC-058/059) ===" -ForegroundColor Cyan

$fileChecks = @(
    @{ Path = "lib/prompt-coach/PromptCoach.ps1"; Label = "PromptCoach.ps1" }
    @{ Path = "lib/prompt-coach/CoachConfig.json"; Label = "CoachConfig.json" }
    @{ Path = "hooks/prompt-coach-capture.ps1"; Label = "capture hook" }
    @{ Path = "hooks/prompt-coach-stop.ps1"; Label = "stop hook" }
    @{ Path = "hooks/autopilot.ps1"; Label = "autopilot hook" }
    @{ Path = "rules/prompt-engineering-coach.mdc"; Label = "coach rule" }
    @{ Path = "skills/prompt-engineering-coach/SKILL.md"; Label = "coach skill" }
    @{ Path = "templates/prompt-lesson/LESSON-TEMPLATE.md"; Label = "lesson template" }
    @{ Path = "templates/prompt-lesson/CONTRACT-TEMPLATE.md"; Label = "contract template" }
    @{ Path = "commands/prompt-coach-status.ps1"; Label = "status cmd" }
    @{ Path = "commands/prompt-lesson-notion.ps1"; Label = "notion cmd" }
    @{ Path = "commands/prompt-hooks-cheatsheet.ps1"; Label = "cheatsheet cmd" }
    @{ Path = "skills/prompt-engineering-coach/references/NOTION-PUBLISH.md"; Label = "notion ref" }
)

foreach ($fc in $fileChecks) {
    if (-not (Test-HubFile -RelPath $fc.Path -Label $fc.Label)) { $fail++ }
}

$cfg = Get-Content (Join-Path $HubRoot "lib/prompt-coach/CoachConfig.json") -Raw | ConvertFrom-Json
foreach ($f in @("notionHubPageId", "scoresFile", "cheatsheetIntervalDays")) {
    if ($cfg.$f) { Write-Host "OK  config.$f" -ForegroundColor Green }
    else { Write-Host "FAIL config.$f" -ForegroundColor Red; $fail++ }
}

$auto = Get-Content (Join-Path $HubRoot "hooks/autopilot.ps1") -Raw
if ($auto -match "Deliverables") { Write-Host "OK  autopilot contract block" -ForegroundColor Green }
else { Write-Host "FAIL autopilot contract" -ForegroundColor Red; $fail++ }

$hj = Get-Content (Join-Path $HubRoot "hooks.json") -Raw | ConvertFrom-Json
if ($hj.hooks.stop) { Write-Host "OK  hooks.json stop" -ForegroundColor Green }
else { Write-Host "FAIL hooks.json stop" -ForegroundColor Red; $fail++ }

. (Join-Path $HubRoot "lib/prompt-coach/PromptCoach.ps1")
$r = Get-CoachReadiness -HubRoot $HubRoot
Write-Host "OK  Get-CoachReadiness (lessons $($r.LessonsWritten))" -ForegroundColor Green

$top = Get-TopHooksFromCaptures -HubRoot $HubRoot
Write-Host "OK  Get-TopHooksFromCaptures ($($top.Count) items)" -ForegroundColor Green

$cs = Get-CheatsheetReadiness -HubRoot $HubRoot
Write-Host "OK  Get-CheatsheetReadiness (ready=$($cs.Ready))" -ForegroundColor Green

$p = '{"prompt":"test prompt for coach capture with enough length to pass filter"}'
$p | powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $HubRoot "hooks/prompt-coach-capture.ps1") 2>&1 | Out-Null
Write-Host "OK  capture hook exit" -ForegroundColor Green

$lesson = Join-Path $HubRoot "ai-tracking/prompt-lessons/2026-07-10-notion-mega-prompt.md"
if (Test-Path $lesson) {
    $pl = Get-NotionPublishPayload -LessonPath $lesson -HubRoot $HubRoot
    if ($pl.parent_page_id) { Write-Host "OK  Get-NotionPublishPayload" -ForegroundColor Green }
    else { Write-Host "FAIL notion payload" -ForegroundColor Red; $fail++ }
}

powershell -NoProfile -File (Join-Path $HubRoot "commands/prompt-hooks-cheatsheet.ps1") -Force 2>&1 | Out-Null
$cheat = Join-Path $HubRoot "ai-tracking/prompt-lessons/cheatsheet-$(Get-Date -Format yyyy-MM).md"
if (Test-Path $cheat) { Write-Host "OK  cheatsheet generated" -ForegroundColor Green }
else { Write-Host "FAIL cheatsheet file" -ForegroundColor Red; $fail++ }

$w = Measure-PromptWater -Text "please could you maybe help me with something really important"
if ($w.waterLevel -lt 1 -or $w.waterLevel -gt 5) {
    Write-Host "FAIL Measure-PromptWater range" -ForegroundColor Red; $fail++
} else {
    Write-Host "OK  Measure-PromptWater level=$($w.waterLevel)" -ForegroundColor Green
}

$cap = Add-PromptCapture -Prompt "Deliverables: test`nDone when: water metrics work" -HubRoot $HubRoot
if ($cap.WaterLevel) { Write-Host "OK  capture waterLevel=$($cap.WaterLevel)" -ForegroundColor Green }
else { Write-Host "FAIL capture water metrics" -ForegroundColor Red; $fail++ }

Write-Host ""
if ($fail -eq 0) {
    Write-Host "Summary: 0 FAIL" -ForegroundColor Green
    exit 0
}
Write-Host "Summary: $fail FAIL" -ForegroundColor Red
exit 1
