# Cursor hub refresh orchestrator — safe now + deferred heavy cleanup
param(
    [switch]$Quick,
    [switch]$Deferred,
    [switch]$SkipCyber,
    [switch]$NoDeferredQueue,
    [string]$HubRoot = "C:\Users\Asus\.cursor"
)

$ErrorActionPreference = "Continue"
$commands = Join-Path $HubRoot "commands"
$logDir = Join-Path $HubRoot "ai-tracking"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

function Invoke-Step {
    param([string]$Label, [scriptblock]$Action)
    Write-Host ""
    Write-Host "=== $Label ==="
    & $Action
    if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
        Write-Host "WARN: $Label exited with code $LASTEXITCODE"
    }
}

if ($Deferred) {
    $deferred = Join-Path $commands "cursor-system-refresh-deferred.ps1"
    & $deferred -HubRoot $HubRoot
    exit $LASTEXITCODE
}

Write-Host "=== Cursor system refresh ==="
Write-Host "Hub: $HubRoot"

Invoke-Step "Pre-audit" {
    & (Join-Path $commands "cursor-system-audit.ps1") -HubRoot $HubRoot
}

if (-not $Quick) {
    if (-not $SkipCyber) {
        Invoke-Step "Cybersecurity library" {
            node (Join-Path $HubRoot "skills\cybersecurity\scripts\ensure-library.mjs")
        }
    }
}

Invoke-Step "Sync workspace rules" {
    python (Join-Path $commands "huashu-sync-workspace-rules.py")
}

Invoke-Step "Skill index" {
    node (Join-Path $commands "generate-skill-index.mjs")
}

if (-not $Quick) {
    Invoke-Step "Cleanup (unlocked only)" {
        & (Join-Path $commands "cursor-system-cleanup.ps1") -Apply -SkipLocked -HubRoot $HubRoot
    }
}

Invoke-Step "Post-audit" {
    & (Join-Path $commands "cursor-system-audit.ps1") -HubRoot $HubRoot
}

if (-not $Quick -and -not $NoDeferredQueue) {
    $pendingPath = Join-Path $logDir ".deferred-refresh-pending.json"
    $state = @{
        queuedAt = (Get-Date).ToString("o")
        reason   = "heavy cleanup after Cursor exit (extensions, locked repos)"
    } | ConvertTo-Json
    Set-Content -Path $pendingPath -Value $state -Encoding UTF8

    $deferredScript = Join-Path $commands "cursor-system-refresh-deferred.ps1"
    $argList = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$deferredScript`" -HubRoot `"$HubRoot`""
    Start-Process -FilePath "powershell.exe" -ArgumentList $argList -WorkingDirectory $HubRoot
    Write-Host ""
    Write-Host "Deferred cleanup queued (runs after Cursor closes)."
    Write-Host "Pending: $pendingPath"
}

Write-Host ""
Write-Host "Refresh complete."
