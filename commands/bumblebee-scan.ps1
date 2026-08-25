# Supply-chain inventory scan via bumblebee (download binary if Go missing)
param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [ValidateSet("baseline", "project", "deep")]
    [string]$Profile = "project"
)

$toolsDir = Join-Path $HubRoot "tools\bumblebee"
$exe = Join-Path $toolsDir "bumblebee.exe"
$out = Join-Path $HubRoot "ai-tracking\bumblebee-inventory.ndjson"
$roots = @($HubRoot, "C:\Users\Asus\projects")

function Ensure-Bumblebee {
    if (Test-Path $exe) { return $true }
    New-Item -ItemType Directory -Force -Path $toolsDir | Out-Null
    $tag = "v0.1.2"
    $assetName = "bumblebee_0.1.2_linux_amd64.tar.gz"
    $url = "https://github.com/perplexityai/bumblebee/releases/download/$tag/$assetName"
    $tgz = Join-Path $env:TEMP "bumblebee-linux.tgz"
    try {
        Invoke-WebRequest -Uri $url -OutFile $tgz -UseBasicParsing
        & tar -xzf $tgz -C $toolsDir
        $linux = Get-ChildItem $toolsDir -Recurse -Filter "bumblebee" -File | Where-Object { $_.Extension -eq "" } | Select-Object -First 1
        if ($linux) {
            Copy-Item $linux.FullName (Join-Path $toolsDir "bumblebee-linux") -Force
            return $true
        }
    } catch {
        Write-Host "WARN: bumblebee download failed: $_"
    }
    return $false
}

$hasBumblebee = Ensure-Bumblebee
New-Item -ItemType Directory -Force -Path (Split-Path $out) | Out-Null

if (-not $hasBumblebee) {
    Write-Host "No Windows bumblebee binary — running hub-supply-scan fallback"
    & (Join-Path $HubRoot "commands\hub-supply-scan.ps1") -HubRoot $HubRoot
    exit 0
}

$linuxBin = Join-Path $toolsDir "bumblebee-linux"
if (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
    $wslRootArgs = ($roots | ForEach-Object {
        $p = ($_.Replace('\','/') -replace '^C:','/mnt/c')
        "--root `"$p`""
    }) -join ' '
    wsl.exe -- bash -lc "chmod +x '/mnt/c/Users/Asus/.cursor/tools/bumblebee/bumblebee-linux' && '/mnt/c/Users/Asus/.cursor/tools/bumblebee/bumblebee-linux' scan --profile $Profile $wslRootArgs" | Set-Content $out -Encoding UTF8
    Write-Host "Wrote $out (via WSL + linux bumblebee)"
    exit 0
}

Write-Host "WSL not available — hub-supply-scan fallback"
& (Join-Path $HubRoot "commands\hub-supply-scan.ps1") -HubRoot $HubRoot
