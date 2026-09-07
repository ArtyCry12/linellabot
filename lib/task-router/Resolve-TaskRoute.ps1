# Task Router resolver — hybrid match, fingerprint, log (shared by hooks + tests)
# Never prints secrets. Fail-open callers should catch and exit 0.

$ErrorActionPreference = "Stop"

$script:TaskRouterBroadTokens = @(
    "security", "audit", "deploy", "site", "plan", "test",
    "build", "fix", "agent"
)

function Get-TaskRouterConfig {
    param([string]$HubRoot)
    $configPath = Join-Path $HubRoot "lib/task-router/routes.json"
    if (-not (Test-Path -LiteralPath $configPath)) { return $null }
    return (Get-Content -LiteralPath $configPath -Raw -Encoding UTF8 | ConvertFrom-Json)
}

function Get-TaskRouterFingerprint {
    param([string]$Text)
    $norm = ($Text -replace "\s+", " ").Trim().ToLowerInvariant()
    $bytes = [Text.Encoding]::UTF8.GetBytes($norm)
    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        $hash = $sha.ComputeHash($bytes)
        return ([BitConverter]::ToString($hash) -replace "-", "").Substring(0, 16).ToLowerInvariant()
    }
    finally { $sha.Dispose() }
}

function Test-TaskRouterFpHit {
    param(
        [string]$HubRoot,
        [string]$Fingerprint,
        [int]$TtlSec = 120
    )
    $cachePath = Join-Path $HubRoot ".cache/task-router/fp.json"
    if (-not (Test-Path -LiteralPath $cachePath)) { return $false }
    try {
        $cache = Get-Content -LiteralPath $cachePath -Raw -Encoding UTF8 | ConvertFrom-Json
        if ([string]$cache.fp -ne $Fingerprint) { return $false }
        $age = ([DateTime]::UtcNow - [DateTime]::Parse([string]$cache.at, $null, [Globalization.DateTimeStyles]::RoundtripKind)).TotalSeconds
        return ($age -ge 0 -and $age -lt $TtlSec)
    }
    catch { return $false }
}

