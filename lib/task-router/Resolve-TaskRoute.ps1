# Task Router resolver — shared by hook and test harness

$ErrorActionPreference = "Stop"

function Resolve-TaskRoute {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Prompt,

        [string]$HubRoot = (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent),
        [int]$MinScore = -1,
        [int]$MaxRoutes = -1
    )

    $configPath = Join-Path $HubRoot "lib/task-router/routes.json"
    if (-not (Test-Path $configPath)) {
        return [PSCustomObject]@{ Matches = @(); Skipped = "config missing" }
    }

    $config = Get-Content $configPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($MinScore -lt 0) { $MinScore = [int]$config.minScore }
    if ($MaxRoutes -lt 0) { $MaxRoutes = [int]$config.maxRoutes }
    $skipLen = [int]$config.skipIfShorterThan

    $trimmed = $Prompt.Trim()
    if ($trimmed.Length -lt $skipLen) {
        return [PSCustomObject]@{ Matches = @(); Skipped = "too short" }
    }

    $lower = $trimmed.ToLowerInvariant()
    $results = @()

    foreach ($route in $config.routes) {
        if ($route.id -eq "autopilot") { continue }

        $score = 0
        $hits = @()

        if ($route.tags) {
            foreach ($tag in $route.tags) {
                $t = [string]$tag
                if ($lower.Contains($t.ToLowerInvariant())) {
                    $score += 15
                    $hits += "tag:$t"
                }
            }
        }

        if ($route.phrases) {
            foreach ($phrase in $route.phrases) {
                $p = [string]$phrase
                if ($lower.Contains($p.ToLowerInvariant())) {
                    $score += 10
                    $hits += "phrase:$p"
                }
            }
        }

        if ($route.keywords) {
            foreach ($kw in $route.keywords) {
                $k = [string]$kw
                if ($lower.Contains($k.ToLowerInvariant())) {
                    $score += 3
                    $hits += "kw:$k"
                }
            }
        }

        if ($score -ge $MinScore) {
            $results += [PSCustomObject]@{
                Id        = $route.id
                Label     = $route.label
                Score     = $score
                Hits      = $hits
                Mode      = $route.mode
                Skill     = $route.skill
                Rule      = $route.rule
                Mcp       = @($route.mcp)
                Commands  = @($route.commands)
                Subagent  = @($route.subagent)
                Docs      = @($route.docs)
                Templates = @($route.templates)
            }
        }
    }

    $ordered = $results | Sort-Object Score -Descending | Select-Object -First $MaxRoutes

    return [PSCustomObject]@{
        Matches  = @($ordered)
        Skipped  = $null
        MinScore = $MinScore
        Prompt   = $trimmed
    }
}

function Format-TaskRouteContext {
    param(
        [Parameter(Mandatory = $true)]
        $ResolveResult
    )

    if (-not $ResolveResult.Matches -or $ResolveResult.Matches.Count -eq 0) {
        return $null
    }

    $lines = @(
        "[TASK ROUTE - auto-detected from your message]",
        "Follow this bundle before loading unrelated skills/MCP. Read SKILL.md when listed.",
        ""
    )

    $i = 0
    foreach ($m in $ResolveResult.Matches) {
        $i++
        $rank = if ($i -eq 1) { "Primary" } else { "Secondary" }
        $lines += "## ${rank}: $($m.Label) (score $($m.Score))"
        if ($m.Mode) { $lines += "- Mode: $($m.Mode)" }
        if ($m.Skill) { $lines += "- Skill: $($m.Skill)" }
        if ($m.Rule) { $lines += "- Rule: $($m.Rule)" }
        if ($m.Mcp -and $m.Mcp.Count -gt 0) { $lines += "- MCP: $($m.Mcp -join ', ')" }
        if ($m.Commands -and $m.Commands.Count -gt 0) { $lines += "- Commands: $($m.Commands -join ', ')" }
        if ($m.Subagent -and $m.Subagent.Count -gt 0) { $lines += "- Subagent: $($m.Subagent -join ', ')" }
        if ($m.Docs -and $m.Docs.Count -gt 0) { $lines += "- Docs: $($m.Docs -join ', ')" }
        $lines += "- Signals: $($m.Hits -join '; ')"
        $lines += ""
    }

    $lines += "Registry: SYSTEM-REGISTRY.md | Tree: rules/auto-orchestrator.mdc"
    return ($lines -join "`n")
}
