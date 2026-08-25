param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [switch]$SkipPageSpeed
)

$ErrorActionPreference = "Continue"
$report = Join-Path $HubRoot "ai-tracking\P3-SMOKE-$(Get-Date -Format yyyy-MM-dd).md"
$lines = @(
    "# P3 system test + P1/P2 tail verification",
    "",
    "Date: $(Get-Date -Format o)",
    "REQ: 006, 007, 077",
    ""
)

function Test-Line($name, $ok, $detail) {
    $icon = if ($ok) { "OK" } else { "FAIL" }
    $script:lines += "| $name | $icon | $detail |"
}

$lines += "| Check | Status | Detail |"
$lines += "|-------|--------|--------|"

$mcpPath = Join-Path $HubRoot "mcp.json"
$mcp = Get-Content $mcpPath -Raw | ConvertFrom-Json
$servers = $mcp.mcpServers.PSObject.Properties.Name

# --- P1 tails ---
foreach ($s in @("notion", "context7", "iconify", "apify", "magnific", "gemini")) {
    Test-Line "P1 MCP: $s" ($servers -contains $s) "mcp.json"
}
Test-Line "P1: GOOGLE-STACK-LITE doc" (Test-Path (Join-Path $HubRoot "docs/knowledge-base/GOOGLE-STACK-LITE.md")) ""
Test-Line "P1: pagespeed script" (Test-Path (Join-Path $HubRoot "commands/pagespeed-audit.ps1")) ""
Test-Line "P1: apify policy" (Test-Path (Join-Path $HubRoot "ai-tracking/APIFY-POLICY.md")) ""
Test-Line "P1: google-workspace" ($servers -contains "google-workspace") "mcp.json"
Test-Line "P1: google-maps" ($servers -contains "google-maps") "mcp.json"

# --- P2 tails ---
$p2Rules = @(
    "subagent-guardrails.mdc",
    "seo-geo.mdc",
    "ai-coding-security.mdc",
    "notion-workspace.mdc",
    "design-stack.mdc"
)
foreach ($r in $p2Rules) {
    Test-Line "P2 rule: $r" (Test-Path (Join-Path $HubRoot "rules/$r")) ""
}
Test-Line "P2: P2-REPOS.md" (Test-Path (Join-Path $HubRoot "docs/knowledge-base/P2-REPOS.md")) "REQ-060-064"
Test-Line "P2: SEO-STACK.md" (Test-Path (Join-Path $HubRoot "docs/knowledge-base/SEO-STACK.md")) ""
Test-Line "P2: design-stack skill" (Test-Path (Join-Path $HubRoot "skills/design-stack/SKILL.md")) ""
Test-Line "P2: PROMPT-HOOKS" (Test-Path (Join-Path $HubRoot "ai-tracking/PROMPT-HOOKS.md")) ""
Test-Line "P2: autopilot slash" (Test-Path (Join-Path $HubRoot "commands/autopilot.md")) ""
Test-Line "P2: autopilot hook" (Test-Path (Join-Path $HubRoot "hooks/autopilot.ps1")) ""
Test-Line "P2: hooks.json" (Test-Path (Join-Path $HubRoot "hooks.json")) ""

