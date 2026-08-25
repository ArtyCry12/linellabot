param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"
$fail = 0

function Assert($cond, [string]$msg) {
    if (-not $cond) {
        Write-Host "FAIL: $msg" -ForegroundColor Red
        $script:fail++
    }
    else {
        Write-Host "OK: $msg" -ForegroundColor Green
    }
}

Write-Host "=== Personalization test ===" -ForegroundColor Cyan

# profile UTF-8
$profilePath = Join-Path $HubRoot "ai-tracking\user-profile\profile.json"
Assert (Test-Path $profilePath) "profile.json exists"
if (Test-Path $profilePath) {
    $raw = Get-Content $profilePath -Raw -Encoding UTF8
    $p = $raw | ConvertFrom-Json
    $name = [string]$p.entrepreneur.name
    Assert ($name.Length -gt 0 -and $name -notmatch '^\?+$') "profile name readable (UTF-8)"
    Assert ($null -ne $p.automationPrefs) "automationPrefs present"
}

# rules + hooks
Assert (Test-Path (Join-Path $HubRoot "rules\user-profile.mdc")) "user-profile.mdc"
$hooks = Get-Content (Join-Path $HubRoot "hooks.json") -Raw -Encoding UTF8 | ConvertFrom-Json
$hookCmds = @($hooks.hooks.beforeSubmitPrompt | ForEach-Object { $_.command })
Assert ($hookCmds -match 'user-profile-intake') "user-profile-intake in hooks.json"

# router routes
$routes = Get-Content (Join-Path $HubRoot "lib\task-router\routes.json") -Raw -Encoding UTF8 | ConvertFrom-Json
$ids = @($routes.routes | ForEach-Object { $_.id })
Assert ($ids -contains 'clarify-first') "clarify-first route"
Assert ($ids -contains 'video-learning') "video-learning route"
Assert ($ids -contains 'notion-tasks') "notion-tasks route"

# skills
Assert (Test-Path (Join-Path $HubRoot "skills\notion-tasks\SKILL.md")) "notion-tasks skill"
Assert (Test-Path (Join-Path $HubRoot "skills\video-learning\SKILL.md")) "video-learning skill"

# coach artifacts
Assert (Test-Path (Join-Path $HubRoot "commands\prompt-lesson-tts.ps1")) "prompt-lesson-tts.ps1"
Assert (Test-Path (Join-Path $HubRoot "templates\marketing\landing-brief.md")) "landing-brief template"

# profile lib inject
. (Join-Path $HubRoot "lib\user-profile\UserProfile.ps1")
$ctx = Format-UserProfileContext -HubRoot $HubRoot
Assert ($ctx -match 'USER PROFILE') "profile context formats"
Assert ($ctx -match 'RU|Russian') "profile mentions language"

# route samples
. (Join-Path $HubRoot "lib\task-router\Resolve-TaskRoute.ps1")
$r1 = Resolve-TaskRoute -Prompt "learn from video youtube url summary" -HubRoot $HubRoot
Assert ($r1.Matches.Count -gt 0 -and $r1.Matches[0].Id -eq 'video-learning') "video-learning matches"

$r2 = Resolve-TaskRoute -Prompt "notion.so задачи галочки" -HubRoot $HubRoot
Assert ($r2.Matches.Count -gt 0 -and $r2.Matches[0].Id -eq 'notion-tasks') "notion-tasks matches"

Write-Host ""
if ($fail -eq 0) {
    Write-Host "PERSONALIZATION: 0 FAIL" -ForegroundColor Green
    exit 0
}
Write-Host "PERSONALIZATION: $fail FAIL" -ForegroundColor Red
exit 1
