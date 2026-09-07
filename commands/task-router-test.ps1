param(
    [string]$Prompt = "",
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"
$resolver = Join-Path $HubRoot "lib/task-router/Resolve-TaskRoute.ps1"
. $resolver

$samples = @(
    "check seo for okara.ai site",
    "clone landing page example.com",
    "storyboard for reels short video",
    "remember we use Exa for research",
    "why is CI failing on github",
    "open site and click sign in",
    "setup n8n workflow for slack",
    "what is DEC-056",
    "design how all system parts should connect",
    "find skill for react performance on skills.sh",
    "grill me before we start the plan",
    "build a new project from scratch",
    "write domain glossary CONTEXT.md for the client",
    "openrouter free models"
)

$expectTop = @{
    "storyboard for reels short video" = "production-studio"
    "grill me before we start the plan" = "clarify-first"
    "build a new project from scratch"  = "from-scratch"
    "write domain glossary CONTEXT.md for the client" = "project-context"
    "openrouter free models" = "openrouter-free"
    "design how all system parts should connect" = "architecture-plan"
}

Write-Host "=== Task Router test ===" -ForegroundColor Cyan

if ($Prompt) {
    $samples = @($Prompt)
    $r = Resolve-TaskRoute -Prompt $Prompt -HubRoot $HubRoot -SkipCache -Source "test"
    $ctx = Format-TaskRouteContext -ResolveResult $r
    if ($ctx) {
        Write-Host "`n--- Injected context preview ---`n" -ForegroundColor Cyan
        Write-Host $ctx
    }
}

$fail = 0
foreach ($s in $samples) {
    $r = Resolve-TaskRoute -Prompt $s -HubRoot $HubRoot -SkipCache -NoLog -Source "test"
    $top = if ($r.Matches.Count -gt 0) { $r.Matches[0].Id } else { "(none)" }
    $score = if ($r.Matches.Count -gt 0) { $r.Matches[0].Score } else { "" }
    $color = if ($top -eq "(none)") { "Yellow" } else { "Green" }
    $wrong = $expectTop.ContainsKey($s) -and $top -ne $expectTop[$s]
    if ($top -eq "(none)" -or $wrong) {
        $fail++
        if ($wrong) { $color = "Red" }
    }
    Write-Host "`n> $s" -ForegroundColor White
    if ($wrong) {
        Write-Host "  -> $top (score $score) expected $($expectTop[$s])" -ForegroundColor $color
    }
    else {
        Write-Host "  -> $top (score $score)" -ForegroundColor $color
    }
    if ($r.Matches.Count -gt 1) {
        Write-Host "  + $($r.Matches[1].Id)" -ForegroundColor DarkGreen
    }
    if ($r.Matches.Count -gt 0) {
        $ctx = Format-TaskRouteContext -ResolveResult $r
        if ($ctx -notmatch "MUST" -or $ctx -notmatch "Echo" -or
            $ctx -notmatch "TASK PREFLIGHT") {
            Write-Host "  FAIL: format missing MUST/Echo/Preflight contract" -ForegroundColor Red
            $fail++
        }
    }
}

# RU remotion / task-decomposition via UTF-8 literals built from fixtures file optional
$fxPath = Join-Path $HubRoot "lib/task-router/test-fixtures.json"
if (Test-Path -LiteralPath $fxPath) {
    $fx = Get-Content -LiteralPath $fxPath -Raw -Encoding UTF8 | ConvertFrom-Json
    foreach ($row in $fx.samples) {
        $s = [string]$row.prompt
        $exp = [string]$row.expect
        $r = Resolve-TaskRoute -Prompt $s -HubRoot $HubRoot -SkipCache -NoLog -Source "test-fx"
        $top = if ($r.Matches.Count -gt 0) { $r.Matches[0].Id } else { "(none)" }
        Write-Host "`n> [fx] $($s.Substring(0, [Math]::Min(48, $s.Length)))..." -ForegroundColor White
        if ($top -ne $exp) {
            Write-Host "  -> $top expected $exp" -ForegroundColor Red
            $fail++
        }
        else {
            Write-Host "  -> $top (ok)" -ForegroundColor Green
        }
    }
}

$fpPrompt = "openrouter free models cache-probe-$(Get-Random)"
$r1 = Resolve-TaskRoute -Prompt $fpPrompt -HubRoot $HubRoot -Source "test-fp"
$r2 = Resolve-TaskRoute -Prompt $fpPrompt -HubRoot $HubRoot -Source "test-fp"
$r1Ids = @($r1.Matches | ForEach-Object Id) -join ","
$r2Ids = @($r2.Matches | ForEach-Object Id) -join ","
if (-not $r2.CacheHit -or $r2Ids -ne $r1Ids -or
    $r2.Advisor -ne $r1.Advisor) {
    Write-Host "`nFAIL: fingerprint cache changed repeated routing decision" -ForegroundColor Red
    $fail++
}
else {
    Write-Host "`nOK: fingerprint cache preserves repeated routing decision" -ForegroundColor Green
}

$hi = Resolve-TaskRoute -Prompt "hi" -HubRoot $HubRoot -SkipCache -NoLog -Source "test"
if ($hi.Matches.Count -gt 0 -or $hi.Advisor) {
    Write-Host "FAIL: short greeting should be silence" -ForegroundColor Red
    $fail++
}
else {
    Write-Host "OK: short greeting silence" -ForegroundColor Green
}

$previousDisableNode = $env:TASK_ROUTER_DISABLE_NODE
$env:TASK_ROUTER_DISABLE_NODE = "1"
try {
    foreach ($archivedPrompt in @(
        "/project-squad restore",
        "@babyagi expand tasks",
        "@crew-ai marketing pipeline"
    )) {
        $fallback = Resolve-TaskRoute -Prompt $archivedPrompt -HubRoot $HubRoot `
            -SkipCache -NoLog -Source "test"
        $fallbackIds = @($fallback.Matches | ForEach-Object Id)
        if ($fallbackIds | Where-Object { $_ -in @("project-squad", "babyagi", "crew-ai") }) {
            Write-Host "FAIL: fallback routed archive/quarantine: $archivedPrompt" -ForegroundColor Red
            $fail++
        }
        elseif (-not $fallback.Advisor) {
            Write-Host "FAIL: fallback did not escalate substantive prompt: $archivedPrompt" -ForegroundColor Red
            $fail++
        }
    }
}
finally {
    $env:TASK_ROUTER_DISABLE_NODE = $previousDisableNode
}
if ($fail -eq 0) {
    Write-Host "OK: fallback excludes archive/quarantine and escalates" -ForegroundColor Green
}

Write-Host "`nFailures: $fail" -ForegroundColor $(if ($fail -eq 0) { "Green" } else { "Yellow" })

$utf8py = Join-Path $HubRoot "commands/task-router-utf8-check.py"
Write-Host "`n=== UTF-8 route probes ===" -ForegroundColor Cyan
python $utf8py
if ($LASTEXITCODE -ne 0) { $fail++ }

if ($fail -gt 0) { exit 1 }
exit 0