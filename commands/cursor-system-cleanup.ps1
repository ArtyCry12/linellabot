# Cursor hub cleanup — move embedded repos, delete caches (use -Apply to execute)
param(
    [switch]$Apply,
    [switch]$SkipLocked,
    [switch]$Force,
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [string]$ProjectsDest = "C:\Users\Asus\projects"
)

$ErrorActionPreference = "Continue"
$logDir = Join-Path $HubRoot "ai-tracking"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$logPath = Join-Path $logDir ("cleanup-log-{0}.txt" -f (Get-Date -Format "yyyy-MM-dd-HHmm"))
$actions = [System.Collections.Generic.List[string]]::new()

$excludeGitScan = @(
    (Join-Path $HubRoot ".git"),
    (Join-Path $HubRoot "projects\c-Users-Asus-cursor"),
    (Join-Path $HubRoot "skills\cybersecurity\library"),
    (Join-Path $HubRoot "plugins\cache")
)

function Log-Action {
    param([string]$Msg)
    $line = "$(Get-Date -Format 'HH:mm:ss') $Msg"
    $actions.Add($line) | Out-Null
    Write-Host $line
}

function Test-PathLocked {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    try {
        $item = Get-Item -LiteralPath $Path -Force
        if ($item.PSIsContainer) {
            $probe = Join-Path $Path ".cleanup-probe"
            New-Item -ItemType File -Path $probe -Force -ErrorAction Stop | Out-Null
            Remove-Item -LiteralPath $probe -Force -ErrorAction Stop
        }
        return $false
    } catch {
        return $true
    }
}

function Remove-PathRobust {
    param([string]$Path, [string]$Label)
    if (-not (Test-Path -LiteralPath $Path)) { return $true }

    if (-not $Apply) {
        Log-Action "DRY-RUN delete $Label"
        return $true
    }

    for ($i = 1; $i -le 3; $i++) {
        try {
            Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction Stop
            if (-not (Test-Path -LiteralPath $Path)) {
                Log-Action "DELETED $Label"
                return $true
            }
        } catch {
            Start-Sleep -Seconds 2
        }
    }

    if ($Force) {
        cmd /c "takeown /f `"$Path`" /r /d y >nul 2>&1"
        cmd /c "icacls `"$Path`" /grant `"$env:USERNAME`:(F)`" /t /c /q >nul 2>&1"
        cmd /c "rmdir /s /q `"$Path`""
        if (-not (Test-Path -LiteralPath $Path)) {
            Log-Action "DELETED $Label (force)"
            return $true
        }
    }

    if ($SkipLocked -and (Test-PathLocked $Path)) {
        Log-Action "SKIP_LOCKED $Label"
        return $false
    }

    Log-Action "FAILED delete $Label"
    return $false
}

function Remove-IfExists {
    param([string]$Path, [string]$Label)
    Remove-PathRobust -Path $Path -Label $Label | Out-Null
}

function Move-IfExists {
    param([string]$Src, [string]$DestName)
    if (-not (Test-Path -LiteralPath $Src)) { return }
    $dest = Join-Path $ProjectsDest $DestName
    if ($Apply) {
        New-Item -ItemType Directory -Force -Path $ProjectsDest | Out-Null
        if (Test-Path $dest) {
            Log-Action "SKIP move $DestName (dest exists)"
            return
        }
        if ($SkipLocked -and (Test-PathLocked $Src)) {
            Log-Action "SKIP_LOCKED move $DestName"
            return
        }
        try {
            Move-Item -LiteralPath $Src -Destination $dest -Force -ErrorAction Stop
            Log-Action "MOVED $DestName -> $dest"
        } catch {
            Log-Action "FAILED move $DestName ($($_.Exception.Message))"
        }
    } else {
        Log-Action "DRY-RUN move $DestName -> $dest"
    }
}

function Get-RepoRootsFromGitScan {
    $roots = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    $gitDirs = Get-ChildItem -LiteralPath $HubRoot -Directory -Recurse -Force -Filter ".git" -ErrorAction SilentlyContinue
    foreach ($g in $gitDirs) {
        $gitPath = $g.FullName
        $skip = $false
        foreach ($ex in $excludeGitScan) {
            if ($gitPath.StartsWith($ex, [StringComparison]::OrdinalIgnoreCase)) {
                $skip = $true
                break
            }
        }
        if ($skip) { continue }
        if ($gitPath -eq (Join-Path $HubRoot ".git")) { continue }

        $repoRoot = Split-Path $gitPath -Parent
        # Skip Cursor workspace metadata under projects/c-Users-Asus-cursor-*
        if ($repoRoot -match '\\projects\\c-Users-Asus-cursor-[^\\]+$' -and -not (Test-Path (Join-Path $repoRoot "package.json"))) {
            continue
        }
        [void]$roots.Add($repoRoot)
    }
    return @($roots)
}

