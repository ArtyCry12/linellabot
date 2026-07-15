param(
    [string]$Prompt = "",
    [string]$HubRoot = "C:\Users\Asus\.cursor"
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
    "find skill for react performance on skills.sh"
)

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
    if ($top -eq "(none)") { $fail++ }
    Write-Host "`n> $s" -ForegroundColor White
    Write-Host "  -> $top (score $score)" -ForegroundColor $color
    if ($r.Matches.Count -gt 1) {
        Write-Host "  + $($r.Matches[1].Id)" -ForegroundColor DarkGreen
    }
}

Write-Host "`nSamples with no route: $fail / $($samples.Count)" -ForegroundColor $(if ($fail -eq 0) { "Green" } else { "Yellow" })
if ($fail -gt 0) { exit 1 }
exit 0
