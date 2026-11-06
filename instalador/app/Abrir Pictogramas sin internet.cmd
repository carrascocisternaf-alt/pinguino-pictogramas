@echo off
setlocal
rem Abre la copia local de respaldo (no se actualiza sola)
set "HTML=%LOCALAPPDATA%\PinguinoPictogramas\Pinguino_Pictogramas.html"
if not exist "%HTML%" set "HTML=%~dp0Pinguino_Pictogramas.html"
set "FURL=file:///%HTML:\=/%"
set "EDGE=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
if not exist "%EDGE%" set "EDGE=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
if exist "%EDGE%" (
  start "" "%EDGE%" --app="%FURL%"
) else (
  start "" "%HTML%"
)
