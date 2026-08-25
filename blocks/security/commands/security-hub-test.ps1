# Smoke test Security Hub + Ponytail wiring
param(
    [string]$HubRoot = ""
)

$ErrorActionPreference = "Stop"
if (-not $HubRoot) { $HubRoot = Split-Path $PSScriptRoot -Parent }

$failed = 0
function Ok([string]$Msg) { Write-Host "OK  $Msg" }
function Fail([string]$Msg) { Write-Host "FAIL $Msg"; $script:failed++ }

$required = @(
    "rules\ponytail.mdc",
    "skills\ponytail\SKILL.md",
    "skills\ponytail-review\SKILL.md",
    "skills\ponytail-audit\SKILL.md",
    "skills\ponytail-debt\SKILL.md",
    "skills\security-hub\SKILL.md",
    "skills\security-hub\tool-matrix.json",
    "skills\security-hub\findings.schema.json",
    "skills\security-hub\references\auth-gate.md",
    "skills\security-hub\prompts\audit.md",
    "skills\security-hub\prompts\false-positive-filter.md",
    "commands\ponytail-status.ps1",
    "commands\ensure-security-tools.ps1",
    "commands\security-scan.ps1",
    "commands\security-dast.ps1",
    "commands\security-recon.ps1",
    "templates\security-ci\README.md",
    "templates\security-ci\security-secrets.yml",
    "templates\security-ci\security-sast.yml",
    "templates\security-ci\security-sca.yml",
    "templates\security-ci\security-iac.yml",
    "templates\security-ci\security-dast.yml",
    "templates\security-ci\security-ai-review.yml"
)

foreach ($rel in $required) {
    $p = Join-Path $HubRoot $rel
    if (Test-Path $p) { Ok $rel } else { Fail "missing $rel" }
}

$routes = Get-Content (Join-Path $HubRoot "lib\task-router\routes.json") -Raw
if ($routes -match '"id":\s*"ponytail"' -and $routes -match '"id":\s*"security-hub"') {
    Ok "routes.json ponytail + security-hub"
} else {
    Fail "routes.json missing ponytail or security-hub"
}

# Auth gate: dast without -Authorized must fail
$scan = Join-Path $HubRoot "commands\security-scan.ps1"
$prev = $ErrorActionPreference
$ErrorActionPreference = "Continue"
& powershell -NoProfile -File $scan -Tier dast -TargetUrl "https://example.com" 2>&1 | Out-Null
$code = $LASTEXITCODE
$ErrorActionPreference = $prev
if ($code -eq 2) { Ok "dast refused without -Authorized (exit 2)" } else { Fail "dast gate expected exit 2, got $code" }

& powershell -NoProfile -File $scan -Tier recon -TargetHost "example.com" 2>&1 | Out-Null
$code2 = $LASTEXITCODE
if ($code2 -eq 2) { Ok "recon refused without -Authorized (exit 2)" } else { Fail "recon gate expected exit 2, got $code2" }

& powershell -NoProfile -File (Join-Path $HubRoot "commands\ensure-security-tools.ps1") -HubRoot $HubRoot | Out-Null
$health = Join-Path $HubRoot "ai-tracking\security-tools-health.json"
if (Test-Path $health) { Ok "security-tools-health.json written" } else { Fail "health json missing" }

& powershell -NoProfile -File (Join-Path $HubRoot "commands\ponytail-status.ps1") -HubRoot $HubRoot | Out-Null
if ($LASTEXITCODE -eq 0) { Ok "ponytail-status" } else { Fail "ponytail-status exit $LASTEXITCODE" }

# secrets tier should not crash (may exit 3 if tools missing)
& powershell -NoProfile -File $scan -Tier secrets -Path $HubRoot -HubRoot $HubRoot 2>&1 | Out-Null
if ($LASTEXITCODE -in 0, 3) { Ok "secrets tier ran (exit $LASTEXITCODE)" } else { Fail "secrets tier unexpected exit $LASTEXITCODE" }

if ($failed -gt 0) {
    Write-Host "FAILED $failed checks"
    exit 1
}
Write-Host "ALL PASS"
exit 0