function Set-TaskRouterFp {
    param(
        [string]$HubRoot,
        [string]$Fingerprint,
        [string[]]$RouteIds
    )
    $dir = Join-Path $HubRoot ".cache/task-router"
    if (-not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    $obj = [ordered]@{
        fp = $Fingerprint
        at = (Get-Date).ToUniversalTime().ToString("o")
        routeIds = @($RouteIds)
    }
    ($obj | ConvertTo-Json -Compress) | Set-Content -LiteralPath (Join-Path $dir "fp.json") -Encoding UTF8
}

function Write-TaskRouterLog {
    param(
        [string]$HubRoot,
        [string]$Source,
        [string]$Fingerprint,
        [bool]$Matched,
        [string[]]$RouteIds,
        [int]$Score,
        [bool]$Advisor,
        [int]$PromptLen,
        [string]$Skipped = $null,
        [string]$Stage = $null,
        [double]$Confidence = 0,
        [string[]]$RequiredActions = @(),
        [double]$LatencyMs = 0,
        [bool]$Semantic = $false
    )
    $logPath = Join-Path $HubRoot "ai-tracking/task-router-log.jsonl"
    $dir = Split-Path $logPath -Parent
    if (-not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    $entry = [ordered]@{
        ts         = (Get-Date).ToUniversalTime().ToString("o")
        source     = $Source
        fp         = $Fingerprint
        matched    = $Matched
        routeIds   = @($RouteIds)
        score      = $Score
        advisor    = $Advisor
        promptLen  = $PromptLen
        promptHash = $Fingerprint
        skipped    = $Skipped
        stage      = $Stage
        confidence = $Confidence
        actions    = @($RequiredActions)
        latencyMs  = $LatencyMs
        semantic   = $Semantic
    }
    Add-Content -LiteralPath $logPath -Value ($entry | ConvertTo-Json -Compress) -Encoding UTF8
}

function Test-TaskRouterWordHit {
    param(
        [string]$HaystackLower,
        [string]$Needle
    )
    if ([string]::IsNullOrWhiteSpace($Needle)) { return $false }
    $n = $Needle.ToLowerInvariant()
    if ($n.Length -ge 12 -or $n.Contains(" ")) {
        return $HaystackLower.Contains($n)
    }
    $escaped = [Regex]::Escape($n)
    $pat = "(?i)(?<![0-9A-Za-z\u0400-\u04FF_])$escaped(?![0-9A-Za-z\u0400-\u04FF_])"
    return [Regex]::IsMatch($HaystackLower, $pat)
}

function Test-TaskRouterIsBroad {
    param([string]$Token)
    $t = $Token.ToLowerInvariant()
    return ($script:TaskRouterBroadTokens -contains $t)
}

function Invoke-TaskRouterSemanticCore {
    param(
        [string]$Prompt,
        [string]$ExtraText,
        [string]$HubRoot,
        [string]$Source
    )
    if ($env:TASK_ROUTER_DISABLE_NODE -eq "1") { return $null }
    $corePath = Join-Path $HubRoot "lib/task-router/router-core.mjs"
    $indexPath = Join-Path $HubRoot "lib/task-router/capabilities.generated.json"
    if (-not (Test-Path -LiteralPath $corePath) -or -not (Test-Path -LiteralPath $indexPath)) {
        return $null
    }
    try {
        $payload = @{
            prompt          = $Prompt
            extraText       = $ExtraText
            source          = $Source
            recordCandidate = ($Source -eq "user")
        } | ConvertTo-Json -Compress
        $previousOutputEncoding = $OutputEncoding
        $OutputEncoding = [Text.UTF8Encoding]::new($false)
        try {
            $raw = $null
            foreach ($attempt in 1..2) {
                $raw = $payload | & node $corePath 2>$null
                if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($raw)) {
                    break
                }
                if ($attempt -eq 1) { Start-Sleep -Milliseconds 50 }
            }
        }
        finally {
            $OutputEncoding = $previousOutputEncoding
        }
        if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($raw)) { return $null }
        return ($raw | ConvertFrom-Json)
    }
    catch {
        return $null
    }
}

