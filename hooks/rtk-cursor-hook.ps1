# Cursor preToolUse hook — compress Shell tool commands via RTK
$ErrorActionPreference = "Continue"

$HubRoot = Split-Path $PSScriptRoot -Parent
$rtk = Join-Path $HubRoot "tools\rtk\rtk.exe"

if (-not (Test-Path $rtk)) {
    # Fail open: do not block agent if RTK missing
    exit 0
}

$inputText = [Console]::In.ReadToEnd()
if (-not $inputText) { exit 0 }

$prev = $ErrorActionPreference
$ErrorActionPreference = "Continue"
try {
    $inputText | & $rtk hook cursor 2>&1 | Out-String | Write-Output
    exit $LASTEXITCODE
}
catch {
    exit 0
}
finally {
    $ErrorActionPreference = $prev
}
