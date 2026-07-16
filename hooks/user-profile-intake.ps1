# Inject user profile context on every prompt (after autopilot, before router)
$ErrorActionPreference = "Stop"
$inputRaw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputRaw)) { exit 0 }

try { $data = $inputRaw | ConvertFrom-Json } catch { exit 0 }

$hubRoot = Split-Path $PSScriptRoot -Parent
$lib = Join-Path $hubRoot "lib\user-profile\UserProfile.ps1"
if (-not (Test-Path $lib)) { exit 0 }

. $lib
$block = Format-UserProfileContext -HubRoot $hubRoot
if ([string]::IsNullOrWhiteSpace($block)) { exit 0 }

$out = @{
    hookSpecificOutput = @{
        hookEventName     = "UserPromptSubmit"
        additionalContext = $block
    }
} | ConvertTo-Json -Compress -Depth 4

Write-Output $out
exit 0
