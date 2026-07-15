# Find skills on skills.sh (npx skills find)
param(
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [string]$Owner = "",
    [switch]$Raw
)

$ErrorActionPreference = "Continue"

$argsList = @("skills", "find", $Query)
if ($Owner) {
    $argsList += @("--owner", $Owner)
}

Write-Host "npx $($argsList -join ' ')" -ForegroundColor Cyan
& npx.cmd @argsList
$exit = $LASTEXITCODE
if ($null -eq $exit) { $exit = 0 }
exit $exit