# --- P3 artifacts ---
Test-Line "P3: LVM-PIPELINE" (Test-Path (Join-Path $HubRoot "ai-tracking/production-studio/LVM-PIPELINE.md")) ""
Test-Line "P3: storyboard-director" (Test-Path (Join-Path $HubRoot "skills/production-studio/references/storyboard-director.md")) ""
Test-Line "P3: OMNI architecture" (Test-Path (Join-Path $HubRoot "ai-tracking/production-studio/OMNI-REEL-ARCHITECTURE.md")) ""
Test-Line "P3: viral refs (18)" ((Get-ChildItem (Join-Path $HubRoot "ai-tracking/production-studio/refs/REF-*.md") -ErrorAction SilentlyContinue).Count -ge 18) ""
Test-Line "P3: selling sites plan" (Test-Path (Join-Path $HubRoot "docs/knowledge-base/SELLING-SITES-LEARNING.md")) "REQ-047-048"
Test-Line "P3: PROJECT-MANAGER" (Test-Path (Join-Path $HubRoot "docs/knowledge-base/PROJECT-MANAGER.md")) "REQ-061"
Test-Line "P3: manual playbook" (Test-Path (Join-Path $HubRoot "ai-tracking/P3-MANUAL-TEST-PLAYBOOK.md")) ""
Test-Line "P3: DEC-056" (Test-Path (Join-Path $HubRoot "ai-tracking/decisions/DEC-056-unified-production.md")) ""
Test-Line "P3: studio ARCHITECTURE" (Test-Path (Join-Path $HubRoot "ai-tracking/production-studio/ARCHITECTURE.md")) ""
Test-Line "P3: segment-splitter" (Test-Path (Join-Path $HubRoot "skills/production-studio/references/segment-splitter.md")) ""
Test-Line "P3: live-action module" (Test-Path (Join-Path $HubRoot "skills/production-studio/references/live-action-module.md")) ""
Test-Line "P3: templates (5)" ((Get-ChildItem (Join-Path $HubRoot "templates/production-studio/*") -ErrorAction SilentlyContinue).Count -ge 5) ""
Test-Line "P3: slash storyboard" (Test-Path (Join-Path $HubRoot "commands/storyboard.md")) ""
Test-Line "P3: selling CRO checklist" (Test-Path (Join-Path $HubRoot "docs/knowledge-base/SELLING-SITE-MANUAL-CHECKLIST.md")) ""

# --- CLI tools ---
@("lighthouse", "htmlhint", "eslint") | ForEach-Object {
    try {
        $v = npx --yes $_ --version 2>&1 | Select-Object -First 1
        Test-Line "CLI: $_" ($v -match '\d') $v
    } catch {
        Test-Line "CLI: $_" $false $_.Exception.Message
    }
}
try {
    $uv = uv --version 2>&1 | Select-Object -First 1
    Test-Line "CLI: uv" ($uv -match 'uv') $uv
} catch {
    Test-Line "CLI: uv" $false "not found"
}

# --- Hook smoke ---
$hookScript = Join-Path $HubRoot "hooks/autopilot.ps1"
if (Test-Path $hookScript) {
    $hookOut = '{"prompt":"!auto test"}' | powershell -NoProfile -ExecutionPolicy Bypass -File $hookScript 2>&1
    Test-Line "Hook: autopilot !auto" ($hookOut -match "AUTOPILOT") ($hookOut.Substring(0, [Math]::Min(80, $hookOut.Length)))
}

# --- PageSpeed (optional) ---
if (-not $SkipPageSpeed) {
    $secrets = Join-Path $HubRoot "ai-tracking/secrets.local.json"
    if (Test-Path $secrets) {
        try {
            powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $HubRoot "commands/pagespeed-audit.ps1") -Url "https://okara.ai/" 2>&1 | Out-Null
            Test-Line "PageSpeed live" $true "okara.ai"
        } catch {
            Test-Line "PageSpeed live" $false $_.Exception.Message
        }
    } else {
        Test-Line "PageSpeed live" $false "secrets.local.json missing"
    }
}

# --- Extension ---
$ext = code --list-extensions 2>&1 | Select-String "alefragnani.project-manager"
Test-Line "REQ-061 extension" ($null -ne $ext) "alefragnani.project-manager"

$failCount = ($lines | Select-String "\| FAIL \|").Count
$lines += ""
$lines += "## Summary"
$lines += "Failures: **$failCount**"
$lines += ""
if ($failCount -gt 0) {
    $lines += "Fix FAIL rows before claiming P3 test complete."
} else {
    $lines += "All automated checks passed. Manual: Reload Window for apify/magnific OAuth if not done."
}

$lines -join "`n" | Set-Content $report -Encoding UTF8
Write-Host "Report: $report" -ForegroundColor Cyan
Get-Content $report
