$ErrorActionPreference = "Stop"
$HubRoot = Split-Path $PSScriptRoot -Parent
$fail = 0

$required = @(
    "lib/babyagi/CreativeLoop.ps1",
    "skills/babyagi/SKILL.md",
    "rules/babyagi.mdc",
    "commands/creative-loop.ps1"
)

foreach ($p in $required) {
    if (-not (Test-Path (Join-Path $HubRoot $p))) {
        Write-Host "FAIL missing $p"
        $fail++
    }
}

. (Join-Path $HubRoot "lib/babyagi/CreativeLoop.ps1")

$init = Initialize-CreativeLoop -Objective "test creative loop" -HubRoot $HubRoot
$sid = $init.SessionId

$t = Get-NextCreativeTask -SessionId $sid -HubRoot $HubRoot
if (-not $t) {
    Write-Host "FAIL no next task"
    $fail++
}

Complete-CreativeTask -SessionId $sid -TaskId $t.id -Result "test result" -HubRoot $HubRoot | Out-Null

$added = Add-CreativeTasks -SessionId $sid -NewTasks @(
    @{ description = "follow-up idea A"; priority = 10 }
) -HubRoot $HubRoot

if ($added.Count -ne 1) {
    Write-Host "FAIL expand"
    $fail++
}

$s = Get-CreativeLoopStatus -SessionId $sid -HubRoot $HubRoot
if ($s.Done -lt 1) {
    Write-Host "FAIL status done count"
    $fail++
}

if ($fail -gt 0) {
    Write-Host "FAILED $fail"
    exit 1
}

Write-Host "OK babyagi test passed session=$sid"
