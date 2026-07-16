# CLI: match n8n workflow templates from local index

param(
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [int]$Top = 3,
    [switch]$Full,
    [int]$Id = 0
)

$HubRoot = Split-Path $PSScriptRoot -Parent
. (Join-Path $HubRoot "lib\n8n-templates\Match-N8nTemplate.ps1")

if ($Id -gt 0) {
    $t = Get-N8nTemplateById -Id $Id -HubRoot $HubRoot
    if (-not $t) {
        Write-Error "Template id=$Id not found"
        exit 1
    }
    Write-Output "=== $($t.Title) (id=$($t.Id)) ==="
    Write-Output "Path: $($t.RelPath)"
    if ($Full) { Write-Output $t.Json }
    exit 0
}

$r = Find-N8nTemplates -Query $Query -Top $Top -HubRoot $HubRoot
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
    Write-Output ("[{0}] score={1} cat={2}" -f $m.Id, $m.Score, $m.Category)
    Write-Output ("  title: " + $m.Title)
    Write-Output ("  path: " + $m.RelPath)
    Write-Output ("  matched: " + ($m.Matched -join ", "))
    if ($Full) {
        $full = Get-N8nTemplateById -Id $m.Id -HubRoot $HubRoot
        if ($full) {
            Write-Output "--- json (truncated in log) ---"
            Write-Output $full.Json.Substring(0, [Math]::Min(2000, $full.Json.Length))
        }
    }
}
