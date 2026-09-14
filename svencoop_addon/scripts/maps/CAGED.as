#include "point_checkpoint"
#include "hlsp/trigger_suitcheck"

void MapInit()
{
	RegisterPointCheckPointEntity();
	RegisterTriggerSuitcheckEntity();
  
   	g_SurvivalMode.EnableMapSupport();
}

void ActivateSurvival( CBaseEntity@ pActivator, CBaseEntity@ pCaller,
	USE_TYPE useType, float flValue )
{
	g_SurvivalMode.Activate();
}

void DisableSurvival( CBaseEntity@ pActivator, CBaseEntity@ pCaller, 
	USE_TYPE useType, float flValue )
{
    g_SurvivalMode.Disable();
}