@echo off
setlocal
cd /d "%~dp0"
set "APP=%~dp0Vulkan-Typing-Studio-Standalone.html"

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

echo.
echo Vulkan needs Firefox 115 ESR or Chrome 109 on Windows 7.
echo Internet Explorer is not supported.
echo.
echo Run "Vulkan Compatibility Check.bat" after installing Firefox ESR.
echo.
pause
exit /b 1

:run_firefox
start "Vulkan Typing Studio" "%FIREFOX%" -new-window "file:///%APP:\=/%"
exit /b 0

:run_chrome
start "Vulkan Typing Studio" "%CHROME%" --app="file:///%APP:\=/%" --disable-translate
exit /b 0
