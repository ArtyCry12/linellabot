param(
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [string]$RepoName = "cursor-hub-archive",
    [string]$Owner = "",
    [switch]$DryRun,
    [switch]$SkipDelete,
    [switch]$KeepLocal
)

$ErrorActionPreference = "Stop"
$gh = "$env:ProgramFiles\GitHub CLI\gh.exe"
if (-not (Test-Path $gh)) { $gh = "$env:LOCALAPPDATA\Programs\GitHub CLI\gh.exe" }
if (-not (Test-Path $gh)) { throw "gh.exe not found. Install GitHub CLI first." }

function Get-GitHubCred {
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "git"
    $psi.Arguments = "credential fill"
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $p = [System.Diagnostics.Process]::Start($psi)
    $p.StandardInput.WriteLine("protocol=https")
    $p.StandardInput.WriteLine("host=github.com")
    $p.StandardInput.WriteLine("")
    $p.StandardInput.Close()
    $out = $p.StandardOutput.ReadToEnd()
    $p.WaitForExit(8000) | Out-Null
    $user = $null; $pass = $null
    foreach ($line in ($out -split "`r?`n")) {
        if ($line -match '^username=(.+)$') { $user = $Matches[1].Trim() }
        if ($line -match '^password=(.+)$') { $pass = $Matches[1].Trim() }
    }
    if (-not $user -or -not $pass) { throw "No github.com credentials in git credential helper. Run: gh auth login" }
    return [pscustomobject]@{ User = $user; Token = $pass }
}

$candidates = @(
    @{ path = "lib\ecc-src"; note = "ECC shallow clone"; keepStub = $true }
    @{ path = "lib\n8n-templates-src"; note = "n8n templates corpus"; keepStub = $true }
)

Write-Host "=== Hub archive to GitHub ===" -ForegroundColor Cyan
$cred = Get-GitHubCred
if (-not $Owner) { $Owner = $cred.User }
$env:GH_TOKEN = $cred.Token
$env:GITHUB_TOKEN = $cred.Token

# Prefer env token; skip interactive auth login
$who = & $gh api user -q .login 2>$null
if (-not $who) { throw "GitHub API auth failed with stored credential" }
Write-Host "GitHub user: $who"

$inventory = @()
foreach ($c in $candidates) {
    $full = Join-Path $HubRoot $c.path
    if (-not (Test-Path $full)) { continue }
    $files = @(Get-ChildItem $full -Recurse -Force -File -ErrorAction SilentlyContinue)
    $mb = 0
    if ($files.Count -gt 0) {
        $mb = [math]::Round((($files | Measure-Object Length -Sum).Sum / 1MB), 2)
    }
    $inventory += [ordered]@{
        path      = $c.path
        note      = $c.note
        mb        = $mb
        fileCount = $files.Count
        keepStub  = $c.keepStub
    }
}

if ($inventory.Count -eq 0) {
    Write-Host "Nothing to archive." -ForegroundColor Yellow
    exit 0
}

$repoFull = "$Owner/$RepoName"
$remoteUrl = "https://github.com/$repoFull.git"

if ($DryRun) {
    $payload = [ordered]@{
        checkedAt = (Get-Date).ToUniversalTime().ToString("o")
        dryRun    = $true
        remote    = $remoteUrl
        inventory = $inventory
    }
    $payload | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $HubRoot "ai-tracking\archive-inventory.json") -Encoding UTF8
    Write-Host "DRY-RUN inventory written. Would push to $remoteUrl"
    exit 0
}

# Ensure private repo exists
$exists = $false
try {
    & $gh api "repos/$repoFull" -q .full_name 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) { $exists = $true }
}
catch { $exists = $false }

if (-not $exists) {
    Write-Host "Creating private repo $repoFull ..."
    $prevEap = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $createOut = & $gh repo create $repoFull --private --description "Cursor hub archived embedded sources (ECC, n8n-templates)" 2>&1
    $createCode = $LASTEXITCODE
    $ErrorActionPreference = $prevEap
    Write-Host ($createOut | Out-String)
    # Accept already-exists
    if ($createCode -ne 0) {
        $check = & $gh api "repos/$repoFull" -q .full_name 2>$null
        if (-not $check) { throw "Failed to create repo $repoFull" }
        Write-Host "Repo already exists, continuing."
    }
}

$stage = Join-Path $env:TEMP ("cursor-hub-archive-" + [guid]::NewGuid().ToString("n").Substring(0, 8))
New-Item -ItemType Directory -Force -Path $stage | Out-Null
Write-Host "Staging: $stage"

