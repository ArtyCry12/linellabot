# Security Hub scan runner — secrets/sast/sca/iac/dast/recon/all-defensive
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("secrets", "sast", "sca", "iac", "dast", "recon", "all-defensive")]
    [string]$Tier,

    [string]$Path = "",
    [string]$TargetUrl = "",
    [string]$TargetHost = "",
    [switch]$Authorized,
    [string]$HubRoot = "",
    [string]$OutDir = ""
)

$ErrorActionPreference = "Stop"
if (-not $HubRoot) { $HubRoot = Split-Path $PSScriptRoot -Parent }
if (-not $Path) { $Path = (Get-Location).Path }
if (-not $OutDir) {
    $OutDir = Join-Path $HubRoot ".cache\security-hub"
}
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$artifacts = @()
$missing = @()
$findings = @()
$toolUsed = ""
$authorizedFlag = $false
$lastNativeExit = 0

function Test-Tool([string]$Name) {
    return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

# Native CLIs write progress to stderr; PS Stop would abort. Capture exit only.
function Invoke-Native {
    param([scriptblock]$Block)
    $prev = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    & $Block 2>&1 | ForEach-Object {
        if ($_ -is [System.Management.Automation.ErrorRecord]) {
            Write-Host $_.Exception.Message
        } else {
            Write-Host $_
        }
    }
    $script:lastNativeExit = $LASTEXITCODE
    $ErrorActionPreference = $prev
    return $script:lastNativeExit
}

function Assert-Authorized {
    param([string]$Kind, [string]$Target)
    if (-not $Authorized) {
        Write-Host "REFUSED: $Kind requires -Authorized. See skills/security-hub/references/auth-gate.md. Target was: $Target"
        exit 2
    }
    if (-not $Target) {
        Write-Host "REFUSED: $Kind requires -TargetUrl or -TargetHost"
        exit 2
    }
    $script:authorizedFlag = $true
}

function Add-Finding {
    param(
        [string]$Severity,
        [string]$Title,
        [string]$Description,
        [string]$File = $null,
        [object]$Line = $null,
        [string]$Category = "generic",
        [string]$Recommendation = $null,
        [string]$RawRef = $null
    )
    $script:findings += [ordered]@{
        severity         = $Severity
        title            = $Title
        description      = $Description
        file             = $File
        line             = $Line
        category         = $Category
        recommendation   = $Recommendation
        confidence       = $null
        rawRef           = $RawRef
    }
}

function Invoke-Secrets {
    $out = Join-Path $OutDir "gitleaks-$stamp.json"
    if (Test-Tool "gitleaks") {
        $script:toolUsed = "gitleaks"
        Invoke-Native { & gitleaks detect --source $Path --report-path $out --report-format json --no-git } | Out-Null
        $artifacts += $out
        if (Test-Path $out) {
            try {
                $raw = Get-Content $out -Raw | ConvertFrom-Json
                foreach ($item in @($raw)) {
                    Add-Finding -Severity "HIGH" -Title "Secret: $($item.RuleID)" `
                        -Description "$($item.Description) match in $($item.File)" `
                        -File $item.File -Line $item.StartLine -Category "secret" -RawRef $out
                }
            } catch { }
        }
        return
    }
    if (Test-Tool "trufflehog") {
        $script:toolUsed = "trufflehog"
        $outTxt = Join-Path $OutDir "trufflehog-$stamp.json"
        Invoke-Native { & trufflehog filesystem $Path --json | Set-Content $outTxt } | Out-Null
        $artifacts += $outTxt
        Add-Finding -Severity "INFO" -Title "trufflehog raw output" -Description "See artifact" -Category "secret" -RawRef $outTxt
        return
    }
    $script:missing += "gitleaks", "trufflehog"
    Write-Host "MISSING tools for secrets tier"
}

function Invoke-Sast {
    $out = Join-Path $OutDir "semgrep-$stamp.json"
    if (Test-Tool "semgrep") {
        $script:toolUsed = "semgrep"
        # --no-git-ignore: scan fixture dirs under .cache / gitignored paths
        Invoke-Native { & semgrep scan --config p/default --no-git-ignore --json -o $out $Path } | Out-Null
        $artifacts += $out
        if (Test-Path $out) {
            try {
                $raw = Get-Content $out -Raw | ConvertFrom-Json
                foreach ($r in @($raw.results)) {
                    $sev = ($r.extra.severity + "").ToUpper()
                    if (-not $sev) { $sev = "MEDIUM" }
                    Add-Finding -Severity $sev -Title $r.check_id -Description $r.extra.message `
                        -File $r.path -Line $r.start.line -Category "sast" -RawRef $out
                }
            } catch { }
        }
        return
    }
    $script:missing += "semgrep"
    Write-Host "MISSING semgrep"
}

function Invoke-Sca {
    $out = Join-Path $OutDir "trivy-$stamp.json"
    if (Test-Tool "trivy") {
        $script:toolUsed = "trivy"
        Invoke-Native { & trivy fs --format json --output $out $Path } | Out-Null
        $artifacts += $out
        if (Test-Path $out) {
            try {
                $raw = Get-Content $out -Raw | ConvertFrom-Json
                foreach ($res in @($raw.Results)) {
                    foreach ($v in @($res.Vulnerabilities)) {
                        if (-not $v) { continue }
                        Add-Finding -Severity ($v.Severity) -Title "$($v.VulnerabilityID) $($v.PkgName)" `
                            -Description $v.Title -Category "sca" -RawRef $out -Recommendation $v.FixedVersion
                    }
                }
            } catch { }
        }
        return
    }
    if (Test-Tool "grype") {
        $script:toolUsed = "grype"
        $out = Join-Path $OutDir "grype-$stamp.json"
        Invoke-Native { & grype "dir:$Path" -o json | Set-Content $out } | Out-Null
        $artifacts += $out
        Add-Finding -Severity "INFO" -Title "grype raw" -Description "See artifact" -Category "sca" -RawRef $out
        return
    }
    $script:missing += "trivy", "grype"
    Write-Host "MISSING trivy/grype"
}

