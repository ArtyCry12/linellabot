param(
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [switch]$Json
)

$ErrorActionPreference = "Stop"
$rows = @()

function Add-Row([string]$path, [string]$kind) {
    if (-not (Test-Path $path)) { return }
    $size = (Get-ChildItem $path -Recurse -Force -ErrorAction SilentlyContinue |
        Measure-Object -Property Length -Sum).Sum
    $script:rows += [PSCustomObject]@{
        path = $path.Replace($HubRoot, "~")
        kind = $kind
        mb   = [math]::Round($size / 1MB, 2)
    }
}

Add-Row (Join-Path $HubRoot "ai-tracking") "tracking"
Add-Row (Join-Path $HubRoot "plugins\cache") "plugins-cache"
Add-Row (Join-Path $HubRoot ".cache\markitdown") "markitdown-cache"
Add-Row (Join-Path $HubRoot "node_modules") "node_modules"
Add-Row (Join-Path $HubRoot "lib\ecc-src") "ecc-src"
Add-Row (Join-Path $HubRoot "lib\n8n-templates-src") "n8n-src"

$report = [ordered]@{
    checkedAt = (Get-Date).ToUniversalTime().ToString("o")
    totalMb   = [math]::Round(($rows | Measure-Object mb -Sum).Sum, 2)
    rows      = $rows
    safeActions = @(
        "commands/cursor-system-refresh-deferred.ps1",
        "ai-tracking archive logs >30d",
        "plugins/cache old versions",
        ".cache/markitdown stale"
    )
}

$out = Join-Path $HubRoot "ai-tracking\disk-audit.json"
$report | ConvertTo-Json -Depth 5 | Set-Content $out -Encoding UTF8

if ($Json) { $report | ConvertTo-Json -Depth 5; exit 0 }

Write-Host "=== Hub disk audit ===" -ForegroundColor Cyan
$rows | Sort-Object mb -Descending | Format-Table -AutoSize
Write-Host "Total: $($report.totalMb) MB" -ForegroundColor Yellow
Write-Host "Report: $out"
exit 0
