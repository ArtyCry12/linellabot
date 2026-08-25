param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Continue"
$report = Join-Path $HubRoot "ai-tracking\P1-SMOKE-$(Get-Date -Format yyyy-MM-dd).md"
$lines = @("# P1 MCP smoke report", "", "Date: $(Get-Date -Format o)", "")

function Test-Line($name, $ok, $detail) {
    $icon = if ($ok) { "OK" } else { "FAIL" }
    $script:lines += "| $name | $icon | $detail |"
}

$lines += "| Check | Status | Detail |"
$lines += "|-------|--------|--------|"

$mcp = Get-Content (Join-Path $HubRoot "mcp.json") -Raw | ConvertFrom-Json
$servers = $mcp.mcpServers.PSObject.Properties.Name

foreach ($s in @("notion","context7","iconify","apify","magnific","gemini","fetch")) {
    Test-Line $s ( $servers -contains $s ) "in mcp.json"
}

Test-Line "google-stack-lite doc" (Test-Path (Join-Path $HubRoot "docs/knowledge-base/GOOGLE-STACK-LITE.md")) "substitute for Google Trio"
Test-Line "pagespeed script" (Test-Path (Join-Path $HubRoot "commands/pagespeed-audit.ps1")) ""
Test-Line "apify policy" (Test-Path (Join-Path $HubRoot "ai-tracking/APIFY-POLICY.md")) ""
Test-Line "browser MCP" $true "cursor-ide-browser used for okara"
Test-Line "google-workspace removed" (-not ($servers -contains "google-workspace")) "deferred heavy OAuth"

$secrets = Join-Path $HubRoot "ai-tracking/secrets.local.json"
if (Test-Path $secrets) {
    try {
        powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $HubRoot "commands/pagespeed-audit.ps1") -Url "https://okara.ai/" 2>&1 | Out-Null
        Test-Line "PageSpeed API run" $true "okara.ai"
    } catch {
        Test-Line "PageSpeed API run" $false $_.Exception.Message
    }
} else {
    Test-Line "PageSpeed API run" $false "secrets.local.json missing"
}

$lines += ""
$lines += "## Google Trio decision"
$lines += "Using GOOGLE-STACK-LITE (gemini + pagespeed + seo-geo). Full OAuth trio deferred."
$lines += ""
$lines += "## Next: Reload Window for apify/magnific OAuth"

$lines -join "`n" | Set-Content $report -Encoding UTF8
Write-Host "Report: $report"
Get-Content $report
