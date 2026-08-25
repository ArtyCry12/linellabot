# Sync agency-agents Cursor rules into hub (selected divisions)
param(
    [string]$RepoRoot = "C:\Users\Asus\projects\agency-agents",
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [string]$Divisions = "marketing,sales,design,product,paid-media",
    [switch]$Convert
)

$bash = "C:\Program Files\Git\bin\bash.exe"
if (-not (Test-Path $bash)) { throw "Git Bash required at $bash" }
if (-not (Test-Path "$RepoRoot\.git")) {
    git clone --depth 1 https://github.com/msitarzewski/agency-agents.git $RepoRoot
}

if ($Convert) {
    & $bash -lc "cd '/c/Users/Asus/projects/agency-agents' && ./scripts/convert.sh --tool cursor"
}

$dest = "$HubRoot/rules/agency"
New-Item -ItemType Directory -Force -Path $dest | Out-Null

& $bash -lc @"
cd '/c/Users/Asus/.cursor' && \
CURSOR_RULES_DIR='/c/Users/Asus/.cursor/rules/agency' \
'/c/Users/Asus/projects/agency-agents/scripts/install.sh' \
  --tool cursor --division '$Divisions' --no-interactive --no-convert
"@

$count = (Get-ChildItem $dest -Filter *.mdc -ErrorAction SilentlyContinue).Count
Write-Host "Agency rules in $dest : $count files"
