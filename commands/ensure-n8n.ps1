# Ensure n8n MCP (instance-level HTTP) + descriptors are healthy

$ErrorActionPreference = "Stop"
$Hub = "C:\Users\Asus\.cursor"
$Test = Join-Path $Hub "commands\test-n8n-mcp.mjs"
$Sync = Join-Path $Hub "commands\sync-n8n-mcp-descriptors.mjs"
$McpJson = Join-Path $Hub "mcp.json"

Write-Host "=== n8n MCP health check ===" -ForegroundColor Cyan

if (-not (Test-Path $McpJson)) {
  Write-Host "ERROR: Missing $McpJson - copy from mcp.json.example" -ForegroundColor Red
  exit 1
}

$cfg = Get-Content $McpJson -Raw | ConvertFrom-Json
$n8n = $cfg.mcpServers.'n8n-mcp'
if (-not $n8n.url) {
  Write-Host "ERROR: n8n-mcp block missing in mcp.json" -ForegroundColor Red
  exit 1
}

$auth = $n8n.headers.Authorization
if (-not $auth -or $auth.Length -lt 120) {
  Write-Host "ERROR: n8n Bearer token missing or truncated in mcp.json" -ForegroundColor Red
  exit 1
}

try {
  & node $Test
  if ($LASTEXITCODE -ne 0) { throw "test-n8n-mcp failed" }

  & node $Sync
  if ($LASTEXITCODE -ne 0) { throw "sync-n8n-mcp-descriptors failed" }
  Write-Host "OK: descriptors synced to user-n8n-mcp" -ForegroundColor Green

  Write-Host ""
  Write-Host "Next: Reload Window in Cursor. n8n-mcp should show tools in Tools and MCP." -ForegroundColor Yellow
  exit 0
}
catch {
  Write-Host ("ERROR: " + $_.Exception.Message) -ForegroundColor Red
  exit 1
}
