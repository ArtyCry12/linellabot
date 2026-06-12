@echo off
setlocal
cd /d "%~dp0.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0cursor-system-refresh.ps1" -Quick
endlocal
