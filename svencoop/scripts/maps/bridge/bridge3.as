#include "CustomHUD"

#include "weapon_hlhandgrenade"

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void MapInit()
{
	CustomHUD::Init();
	
	hlw_handgrenade::Register();
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
void EndGame( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::EndGame();
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void UpdateTickets( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::UpdateTickets();
}
