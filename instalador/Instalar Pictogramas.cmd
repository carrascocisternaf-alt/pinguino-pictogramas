@echo off
chcp 65001 >nul
setlocal
title Instalar Pinguino Pictogramas
echo.
echo   Pinguino Pictogramas - instalacion
echo   ----------------------------------
echo.

rem Version en linea: se actualiza sola y funciona sin internet despues de abrirla una vez
set "URL=https://carrascocisternaf-alt.github.io/pinguino-pictogramas/"
set "SRC=%~dp0app"
set "DEST=%LOCALAPPDATA%\PinguinoPictogramas"

if not exist "%SRC%\Pinguino_Pictogramas.html" (
  echo   No encuentro la carpeta "app" junto a este archivo.
  echo   Copia la carpeta completa del pendrive y vuelve a intentar.
  goto fin
)

rem Copia local de respaldo, para un PC sin internet
if not exist "%DEST%" mkdir "%DEST%"
copy /Y "%SRC%\Pinguino_Pictogramas.html" "%DEST%\" >nul
if errorlevel 1 (
  echo   No se pudo copiar la herramienta a "%DEST%".
  goto fin
)
copy /Y "%SRC%\pictogramas.ico" "%DEST%\" >nul
copy /Y "%SRC%\Abrir Pictogramas.cmd" "%DEST%\" >nul
copy /Y "%SRC%\Abrir Pictogramas sin internet.cmd" "%DEST%\" >nul

rem Edge viene con Windows 10 y 11: abre la herramienta en su propia ventana
set "EDGE=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
if not exist "%EDGE%" set "EDGE=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
if not exist "%EDGE%" set "EDGE="

rem Accesos directos con icono en el Escritorio y en el menu Inicio:
rem   "Pictogramas"                -> version en linea (se actualiza sola)
rem   "Pictogramas (sin internet)" -> copia local de respaldo
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$s=New-Object -ComObject WScript.Shell; $q=[char]34; $ico=Join-Path $env:DEST 'pictogramas.ico';" ^
  "$html=Join-Path $env:DEST 'Pinguino_Pictogramas.html'; $local='file:///'+($html -replace '\\','/');" ^
  "foreach($d in @([Environment]::GetFolderPath('Desktop'),[Environment]::GetFolderPath('Programs'))){" ^
  "  foreach($par in @(@('Pictogramas',$env:URL),@('Pictogramas (sin internet)',$local))){" ^
  "    $l=$s.CreateShortcut((Join-Path $d ($par[0]+'.lnk')));" ^
  "    if($env:EDGE){$l.TargetPath=$env:EDGE; $l.Arguments='--app='+$q+$par[1]+$q}" ^
  "    else{$l.TargetPath=$env:ComSpec; $l.Arguments='/c start '+$q+$q+' '+$q+$par[1]+$q; $l.WindowStyle=7};" ^
  "    $l.IconLocation=$ico; $l.WorkingDirectory=$env:DEST; $l.Description='Pinguino Pictogramas'; $l.Save() } }" >nul 2>&1

if errorlevel 1 (
  rem Si PowerShell esta bloqueado, deja archivos para abrirla desde el Escritorio
  for %%D in ("%USERPROFILE%\Desktop" "%USERPROFILE%\Escritorio" "%OneDrive%\Desktop" "%OneDrive%\Escritorio") do if exist "%%~D" (
    copy /Y "%SRC%\Abrir Pictogramas.cmd" "%%~D\" >nul 2>&1
    copy /Y "%SRC%\Abrir Pictogramas sin internet.cmd" "%%~D\" >nul 2>&1
  )
  echo   Instalada. En el Escritorio quedo "Abrir Pictogramas".
) else (
  echo   Instalada. En el Escritorio y en el menu Inicio quedo el icono "Pictogramas".
)
echo.
echo   - "Pictogramas" se actualiza sola cada vez que hay una version nueva.
echo     Necesita internet la primera vez; despues funciona tambien sin conexion.
echo   - "Pictogramas (sin internet)" es una copia de respaldo de esta version.
echo.
choice /C SN /N /M "  Abrir Pictogramas ahora? (recomendado, la deja lista sin conexion) (S/N) "
if errorlevel 2 goto fin
call "%DEST%\Abrir Pictogramas.cmd"

:fin
echo.
pause
