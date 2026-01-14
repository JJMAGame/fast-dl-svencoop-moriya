@ECHO OFF

setlocal enabledelayedexpansion

CD /d %~dp0
IF "%1"=="-silent" (
	SET loud=0
) ELSE (
	SET loud=1
)

SET szGame=Blue Shift
SET szModDir=bshift
SET "scVersion=5.0"

rem If anybody knows how to make this split over multiple lines, let me know
SET "mapList=ba_canal1 ba_canal1b ba_canal2 ba_canal3 ba_elevator ba_maint ba_outro ba_power1 ba_power2 ba_security1 ba_security2 ba_teleport1 ba_teleport2 ba_tram1 ba_tram2 ba_tram3 ba_xen1 ba_xen2 ba_xen3 ba_xen4 ba_xen5 ba_xen6 ba_yard1 ba_yard2 ba_yard3 ba_yard3a ba_yard3b ba_yard4 ba_yard4a ba_yard5 ba_yard5a"

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

unzip.exe -o bshift_support.sven -d maps
CD maps

ECHO.
ECHO Converting BSP format...
ECHO.

FOR %%m in (%mapList%) do (
	..\BShiftBSPConverter.exe %%m.bsp
)

ECHO.
ECHO Importing entity data...
ECHO.

FOR %%m in (%mapList%) do (
	ripent.exe -import -noinfo %%m.bsp
)

ECHO.
ECHO Flushing temporary data...
ECHO.

DEL ba_*.ent

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
