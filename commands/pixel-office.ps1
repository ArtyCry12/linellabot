# Pixel Office — update squad agent status + open browser
param(
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [string]$Agent = "",
    [ValidateSet("idle", "working")]
    [string]$State = "working",
    [string]$Task = "",
    [switch]$OpenOnly,
    [int]$Port = 8799
)

$officeDir = Join-Path $HubRoot "tools\pixel-office"
$statusPath = Join-Path $officeDir "status.json"

function Update-Status {
    param([string]$Id, [string]$St, [string]$Tk)
    if (-not (Test-Path $statusPath)) { return }
    $data = Get-Content $statusPath -Raw | ConvertFrom-Json
    $data.updatedAt = (Get-Date).ToString("o")
    foreach ($a in $data.agents) {
        if ($a.id -eq $Id) { $a.state = $St }
    }
    if ($Tk) {
        $data.lastEvent = @{ id = $Id; state = $St; task = $Tk }
    }
    $data | ConvertTo-Json -Depth 5 | Set-Content $statusPath -Encoding UTF8
}

if ($Agent -and -not $OpenOnly) {
    Update-Status -Id $Agent -St $State -Task $Task
    Write-Host "Pixel office: $Agent → $State $(if ($Task) { "($Task)" })"
}

$listener = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
if (-not $listener) {
    Start-Process -FilePath "python" -ArgumentList "-m", "http.server", $Port `
        -WorkingDirectory $officeDir -WindowStyle Hidden
    Start-Sleep -Seconds 1
}

if ($OpenOnly -or $Agent) {
    Start-Process "http://localhost:$Port/"
}