function Invoke-Iac {
    if (Test-Tool "checkov") {
        $script:toolUsed = "checkov"
        Invoke-Native { & checkov -d $Path -o json --output-file-path $OutDir } | Out-Null
        $candidates = Get-ChildItem $OutDir -Filter "results_*.json" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
        if ($candidates) {
            $out = $candidates[0].FullName
            $artifacts += $out
            Add-Finding -Severity "INFO" -Title "checkov results" -Description "See artifact" -Category "iac" -RawRef $out
        }
        return
    }
    $script:missing += "checkov"
    Write-Host "MISSING checkov"
}

function Invoke-Dast {
    $target = $TargetUrl
    Assert-Authorized -Kind "dast" -Target $target
    $outDirZap = Join-Path $OutDir "zap-$stamp"
    New-Item -ItemType Directory -Force -Path $outDirZap | Out-Null

    if (Test-Tool "docker") {
        $script:toolUsed = "docker:zaproxy"
        $report = Join-Path $outDirZap "report.json"
        Invoke-Native {
            & docker run --rm -v "${outDirZap}:/zap/wrk:rw" ghcr.io/zaproxy/zaproxy:stable `
                zap-baseline.py -t $target -J report.json
        } | Out-Null
        $artifacts += $outDirZap
        if (Test-Path $report) {
            Add-Finding -Severity "INFO" -Title "ZAP baseline" -Description "Report written" -Category "dast" -RawRef $report
        } else {
            Add-Finding -Severity "INFO" -Title "ZAP baseline ran" -Description "Check docker logs; report may be under $outDirZap" -Category "dast" -RawRef $outDirZap
        }
        return
    }
    if (Test-Tool "zap-baseline.py") {
        $script:toolUsed = "zap-baseline.py"
        Invoke-Native { & zap-baseline.py -t $target -J (Join-Path $outDirZap "report.json") } | Out-Null
        $artifacts += $outDirZap
        return
    }
    $script:missing += "docker", "zap-baseline.py"
    Write-Host "MISSING docker or zap-baseline.py for dast"
}

function Invoke-Recon {
    $hostName = if ($TargetHost) { $TargetHost } else {
        if ($TargetUrl) {
            try { ([Uri]$TargetUrl).Host } catch { $TargetUrl }
        } else { "" }
    }
    Assert-Authorized -Kind "recon" -Target $hostName

    $outBase = Join-Path $OutDir "recon-$stamp"
    New-Item -ItemType Directory -Force -Path $outBase | Out-Null
    $subsFile = Join-Path $outBase "subdomains.txt"
    $httpxFile = Join-Path $outBase "httpx.json"
    $nucleiFile = Join-Path $outBase "nuclei.json"

    if (Test-Tool "subfinder") {
        $script:toolUsed = "subfinder"
        Invoke-Native { & subfinder -d $hostName -silent | Set-Content $subsFile } | Out-Null
        $artifacts += $subsFile
    } else {
        $script:missing += "subfinder"
        Set-Content $subsFile $hostName
    }

    if (Test-Tool "httpx") {
        $script:toolUsed = if ($script:toolUsed) { "$script:toolUsed+httpx" } else { "httpx" }
        Invoke-Native { Get-Content $subsFile | & httpx -silent -json -o $httpxFile } | Out-Null
        $artifacts += $httpxFile
    } else {
        $script:missing += "httpx"
    }

    if (Test-Tool "nuclei") {
        $script:toolUsed = if ($script:toolUsed) { "$script:toolUsed+nuclei" } else { "nuclei" }
        $nucleiTarget = if ($TargetUrl) { $TargetUrl } else { "https://$hostName" }
        Invoke-Native { & nuclei -u $nucleiTarget -jsonl -o $nucleiFile } | Out-Null
        $artifacts += $nucleiFile
        if (Test-Path $nucleiFile) {
            Get-Content $nucleiFile | ForEach-Object {
                try {
                    $n = $_ | ConvertFrom-Json
                    Add-Finding -Severity ($n.info.severity + "").ToUpper() -Title $n.info.name `
                        -Description $n.info.description -Category "nuclei" -RawRef $nucleiFile
                } catch { }
            }
        }
    } else {
        $script:missing += "nuclei"
    }

    if (-not $findings.Count) {
        Add-Finding -Severity "INFO" -Title "recon artifacts" -Description "See $outBase" -Category "recon" -RawRef $outBase
    }
}

