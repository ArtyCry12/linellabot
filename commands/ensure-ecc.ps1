param(
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$eccDir = Join-Path $HubRoot "lib\ecc-src"
$instinctsDir = Join-Path $HubRoot "ai-tracking\instincts"
$seed = Join-Path $instinctsDir "seed-instincts.json"
$log = @()

function Log([string]$m) { $script:log += $m; Write-Host $m }

if (-not (Test-Path $instinctsDir)) {
    New-Item -ItemType Directory -Path $instinctsDir -Force | Out-Null
}
if (-not (Test-Path $seed)) {
    throw "Missing seed instincts: $seed"
}

$git = Get-Command git -ErrorAction SilentlyContinue
$needClone = $true
if ((Test-Path $eccDir) -and -not $Force) {
    $hasContent = (Test-Path (Join-Path $eccDir "README.md")) -or
                  (Test-Path (Join-Path $eccDir "package.json")) -or
                  (Test-Path (Join-Path $eccDir ".git"))
    $isStub = Test-Path (Join-Path $eccDir "ARCHIVED.md")
    if ($hasContent -and -not $isStub) {
        $needClone = $false
        Log "OK: ecc-src exists"
    }
}

if (-not $git) {
    Log "WARN: git not found; skipping ecc-src clone"
}
elseif ($needClone) {
    if (Test-Path $eccDir) { Remove-Item -Recurse -Force $eccDir }
    Log "Cloning ECC (depth 1)..."
    & git clone --depth 1 https://github.com/affaan-m/ECC.git $eccDir
    if ($LASTEXITCODE -ne 0) { throw "git clone ECC failed" }
    Log "OK: ecc-src at $eccDir"
}

# Merge seed into active instincts if empty
$active = Join-Path $instinctsDir "active-instincts.json"
if (-not (Test-Path $active)) {
    Copy-Item $seed $active
    Log "OK: seeded active-instincts.json"
}

$health = [ordered]@{
    checkedAt = (Get-Date).ToUniversalTime().ToString("o")
    eccSrc    = (Test-Path $eccDir)
    instincts = (Test-Path $active)
    log       = $log
}
$healthPath = Join-Path $HubRoot "ai-tracking\ecc-health.json"
$health | ConvertTo-Json -Depth 4 | Set-Content $healthPath -Encoding UTF8
Log "Health: $healthPath"
exit 0
