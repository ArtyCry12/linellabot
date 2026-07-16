# CLI: match user query against local prompt index

param(
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [int]$Top = 3,
    [switch]$DevOnly,
    [switch]$Full,
    [int]$Id = 0
)

$HubRoot = Split-Path $PSScriptRoot -Parent
. (Join-Path $HubRoot "lib/awesome-prompts/Match-PromptTemplate.ps1")

if ($Id -gt 0) {
    $t = Get-PromptTemplateById -Id $Id -HubRoot $HubRoot
    if (-not $t) {
        Write-Error "Template id=$Id not found"
        exit 1
    }
    Write-Output "=== $($t.act) (id=$($t.id)) ==="
    Write-Output $t.prompt
    exit 0
}

$r = Find-PromptTemplates -Query $Query -Top $Top -DevOnly:$DevOnly -HubRoot $HubRoot
if (-not $r.Ok) {
    Write-Error $r.Error
    exit 1
}

if ($r.Matches.Count -eq 0) {
    Write-Output "No matches (index total: $($r.Total))"
    exit 0
}

foreach ($m in $r.Matches) {
    Write-Output ""
    Write-Output ("[{0}] score={1} act={2}" -f $m.Id, $m.Score, $m.Act)
    Write-Output ("  matched: " + ($m.Matched -join ", "))
    Write-Output ("  preview: " + $m.Preview)
    if ($Full) {
        $full = Get-PromptTemplateById -Id $m.Id -HubRoot $HubRoot
        if ($full) {
            Write-Output "--- full ---"
            Write-Output $full.prompt
        }
    }
}
