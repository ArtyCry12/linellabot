param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [switch]$Json
)

$ErrorActionPreference = "Stop"
$axesPath = Join-Path $HubRoot "lib\hub-benchmark\axes.json"
$axes = Get-Content $axesPath -Raw -Encoding UTF8 | ConvertFrom-Json

$before = [ordered]@{
    capturedAt = "2026-07-13T12:00:00Z"
    phase      = "before-C-D-E"
    categories = $axes.labelsRu
    now        = $axes.beforeNow
    target     = $axes.target
}

$tests = @(Get-ChildItem (Join-Path $HubRoot "commands\*-test.ps1") -ErrorAction SilentlyContinue).Count

$after = [ordered]@{
    capturedAt = (Get-Date).ToUniversalTime().ToString("o")
    phase      = "after-C-D-E"
    categories = $axes.labelsRu
    now        = $axes.afterNow
    target     = $axes.target
    signals    = [ordered]@{
        testScripts         = $tests
        userProfileRule     = (Test-Path (Join-Path $HubRoot "rules\user-profile.mdc"))
        mcpHealth           = (Test-Path (Join-Path $HubRoot "commands\mcp-health.ps1"))
        hubGate             = (Test-Path (Join-Path $HubRoot "commands\hub-gate.ps1"))
        personalizationTest = (Test-Path (Join-Path $HubRoot "commands\personalization-test.ps1"))
    }
}

$beforePath = Join-Path $HubRoot "ai-tracking\benchmark-snapshot-before.json"
$afterPath  = Join-Path $HubRoot "ai-tracking\benchmark-snapshot-after.json"

if (-not (Test-Path $beforePath)) {
    $before | ConvertTo-Json -Depth 5 | Set-Content $beforePath -Encoding UTF8
}
$after | ConvertTo-Json -Depth 5 | Set-Content $afterPath -Encoding UTF8

if ($Json) {
    @{ before = $before; after = $after } | ConvertTo-Json -Depth 6
    exit 0
}

Write-Host "=== Hub benchmark ===" -ForegroundColor Cyan
for ($i = 0; $i -lt $axes.labelsRu.Count; $i++) {
    Write-Host ("{0,-18} {1} -> {2}" -f $axes.labelsRu[$i], $axes.beforeNow[$i], $axes.afterNow[$i])
}
Write-Host "Snapshots: $beforePath , $afterPath"
exit 0
