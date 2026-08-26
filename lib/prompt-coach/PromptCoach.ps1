# Prompt Engineering Coach — capture, state, readiness

$ErrorActionPreference = "Stop"

function Get-DefaultHubRoot {
    Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
}

function Get-CoachPaths {
    param([string]$HubRoot = "")
    if (-not $HubRoot) { $HubRoot = Get-DefaultHubRoot }
    $cfgPath = Join-Path $HubRoot "lib/prompt-coach/CoachConfig.json"
    $cfg = Get-Content $cfgPath -Raw -Encoding UTF8 | ConvertFrom-Json
    [PSCustomObject]@{
        HubRoot     = $HubRoot
        Config      = $cfg
        CapturePath = Join-Path $HubRoot $cfg.captureFile
        StatePath   = Join-Path $HubRoot $cfg.stateFile
        LessonsDir  = Join-Path $HubRoot $cfg.lessonsDir
    }
}

function Test-NoisePrompt {
    param([string]$Text, $Config)
    foreach ($n in $Config.noisePatterns) {
        if ($Text -like "*$n*") { return $true }
    }
    return $false
}

function Test-SubstantivePrompt {
    param([string]$Text, $Config)
    if ($Text.Length -lt [int]$Config.minCharsSubstantive) { return $false }
    if (Test-NoisePrompt -Text $Text -Config $Config) { return $false }
    return $true
}

function Get-CoachState {
    param($Paths)
    if (-not (Test-Path $Paths.StatePath)) {
        return [PSCustomObject]@{
            version             = 1
            lastLessonAt        = $null
            lessonsWritten      = 0
            substantiveCaptured = 0
            milestones          = @()
            lastCaptureAt       = $null
        }
    }
    return Get-Content $Paths.StatePath -Raw -Encoding UTF8 | ConvertFrom-Json
}

function Save-CoachState {
    param($Paths, $State)
    $dir = Split-Path $Paths.StatePath -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $State | ConvertTo-Json -Depth 6 | Set-Content $Paths.StatePath -Encoding UTF8
}

function Get-PromptTokenCount {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Text,
        [string]$HubRoot = ""
    )

    if (-not $HubRoot) { $HubRoot = Get-DefaultHubRoot }
    $py = Join-Path $HubRoot ".venv-markitdown\Scripts\python.exe"
    $script = Join-Path $HubRoot "lib\prompt-coach\count_tokens.py"
    if (-not (Test-Path $py) -or -not (Test-Path $script)) { return $null }

    $prev = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $escaped = $Text -replace '"', '\"'
        $out = & $py $script $Text 2>&1 | Select-Object -Last 1
        if ($out -match '^\d+$') { return [int]$out }
        return $null
    }
    finally {
        $ErrorActionPreference = $prev
    }
}

function Measure-PromptWater {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Text,
        [string]$HubRoot = ""
    )

    $words = @($Text -split '\s+' | Where-Object { $_.Length -gt 0 })
    $wordCount = $words.Count
    $len = $Text.Length
    $tokenCount = Get-PromptTokenCount -Text $Text -HubRoot $HubRoot

    $fillers = @(
        "please", "kindly", "just", "really", "very", "maybe", "somewhat",
        "could you", "i want you to", "i need you to",
        "пожалуйста", "можешь", "хочу чтобы", "нужно чтобы", "очень", "просто",
        "как-нибудь", "если можно", "было бы здорово"
    )

    $lower = $Text.ToLowerInvariant()
    $fillerHits = 0
    foreach ($f in $fillers) {
        if ($lower.Contains($f)) { $fillerHits++ }
    }

    $hasContract = ($Text -match 'Deliverables:|Done when:|!auto|/autopilot|REQ-')
    $level = 3
    if ($len -lt 80) { $level-- }
    if ($len -gt 400) { $level++ }
    if ($len -gt 900) { $level++ }
    if ($wordCount -gt 150) { $level++ }
    if ($fillerHits -ge 3) { $level++ }
    if ($hasContract) { $level-- }
    if ($null -ne $tokenCount) {
        if ($tokenCount -gt 250) { $level++ }
        if ($tokenCount -gt 600) { $level++ }
        if ($tokenCount -lt 40) { $level-- }
    }
    if ($level -lt 1) { $level = 1 }
    if ($level -gt 5) { $level = 5 }

    return [PSCustomObject]@{
        wordCount   = $wordCount
        charCount   = $len
        tokenCount  = $tokenCount
        fillerHits  = $fillerHits
        hasContract = [bool]$hasContract
        waterLevel  = $level
    }
}

