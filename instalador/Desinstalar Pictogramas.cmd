@echo off
chcp 65001 >nul
title Desinstalar Pinguino Pictogramas
echo.
choice /C SN /N /M "  Quitar Pinguino Pictogramas de este computador? (S/N) "
if errorlevel 2 goto fin
del /Q "%USERPROFILE%\Desktop\Pictogramas.lnk" 2>nul
for %%D in ("%USERPROFILE%\Desktop" "%USERPROFILE%\Escritorio" "%OneDrive%\Desktop" "%OneDrive%\Escritorio") do del /Q "%%~D\Abrir Pictogramas.cmd" 2>nul
del /Q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Pictogramas.lnk" 2>nul
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-Item -Force -ErrorAction SilentlyContinue (Join-Path ([Environment]::GetFolderPath('Desktop')) 'Pictogramas.lnk')" >nul 2>&1
rmdir /S /Q "%LOCALAPPDATA%\PinguinoPictogramas" 2>nul
echo   Listo, se quito Pictogramas.
:fin
echo.
pause
