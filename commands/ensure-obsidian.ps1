# Ensure Obsidian Desktop + Local REST API (HTTP 27123) is reachable
param(
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [int]$PollSeconds = 90
)

$ErrorActionPreference = "Continue"
$mcpPath = Join-Path $HubRoot "mcp.json"

function Get-ObsidianToken {
    if (-not (Test-Path $mcpPath)) { return $null }
    try {
        $cfg = Get-Content $mcpPath -Raw | ConvertFrom-Json
        $auth = $cfg.mcpServers.obsidian.headers.Authorization
        if (-not $auth) { return $null }
        return ($auth -replace '^Bearer\s+', '').Trim()
    } catch {
        return $null
    }
}

function Test-ObsidianApi {
    param([string]$Token)
    if (-not $Token) { return @{ ok = $false; reason = "no token in mcp.json" } }
    try {
        $headers = @{ Authorization = "Bearer $Token" }
        $r = Invoke-RestMethod -Uri "http://127.0.0.1:27123/" -Headers $headers -TimeoutSec 5
        return @{ ok = ($r.status -eq "OK"); authenticated = $r.authenticated; version = $r.versions.self }
    } catch {
        return @{ ok = $false; reason = $_.Exception.Message }
    }
}

function Find-ObsidianExe {
    $candidates = @(
        (Join-Path $env:LOCALAPPDATA "Programs\Obsidian\Obsidian.exe"),
        (Join-Path $env:LOCALAPPDATA "obsidian\Obsidian.exe")
    )
    foreach ($p in $candidates) {
        if (Test-Path $p) { return $p }
    }
    try {
        $keys = @(
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Obsidian",
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{obsidian}"
        )
        foreach ($k in $keys) {
            if (Test-Path $k) {
                $disp = (Get-ItemProperty $k -ErrorAction SilentlyContinue).DisplayIcon
                if ($disp -and (Test-Path ($disp -replace ',.*$',''))) {
                    return ($disp -replace ',.*$','')
                }
            }
        }
    } catch { }
    return $null
}

function Bump-McpJson {
    if (-not (Test-Path $mcpPath)) { return }
    try {
        $raw = Get-Content $mcpPath -Raw
        $stamp = (Get-Date).ToString("o")
        if ($raw -match '# refreshed:') {
            $raw = $raw -replace '# refreshed:.*', "# refreshed: $stamp"
        } else {
            $raw = $raw.TrimEnd() + "`n# refreshed: $stamp`n"
        }
        Set-Content -Path $mcpPath -Value $raw -Encoding UTF8 -NoNewline
        Write-Host "Bumped mcp.json refresh timestamp"
    } catch {
        Write-Host "WARN: could not bump mcp.json ($($_.Exception.Message))"
    }
}

$token = Get-ObsidianToken
$health = Test-ObsidianApi -Token $token
if ($health.ok) {
    Write-Host "Obsidian OK (v$($health.version))"
    Bump-McpJson
    exit 0
}

Write-Host "Obsidian offline: $($health.reason)"

$exe = Find-ObsidianExe
if (-not $exe) {
    Write-Host "ERROR: Obsidian.exe not found. Install Obsidian Desktop."
    exit 1
}

Write-Host "Starting Obsidian: $exe"
Start-Process -FilePath $exe -ArgumentList @("--vault", $HubRoot) -ErrorAction SilentlyContinue
if (-not $?) {
    Start-Process -FilePath $exe -ErrorAction SilentlyContinue
}

$deadline = (Get-Date).AddSeconds($PollSeconds)
while ((Get-Date) -lt $deadline) {
    Start-Sleep -Seconds 3
    $health = Test-ObsidianApi -Token $token
    if ($health.ok) {
        Write-Host "Obsidian OK after start (v$($health.version))"
        Bump-McpJson
        exit 0
    }
}

Write-Host "ERROR: Obsidian did not respond on :27123 within ${PollSeconds}s. Enable Local REST API HTTP in plugin settings."
exit 1
