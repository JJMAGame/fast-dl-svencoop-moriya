#include "weapons/weapon_hrpython"
#include "weapons/weapon_hrcrowbar"
#include "hud/game_hudsprite"


void MapInit()
{ 	
        HR_PYTHON::RegisterPython();
        HR_CROWBAR::RegisterCrowbar();
        g_CustomEntityFuncs.RegisterCustomEntity( "game_hudsprite", "game_hudsprite" );
}