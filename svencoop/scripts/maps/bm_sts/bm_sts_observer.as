// bm_sts 1 version
void RegisterObserver()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerObserver", "trigger_observer" );
	g_Scheduler.SetInterval( "SpectateThink", 0.1, g_Scheduler.REPEAT_INFINITE_TIMES );
}

class CTriggerObserver : ScriptBaseEntity
{
	bool KeyValue( const string& in szKey, const string& in szValue )
	{
		return BaseClass.KeyValue( szKey, szValue );
	}
	
	void Spawn()
	{
		// Classic base trigger initialization
		self.pev.solid = SOLID_TRIGGER;
		self.pev.movetype = MOVETYPE_NONE;
		self.pev.effects = EF_NODRAW;

		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetModel( self, self.pev.model );
	}
	
	void Touch( CBaseEntity@ pOther )
	{
		// Alive players only
		if ( pOther.IsPlayer() && pOther.IsAlive() )
		{
			CBasePlayer@ pPlayer = cast< CBasePlayer@ >( pOther );
			pPlayer.KeyValue( "$i_is_observer", "1" );
			pPlayer.GetObserver().StartObserver( pPlayer.pev.origin, pPlayer.pev.angles, false );
			g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "* Press TERTIARY ATTACK to leave spectator mode.\n" );
			pPlayer.pev.nextthink = g_Engine.time + 0.5; // Avoid instant respawn if mp_respawndelay is 0
		}
	}
}

// Global on purpose. If multiple trigger_observer are used, each individual Think() would decrease server perfomance.
void SpectateThink()
{
	for ( int iPlayerIndex = 1; iPlayerIndex <= g_Engine.maxClients; iPlayerIndex++ )
	{
		CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iPlayerIndex );
		if ( pPlayer !is null && pPlayer.IsConnected() )
		{
			CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
			CustomKeyvalue bIsSpectating_pre( pCustom.GetKeyvalue( "$i_is_observer" ) );
			int bIsSpectating = bIsSpectating_pre.GetInteger();
			
			if ( bIsSpectating >= 1 )
			{
				// Handle player buttons
				if ( ( pPlayer.pev.button & IN_ALT1 ) != 0 )
				{
					// Leave observer mode
					g_PlayerFuncs.RespawnPlayer( pPlayer, true, true );
					pPlayer.KeyValue( "$i_is_observer", "0" );
					continue;
				}
				
				pPlayer.pev.nextthink = g_Engine.time + 0.5;
			}
		}
	}
}
