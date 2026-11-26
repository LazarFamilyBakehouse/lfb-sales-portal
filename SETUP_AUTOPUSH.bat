@echo off
echo ============================================
echo   LFB Leads Portal - Setting up Auto-Push
echo   (Run this ONCE. No administrator needed.)
echo ============================================
echo.

set "SCRIPT=%~dp0autopush_watcher.ps1"
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "LAUNCHER=%STARTUP%\LFB_Sales_AutoPush.vbs"

echo Installing the startup launcher...
> "%LAUNCHER%" echo CreateObject("WScript.Shell").Run "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File ""%SCRIPT%""", 0, False

if not exist "%LAUNCHER%" (
    echo.
    echo ERROR: Could not create the launcher in your Startup folder.
    pause
    exit /b 1
)

echo Starting the watcher now...
wscript "%LAUNCHER%"

echo.
echo ============================================
echo   DONE. Auto-push is on.
echo   It starts by itself each time you sign in
echo   to Windows and publishes any change in
echo   this folder within about 15 seconds.
echo.
echo   To turn it off: delete
echo   LFB_Sales_AutoPush.vbs from your Startup
echo   folder, then restart the computer.
echo ============================================
echo.
pause
