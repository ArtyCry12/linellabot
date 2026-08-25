# n8n templates index test
param([string]$HubRoot = "")

$ErrorActionPreference = "Stop"
if (-not $HubRoot) { $HubRoot = Split-Path $PSScriptRoot -Parent }

$fail = 0
function Assert([bool]$Cond, [string]$Msg) {
    if ($Cond) { Write-Host "OK: $Msg" -ForegroundColor Green }
    else { Write-Host "FAIL: $Msg" -ForegroundColor Red; $script:fail++ }
}

Write-Host "=== n8n-templates-test ===" -ForegroundColor Cyan

$indexPath = Join-Path $HubRoot "lib\n8n-templates\template-index.json"
if (-not (Test-Path $indexPath)) {
    & (Join-Path $HubRoot "commands\build-n8n-templates-index.ps1") -HubRoot $HubRoot | Out-Host
}

Assert (Test-Path $indexPath) "template-index.json exists"
$data = Get-Content $indexPath -Raw | ConvertFrom-Json
Assert ($data.total -gt 50) "index has templates (total=$($data.total))"

. (Join-Path $HubRoot "lib\n8n-templates\Match-N8nTemplate.ps1")
$r = Find-N8nTemplates -Query "telegram AI bot" -Top 3 -HubRoot $HubRoot
Assert ($r.Ok -and $r.Matches.Count -ge 1) "match telegram AI bot"

if ($r.Matches.Count -gt 0) {
    $t = Get-N8nTemplateById -Id $r.Matches[0].Id -HubRoot $HubRoot
    Assert ($null -ne $t -and $t.Json.Length -gt 100) "load template by id"
}

if ($fail -eq 0) {
    Write-Host "ALL PASSED" -ForegroundColor Green
    exit 0
}
Write-Host "FAILED: $fail" -ForegroundColor Red
exit 1
