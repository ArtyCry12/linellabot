# Sync selected Claude Code plugin skills into Cursor hub skills/
# Source: ~/.claude/plugins/cache/claude-plugins-official/
# Run after: claude plugin install <name>@claude-plugins-official

$ErrorActionPreference = 'Stop'
$HubSkills = (Join-Path (Join-Path $PSScriptRoot '..') 'skills') | Resolve-Path
$PluginRoot = Join-Path (Join-Path (Join-Path $env:USERPROFILE '.claude') 'plugins') 'cache\claude-plugins-official'

$map = @(
    @{
        Name = 'brainstorming'
        Source = Join-Path (Join-Path (Join-Path (Join-Path $PluginRoot 'superpowers') '6.1.1') 'skills') 'brainstorming'
    },
    @{
        Name = 'systematic-debugging'
        Source = Join-Path (Join-Path (Join-Path (Join-Path $PluginRoot 'superpowers') '6.1.1') 'skills') 'systematic-debugging'
    },
    @{
        Name = 'subagent-driven-development'
        Source = Join-Path (Join-Path (Join-Path (Join-Path $PluginRoot 'superpowers') '6.1.1') 'skills') 'subagent-driven-development'
    },
    @{
        Name = 'verification-before-completion'
        Source = Join-Path (Join-Path (Join-Path (Join-Path $PluginRoot 'superpowers') '6.1.1') 'skills') 'verification-before-completion'
    },
    @{
        Name = 'frontend-design'
        Source = Join-Path (Join-Path (Join-Path (Join-Path $PluginRoot 'frontend-design') 'unknown') 'skills') 'frontend-design'
    }
)

$ok = 0
$fail = 0
foreach ($item in $map) {
    $dest = Join-Path $HubSkills $item.Name
    if (-not (Test-Path $item.Source)) {
        Write-Warning "SKIP $($item.Name): source missing $($item.Source)"
        $fail++
        continue
    }
    if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
    Copy-Item -Path $item.Source -Destination $dest -Recurse -Force
    Write-Host "OK $($item.Name) -> $dest"
    $ok++
}

# pr-review is hub-native (not copied from plugin)
$prSkill = Join-Path (Join-Path $HubSkills 'pr-review') 'SKILL.md'
if (Test-Path $prSkill) {
    Write-Host "OK pr-review (hub-native)"
    $ok++
} else {
    Write-Warning "FAIL pr-review SKILL.md missing"
    $fail++
}

Write-Host "---"
Write-Host "Synced: $ok | Missing: $fail"
if ($fail -gt 0) { exit 1 }
