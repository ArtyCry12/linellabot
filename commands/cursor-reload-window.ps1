# Reload Cursor window after MCP config changes
$ErrorActionPreference = "Continue"
$cursor = Join-Path $env:LOCALAPPDATA "Programs\cursor\resources\app\bin\cursor.cmd"

Write-Host "=== Cursor Reload Window ===" -ForegroundColor Cyan

if (-not (Test-Path $cursor)) {
  Write-Host "ERROR: cursor.cmd not found at $cursor" -ForegroundColor Red
  Write-Host "Manual: Ctrl+Shift+P -> Developer: Reload Window"
  exit 1
}

# VS Code/Cursor accepts --command (may log a warning)
& $cursor --command "workbench.action.reloadWindow" 2>$null
Start-Sleep -Seconds 2

Write-Host "Reload command sent." -ForegroundColor Green
Write-Host "If window did not reload: Ctrl+Shift+P -> Developer: Reload Window"
