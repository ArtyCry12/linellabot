param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("marketing", "production")]
    [string]$Crew,
    [string]$Topic = "project",
    [string]$Project = "",
    [switch]$Json
)

$ErrorActionPreference = "Stop"
$HubRoot = Split-Path $PSScriptRoot -Parent
. (Join-Path $HubRoot "lib/crew-ai/Expand-CrewPlan.ps1")

$crewId = if ($Crew -eq "production") { "production-crew" } else { "marketing-crew" }
$vars = @{
    topic   = $Topic
    project = if ($Project) { $Project } else { $Topic }
}

$plan = Expand-CrewPlan -CrewId $crewId -Variables $vars -HubRoot $HubRoot

if ($Json) {
    $plan | ConvertTo-Json -Depth 8
    exit 0
}

Write-Output (Format-CrewPlanMarkdown -Plan $plan)
