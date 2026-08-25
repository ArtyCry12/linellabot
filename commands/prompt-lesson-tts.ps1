param(
    [Parameter(Mandatory = $true)]
    [string]$LessonPath,
    [string]$HubRoot = (Split-Path $PSScriptRoot -Parent),
    [string]$Voice = "ru-RU-DmitryNeural",
    [switch]$Json
)

$ErrorActionPreference = "Stop"

$full = if ([System.IO.Path]::IsPathRooted($LessonPath)) { $LessonPath } else { Join-Path $HubRoot $LessonPath }
if (-not (Test-Path $full)) { throw "Lesson not found: $full" }

$md = Get-Content $full -Raw -Encoding UTF8
# Strip markdown noise for TTS
$text = $md -replace '(?m)^#+\s*', '' -replace '\[([^\]]+)\]\([^)]+\)', '$1' -replace '[*_`]', ''
$text = ($text -split "`n" | Where-Object { $_.Trim().Length -gt 0 }) -join ". "
if ($text.Length -gt 8000) { $text = $text.Substring(0, 8000) + "…" }

$outDir = Join-Path $HubRoot "ai-tracking\prompt-lessons\audio"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$slug = (Split-Path $full -Leaf) -replace '\.md$',''
$outMp3 = Join-Path $outDir "$slug.mp3"

$edge = Get-Command edge-tts -ErrorAction SilentlyContinue
$pyEdge = Join-Path $HubRoot ".venv-markitdown\Scripts\edge-tts.exe"
if (-not $edge -and (Test-Path $pyEdge)) { $edge = Get-Command $pyEdge }

$ok = $false
$err = $null
if ($edge) {
    try {
        & $edge.Source --voice $Voice --text $text --write-media $outMp3 2>&1 | Out-Null
        if (Test-Path $outMp3) { $ok = $true }
    }
    catch { $err = $_.Exception.Message }
}
else {
    # Install edge-tts into markitdown venv on demand
    $py = Join-Path $HubRoot ".venv-markitdown\Scripts\python.exe"
    if (Test-Path $py) {
        & $py -m pip install edge-tts -q 2>&1 | Out-Null
        if (Test-Path $pyEdge) {
            & $pyEdge --voice $Voice --text $text --write-media $outMp3 2>&1 | Out-Null
            if (Test-Path $outMp3) { $ok = $true }
        }
    }
    if (-not $ok) { $err = "edge-tts not available; run: pip install edge-tts" }
}

$result = [ordered]@{
    lesson   = $full
    audio    = if ($ok) { $outMp3 } else { $null }
    voice    = $Voice
    chars    = $text.Length
    ok       = $ok
    error    = $err
    fallback = "skills/huashu-design/references/voiceover-pipeline.md"
}

if ($Json) {
    $result | ConvertTo-Json -Depth 4
    exit $(if ($ok) { 0 } else { 1 })
}

Write-Host "=== Prompt lesson TTS ===" -ForegroundColor Cyan
if ($ok) {
    Write-Host "OK: $outMp3" -ForegroundColor Green
    exit 0
}
Write-Host "FAIL: $err" -ForegroundColor Red
Write-Host "Fallback: huashu voiceover skill" -ForegroundColor Yellow
exit 1
