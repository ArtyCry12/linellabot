# Cold cache sweep - obvious junk only. Never kills processes. Never calls cursor-system-cleanup.ps1.
# Canon: ai-tracking/ecosystem-governance/CACHE-POLICY.md
param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [string]$ProjectsRoot = "C:\Users\artyo\projects",
    [ValidateSet("T0", "T1")]
    [string]$Tier = "T0",
    [switch]$Apply,
    [int]$BudgetMb = 2048,
    [int]$HotDays = 7,
    [int]$ReportAgeDays = 3,
    [int]$NpmLogDays = 14,
    [int]$CursorLogDays = 30,
    [int]$TempHours = 24
)

$ErrorActionPreference = "Continue"
$startedAt = Get-Date
$maxSeconds = if ($Tier -eq "T1") { 600 } else { 90 }
$budgetBytes = [long]$BudgetMb * 1MB
$freed = 0L
$rows = New-Object System.Collections.Generic.List[object]
$stopReason = $null
$effectiveApply = [bool]$Apply

function Test-TimedOut {
    return ((Get-Date) - $script:startedAt).TotalSeconds -ge $script:maxSeconds
}

function Test-BudgetHit {
    return $script:freed -ge $script:budgetBytes
}

function Get-DirSizeBytes {
    param([string]$Path)
    try {
        $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
        if (-not $item.PSIsContainer) { return [long]$item.Length }
        $sum = 0L
        Get-ChildItem -LiteralPath $Path -Recurse -Force -File -ErrorAction SilentlyContinue |
            ForEach-Object { $sum += $_.Length }
        return $sum
    }
    catch { return 0L }
}

function Test-PathLocked {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    try {
        $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
        if ($item.PSIsContainer) {
            $probe = Join-Path $Path ".cache-sweep-probe"
            New-Item -ItemType File -Path $probe -Force -ErrorAction Stop | Out-Null
            Remove-Item -LiteralPath $probe -Force -ErrorAction Stop
        }
        else {
            $fs = [System.IO.File]::Open($Path, "Open", "ReadWrite", "None")
            $fs.Close()
        }
        return $false
    }
    catch { return $true }
}

function Add-Row {
    param([string]$Action, [string]$Label, [double]$Mb, [string]$Err = $null)
    $o = [ordered]@{ action = $Action; label = $Label; mb = $Mb }
    if ($Err) { $o.err = $Err }
    $script:rows.Add([pscustomobject]$o)
}

function Invoke-SweepDelete {
    param([string]$Path, [string]$Label, [int]$MinAgeDays = 0)
    if (Test-TimedOut) { $script:stopReason = "timeout"; return }
    if (Test-BudgetHit) { $script:stopReason = "budget"; return }
    if (-not (Test-Path -LiteralPath $Path)) { return }

    if ($MinAgeDays -gt 0) {
        try {
            $lw = (Get-Item -LiteralPath $Path -Force).LastWriteTime
            if ($lw -gt (Get-Date).AddDays(-$MinAgeDays)) { return }
        }
        catch { return }
    }

    $size = Get-DirSizeBytes $Path
    $mb = [math]::Round($size / 1MB, 2)

    if (-not $script:effectiveApply) {
        Add-Row "DRY" $Label $mb
        return
    }
    if (Test-PathLocked $Path) {
        Add-Row "SKIP" $Label $mb "locked"
        return
    }
    try {
        Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction Stop
        $script:freed += $size
        Add-Row "DEL" $Label $mb
    }
    catch {
        Add-Row "SKIP" $Label $mb $_.Exception.Message
    }
}

function Get-ProcessCommandLines {
    $list = New-Object System.Collections.Generic.List[string]
    try {
        Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
            ForEach-Object {
                if ($_.CommandLine) { [void]$list.Add([string]$_.CommandLine) }
            }
    }
    catch { }
    return $list
}

$script:processCommandLines = Get-ProcessCommandLines

