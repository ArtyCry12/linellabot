param(
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [switch]$Reload,
    [int]$WaitMinutes = 3
)

$ErrorActionPreference = "Continue"
Write-Host "=== Post-reload bootstrap (REQ-006) ===" -ForegroundColor Cyan

if ($Reload) {
    $reload = Join-Path $HubRoot "commands\cursor-reload-window.ps1"
    if (Test-Path $reload) {
        & $reload
    } else {
        Write-Host "Manual: Ctrl+Shift+P -> Developer: Reload Window" -ForegroundColor Yellow
    }
}

$sec = $WaitMinutes * 60
Write-Host "Waiting $WaitMinutes min for MCP servers to start..." -ForegroundColor Yellow
Start-Sleep -Seconds $sec

$final = Join-Path $HubRoot "commands\p3-final-audit.ps1"
if (Test-Path $final) {
    & $final -HubRoot $HubRoot
} else {
    & (Join-Path $HubRoot "commands\p3-system-test.ps1") -HubRoot $HubRoot
}

Write-Host "`nNext: POST-RELOAD-GUIDE.md" -ForegroundColor Green
