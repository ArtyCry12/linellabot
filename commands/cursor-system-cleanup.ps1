# Cursor hub cleanup — move embedded repos, delete caches (use -Apply to execute)
param(
    [switch]$Apply,
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [string]$ProjectsDest = "C:\Users\Asus\projects"
)

$ErrorActionPreference = "Continue"
$logDir = Join-Path $HubRoot "ai-tracking"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$logPath = Join-Path $logDir ("cleanup-log-{0}.txt" -f (Get-Date -Format "yyyy-MM-dd-HHmm"))
$actions = [System.Collections.Generic.List[string]]::new()

function Log-Action {
    param([string]$Msg)
    $line = "$(Get-Date -Format 'HH:mm:ss') $Msg"
    $actions.Add($line) | Out-Null
    Write-Host $line
}

function Remove-IfExists {
    param([string]$Path, [string]$Label)
    if (-not (Test-Path -LiteralPath $Path)) { return }
    if ($Apply) {
        Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction SilentlyContinue
        Log-Action "DELETED $Label"
    } else {
        Log-Action "DRY-RUN delete $Label"
    }
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
        Move-Item -LiteralPath $Src -Destination $dest -Force
        Log-Action "MOVED $DestName -> $dest"
    } else {
        Log-Action "DRY-RUN move $DestName -> $dest"
    }
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

# Ephemeral numeric project dirs
Get-ChildItem -LiteralPath (Join-Path $HubRoot "projects") -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match '^\d+$' } |
    ForEach-Object { Remove-IfExists $_.FullName "projects/$($_.Name)" }

# Scratch files at root
Get-ChildItem -LiteralPath $HubRoot -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match '^(_probe|_read_|_do_|_dump_|_find_|_finish_|_scan_|_stash_)' -or $_.Name -in @('fix.txt', 'init_fix.txt') } |
    ForEach-Object {
        if ($Apply) { Remove-Item $_.FullName -Force; Log-Action "DELETED $($_.Name)" }
        else { Log-Action "DRY-RUN delete $($_.Name)" }
    }

# --- MOVE embedded client repos ---
$moveMap = @{
    "flash-tokens-trust"     = "flash-tokens-trust"
    "neo-car-site1"          = "neo-car-site1"
    "neo-car-site2"          = "neo-car-site2"
    "gelentwagen-newlook-site" = "gelentwagen-newlook-site"
    "meloai-site"            = "meloai-site"
    "my-3d-agency"           = "my-3d-agency"
    "AiManager-project"      = "AiManager-project"
    "ui-project"             = "ui-project"
    "nano-banana-mcp"        = "nano-banana-mcp"
    "stitch-mcp"             = "stitch-mcp"
    "linellabotprojet"       = "linellabotprojet"
}

foreach ($entry in $moveMap.GetEnumerator()) {
    Move-IfExists (Join-Path $HubRoot $entry.Key) $entry.Value
}

# Remove duplicate .cursor/rules in hub (sync script fills other workspaces)
$dupRules = Join-Path $HubRoot ".cursor\rules"
if (Test-Path $dupRules) {
    Remove-IfExists $dupRules "hub .cursor/rules duplicate"
}

# seo-geo flat stubs (keep skills/seo-geo pack)
Get-ChildItem -LiteralPath (Join-Path $HubRoot "skills") -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match '^seo-geo-' } |
    ForEach-Object { Remove-IfExists $_.FullName "skills/$($_.Name)" }

$actions | Set-Content -Path $logPath -Encoding UTF8
Write-Host ""
Write-Host "Log: $logPath"
if (-not $Apply) {
    Write-Host "Dry-run only. Re-run with -Apply to execute."
}
