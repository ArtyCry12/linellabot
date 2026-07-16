param(
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [switch]$Quick
)

$ErrorActionPreference = "Stop"
Write-Host "=== Hub gate - all *-test.ps1 ===" -ForegroundColor Cyan

$tests = Get-ChildItem (Join-Path $HubRoot "commands\*-test.ps1") | Sort-Object Name
if ($Quick) {
    $tests = $tests | Where-Object { $_.Name -match 'personalization|task-router|markitdown|hub-learning' }
}

$results = @()
$fail = 0
foreach ($t in $tests) {
    Write-Host ""
    Write-Host "--- $($t.Name) ---" -ForegroundColor DarkCyan
    & $t.FullName -HubRoot $HubRoot
    $code = $LASTEXITCODE
    $results += [PSCustomObject]@{ test = $t.Name; exit = $code }
    if ($code -ne 0) { $fail++ }
}

Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Cyan
$results | Format-Table -AutoSize
if ($fail -eq 0) {
    Write-Host "HUB GATE: PASS" -ForegroundColor Green
    exit 0
}
Write-Host "HUB GATE: $fail failed" -ForegroundColor Red
exit 1
