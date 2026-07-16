param(
    [string]$HubRoot = "C:\Users\Asus\.cursor"
)

$ErrorActionPreference = "Stop"
$fail = 0

function Assert($c, $m) {
    if ($c) { Write-Host "OK: $m" -ForegroundColor Green }
    else { Write-Host "FAIL: $m" -ForegroundColor Red; $script:fail++ }
}

Write-Host "=== Hooks token budget test ===" -ForegroundColor Cyan

. (Join-Path $HubRoot "lib\user-profile\UserProfile.ps1")
# Force first inject
$stamp = Join-Path $HubRoot "ai-tracking\user-profile\.last-inject"
if (Test-Path $stamp) { Remove-Item $stamp -Force }

$ctx = Format-UserProfileContext -HubRoot $HubRoot -Force
Assert ($ctx.Length -gt 0) "profile injects"
Assert ($ctx.Length -lt 500) "profile under 500 chars ($($ctx.Length))"

$ctx2 = Format-UserProfileContext -HubRoot $HubRoot
Assert ([string]::IsNullOrEmpty($ctx2)) "profile throttled within window"

. (Join-Path $HubRoot "lib\task-router\Resolve-TaskRoute.ps1")
$r = Resolve-TaskRoute -Prompt "check seo for okara.ai site" -HubRoot $HubRoot
$fmt = Format-TaskRouteContext -ResolveResult $r
Assert ($fmt.Length -lt 400) "router context under 400 chars ($($fmt.Length))"
Assert ($fmt -notmatch 'Registry: SYSTEM-REGISTRY') "router no registry footer"

$stop = Get-Content (Join-Path $HubRoot "hooks\prompt-coach-stop.ps1") -Raw
Assert ($stop.Length -lt 1200) "coach stop script compact"

Write-Host ""
if ($fail -eq 0) { Write-Host "HOOKS TOKEN: PASS"; exit 0 }
Write-Host "HOOKS TOKEN: $fail FAIL"; exit 1
