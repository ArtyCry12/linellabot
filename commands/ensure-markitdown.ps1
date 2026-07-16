# Ensure MarkItDown venv (Python 3.12 via uv) + smoke convert
param(
    [string]$HubRoot = "",
    [switch]$SkipSmoke
)

$ErrorActionPreference = "Stop"
if (-not $HubRoot) { $HubRoot = Split-Path $PSScriptRoot -Parent }

. (Join-Path $HubRoot "lib\markitdown\MarkItDown.ps1")
$paths = Get-MarkItDownPaths -HubRoot $HubRoot
$log = @()

function Log([string]$Msg) {
    $script:log += "$(Get-Date -Format 'HH:mm:ss') $Msg"
    Write-Host $Msg
}

$uv = Get-Command uv -ErrorAction SilentlyContinue
if (-not $uv) {
    $uvCandidate = Join-Path $env:APPDATA "Python\Python38\Scripts\uv.exe"
    if (Test-Path $uvCandidate) { $uv = Get-Command $uvCandidate }
}
if (-not $uv) {
    Write-Error "uv not found. Install: pip install uv"
    exit 1
}

$uvBin = Join-Path $env:USERPROFILE ".local\bin"
if (Test-Path $uvBin) {
    $env:PATH = "$uvBin;$env:PATH"
}

Log "Ensuring Python 3.12 via uv..."
& uv python install 3.12
if ($LASTEXITCODE -ne 0) { throw "uv python install 3.12 failed" }

if (-not (Test-Path $paths.VenvDir)) {
    Log "Creating venv at $($paths.VenvDir)"
    & uv venv $paths.VenvDir --python 3.12
    if ($LASTEXITCODE -ne 0) { throw "uv venv failed" }
}

Log "Installing markitdown[all]..."
& uv pip install "markitdown[all]" markitdown-mcp --python $paths.PythonExe
if ($LASTEXITCODE -ne 0) { throw "pip install markitdown failed" }

if (-not (Test-MarkItDownInstalled -HubRoot $HubRoot)) {
    throw "markitdown import check failed"
}
Log "OK: markitdown import"

$mcpExe = Join-Path $paths.VenvDir "Scripts\markitdown-mcp.exe"
if (Test-Path $mcpExe) {
    Log "OK: markitdown-mcp binary at $mcpExe"
}
else {
    Log "WARN: markitdown-mcp.exe not found; pip install markitdown-mcp"
}

$smokeOk = $false
$smokeOut = $null
if (-not $SkipSmoke) {
    $fixtureDir = Join-Path $HubRoot "skills\markitdown\fixtures"
    New-Item -ItemType Directory -Force -Path $fixtureDir | Out-Null
    $sampleHtml = Join-Path $fixtureDir "sample.html"
    if (-not (Test-Path $sampleHtml)) {
        @"
<!DOCTYPE html>
<html><head><title>MarkItDown smoke</title></head>
<body><h1>Hub test</h1><p>Token-efficient markdown intake.</p></body></html>
"@ | Set-Content -Path $sampleHtml -Encoding UTF8
    }
    try {
        $r = Invoke-MarkItDownConvert -SourcePath $sampleHtml -HubRoot $HubRoot -Force
        if ($r.Output -and (Test-Path $r.Output)) {
            $smokeOk = $true
            $smokeOut = $r.Output
            Log "OK: smoke convert -> $smokeOut"
        }
    }
    catch {
        Log "WARN: smoke convert failed: $($_.Exception.Message)"
    }
}

$health = [ordered]@{
    checkedAt  = (Get-Date).ToUniversalTime().ToString("o")
    python   = $paths.PythonExe
    venv     = $paths.VenvDir
    installed = (Test-MarkItDownInstalled -HubRoot $HubRoot)
    mcpExe    = (Join-Path $paths.VenvDir "Scripts\markitdown-mcp.exe")
    mcpOk     = (Test-Path $mcpExe)
    smokeOk  = $smokeOk
    smokeOut = $smokeOut
    log      = $log
}
$dir = Split-Path $paths.HealthPath -Parent
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
($health | ConvertTo-Json -Depth 5) | Set-Content -Path $paths.HealthPath -Encoding UTF8

Write-Output "Health: $($paths.HealthPath)"
if (-not $health.installed) { exit 1 }
exit 0
