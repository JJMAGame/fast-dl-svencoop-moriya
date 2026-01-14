/*
* This script implements all other scripts in Momma Mesa
*/

#include "func_tankgrenade"
#include "func_tank_egon"
#include "env_toxiccloud"

void MapInit()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "func_tankgrenade", "func_tankgrenade" );
	g_CustomEntityFuncs.RegisterCustomEntity( "func_tank_egon", "func_tank_egon" );
	g_CustomEntityFuncs.RegisterCustomEntity( "env_toxiccloud", "env_toxiccloud" );
}

void Precache()
{
	// func_tankgrenade
	g_Game.PrecacheModel( "models/grenade.mdl" );
	g_SoundSystem.PrecacheSound( "weapons/glauncher.wav" );
	g_SoundSystem.PrecacheSound( "weapons/glauncher2.wav" );
	
	// func_tank_egon
	g_Game.PrecacheModel( "sprites/xbeam1.spr" );
	g_Game.PrecacheModel( "sprites/xspark1.spr" );
	g_SoundSystem.PrecacheSound( "weapons/egon_off1.wav" );
	g_SoundSystem.PrecacheSound( "weapons/egon_run3.wav" );
	g_SoundSystem.PrecacheSound( "weapons/egon_windup2.wav" );
}