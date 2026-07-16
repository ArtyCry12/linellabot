# BabyAGI-style creative task loop for Cursor hub (file-backed, no Python).

function Get-BabyAgiRoot {
    param([string]$HubRoot = $null)
    if (-not $HubRoot) {
        $HubRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
        if (-not (Test-Path (Join-Path $HubRoot "hooks.json"))) {
            $HubRoot = "C:\Users\Asus\.cursor"
        }
    }
    return $HubRoot
}

function Get-CreativeLoopSessionDir {
    param(
        [string]$SessionId,
        [string]$HubRoot = $null
    )
    $HubRoot = Get-BabyAgiRoot -HubRoot $HubRoot
    return Join-Path $HubRoot "ai-tracking/creative-loop/sessions/$SessionId"
}

function Initialize-CreativeLoop {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Objective,

        [string]$SessionId = "",
        [string]$Context = "",
        [int]$MaxTasks = 12,
        [string]$HubRoot = $null
    )

    $HubRoot = Get-BabyAgiRoot -HubRoot $HubRoot
    if (-not $SessionId) {
        $SessionId = (Get-Date).ToString("yyyyMMdd-HHmmss") + "-" + ([guid]::NewGuid().ToString().Substring(0, 8))
    }

    $dir = Get-CreativeLoopSessionDir -SessionId $SessionId -HubRoot $HubRoot
    New-Item -ItemType Directory -Path $dir -Force | Out-Null

    $seedTasks = @(
        [ordered]@{
            id          = "t1"
            description = "Brainstorm 5 distinct angles for the objective"
            status      = "pending"
            priority    = 1
            createdAt   = (Get-Date).ToUniversalTime().ToString("o")
        },
        [ordered]@{
            id          = "t2"
            description = "Pick the strongest angle and outline 3 concrete deliverables"
            status      = "pending"
            priority    = 2
            createdAt   = (Get-Date).ToUniversalTime().ToString("o")
        },
        [ordered]@{
            id          = "t3"
            description = "Draft the first deliverable (minimal viable artifact)"
            status      = "pending"
            priority    = 3
            createdAt   = (Get-Date).ToUniversalTime().ToString("o")
        }
    )

    $manifest = [ordered]@{
        version   = 1
        sessionId = $SessionId
        objective = $Objective
        context   = $Context
        maxTasks  = $MaxTasks
        createdAt = (Get-Date).ToUniversalTime().ToString("o")
        status    = "active"
        tasks     = $seedTasks
    }

    $manifestPath = Join-Path $dir "manifest.json"
    ($manifest | ConvertTo-Json -Depth 8) | Set-Content -Path $manifestPath -Encoding UTF8

    $resultsPath = Join-Path $dir "results.jsonl"
    if (-not (Test-Path $resultsPath)) {
        New-Item -ItemType File -Path $resultsPath -Force | Out-Null
    }

    return [PSCustomObject]@{
        SessionId = $SessionId
        Dir       = $dir
        Manifest  = $manifestPath
        Tasks     = $seedTasks.Count
    }
}

function Get-CreativeLoopManifest {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SessionId,
        [string]$HubRoot = $null
    )

    $dir = Get-CreativeLoopSessionDir -SessionId $SessionId -HubRoot $HubRoot
    $path = Join-Path $dir "manifest.json"
    if (-not (Test-Path $path)) {
        throw "Session not found: $SessionId"
    }
    return Get-Content $path -Raw -Encoding UTF8 | ConvertFrom-Json
}

function ConvertTo-MutableTask {
    param($Task)
    $h = [ordered]@{
        id          = $Task.id
        description = $Task.description
        status      = $Task.status
        priority    = [int]$Task.priority
        createdAt   = $Task.createdAt
    }
    if ($Task.PSObject.Properties.Name -contains "parentId") { $h.parentId = $Task.parentId }
    if ($Task.PSObject.Properties.Name -contains "completedAt") { $h.completedAt = $Task.completedAt }
    return $h
}

function Save-CreativeLoopManifest {
    param(
        [Parameter(Mandatory = $true)]
        $Manifest,
        [string]$HubRoot = $null
    )

    $dir = Get-CreativeLoopSessionDir -SessionId $Manifest.sessionId -HubRoot $HubRoot
    $path = Join-Path $dir "manifest.json"
    ($Manifest | ConvertTo-Json -Depth 8) | Set-Content -Path $path -Encoding UTF8
}

