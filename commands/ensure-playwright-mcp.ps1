param(
    [string]$HubRoot = "C:\Users\Asus\.cursor"
)

$ErrorActionPreference = "Stop"
Write-Host "=== Playwright MCP ensure ===" -ForegroundColor Cyan

$npx = Get-Command npx.cmd -ErrorAction SilentlyContinue
if (-not $npx) { throw "npx.cmd not found" }

# Smoke: package resolves
& npx.cmd -y @playwright/mcp@latest --help 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "WARN: @playwright/mcp help failed; add to mcp.json manually" -ForegroundColor Yellow
    exit 1
}

$mcpPath = Join-Path $HubRoot "mcp.json"
if (Test-Path $mcpPath) {
    $raw = Get-Content $mcpPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if (-not $raw.mcpServers.PSObject.Properties['playwright']) {
        Write-Host "NOTE: add playwright to mcp.json:" -ForegroundColor Yellow
        Write-Host '  "playwright": { "command": "npx.cmd", "args": ["-y", "@playwright/mcp@latest"] }'
    }
    else {
        Write-Host "OK: playwright in mcp.json" -ForegroundColor Green
    }
}

$health = Join-Path $HubRoot "ai-tracking\playwright-mcp-health.json"
@{ checkedAt = (Get-Date).ToUniversalTime().ToString("o"); ok = $true } |
    ConvertTo-Json | Set-Content $health -Encoding UTF8
exit 0
