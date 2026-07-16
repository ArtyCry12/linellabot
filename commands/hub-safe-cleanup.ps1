# Safe cleanup while Cursor may be running — caches, old logs, skip locked paths
param(
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [switch]$Apply,
    [int]$LogDays = 30,
    # MarkItDown cache is sacred by default (DEC + always-on hook). Opt-in only.
    [switch]$IncludeMarkitdownCache
)

$ErrorActionPreference = "Continue"
$report = [System.Collections.Generic.List[object]]::new()
$freed = 0L

function Try-Delete {
    param([string]$Path, [string]$Label)
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $size = 0L
    try {
        if ((Get-Item -LiteralPath $Path -Force).PSIsContainer) {
            $files = @(Get-ChildItem -LiteralPath $Path -Recurse -Force -File -ErrorAction SilentlyContinue)
            if ($files.Count -gt 0) {
                $size = [long](($files | Measure-Object -Property Length -Sum).Sum)
            }
        }
        else {
            $size = [long](Get-Item -LiteralPath $Path -Force).Length
        }
    }
    catch { }

    if (-not $Apply) {
        $script:report.Add([pscustomobject]@{ action = "DRY"; label = $Label; mb = [math]::Round($size / 1MB, 2) })
        return
    }

    try {
        Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction Stop
        $script:freed += $size
        $script:report.Add([pscustomobject]@{ action = "DEL"; label = $Label; mb = [math]::Round($size / 1MB, 2) })
    }
    catch {
        $script:report.Add([pscustomobject]@{ action = "SKIP"; label = $Label; mb = [math]::Round($size / 1MB, 2); err = $_.Exception.Message })
    }
}

Write-Host "=== Hub safe cleanup (Apply=$Apply) ===" -ForegroundColor Cyan

# MarkItDown cache — skipped unless -IncludeMarkitdownCache
if ($IncludeMarkitdownCache) {
    Try-Delete (Join-Path $HubRoot ".cache\markitdown") "markitdown cache"
}
else {
    $script:report.Add([pscustomobject]@{ action = "KEEP"; label = "markitdown cache (sacred)"; mb = 0 })
}

# Scratch / probe files at hub root
Get-ChildItem -LiteralPath $HubRoot -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match '^(_probe|_read_|_do_|_dump_|_find_|_finish_|_scan_|_stash_)' } |
    ForEach-Object { Try-Delete $_.FullName $_.Name }

# Old cleanup / deferred logs
$track = Join-Path $HubRoot "ai-tracking"
$archive = Join-Path $track "archive"
if ($Apply -and -not (Test-Path $archive)) {
    New-Item -ItemType Directory -Force -Path $archive | Out-Null
}
$cutoff = (Get-Date).AddDays(-$LogDays)
Get-ChildItem -LiteralPath $track -File -ErrorAction SilentlyContinue |
    Where-Object {
        ($_.Name -match '^(cleanup-log-|deferred-refresh-|system-audit-)') -and
        $_.LastWriteTime -lt $cutoff
    } |
    ForEach-Object {
        if ($Apply) {
            Move-Item -LiteralPath $_.FullName -Destination (Join-Path $archive $_.Name) -Force -ErrorAction SilentlyContinue
            $script:report.Add([pscustomobject]@{ action = "ARC"; label = $_.Name; mb = [math]::Round($_.Length / 1MB, 2) })
        }
        else {
            $script:report.Add([pscustomobject]@{ action = "DRY-ARC"; label = $_.Name; mb = [math]::Round($_.Length / 1MB, 2) })
        }
    }

# Root node_modules / .next (non-essential)
Try-Delete (Join-Path $HubRoot "node_modules") "hub node_modules"
Try-Delete (Join-Path $HubRoot ".next") "hub .next"
Try-Delete (Join-Path $HubRoot "skills\clone-website\template\node_modules") "clone-website template node_modules"

# Ephemeral temp project folders
$projectsDir = Join-Path $HubRoot "projects"
if (Test-Path $projectsDir) {
    Get-ChildItem -LiteralPath $projectsDir -Directory -ErrorAction SilentlyContinue |
        Where-Object {
            $_.Name -match '^\d+$' -or
            $_.Name -match '^C-Users-Asus-AppData-Local-Temp-'
        } |
        ForEach-Object { Try-Delete $_.FullName ("projects/" + $_.Name) }
}

# Old plugin version folders: keep newest per plugin id when many versions exist
$plugCache = Join-Path $HubRoot "plugins\cache\cursor-public"
if (Test-Path $plugCache) {
    Get-ChildItem -LiteralPath $plugCache -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $versions = @(Get-ChildItem -LiteralPath $_.FullName -Directory -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending)
        if ($versions.Count -gt 2) {
            $versions | Select-Object -Skip 2 | ForEach-Object {
                Try-Delete $_.FullName ("plugin-old/" + $_.Parent.Name + "/" + $_.Name)
            }
        }
    }
}

$out = Join-Path $HubRoot "ai-tracking\safe-cleanup-last.json"
[ordered]@{
    checkedAt = (Get-Date).ToUniversalTime().ToString("o")
    apply     = [bool]$Apply
    freedMb   = [math]::Round($freed / 1MB, 2)
    rows      = @($report)
} | ConvertTo-Json -Depth 5 | Set-Content $out -Encoding UTF8

$report | Format-Table -AutoSize | Out-String | Write-Host
Write-Host ("Freed ~{0} MB | Report: {1}" -f [math]::Round($freed / 1MB, 2), $out)
if (-not $Apply) {
    Write-Host "Dry-run only. Re-run with -Apply." -ForegroundColor Yellow
}
exit 0
