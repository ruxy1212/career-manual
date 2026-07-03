@echo off
setlocal

set ZIP=manual.zip

:: Delete old archive if it exists
if exist "%ZIP%" del "%ZIP%"

:: Create new archive
pwsh -NoProfile -Command ^
"Compress-Archive -Path 'resource','MANUAL.md' -DestinationPath '%ZIP%'"

echo.
echo Archive created: %ZIP%
pause