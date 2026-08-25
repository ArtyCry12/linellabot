# Thin wrapper: authorized recon (subfinder → httpx → nuclei)
param(
    [string]$TargetHost = "",
    [string]$TargetUrl = "",
    [switch]$Authorized,
    [string]$HubRoot = "",
    [string]$OutDir = ""
)
$ErrorActionPreference = "Stop"
if (-not $HubRoot) { $HubRoot = Split-Path $PSScriptRoot -Parent }
$scan = Join-Path $HubRoot "commands\security-scan.ps1"
if (-not $Authorized) {
    Write-Error "REFUSED: pass -Authorized after confirming ownership. See skills/security-hub/references/auth-gate.md"
    exit 2
}
if (-not $TargetHost -and -not $TargetUrl) {
    Write-Error "Provide -TargetHost or -TargetUrl"
    exit 2
}
& $scan -Tier recon -TargetHost $TargetHost -TargetUrl $TargetUrl -Authorized -HubRoot $HubRoot -OutDir $OutDir
exit $LASTEXITCODE
