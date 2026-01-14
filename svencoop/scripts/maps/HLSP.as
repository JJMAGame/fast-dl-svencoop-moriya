/*
* This script implements HLSP survival mode
*/

#include "point_checkpoint"
#include "hlsp/trigger_suitcheck"
#include "HLSPClassicMode"

void MapInit()
{
	RegisterPointCheckPointEntity();
	RegisterTriggerSuitcheckEntity();
	
	g_EngineFuncs.CVarSetFloat( "mp_hevsuit_voice", 1 );
	
	ClassicModeMapInit();
}
