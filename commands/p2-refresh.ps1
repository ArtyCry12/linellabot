param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Continue"
Write-Host "=== P2 refresh ===" -ForegroundColor Cyan

# Rules sync
$sync = Join-Path $HubRoot "commands\huashu-sync-workspace-rules.py"
if (Test-Path $sync) {
    python $sync
}

# Skill index
$idx = Join-Path $HubRoot "commands\generate-skill-index.mjs"
if (Test-Path $idx) {
    node $idx 2>&1 | Out-Null
}

# P1 smoke
$p1 = Join-Path $HubRoot "commands\p1-mcp-smoke.ps1"
if (Test-Path $p1) {
    & $p1 -HubRoot $HubRoot
}

# SEO CLI versions
Write-Host "`nSEO CLI:" -ForegroundColor Yellow
@("lighthouse", "htmlhint", "eslint") | ForEach-Object {
    $v = npx --yes $_ --version 2>&1 | Select-Object -First 1
    Write-Host "  $_ : $v"
}

# uv
uv --version 2>&1 | ForEach-Object { Write-Host "  uv: $_" }

Write-Host "`nP2 refresh done. See ai-tracking/P2-MCP-COMPLETE.md" -ForegroundColor Green
