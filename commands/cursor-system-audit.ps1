# Cursor hub system audit — dry-run report (JSON + Markdown)
param(
    [switch]$Apply,
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Continue"
$date = Get-Date -Format "yyyy-MM-dd"
$reportDir = Join-Path $HubRoot "ai-tracking"
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

function Get-DirSizeMB {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return 0 }
    $skip = @('node_modules', '.git', '.next', '.turbo', 'dist', 'build')
    $bytes = 0
    Get-ChildItem -LiteralPath $Path -Recurse -Force -File -ErrorAction SilentlyContinue |
        Where-Object {
            $parts = $_.FullName.Split([IO.Path]::DirectorySeparatorChar)
            -not ($parts | Where-Object { $skip -contains $_ })
        } |
        ForEach-Object { $bytes += $_.Length }
    return [math]::Round($bytes / 1MB, 1)
}

function Test-McpFetchHealth {
    return @{ ok = $true; note = 'fetch MCP - restart via Cursor Settings if errored' }
}

$topLevel = Get-ChildItem -LiteralPath $HubRoot -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -notin @('.git') }

$sizes = @{}
foreach ($item in $topLevel) {
    if ($item.PSIsContainer) {
        $sizes[$item.Name] = Get-DirSizeMB $item.FullName
    }
}

$nestedGit = @(Get-ChildItem -LiteralPath $HubRoot -Directory -Recurse -Force -Filter ".git" -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -ne (Join-Path $HubRoot ".git") })

$brokenJunctions = @()
$cyberLink = Join-Path $HubRoot "skills\cybersecurity\library\Anthropic-Cybersecurity-Skills-main"
if (Test-Path $cyberLink) {
    try {
        $target = (Get-Item -LiteralPath $cyberLink -Force).Target
        if ($target -and -not (Test-Path $target)) {
            $brokenJunctions += @{ path = $cyberLink; target = $target }
        }
    } catch {
        $brokenJunctions += @{ path = $cyberLink; target = "unreadable" }
    }
}

$gitnexusIndex = Join-Path $HubRoot ".gitnexus\lbug"
$gitnexusStale = $false
if (Test-Path $gitnexusIndex) {
    $idxDate = (Get-Item $gitnexusIndex).LastWriteTime
    $gitnexusStale = $idxDate -lt (Get-Date).AddDays(-7)
}

$untracked = 0
try {
    Push-Location $HubRoot
    $untracked = (git status --porcelain 2>$null | Measure-Object -Line).Lines
} finally {
    Pop-Location
}

$mcpHealth = Test-McpFetchHealth

$pendingPath = Join-Path $reportDir ".deferred-refresh-pending.json"
$deferredPending = $false
$deferredQueuedAt = $null
if (Test-Path $pendingPath) {
    $deferredPending = $true
    try {
        $p = Get-Content $pendingPath -Raw | ConvertFrom-Json
        $deferredQueuedAt = $p.queuedAt
    } catch { }
}

$totalMB = ($sizes.Values | Measure-Object -Sum).Sum
$report = [ordered]@{
    timestamp = (Get-Date).ToString("o")
    hubRoot   = $HubRoot
    dryRun    = (-not $Apply.IsPresent)
    totalSizeMB = $totalMB
    topLevelSizesMB = $sizes
    nestedGitRepos = $nestedGit.Count
    brokenJunctions = $brokenJunctions
    gitnexusStale = $gitnexusStale
    untrackedGitLines = $untracked
    deferredPending = $deferredPending
    deferredQueuedAt = $deferredQueuedAt
    recommendations = @(
        if ($sizes.extensions -gt 100) { "DELETE extensions/ (~$($sizes.extensions) MB misplaced)" }
        if ($sizes.'skills-libraries' -gt 50) { "DELETE skills-libraries/ after skills installed" }
        if ($sizes.libraries -gt 10) { "DELETE libraries/huashu-design duplicate" }
        if ($nestedGit.Count -gt 5) { "MOVE embedded repos to C:\Users\Asus\projects\" }
        if ($brokenJunctions.Count -gt 0) { "RUN node skills/cybersecurity/scripts/ensure-library.mjs" }
        if ($gitnexusStale) { "RUN npx gitnexus analyze" }
        if ($deferredPending) { "Deferred cleanup pending (closes when Cursor exits)" }
    ) | Where-Object { $_ }
}

$jsonPath = Join-Path $reportDir "system-audit-$date.json"
$mdPath = Join-Path $reportDir "system-audit-$date.md"
$report | ConvertTo-Json -Depth 6 | Set-Content -Path $jsonPath -Encoding UTF8

$deferredLine = if ($deferredQueuedAt) { "$deferredPending (since $deferredQueuedAt)" } else { "$deferredPending" }

$md = @"
# System audit $date

- **Hub:** ``$HubRoot``
- **Total (top-level dirs):** ~$totalMB MB
- **Nested .git repos:** $($nestedGit.Count)
- **Untracked git lines:** $untracked
- **GitNexus stale (>7d):** $gitnexusStale
- **Deferred cleanup pending:** $deferredLine

## Top sizes (MB)

$(($sizes.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 15 | ForEach-Object { "- $($_.Key): $($_.Value)" }) -join "`n")

## Recommendations

$(($report.recommendations | ForEach-Object { "- $_" }) -join "`n")

JSON: ``$jsonPath``
"@
Set-Content -Path $mdPath -Value $md -Encoding UTF8

Write-Host "Audit complete."
Write-Host "  JSON: $jsonPath"
Write-Host "  MD:   $mdPath"
Write-Host "  Total top-level: ~$totalMB MB"
