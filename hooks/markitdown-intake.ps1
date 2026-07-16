# MarkItDown intake hook — convert documents to .md before agent reads binaries
# Runs on UserPromptSubmit via hooks.json (after repo-intake)

$ErrorActionPreference = "Stop"
$inputRaw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputRaw)) { exit 0 }

try {
    $data = $inputRaw | ConvertFrom-Json
} catch {
    exit 0
}

$prompt = ""
if ($data.prompt) { $prompt = [string]$data.prompt }
elseif ($data.user_message) { $prompt = [string]$data.user_message }
elseif ($data.message) { $prompt = [string]$data.message }

if ([string]::IsNullOrWhiteSpace($prompt)) { exit 0 }

$fullPrompt = $prompt

$hubRoot = Split-Path $PSScriptRoot -Parent
$lib = Join-Path $hubRoot "lib\markitdown\MarkItDown.ps1"
if (-not (Test-Path $lib)) { exit 0 }

. $lib

if (Test-MarkItDownSkipPrompt -Prompt $fullPrompt) { exit 0 }

$paths = Find-DocumentPathsInPrompt -FullPrompt $fullPrompt
if ($paths.Count -eq 0) { exit 0 }

if (-not (Test-MarkItDownInstalled -HubRoot $hubRoot)) {
    $block = @"
[MARKITDOWN - documents detected, venv missing]

Run once: powershell -File commands/ensure-markitdown.ps1
Then convert PDF/Office to .md before reading binaries.
Skill: skills/markitdown/SKILL.md
"@
    $out = @{
        hookSpecificOutput = @{
            hookEventName     = "UserPromptSubmit"
            additionalContext = $block
        }
    } | ConvertTo-Json -Compress -Depth 4
    Write-Output $out
    exit 0
}

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("[MARKITDOWN] Use .md paths below, not binaries.")
$lines.Add("")

foreach ($src in $paths) {
    try {
        $r = Invoke-MarkItDownConvert -SourcePath $src -HubRoot $hubRoot
        if ($r.Deferred) {
            $lines.Add("- QUEUED: $src (markitdown-drain.ps1)")
        }
        elseif ($r.Output) {
            $tag = if ($r.Cached) { "cached" } else { "ok" }
            $lines.Add("- $tag md: $($r.Output)")
        }
    }
    catch {
        $lines.Add("- FAIL: $src")
    }
}

$out = @{
    hookSpecificOutput = @{
        hookEventName     = "UserPromptSubmit"
        additionalContext = ($lines -join "`n")
    }
} | ConvertTo-Json -Compress -Depth 4

Write-Output $out
exit 0
