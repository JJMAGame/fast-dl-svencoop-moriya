/* COUNTER-STRIKE 1.6 12 GAUGE AMMO - USED BY M3 AND XM-1014*/
//Author: KernCore

#include "../base"

namespace CSAMMO_SHOTGUN
{//Namespace Start

const string W_MODEL = "models/w_shotbox.mdl";

class CS16_12BuckShot : ScriptBasePlayerAmmoEntity, CS16BASE::AmmoBase
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, W_MODEL );
		BaseClass.Spawn();
	}

	void Precache()
	{
		g_Game.PrecacheModel( W_MODEL );
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
	}

	bool AddAmmo( CBaseEntity@ pOther )
	{
		return CommonAddAmmo( pOther, 8, 32, "ammo_cs_buckshot" );
	}
}

string GetName()
{
	return "ammo_cs_buckshot";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CSAMMO_SHOTGUN::CS16_12BuckShot", GetName() );
}

}//Namespace End