function Resolve-TaskRoute {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Prompt,
        [string]$ExtraText = "",
        [string]$HubRoot = (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent),
        [int]$MinScore = -1,
        [int]$MaxRoutes = -1,
        [string]$Source = "resolve",
        [switch]$SkipCache,
        [switch]$NoLog
    )

    $config = Get-TaskRouterConfig -HubRoot $HubRoot
    if (-not $config) {
        return [PSCustomObject]@{
            Matches = @(); Skipped = "config missing"; MinScore = 0; Prompt = $Prompt
            Fingerprint = ""; Advisor = $false; Inject = $false; CacheHit = $false; TopScore = 0
        }
    }

    if ($MinScore -lt 0) { $MinScore = [int]$config.minScore }
    if ($MaxRoutes -lt 0) { $MaxRoutes = [int]$config.maxRoutes }
    $skipLen = [int]$config.skipIfShorterThan
    $longThreshold = 400
    if ($config.longThreshold) { $longThreshold = [int]$config.longThreshold }

    $combined = $Prompt
    if (-not [string]::IsNullOrWhiteSpace($ExtraText)) {
        $combined = "$Prompt`n$ExtraText"
    }
    $trimmed = $combined.Trim()
    $fp = Get-TaskRouterFingerprint -Text $trimmed

    if ($trimmed.Length -lt $skipLen) {
        if (-not $NoLog) {
            Write-TaskRouterLog -HubRoot $HubRoot -Source $Source -Fingerprint $fp -Matched:$false `
                -RouteIds @() -Score 0 -Advisor:$false -PromptLen $trimmed.Length -Skipped "too short"
        }
        return [PSCustomObject]@{
            Matches = @(); Skipped = "too short"; MinScore = $MinScore; Prompt = $trimmed
            Fingerprint = $fp; Advisor = $false; Inject = $false; CacheHit = $false; TopScore = 0
        }
    }

    $cacheHit = $false
    if (-not $SkipCache) {
        $cacheHit = Test-TaskRouterFpHit -HubRoot $HubRoot -Fingerprint $fp
    }

    $semantic = Invoke-TaskRouterSemanticCore -Prompt $Prompt -ExtraText $ExtraText `
        -HubRoot $HubRoot -Source $Source
    if ($semantic) {
        $ordered = @($semantic.matches | Select-Object -First $MaxRoutes)
        $topScore = if ($ordered.Count -gt 0) { [int]$ordered[0].Score } else { 0 }
        $advisor = [bool]$semantic.advisorRequired
        $inject = [bool]$semantic.inject
        $ids = @($ordered | ForEach-Object { $_.Id })

        if (-not $SkipCache -and ($inject -or $advisor)) {
            Set-TaskRouterFp -HubRoot $HubRoot -Fingerprint $fp -RouteIds $ids
        }
        if (-not $NoLog) {
            Write-TaskRouterLog -HubRoot $HubRoot -Source $Source -Fingerprint $fp `
                -Matched:($ordered.Count -gt 0) -RouteIds $ids -Score $topScore `
                -Advisor:$advisor -PromptLen $trimmed.Length -Skipped $null `
                -Stage ([string]$semantic.stage) -Confidence ([double]$semantic.confidence) `
                -RequiredActions @($semantic.requiredActions) `
                -LatencyMs ([double]$semantic.latencyMs) -Semantic:$true
        }
        return [PSCustomObject]@{
            Matches          = $ordered
            Skipped          = $null
            MinScore         = $MinScore
            Prompt           = $trimmed
            Fingerprint      = $fp
            Advisor          = $advisor
            Inject           = $inject
            CacheHit         = $cacheHit
            TopScore         = $topScore
            ExtraUsed        = (-not [string]::IsNullOrWhiteSpace($ExtraText))
            Semantic         = $true
            Stage            = [string]$semantic.stage
            Confidence       = [double]$semantic.confidence
            RequiredActions  = @($semantic.requiredActions)
            ExpectedReceipts = @($semantic.expectedReceipts)
            Candidates       = @($semantic.candidates)
            LatencyMs        = [double]$semantic.latencyMs
            Substantive      = [bool]$semantic.substantive
            Social           = [bool]$semantic.social
        }
    }

    $lower = $trimmed.ToLowerInvariant()
    $explicitRoute = [Regex]::IsMatch($lower, "@route|(^|\s)/route(\s|$)")
    $hasTagAnywhere = $false
    $results = @()
    $weakBest = 0

    foreach ($route in $config.routes) {
        if ($route.id -eq "autopilot") { continue }
        if ([string]$route.status -in @("archived", "unrouted")) { continue }
        $routeSkill = [string]$route.skill
        if ($routeSkill -match '[/\\]_(archive|quarantine)[/\\]') { continue }

        $score = 0
        $hits = @()
        $phraseSpans = New-Object System.Collections.Generic.List[string]
        $tagHit = $false
        $secondSignal = $false

        if ($route.tags) {
            foreach ($tag in $route.tags) {
                $t = [string]$tag
                if ($lower.Contains($t.ToLowerInvariant())) {
                    $score += 15
                    $hits += "tag:$t"
                    $tagHit = $true
                    $hasTagAnywhere = $true
                    $secondSignal = $true
                }
            }
        }

        if ($route.phrases) {
            foreach ($phrase in $route.phrases) {
                $p = [string]$phrase
                $pl = $p.ToLowerInvariant()
                if ($lower.Contains($pl)) {
                    $score += 10
                    $hits += "phrase:$p"
                    [void]$phraseSpans.Add($pl)
                    $secondSignal = $true
                }
            }
        }

        if ($route.keywords) {
            foreach ($kw in $route.keywords) {
                $k = [string]$kw
                $kl = $k.ToLowerInvariant()
                $insidePhrase = $false
                foreach ($ps in $phraseSpans) {
                    if ($ps.Contains($kl)) { $insidePhrase = $true; break }
                }
                if ($insidePhrase) { continue }
                if (-not (Test-TaskRouterWordHit -HaystackLower $lower -Needle $k)) { continue }
                if (Test-TaskRouterIsBroad -Token $k) {
                    if (-not $secondSignal -and -not $tagHit -and $phraseSpans.Count -eq 0) {
                        $other = $false
                        foreach ($kw2 in $route.keywords) {
                            $k2 = [string]$kw2
                            if ($k2.ToLowerInvariant() -eq $kl) { continue }
                            if (Test-TaskRouterIsBroad -Token $k2) { continue }
                            if (Test-TaskRouterWordHit -HaystackLower $lower -Needle $k2) { $other = $true; break }
                        }
                        if (-not $other) { continue }
                    }
                }
                $score += 3
                $hits += "kw:$k"
                if (-not (Test-TaskRouterIsBroad -Token $k)) { $secondSignal = $true }
            }
        }

        if ($score -gt $weakBest) { $weakBest = $score }

        if ($score -ge $MinScore) {
            $results += [PSCustomObject]@{
                Id        = $route.id
                Label     = $route.label
                Score     = $score
                Hits      = $hits
                Mode      = $route.mode
                Skill     = $route.skill
                Skills    = @($route.skills)
                Rule      = $route.rule
                Mcp       = @($route.mcp)
                Commands  = @($route.commands)
                Subagent  = @($route.subagent)
                Docs      = @($route.docs)
                Templates = @($route.templates)
                Note      = $route.note
            }
        }
    }

    $ordered = @($results | Sort-Object Score -Descending | Select-Object -First $MaxRoutes)
    $topScore = if ($ordered.Count -gt 0) { [int]$ordered[0].Score } else { 0 }
    $isLong = ($trimmed.Length -ge $longThreshold) -or (-not [string]::IsNullOrWhiteSpace($ExtraText))
    $inject = ($ordered.Count -gt 0) -or $hasTagAnywhere

    $advisor = $false
    if ($explicitRoute) {
        $advisor = $true
    }
    elseif ($isLong -and ($ordered.Count -eq 0 -or $topScore -lt ($MinScore + 5))) {
        $advisor = $true
    }
    elseif ($ordered.Count -eq 0 -and $weakBest -gt 0) {
        $advisor = $true
    }
    elseif ($ordered.Count -eq 0 -and
        $lower -notmatch '^(hello|thanks|hi)\W*$') {
        $advisor = $true
    }

    $ids = @($ordered | ForEach-Object { $_.Id })
    if (-not $SkipCache -and ($inject -or $advisor)) {
        Set-TaskRouterFp -HubRoot $HubRoot -Fingerprint $fp -RouteIds $ids
    }

    if (-not $NoLog) {
        Write-TaskRouterLog -HubRoot $HubRoot -Source $Source -Fingerprint $fp -Matched:($ordered.Count -gt 0) `
            -RouteIds $ids -Score $topScore -Advisor:$advisor -PromptLen $trimmed.Length -Skipped $null
    }

    return [PSCustomObject]@{
        Matches      = $ordered
        Skipped      = $null
        MinScore     = $MinScore
        Prompt       = $trimmed
        Fingerprint  = $fp
        Advisor      = $advisor
        Inject       = $inject
        CacheHit     = $cacheHit
        TopScore     = $topScore
        ExtraUsed    = (-not [string]::IsNullOrWhiteSpace($ExtraText))
    }
}

function Format-TaskRouteContext {
    param(
        [Parameter(Mandatory = $true)]
        $ResolveResult
    )

    $hasMatches = $ResolveResult.Matches -and $ResolveResult.Matches.Count -gt 0
    $advisor = [bool]$ResolveResult.Advisor
    if (-not $hasMatches -and -not $advisor) { return $null }
    if ($ResolveResult.PSObject.Properties.Name -contains "Inject" -and -not $ResolveResult.Inject -and -not $advisor) {
        return $null
    }

    $echoHint = [char]0x041F + [char]0x043E + [char]0x0434 + [char]0x043A + [char]0x043B + [char]0x044E + [char]0x0447 + [char]0x0438 + [char]0x043B + ":"
    $lines = @()
    if ($hasMatches) {
        $lines += "[TASK ROUTE]"
        $lines += "MUST: Read Primary SKILL.md before improvising. Echo $echoHint in first reply block."
        $lines += ""
        $i = 0
        foreach ($m in $ResolveResult.Matches) {
            $i++
            $rank = if ($i -eq 1) { "P" } else { "S" }
            $bits = @("${rank}:$($m.Id)")
            if ($m.Mode) { $bits += "mode=$($m.Mode)" }
            if ($m.Skill) { $bits += "skill=$($m.Skill)" }
            if ($m.Skills -and $m.Skills.Count -gt 0) {
                $bits += ("skills=" + (($m.Skills | Select-Object -First 3) -join ","))
            }
            if ($m.Rule) { $bits += "rule=$($m.Rule)" }
            if ($m.Commands -and $m.Commands.Count -gt 0 -and $i -eq 1) {
                $bits += ("cmds=" + (($m.Commands | Select-Object -First 4) -join ","))
            }
            if ($m.Mcp -and $m.Mcp.Count -gt 0) { $bits += ("mcp=" + ($m.Mcp -join ",")) }
            if ($m.Subagent -and $m.Subagent.Count -gt 0 -and $i -eq 1) {
                $bits += ("sub=" + (($m.Subagent | Select-Object -First 4) -join ","))
            }
            if ($m.Note) { $bits += "note=$($m.Note)" }
            $lines += ($bits -join " | ")
        }
    }
    else {
        $lines += "[TASK ROUTE]"
        $lines += "No strong keyword match."
    }

    if ($ResolveResult.PSObject.Properties.Name -contains "Stage") {
        $lines += ""
        $lines += "[TASK PREFLIGHT]"
        $lines += "stage=$($ResolveResult.Stage) | confidence=$($ResolveResult.Confidence) | fp=$($ResolveResult.Fingerprint)"
        if ($ResolveResult.Candidates -and $ResolveResult.Candidates.Count -gt 0) {
            $candidateBits = @($ResolveResult.Candidates | Select-Object -First 3 |
                ForEach-Object { "$($_.id):$($_.score)" })
            $lines += ("CANDIDATES: " + ($candidateBits -join ", "))
        }
        if ($ResolveResult.RequiredActions -and $ResolveResult.RequiredActions.Count -gt 0) {
            $lines += ("REQUIRED: " + ($ResolveResult.RequiredActions -join ", "))
            $lines += "MUST execute each applicable required action or report a concrete blocker."
            $lines += "RECEIPT after action: system | why | evidence/result | status. Never claim unused systems."
        }
    }

    if ($advisor) {
        $lines += ""
        $lines += "[TASK ROUTE - advisor]"
        $lines += "Parent MUST spawn route-advisor once for this substantive low-confidence task. Use subagent_type=route-advisor, or generalPurpose with agents/route-advisor.md if unavailable. model=composer-2.5-fast. Never inherit. Never loop advisor. Apply returned route + required actions."
    }

    return ($lines -join "`n")
}

function Get-TaskRouterPlanExtraText {
    param(
        [string]$Prompt,
        [string]$HubRoot,
        [int]$MaxChars = 8000
    )
    if ([string]::IsNullOrWhiteSpace($Prompt)) { return "" }
    $m = [Regex]::Match($Prompt, "(?i)([A-Za-z0-9_./\\:-]+\.plan\.md)")
    if (-not $m.Success) { return "" }
    $raw = $m.Groups[1].Value.Trim("""'")
    $candidates = @()
    if ([IO.Path]::IsPathRooted($raw)) {
        $candidates += $raw
    }
    else {
        $candidates += (Join-Path $HubRoot $raw)
        $candidates += (Join-Path (Join-Path $HubRoot "plans") (Split-Path $raw -Leaf))
        $candidates += (Join-Path (Join-Path $HubRoot ".cursor/plans") (Split-Path $raw -Leaf))
    }
    foreach ($c in $candidates) {
        if (Test-Path -LiteralPath $c) {
            $text = [IO.File]::ReadAllText($c, [Text.UTF8Encoding]::new($false))
            if ($text.Length -gt $MaxChars) { $text = $text.Substring(0, $MaxChars) }
            return $text
        }
    }
    return ""
}