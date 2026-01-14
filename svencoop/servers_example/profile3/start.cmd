@ECHO OFF

SET DIR_CONFIG=%~dp0
SET DIR_GAME=%DIR_CONFIG%..\..\..\
FOR %%I IN (.) DO SET CONFIG=%%~nxI
FOR /F "tokens=1-2 delims=:" %%a IN ('ipconfig^|find "IPv4"') DO SET IP=%%b



REM # << Profile configuration: START

SET GAME=svencoop
SET IP=%IP:~1%
SET PORT=27035
SET SPORT=26902
SET PLAYERS=12
SET MAP=_server_start

REM # >> Profile configuration: END



ECHO Launching SvenDS with the "%CONFIG%" configuration profile...
ECHO.

CD "%DIR_GAME%"
echo SvenDS.exe -console -game "%GAME%" +ip "%IP%" -port %PORT% +maxplayers %PLAYERS% +servercfgfile "servers/%CONFIG%/server.cfg" +logsdir "servers/%CONFIG%/logs" +log on +map "%MAP%" %1 %2 %3 %4 %5 %6 %7 %8 %9
CD "%DIR_CONFIG%"

ECHO.
ECHO SvenDS has closed.
ECHO.
