param(
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [int]$PollSeconds = 15,
    [int]$MaxMinutes = 30
)

$log = Join-Path $HubRoot "ai-tracking\okara-login-watch.log"
$done = Join-Path $HubRoot "ai-tracking\.okara-ready.flag"

if (Test-Path $done) { Remove-Item $done -Force }

Write-Host "Waiting for okara.ai login in Cursor browser side panel..."
Write-Host "Log: $log"

$deadline = (Get-Date).AddMinutes($MaxMinutes)
while ((Get-Date) -lt $deadline) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content $log "$ts polling - complete Google sign-in in side browser"
    Start-Sleep -Seconds $PollSeconds
}

Add-Content $log "$(Get-Date -Format o) timeout - agent should snapshot manually"
