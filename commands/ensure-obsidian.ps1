# Ensure Obsidian Desktop + Local REST API (HTTP 27123 / HTTPS 27124) is reachable
param(
    [string]$HubRoot = "C:\Users\Asus\.cursor",
    [int]$PollSeconds = 180
)

$ErrorActionPreference = "Continue"
$mcpPath = Join-Path $HubRoot "mcp.json"
$pluginDataPath = Join-Path $HubRoot ".obsidian\plugins\obsidian-local-rest-api\data.json"

function Get-PluginConfig {
    if (-not (Test-Path $pluginDataPath)) { return $null }
    try { return Get-Content $pluginDataPath -Raw | ConvertFrom-Json } catch { return $null }
}

function Ensure-PluginHttpEnabled {
    if (-not (Test-Path $pluginDataPath)) {
        Write-Host "WARN: Local REST API plugin data.json missing"
        return
    }
    try {
        $cfg = Get-Content $pluginDataPath -Raw | ConvertFrom-Json
        $changed = $false
        if (-not $cfg.enableInsecureServer) { $cfg.enableInsecureServer = $true; $changed = $true }
        if ($cfg.insecurePort -ne 27123) { $cfg.insecurePort = 27123; $changed = $true }
        if (-not $cfg.enableSecureServer) { $cfg.enableSecureServer = $true; $changed = $true }
        if ($changed) {
            $cfg | ConvertTo-Json -Depth 6 | Set-Content -Path $pluginDataPath -Encoding UTF8
            Write-Host "Patched plugin data.json: HTTP 27123 enabled"
        }
    } catch {
        Write-Host "WARN: could not patch plugin config"
    }
}

function Sync-McpTokenFromPlugin {
    $plugin = Get-PluginConfig
    if (-not $plugin -or -not $plugin.apiKey) { return $null }
    if (-not (Test-Path $mcpPath)) { return $plugin.apiKey }
    try {
        $cfg = Get-Content $mcpPath -Raw | ConvertFrom-Json
        $current = $cfg.mcpServers.obsidian.headers.Authorization -replace '^Bearer\s+', ''
        if ($current -ne $plugin.apiKey) {
            $cfg.mcpServers.obsidian.headers.Authorization = "Bearer $($plugin.apiKey)"
            $cfg | ConvertTo-Json -Depth 10 | Set-Content -Path $mcpPath -Encoding UTF8
            Write-Host "Synced mcp.json Bearer from plugin apiKey"
        }
        return $plugin.apiKey
    } catch {
        return $plugin.apiKey
    }
}

function Get-ObsidianToken {
    $fromPlugin = Sync-McpTokenFromPlugin
    if ($fromPlugin) { return $fromPlugin.Trim() }
    if (-not (Test-Path $mcpPath)) { return $null }
    try {
        $cfg = Get-Content $mcpPath -Raw | ConvertFrom-Json
        $auth = $cfg.mcpServers.obsidian.headers.Authorization
        if (-not $auth) { return $null }
        return ($auth -replace '^Bearer\s+', '').Trim()
    } catch { return $null }
}

function Test-ObsidianApi {
    param([string]$Token)
    if (-not $Token) { return @{ ok = $false; reason = "no token"; transport = $null } }

    $endpoints = @(
        @{ uri = "http://127.0.0.1:27123/"; transport = "http" },
        @{ uri = "https://127.0.0.1:27124/"; transport = "https" }
    )

    foreach ($entry in $endpoints) {
        try {
            $job = Start-Job -ScriptBlock {
                param($Uri, $Tok, $IsHttps)
                $p = @{
                    Uri         = $Uri
                    Headers     = @{ Authorization = "Bearer $Tok" }
                    TimeoutSec  = 8
                    ErrorAction = "Stop"
                }
                if ($IsHttps) { $p.SkipCertificateCheck = $true }
                return Invoke-RestMethod @p
            } -ArgumentList $entry.uri, $Token, ($entry.transport -eq "https")
            if (-not (Wait-Job $job -Timeout 12)) {
                Stop-Job $job -Force -ErrorAction SilentlyContinue
                Remove-Job $job -Force -ErrorAction SilentlyContinue
                continue
            }
            $r = Receive-Job $job
            Remove-Job $job -Force -ErrorAction SilentlyContinue
            if ($r.status -eq "OK") {
                return @{
                    ok            = $true
                    authenticated = $r.authenticated
                    version       = $r.versions.self
                    transport     = $entry.transport
                }
            }
        } catch { }
    }
    return @{ ok = $false; reason = "no response on port 27123 or 27124"; transport = $null }
}

function Restart-ObsidianIfHung {
    $listening = netstat -an | Select-String "127.0.0.1:27123.*LISTENING"
    if (-not $listening) { return $false }
    $token = Get-ObsidianToken
    $h = Test-ObsidianApi -Token $token
    if ($h.ok) { return $false }
    Write-Host "Obsidian REST API hung - restarting Obsidian..."
    Get-Process -Name Obsidian -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
    return $true
}

function Find-ObsidianExe {
    $candidates = @(
        (Join-Path $env:LOCALAPPDATA "Programs\Obsidian\Obsidian.exe"),
        (Join-Path $env:LOCALAPPDATA "obsidian\Obsidian.exe")
    )
    foreach ($p in $candidates) { if (Test-Path $p) { return $p } }
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
    } catch { }
}

Ensure-PluginHttpEnabled
$null = Restart-ObsidianIfHung
$token = Get-ObsidianToken
$health = Test-ObsidianApi -Token $token
if ($health.ok) {
    Write-Host "Obsidian OK via $($health.transport) (v$($health.version))"
    Bump-McpJson
    exit 0
}

Write-Host "Obsidian offline: $($health.reason)"

$exe = Find-ObsidianExe
if (-not $exe) {
    Write-Host "ERROR: Obsidian.exe not found"
    exit 1
}

$vaultUri = "obsidian://open?vault=" + [uri]::EscapeDataString($HubRoot)
Write-Host "Launching Obsidian vault: $HubRoot"
Start-Process $vaultUri -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
if (-not (Get-Process -Name Obsidian -ErrorAction SilentlyContinue)) {
    Start-Process -FilePath $exe -ArgumentList @("`"$HubRoot`"") -ErrorAction SilentlyContinue
}

$deadline = (Get-Date).AddSeconds($PollSeconds)
while ((Get-Date) -lt $deadline) {
    Start-Sleep -Seconds 4
    $health = Test-ObsidianApi -Token $token
    if ($health.ok) {
        Write-Host "Obsidian OK after start via $($health.transport) (v$($health.version))"
        Bump-McpJson
        exit 0
    }
}

Write-Host "ERROR: Obsidian still offline after $PollSeconds seconds."
Write-Host "Check: vault open at $HubRoot; Local REST API plugin enabled; HTTP server on port 27123."
exit 1
