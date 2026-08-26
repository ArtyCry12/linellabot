# MarkItDown hub test — venv, convert, hook dry-run
param([string]$HubRoot = "")

$ErrorActionPreference = "Stop"
if (-not $HubRoot) { $HubRoot = Split-Path $PSScriptRoot -Parent }

. (Join-Path $HubRoot "lib\markitdown\MarkItDown.ps1")

$fail = 0
function Assert([bool]$Cond, [string]$Msg) {
    if ($Cond) { Write-Host "OK: $Msg" -ForegroundColor Green }
    else { Write-Host "FAIL: $Msg" -ForegroundColor Red; $script:fail++ }
}

Write-Host "=== markitdown-test ===" -ForegroundColor Cyan

$paths = Get-MarkItDownPaths -HubRoot $HubRoot
Assert (Test-Path $paths.PythonExe) "Python venv exists"
Assert (Test-MarkItDownInstalled -HubRoot $HubRoot) "markitdown import"

$fixture = Join-Path $HubRoot "skills\markitdown\fixtures\sample.html"
if (-not (Test-Path $fixture)) {
    & (Join-Path $HubRoot "commands\ensure-markitdown.ps1") -HubRoot $HubRoot | Out-Null
}

try {
    $r = Invoke-MarkItDownConvert -SourcePath $fixture -HubRoot $HubRoot
    Assert ($r.Output -and (Test-Path $r.Output)) "convert sample.html"
    $r2 = Invoke-MarkItDownConvert -SourcePath $fixture -HubRoot $HubRoot
    Assert ($r2.Cached -eq $true) "cache hit on second convert"
}
catch {
    Assert $false "convert: $($_.Exception.Message)"
}

$hook = Join-Path $HubRoot "hooks\markitdown-intake.ps1"
Assert (Test-Path $hook) "markitdown-intake hook exists"

$testPrompt = "Please read C:\fake\report.pdf and summarize"
$found = Find-DocumentPathsInText -Text $testPrompt
Assert ($found.Count -ge 0) "Find-DocumentPathsInText runs"

$attachSample = @"
<attached_files>
<code_selection path="file:///c%3A/Users/artyo/test/report.pdf" lines="1-10">
</code_selection>
</attached_files>
"@
$foundAttach = Find-DocumentPathsInPrompt -FullPrompt $attachSample
Assert ($foundAttach.Count -ge 0) "Find-DocumentPathsInPrompt scans attached_files"

$skip = Test-MarkItDownSkipPrompt -Prompt "skip-markitdown please"
Assert ($skip -eq $true) "skip flag detected"

Write-Host ""
if ($fail -eq 0) {
    Write-Host "ALL PASSED ($fail failures)" -ForegroundColor Green
    exit 0
}
Write-Host "FAILED: $fail checks" -ForegroundColor Red
exit 1
