# User profile loader — quiz-derived preferences for hooks (token-compact)

$ErrorActionPreference = "Stop"

function Get-UserProfileHubRoot {
    param([string]$HubRoot = "")
    if (-not $HubRoot) {
        $HubRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
        if (-not (Test-Path (Join-Path $HubRoot "hooks.json"))) {
            $HubRoot = "C:\Users\Asus\.cursor"
        }
    }
    return $HubRoot
}

function Get-UserProfile {
    param([string]$HubRoot = "")
    $HubRoot = Get-UserProfileHubRoot -HubRoot $HubRoot
    $path = Join-Path $HubRoot "ai-tracking\user-profile\profile.json"
    if (-not (Test-Path $path)) { return $null }
    return Get-Content $path -Raw -Encoding UTF8 | ConvertFrom-Json
}

function Test-ProfileInjectDue {
    param(
        [string]$HubRoot = "",
        [int]$CooldownMinutes = 45
    )
    $HubRoot = Get-UserProfileHubRoot -HubRoot $HubRoot
    $stamp = Join-Path $HubRoot "ai-tracking\user-profile\.last-inject"
    if (-not (Test-Path $stamp)) { return $true }
    try {
        $t = Get-Content $stamp -Raw -Encoding UTF8
        $dt = [DateTime]::Parse($t.Trim())
        return ((Get-Date) - $dt).TotalMinutes -ge $CooldownMinutes
    }
    catch {
        return $true
    }
}

function Set-ProfileInjectStamp {
    param([string]$HubRoot = "")
    $HubRoot = Get-UserProfileHubRoot -HubRoot $HubRoot
    $dir = Join-Path $HubRoot "ai-tracking\user-profile"
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    (Get-Date).ToUniversalTime().ToString("o") | Set-Content (Join-Path $dir ".last-inject") -Encoding UTF8
}

function Format-UserProfileContext {
    param(
        [string]$HubRoot = "",
        [switch]$Force
    )
    if (-not $Force -and -not (Test-ProfileInjectDue -HubRoot $HubRoot)) {
        return ""
    }

    $p = Get-UserProfile -HubRoot $HubRoot
    if (-not $p) { return "" }

    $name = if ($p.entrepreneur.name) { [string]$p.entrepreneur.name } else { "user" }
    $mode = if ($p.automationPrefs.defaultMode) { [string]$p.automationPrefs.defaultMode } else { "confirm-writes" }
    $auton = if ($p.entrepreneur.autonomyPref) { [string]$p.entrepreneur.autonomyPref } else { "plan-first" }
    $top = ""
    if ($p.systemFixes -and $p.systemFixes.Count -gt 0 -and $p.systemFixes[-1].topFix) {
        $top = [string]$p.systemFixes[-1].topFix
        if ($top.Length -gt 60) { $top = $top.Substring(0, 60) }
    }

    $lines = @(
        "[USER PROFILE]",
        "User=$name | RU plain | autonomy=$auton | auto=$mode",
        "Ask full questions BEFORE big tasks only. Mid-run: only commit/push/deploy/delete/secrets.",
        "Humanizer on audits/lessons/client copy. Use real SKILL.md."
    )
    if ($top) { $lines += "TopFix: $top" }

    Set-ProfileInjectStamp -HubRoot $HubRoot
    return ($lines -join "`n")
}
