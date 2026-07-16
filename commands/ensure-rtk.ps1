# Ensure RTK binary + safe Cursor preToolUse hook merge
param(
    [string]$HubRoot = "",
    [switch]$SkipHook,
    [switch]$ForceHook
)

$ErrorActionPreference = "Stop"
if (-not $HubRoot) { $HubRoot = Split-Path $PSScriptRoot -Parent }

. (Join-Path $HubRoot "lib\rtk\Rtk.ps1")
$paths = Get-RtkPaths -HubRoot $HubRoot
$log = @()

function Log([string]$Msg) {
    $script:log += "$(Get-Date -Format 'HH:mm:ss') $Msg"
    Write-Host $Msg
}

if (-not (Test-RtkInstalled -HubRoot $HubRoot)) {
    Log "RTK binary missing - installing..."
    if (-not (Test-Path $paths.InstallScript)) {
        throw "install-rtk-binary.ps1 not found"
    }
    & $paths.InstallScript
    if ($LASTEXITCODE -ne 0) { throw "install-rtk-binary failed" }
}

if (-not (Test-RtkInstalled -HubRoot $HubRoot)) {
    throw "RTK still not installed after install script"
}
Log "OK: $($paths.ExePath)"

$hookScript = $paths.HookScript
if (-not (Test-Path $hookScript)) {
    throw "Missing hook wrapper: $hookScript"
}
Log "OK: rtk-cursor-hook.ps1"

$hookMerged = $false
$hookMsg = "skipped"
if (-not $SkipHook) {
    $merge = Merge-RtkCursorHook -HubRoot $HubRoot -Force:$ForceHook
    $hookMerged = $merge.Changed
    $hookMsg = $merge.Message
    Log $hookMsg
    if ($merge.Backup) { Log "Backup: $($merge.Backup)" }
}

$hookOk = Test-RtkCursorHook -HubRoot $HubRoot

# tiktoken for prompt-coach (reuse markitdown venv)
$tiktokenOk = $false
$mdVenv = Join-Path $HubRoot ".venv-markitdown\Scripts\python.exe"
if (Test-Path $mdVenv) {
    Log "Ensuring tiktoken in markitdown venv..."
    $uv = Get-Command uv -ErrorAction SilentlyContinue
    if (-not $uv) {
        $uvCandidate = Join-Path $env:APPDATA "Python\Python38\Scripts\uv.exe"
        if (Test-Path $uvCandidate) { $uv = Get-Command $uvCandidate }
    }
    if ($uv) {
        $prev = $ErrorActionPreference
        $ErrorActionPreference = "Continue"
        & uv pip install tiktoken --python $mdVenv -q 2>&1 | Out-Null
        & $mdVenv -c "import tiktoken; print('ok')" 2>&1 | Out-Null
        $tiktokenOk = ($LASTEXITCODE -eq 0)
        $ErrorActionPreference = $prev
    }
    if ($tiktokenOk) { Log "OK: tiktoken" } else { Log "WARN: tiktoken install failed" }
}

$health = [ordered]@{
    checkedAt    = (Get-Date).ToUniversalTime().ToString("o")
    version      = Get-RtkVersion -HubRoot $HubRoot
    exePath      = $paths.ExePath
    hookPresent  = $hookOk
    hookMerged   = $hookMerged
    hookMessage  = $hookMsg
    tiktokenOk   = $tiktokenOk
    log          = $log
}
$dir = Split-Path $paths.HealthPath -Parent
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
($health | ConvertTo-Json -Depth 5) | Set-Content -Path $paths.HealthPath -Encoding UTF8

Write-Output "Health: $($paths.HealthPath)"
if (-not $health.hookPresent -and -not $SkipHook) { exit 1 }
exit 0
