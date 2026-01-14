@ECHO OFF

CD /d %~dp0
SET szGame=Blue Shift

ECHO.
ECHO.= Half-Life: %szGame% map support for Sven Co-op 5.0 =-
ECHO.
ECHO You are about to uninstall co-op support for the %szGame%
ECHO single-player storyline maps.
ECHO.
ECHO This will free up around 55MB of space.
ECHO.
ECHO You can re-install %szGame% support using the file:
ECHO Install_bshift_Support.bat
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

DEL ba_canal1.bsp
DEL ba_canal1b.bsp
DEL ba_canal2.bsp
DEL ba_canal3.bsp
DEL ba_elevator.bsp
DEL ba_maint.bsp
DEL ba_outro.bsp
DEL ba_power1.bsp
DEL ba_power2.bsp
DEL ba_security1.bsp
DEL ba_security2.bsp
DEL ba_teleport1.bsp
DEL ba_teleport2.bsp
DEL ba_tram1.bsp
DEL ba_tram2.bsp
DEL ba_tram3.bsp
DEL ba_xen1.bsp
DEL ba_xen2.bsp
DEL ba_xen3.bsp
DEL ba_xen4.bsp
DEL ba_xen5.bsp
DEL ba_xen6.bsp
DEL ba_yard1.bsp
DEL ba_yard2.bsp
DEL ba_yard3.bsp
DEL ba_yard3a.bsp
DEL ba_yard3b.bsp
DEL ba_yard4.bsp
DEL ba_yard4a.bsp
DEL ba_yard5.bsp
DEL ba_yard5a.bsp

DEL ba_canal1.cfg
DEL ba_canal1b.cfg
DEL ba_canal2.cfg
DEL ba_canal3.cfg
DEL ba_elevator.cfg
DEL ba_maint.cfg
DEL ba_outro.cfg
DEL ba_power1.cfg
DEL ba_power2.cfg
DEL ba_security1.cfg
DEL ba_security2.cfg
DEL ba_teleport1.cfg
DEL ba_teleport2.cfg
DEL ba_tram1.cfg
DEL ba_tram2.cfg
DEL ba_tram3.cfg
DEL ba_xen1.cfg
DEL ba_xen2.cfg
DEL ba_xen3.cfg
DEL ba_xen4.cfg
DEL ba_xen5.cfg
DEL ba_xen6.cfg
DEL ba_yard1.cfg
DEL ba_yard2.cfg
DEL ba_yard3.cfg
DEL ba_yard3a.cfg
DEL ba_yard3b.cfg
DEL ba_yard4.cfg
DEL ba_yard4a.cfg
DEL ba_yard5.cfg
DEL ba_yard5a.cfg

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
