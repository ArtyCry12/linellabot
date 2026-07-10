# Links Matt Pocock skills-main sub-skills into ~/.cursor/skills/ as directory junctions.
# Re-run after updating the bundle under skills-main-top-coding/skills-main.

$ErrorActionPreference = 'Stop'

$RepoRoot = Join-Path $env:USERPROFILE '.cursor\skills\skills-main-top-coding\skills-main'
$DestRoot = Join-Path $env:USERPROFILE '.cursor\skills'

$SkipNames = @(
  'mattpocock-skills',
  'skills-main-top-coding',
  'clone-website',
  'huashu-design'
)

if (-not (Test-Path $RepoRoot)) {
  Write-Error "Bundle not found: $RepoRoot`nExtract skills-main zip there first."
}

$linked = 0
$skipped = 0

Get-ChildItem -Path (Join-Path $RepoRoot 'skills') -Recurse -Filter 'SKILL.md' |
  Where-Object { $_.FullName -notmatch '[\\/]deprecated[\\/]' } |
  ForEach-Object {
    $src = $_.DirectoryName
    $name = Split-Path $src -Leaf

    if ($SkipNames -contains $name) {
      $skipped++
      return
    }

    $target = Join-Path $DestRoot $name

    if (Test-Path $target) {
      $item = Get-Item -LiteralPath $target -Force
      if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        Remove-Item -LiteralPath $target -Force
      }
      else {
        Write-Warning "Skip $name - non-junction folder already exists at $target"
        $skipped++
        return
      }
    }

    New-Item -ItemType Junction -Path $target -Target $src | Out-Null
    Write-Host "linked $name -> $src"
    $linked++
  }

Write-Host ""
Write-Host "Done. Linked: $linked, skipped: $skipped"
