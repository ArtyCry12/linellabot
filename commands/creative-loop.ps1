param(
    [ValidateSet("init", "next", "complete", "expand", "status", "list")]
    [string]$Action = "status",
    [string]$Objective = "",
    [string]$SessionId = "",
    [string]$TaskId = "",
    [string]$Result = "",
    [string]$TasksJson = "",
    [string]$Context = ""
)

$ErrorActionPreference = "Stop"
$HubRoot = Split-Path $PSScriptRoot -Parent
. (Join-Path $HubRoot "lib/babyagi/CreativeLoop.ps1")

$sessionsRoot = Join-Path $HubRoot "ai-tracking/creative-loop/sessions"
if (-not (Test-Path $sessionsRoot)) {
    New-Item -ItemType Directory -Path $sessionsRoot -Force | Out-Null
}

switch ($Action) {
    "init" {
        if (-not $Objective) {
            Write-Error "init requires -Objective"
        }
        $r = Initialize-CreativeLoop -Objective $Objective -SessionId $SessionId -Context $Context -HubRoot $HubRoot
        Write-Output "OK session=$($r.SessionId) tasks=$($r.Tasks)"
        Write-Output "dir: $($r.Dir)"
    }
    "list" {
        Get-ChildItem $sessionsRoot -Directory | Sort-Object LastWriteTime -Descending | ForEach-Object {
            try {
                $s = Get-CreativeLoopStatus -SessionId $_.Name -HubRoot $HubRoot
                Write-Output "$($s.SessionId) [$($s.Status)] done=$($s.Done)/$($s.Total) - $($s.Objective.Substring(0, [Math]::Min(60, $s.Objective.Length)))"
            }
            catch {
                Write-Output "$($_.Name) [invalid]"
            }
        }
    }
    "status" {
        if (-not $SessionId) {
            Write-Output "Usage: creative-loop.ps1 -Action status -SessionId <id>"
            Write-Output "Or: creative-loop.ps1 -Action list"
            exit 0
        }
        $s = Get-CreativeLoopStatus -SessionId $SessionId -HubRoot $HubRoot
        $s | Format-List
    }
    "next" {
        if (-not $SessionId) { Write-Error "next requires -SessionId" }
        $t = Get-NextCreativeTask -SessionId $SessionId -HubRoot $HubRoot
        if (-not $t) {
            Write-Output "OK no pending tasks (loop complete or empty)"
            exit 0
        }
        Write-Output "OK task=$($t.id) priority=$($t.priority)"
        Write-Output $t.description
    }
    "complete" {
        if (-not $SessionId -or -not $TaskId -or -not $Result) {
            Write-Error "complete requires -SessionId -TaskId -Result"
        }
        $r = Complete-CreativeTask -SessionId $SessionId -TaskId $TaskId -Result $Result -HubRoot $HubRoot
        Write-Output "OK task=$($r.TaskId) session=$($r.Status) pending=$($r.Pending)"
    }
    "expand" {
        if (-not $SessionId -or -not $TasksJson) {
            Write-Error "expand requires -SessionId -TasksJson (JSON array of {description,priority?})"
        }
        $arr = $TasksJson | ConvertFrom-Json
        $added = Add-CreativeTasks -SessionId $SessionId -NewTasks @($arr) -HubRoot $HubRoot
        Write-Output ("OK added: " + ($added -join ", "))
    }
}
