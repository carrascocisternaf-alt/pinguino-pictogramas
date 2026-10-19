@echo off
chcp 65001 >nul
setlocal
title Instalar Pinguino Pictogramas
echo.
echo   Pinguino Pictogramas - instalacion
echo   ----------------------------------
echo.

set "SRC=%~dp0app"
set "DEST=%LOCALAPPDATA%\PinguinoPictogramas"

if not exist "%SRC%\Pinguino_Pictogramas.html" (
  echo   No encuentro la carpeta "app" junto a este archivo.
  echo   Copia la carpeta completa del pendrive y vuelve a intentar.
  goto fin
)

if not exist "%DEST%" mkdir "%DEST%"
copy /Y "%SRC%\Pinguino_Pictogramas.html" "%DEST%\" >nul
if errorlevel 1 (
  echo   No se pudo copiar la herramienta a "%DEST%".
  goto fin
)
copy /Y "%SRC%\pictogramas.ico" "%DEST%\" >nul
copy /Y "%SRC%\Abrir Pictogramas.cmd" "%DEST%\" >nul

rem Edge viene con Windows 10 y 11: abre la herramienta en su propia ventana
set "EDGE=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
if not exist "%EDGE%" set "EDGE=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
if not exist "%EDGE%" set "EDGE="

rem Accesos directos con icono en el Escritorio y en el menu Inicio
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$s=New-Object -ComObject WScript.Shell; $q=[char]34;" ^
  "$html=Join-Path $env:DEST 'Pinguino_Pictogramas.html';" ^
  "foreach($d in @([Environment]::GetFolderPath('Desktop'),[Environment]::GetFolderPath('Programs'))){" ^
  "  $l=$s.CreateShortcut((Join-Path $d 'Pictogramas.lnk'));" ^
  "  if($env:EDGE){$l.TargetPath=$env:EDGE; $l.Arguments='--app='+$q+'file:///'+($html -replace '\\','/')+$q}" ^
  "  else{$l.TargetPath=$html};" ^
  "  $l.IconLocation=(Join-Path $env:DEST 'pictogramas.ico'); $l.WorkingDirectory=$env:DEST;" ^
  "  $l.Description='Pinguino Pictogramas'; $l.Save() }" >nul 2>&1

if errorlevel 1 (
  rem Si PowerShell esta bloqueado, deja un archivo para abrirla desde el Escritorio
  for %%D in ("%USERPROFILE%\Desktop" "%USERPROFILE%\Escritorio" "%OneDrive%\Desktop" "%OneDrive%\Escritorio") do if exist "%%~D" copy /Y "%SRC%\Abrir Pictogramas.cmd" "%%~D\" >nul 2>&1
  echo   Instalada. En el Escritorio quedo "Abrir Pictogramas".
) else (
  echo   Instalada. En el Escritorio y en el menu Inicio quedo el icono "Pictogramas".
)
echo.
echo   Para actualizar a una version nueva, vuelve a ejecutar este instalador.
echo   Tus pautas guardadas y ajustes se mantienen.
echo.
choice /C SN /N /M "  Abrir Pictogramas ahora? (S/N) "
if errorlevel 2 goto fin
call "%DEST%\Abrir Pictogramas.cmd"

:fin
echo.
pause
