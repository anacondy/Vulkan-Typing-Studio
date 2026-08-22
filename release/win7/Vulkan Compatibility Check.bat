@echo off
setlocal
cd /d "%~dp0"
set "CHECK=%~dp0Vulkan-Win7-Diagnostics.html"

set "FIREFOX=%ProgramFiles%\Mozilla Firefox\firefox.exe"
if exist "%FIREFOX%" goto run_firefox
set "FIREFOX=%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe"
if exist "%FIREFOX%" goto run_firefox

set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if exist "%CHROME%" goto run_chrome
set "CHROME=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if exist "%CHROME%" goto run_chrome
set "CHROME=%LocalAppData%\Google\Chrome\Application\chrome.exe"
if exist "%CHROME%" goto run_chrome

echo No compatible browser was found.
echo Install Firefox 115 ESR for Windows 7, then run this check again.
pause
exit /b 1

:run_firefox
start "Vulkan Compatibility Check" "%FIREFOX%" -new-window "file:///%CHECK:\=/%"
exit /b 0

:run_chrome
start "Vulkan Compatibility Check" "%CHROME%" --app="file:///%CHECK:\=/%" --disable-translate
exit /b 0
