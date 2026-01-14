@ECHO OFF

setlocal enabledelayedexpansion

CD /d %~dp0
IF "%1"=="-silent" (
	SET loud=0
) ELSE (
	SET loud=1
)

SET szGame=Opposing Force
SET szModDir=gearbox
SET "scVersion=5.0"

SET "mapList=of0a0 of1a1 of1a2 of1a3 of1a4 of1a4b of1a5 of1a5b of1a6 of2a1 of2a1b of2a4 of2a5 of2a6 of3a1 of3a4 of3a5 of3a6 of4a1 of4a2 of4a3 of4a4 of4a5 of5a1 of5a2 of5a3 of5a4 of6a1 of6a2 of6a3 of6a4 of6a4b of6a5"

rem If you still have issues with the script not finding your game dir
rem please LET US KNOW and we'll fix it! -R4to0 (27 November 2020)
CALL FindHLDirectory.bat szHLDir

if not exist !szHLDir! (
	ECHO Could not find Half-Life directory
	ECHO Check that Half-Life is installed, and that you have ran it at least once ^(start the game and begin a new game^)
	GOTO BROKEN
)

SET szBaseContentDir=!szHLDir!\%szModDir%

IF NOT EXIST "%szBaseContentDir%" (
	ECHO Could not find %szModDir% directory
	ECHO Check that %szGame% is installed, and that you have ran it at least once ^(start the game and begin a new game^)
	GOTO BROKEN
)

ECHO.
ECHO -= Half-Life: %szGame% map support for Sven Co-op %scVersion% =-
ECHO.
ECHO Warning: Around 80MB of free disk space required.
ECHO Installation may take a few minutes; please be patient.
ECHO.

ECHO.
ECHO ----------------------------------------------------------------------------
ECHO IMPORTANT: To install %szGame% support, you must own 'Half-Life:
ECHO %szGame%' and have it fully downloaded and installed on Steam!
ECHO ----------------------------------------------------------------------------
ECHO.

IF %loud%==1 PAUSE

IF NOT EXIST "maps\Ripent.exe" (
	ECHO Missing Ripent.exe
	GOTO BROKEN
)

CALL :GetFirstParam %mapList%

IF NOT EXIST "%szBaseContentDir%\maps\%firstParam%.bsp" (
	ECHO Missing maps
	GOTO BROKEN
)

ECHO.
ECHO Copying official maps from installed game...
ECHO.

FOR %%m in (%mapList%) do (
	COPY "%szBaseContentDir%\maps\%%m.bsp" maps\
)

COPY "%szBaseContentDir%\gfx\env\*" gfx\env\

ECHO.
ECHO -= Valve's original Half-Life %szGame% maps have been copied. =-
ECHO.

ECHO.
ECHO Preparing...
ECHO.

unzip.exe -o opfor_support.sven -d maps
CD maps

ECHO.
ECHO Importing entity data...
ECHO.

FOR %%m in (%mapList%) do (
	ripent.exe -import -noinfo %%m.bsp
)

ECHO.
ECHO Flushing temporary data...
ECHO.

DEL of?a?.ent
DEL of?a?b.ent

CD ..

GOTO FINISHED



:FINISHED

ECHO.
ECHO ----------------------------------------------------------------------------
ECHO Finished!
ECHO ----------------------------------------------------------------------------
ECHO.
ECHO (Unless a bunch of lines saying "ERROR" or "File not found" flashed up... in
ECHO which case you're in trouble.
ECHO.
ECHO If there /aren't/ lots of error messages listed above, things went fine.
ECHO Congratulations!
ECHO.
ECHO Use the "-sp_campaign_portal.bsp" map to play the %szGame%
ECHO single-player chapters in Sven Co-op.
ECHO.
ECHO Close this command prompt window to complete installation.
ECHO.

IF %loud%==1 PAUSE
GOTO EXIT



:BROKEN

ECHO.
ECHO ----------------------------------------------------------------------------
ECHO ERROR: %szGame% support installation files not found!
ECHO ----------------------------------------------------------------------------
ECHO.
ECHO Ensure that Sven Co-op is correctly installed, and that you are running this
ECHO file from your svencoop\ folder!
ECHO.
ECHO.
ECHO This batch file will now exit.
ECHO.

IF %loud%==1 PAUSE
GOTO EXIT

rem Batch files can't tokenize variables outside of for for some reason
:GetFirstParam
SET firstParam=%1
GOTO EXIT

:EXIT