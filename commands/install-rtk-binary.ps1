# Download RTK Windows binary
$ErrorActionPreference = "Stop"
$HubRoot = Split-Path $PSScriptRoot -Parent
$tools = Join-Path $HubRoot "tools\rtk"
New-Item -ItemType Directory -Force -Path $tools | Out-Null
$zip = Join-Path $env:TEMP "rtk-win.zip"
$url = "https://github.com/rtk-ai/rtk/releases/latest/download/rtk-x86_64-pc-windows-msvc.zip"
Write-Host "Downloading $url ..."
Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
Expand-Archive -Path $zip -DestinationPath $tools -Force
$target = Join-Path $tools "rtk.exe"
$exe = Get-ChildItem -Path $tools -Filter "rtk.exe" -Recurse | Select-Object -First 1
if ($exe) {
    if ($exe.FullName -ne $target) {
        Copy-Item $exe.FullName $target -Force
    }
    Write-Host "OK: $target"
}
& (Join-Path $tools "rtk.exe") --version
