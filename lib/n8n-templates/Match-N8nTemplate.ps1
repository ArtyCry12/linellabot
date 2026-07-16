# Match user query against local n8n template index.

function Get-N8nTemplatesRoot {
    param([string]$HubRoot = $null)
    if (-not $HubRoot) {
        $HubRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
        if (-not (Test-Path (Join-Path $HubRoot "hooks.json"))) {
            $HubRoot = "C:\Users\Asus\.cursor"
        }
    }
    return $HubRoot
}

function Get-KeywordTokens {
    param([string]$Text)
    if (-not $Text) { return @() }
    $clean = ($Text -replace '[^\p{L}\p{N}\s]', ' ').ToLowerInvariant()
    return @($clean -split '\s+' | Where-Object { $_.Length -ge 3 })
}

function Find-N8nTemplates {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Query,
        [int]$Top = 3,
        [string]$HubRoot = $null
    )

    $HubRoot = Get-N8nTemplatesRoot -HubRoot $HubRoot
    $indexPath = Join-Path $HubRoot "lib\n8n-templates\template-index.json"

    if (-not (Test-Path $indexPath)) {
        return [PSCustomObject]@{
            Ok      = $false
            Error   = "Index missing. Run: commands/build-n8n-templates-index.ps1 -ForceClone"
            Matches = @()
        }
    }

    $data = Get-Content $indexPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $queryTokens = Get-KeywordTokens $Query
    if ($queryTokens.Count -eq 0) {
        return [PSCustomObject]@{
            Ok      = $true
            Matches = @()
            Note    = "Query too short"
            Total   = $data.total
        }
    }

    $scored = @()
    foreach ($item in $data.items) {
        $score = 0
        $matched = @()

        foreach ($qt in $queryTokens) {
            foreach ($kw in $item.keywords) {
                if ($kw -eq $qt) { $score += 5; $matched += $qt }
                elseif ($kw.StartsWith($qt) -or $qt.StartsWith($kw)) { $score += 2; $matched += $qt }
            }
            if (([string]$item.title).ToLowerInvariant().Contains($qt)) { $score += 4; $matched += "title:$qt" }
            if (([string]$item.category).ToLowerInvariant().Contains($qt)) { $score += 3; $matched += "cat:$qt" }
            foreach ($n in @($item.nodes)) {
                $ns = [string]$n
                if ($ns.ToLowerInvariant().Contains($qt)) { $score += 2; $matched += "node:$qt"; break }
            }
            foreach ($t in @($item.triggers)) {
                $ts = [string]$t
                if ($ts.ToLowerInvariant().Contains($qt)) { $score += 3; $matched += "trig:$qt"; break }
            }
        }

        if ($score -gt 0) {
            $scored += [PSCustomObject]@{
                Id       = $item.id
                Title    = $item.title
                Category = $item.category
                Score    = $score
                Matched  = @($matched | Select-Object -Unique)
                RelPath  = $item.relPath
                Nodes    = $item.nodes
                Triggers = $item.triggers
            }
        }
    }

    $topMatches = $scored | Sort-Object Score -Descending | Select-Object -First $Top
    return [PSCustomObject]@{
        Ok      = $true
        Matches = @($topMatches)
        Total   = $data.total
    }
}

function Get-N8nTemplateById {
    param(
        [Parameter(Mandatory = $true)]
        [int]$Id,
        [string]$HubRoot = $null
    )

    $HubRoot = Get-N8nTemplatesRoot -HubRoot $HubRoot
    $corpusPath = Join-Path $HubRoot "lib\n8n-templates\template-corpus.jsonl"
    if (-not (Test-Path $corpusPath)) { return $null }

    foreach ($line in [System.IO.File]::ReadLines($corpusPath)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $row = $line | ConvertFrom-Json
        if ([int]$row.id -eq $Id) {
            $src = $row.srcFile
            if (-not $src -and $row.relPath) {
                $manifest = Join-Path $HubRoot "lib\n8n-templates\template-manifest.json"
                if (Test-Path $manifest) {
                    $m = Get-Content $manifest -Raw | ConvertFrom-Json
                    $src = Join-Path $m.srcDir $row.relPath
                }
            }
            $json = $null
            if ($src -and (Test-Path -LiteralPath $src)) {
                $json = Get-Content -LiteralPath $src -Raw -Encoding UTF8
            }
            return [PSCustomObject]@{
                Id      = $row.id
                Title   = $row.title
                RelPath = $row.relPath
                SrcFile = $src
                Json    = $json
            }
        }
    }
    return $null
}
