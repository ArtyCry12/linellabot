$ErrorActionPreference = "Stop"
$HubRoot = Split-Path $PSScriptRoot -Parent
$fail = 0

$required = @(
    "lib/crew-ai/Expand-CrewPlan.ps1",
    "lib/crew-ai/crews/marketing-crew.json",
    "lib/crew-ai/crews/production-crew.json",
    "skills/crew-ai/SKILL.md",
    "rules/crew-ai.mdc",
    "commands/crew-plan.ps1"
)

foreach ($p in $required) {
    if (-not (Test-Path (Join-Path $HubRoot $p))) {
        Write-Host "FAIL missing $p"
        $fail++
    }
}

. (Join-Path $HubRoot "lib/crew-ai/Expand-CrewPlan.ps1")

$m = Expand-CrewPlan -CrewId "marketing-crew" -Variables @{ topic = "test" } -HubRoot $HubRoot
if ($m.Tasks.Count -ne 4) {
    Write-Host "FAIL marketing crew expected 4 tasks got $($m.Tasks.Count)"
    $fail++
}

$p = Expand-CrewPlan -CrewId "production-crew" -Variables @{ project = "reel" } -HubRoot $HubRoot
if ($p.Tasks.Count -ne 4) {
    Write-Host "FAIL production crew expected 4 tasks got $($p.Tasks.Count)"
    $fail++
}

if ($fail -gt 0) {
    Write-Host "FAILED $fail"
    exit 1
}

Write-Host "OK crew-ai test passed"
