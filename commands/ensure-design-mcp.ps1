# Ensure Stitch + Figma MCP are configured and descriptors synced
$ErrorActionPreference = "Stop"
$Hub = (Split-Path $PSScriptRoot -Parent)
$Commands = Join-Path $Hub "commands"

Write-Host "=== Design MCP health (Stitch + Figma) ===" -ForegroundColor Cyan

& (Join-Path $Commands "ensure-stitch.ps1")
if ($LASTEXITCODE -ne 0) {
  Write-Host "FAIL: Stitch health check" -ForegroundColor Red
  exit 1
}

$mcpJson = Join-Path $Hub "mcp.json"
if (-not (Test-Path $mcpJson)) {
  Write-Host "ERROR: mcp.json missing" -ForegroundColor Red
  exit 1
}

$cfg = Get-Content $mcpJson -Raw | ConvertFrom-Json
$figma = $cfg.mcpServers.figma
if (-not $figma) {
  Write-Host "WARN: figma not in mcp.json" -ForegroundColor Yellow
} elseif ($figma.url -ne "https://mcp.figma.com/mcp") {
  Write-Host "WARN: unexpected figma url" -ForegroundColor Yellow
} else {
  Write-Host "OK: figma entry in mcp.json" -ForegroundColor Green
}

& node (Join-Path $Commands "sync-figma-mcp-descriptors.mjs")
if ($LASTEXITCODE -ne 0) {
  Write-Host "FAIL: sync-figma-mcp-descriptors" -ForegroundColor Red
  exit 1
}

$stitch = $cfg.mcpServers.stitch
$stitchArgs = ($stitch.args | Out-String)
if ($stitch.command -ne "node" -or $stitchArgs -notmatch "stitch-mcp-proxy") {
  Write-Host "WARN: stitch should use stitch-mcp-proxy.mjs" -ForegroundColor Yellow
} else {
  Write-Host "OK: stitch proxy config" -ForegroundColor Green
}

Write-Host ""
Write-Host "Next: Reload Window then Connect figma OAuth in MCP settings" -ForegroundColor Yellow
exit 0
