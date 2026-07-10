param(
    [Parameter(Mandatory = $true)][string]$Url,
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [ValidateSet("mobile", "desktop")][string]$Strategy = "mobile",
    [switch]$SkipLighthouse,
    [switch]$SkipPageSpeed
)

$ErrorActionPreference = "Stop"
$ts = Get-Date -Format "yyyy-MM-ddTHH-mm-ss"
$outDir = Join-Path $HubRoot "ai-tracking\seo-runs"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$report = Join-Path $outDir "audit-$ts.md"

"# SEO audit — $Url`n" | Set-Content $report -Encoding UTF8
"**Date:** $(Get-Date -Format o)`n" | Add-Content $report

if (-not $SkipPageSpeed) {
    Write-Host "PageSpeed ($Strategy)..."
    & (Join-Path $HubRoot "commands\pagespeed-audit.ps1") -Url $Url -HubRoot $HubRoot -Strategy $Strategy
    $psi = Get-Content (Join-Path $HubRoot "ai-tracking\pagespeed-last.json") -Raw | ConvertFrom-Json
    $perf = [math]::Round($psi.lighthouseResult.categories.performance.score * 100)
    "`n## PageSpeed ($Strategy)`n- Performance: **$perf**`n" | Add-Content $report
}

if (-not $SkipLighthouse) {
    Write-Host "Lighthouse CLI..."
    $lhJson = Join-Path $outDir "lighthouse-$ts.json"
    $lhHtml = Join-Path $outDir "lighthouse-$ts.html"
    npx --yes lighthouse $Url --output=json --output-path=$lhJson --quiet --chrome-flags="--headless" 2>&1 | Out-Null
    if (Test-Path $lhJson) {
        $lh = Get-Content $lhJson -Raw | ConvertFrom-Json
        $cats = $lh.categories
        "`n## Lighthouse`n" | Add-Content $report
        foreach ($name in @("performance","accessibility","best-practices","seo")) {
            if ($cats.$name) {
                $s = [math]::Round($cats.$name.score * 100)
                "- $($name): **$s**" | Add-Content $report
            }
        }
        "``nRaw: ``$lhJson``" | Add-Content $report
    } else {
        "`n## Lighthouse`n- Skipped or failed (Chrome required)`n" | Add-Content $report
    }
}

Write-Host "Report: $report"
