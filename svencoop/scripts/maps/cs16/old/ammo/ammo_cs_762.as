/* COUNTER-STRIKE 1.6 7.62 AMMO - USED BY AK-47, G3-SG1, SCOUT*/
//Author: KernCore

#include "../base"

namespace CSAMMO_762
{//Namespace Start

const string W_MODEL = "models/cs16/ammo/762/w_762nato.mdl";

class CS16_762 : ScriptBasePlayerAmmoEntity, CS16BASE::AmmoBase
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
		g_Game.PrecacheModel( "models/cs16/ammo/762/w_762natot.mdl" );
		g_SoundSystem.PrecacheSound( "hlclassic/items/9mmclip1.wav" );
	}

	bool AddAmmo( CBaseEntity@ pOther )
	{
		return CommonAddAmmo( pOther, 30, 90, "ammo_cs_762" );
	}
}

string GetName()
{
	return "ammo_cs_762";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CSAMMO_762::CS16_762", GetName() );
}

}//Namespace End