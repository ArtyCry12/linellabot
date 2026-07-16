# Ingest quiz JSON from chat, clipboard file, or inbox folder.
# Usage:
#   !quiz-ingest  (paste JSON in chat; agent runs this)
#   powershell -File commands/quiz-ingest.ps1 -JsonPath path\to\payload.json
#   powershell -File commands/quiz-ingest.ps1 -ScanInbox

param(
    [string]$Json,
    [string]$JsonPath,
    [switch]$ScanInbox
)

$ErrorActionPreference = "Stop"
$HubRoot = Split-Path $PSScriptRoot -Parent
. (Join-Path $HubRoot "lib/quiz-channel/QuizChannel.ps1")

if ($ScanInbox) {
    $pending = Get-QuizInboxPending -HubRoot $HubRoot
    if ($pending.Count -eq 0) {
        Write-Output "OK: inbox empty"
        exit 0
    }
    foreach ($f in $pending) {
        $raw = Get-Content $f.FullName -Raw
        $obj = $raw | ConvertFrom-Json
        $obj | Add-Member -NotePropertyName "_inboxFile" -NotePropertyValue $f.FullName -Force
        $r = Invoke-QuizIngest -Payload $obj -HubRoot $HubRoot -FromInbox
        Write-Output "OK: ingested $($f.Name) quiz=$($r.Quiz) id=$($r.RecordId)"
    }
    exit 0
}

if ($JsonPath) {
    if (-not (Test-Path $JsonPath)) {
        Write-Error "File not found: $JsonPath"
        exit 1
    }
    $Json = Get-Content $JsonPath -Raw
}

if (-not $Json) {
    Write-Output @"
Quiz ingest — no JSON provided.

Ways to submit from ecosystem-audit canvas:
1. Copy JSON from canvas export field
2. In chat: !quiz-ingest + paste JSON block
3. Save JSON to ai-tracking/user-profile/inbox/*.json then:
   powershell -File commands/quiz-ingest.ps1 -ScanInbox

Stored at:
  ai-tracking/user-profile/quiz-responses.jsonl
  ai-tracking/user-profile/profile.json
"@
    exit 0
}

$result = Invoke-QuizIngest -Payload $Json -HubRoot $HubRoot
Write-Output "OK: quiz=$($result.Quiz) record=$($result.RecordId)"
Write-Output "jsonl: $($result.Jsonl)"
Write-Output "profile: $($result.Profile)"
