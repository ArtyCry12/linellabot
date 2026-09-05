@echo off
REM Bypasses Windows PowerShell Restricted policy. Does not print the API key.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0openrouter-free-test.ps1" %*
exit /b %ERRORLEVEL%
