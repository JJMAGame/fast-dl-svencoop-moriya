#include "CustomHUD"
#include "point_checkpoint"

void MapInit()
{	
	RegisterPointCheckPointEntity();
	CustomHUD::Init();
	
	// Map support is enabled here by default.
	// So you don't have to add "mp_survival_supported 1" to the map config
	g_SurvivalMode.EnableMapSupport();
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void ActivateSurvival( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	g_SurvivalMode.Activate();
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void StartGame( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::StartGame();
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void UpdateTickets( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::UpdateTickets();
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void UpdateCaches( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::UpdateCaches();
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void UpdateZone1( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::UpdateZone1();
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void UpdateZone2( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::UpdateZone2();
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void UpdateZone3( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::UpdateZone3();
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void UpdateZone4( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::UpdateZone4();
}