function Write-Report([string]$TierName) {
    $by = @{}
    foreach ($f in $findings) {
        $s = $f.severity
        if (-not $by.ContainsKey($s)) { $by[$s] = 0 }
        $by[$s]++
    }
    $report = [ordered]@{
        schemaVersion = "1.0"
        generatedAt   = (Get-Date).ToUniversalTime().ToString("o")
        tier          = $TierName
        target        = if ($TargetUrl) { $TargetUrl } elseif ($TargetHost) { $TargetHost } else { $Path }
        authorized    = [bool]$authorizedFlag
        tool          = $toolUsed
        findings      = $findings
        summary       = [ordered]@{
            total         = $findings.Count
            bySeverity    = $by
            missingTools  = $missing
            notes         = ""
        }
        artifacts     = $artifacts
    }
    $reportPath = Join-Path $OutDir "findings-$TierName-$stamp.json"
    $report | ConvertTo-Json -Depth 8 | Set-Content -Path $reportPath -Encoding utf8
    Write-Host "FINDINGS_FILE=$reportPath"
    Write-Host "total=$($findings.Count) missing=$($missing -join ',') tool=$toolUsed"
    return $reportPath
}

$exitCode = 0
switch ($Tier) {
    "secrets" { Invoke-Secrets; Write-Report "secrets" | Out-Null }
    "sast" { Invoke-Sast; Write-Report "sast" | Out-Null }
    "sca" { Invoke-Sca; Write-Report "sca" | Out-Null }
    "iac" { Invoke-Iac; Write-Report "iac" | Out-Null }
    "dast" { Invoke-Dast; Write-Report "dast" | Out-Null }
    "recon" { Invoke-Recon; Write-Report "recon" | Out-Null }
    "all-defensive" {
        Invoke-Secrets
        Invoke-Sast
        Invoke-Sca
        Invoke-Iac
        Write-Report "mixed" | Out-Null
    }
}

if ($missing.Count -gt 0 -and $findings.Count -eq 0 -and $Tier -notin @("dast", "recon")) {
    $exitCode = 3
}
exit $exitCode
