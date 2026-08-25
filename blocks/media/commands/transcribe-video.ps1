param(
    [string]$VideoPath = "C:\Users\Asus\Downloads\OMNI REEl.mp4",
    [string]$OutDir = "C:\Users\Asus\.cursor\ai-tracking\production-studio",
    [string]$Model = "base"
)

$tools = "C:\Users\Asus\.cursor\ai-tracking\tools"
$env:PATH = "$tools;$env:PATH"
if (-not (Test-Path "$tools\ffmpeg.exe")) {
    pip install imageio-ffmpeg -q
    $src = python -c "import imageio_ffmpeg; print(imageio_ffmpeg.get_ffmpeg_exe())"
    Copy-Item -Force $src "$tools\ffmpeg.exe"
}

whisper $VideoPath --model $Model --language ru --output_dir $OutDir --output_format txt
$base = [System.IO.Path]::GetFileNameWithoutExtension($VideoPath)
$srcTxt = Join-Path $OutDir "$base.txt"
$dstTxt = Join-Path $OutDir "OMNI-REEL.txt"
if (Test-Path $srcTxt) { Move-Item -Force $srcTxt $dstTxt; Write-Host "Wrote $dstTxt" }