function Register-PromptMetrics {
    param(
        [Parameter(Mandatory = $true)]
        $Metrics,
        [string]$HubRoot = ""
    )

    $paths = Get-CoachPaths -HubRoot $HubRoot
    $cfg = $paths.Config
    if (-not $cfg.metricsFile) { return }

    $metricsPath = Join-Path $paths.HubRoot $cfg.metricsFile
    $dir = Split-Path $metricsPath -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    $entry = @{
        t           = (Get-Date).ToString("o")
        wordCount   = $Metrics.wordCount
        charCount   = $Metrics.charCount
        tokenCount  = $Metrics.tokenCount
        fillerHits  = $Metrics.fillerHits
        hasContract = $Metrics.hasContract
        waterLevel  = $Metrics.waterLevel
    } | ConvertTo-Json -Compress

    Add-Content -Path $metricsPath -Value $entry -Encoding UTF8
}

function Get-PromptWaterReport {
    param(
        [int]$Last = 20,
        [string]$HubRoot = ""
    )

    $paths = Get-CoachPaths -HubRoot $HubRoot
    $cfg = $paths.Config
    $metricsPath = Join-Path $paths.HubRoot $cfg.metricsFile
    if (-not (Test-Path $metricsPath)) {
        return [PSCustomObject]@{
            Count   = 0
            AvgWater = 0
            HighWater = 0
            Items   = @()
        }
    }

    $items = @()
    $lines = Get-Content $metricsPath -Encoding UTF8 | Select-Object -Last $Last
    foreach ($line in $lines) {
        try { $items += $line | ConvertFrom-Json } catch { }
    }

    if ($items.Count -eq 0) {
        return [PSCustomObject]@{ Count = 0; AvgWater = 0; HighWater = 0; Items = @() }
    }

    $sum = 0
    $high = 0
    foreach ($i in $items) {
        $sum += [int]$i.waterLevel
        if ([int]$i.waterLevel -ge 4) { $high++ }
    }

    return [PSCustomObject]@{
        Count    = $items.Count
        AvgWater = [math]::Round($sum / $items.Count, 2)
        HighWater = $high
        Items    = $items
    }
}

function Add-PromptCapture {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Prompt,
        [string]$HubRoot = ""
    )

    $paths = Get-CoachPaths -HubRoot $HubRoot
    $cfg = $paths.Config
    if (-not (Test-SubstantivePrompt -Text $Prompt -Config $cfg)) {
        return [PSCustomObject]@{ Captured = $false; Reason = "filtered" }
    }

    $metrics = Measure-PromptWater -Text $Prompt

    $entry = @{
        t           = (Get-Date).ToString("o")
        len         = $Prompt.Length
        text        = $Prompt
        source      = "user"
        wordCount   = $metrics.wordCount
        waterLevel  = $metrics.waterLevel
        fillerHits  = $metrics.fillerHits
        hasContract = $metrics.hasContract
    } | ConvertTo-Json -Compress -Depth 3

    $capDir = Split-Path $paths.CapturePath -Parent
    if (-not (Test-Path $capDir)) { New-Item -ItemType Directory -Path $capDir -Force | Out-Null }
    Add-Content -Path $paths.CapturePath -Value $entry -Encoding UTF8
    Register-PromptMetrics -Metrics $metrics -HubRoot $HubRoot

    $state = Get-CoachState -Paths $paths
    $state.substantiveCaptured = [int]$state.substantiveCaptured + 1
    $state.lastCaptureAt = (Get-Date).ToString("o")
    Save-CoachState -Paths $paths -State $state

    return [PSCustomObject]@{
        Captured   = $true
        Total      = $state.substantiveCaptured
        WaterLevel = $metrics.waterLevel
    }
}

function Get-CapturesSinceLesson {
    param($Paths, $State)
    if (-not (Test-Path $Paths.CapturePath)) { return @() }
    $lines = Get-Content $Paths.CapturePath -Encoding UTF8 | Where-Object { $_.Trim() }
    $since = $State.lastLessonAt
    $items = @()
    foreach ($line in $lines) {
        try {
            $o = $line | ConvertFrom-Json
            if ($since -and $o.t -le $since) { continue }
            $items += $o
        } catch { }
    }
    return $items
}

