@ECHO OFF

CD /d %~dp0
SET szGame=Opposing Force

ECHO.
ECHO.= Half-Life: %szGame% map support for Sven Co-op 5.0 =-
ECHO.
ECHO You are about to uninstall co-op support for the %szGame%
ECHO single-player storyline maps.
ECHO.
ECHO This will free up around 80MB of space.
ECHO.
ECHO You can re-install %szGame% support using the file:
ECHO Install_OpFor_Support.bat
ECHO.
ECHO To abort uninstall, just close this command prompt window.
ECHO To continue, press any key twice.
ECHO.

IF NOT "%1"=="-silent" pause
IF NOT "%1"=="-silent" pause



:UNINSTALL

ECHO.
ECHO Uninstalling...
ECHO.

CD maps

DEL of0a0.bsp
DEL of1a1.bsp
DEL of1a2.bsp
DEL of1a3.bsp
DEL of1a4.bsp
DEL of1a4b.bsp
DEL of1a5.bsp
DEL of1a5b.bsp
DEL of1a6.bsp
DEL of2a1.bsp
DEL of2a1b.bsp
DEL of2a2.bsp
DEL of2a3.bsp
DEL of2a4.bsp
DEL of2a5.bsp
DEL of2a6.bsp
DEL of3a1.bsp
DEL of3a1b.bsp
DEL of3a2.bsp
DEL of3a4.bsp
DEL of3a5.bsp
DEL of3a6.bsp
DEL of4a1.bsp
DEL of4a2.bsp
DEL of4a3.bsp
DEL of4a4.bsp
DEL of4a5.bsp
DEL of5a1.bsp
DEL of5a2.bsp
DEL of5a3.bsp
DEL of5a4.bsp
DEL of6a1.bsp
DEL of6a2.bsp
DEL of6a3.bsp
DEL of6a4.bsp
DEL of6a4b.bsp
DEL of6a5.bsp
DEL of7a0.bsp

DEL of0a0.cfg
DEL of1a1.cfg
DEL of1a2.cfg
DEL of1a3.cfg
DEL of1a4.cfg
DEL of1a4b.cfg
DEL of1a5.cfg
DEL of1a5b.cfg
DEL of1a6.cfg
DEL of2a1.cfg
DEL of2a1b.cfg
DEL of2a2.cfg
DEL of2a3.cfg
DEL of2a4.cfg
DEL of2a5.cfg
DEL of2a6.cfg
DEL of3a1.cfg
DEL of3a2.cfg
DEL of3a4.cfg
DEL of3a5.cfg
DEL of3a6.cfg
DEL of4a1.cfg
DEL of4a2.cfg
DEL of4a3.cfg
DEL of4a4.cfg
DEL of4a4_skl.cfg
DEL of4a5.cfg
DEL of5a1.cfg
DEL of5a2.cfg
DEL of5a3.cfg
DEL of5a4.cfg
DEL of6a1.cfg
DEL of6a2.cfg
DEL of6a3.cfg
DEL of6a4.cfg
DEL of6a4b.cfg
DEL of6a5.cfg
REM DEL of7a0.cfg

CD ..



:FINISHED

ECHO.
ECHO ----------------------------------------------------------------------------
ECHO Finished!
ECHO ----------------------------------------------------------------------------
ECHO.
ECHO Don't worry about any File Not Found errors, by the way. There are likely to
ECHO be several.
ECHO.
ECHO Close this command prompt window to complete un-installation.
ECHO.
IF NOT "%1"=="-silent" pause



:EXIT
