# PR review entry — routes to skills/pr-review/SKILL.md
# Usage: powershell -File commands/pr-review.ps1
# Agent: load skills/pr-review/SKILL.md and spawn squad-review

$skill = (Join-Path (Join-Path (Join-Path $PSScriptRoot '..') 'skills') 'pr-review\SKILL.md') | Resolve-Path
if (-not (Test-Path $skill)) {
    Write-Error "Missing $skill — run sync-claude-plugin-skills.ps1"
    exit 1
}

$gh = Get-Command gh -ErrorAction SilentlyContinue
if (-not $gh) {
    Write-Warning 'gh CLI not found — install GitHub CLI for PR comments'
}

Write-Host "pr-review: load $skill"
Write-Host "Spawn squad-review with confidence threshold >= 80"
Write-Host "User must approve before gh pr comment"
