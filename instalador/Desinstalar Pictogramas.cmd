@echo off
chcp 65001 >nul
title Desinstalar Pinguino Pictogramas
echo.
choice /C SN /N /M "  Quitar Pinguino Pictogramas de este computador? (S/N) "
if errorlevel 2 goto fin
for %%D in ("%USERPROFILE%\Desktop" "%USERPROFILE%\Escritorio" "%OneDrive%\Desktop" "%OneDrive%\Escritorio" "%APPDATA%\Microsoft\Windows\Start Menu\Programs") do (
  del /Q "%%~D\Pictogramas.lnk" 2>nul
  del /Q "%%~D\Pictogramas (sin internet).lnk" 2>nul
  del /Q "%%~D\Abrir Pictogramas.cmd" 2>nul
  del /Q "%%~D\Abrir Pictogramas sin internet.cmd" 2>nul
)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$d=[Environment]::GetFolderPath('Desktop'); 'Pictogramas.lnk','Pictogramas (sin internet).lnk' | ForEach-Object { Remove-Item -Force -ErrorAction SilentlyContinue (Join-Path $d $_) }" >nul 2>&1
rmdir /S /Q "%LOCALAPPDATA%\PinguinoPictogramas" 2>nul
echo   Listo, se quito Pictogramas.
:fin
echo.
pause
