# Install current-user Scheduled Tasks for cache-auto-sweep (no admin).
# Default: dry-run only. Pass -Apply after Boss YES on the first report.
param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [switch]$Apply,
    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"
$sweep = Join-Path $HubRoot "commands\cache-auto-sweep.ps1"
if (-not (Test-Path -LiteralPath $sweep)) {
    Write-Error "Missing $sweep"
    exit 1
}

$nightlyName = "CursorHub-CacheAutoSweep-Nightly"
$idleName = "CursorHub-CacheAutoSweep-Idle"

function Remove-SweepTask {
    param([string]$Name)
    $existing = Get-ScheduledTask -TaskName $Name -ErrorAction SilentlyContinue
    if ($existing) {
        Unregister-ScheduledTask -TaskName $Name -Confirm:$false
        Write-Host "Removed task $Name"
    }
}

if ($Uninstall) {
    Remove-SweepTask $nightlyName
    Remove-SweepTask $idleName
    Write-Host "Uninstalled cache-auto-sweep tasks."
    exit 0
}

$applyArg = ""
if ($Apply) { $applyArg = " -Apply" }

$ps = "powershell.exe"
$nightlyArgs = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$sweep`" -HubRoot `"$HubRoot`" -Tier T1$applyArg"
$idleArgs = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$sweep`" -HubRoot `"$HubRoot`" -Tier T0$applyArg"

$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited

Remove-SweepTask $nightlyName
Remove-SweepTask $idleName

$nightlyAction = New-ScheduledTaskAction -Execute $ps -Argument $nightlyArgs -WorkingDirectory $HubRoot
$nightlyTrigger = New-ScheduledTaskTrigger -Daily -At "03:00"
$nightlySettings = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Minutes 20)
Register-ScheduledTask -TaskName $nightlyName -Action $nightlyAction -Trigger $nightlyTrigger -Settings $nightlySettings -Principal $principal -Description "Cursor Hub cache T0+T1 at 03:00. Dry-run unless install -Apply." | Out-Null
Write-Host "Registered $nightlyName (03:00 T1)"

$idleAction = New-ScheduledTaskAction -Execute $ps -Argument $idleArgs -WorkingDirectory $HubRoot
$idleTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(5) -RepetitionInterval (New-TimeSpan -Hours 4) -RepetitionDuration (New-TimeSpan -Days 3650)
$idleSettings = New-ScheduledTaskSettingsSet -RunOnlyIfIdle -IdleDuration (New-TimeSpan -Minutes 10) -IdleWaitTimeout (New-TimeSpan -Hours 2) -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Minutes 5)
Register-ScheduledTask -TaskName $idleName -Action $idleAction -Trigger $idleTrigger -Settings $idleSettings -Principal $principal -Description "Cursor Hub cache T0 when idle. Dry-run unless install -Apply." | Out-Null
Write-Host "Registered $idleName (idle every 4h, T0)"

if ($Apply) {
    Write-Host "Tasks will DELETE (install -Apply). Policy: CACHE-POLICY.md"
}
else {
    Write-Host "Tasks are DRY-RUN. After the first report, re-run with -Apply to enable deletes."
}
exit 0
