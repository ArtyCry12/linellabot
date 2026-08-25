param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Continue"
$report = Join-Path $HubRoot "ai-tracking\P3-READY-$(Get-Date -Format yyyy-MM-dd).md"
$lines = @(
    "# P3 ready-for-manual-test check",
    "",
    "Date: $(Get-Date -Format o)",
    "Playbook: ai-tracking/P3-MANUAL-TEST-PLAYBOOK.md",
    ""
)

function Test-Line($name, $ok, $detail) {
    $icon = if ($ok) { "OK" } else { "FAIL" }
    $script:lines += "| $name | $icon | $detail |"
}

$lines += "| Artifact | Status | Detail |"
$lines += "|----------|--------|--------|"

$required = @(
    @{ N = "P3 manual playbook"; P = "ai-tracking/P3-MANUAL-TEST-PLAYBOOK.md" },
    @{ N = "DEC-056 decision"; P = "ai-tracking/decisions/DEC-056-unified-production.md" },
    @{ N = "Studio ARCHITECTURE"; P = "ai-tracking/production-studio/ARCHITECTURE.md" },
    @{ N = "Studio GAP-ANALYSIS"; P = "ai-tracking/production-studio/GAP-ANALYSIS.md" },
    @{ N = "LVM-PIPELINE"; P = "ai-tracking/production-studio/LVM-PIPELINE.md" },
    @{ N = "MONEYPRINTER-PATTERNS"; P = "ai-tracking/production-studio/MONEYPRINTER-PATTERNS.md" },
    @{ N = "module shared"; P = "ai-tracking/production-studio/modules/shared/README.md" },
    @{ N = "module ai-lvm"; P = "ai-tracking/production-studio/modules/ai-lvm/README.md" },
    @{ N = "module live-action"; P = "ai-tracking/production-studio/modules/live-action/README.md" },
    @{ N = "ref segment-splitter"; P = "skills/production-studio/references/segment-splitter.md" },
    @{ N = "ref style-lock"; P = "skills/production-studio/references/style-lock.md" },
    @{ N = "ref live-action"; P = "skills/production-studio/references/live-action-module.md" },
    @{ N = "ref storyboard-director"; P = "skills/production-studio/references/storyboard-director.md" },
    @{ N = "tpl project-brief"; P = "templates/production-studio/project-brief.md" },
    @{ N = "tpl segment-manifest"; P = "templates/production-studio/segment-manifest.json" },
    @{ N = "tpl storyboard-table"; P = "templates/production-studio/storyboard-table.md" },
    @{ N = "tpl live-shoot-brief"; P = "templates/production-studio/live-shoot-brief.md" },
    @{ N = "tpl qc-gate"; P = "templates/production-studio/qc-gate.md" },
    @{ N = "slash storyboard"; P = "commands/storyboard.md" },
    @{ N = "slash production-studio"; P = "commands/production-studio.md" },
    @{ N = "selling CRO checklist"; P = "docs/knowledge-base/SELLING-SITE-MANUAL-CHECKLIST.md" },
    @{ N = "selling learning plan"; P = "docs/knowledge-base/SELLING-SITES-LEARNING.md" },
    @{ N = "transcribe-video"; P = "commands/transcribe-video.ps1" },
    @{ N = "p3-system-test"; P = "commands/p3-system-test.ps1" },
    @{ N = "post-reload guide"; P = "docs/POST-RELOAD-GUIDE.md" },
    @{ N = "REQ-STATUS"; P = "ai-tracking/REQ-STATUS.md" },
    @{ N = "P3-COMPLETE"; P = "ai-tracking/P3-COMPLETE.md" },
    @{ N = "gsc-audit.ps1"; P = "commands/gsc-audit.ps1" },
    @{ N = "p3-final-audit"; P = "commands/p3-final-audit.ps1" },
    @{ N = "mode-routing"; P = "rules/mode-routing.mdc" },
    @{ N = "slash lvm-segment"; P = "commands/lvm-segment.md" }
)

foreach ($r in $required) {
    $full = Join-Path $HubRoot $r.P
    Test-Line $r.N (Test-Path $full) $r.P
}

$refCount = (Get-ChildItem (Join-Path $HubRoot "ai-tracking/production-studio/refs/REF-*.md") -ErrorAction SilentlyContinue).Count
Test-Line "viral refs count" ($refCount -ge 18) "$refCount files"

$failCount = ($lines | Select-String "\| FAIL \|").Count
$lines += ""
$lines += "## Verdict"
if ($failCount -eq 0) {
    $lines += "**BUILD COMPLETE** - POST-RELOAD-GUIDE.md then user tests"
} else {
    $lines += "**NOT READY** - fix $failCount FAIL rows"
}
$lines += ""
$lines += "Failures: **$failCount**"

$lines -join "`n" | Set-Content $report -Encoding UTF8
Write-Host $report -ForegroundColor Cyan
if ($failCount -gt 0) { exit 1 }
exit 0