function Get-NextCreativeTask {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SessionId,
        [string]$HubRoot = $null
    )

    $m = Get-CreativeLoopManifest -SessionId $SessionId -HubRoot $HubRoot
    $pending = @($m.tasks | Where-Object { $_.status -eq "pending" } | Sort-Object { [int]$_.priority })
    if ($pending.Count -eq 0) {
        return $null
    }

    $next = $pending[0]
    $newTasks = @()
    foreach ($t in $m.tasks) {
        $mt = ConvertTo-MutableTask $t
        if ($mt.id -eq $next.id) { $mt.status = "active" }
        $newTasks += $mt
    }
    $m.tasks = $newTasks
    Save-CreativeLoopManifest -Manifest $m -HubRoot $HubRoot
    return ($newTasks | Where-Object { $_.id -eq $next.id } | Select-Object -First 1)
}

function Complete-CreativeTask {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SessionId,

        [Parameter(Mandatory = $true)]
        [string]$TaskId,

        [Parameter(Mandatory = $true)]
        [string]$Result,

        [string]$HubRoot = $null
    )

    $m = Get-CreativeLoopManifest -SessionId $SessionId -HubRoot $HubRoot
    $found = $false
    $newTasks = @()
    $ts = (Get-Date).ToUniversalTime().ToString("o")
    foreach ($t in $m.tasks) {
        $mt = ConvertTo-MutableTask $t
        if ($mt.id -eq $TaskId) {
            $mt.status = "done"
            $mt.completedAt = $ts
            $found = $true
        }
        $newTasks += $mt
    }
    if (-not $found) {
        throw "Task not found: $TaskId"
    }
    $m.tasks = $newTasks

    $pendingLeft = @($newTasks | Where-Object { $_.status -eq "pending" -or $_.status -eq "active" })
    if ($pendingLeft.Count -eq 0) {
        $m.status = "completed"
    }

    Save-CreativeLoopManifest -Manifest $m -HubRoot $HubRoot

    $dir = Get-CreativeLoopSessionDir -SessionId $SessionId -HubRoot $HubRoot
    $record = [ordered]@{
        taskId    = $TaskId
        result    = $Result
        timestamp = (Get-Date).ToUniversalTime().ToString("o")
    }
    ($record | ConvertTo-Json -Compress) | Add-Content -Path (Join-Path $dir "results.jsonl") -Encoding UTF8

    return [PSCustomObject]@{
        TaskId  = $TaskId
        Status  = $m.status
        Pending = @($pendingLeft | Where-Object { $_.status -eq "pending" }).Count
    }
}

function Add-CreativeTasks {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SessionId,

        [Parameter(Mandatory = $true)]
        [object[]]$NewTasks,

        [string]$HubRoot = $null
    )

    $m = Get-CreativeLoopManifest -SessionId $SessionId -HubRoot $HubRoot
    $existing = @($m.tasks).Count
    if ($existing + $NewTasks.Count -gt [int]$m.maxTasks) {
        throw "Max tasks $($m.maxTasks) would be exceeded"
    }

    $maxPrio = 0
    foreach ($t in $m.tasks) {
        if ([int]$t.priority -gt $maxPrio) { $maxPrio = [int]$t.priority }
    }

    $taskList = @()
    foreach ($t in $m.tasks) {
        $taskList += ConvertTo-MutableTask $t
    }

    $added = @()
    $i = 0
    foreach ($nt in $NewTasks) {
        $i++
        $id = if ($nt.id) { $nt.id } else { "t$($taskList.Count + $i)" }
        $entry = [ordered]@{
            id          = $id
            description = if ($nt.description) { $nt.description } else { [string]$nt }
            status      = "pending"
            priority    = if ($nt.priority) { [int]$nt.priority } else { $maxPrio + $i }
            createdAt   = (Get-Date).ToUniversalTime().ToString("o")
        }
        if ($nt.parentId) { $entry.parentId = $nt.parentId }
        $taskList += $entry
        $added += $id
    }

    $m.tasks = $taskList

    Save-CreativeLoopManifest -Manifest $m -HubRoot $HubRoot
    return $added
}

function Get-CreativeLoopStatus {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SessionId,
        [string]$HubRoot = $null
    )

    $m = Get-CreativeLoopManifest -SessionId $SessionId -HubRoot $HubRoot
    $tasks = @($m.tasks)
    return [PSCustomObject]@{
        SessionId = $m.sessionId
        Objective = $m.objective
        Status    = $m.status
        Total     = $tasks.Count
        Pending   = @($tasks | Where-Object { $_.status -eq "pending" }).Count
        Active    = @($tasks | Where-Object { $_.status -eq "active" }).Count
        Done      = @($tasks | Where-Object { $_.status -eq "done" }).Count
        MaxTasks  = $m.maxTasks
    }
}
