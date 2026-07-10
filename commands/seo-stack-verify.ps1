param(
    [string]$HubRoot = "C:\Users\Asus\.cursor"
)

$ErrorActionPreference = "Continue"
$report = Join-Path $HubRoot "ai-tracking\SEO-STACK-VERIFY-$(Get-Date -Format yyyy-MM-dd).md"
$lines = @("# SEO stack verify (REQ-024)", "", "Date: $(Get-Date -Format o)", "", "| Tool | Status | Version |", "|------|--------|---------|")

function Test-Tool($name, $args) {
    try {
        $v = & npx --yes $name @args 2>&1 | Select-Object -First 1
        $ok = $v -match '\d|v\d'
        $script:lines += "| $name | $(if ($ok) {'OK'} else {'FAIL'}) | $v |"
    } catch {
        $script:lines += "| $name | FAIL | $($_.Exception.Message) |"
    }
}

Test-Tool "lighthouse" @("--version")
Test-Tool "htmlhint" @("--version")
Test-Tool "eslint" @("--version")
Test-Tool "stylelint" @("--version")
Test-Tool "@lhci/cli" @("--version")

try {
    $curl = curl --version 2>&1 | Select-Object -First 1
    $lines += "| curl | OK | $curl |"
} catch {
    $lines += "| curl | FAIL | |"
}

if (Get-Command jq -ErrorAction SilentlyContinue) {
    $jq = jq --version 2>&1
    $lines += "| jq | OK | $jq |"
} else {
    $lines += "| jq | SKIP | optional on Windows |"
}

$fail = ($lines | Select-String "\| FAIL \|").Count
$lines += ""
$lines += "Failures: **$fail**"

$lines -join "`n" | Set-Content $report -Encoding UTF8
Write-Host "Report: $report"
