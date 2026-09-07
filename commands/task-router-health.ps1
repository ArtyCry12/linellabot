param(
    [switch]$IncludeTests,
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"
$decisionPath = Join-Path $HubRoot "ai-tracking/task-router-log.jsonl"
$receiptPath = Join-Path $HubRoot ".cache/task-router/receipts.jsonl"

function Read-TaskRouterJsonLines {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return @() }
    return @(Get-Content -LiteralPath $Path -Encoding UTF8 | ForEach-Object {
        try { $_ | ConvertFrom-Json } catch { $null }
    } | Where-Object { $_ })
}

function Get-TaskRouterPercentile {
    param([double[]]$Values, [double]$Percentile)
    if (-not $Values -or $Values.Count -eq 0) { return 0 }
    $sorted = @($Values | Sort-Object)
    $index = [Math]::Min($sorted.Count - 1, [Math]::Ceiling($sorted.Count * $Percentile) - 1)
    return [double]$sorted[$index]
}

$decisions = @(Read-TaskRouterJsonLines -Path $decisionPath)
if (-not $IncludeTests) {
    $decisions = @($decisions | Where-Object {
        $_.source -notmatch '^(test|test-fp|test-fx|smoke)'
    })
}
$receipts = @(Read-TaskRouterJsonLines -Path $receiptPath)

$total = $decisions.Count
$matched = @($decisions | Where-Object { $_.matched }).Count
$advisor = @($decisions | Where-Object { $_.advisor }).Count
$semantic = @($decisions | Where-Object { $_.semantic }).Count
$unmatched = @($decisions | Where-Object {
    -not $_.matched -and -not $_.skipped -and -not $_.advisor
}).Count
$latencies = @($decisions | Where-Object { $_.latencyMs -gt 0 } |
    ForEach-Object { [double]$_.latencyMs })
$p95 = Get-TaskRouterPercentile -Values $latencies -Percentile 0.95

$missing = @()
foreach ($decision in $decisions) {
    foreach ($action in @($decision.actions)) {
        $found = @($receipts | Where-Object {
            $_.taskFp -eq $decision.fp -and $_.system -eq $action
        }).Count -gt 0
        if (-not $found) {
            $missing += [PSCustomObject]@{ fp = $decision.fp; action = $action }
        }
    }
}

Write-Output "Task Router Max health"
Write-Output "======================"
Write-Output "Decisions (real)      : $total"
Write-Output "Matched               : $matched"
Write-Output "Advisor required      : $advisor"
Write-Output "Unrouted without help : $unmatched"
Write-Output "Semantic decisions    : $semantic"
Write-Output ("Local latency p95     : {0:N1} ms" -f $p95)
Write-Output "Receipts              : $($receipts.Count)"
Write-Output "Missing receipts      : $($missing.Count)"

if ($missing.Count -gt 0) {
    Write-Output ""
    Write-Output "Missing required actions:"
    $missing | Group-Object action | Sort-Object Count -Descending |
        Select-Object -First 10 | ForEach-Object {
            Write-Output ("  {0,-30} {1}" -f $_.Name, $_.Count)
        }
}

if (($latencies.Count -ge 20 -and $p95 -gt 250) -or $unmatched -gt 0) { exit 1 }
exit 0
