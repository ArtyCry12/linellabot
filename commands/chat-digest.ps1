# Chat session digest (no hooks.json).
# Writes short markdown under ai-tracking/chat-digests/ — not full transcripts.
param(
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [string]$Title = "",
    [string]$Summary = "",
    [string[]]$Done = @(),
    [string[]]$Open = @(),
    [string[]]$Commits = @()
)

$ErrorActionPreference = "Stop"
$dir = Join-Path $HubRoot "ai-tracking\chat-digests"
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$stamp = Get-Date -Format "yyyy-MM-dd-HHmm"
$path = Join-Path $dir "digest-$stamp.md"

if (-not $Title) { $Title = "Session digest $stamp" }

$doneLines = if ($Done.Count) { ($Done | ForEach-Object { "- $_" }) -join "`n" } else { "- (none listed)" }
$openLines = if ($Open.Count) { ($Open | ForEach-Object { "- $_" }) -join "`n" } else { "- (none listed)" }
$commitLines = if ($Commits.Count) {
    ($Commits | ForEach-Object { "- ``$_``" }) -join "`n"
} else {
    try {
        $log = @(git -C $HubRoot log -8 --oneline 2>$null)
        if ($log) { ($log | ForEach-Object { "- ``$_``" }) -join "`n" } else { "- (git unavailable)" }
    } catch { "- (git unavailable)" }
}

$when = Get-Date -Format "yyyy-MM-dd HH:mm"
$body = @"
# $Title

**When:** $when (local)

## Summary

$Summary

## Done

$doneLines

## Open

$openLines

## Recent commits

$commitLines

## Notes

- Full transcripts stay in Cursor agent-transcripts (not copied here).
- Reload context: read this file instead of re-reading the whole chat.
"@

Set-Content -LiteralPath $path -Value $body -Encoding UTF8
Write-Host "Wrote $path"
Write-Output $path
