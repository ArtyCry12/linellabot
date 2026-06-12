# Deferred hub refresh — runs after Cursor exits (heavy cleanup)
param(
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [int]$WaitMinutes = 30
)

$ErrorActionPreference = "Continue"
$logDir = Join-Path $HubRoot "ai-tracking"
$pendingPath = Join-Path $logDir ".deferred-refresh-pending.json"
$logPath = Join-Path $logDir ("deferred-refresh-{0}.txt" -f (Get-Date -Format "yyyy-MM-dd-HHmm"))
$lines = [System.Collections.Generic.List[string]]::new()

function Log {
    param([string]$Msg)
    $line = "$(Get-Date -Format 'HH:mm:ss') $Msg"
    $lines.Add($line) | Out-Null
    Write-Host $line
}

function Test-CursorRunning {
    $names = @('Cursor', 'cursor')
    foreach ($n in $names) {
        if (Get-Process -Name $n -ErrorAction SilentlyContinue) { return $true }
    }
    return $false
}

New-Item -ItemType Directory -Force -Path $logDir | Out-Null
Log "Deferred refresh started"

$deadline = (Get-Date).AddMinutes($WaitMinutes)
while ((Get-Date) -lt $deadline) {
    if (-not (Test-CursorRunning)) { break }
    Log "Waiting for Cursor to exit..."
    Start-Sleep -Seconds 5
}

if (Test-CursorRunning) {
    Log "TIMEOUT: Cursor still running after ${WaitMinutes}m — aborting heavy cleanup"
    $lines | Set-Content -Path $logPath -Encoding UTF8
    exit 1
}

Log "Cursor not running — full cleanup"
$cleanup = Join-Path $HubRoot "commands\cursor-system-cleanup.ps1"
& $cleanup -Apply -Force -HubRoot $HubRoot 2>&1 | ForEach-Object { Log $_ }

# Cybersecurity library if incomplete
$skillsDir = Join-Path $HubRoot "skills\cybersecurity\library\Anthropic-Cybersecurity-Skills-main\skills"
$skillCount = 0
if (Test-Path $skillsDir) {
    $skillCount = (Get-ChildItem $skillsDir -Directory -ErrorAction SilentlyContinue).Count
}
if ($skillCount -lt 700) {
    Log "Refreshing cybersecurity library ($skillCount skills)"
    $ensure = Join-Path $HubRoot "skills\cybersecurity\scripts\ensure-library.mjs"
    node $ensure --force 2>&1 | ForEach-Object { Log $_ }
}

Log "Post-audit"
$audit = Join-Path $HubRoot "commands\cursor-system-audit.ps1"
& $audit -HubRoot $HubRoot 2>&1 | ForEach-Object { Log $_ }

if (Test-Path $pendingPath) {
    Remove-Item -LiteralPath $pendingPath -Force -ErrorAction SilentlyContinue
    Log "Cleared pending flag"
}

$lines | Set-Content -Path $logPath -Encoding UTF8
Log "Done. Log: $logPath"
