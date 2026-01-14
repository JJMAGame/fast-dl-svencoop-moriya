/*
* This script implements all other scripts in Stadium4
*/

#include "env_te"
#include "game_monstercounter"
#include "trigger_random_position"

void MapInit()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "env_te_teleport", "env_te_teleport" );
	g_CustomEntityFuncs.RegisterCustomEntity( "game_monstercounter", "game_monstercounter" );
	g_CustomEntityFuncs.RegisterCustomEntity( "trigger_random_position", "trigger_random_position" );
}