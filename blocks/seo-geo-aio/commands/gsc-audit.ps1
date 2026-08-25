param(
    [string]$ImportDir = "C:\Users\Asus\.cursor\ai-tracking\gsc-import",
    [string]$HubRoot = "C:\Users\Asus\.cursor"
)

$ErrorActionPreference = "Continue"
$out = Join-Path $HubRoot "ai-tracking\gsc-last-summary.md"

if (-not (Test-Path $ImportDir)) {
    New-Item -ItemType Directory -Force -Path $ImportDir | Out-Null
    @"
# GSC import folder

Export CSV from Google Search Console -> save here.
Run: ``commands/gsc-audit.ps1``

Full API: enable google-workspace OAuth then extend this script.
"@ | Set-Content (Join-Path $ImportDir "README.md") -Encoding UTF8
    Write-Host "Created $ImportDir — add GSC CSV export, re-run."
    exit 0
}

$csv = Get-ChildItem $ImportDir -Filter "*.csv" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $csv) {
    Write-Host "No CSV in $ImportDir"
    exit 1
}

$rows = Import-Csv $csv.FullName
$top = $rows | Select-Object -First 20

"# GSC summary — $($csv.Name)" | Set-Content $out -Encoding UTF8
"**Rows:** $($rows.Count)" | Add-Content $out
"**Date:** $(Get-Date -Format o)" | Add-Content $out
"" | Add-Content $out
"## Top rows (preview)" | Add-Content $out
$top | Format-Table -AutoSize | Out-String | Add-Content $out

Write-Host "Summary: $out"
