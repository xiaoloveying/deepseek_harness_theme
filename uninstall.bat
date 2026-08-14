@echo off
rem Windows double-click uninstaller
cd /d "%~dp0"
echo Uninstalling dsh-theme-wallpaper...
node uninstall.cjs %*
echo.
pause