function Test-ProjectHot {
    param([string]$ProjectRoot)
    $root = $ProjectRoot.TrimEnd("\", "/")
    foreach ($cl in $script:processCommandLines) {
        if ($cl.IndexOf($root, [StringComparison]::OrdinalIgnoreCase) -ge 0) { return $true }
    }
    $cutoff = (Get-Date).AddDays(-$script:HotDays)
    $markers = @(
        (Join-Path $ProjectRoot "package.json"),
        (Join-Path $ProjectRoot ".git\HEAD"),
        (Join-Path $ProjectRoot ".git\index"),
        (Join-Path $ProjectRoot "src"),
        (Join-Path $ProjectRoot "app"),
        (Join-Path $ProjectRoot "pages"),
        (Join-Path $ProjectRoot "apps"),
        (Join-Path $ProjectRoot "components")
    )
    foreach ($m in $markers) {
        if (-not (Test-Path -LiteralPath $m)) { continue }
        try {
            if ((Get-Item -LiteralPath $m -Force).LastWriteTime -gt $cutoff) { return $true }
        }
        catch { }
    }
    return $false
}

function Find-NamedDirs {
    param([string]$Root, [string[]]$Names, [string[]]$SkipNames)
    if (-not (Test-Path -LiteralPath $Root)) { return }
    $stack = New-Object System.Collections.Stack
    $stack.Push($Root)
    $skipSet = @{}
    foreach ($s in $SkipNames) { $skipSet[$s] = $true }
    $nameSet = @{}
    foreach ($n in $Names) { $nameSet[$n] = $true }

    while ($stack.Count -gt 0) {
        if (Test-TimedOut) { $script:stopReason = "timeout"; return }
        $dir = [string]$stack.Pop()
        $children = @(Get-ChildItem -LiteralPath $dir -Directory -Force -ErrorAction SilentlyContinue)
        foreach ($c in $children) {
            if ($c.Name -like ".venv*") { continue }
            if ($skipSet.ContainsKey($c.Name)) { continue }
            if ($nameSet.ContainsKey($c.Name)) {
                $c
                continue
            }
            $stack.Push($c.FullName)
        }
    }
}

# --- Circuit breaker: Cursor just started ---
$cursorProc = @(Get-Process -Name "Cursor", "cursor" -ErrorAction SilentlyContinue | Sort-Object StartTime)
if ($cursorProc.Count -gt 0) {
    $ageMin = ((Get-Date) - $cursorProc[0].StartTime).TotalMinutes
    if ($ageMin -lt 10) {
        $effectiveApply = $false
        Add-Row "KEEP" ("cursor-warm {0:N1}m report only" -f $ageMin) 0
    }
}

$reportsDir = Join-Path $HubRoot "ai-tracking\ecosystem-governance\reports"
New-Item -ItemType Directory -Force -Path $reportsDir | Out-Null

Write-Host ("=== Cache auto-sweep Tier={0} Apply={1} effectiveApply={2} ===" -f $Tier, [bool]$Apply, $effectiveApply)

# --- Step 1: hub-safe-cleanup (compose, do not copy) ---
$safe = Join-Path $HubRoot "commands\hub-safe-cleanup.ps1"
if (Test-Path -LiteralPath $safe) {
    $safeArgs = @{ HubRoot = $HubRoot }
    if ($effectiveApply) { $safeArgs.Apply = $true }
    try {
        & $safe @safeArgs | Out-Host
        Add-Row "HUB" "hub-safe-cleanup" 0
    }
    catch {
        Add-Row "SKIP" "hub-safe-cleanup" 0 $_.Exception.Message
    }
}
else {
    Add-Row "SKIP" "hub-safe-cleanup missing" 0
}

# Time budget applies to this script's walks, not hub-safe-cleanup.
$startedAt = Get-Date

$t0Names = @("__pycache__", ".pytest_cache")
$t0AgedNames = @("coverage", ".nyc_output", "playwright-report", "test-results")
$t0All = $t0Names + $t0AgedNames
$t1Names = @(".next", ".turbo")
$walkSkip = @("node_modules", ".git", ".next", ".turbo", "dist", ".gitnexus", ".cache")

# --- AppData before project walk so logs/temp are not starved by a fat tree ---
$npmLogs = Join-Path $env:LOCALAPPDATA "npm-cache\_logs"
if (Test-Path -LiteralPath $npmLogs) {
    $npmCutoff = (Get-Date).AddDays(-$NpmLogDays)
    $oldLogs = @(Get-ChildItem -LiteralPath $npmLogs -File -Force -ErrorAction SilentlyContinue |
            Where-Object { $_.LastWriteTime -lt $npmCutoff })
    foreach ($f in $oldLogs) {
        Invoke-SweepDelete -Path $f.FullName -Label ("npm-log/" + $f.Name)
        if ($script:stopReason -eq "budget") { break }
    }
}

$cursorLogs = Join-Path $env:APPDATA "Cursor\logs"
$todayPrefix = Get-Date -Format "yyyyMMdd"
if (Test-Path -LiteralPath $cursorLogs) {
    $logCutoff = (Get-Date).AddDays(-$CursorLogDays)
    $oldCursorLogs = @(Get-ChildItem -LiteralPath $cursorLogs -Force -ErrorAction SilentlyContinue |
            Where-Object {
                $_.LastWriteTime -lt $logCutoff -and
                $_.Name -notlike ($todayPrefix + "*")
            })
    foreach ($f in $oldCursorLogs) {
        Invoke-SweepDelete -Path $f.FullName -Label ("cursor-log/" + $f.Name)
        if ($script:stopReason -eq "budget") { break }
    }
}

$tempRoot = $env:TEMP
$tempCutoff = (Get-Date).AddHours(-$TempHours)
if (Test-Path -LiteralPath $tempRoot) {
    $oldTemp = @(Get-ChildItem -LiteralPath $tempRoot -Force -ErrorAction SilentlyContinue |
            Where-Object {
                $_.LastWriteTime -lt $tempCutoff -and
                (
                    $_.Name -like "cursor-*" -or
                    $_.Name -like "Cursor-*" -or
                    $_.Name -like "cursor-inno-updater*" -or
                    $_.Name -like "*cursor-agent*" -or
                    $_.Name -like "com.cursor*" -or
                    $_.Name -like "next-swc*"
                )
            })
    foreach ($f in $oldTemp) {
        Invoke-SweepDelete -Path $f.FullName -Label ("temp/" + $f.Name)
        if ($script:stopReason -eq "budget") { break }
    }
}

# --- Projects allowlist ---
$projectRoots = New-Object System.Collections.Generic.List[string]
if (Test-Path -LiteralPath $ProjectsRoot) {
    Get-ChildItem -LiteralPath $ProjectsRoot -Directory -ErrorAction SilentlyContinue |
        ForEach-Object { [void]$projectRoots.Add($_.FullName) }
}
$seen = @{}
foreach ($proj in $projectRoots) {
    if (Test-TimedOut -or Test-BudgetHit) { break }
    $key = $proj.ToLowerInvariant()
    if ($seen.ContainsKey($key)) { continue }
    $seen[$key] = $true

    $hot = Test-ProjectHot $proj
    $rel = { param($p) $p.FullName.Substring($proj.Length).TrimStart("\") }

    foreach ($d in @(Find-NamedDirs -Root $proj -Names $t0All -SkipNames $walkSkip)) {
        if ($null -eq $d) { continue }
        $age = 0
        if ($t0AgedNames -contains $d.Name) { $age = $ReportAgeDays }
        Invoke-SweepDelete -Path $d.FullName -Label ("t0/" + (& $rel $d)) -MinAgeDays $age
        if ($script:stopReason) { break }
    }
    if ($script:stopReason) { break }

    if ($Tier -eq "T1") {
        if ($hot) {
            Add-Row "KEEP" ("hot " + (Split-Path $proj -Leaf)) 0
        }
        else {
            foreach ($d in @(Find-NamedDirs -Root $proj -Names $t1Names -SkipNames @("node_modules", ".git", "dist", ".gitnexus", ".cache", ".venv"))) {
                if ($null -eq $d) { continue }
                Invoke-SweepDelete -Path $d.FullName -Label ("t1/" + (& $rel $d))
                if ($script:stopReason) { break }
            }
            $nmCache = Join-Path $proj "node_modules\.cache"
            if (Test-Path -LiteralPath $nmCache) {
                Invoke-SweepDelete -Path $nmCache -Label ("t1/" + (Split-Path $proj -Leaf) + "/node_modules/.cache")
            }
        }
    }
}

# --- Step 4: orphan process report (never kill) ---
$orphans = New-Object System.Collections.Generic.List[object]
$watch = 'next|vite|turbo|playwright|webpack|nuxt'
try {
    $procs = @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue)
    foreach ($p in $procs) {
        $name = [string]$p.Name
        $cl = [string]$p.CommandLine
        $isNode = $name -match '^(node|nodejs)\.exe$'
        $isPlay = ($name -match '^(chrome|chromium|msedge)\.exe$' -and $cl -match 'playwright')
        $isTool = $name -match '^(vite|turbo)\.exe$'
        if (-not ($isNode -or $isPlay -or $isTool)) { continue }
        if ($isNode -and $cl -notmatch $watch) { continue }
        $wsMb = 0
        $cpu = 0
        try {
            $gp = Get-Process -Id $p.ProcessId -ErrorAction Stop
            $wsMb = [math]::Round($gp.WorkingSet64 / 1MB, 1)
            $cpu = [math]::Round($gp.CPU, 1)
        }
        catch { }
        $orphans.Add([pscustomobject]@{
                pid     = $p.ProcessId
                name    = $name
                cpuSec  = $cpu
                wsMb    = $wsMb
                cmd     = if ($cl.Length -gt 300) { $cl.Substring(0, 300) + "..." } else { $cl }
            }) | Out-Null
    }
}
catch { }

$orphanPath = Join-Path $reportsDir "orphan-processes-last.json"
$orphanPayload = [pscustomobject]@{
    checkedAt = (Get-Date).ToUniversalTime().ToString("o")
    willKill  = $false
    count     = $orphans.Count
    processes = @($orphans.ToArray())
}
ConvertTo-Json -InputObject $orphanPayload -Depth 5 |
    Set-Content -Path $orphanPath -Encoding UTF8

$mdPath = Join-Path $reportsDir ("cache-sweep-{0}.md" -f (Get-Date -Format "yyyy-MM-dd"))
$jsonPath = Join-Path $reportsDir "cache-sweep-last.json"
$elapsed = [math]::Round(((Get-Date) - $startedAt).TotalSeconds, 1)

$summary = [pscustomobject]@{
    checkedAt      = (Get-Date).ToUniversalTime().ToString("o")
    tier           = $Tier
    applyRequested = [bool]$Apply
    applyEffective = $effectiveApply
    stopReason     = $stopReason
    elapsedSec     = $elapsed
    freedMb        = [math]::Round($freed / 1MB, 2)
    rowCount       = $rows.Count
    orphanCount    = $orphans.Count
    orphanReport   = $orphanPath
    rows           = @($rows.ToArray())
}
ConvertTo-Json -InputObject $summary -Depth 6 |
    Set-Content -Path $jsonPath -Encoding UTF8

$md = @(
    "# Cache sweep $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    ""
    "- Tier: $Tier"
    "- Apply requested: $Apply / effective: $effectiveApply"
    "- Freed MB: $([math]::Round($freed / 1MB, 2))"
    "- Elapsed s: $elapsed"
    "- Stop: $stopReason"
    "- Orphans (report only): $($orphans.Count) -> ``$orphanPath``"
    ""
    "## Rows"
    ""
)
foreach ($r in $rows) {
    $errBit = if ($r.err) { " - $($r.err)" } else { "" }
    $md += "- $($r.action) $($r.label) ($($r.mb) MB)$errBit"
}
$md -join "`n" | Set-Content -Path $mdPath -Encoding UTF8

Write-Host ("Freed ~{0} MB | {1} | orphans {2}" -f [math]::Round($freed / 1MB, 2), $jsonPath, $orphans.Count)
if (-not $Apply) {
    Write-Host "Dry-run only. Re-run with -Apply to delete." -ForegroundColor Yellow
}
if ($Apply -and -not $effectiveApply) {
    Write-Host "Apply requested but circuit breaker forced report-only." -ForegroundColor Yellow
}
exit 0
