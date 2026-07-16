# Drain MarkItDown background queue (large files)
param(
    [string]$HubRoot = "",
    [int]$MaxItems = 10
)

$ErrorActionPreference = "Stop"
if (-not $HubRoot) { $HubRoot = Split-Path $PSScriptRoot -Parent }

. (Join-Path $HubRoot "lib\markitdown\MarkItDown.ps1")

if (-not (Test-MarkItDownInstalled -HubRoot $HubRoot)) {
    Write-Error "MarkItDown not installed. Run: commands/ensure-markitdown.ps1"
    exit 1
}

$r = Invoke-MarkItDownDrain -HubRoot $HubRoot -MaxItems $MaxItems
Write-Output "Processed: $($r.Processed), remaining: $($r.Remaining)"
foreach ($item in $r.Results) {
    Write-Output "  $($item.Source) -> $($item.Output)"
}
exit 0
