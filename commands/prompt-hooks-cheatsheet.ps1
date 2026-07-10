param(
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [switch]$Force
)

$ErrorActionPreference = "Stop"
. (Join-Path $HubRoot "lib/prompt-coach/PromptCoach.ps1")

$ready = Get-CheatsheetReadiness -HubRoot $HubRoot
if (-not $Force -and -not $ready.Ready) {
    Write-Host "Cheatsheet not due: $($ready.DaysSince)d / $($ready.IntervalDays)d, captures $($ready.CaptureCount)" -ForegroundColor Yellow
    exit 0
}

$month = Get-Date -Format "yyyy-MM"
$outPath = Join-Path $HubRoot "ai-tracking/prompt-lessons/cheatsheet-$month.md"
$top = @(Get-TopHooksFromCaptures -Top 5 -HubRoot $HubRoot)

$lines = @(
    "# Top hooks - $month"
    ""
    "Personal cheatsheet from _capture.jsonl"
    ""
    "| # | Pattern | Count |"
    "|---|---------|-------|"
)

$i = 0
foreach ($t in $top) {
    $i++
    $lines += "| $i | $($t.Name) | $($t.Value)x |"
}

if ($top.Count -eq 0) {
    $lines += "| - | Use !auto, seo audit, prompt-lesson | 0 |"
}

$lines += @(
    ""
    "## Quick adds"
    ""
    "- Deliverables / Ne trogat / Gotovo kogda - mega tasks"
    "- /route <query> - task-router preview"
    "- prompt-coach-status - lesson readiness"
    ""
    "Full list: ai-tracking/PROMPT-HOOKS.md"
    ""
    "*Generated: $(Get-Date -Format o)*"
)

$lines -join "`n" | Set-Content $outPath -Encoding UTF8
Complete-Cheatsheet -MonthSlug $month -HubRoot $HubRoot
Write-Host "Wrote: $outPath" -ForegroundColor Green
