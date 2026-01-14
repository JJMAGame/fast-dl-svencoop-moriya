@echo off
rem This batch file finds the Half-Life directory and returns it
rem If the directory could not be found, returns an empty value

echo [FindHLDirectory] Looking for Half-Life directory...

setlocal enabledelayedexpansion

set "RETURNVALUE="

set KEY_NAME="HKEY_CURRENT_USER\Software\Valve\Steam"
set VALUE_NAME=ModInstallPath
set STEAM_PATH=SteamPath
set "HLSTEAMLIBDIR=steamapps\common\Half-Life"
set "STEAMLIBFILE=steamapps\libraryfolders.vdf"
set "METHOD="

rem Path relative to the default game or DS install.
set "RELATIVE_PATH=..\..\Half-Life"

FOR /F "tokens=2*" %%A IN ('REG.exe query "%KEY_NAME%" /v "%VALUE_NAME%" 2^>nul ^| find "%VALUE_NAME%"') DO (set pInstallDir=%%B)

rem ModInstallPath search
IF "!pInstallDir!" == "" (
	ECHO [FindHLDirectory] Could not find using %VALUE_NAME% method. Trying to find game directory using relative path.
	IF EXIST %RELATIVE_PATH% (
		set "METHOD=Relative Path"
		set "RETURNVALUE=%RELATIVE_PATH%"
		goto :returncall
	) else (
		echo [FindHLDirectory] Could not find game in the relative path. Trying to find game directory using Steam client libraries.
		goto :steamlib
	)
) ELSE (
	rem Got from ModInstallPath key
	set "METHOD=ModInstallPath"
	set "RETURNVALUE=%pInstallDir%"
	goto :returncall
)

:steamlib
rem Figure out where Steam client is installed
FOR /F "tokens=2*" %%A IN ('REG.exe query "%KEY_NAME%" /v "%STEAM_PATH%" 2^>nul ^| find "%STEAM_PATH%"') DO (set pSteamPath=%%B)

rem Replace forward slashes with backslashes, because Windows likes them -R4to0 (27 November 2020)
set "pSteamPath=!pSteamPath:/=\!"

if "!pSteamPath!" == "" (
 	echo [FindHLDirectory] Steam client path not found. Unable to find any valid game installation.
 	goto :returncall
) else (
	echo [FindHLDirectory] Found Steam Client installation at !pSteamPath!
)

rem Is there a Half-Life install in the main library?
if exist "!pSteamPath!\%HLSTEAMLIBDIR%" (
	set "METHOD=Steam Default Library"
	set "RETURNVALUE=!pSteamPath!\%HLSTEAMLIBDIR%"
	goto :returncall
) else (
	echo [FindHLDirectory] Could not find game in the Steam Default Library path. Trying to find game directory using Steam client path.
)

rem Search through libraryfolders.vdf
set "LIBRARYFILE=!pSteamPath!\%STEAMLIBFILE%"
if exist "!LIBRARYFILE!" (
	for /F "tokens=2" %%L in ('findstr "[a-z]:" "!LIBRARYFILE!"') do (
		set "line=%%L"

		rem Replace double backquotes with single ones
		set "line=!line:\\=\!"

		rem Remove quotes
		set "line=!line:"=!"

		if exist "!line!\%HLSTEAMLIBDIR%" (
			rem Found Half-Life path on this library
			set "METHOD=Steam Library"
			set "RETURNVALUE=!line!\%HLSTEAMLIBDIR%"
			goto :returncall
		)
	)
) else (
	echo [FindHLDirectory] Steam library file not found. Unable to find any valid game installation.
)

rem Return from caller
:returncall
if exist "!RETURNVALUE!" (
	echo [FindHLDirectory] Found Half-Life dir at !RETURNVALUE! using %METHOD% method.
)
echo.
ENDLOCAL&SET %~1=%RETURNVALUE%
