/* COUNTER-STRIKE 1.6 .50 AE AMMO - USED BY DESERT EAGLE*/
class CS16_Ammo_50AE : ScriptBasePlayerAmmoEntity
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/cs16/ammo/50ae/w_50ae.mdl" );
		BaseClass.Spawn();
	}
	
	void Precache()
	{
		g_Game.PrecacheModel( "models/cs16/ammo/50ae/w_50ae.mdl" );
		g_Game.PrecacheModel( "models/cs16/ammo/50ae/w_50aet.mdl" );
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
	}

	bool AddAmmo( CBaseEntity@ pither )
	{
		int iGive;
		
		iGive = DEAGLE_DEFAULT_GIVE;
		
		if( pither.GiveAmmo( iGive, "ammo_cs_50ae", DEAGLE_MAX_CARRY ) != -1 )
		{
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
			return true;
		}
		return false;
	}
}

string GetCS16_Ammo_50AE()
{
	return "ammo_cs_50ae";
}

void RegisterCS_AMMO_50AE()
{
	g_Game.PrecacheModel( "models/cs16/ammo/50ae/w_50ae.mdl" );
	g_Game.PrecacheModel( "models/cs16/ammo/50ae/w_50aet.mdl" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CS16_Ammo_50AE", GetCS16_Ammo_50AE() );
}

/* COUNTER-STRIKE 1.6 .338 LAPUA MAGNUM AMMO - USED BY AWP*/
class CS16_Ammo_338lapua : ScriptBasePlayerAmmoEntity
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/cs16/ammo/338lapua/w_338magnum.mdl" );
		BaseClass.Spawn();
	}
	
	void Precache()
	{
		g_Game.PrecacheModel( "models/cs16/ammo/338lapua/w_338magnum.mdl" );
		g_Game.PrecacheModel( "models/cs16/ammo/338lapua/w_338magnumt.mdl" );
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
	}

	bool AddAmmo( CBaseEntity@ pither )
	{
		int iGive;
		
		iGive = AWP_DEFAULT_GIVE;
		
		if( pither.GiveAmmo( iGive, "ammo_cs_338lapua", AWP_MAX_CARRY ) != -1 )
		{
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
			return true;
		}
		return false;
	}
}

string GetCS16_Ammo_338lapua()
{
	return "ammo_cs_338lapua";
}

void RegisterCS_AMMO_338LAPUA()
{
	g_Game.PrecacheModel( "models/cs16/ammo/338lapua/w_338magnum.mdl" );
	g_Game.PrecacheModel( "models/cs16/ammo/338lapua/w_338magnumt.mdl" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CS16_Ammo_338lapua", GetCS16_Ammo_338lapua() );
}

/* COUNTER-STRIKE 1.6 9MM AMMO - USED BY GLOCK, MP5, TMP, DUAL ELITES*/
class CS16_Ammo_9mm : ScriptBasePlayerAmmoEntity
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/cs16/ammo/9mmparab/w_9mmclip_big.mdl" );

		BaseClass.Spawn();
	}

	void Precache()
	{
		g_Game.PrecacheModel( "models/cs16/ammo/9mmparab/w_9mmclip_big.mdl" );
		g_Game.PrecacheModel( "models/cs16/ammo/9mmparab/w_9mmclip_bigt.mdl" );
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
	}

	bool AddAmmo( CBaseEntity@ pOther )
	{
		int iGive;
		
		iGive = MP5Navy_DEFAULT_GIVE;
		
		if( pOther.GiveAmmo( iGive, "ammo_cs_9mm", CS_9mm_MAX_CARRY ) != -1 )
		{
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
			return true;
		}
		return false;
	}
}

string GetCS16_Ammo_9mm()
{
	return "ammo_cs_9mm";
}

void RegisterCS_AMMO_9MM()
{
	g_Game.PrecacheModel( "models/cs16/ammo/9mmparab/w_9mmclip_big.mdl" );
	g_Game.PrecacheModel( "models/cs16/ammo/9mmparab/w_9mmclip_bigt.mdl" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CS16_Ammo_9mm", GetCS16_Ammo_9mm() );
}

/* COUNTER-STRIKE 1.6 .357 SIG AMMO - USED BY P228*/
class CS16_Ammo_357sig : ScriptBasePlayerAmmoEntity
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/cs16/ammo/357sig/w_357sig.mdl" );
		BaseClass.Spawn();
	}
	
	void Precache()
	{
		g_Game.PrecacheModel( "models/cs16/ammo/357sig/w_357sig.mdl" );
		g_Game.PrecacheModel( "models/cs16/ammo/357sig/w_357sigt.mdl" );
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
	}

	bool AddAmmo( CBaseEntity@ pither )
	{
		int iGive;
		
		iGive = P228_DEFAULT_GIVE;
		
		if( pither.GiveAmmo( iGive, "ammo_cs_357sig", P228_MAX_CARRY ) != -1 )
		{
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
			return true;
		}
		return false;
	}
}

string GetCS16_Ammo_357sig()
{
	return "ammo_cs_357sig";
}

