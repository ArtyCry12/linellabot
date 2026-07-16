# Verify Claude plugin -> Cursor hub bridge (skills + routes)
$ErrorActionPreference = 'Stop'
$root = (Join-Path $PSScriptRoot '..') | Resolve-Path
$skills = Join-Path $root 'skills'
$routes = Join-Path (Join-Path $root 'lib') 'task-router\routes.json'

$requiredSkills = @(
    'brainstorming',
    'systematic-debugging',
    'subagent-driven-development',
    'verification-before-completion',
    'frontend-design',
    'pr-review',
    'writing-plans'
)

$fail = 0
foreach ($name in $requiredSkills) {
    $p = Join-Path (Join-Path $skills $name) 'SKILL.md'
    if (Test-Path $p) { Write-Host "PASS skill $name" }
    else { Write-Host "FAIL skill $name"; $fail++ }
}

$json = Get-Content $routes -Raw | ConvertFrom-Json
$routeIds = @('coding-discipline', 'frontend-design-web', 'pr-review', 'automation-audit')
foreach ($id in $routeIds) {
    $r = $json.routes | Where-Object { $_.id -eq $id }
    if ($r) { Write-Host "PASS route $id" }
    else { Write-Host "FAIL route $id"; $fail++ }
}

$scout = Join-Path (Join-Path $root 'agents') 'squad-scout.md'
$scoutText = Get-Content $scout -Raw
if ($scoutText -match 'automation audit|recommend automations') { Write-Host 'PASS squad-scout audit' }
else { Write-Host 'FAIL squad-scout audit section'; $fail++ }

if ($fail -gt 0) { Write-Host "FAIL count: $fail"; exit 1 }
Write-Host 'claude-plugins-bridge-test: PASS'
