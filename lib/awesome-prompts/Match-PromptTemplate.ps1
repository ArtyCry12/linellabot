# Match user text against local awesome-prompts index.
# Returns top-N template matches without loading full corpus into agent context.

function Get-AwesomePromptsRoot {
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

function Find-PromptTemplates {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Query,

        [int]$Top = 3,
        [switch]$DevOnly,
        [string]$HubRoot = $null
    )

    $HubRoot = Get-AwesomePromptsRoot -HubRoot $HubRoot
    $indexPath = Join-Path $HubRoot "lib/awesome-prompts/prompt-index.json"

    if (-not (Test-Path $indexPath)) {
        return [PSCustomObject]@{
            Ok      = $false
            Error   = "Index missing. Run: commands/build-awesome-prompts-index.ps1"
            Matches = @()
        }
    }

    $data = Get-Content $indexPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $queryTokens = Get-KeywordTokens $Query
    if ($queryTokens.Count -eq 0) {
        return [PSCustomObject]@{
            Ok      = $true
            Matches = @()
            Note    = "Query too short for matching"
        }
    }

    $scored = @()
    foreach ($item in $data.items) {
        if ($DevOnly -and -not $item.for_devs) { continue }

        $score = 0
        $matched = @()
        foreach ($qt in $queryTokens) {
            foreach ($kw in $item.keywords) {
                if ($kw -eq $qt) {
                    $score += 5
                    $matched += $qt
                }
                elseif ($kw.StartsWith($qt) -or $qt.StartsWith($kw)) {
                    $score += 2
                    $matched += $qt
                }
            }
            if ($item.act.ToLowerInvariant().Contains($qt)) {
                $score += 4
                $matched += "act:$qt"
            }
        }

        if ($score -gt 0) {
            $scored += [PSCustomObject]@{
                Id      = $item.id
                Act     = $item.act
                Score   = $score
                Matched = ($matched | Select-Object -Unique)
                Preview = $item.preview
                ForDevs = $item.for_devs
                Type    = $item.type
            }
        }
    }

    $topMatches = $scored | Sort-Object Score -Descending | Select-Object -First $Top

    return [PSCustomObject]@{
        Ok      = $true
        Query   = $Query
        Total   = $data.meta.total
        Matches = @($topMatches)
    }
}

function Get-PromptTemplateById {
    param(
        [Parameter(Mandatory = $true)]
        [int]$Id,
        [string]$HubRoot = $null
    )

    $HubRoot = Get-AwesomePromptsRoot -HubRoot $HubRoot
    $corpusPath = Join-Path $HubRoot "lib/awesome-prompts/prompt-corpus.jsonl"
    if (-not (Test-Path $corpusPath)) {
        return $null
    }

    foreach ($line in [System.IO.File]::ReadLines($corpusPath)) {
        $obj = $line | ConvertFrom-Json
        if ([int]$obj.id -eq $Id) {
            return $obj
        }
    }
    return $null
}

function Expand-PromptTemplate {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Prompt,

        [hashtable]$Variables = @{}
    )

    $result = $Prompt
    foreach ($key in $Variables.Keys) {
        $val = [string]$Variables[$key]
        $patternNamed = '\$\{' + [regex]::Escape($key) + ':[^}]+\}'
        $patternPlain = '\$\{' + [regex]::Escape($key) + '\}'
        $result = [regex]::Replace($result, $patternNamed, $val)
        $result = [regex]::Replace($result, $patternPlain, $val)
    }
    return $result
}
