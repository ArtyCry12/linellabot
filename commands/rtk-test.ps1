param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"
$fail = 0

function Fail([string]$Msg) {
    Write-Host "FAIL $Msg" -ForegroundColor Red
    $script:fail++
}

Write-Host "=== RTK token economy test ===" -ForegroundColor Cyan

. (Join-Path $HubRoot "lib\rtk\Rtk.ps1")
$paths = Get-RtkPaths -HubRoot $HubRoot

if (Test-RtkInstalled -HubRoot $HubRoot) {
    Write-Host "OK  rtk.exe installed ($($paths.ExePath))" -ForegroundColor Green
} else {
    Fail "rtk.exe not found"
}

if (Test-Path $paths.HookScript) {
    Write-Host "OK  rtk-cursor-hook.ps1" -ForegroundColor Green
} else {
    Fail "rtk-cursor-hook.ps1 missing"
}

if (Test-RtkCursorHook -HubRoot $HubRoot) {
    Write-Host "OK  hooks.json preToolUse Shell" -ForegroundColor Green
} else {
    Fail "hooks.json missing RTK preToolUse hook"
}

$hj = Get-Content $paths.HooksPath -Raw | ConvertFrom-Json
$beforeCount = @($hj.hooks.beforeSubmitPrompt).Count
if ($beforeCount -ge 5) {
    Write-Host "OK  beforeSubmitPrompt chain ($beforeCount hooks)" -ForegroundColor Green
} else {
    Fail "beforeSubmitPrompt chain too short ($beforeCount)"
}

if (Test-Path $paths.HealthPath) {
    Write-Host "OK  rtk-health.json" -ForegroundColor Green
} else {
    Fail "rtk-health.json missing - run ensure-rtk.ps1"
}

$countPy = Join-Path $HubRoot "lib\prompt-coach\count_tokens.py"
if (Test-Path $countPy) {
    $py = Join-Path $HubRoot ".venv-markitdown\Scripts\python.exe"
    if (Test-Path $py) {
        $out = & $py $countPy "hello world" 2>&1
        if ($out -match '^\d+$') {
            Write-Host "OK  count_tokens.py -> $out tokens" -ForegroundColor Green
        } else {
            Fail "count_tokens.py output invalid: $out"
        }
    } else {
        Write-Host "WARN count_tokens.py present but venv missing" -ForegroundColor Yellow
    }
} else {
    Fail "count_tokens.py missing"
}

Write-Host ""
if ($fail -eq 0) {
    Write-Host "Summary: ALL PASSED" -ForegroundColor Green
    exit 0
}
Write-Host "Summary: $fail FAIL" -ForegroundColor Red
exit 1
