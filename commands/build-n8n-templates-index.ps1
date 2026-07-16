# Build local search index from awesome-n8n-templates JSON workflows.
# Output: template-index.json + template-corpus.jsonl (full workflow by id)

param(
    [string]$HubRoot = "",
    [string]$SrcDir = "",
    [switch]$ForceClone
)

$ErrorActionPreference = "Stop"

if (-not $HubRoot) { $HubRoot = Split-Path $PSScriptRoot -Parent }
if (-not $SrcDir) { $SrcDir = Join-Path $HubRoot "lib\n8n-templates-src" }

$outDir = Join-Path $HubRoot "lib\n8n-templates"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

if (-not (Test-Path $SrcDir)) {
    if ($ForceClone) {
        Write-Host "Cloning awesome-n8n-templates..."
        & git clone --depth 1 https://github.com/enescingoz/awesome-n8n-templates.git $SrcDir
    }
    else {
        Write-Error "Source missing: $SrcDir. Run with -ForceClone or: git clone --depth 1 https://github.com/enescingoz/awesome-n8n-templates.git $SrcDir"
        exit 1
    }
}

function Get-KeywordTokens {
    param([string]$Text)
    if (-not $Text) { return @() }
    $clean = ($Text -replace '[^\p{L}\p{N}\s]', ' ').ToLowerInvariant()
    return @($clean -split '\s+' | Where-Object { $_.Length -ge 3 })
}

function Get-TriggerTypes {
    param($Nodes)
    $triggers = @()
    foreach ($n in $Nodes) {
        $t = [string]$n.type
        if ($t -match 'Trigger$' -or $t -match 'trigger' -or $t -match 'webhook') {
            $triggers += $t
        }
    }
    return @($triggers | Select-Object -Unique)
}

$index = @()
$corpusPath = Join-Path $outDir "template-corpus.jsonl"
if (Test-Path $corpusPath) { Remove-Item $corpusPath -Force }

$manifestPath = Join-Path $outDir "template-manifest.json"

$id = 0
$files = Get-ChildItem -Path $SrcDir -Recurse -Filter "*.json" -File |
    Where-Object {
        $_.FullName -notmatch '\\\.github\\' -and
        $_.DirectoryName -ne $SrcDir
    }

Write-Host "Indexing $($files.Count) workflow JSON files..."

foreach ($f in $files) {
    try {
        $raw = Get-Content $f.FullName -Raw -Encoding UTF8
        $wf = $raw | ConvertFrom-Json
    }
    catch {
        Write-Host "SKIP parse: $($f.Name)"
        continue
    }

    if (-not $wf.nodes) { continue }

    $id++
    $relPath = $f.FullName.Substring($SrcDir.Length).TrimStart('\', '/')
    $category = $f.Directory.Name
    if ($category -eq $SrcDir -or $category -eq (Split-Path $SrcDir -Leaf)) {
        $category = "root"
    }

    $name = if ($wf.name) { [string]$wf.name } else { $f.BaseName }
    $nodeTypes = @($wf.nodes | ForEach-Object { [string]$_.type } | Where-Object { $_ } | Select-Object -Unique)
    $triggers = Get-TriggerTypes -Nodes $wf.nodes
    $keywords = Get-KeywordTokens ($name + " " + $category + " " + ($nodeTypes -join " "))
    $keywords = @($keywords | Select-Object -Unique | Select-Object -First 30)

    $index += [ordered]@{
        id        = $id
        title     = $name
        category  = $category
        relPath   = $relPath
        nodes     = @($nodeTypes | Select-Object -First 20)
        triggers  = $triggers
        keywords  = $keywords
        nodeCount = $wf.nodes.Count
    }

    $corpusLine = [ordered]@{
        id       = $id
        title    = $name
        relPath  = $relPath
        srcFile  = $f.FullName
    }
    ($corpusLine | ConvertTo-Json -Compress) | Add-Content -Path $corpusPath -Encoding UTF8
}

$payload = [ordered]@{
    version    = 1
    builtAt    = (Get-Date).ToUniversalTime().ToString("o")
    source     = "https://github.com/enescingoz/awesome-n8n-templates"
    srcDir     = $SrcDir
    total      = $index.Count
    items      = $index
}
$indexPath = Join-Path $outDir "template-index.json"
($payload | ConvertTo-Json -Depth 8) | Set-Content -Path $indexPath -Encoding UTF8

[ordered]@{
    srcDir = $SrcDir
    total  = $index.Count
} | ConvertTo-Json | Set-Content -Path $manifestPath -Encoding UTF8

Write-Output "OK: $($index.Count) templates -> $indexPath"
Write-Output "Corpus: $corpusPath"
