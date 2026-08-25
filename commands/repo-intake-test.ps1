param([string]$HubRoot = (Split-Path $PSScriptRoot -Parent))

$ErrorActionPreference = "Stop"
$fail = 0

Write-Host "=== Repo Intake test ===" -ForegroundColor Cyan

$files = @(
    "skills/repo-intake/SKILL.md"
    "hooks/repo-intake.ps1"
    "rules/repo-intake.mdc"
    "commands/repo.md"
    "templates/repo-intake/MENU-TEMPLATE.md"
)
foreach ($f in $files) {
    if (Test-Path (Join-Path $HubRoot $f)) { Write-Host "OK  $f" -ForegroundColor Green }
    else { Write-Host "FAIL $f" -ForegroundColor Red; $fail++ }
}

$hj = Get-Content (Join-Path $HubRoot "hooks.json") -Raw | ConvertFrom-Json
$hasHook = $false
foreach ($h in $hj.hooks.beforeSubmitPrompt) {
    if ($h.command -match 'repo-intake') { $hasHook = $true }
}
if ($hasHook) { Write-Host "OK  hooks.json repo-intake" -ForegroundColor Green }
else { Write-Host "FAIL hooks.json" -ForegroundColor Red; $fail++ }

$p = '{"prompt":"https://github.com/foo/some-skill look at this"}'
$out = $p | powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $HubRoot "hooks/repo-intake.ps1") 2>&1
if ($out -match 'REPO INTAKE') { Write-Host "OK  hook injects REPO INTAKE" -ForegroundColor Green }
else { Write-Host "FAIL hook output" -ForegroundColor Red; $fail++ }

. (Join-Path $HubRoot "lib/task-router/Resolve-TaskRoute.ps1")
$r = Resolve-TaskRoute -Prompt "/repo https://github.com/foo/bar" -HubRoot $HubRoot
if ($r.Matches[0].Id -eq 'repo-intake') { Write-Host "OK  task-router repo-intake" -ForegroundColor Green }
else { Write-Host "FAIL task-router ($($r.Matches[0].Id))" -ForegroundColor Red; $fail++ }

Write-Host ""
if ($fail -eq 0) { Write-Host "Summary: 0 FAIL" -ForegroundColor Green; exit 0 }
Write-Host "Summary: $fail FAIL" -ForegroundColor Red
exit 1