void RegisterCS_AMMO_357SIG()
{
	g_Game.PrecacheModel( "models/cs16/ammo/357sig/w_357sig.mdl" );
	g_Game.PrecacheModel( "models/cs16/ammo/357sig/w_357sigt.mdl" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CS16_Ammo_357sig", GetCS16_Ammo_357sig() );
}

/* COUNTER-STRIKE 1.6 45 ACP AMMO - USED BY USP, UMP-45 AND MAC-10*/
class CS16_Ammo_45acp : ScriptBasePlayerAmmoEntity
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/cs16/ammo/45acp/w_45acp.mdl" );
		BaseClass.Spawn();
	}
	
	void Precache()
	{
		g_Game.PrecacheModel( "models/cs16/ammo/45acp/w_45acp.mdl" );
		g_Game.PrecacheModel( "models/cs16/ammo/45acp/w_45acpt.mdl" );
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
	}

	bool AddAmmo( CBaseEntity@ pither )
	{
		int iGive;
		
		iGive = USP_DEFAULT_GIVE;
		
		if( pither.GiveAmmo( iGive, "ammo_cs_45acp", CS_45acp_MAX_CARRY ) != -1 )
		{
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
			return true;
		}
		return false;
	}
}

string GetCS16_Ammo_45acp()
{
	return "ammo_cs_45acp";
}

void RegisterCS_AMMO_45ACP()
{
	g_Game.PrecacheModel( "models/cs16/ammo/45acp/w_45acp.mdl" );
	g_Game.PrecacheModel( "models/cs16/ammo/45acp/w_45acpt.mdl" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CS16_Ammo_45acp", GetCS16_Ammo_45acp() );
}

/* COUNTER-STRIKE 1.6 FN 5-7 AMMO - USED BY FIVE-SEVEN AND P90*/
class CS16_Ammo_fn57 : ScriptBasePlayerAmmoEntity
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/cs16/ammo/fn57/w_57mm.mdl" );
		BaseClass.Spawn();
	}
	
	void Precache()
	{
		g_Game.PrecacheModel( "models/cs16/ammo/fn57/w_57mm.mdl" );
		g_Game.PrecacheModel( "models/cs16/ammo/fn57/w_57mmt.mdl" );
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
	}

	bool AddAmmo( CBaseEntity@ pOther )
	{
		int iGive;
		
		iGive = P90_DEFAULT_GIVE;
		
		if( pOther.GiveAmmo( iGive, "ammo_cs_fn57", CS_57_MAX_CARRY ) != -1 )
		{
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
			return true;
		}
		return false;
	}
}

string GetCS16_Ammo_fn57()
{
	return "ammo_cs_fn57";
}

void RegisterCS_AMMO_FN57()
{
	g_Game.PrecacheModel( "models/cs16/ammo/fn57/w_57mm.mdl" );
	g_Game.PrecacheModel( "models/cs16/ammo/fn57/w_57mmt.mdl" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CS16_Ammo_fn57", GetCS16_Ammo_fn57() );
}

/* COUNTER-STRIKE 1.6 5.56 AMMO - USED BY M4A1, GALIL, FAMAS, AUG, SG-552 AND SG-550*/
class CS16_Ammo_556mag : ScriptBasePlayerAmmoEntity
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/cs16/ammo/556/w_556nato.mdl" );
		BaseClass.Spawn();
	}
	
	void Precache()
	{
		g_Game.PrecacheModel( "models/cs16/ammo/556/w_556nato.mdl" );
		g_Game.PrecacheModel( "models/cs16/ammo/556/w_556natot.mdl" );
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
	}

	bool AddAmmo( CBaseEntity@ pither )
	{
		int iGive;
		
		iGive = M4A1_DEFAULT_GIVE;
		
		if( pither.GiveAmmo( iGive, "ammo_cs_556", CS_556_MAX_CARRY ) != -1 )
		{
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
			return true;
		}
		return false;
	}
}

string GetCS16_Ammo_556mag()
{
	return "ammo_cs_556";
}

void RegisterCS_AMMO_556MAG()
{
	g_Game.PrecacheModel( "models/cs16/ammo/556/w_556nato.mdl" );
	g_Game.PrecacheModel( "models/cs16/ammo/556/w_556natot.mdl" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CS16_Ammo_556mag", GetCS16_Ammo_556mag() );
}

/* COUNTER-STRIKE 1.6 5.56 BOX AMMO - USED BY M249*/
class CS16_Ammo_556box : ScriptBasePlayerAmmoEntity
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/cs16/ammo/556/w_556natobox.mdl" );
		BaseClass.Spawn();
	}
	
	void Precache()
	{
		g_Game.PrecacheModel( "models/cs16/ammo/556/w_556natobox.mdl" );
		g_Game.PrecacheModel( "models/cs16/ammo/556/w_556natoboxt.mdl" );
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
	}

	bool AddAmmo( CBaseEntity@ pither )
	{
		int iGive;
		
		iGive = M249_DEFAULT_GIVE;
		
		if( pither.GiveAmmo( iGive, "ammo_cs_556box", M249_MAX_CARRY ) != -1 )
		{
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
			return true;
		}
		return false;
	}
}

string GetCS16_Ammo_556box()
{
	return "ammo_cs_556box";
}

void RegisterCS_AMMO_556BOX()
{
	g_Game.PrecacheModel( "models/cs16/ammo/556/w_556natobox.mdl" );
	g_Game.PrecacheModel( "models/cs16/ammo/556/w_556natoboxt.mdl" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CS16_Ammo_556box", GetCS16_Ammo_556box() );
}

void RegisterCSAmmo()
{
	RegisterCS_AMMO_762();
	RegisterCS_AMMO_50AE();
	RegisterCS_AMMO_338LAPUA();
	RegisterCS_AMMO_9MM();
	RegisterCS_AMMO_357SIG();
	RegisterCS_AMMO_45ACP();
	RegisterCS_AMMO_FN57();
	RegisterCS_AMMO_556MAG();
	RegisterCS_AMMO_556BOX();
	RegisterCS_AMMO_12GAUGE();
}