Push-Location $stage
$prevEap = $ErrorActionPreference
$ErrorActionPreference = "Continue"
try {
    git init -q 2>&1 | Out-Null
    git checkout -b main 2>&1 | Out-Null
    git config core.longpaths true
    git config core.autocrlf false
    @"
# cursor-hub-archive

Private archive of large embedded sources from ``C:\Users\Asus\.cursor``.

| Path | Note |
|------|------|
$(($inventory | ForEach-Object { "| ``$($_.path)`` | $($_.note) ($($_.mb) MB) |" }) -join "`n")

Restored via: ``commands/hub-archive-to-github.ps1`` / ``commands/ensure-ecc.ps1``.
"@ | Set-Content README.md -Encoding UTF8

    foreach ($item in $inventory) {
        $src = Join-Path $HubRoot $item.path
        $destName = Split-Path $item.path -Leaf
        $dest = Join-Path $stage $destName
        Write-Host "Copy $destName..."
        & robocopy $src $dest /E /XD .git node_modules .venv dist coverage .turbo /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
        if ($LASTEXITCODE -ge 8) { throw "robocopy failed for $destName code=$LASTEXITCODE" }
    }

    & git add -A *> $null
    $addCode = $LASTEXITCODE
    if ($addCode -ne 0) {
        $errLog = Join-Path $env:TEMP "hub-archive-git-add-err.txt"
        & git add -A 2> $errLog
        $addCode = $LASTEXITCODE
        $hint = if (Test-Path $errLog) { Get-Content $errLog -Raw } else { "" }
        if ($addCode -ne 0) { throw "git add failed code=$addCode $hint" }
    }

    & git -c user.email="archive@local" -c user.name="Hub Archive" commit -m "archive: hub embedded sources $(Get-Date -Format yyyy-MM-dd)" *> $null
    $commitCode = $LASTEXITCODE
    if ($commitCode -ne 0) {
        # empty commit? check if HEAD exists
        & git rev-parse HEAD *> $null
        if ($LASTEXITCODE -ne 0) { throw "git commit failed code=$commitCode" }
    }

    $pushUrl = "https://{0}:{1}@github.com/{2}.git" -f $Owner, $cred.Token, $repoFull
    & git remote remove origin *> $null
    & git remote add origin $pushUrl *> $null
    & git push -u origin main --force *> $null
    $pushCode = $LASTEXITCODE
    if ($pushCode -ne 0) { throw "git push failed code=$pushCode" }
    Write-Host "Push OK"
}
finally {
    $ErrorActionPreference = $prevEap
    Pop-Location
}

# Verify: authenticated shallow clone OR API
$verify = Join-Path $env:TEMP ("cursor-hub-archive-verify-" + [guid]::NewGuid().ToString("n").Substring(0, 8))
Write-Host "Verify clone..."
$verified = @()
$prevEap2 = $ErrorActionPreference
$ErrorActionPreference = "Continue"
$verifyUrl = "https://{0}:{1}@github.com/{2}.git" -f $Owner, $cred.Token, $repoFull
& git clone --depth 1 $verifyUrl $verify *> $null
$cloneOk = $LASTEXITCODE
$ErrorActionPreference = $prevEap2

if ($cloneOk -eq 0 -and (Test-Path (Join-Path $verify "README.md"))) {
    foreach ($item in $inventory) {
        $leaf = Split-Path $item.path -Leaf
        $vPath = Join-Path $verify $leaf
        $ok = Test-Path $vPath
        $vc = 0
        if ($ok) {
            $vc = @(Get-ChildItem $vPath -Recurse -Force -File -ErrorAction SilentlyContinue).Count
        }
        $verified += [ordered]@{
            path            = $item.path
            verifyOk        = $ok
            remoteFileCount = $vc
            localFileCount  = $item.fileCount
            method          = "clone"
        }
        Write-Host ("  {0}: ok={1} remoteFiles={2} localFiles={3}" -f $leaf, $ok, $vc, $item.fileCount)
    }
}
else {
    $readmeOk = & $gh api "repos/$repoFull/contents/README.md" -q .name 2>$null
    if ($readmeOk -ne "README.md") { throw "Verify failed: clone and API" }
    Write-Host "Verify via API OK"
    foreach ($item in $inventory) {
        $leaf = Split-Path $item.path -Leaf
        $ErrorActionPreference = "Continue"
        $listing = & $gh api "repos/$repoFull/contents/$leaf" 2>$null
        $ErrorActionPreference = "Stop"
        $ok = -not [string]::IsNullOrWhiteSpace([string]$listing)
        $verified += [ordered]@{
            path            = $item.path
            verifyOk        = $ok
            remoteFileCount = -1
            localFileCount  = $item.fileCount
            method          = "api"
        }
        Write-Host ("  {0}: apiOk={1}" -f $leaf, $ok)
    }
}

$allOk = ($verified | Where-Object { -not $_.verifyOk }).Count -eq 0
if (-not $allOk) { throw "Verify failed for some paths - local NOT deleted" }

# Delete local only after verify
$deleted = @()
if (-not $SkipDelete -and -not $KeepLocal) {
    foreach ($item in $inventory) {
        $full = Join-Path $HubRoot $item.path
        if (-not (Test-Path $full)) { continue }
        Remove-Item -LiteralPath $full -Recurse -Force -ErrorAction Stop
        $stubDir = $full
        New-Item -ItemType Directory -Force -Path $stubDir | Out-Null
        $leaf = Split-Path $item.path -Leaf
        @"
# Archived to GitHub

This folder was moved to private repo:
https://github.com/$repoFull

Folder in archive: ``$leaf``

Restore:
``````powershell
gh repo clone $repoFull `$env:TEMP\cursor-hub-archive
# or: commands/ensure-ecc.ps1 for ECC upstream re-clone
``````
"@ | Set-Content (Join-Path $stubDir "ARCHIVED.md") -Encoding UTF8
        $deleted += $item.path
        Write-Host "Deleted local + stub: $($item.path)" -ForegroundColor Green
    }
}

# Cleanup temps (don't leave token in remote URL workspace)
Remove-Item -LiteralPath $stage -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $verify -Recurse -Force -ErrorAction SilentlyContinue

$payload = [ordered]@{
    checkedAt = (Get-Date).ToUniversalTime().ToString("o")
    dryRun    = $false
    remote    = $remoteUrl
    owner     = $Owner
    repo      = $RepoName
    inventory = $inventory
    verified  = $verified
    deleted   = $deleted
    url       = "https://github.com/$repoFull"
}
$out = Join-Path $HubRoot "ai-tracking\archive-inventory.json"
$payload | ConvertTo-Json -Depth 6 | Set-Content $out -Encoding UTF8

Remove-Item Env:GH_TOKEN -ErrorAction SilentlyContinue
Remove-Item Env:GITHUB_TOKEN -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "OK: archived to https://github.com/$repoFull" -ForegroundColor Green
Write-Host "Inventory: $out"
exit 0
