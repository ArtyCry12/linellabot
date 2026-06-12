@echo off
setlocal
cd /d "%~dp0.."
echo === Cursor system refresh ===
python commands\huashu-sync-workspace-rules.py
if errorlevel 1 exit /b 1
node commands\generate-skill-index.mjs
if errorlevel 1 exit /b 1
powershell -NoProfile -ExecutionPolicy Bypass -File commands\cursor-system-audit.ps1
echo.
echo Done. For cleanup: powershell commands\cursor-system-cleanup.ps1 -Apply
endlocal
