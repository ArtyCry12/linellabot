# RTK — token-efficient terminal output (Cursor preToolUse hook)

$ErrorActionPreference = "Stop"

function Get-DefaultRtkHubRoot {
    Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
}

function Get-RtkPaths {
    param([string]$HubRoot = "")
    if (-not $HubRoot) { $HubRoot = Get-DefaultRtkHubRoot }
    $toolsDir = Join-Path $HubRoot "tools\rtk"
    [PSCustomObject]@{
        HubRoot     = $HubRoot
        ToolsDir    = $toolsDir
        ExePath     = Join-Path $toolsDir "rtk.exe"
        HooksPath   = Join-Path $HubRoot "hooks.json"
        HookScript  = Join-Path $HubRoot "hooks\rtk-cursor-hook.ps1"
        HealthPath  = Join-Path $HubRoot "ai-tracking\rtk-health.json"
        InstallScript = Join-Path $HubRoot "commands\install-rtk-binary.ps1"
    }
}

function Test-RtkInstalled {
    param([string]$HubRoot = "")
    $paths = Get-RtkPaths -HubRoot $HubRoot
    if (-not (Test-Path $paths.ExePath)) { return $false }
    $prev = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        & $paths.ExePath --version 2>&1 | Out-Null
        return $LASTEXITCODE -eq 0
    }
    finally {
        $ErrorActionPreference = $prev
    }
}

function Get-RtkVersion {
    param([string]$HubRoot = "")
    $paths = Get-RtkPaths -HubRoot $HubRoot
    if (-not (Test-Path $paths.ExePath)) { return $null }
    $prev = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $out = & $paths.ExePath --version 2>&1 | Out-String
        return ($out -replace '\s+', ' ').Trim()
    }
    finally {
        $ErrorActionPreference = $prev
    }
}

function Test-RtkCursorHook {
    param([string]$HubRoot = "")
    $paths = Get-RtkPaths -HubRoot $HubRoot
    if (-not (Test-Path $paths.HooksPath)) { return $false }
    $hj = Get-Content $paths.HooksPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if (-not $hj.hooks.preToolUse) { return $false }
    foreach ($h in $hj.hooks.preToolUse) {
        if ($h.matcher -eq "Shell" -and $h.command -match "rtk-cursor-hook\.ps1") {
            return $true
        }
    }
    return $false
}

function Merge-RtkCursorHook {
    param(
        [string]$HubRoot = "",
        [switch]$Force
    )
    $paths = Get-RtkPaths -HubRoot $HubRoot
    if (-not (Test-Path $paths.HooksPath)) {
        throw "hooks.json not found at $($paths.HooksPath)"
    }

    $backup = "$($paths.HooksPath).pre-rtk-merge.bak"
    Copy-Item $paths.HooksPath $backup -Force

    $raw = Get-Content $paths.HooksPath -Raw -Encoding UTF8
    $hj = $raw | ConvertFrom-Json

    if (-not $hj.hooks) {
        $hj | Add-Member -NotePropertyName hooks -NotePropertyValue ([PSCustomObject]@{}) -Force
    }

    $entry = [PSCustomObject]@{
        command = "powershell -NoProfile -ExecutionPolicy Bypass -File hooks/rtk-cursor-hook.ps1"
        matcher = "Shell"
    }

    $list = @()
    if ($hj.hooks.preToolUse) {
        $list = @($hj.hooks.preToolUse)
    }

    $hasRtk = $false
    foreach ($h in $list) {
        if ($h.command -match "rtk") { $hasRtk = $true; break }
    }

    if ($hasRtk -and -not $Force) {
        return [PSCustomObject]@{
            Changed = $false
            Backup = $backup
            Message = "RTK preToolUse already present"
        }
    }

    if ($hasRtk -and $Force) {
        $list = @($list | Where-Object { $_.command -notmatch "rtk" })
    }

    $list += $entry
    $hj.hooks | Add-Member -NotePropertyName preToolUse -NotePropertyValue $list -Force

    ($hj | ConvertTo-Json -Depth 10) | Set-Content -Path $paths.HooksPath -Encoding UTF8

    [PSCustomObject]@{
        Changed = $true
        Backup  = $backup
        Message = "Added preToolUse Shell hook via rtk-cursor-hook.ps1"
    }
}
