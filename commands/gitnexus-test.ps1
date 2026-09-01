param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [switch]$Json
)

# GitNexus index freshness + ignore canon gate.
# Pattern: commands/rtk-test.ps1, commands/mcp-health.ps1.
# Exit 0 = fresh + ignore OK; Exit 1 = stale or ignore missing.

$ErrorActionPreference = "Stop"
Set-Location $HubRoot

$fail = 0
function Fail([string]$Msg) {
    Write-Host "FAIL $Msg" -ForegroundColor Red
    $script:fail++
}

# Required .gitnexusignore lines (substring match). See 2026-09-01 reindex incident.
$requiredIgnore = @(
    'blocks/design/skills/impeccable/scripts/',
    'skills/_quarantine/',
    'skills/skills-main-top-coding/'
)

$runCjs = Join-Path $HubRoot '.gitnexus\run.cjs'
$ignorePath = Join-Path $HubRoot '.gitnexusignore'
$healthPath = Join-Path $HubRoot 'ai-tracking\gitnexus-health.json'

$report = [ordered]@{
    ok          = $false
    indexedAt   = $null
    indexedCommit = $null
    headCommit  = $null
    stale       = $true
    ignoreOk   = $false
    missingIgnore = @()
    timestamp   = (Get-Date).ToString('o')
}

# 1. run.cjs exists
if (-not (Test-Path $runCjs)) {
    Fail ".gitnexus/run.cjs missing (run commands/gitnexus-reindex.ps1 first)"
    $report | ConvertTo-Json -Depth 4 | Set-Content $healthPath -Encoding UTF8
    if ($Json) { $report | ConvertTo-Json -Depth 4 }
    Write-Host "Summary: $fail FAIL" -ForegroundColor Red
    exit 1
}

# 2. status parse
# node emits a DEP0190 deprecation warning on stderr; capture separately so
# $ErrorActionPreference=Stop does not turn it into a RemoteException.
$statusOut = ''
try {
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = 'node'
    $psi.Arguments = "`"$runCjs`" status"
    $psi.WorkingDirectory = $HubRoot
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $p = [System.Diagnostics.Process]::Start($psi)
    $stdoutTask = $p.StandardOutput.ReadToEndAsync()
    $stderrTask = $p.StandardError.ReadToEndAsync()
    $p.WaitForExit()
    $statusOut = $stdoutTask.Result
    $null = $stderrTask.Result
} catch {
    Fail "node .gitnexus/run.cjs status threw: $_"
    $report | ConvertTo-Json -Depth 4 | Set-Content $healthPath -Encoding UTF8
    if ($Json) { $report | ConvertTo-Json -Depth 4 }
    Write-Host "Summary: $fail FAIL" -ForegroundColor Red
    exit 1
}
$statusText = $statusOut
$upToDate = $statusText -match 'up-to-date'
$staleMatch = $statusText -match 'stale|out-of-date|behind'

# Indexed commit (short hash) and indexedAt
$indexedCommit = $null
if ($statusText -match 'Indexed commit:\s*([0-9a-f]{7,40})') { $indexedCommit = $matches[1] }
if ($statusText -match 'Current commit:\s*([0-9a-f]{7,40})') { $report.headCommit = $matches[1] }
if ($statusText -match 'Indexed:\s*(.+)') { $report.indexedAt = ($matches[1].Trim()) }

# Fallback to meta.json if status did not surface commits
if (-not $indexedCommit -or -not $report.headCommit) {
    $metaPath = Join-Path $HubRoot '.gitnexus\meta.json'
    if (Test-Path $metaPath) {
        try {
            $bytes = [System.IO.File]::ReadAllBytes($metaPath)
            $meta = ([System.Text.Encoding]::UTF8.GetString($bytes)) | ConvertFrom-Json
            if (-not $indexedCommit -and $meta.lastCommit) { $indexedCommit = $meta.lastCommit.Substring(0,7) }
            if (-not $report.indexedAt -and $meta.indexedAt) { $report.indexedAt = [string]$meta.indexedAt }
        } catch { }
    }
}
if (-not $report.headCommit) {
    try { $report.headCommit = (git rev-parse HEAD).Substring(0,7) } catch { }
}
$report.indexedCommit = $indexedCommit

if ($upToDate -and -not $staleMatch) {
    $report.stale = $false
} elseif ($indexedCommit -and $report.headCommit -and $indexedCommit -eq $report.headCommit) {
    $report.stale = $false
} else {
    $report.stale = $true
}

# 3. .gitnexusignore required lines
$ignoreOk = $true
$missing = @()
if (Test-Path $ignorePath) {
    $ignoreText = Get-Content $ignorePath -Raw
    foreach ($line in $requiredIgnore) {
        if ($ignoreText -notlike "*$line*") {
            $ignoreOk = $false
            $missing += $line
        }
    }
} else {
    $ignoreOk = $false
    $missing = $requiredIgnore
}
$report.ignoreOk = $ignoreOk
$report.missingIgnore = $missing

# 4. verdict
$report.ok = (-not $report.stale) -and $ignoreOk

# 5. write health json
$dir = Split-Path $healthPath -Parent
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
$report | ConvertTo-Json -Depth 4 | Set-Content $healthPath -Encoding UTF8

if ($Json) {
    $report | ConvertTo-Json -Depth 4
    exit 0
}

Write-Host "=== GitNexus test ===" -ForegroundColor Cyan
Write-Host ("run.cjs        : {0}" -f $(if (Test-Path $runCjs) { 'OK' } else { 'MISSING' }))
Write-Host ("indexedAt      : {0}" -f $report.indexedAt)
Write-Host ("indexed commit : {0}" -f $report.indexedCommit)
Write-Host ("head commit    : {0}" -f $report.headCommit)
Write-Host ("stale          : {0}" -f $report.stale)
Write-Host ("ignore canon   : {0}" -f $(if ($ignoreOk) { 'OK' } else { "MISSING $($missing -join ', ')" }))
Write-Host ("health json    : {0}" -f $healthPath)

if ($report.ok) {
    Write-Host "`nSummary: ALL PASSED" -ForegroundColor Green
    exit 0
}

if ($report.stale) {
    Write-Host "`nSTALE - run: powershell -File commands/gitnexus-reindex.ps1" -ForegroundColor Yellow
    $fail++
}
if (-not $ignoreOk) {
    Write-Host "`nIGNORE CANON MISSING - see .gitnexusignore (incident 2026-09-01)" -ForegroundColor Yellow
    $fail++
}

Write-Host "Summary: $fail FAIL" -ForegroundColor Red
exit 1
