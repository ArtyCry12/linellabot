# Test find-skills hub wiring (Session 1)

$ErrorActionPreference = "Stop"
$HubRoot = Split-Path $PSScriptRoot -Parent
$fail = 0

$paths = @(
    "skills/find-skills/SKILL.md",
    "rules/find-skills.mdc",
    "commands/find-skills.ps1",
    ".agents/skills/find-skills/SKILL.md"
)

foreach ($p in $paths) {
    $full = Join-Path $HubRoot $p
    if (-not (Test-Path -LiteralPath $full)) {
        Write-Host "FAIL missing $p"
        $fail++
    }
    else {
        Write-Host "OK $p"
    }
}

$routes = Join-Path $HubRoot "lib/task-router/routes.json"
$routesText = Get-Content -LiteralPath $routes -Raw -Encoding UTF8
if ($routesText -notmatch '"id"\s*:\s*"find-skills"') {
    Write-Host "FAIL routes.json missing find-skills id"
    $fail++
}
else {
    Write-Host "OK routes.json has find-skills"
}

. (Join-Path $HubRoot "lib/task-router/Resolve-TaskRoute.ps1")
$r = Resolve-TaskRoute -Prompt "find skill for react performance on skills.sh" -HubRoot $HubRoot
$top = if ($r.Matches.Count -gt 0) { $r.Matches[0].Id } else { "(none)" }
if ($top -ne "find-skills") {
    Write-Host "FAIL route expected find-skills, got $top"
    $fail++
}
else {
    Write-Host "OK route -> find-skills score=$($r.Matches[0].Score)"
}

Write-Host "Smoke: npx skills find seo"
$cliOut = & npx.cmd skills find "seo" 2>&1 | Out-String
$len = 0
if ($cliOut) { $len = $cliOut.Length }
if ($LASTEXITCODE -ne 0 -and [string]::IsNullOrWhiteSpace($cliOut)) {
    Write-Host "WARN npx skills find failed - wiring still OK"
}
else {
    Write-Host "OK npx skills find output length=$len"
}

if ($fail -gt 0) {
    Write-Host "FAILED checks=$fail"
    exit 1
}

Write-Host "OK find-skills test passed"
exit 0
