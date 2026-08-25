param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [switch]$Json
)

$ErrorActionPreference = "Stop"
. (Join-Path $HubRoot "lib\mcp-router\McpTier.ps1")

$report = Get-McpHealthReport -HubRoot $HubRoot
$fail = 0

if ($Json) {
    $report | ConvertTo-Json -Depth 6
}
else {
    Write-Host "=== MCP health ===" -ForegroundColor Cyan
    foreach ($s in $report.servers) {
        $color = if ($s.configured) { "Green" } else { "Yellow" }
        $status = if ($s.configured) { "configured" } else { "missing in mcp.json" }
        if ($s.tier -eq "always-on" -and -not $s.configured) { $fail++ }
        Write-Host ("{0,-24} {1,-12} {2}" -f $s.id, $s.tier, $status) -ForegroundColor $color
    }
}

$outPath = Join-Path $HubRoot "ai-tracking\mcp-health.json"
$report | ConvertTo-Json -Depth 6 | Set-Content $outPath -Encoding UTF8

if ($fail -gt 0) {
    Write-Host "`nALWAYS-ON missing: $fail (add to mcp.json + Reload Window)" -ForegroundColor Yellow
    exit 1
}
Write-Host "`nMCP health: 0 critical fail" -ForegroundColor Green
exit 0
