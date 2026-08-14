@echo off
rem Windows double-click installer
cd /d "%~dp0"
echo Installing dsh-theme-wallpaper...
node install.cjs %*
echo.
pause
