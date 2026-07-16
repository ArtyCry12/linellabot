# Quiz channel — ingest quiz payloads from canvas or chat into hub storage.
# Used by commands/quiz-ingest.ps1

function Read-ProfileHashtable {
    param([string]$Path)
    $ht = @{}
    if (-not (Test-Path $Path)) { return $ht }
    $raw = Get-Content $Path -Raw -ErrorAction SilentlyContinue
    if ([string]::IsNullOrWhiteSpace($raw)) { return $ht }
    $obj = $raw | ConvertFrom-Json
    if ($null -eq $obj) { return $ht }
    foreach ($prop in $obj.PSObject.Properties) {
        $ht[$prop.Name] = $prop.Value
    }
    return $ht
}

function Get-QuizChannelRoot {
    param([string]$HubRoot = $null)
    if (-not $HubRoot) {
        $HubRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
        if (-not (Test-Path (Join-Path $HubRoot "hooks.json"))) {
            $HubRoot = "C:\Users\Asus\.cursor"
        }
    }
    return $HubRoot
}

function Initialize-QuizChannel {
    param([string]$HubRoot)
    $dirs = @(
        "ai-tracking/user-profile",
        "ai-tracking/user-profile/inbox"
    )
    foreach ($d in $dirs) {
        $p = Join-Path $HubRoot $d
        if (-not (Test-Path $p)) {
            New-Item -ItemType Directory -Path $p -Force | Out-Null
        }
    }
}

function Invoke-QuizIngest {
    param(
        [Parameter(Mandatory = $true)]
        [object]$Payload,
        [string]$HubRoot = $null,
        [switch]$FromInbox
    )

    $HubRoot = Get-QuizChannelRoot -HubRoot $HubRoot
    Initialize-QuizChannel -HubRoot $HubRoot

    if ($Payload -is [string]) {
        $Payload = $Payload | ConvertFrom-Json
    }

    $quizId = $Payload.quiz
    if (-not $quizId) {
        throw "Payload missing 'quiz' field (profile | fixes | automation)"
    }

    $record = [ordered]@{
        id        = [guid]::NewGuid().ToString()
        quiz      = $quizId
        timestamp = if ($Payload.timestamp) { $Payload.timestamp } else { (Get-Date).ToUniversalTime().ToString("o") }
        source    = if ($Payload.source) { $Payload.source } else { "canvas" }
        answers   = $Payload.answers
    }

    $jsonl = Join-Path $HubRoot "ai-tracking/user-profile/quiz-responses.jsonl"
    ($record | ConvertTo-Json -Compress -Depth 10) | Add-Content -Path $jsonl -Encoding UTF8

    $profilePath = Join-Path $HubRoot "ai-tracking/user-profile/profile.json"
    $profile = Read-ProfileHashtable -Path $profilePath

    if ($quizId -eq "profile") {
        $profile["entrepreneur"] = $Payload.answers
        $profile["profileUpdatedAt"] = $record.timestamp
    }
    elseif ($quizId -eq "fixes") {
        if (-not $profile["systemFixes"]) { $profile["systemFixes"] = @() }
        $profile["systemFixes"] += $Payload.answers
        $profile["fixesUpdatedAt"] = $record.timestamp
    }
    elseif ($quizId -eq "automation") {
        $profile["automationPrefs"] = $Payload.answers
        $profile["automationUpdatedAt"] = $record.timestamp
    }

    ($profile | ConvertTo-Json -Depth 10) | Set-Content -Path $profilePath -Encoding UTF8

    if ($FromInbox -and $Payload._inboxFile) {
        Remove-Item -LiteralPath $Payload._inboxFile -Force -ErrorAction SilentlyContinue
    }

    return @{
        Ok       = $true
        Quiz     = $quizId
        RecordId = $record.id
        Jsonl    = $jsonl
        Profile  = $profilePath
    }
}

function Get-QuizInboxPending {
    param([string]$HubRoot = $null)
    $HubRoot = Get-QuizChannelRoot -HubRoot $HubRoot
    $inbox = Join-Path $HubRoot "ai-tracking/user-profile/inbox"
    if (-not (Test-Path $inbox)) { return @() }
    Get-ChildItem -Path $inbox -Filter "*.json" -File | Sort-Object LastWriteTime
}
