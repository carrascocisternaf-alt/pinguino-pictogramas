@echo off
setlocal
rem Abre la version en linea (se actualiza sola; sin conexion usa la ultima abierta)
set "URL=https://carrascocisternaf-alt.github.io/pinguino-pictogramas/"
set "EDGE=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
if not exist "%EDGE%" set "EDGE=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
if exist "%EDGE%" (
  start "" "%EDGE%" --app="%URL%"
) else (
  start "" "%URL%"
)
