param(
    [string]$HubRoot = "C:\Users\artyo\.cursor"
)
# Rebuild hub GitNexus AFTER Reload Window (workers fail if 21 MCP still hold RAM).
# MCP runtime heap stays 1536 in mcp.json. This script uses 4096 only for analyze.
# Expected duration: ~3-5 min on the hub (parse + graph). Long runs may be marked
# `error` by the Cursor shell wrapper even when analyze succeeds - that is NOT
# index corruption. Verify with commands/gitnexus-test.ps1 after every run.
$ErrorActionPreference = "Stop"
Set-Location $HubRoot
$env:NODE_OPTIONS = "--max-old-space-size=4096"

$startIso = (Get-Date).ToString('o')
Write-Host "GitNexus reindex with .gitnexusignore" -ForegroundColor Cyan
Write-Host "start    : $startIso"
Write-Host "expected : ~3-5 min (hub). Long shell jobs may show 'error' even on success - verify with gitnexus-test.ps1."

$stderrFile = [System.IO.Path]::GetTempFileName()
$runCjs = Join-Path $HubRoot ".gitnexus\run.cjs"

# node emits DEP0190 on stderr; do not merge stderr into PowerShell error stream
# ($ErrorActionPreference=Stop would treat it as a fatal exception).
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = 'node'
$psi.Arguments = "`"$runCjs`" analyze --force --skip-agents-md --skip-skills"
$psi.WorkingDirectory = $HubRoot
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true

$p = [System.Diagnostics.Process]::Start($psi)
$outTask = [System.Threading.Tasks.Task]::Run({ $p.StandardOutput.ReadToEnd() })
$errTask = [System.Threading.Tasks.Task]::Run({ $p.StandardError.ReadToEnd() })
$p.WaitForExit()
$stdout = $outTask.Result
$stderr = $errTask.Result
$code = $p.ExitCode

if ($stdout) { Write-Host $stdout }
if ($stderr) { Set-Content -Path $stderrFile -Value $stderr -Encoding UTF8 }

$endIso = (Get-Date).ToString('o')
Write-Host "end      : $endIso"

if ($code -ne 0) {
    Write-Host "analyze FAILED (exit $code). Last 20 stderr lines:" -ForegroundColor Red
    if ($stderr) {
        ($stderr -split "`n" | Select-Object -Last 20) | ForEach-Object { Write-Host $_ }
    } elseif (Test-Path $stderrFile) {
        Get-Content $stderrFile -Tail 20 | ForEach-Object { Write-Host $_ }
    }
    exit $code
}

# Post-success gate: freshness + ignore canon
$testScript = Join-Path $HubRoot 'commands\gitnexus-test.ps1'
Write-Host "post-success gate: gitnexus-test.ps1" -ForegroundColor Cyan
& powershell -NoProfile -File $testScript
$testCode = $LASTEXITCODE
if ($testCode -ne 0) {
    Write-Host "gitnexus-test.ps1 FAILED (exit $testCode) after reindex - index may still be stale or ignore canon drifted." -ForegroundColor Red
    exit $testCode
}

Write-Host "reindex OK + gate PASS" -ForegroundColor Green
exit 0