function Get-CoachReadiness {
    param([string]$HubRoot = "")

    $paths = Get-CoachPaths -HubRoot $HubRoot
    $cfg = $paths.Config
    $state = Get-CoachState -Paths $paths
    $captures = @(Get-CapturesSinceLesson -Paths $paths -State $state)

    $daysSince = 999.0
    if ($state.lastLessonAt) {
        $last = [DateTime]::Parse($state.lastLessonAt)
        $daysSince = ((Get-Date) - $last).TotalDays
    }

    $hasMilestone = $false
    if ($state.milestones) {
        foreach ($m in @($state.milestones)) {
            if (-not $state.lastLessonAt) { $hasMilestone = $true; break }
            if ($m.at -gt $state.lastLessonAt) { $hasMilestone = $true; break }
        }
    }

    $ready = $false
    $reasons = @()

    if ($daysSince -lt [double]$cfg.minDaysBetweenLessons) {
        $wait = [math]::Ceiling([double]$cfg.minDaysBetweenLessons - $daysSince)
        $reasons += "wait_days:$wait"
    }

    $promptCount = $captures.Count
    if ($promptCount -ge [int]$cfg.minSubstantivePrompts) {
        $reasons += "prompts_ok:$promptCount"
    }

    if ($hasMilestone) { $reasons += "milestone_ok" }

    if ($daysSince -ge [double]$cfg.minDaysBetweenLessons) {
        if ($promptCount -ge [int]$cfg.minSubstantivePrompts) { $ready = $true }
        if ($hasMilestone -and $promptCount -ge 2) { $ready = $true }
    }

    return [PSCustomObject]@{
        Ready           = $ready
        PromptsSince    = $promptCount
        MinPrompts      = [int]$cfg.minSubstantivePrompts
        DaysSinceLesson = [math]::Floor($daysSince)
        MinDays         = [int]$cfg.minDaysBetweenLessons
        LessonsWritten  = [int]$state.lessonsWritten
        LastLessonAt    = $state.lastLessonAt
        Reasons         = ($reasons -join "; ")
        Captures        = $captures
        NotionHub       = $cfg.notionHub
    }
}

function Register-CoachMilestone {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Label,
        [string]$HubRoot = ""
    )
    $paths = Get-CoachPaths -HubRoot $HubRoot
    $state = Get-CoachState -Paths $paths
    $list = @()
    if ($state.milestones) { $list = @($state.milestones) }
    $list += [PSCustomObject]@{ at = (Get-Date).ToString("o"); label = $Label }
    $state.milestones = $list
    Save-CoachState -Paths $paths -State $state
}

function Complete-CoachLesson {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Slug,
        [string]$HubRoot = ""
    )
    $paths = Get-CoachPaths -HubRoot $HubRoot
    $state = Get-CoachState -Paths $paths
    $state.lastLessonAt = (Get-Date).ToString("o")
    $state.lessonsWritten = [int]$state.lessonsWritten + 1
    $state.lastLessonSlug = $Slug
    Save-CoachState -Paths $paths -State $state
}

function Register-MiniScore {
    param(
        [Parameter(Mandatory = $true)]
        [int]$Score,
        [Parameter(Mandatory = $true)]
        [string]$Reason,
        [string]$HubRoot = "",
        # Optional markers for analytics only (no lesson/nudge). Example: @('wbs-gap')
        [string[]]$Flags = @()
    )
    if ($Score -lt 1) { $Score = 1 }
    if ($Score -gt 10) { $Score = 10 }
    $paths = Get-CoachPaths -HubRoot $HubRoot
    $cfg = $paths.Config
    $scoresPath = Join-Path $paths.HubRoot $cfg.scoresFile
    $dir = Split-Path $scoresPath -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $entry = @{
        t      = (Get-Date).ToString("o")
        score  = $Score
        reason = $Reason
    }
    if ($Flags -and $Flags.Count -gt 0) {
        $entry.flags = @($Flags | Where-Object { $_ -and $_.Trim() } | Select-Object -Unique)
    }
    $json = $entry | ConvertTo-Json -Compress
    Add-Content -Path $scoresPath -Value $json -Encoding UTF8
}

