# Deferred hub refresh — wait for Cursor exit, then heavy cleanup.
# Or run safe cleanup now while Cursor is open: -SafeNow
param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [int]$WaitMinutes = 30,
    [switch]$SafeNow,
    [switch]$SkipCyberLibrary
)

$ErrorActionPreference = "Continue"
$logDir = Join-Path $HubRoot "ai-tracking"
$pendingPath = Join-Path $logDir ".deferred-refresh-pending.json"
$stamp = Get-Date -Format "yyyy-MM-dd-HHmm"
$logPath = Join-Path $logDir ("deferred-refresh-{0}.txt" -f $stamp)
$lines = [System.Collections.Generic.List[string]]::new()

function Write-Log {
    param([string]$Msg)
    $line = "{0} {1}" -f (Get-Date -Format "HH:mm:ss"), $Msg
    [void]$lines.Add($line)
    Write-Host $line
}

function Test-CursorRunning {
    $procs = Get-Process -Name "Cursor","cursor" -ErrorAction SilentlyContinue
    return ($null -ne $procs -and @($procs).Count -gt 0)
}

function Save-Log {
    $lines | Set-Content -Path $logPath -Encoding UTF8
}

New-Item -ItemType Directory -Force -Path $logDir | Out-Null
Write-Log "Deferred refresh started (SafeNow=$SafeNow)"

$safeScript = Join-Path $HubRoot "commands\hub-safe-cleanup.ps1"
if (Test-Path $safeScript) {
    Write-Log "Running hub-safe-cleanup.ps1"
    & $safeScript -HubRoot $HubRoot -Apply 2>&1 | ForEach-Object { Write-Log ("SAFE: {0}" -f $_) }
}
else {
    Write-Log "WARN: hub-safe-cleanup.ps1 missing - skip soft cleanup"
}

if ($SafeNow) {
    Write-Log "SafeNow mode: skip wait and heavy locked cleanup"
    @{
        queuedAt  = (Get-Date).ToUniversalTime().ToString("o")
        reason    = "SafeNow completed; heavy cleanup still pending after Cursor exit"
        waitMins  = $WaitMinutes
    } | ConvertTo-Json | Set-Content -Path $pendingPath -Encoding UTF8
    Write-Log "Pending flag set for full cleanup after Cursor exit"
    Save-Log
    Write-Log ("Done (safe). Log: {0}" -f $logPath)
    exit 0
}

$deadline = (Get-Date).AddMinutes($WaitMinutes)
while ((Get-Date) -lt $deadline) {
    if (-not (Test-CursorRunning)) { break }
    Write-Log "Waiting for Cursor to exit..."
    Start-Sleep -Seconds 5
}

if (Test-CursorRunning) {
    Write-Log ("TIMEOUT: Cursor still running after {0}m - aborting heavy cleanup" -f $WaitMinutes)
    @{
        queuedAt = (Get-Date).ToUniversalTime().ToString("o")
        reason   = "timeout waiting for Cursor exit"
    } | ConvertTo-Json | Set-Content -Path $pendingPath -Encoding UTF8
    Save-Log
    exit 1
}

Write-Log "Cursor not running - full cleanup (cursor-system-cleanup; not cache-auto-sweep)"
$cleanup = Join-Path $HubRoot "commands\cursor-system-cleanup.ps1"
if (Test-Path $cleanup) {
    & $cleanup -Apply -Force -SkipLocked -HubRoot $HubRoot 2>&1 | ForEach-Object { Write-Log ("FULL: {0}" -f $_) }
}
else {
    Write-Log "WARN: cursor-system-cleanup.ps1 missing"
}

if (-not $SkipCyberLibrary) {
    $skillsDir = Join-Path $HubRoot "skills\cybersecurity\library\Anthropic-Cybersecurity-Skills-main\skills"
    $skillCount = 0
    if (Test-Path $skillsDir) {
        $skillCount = @(Get-ChildItem $skillsDir -Directory -ErrorAction SilentlyContinue).Count
    }
    if ($skillCount -lt 700) {
        Write-Log ("Refreshing cybersecurity library ({0} skills)" -f $skillCount)
        $ensure = Join-Path $HubRoot "skills\cybersecurity\scripts\ensure-library.mjs"
        if (Test-Path $ensure) {
            node $ensure --force 2>&1 | ForEach-Object { Write-Log $_ }
        }
    }
}

Write-Log "Post-audit"
$audit = Join-Path $HubRoot "commands\cursor-system-audit.ps1"
if (Test-Path $audit) {
    & $audit -HubRoot $HubRoot 2>&1 | ForEach-Object { Write-Log $_ }
}

if (Test-Path $pendingPath) {
    Remove-Item -LiteralPath $pendingPath -Force -ErrorAction SilentlyContinue
    Write-Log "Cleared pending flag"
}

Save-Log
Write-Log ("Done. Log: {0}" -f $logPath)
exit 0
