param(
    [Parameter(Position = 0)]
    [ValidateSet("core", "design", "qa", "ops", "status", "list")]
    [string]$Name = "status",
    [string]$HubRoot = "C:\Users\artyo\.cursor"
)

$ErrorActionPreference = "Stop"

$profilesDir = Join-Path $HubRoot "lib\mcp-router\profiles"
$statePath = Join-Path $HubRoot "ai-tracking\mcp-active-profile.json"
$applyJs = Join-Path $HubRoot "lib\mcp-router\apply-mcp-profile.mjs"

function Show-McpProfileStatus {
    Write-Host "=== MCP profiles ===" -ForegroundColor Cyan
    Get-ChildItem $profilesDir -Filter "*.json" | ForEach-Object {
        $p = Get-Content $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
        $ids = if ($p.ids -and $p.ids[0] -eq "*") { "all from store" } else { ($p.ids -join ", ") }
        Write-Host ("  {0,-8} {1}" -f $p.id, $ids)
    }
    if (Test-Path $statePath) {
        $st = Get-Content $statePath -Raw -Encoding UTF8 | ConvertFrom-Json
        Write-Host "`nActive: $($st.profile)  ($($st.appliedAt))" -ForegroundColor Green
        Write-Host ("Servers: " + ($st.ids -join ", "))
        Write-Host "GitNexus heap: $($st.gitnexusHeapMb) MB"
    }
    else {
        Write-Host "`nActive: unknown (no ai-tracking/mcp-active-profile.json)" -ForegroundColor Yellow
    }
    $mcpPath = Join-Path $HubRoot "mcp.json"
    if (Test-Path $mcpPath) {
        $live = (Get-Content $mcpPath -Raw -Encoding UTF8 | ConvertFrom-Json).mcpServers.PSObject.Properties.Name
        Write-Host ("mcp.json now: " + ($live -join ", "))
    }
}

if ($Name -eq "status" -or $Name -eq "list") {
    Show-McpProfileStatus
    exit 0
}

if (-not (Test-Path (Join-Path $HubRoot "mcp.json.store"))) {
    Write-Host "mcp.json.store missing. Copy mcp.json there before switching." -ForegroundColor Red
    exit 1
}

Write-Host "Applying profile: $Name" -ForegroundColor Cyan
node $applyJs $Name
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Show-McpProfileStatus
Write-Host "`nReload Window in Cursor so old MCP processes die." -ForegroundColor Yellow
exit 0
