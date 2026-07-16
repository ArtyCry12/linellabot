param(
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [switch]$SkipEcc,
    [switch]$SkipMarkitdown
)

$ErrorActionPreference = "Stop"
$steps = @(
    @{ name = "markitdown"; script = "commands\ensure-markitdown.ps1"; skip = $SkipMarkitdown }
    @{ name = "ecc"; script = "commands\ensure-ecc.ps1"; skip = $SkipEcc }
    @{ name = "playwright-mcp"; script = "commands\ensure-playwright-mcp.ps1"; skip = $false }
)

$fail = 0
foreach ($s in $steps) {
    if ($s.skip) { continue }
    $path = Join-Path $HubRoot $s.script
    if (-not (Test-Path $path)) {
        Write-Host "SKIP: $($s.name) — script missing" -ForegroundColor Yellow
        continue
    }
    Write-Host "`n--- $($s.name) ---" -ForegroundColor Cyan
    & $path -HubRoot $HubRoot
    if ($LASTEXITCODE -ne 0) { $fail++ }
}

& (Join-Path $HubRoot "commands\mcp-health.ps1") -HubRoot $HubRoot
if ($LASTEXITCODE -ne 0) { $fail++ }

if ($fail -eq 0) { exit 0 }
exit 1
