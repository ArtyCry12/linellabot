# Ensure Open Design sparse checkout under blocks/design/skills/open-design/repo
# Usage: powershell -File commands/ensure-open-design.ps1

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$Dest = Join-Path $RepoRoot "blocks\design\skills\open-design\repo"
$Url = "https://github.com/nexu-io/open-design.git"

if (-not (Test-Path (Join-Path $Dest ".git"))) {
  if (Test-Path $Dest) { Remove-Item $Dest -Recurse -Force }
  New-Item -ItemType Directory -Path $Dest -Force | Out-Null
  Push-Location $Dest
  try {
    git clone --filter=blob:none --sparse --depth 1 $Url .
    git sparse-checkout set --skip-checks skills design-templates plugins/open-design docs AGENTS.md QUICKSTART.md README.md CONTEXT.md
    git checkout
  } finally {
    Pop-Location
  }
  Write-Host "Cloned Open Design -> $Dest"
} else {
  Push-Location $Dest
  try {
    git fetch --depth 1 origin main
    git reset --hard origin/main
    git sparse-checkout set --skip-checks skills design-templates plugins/open-design docs AGENTS.md QUICKSTART.md README.md CONTEXT.md
  } finally {
    Pop-Location
  }
  Write-Host "Updated Open Design -> $Dest"
}

$skills = (Get-ChildItem (Join-Path $Dest "skills") -Directory -ErrorAction SilentlyContinue).Count
$templates = (Get-ChildItem (Join-Path $Dest "design-templates") -Directory -ErrorAction SilentlyContinue).Count
Write-Host "skills=$skills design-templates=$templates"

# Optional discovery junction: ~/.agents/skills/open-design -> hub skill bridge if present
$AgentsSkill = Join-Path $env:USERPROFILE ".agents\skills\open-design"
$HubSkill = Join-Path $RepoRoot "blocks\design\skills\open-design"
if ((Test-Path (Split-Path $AgentsSkill -Parent)) -and (Test-Path $HubSkill)) {
  if (Test-Path $AgentsSkill) {
    $item = Get-Item $AgentsSkill -Force
    if ($item.LinkType -eq "Junction" -or $item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
      cmd /c "rmdir `"$AgentsSkill`""
    } else {
      Remove-Item $AgentsSkill -Recurse -Force -ErrorAction SilentlyContinue
    }
  }
  cmd /c "mklink /J `"$AgentsSkill`" `"$HubSkill`""
  Write-Host "Junction: $AgentsSkill -> $HubSkill"
}
