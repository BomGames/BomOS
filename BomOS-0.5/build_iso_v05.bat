@echo off
setlocal
cd /d "%~dp0"
call build_v05.bat
if errorlevel 1 exit /b %errorlevel%
py make_iso_v05.py "..\bomOS-V0.3.iso" "..\bomOS-V0.5.iso" "bomos.bin" "apps" "..\DOOM1.WAD"
if errorlevel 1 exit /b %errorlevel%
echo BomOS 0.5 ISO is ready: "..\bomOS-V0.5.iso"
