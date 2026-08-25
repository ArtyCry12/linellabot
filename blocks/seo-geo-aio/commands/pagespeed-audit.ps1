param(
    [Parameter(Mandatory = $true)][string]$Url,
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [ValidateSet("mobile", "desktop")][string]$Strategy = "mobile"
)

$secrets = Join-Path $HubRoot "ai-tracking\secrets.local.json"
$key = $env:PAGESPEED_API_KEY
if (-not $key -and (Test-Path $secrets)) {
    $key = (Get-Content $secrets -Raw | ConvertFrom-Json).PAGESPEED_API_KEY
}
if (-not $key) { throw "Set PAGESPEED_API_KEY in secrets.local.json or env" }

$encoded = [uri]::EscapeDataString($Url)
$api = "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=$encoded&strategy=$Strategy&key=$key"
$result = Invoke-RestMethod -Uri $api -UseBasicParsing
$out = Join-Path $HubRoot "ai-tracking\pagespeed-last.json"
$result | ConvertTo-Json -Depth 8 | Set-Content $out -Encoding UTF8
$score = $result.lighthouseResult.categories.performance.score * 100
Write-Host "Performance ($Strategy): $([math]::Round($score)) — saved $out"
