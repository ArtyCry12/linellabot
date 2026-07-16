# Test awesome-prompts local matcher

$ErrorActionPreference = "Stop"
$HubRoot = Split-Path $PSScriptRoot -Parent
$fail = 0

$paths = @(
    "lib/awesome-prompts/Match-PromptTemplate.ps1",
    "lib/awesome-prompts/prompt-index.json",
    "skills/awesome-prompts/SKILL.md",
    "rules/awesome-prompts.mdc",
    "commands/awesome-prompts-match.ps1",
    "commands/build-awesome-prompts-index.ps1"
)

foreach ($p in $paths) {
    $full = Join-Path $HubRoot $p
    if (-not (Test-Path $full)) {
        Write-Host "FAIL missing $p"
        $fail++
    }
}

. (Join-Path $HubRoot "lib/awesome-prompts/Match-PromptTemplate.ps1")

$corpus = Join-Path $HubRoot "lib/awesome-prompts/prompt-corpus.jsonl"
if (-not (Test-Path $corpus)) {
    Write-Host "WARN corpus missing - run build-awesome-prompts-index.ps1"
}

$r = Find-PromptTemplates -Query "javascript code review senior developer" -Top 2 -HubRoot $HubRoot
if (-not $r.Ok -or $r.Matches.Count -eq 0) {
    Write-Host "FAIL no matches for dev query"
    $fail++
}
else {
    Write-Host "OK match: $($r.Matches[0].Act) score=$($r.Matches[0].Score)"
}

if ($fail -gt 0) {
    Write-Host "FAILED $fail checks"
    exit 1
}

Write-Host "OK awesome-prompts test passed"
