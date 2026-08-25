# Lightweight supply-chain inventory when bumblebee.exe unavailable (Windows)
param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [string[]]$Roots = @("C:\Users\Asus\.cursor", "C:\Users\Asus\projects")
)

$out = Join-Path $HubRoot "ai-tracking\hub-supply-scan.json"
$records = @()

foreach ($root in $Roots) {
    if (-not (Test-Path $root)) { continue }
    $mcp = Get-ChildItem $root -Recurse -Filter "mcp.json" -ErrorAction SilentlyContinue | Select-Object -First 20
    foreach ($f in $mcp) {
        $records += [ordered]@{ type = "mcp-config"; path = $f.FullName; root = $root }
    }
    $locks = Get-ChildItem $root -Recurse -Include "package-lock.json","pnpm-lock.yaml","skills-lock.json" -ErrorAction SilentlyContinue | Select-Object -First 50
    foreach ($f in $locks) {
        $records += [ordered]@{ type = "lockfile"; path = $f.FullName; root = $root }
    }
}

$result = [ordered]@{
    scannedAt = (Get-Date).ToString("o")
    scanner   = "hub-supply-scan-fallback"
    note      = "Install bumblebee for full NDJSON inventory: commands/bumblebee-scan.ps1"
    count     = $records.Count
    records   = $records
}

New-Item -ItemType Directory -Force -Path (Split-Path $out) | Out-Null
$result | ConvertTo-Json -Depth 5 | Set-Content $out -Encoding UTF8
Write-Host "Wrote $out ($($records.Count) records)"
