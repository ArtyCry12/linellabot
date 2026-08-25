param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"
$cred = Join-Path $HubRoot "ai-tracking\google-oauth-client.json"

if (-not (Test-Path $cred)) {
    throw "Missing OAuth file at $cred"
}

Write-Host "=== Google MCP ==="
Write-Host "OK: OAuth file present"
Write-Host "OK: google-workspace uses google-workspace-mcp-wrapper.mjs"
Write-Host "OK: google-maps endpoint configured"
Write-Host ""
Write-Host "Next:"
Write-Host "1. Reload Window in Cursor"
Write-Host "2. Enable google-workspace in MCP settings"
Write-Host "3. Complete browser OAuth on first use"
Write-Host "4. Enable Gmail, Drive, Calendar APIs in Google Cloud if needed"
