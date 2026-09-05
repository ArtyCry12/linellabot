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
    "/project-squad audit this repo",
    "find skill for react performance on skills.sh",
    "разложи задачу на эпики и user stories с work packages",
    "открой remotion studio",
    "собери композицию remotion",
    "grill me before we start the plan",
    "build a new project from scratch",
    "write domain glossary CONTEXT.md for the client",
    "openrouter free models"
)

$expectTop = @{
    "storyboard for reels short video" = "production-studio"
    "открой remotion studio"           = "remotion-code"
    "собери композицию remotion"       = "remotion-code"
    "grill me before we start the plan" = "clarify-first"
    "build a new project from scratch"  = "from-scratch"
    "write domain glossary CONTEXT.md for the client" = "project-context"
    "openrouter free models" = "openrouter-free"
}

Write-Host "=== Task Router test ===" -ForegroundColor Cyan

if ($Prompt) {
    $samples = @($Prompt)
    $r = Resolve-TaskRoute -Prompt $Prompt -HubRoot $HubRoot
    $ctx = Format-TaskRouteContext -ResolveResult $r
    if ($ctx) {
        Write-Host "`n--- Injected context preview ---`n" -ForegroundColor Cyan
        Write-Host $ctx
    }
}

$fail = 0
foreach ($s in $samples) {
    $r = Resolve-TaskRoute -Prompt $s -HubRoot $HubRoot
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
}

Write-Host "`nFailures: $fail / $($samples.Count)" -ForegroundColor $(if ($fail -eq 0) { "Green" } else { "Yellow" })

$utf8 = Join-Path $HubRoot "commands/task-router-utf8-check.py"
Write-Host "`n=== UTF-8 route probes ===" -ForegroundColor Cyan
python $utf8
if ($LASTEXITCODE -ne 0) { $fail++ }

if ($fail -gt 0) { exit 1 }
exit 0
