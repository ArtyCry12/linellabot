param(
    [Parameter(Mandatory = $true)]
    [string]$TaskFp,
    [Parameter(Mandatory = $true)]
    [string]$System,
    [Parameter(Mandatory = $true)]
    [string]$Why,
    [Parameter(Mandatory = $true)]
    [string]$Evidence,
    [ValidateSet("done", "skipped", "blocked")]
    [string]$Status = "done",
    [string]$HubRoot = ""
)

$ErrorActionPreference = "Stop"
if (-not $HubRoot) { $HubRoot = Split-Path $PSScriptRoot -Parent }

function Protect-TaskRouterReceiptText {
    param([string]$Text, [int]$MaxLength = 240)
    $safe = $Text
    $safe = $safe -replace '(?i)\bhttps?://\S+', '[url]'
    $safe = $safe -replace '(?i)\b[\w.+-]+@[\w.-]+\.[a-z]{2,}\b', '[email]'
    $safe = $safe -replace '(?i)\b(?:sk|pk|rk|api)[-_][a-z0-9_-]{8,}\b', '[secret]'
    $safe = $safe -replace '(?i)(^|[\s,;])([\w-]*(?:api[_-]?key|token|secret|password|passwd)[\w-]*|\u043F\u0430\u0440\u043E\u043B\p{L}*)\s*(?:[:=]\s*|\s+)\S+', '$1$2=[secret]'
    $safe = $safe -replace '\s+', ' '
    $safe = $safe.Trim()
    if ($safe.Length -gt $MaxLength) { $safe = $safe.Substring(0, $MaxLength) }
    return $safe
}

$dir = Join-Path $HubRoot ".cache/task-router"
if (-not (Test-Path -LiteralPath $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}
$entry = [ordered]@{
    ts       = (Get-Date).ToUniversalTime().ToString("o")
    taskFp   = $TaskFp
    system   = $System
    why      = Protect-TaskRouterReceiptText -Text $Why -MaxLength 160
    evidence = Protect-TaskRouterReceiptText -Text $Evidence
    status   = $Status
}
Add-Content -LiteralPath (Join-Path $dir "receipts.jsonl") `
    -Value ($entry | ConvertTo-Json -Compress) -Encoding UTF8

Write-Output "receipt:${System}:${Status}"
