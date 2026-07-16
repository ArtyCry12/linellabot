# Build local search index from prompts.chat / awesome-chatgpt-prompts CSV.
# Output: prompt-index.json (search) + prompt-corpus.jsonl (full text by id)

param(
    [string]$CsvUrl = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
    [string]$CsvPath = "",
    [string]$HubRoot = "",
    [int]$MaxEntries = 0,
    [switch]$DevOnly
)

$ErrorActionPreference = "Stop"

if (-not $HubRoot) {
    $HubRoot = Split-Path $PSScriptRoot -Parent
}

$outDir = Join-Path $HubRoot "lib/awesome-prompts"
if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

$csvFile = $CsvPath
if (-not $csvFile) {
    $csvFile = Join-Path $outDir "_prompts.csv"
    if (-not (Test-Path $csvFile)) {
        Write-Host "Downloading CSV..."
        Invoke-WebRequest -Uri $CsvUrl -OutFile $csvFile -UseBasicParsing
    }
}

Write-Host "Parsing $csvFile ..."
$rows = Import-Csv -Path $csvFile -Encoding UTF8

function Get-KeywordTokens {
    param([string]$Text)
    if (-not $Text) { return @() }
    $clean = ($Text -replace '[^\p{L}\p{N}\s]', ' ').ToLowerInvariant()
    $tokens = $clean -split '\s+' | Where-Object { $_.Length -ge 3 }
    return $tokens | Select-Object -Unique
}

$index = @()
$corpusPath = Join-Path $outDir "prompt-corpus.jsonl"
if (Test-Path $corpusPath) { Remove-Item $corpusPath -Force }

$id = 0
foreach ($row in $rows) {
    if ($DevOnly -and ($row.for_devs -ne "TRUE")) { continue }

    $id++
    if ($MaxEntries -gt 0 -and $id -gt $MaxEntries) { break }

    $act = [string]$row.act
    $prompt = [string]$row.prompt
    if (-not $act -or -not $prompt) { continue }

    $actTokens = Get-KeywordTokens $act
    $promptTokens = Get-KeywordTokens ($prompt.Substring(0, [Math]::Min(200, $prompt.Length)))
    $keywords = ($actTokens + $promptTokens) | Select-Object -Unique | Select-Object -First 24

    $entry = [ordered]@{
        id       = $id
        act      = $act
        for_devs = ($row.for_devs -eq "TRUE")
        type     = [string]$row.type
        keywords = @($keywords)
        preview  = if ($prompt.Length -gt 160) { $prompt.Substring(0, 160) + "..." } else { $prompt }
    }
    $index += $entry

    $corpusLine = [ordered]@{
        id     = $id
        act    = $act
        prompt = $prompt
    }
    ($corpusLine | ConvertTo-Json -Compress -Depth 3) | Add-Content -Path $corpusPath -Encoding UTF8
}

$meta = [ordered]@{
    version    = 1
    source     = "f/awesome-chatgpt-prompts (prompts.csv)"
    builtAt    = (Get-Date).ToUniversalTime().ToString("o")
    total      = $index.Count
    devOnly    = [bool]$DevOnly
}
$payload = [ordered]@{
    meta  = $meta
    items = $index
}

$indexPath = Join-Path $outDir "prompt-index.json"
$json = $payload | ConvertTo-Json -Depth 6 -Compress
[System.IO.File]::WriteAllText($indexPath, $json, [System.Text.UTF8Encoding]::new($false))

Write-Host "OK: index=$($index.Count) -> $indexPath"
Write-Host "OK: corpus -> $corpusPath"
