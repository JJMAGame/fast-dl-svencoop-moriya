#include "../AmmoMod"
#include "bm_sts_teamsprite"
#include "bm_sts_observer"
#include "bm_sts_trigger_nostuck_teleport"

void MapInit()
{
	PrecacheTeamSprite();
	RegisterObserver();
	RegisterTeleport();
	InitAmmoCount();
}

void InitAmmoCount()
{
	AmmoMod::AmmoMod@ pAmmoMod = AmmoMod::AmmoMod();
	
	@AmmoMod::g_ActiveAmmoMod = @pAmmoMod;
	
	pAmmoMod.AmmoCounts[ "9mm" ] = 99999;
	pAmmoMod.AmmoCounts[ "buckshot" ] = 99999;
	pAmmoMod.AmmoCounts[ "357" ] = 99999;
	pAmmoMod.AmmoCounts[ "bolts" ] = 99999;
	pAmmoMod.AmmoCounts[ "556" ] = 99999;
	pAmmoMod.AmmoCounts[ "rockets" ] = 99999;
	pAmmoMod.AmmoCounts[ "uranium" ] = 99999;
	pAmmoMod.AmmoCounts[ "Hand Grenade" ] = 99999;
	pAmmoMod.AmmoCounts[ "Snarks" ] = 99999;
	pAmmoMod.AmmoCounts[ "m40a1" ] = 99999;
	pAmmoMod.AmmoCounts[ "sporeclip" ] = 99999;
	
	pAmmoMod.SetAmmoToMax = true;
}


void ApplyActiveAutobalance2( CBaseEntity@ pActivator, CBaseEntity@ pCaller,
	USE_TYPE useType, float flValue )
{
}

void ApplyActiveAutobalance4( CBaseEntity@ pActivator, CBaseEntity@ pCaller,
	USE_TYPE useType, float flValue )
{
}

void ApplyActiveGreen( CBaseEntity@ pActivator, CBaseEntity@ pCaller,
	USE_TYPE useType, float flValue )
{
}

void ApplyActiveBlue( CBaseEntity@ pActivator, CBaseEntity@ pCaller,
	USE_TYPE useType, float flValue )
{
}

void ApplyActiveRed( CBaseEntity@ pActivator, CBaseEntity@ pCaller,
	USE_TYPE useType, float flValue )
{
}

void ApplyActiveYellow( CBaseEntity@ pActivator, CBaseEntity@ pCaller,
	USE_TYPE useType, float flValue )
{
}
