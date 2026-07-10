# Ensure Stitch MCP proxy + descriptors are healthy

$ErrorActionPreference = "Stop"
$Hub = "C:\Users\Asus\.cursor"
$Proxy = Join-Path $Hub "commands\stitch-mcp-proxy.mjs"
$Sync = Join-Path $Hub "commands\sync-stitch-mcp-descriptors.mjs"
$McpJson = Join-Path $Hub "mcp.json"

Write-Host "=== Stitch MCP health check ===" -ForegroundColor Cyan

if (-not (Test-Path $Proxy)) {
  Write-Host "ERROR: Missing $Proxy" -ForegroundColor Red
  exit 1
}

$key = $env:STITCH_API_KEY
if (-not $key -and (Test-Path $McpJson)) {
  $cfg = Get-Content $McpJson -Raw | ConvertFrom-Json
  $key = $cfg.mcpServers.stitch.env.STITCH_API_KEY
  if (-not $key) { $key = $cfg.mcpServers.stitch.headers.'X-Goog-Api-Key' }
}

if (-not $key) {
  Write-Host "ERROR: STITCH_API_KEY not in env or mcp.json" -ForegroundColor Red
  exit 1
}

$env:STITCH_API_KEY = $key
$initBody = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"ensure-stitch","version":"1"}}}'
$listBody = '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}'

function Invoke-StitchProxy($body) {
  return ($body | node $Proxy 2>$null | Select-Object -Last 1)
}

try {
  $init = Invoke-StitchProxy $initBody | ConvertFrom-Json
  if (-not $init.result) { throw "initialize failed: $($init | ConvertTo-Json -Compress)" }
  Write-Host "OK: initialize -> $($init.result.serverInfo.name)" -ForegroundColor Green

  $listRaw = Invoke-StitchProxy $listBody
  $listBytes = [System.Text.Encoding]::UTF8.GetByteCount($listRaw)
  $list = $listRaw | ConvertFrom-Json
  $count = @($list.result.tools).Count
  if ($count -lt 1) { throw "tools/list returned 0 tools (payload ${listBytes} bytes)" }
  Write-Host "OK: tools/list -> $count tools ($([math]::Round($listBytes/1024, 1)) KB stripped)" -ForegroundColor Green

  & node $Sync
  if ($LASTEXITCODE -ne 0) { throw "sync-stitch-mcp-descriptors failed" }
  Write-Host "OK: descriptors synced to user-stitch" -ForegroundColor Green

  Write-Host ""
  Write-Host "Next: Reload Window in Cursor. Stitch should show 14 tools (not 0)." -ForegroundColor Yellow
  exit 0
}
catch {
  Write-Host "ERROR: $_" -ForegroundColor Red
  exit 1
}