# --- DELETE targets ---
Remove-IfExists (Join-Path $HubRoot "extensions") "extensions/"
Remove-IfExists (Join-Path $HubRoot "libraries\huashu-design") "libraries/huashu-design"
Remove-IfExists (Join-Path $HubRoot "skills-libraries") "skills-libraries/"
Remove-IfExists (Join-Path $HubRoot "skills\clone-website\template\node_modules") "clone-website template node_modules"
Remove-IfExists (Join-Path $HubRoot "node_modules") "root node_modules"
Remove-IfExists (Join-Path $HubRoot ".next") "root .next"
Remove-IfExists (Join-Path $HubRoot "skills\Cursor.lnk") "skills/Cursor.lnk"

$projLinella = Join-Path $HubRoot "projects\c-Users-Asus-cursor-linellabotprojet\node_modules"
Remove-IfExists $projLinella "projects/linellabotprojet node_modules"
Remove-IfExists (Join-Path $HubRoot "projects\c-Users-Asus-cursor-linellabotprojet\.next") "projects/linellabotprojet .next"

# Ephemeral project dirs
$projectsDir = Join-Path $HubRoot "projects"
if (Test-Path $projectsDir) {
    Get-ChildItem -LiteralPath $projectsDir -Directory -ErrorAction SilentlyContinue |
        Where-Object {
            $_.Name -match '^\d+$' -or
            $_.Name -match '^C-Users-Asus-AppData-Local-Temp-'
        } |
        ForEach-Object { Remove-IfExists $_.FullName "projects/$($_.Name)" }
}

# Scratch files at root
Get-ChildItem -LiteralPath $HubRoot -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match '^(_probe|_read_|_do_|_dump_|_find_|_finish_|_scan_|_stash_)' -or $_.Name -in @('fix.txt', 'init_fix.txt') } |
    ForEach-Object {
        if ($Apply) { Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue; Log-Action "DELETED $($_.Name)" }
        else { Log-Action "DRY-RUN delete $($_.Name)" }
    }

# --- MOVE embedded client repos (static map) ---
$moveMap = @{
    "flash-tokens-trust"       = "flash-tokens-trust"
    "neo-car-site1"            = "neo-car-site1"
    "neo-car-site2"            = "neo-car-site2"
    "gelentwagen-newlook-site" = "gelentwagen-newlook-site"
    "meloai-site"              = "meloai-site"
    "my-3d-agency"             = "my-3d-agency"
    "AiManager-project"        = "AiManager-project"
    "ui-project"               = "ui-project"
    "nano-banana-mcp"          = "nano-banana-mcp"
    "stitch-mcp"               = "stitch-mcp"
    "linellabotprojet"         = "linellabotprojet"
    "InCruises"                = "InCruises"
}

foreach ($entry in $moveMap.GetEnumerator()) {
    Move-IfExists (Join-Path $HubRoot $entry.Key) $entry.Value
}

# --- Auto-discovery: nested .git repos ---
foreach ($repoRoot in Get-RepoRootsFromGitScan) {
    $name = Split-Path $repoRoot -Leaf
    if ($name -eq ".cursor" -or $name -eq $HubRoot) { continue }
    Move-IfExists $repoRoot $name
}

# Remove duplicate .cursor/rules in hub
$dupRules = Join-Path $HubRoot ".cursor\rules"
if (Test-Path $dupRules) {
    Remove-IfExists $dupRules "hub .cursor/rules duplicate"
}

# seo-geo flat stubs
Get-ChildItem -LiteralPath (Join-Path $HubRoot "skills") -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match '^seo-geo-' } |
    ForEach-Object { Remove-IfExists $_.FullName "skills/$($_.Name)" }

$actions | Set-Content -Path $logPath -Encoding UTF8
Write-Host ""
Write-Host "Log: $logPath"
if (-not $Apply) {
    Write-Host "Dry-run only. Re-run with -Apply to execute."
}
