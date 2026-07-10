param(
    [string]$HubRoot = "C:\Users\Asus\.cursor"
)

$ErrorActionPreference = "Stop"
Write-Host "=== Hub routing + prompt coach combined test ===" -ForegroundColor Cyan

$router = Join-Path $HubRoot "commands/task-router-test.ps1"
$coach = Join-Path $HubRoot "commands/prompt-coach-test.ps1"

& $router
$r1 = $LASTEXITCODE
& $coach
$r2 = $LASTEXITCODE

Write-Host ""
if ($r1 -eq 0 -and $r2 -eq 0) {
    Write-Host "COMBINED: 0 FAIL - ready to commit" -ForegroundColor Green
    exit 0
}
Write-Host "COMBINED: FAIL (router=$r1 coach=$r2)" -ForegroundColor Red
exit 1
