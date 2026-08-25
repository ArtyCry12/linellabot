param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Continue"
$report = Join-Path $HubRoot "ai-tracking\P3-FINAL-AUDIT-$(Get-Date -Format yyyy-MM-dd).md"

Write-Host "=== P3 final audit (REQ-007, 077) ===" -ForegroundColor Cyan

& (Join-Path $HubRoot "commands\p3-ready-check.ps1") -HubRoot $HubRoot
& (Join-Path $HubRoot "commands\p3-system-test.ps1") -HubRoot $HubRoot
& (Join-Path $HubRoot "commands\seo-stack-verify.ps1") -HubRoot $HubRoot

$lines = @(
    "# P3 Final Audit",
    "",
    "Date: $(Get-Date -Format o)",
    "",
    "## Reports",
    "- P3-READY-*.md",
    "- P3-SMOKE-*.md",
    "- SEO-STACK-VERIFY-*.md",
    "",
    "## Integrity (REQ-077)",
    ""
)

function Add-Check($name, $ok) {
    $mark = if ($ok) { "x" } else { " " }
    $script:lines += "- [$mark] $name"
}

Add-Check "REQ-STATUS.md" (Test-Path (Join-Path $HubRoot "ai-tracking/REQ-STATUS.md"))
Add-Check "POST-RELOAD-GUIDE.md" (Test-Path (Join-Path $HubRoot "docs/POST-RELOAD-GUIDE.md"))
Add-Check "P3-MANUAL-TEST-PLAYBOOK.md" (Test-Path (Join-Path $HubRoot "ai-tracking/P3-MANUAL-TEST-PLAYBOOK.md"))
Add-Check "hooks.json" (Test-Path (Join-Path $HubRoot "hooks.json"))
Add-Check "production-studio templates" ((Get-ChildItem (Join-Path $HubRoot "templates/production-studio") -ErrorAction SilentlyContinue).Count -ge 5)
Add-Check "DEC-056" (Test-Path (Join-Path $HubRoot "ai-tracking/decisions/DEC-056-unified-production.md"))
Add-Check "mode-routing rule" (Test-Path (Join-Path $HubRoot "rules/mode-routing.mdc"))

$mcpExample = Get-Content (Join-Path $HubRoot "mcp.json.example") -Raw
Add-Check "google-workspace in example" ($mcpExample -match "google-workspace")
Add-Check "google-maps in example" ($mcpExample -match "google-maps")

$lines += ""
$lines += "## User after Reload"
$lines += "1. Connect OAuth: notion (if needed), apify, magnific, google-workspace"
$lines += "2. Run quick tests from POST-RELOAD-GUIDE.md"
$lines += "3. Report issues in chat - we fix incrementally"

$lines -join "`n" | Set-Content $report -Encoding UTF8
Write-Host "Report: $report" -ForegroundColor Green
