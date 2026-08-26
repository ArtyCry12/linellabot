# Sync agency-agents Cursor rules into hub (selected divisions)
param(
    [string]$RepoRoot = (Join-Path $env:USERPROFILE "projects\agency-agents"),
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [string]$Divisions = "marketing,sales,design,product,paid-media",
    [switch]$Convert
)

$bash = "C:\Program Files\Git\bin\bash.exe"
if (-not (Test-Path $bash)) { throw "Git Bash required at $bash" }
if (-not (Test-Path "$RepoRoot\.git")) {
    git clone --depth 1 https://github.com/msitarzewski/agency-agents.git $RepoRoot
}

# Git Bash paths: C:\Users\x → /c/Users/x
function ConvertTo-GitBashPath([string]$WinPath) {
    $p = $WinPath.Replace('\', '/')
    if ($p -match '^([A-Za-z]):/(.*)$') {
        return "/$($Matches[1].ToLower())/$($Matches[2])"
    }
    return $p
}

$repoBash = ConvertTo-GitBashPath $RepoRoot
$hubBash = ConvertTo-GitBashPath $HubRoot
$agencyRulesBash = ConvertTo-GitBashPath (Join-Path $HubRoot "rules\agency")

if ($Convert) {
    & $bash -lc "cd '$repoBash' && ./scripts/convert.sh --tool cursor"
}

$dest = "$HubRoot/rules/agency"
New-Item -ItemType Directory -Force -Path $dest | Out-Null

& $bash -lc @"
cd '$hubBash' && \
CURSOR_RULES_DIR='$agencyRulesBash' \
'$repoBash/scripts/install.sh' \
  --tool cursor --division '$Divisions' --no-interactive --no-convert
"@

$count = (Get-ChildItem $dest -Filter *.mdc -ErrorAction SilentlyContinue).Count
Write-Host "Agency rules in $dest : $count files"
