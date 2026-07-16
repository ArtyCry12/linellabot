# Expand crew JSON into Cursor Task spawn plan (Boss / squad-growth)

function Get-CrewAiRoot {
    param([string]$HubRoot = $null)
    if (-not $HubRoot) {
        $HubRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
        if (-not (Test-Path (Join-Path $HubRoot "hooks.json"))) {
            $HubRoot = "C:\Users\Asus\.cursor"
        }
    }
    return $HubRoot
}

function Expand-CrewVariables {
    param(
        [string]$Text,
        [hashtable]$Vars
    )
    if (-not $Text) { return $Text }
    $out = $Text
    foreach ($k in $Vars.Keys) {
        $out = $out -replace ('\{' + [regex]::Escape($k) + '\}'), [string]$Vars[$k]
    }
    return $out
}

function Get-CrewDefinition {
    param(
        [Parameter(Mandatory = $true)]
        [string]$CrewId,
        [string]$HubRoot = $null
    )

    $HubRoot = Get-CrewAiRoot -HubRoot $HubRoot
    $path = Join-Path $HubRoot "lib/crew-ai/crews/$CrewId.json"
    if (-not (Test-Path $path)) {
        $path = Join-Path $HubRoot "lib/crew-ai/crews/$CrewId-crew.json"
    }
    if (-not (Test-Path $path)) {
        throw "Crew not found: $CrewId (looked for $CrewId.json and $CrewId-crew.json)"
    }
    return Get-Content $path -Raw -Encoding UTF8 | ConvertFrom-Json
}

function Expand-CrewPlan {
    param(
        [Parameter(Mandatory = $true)]
        [string]$CrewId,

        [hashtable]$Variables = @{ topic = "project"; project = "project" },
        [string]$HubRoot = $null
    )

    $HubRoot = Get-CrewAiRoot -HubRoot $HubRoot
    $crew = Get-CrewDefinition -CrewId $CrewId -HubRoot $HubRoot

    $agentMap = @{}
    foreach ($a in $crew.agents) {
        $agentMap[$a.id] = $a
    }

    $tasks = @()
    foreach ($t in $crew.tasks) {
        $agent = $agentMap[$t.agent]
        $tasks += [PSCustomObject]@{
            TaskId         = $t.id
            AgentId        = $t.agent
            Subagent       = $agent.hubSubagent
            Skill          = $agent.hubSkill
            Role           = Expand-CrewVariables -Text $agent.role -Vars $Variables
            Goal           = Expand-CrewVariables -Text $agent.goal -Vars $Variables
            Description    = Expand-CrewVariables -Text $t.description -Vars $Variables
            ExpectedOutput = Expand-CrewVariables -Text $t.expectedOutput -Vars $Variables
            DependsOn      = @($t.dependsOn)
            Mcp            = @($agent.mcp)
            Commands       = @($agent.commands)
        }
    }

    return [PSCustomObject]@{
        CrewId      = $crew.id
        Process     = $crew.process
        HubPhase    = $crew.hubPhase
        Description = $crew.description
        Variables   = $Variables
        Tasks       = $tasks
        Gates       = $crew.gates
    }
}

function Format-CrewPlanMarkdown {
    param(
        [Parameter(Mandatory = $true)]
        $Plan
    )

    $lines = @()
    $lines += "# Crew plan: $($Plan.CrewId)"
    $lines += ""
    $lines += "**Process:** $($Plan.Process) | **Hub phase:** $($Plan.HubPhase)"
    $lines += ""
    if ($Plan.Gates.publishRequiresApproval) {
        $lines += "> Gate: publish requires explicit user approval."
    }
    $lines += ""

    $order = 1
    foreach ($t in $Plan.Tasks) {
        $deps = if ($t.DependsOn.Count -gt 0) { "depends: " + ($t.DependsOn -join ", ") } else { "depends: none" }
        $lines += ("## Step {0} - {1} ({2})" -f $order, $t.TaskId, $deps)
        $lines += ""
        $lines += ("**Subagent:** {0}" -f $t.Subagent)
        if ($t.Skill) { $lines += ("**Skill:** {0}" -f $t.Skill) }
        $lines += ""
        $lines += "**Role:** $($t.Role)"
        $lines += "**Goal:** $($t.Goal)"
        $lines += ""
        $lines += "**Task:** $($t.Description)"
        $lines += ""
        $lines += "**Expected output:** $($t.ExpectedOutput)"
        $lines += ""
        $lines += '```'
        $lines += "Use the $($t.Subagent) subagent to: $($t.Description)"
        $lines += "Expected: $($t.ExpectedOutput)"
        $lines += '```'
        $lines += ""
        $order++
    }

    return ($lines -join "`n")
}