function Get-TopHooksFromCaptures {
    param(
        [int]$Top = 5,
        [string]$HubRoot = ""
    )
    $paths = Get-CoachPaths -HubRoot $HubRoot
    if (-not (Test-Path $paths.CapturePath)) { return @() }

    $hookPatterns = @(
        @{ re = '!auto|/autopilot'; label = '!auto / /autopilot' }
        @{ re = 'seo|seo audit|check seo'; label = 'seo audit' }
        @{ re = 'clone|landing'; label = 'clone-website' }
        @{ re = 'storyboard|reels'; label = 'production-studio' }
        @{ re = 'remember|handoff'; label = 'user-memory' }
        @{ re = 'project-squad|/project-squad'; label = 'project-squad' }
        @{ re = 'P[123]|phase'; label = 'P1/P2/P3 phase' }
        @{ re = 'notion'; label = 'notion-workspace' }
        @{ re = 'n8n'; label = 'n8n-workflow' }
        @{ re = 'prompt-lesson|prompt coach'; label = 'prompt-lesson' }
        @{ re = 'Deliverables:|Done when:'; label = 'mega-task contract' }
    )

    $counts = @{}
    $lines = Get-Content $paths.CapturePath -Encoding UTF8
    foreach ($line in $lines) {
        try {
            $o = $line | ConvertFrom-Json
            $text = [string]$o.text
            foreach ($hp in $hookPatterns) {
                if ($text -match $hp.re) {
                    $counts[$hp.label] = [int]$counts[$hp.label] + 1
                }
            }
        } catch { }
    }

    return $counts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First $Top
}

function Get-CheatsheetReadiness {
    param([string]$HubRoot = "")
    $paths = Get-CoachPaths -HubRoot $HubRoot
    $cfg = $paths.Config
    $state = Get-CoachState -Paths $paths
    $days = [double]$cfg.cheatsheetIntervalDays
    $since = 999.0
    $lastAt = $state.PSObject.Properties['lastCheatsheetAt'].Value
    if ($lastAt) {
        $since = ((Get-Date) - [DateTime]::Parse([string]$lastAt)).TotalDays
    }
    $captures = @()
    if (Test-Path $paths.CapturePath) {
        $captures = @(Get-Content $paths.CapturePath -Encoding UTF8 | ForEach-Object { $_ | ConvertFrom-Json })
    }
    $ready = ($since -ge $days) -and ($captures.Count -ge 3)
    return [PSCustomObject]@{
        Ready          = $ready
        DaysSince      = [math]::Floor($since)
        IntervalDays   = [int]$days
        CaptureCount   = $captures.Count
        LastCheatsheet = $lastAt
    }
}

function Complete-Cheatsheet {
    param(
        [Parameter(Mandatory = $true)]
        [string]$MonthSlug,
        [string]$HubRoot = ""
    )
    $paths = Get-CoachPaths -HubRoot $HubRoot
    $state = Get-CoachState -Paths $paths
    $state | Add-Member -NotePropertyName lastCheatsheetAt -NotePropertyValue (Get-Date).ToString("o") -Force
    $state | Add-Member -NotePropertyName lastCheatsheetSlug -NotePropertyValue $MonthSlug -Force
    Save-CoachState -Paths $paths -State $state
}

function Get-NotionPublishPayload {
    param(
        [Parameter(Mandatory = $true)]
        [string]$LessonPath,
        [string]$HubRoot = ""
    )
    $paths = Get-CoachPaths -HubRoot $HubRoot
    $cfg = $paths.Config
    if (-not (Test-Path $LessonPath)) { throw "Lesson not found: $LessonPath" }
    $md = Get-Content $LessonPath -Raw -Encoding UTF8
    $title = Split-Path $LessonPath -Leaf
    $title = $title -replace '\.md$',''
    $pageId = [string]$cfg.notionHubPageId
    if ($pageId -match '^([a-f0-9]{8})([a-f0-9]{4})([a-f0-9]{4})([a-f0-9]{4})([a-f0-9]{12})$') {
        $pageId = "$($Matches[1])-$($Matches[2])-$($Matches[3])-$($Matches[4])-$($Matches[5])"
    }
    return [PSCustomObject]@{
        parent_page_id = $pageId
        notion_hub     = $cfg.notionHub
        title          = $title
        content_md     = $md
        mcp_tool       = "notion-create-pages"
        mcp_parent     = @{ page_id = $pageId }
        note           = "User must approve before MCP call. Convert md to Notion markdown per notion://docs/enhanced-markdown-spec"
    }
}

