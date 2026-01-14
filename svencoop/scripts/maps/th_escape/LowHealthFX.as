/*
*	Low Health Screen/Sound FX
*
*	Modified by Tomas "GeckoN" Slavotinek
*/

namespace LowHealth
{

const float HEALTH_LOW = 25.0;

final class LowHealthMod
{
	private CScheduledFunction@ m_pLowHealthThink;
	private bool m_bInitialized;
	
	private HUDTextParams hudMsg;
	
	LowHealthMod()
	{
		@m_pLowHealthThink = null;
		m_bInitialized = false;
	}
	
	~LowHealthMod()
	{
		ShutDown();
	}
	
	void ShutDown()
	{
		if ( m_pLowHealthThink !is null )
		{
			g_Scheduler.RemoveTimer( m_pLowHealthThink );
			@m_pLowHealthThink = null;
		}
		
		if( m_bInitialized )
		{
			g_Hooks.RemoveHook( Hooks::Player::ClientPutInServer, ClientPutInServerHook( this.OnClientPutInServer ) );
			g_Hooks.RemoveHook( Hooks::Player::PlayerSpawn, PlayerSpawnHook( this.OnPlayerSpawn ) );
		}
	}

	void OnInit()
	{
		g_Hooks.RegisterHook( Hooks::Player::ClientPutInServer, ClientPutInServerHook( this.OnClientPutInServer ) );
		g_Hooks.RegisterHook( Hooks::Player::PlayerSpawn, PlayerSpawnHook( this.OnPlayerSpawn ) );
		
		m_bInitialized = true;
	}

	void OnMapInit()
	{
		@m_pLowHealthThink = g_Scheduler.SetInterval( @this, "LowHealthThink", 0.1f );

		g_SoundSystem.PrecacheSound( "player/heartbeat1.wav" );
		//g_SoundSystem.PrecacheSound( "player/breathe2.wav" );
	}

	HookReturnCode OnClientPutInServer( CBasePlayer@ pPlayer )
	{
		CustomPlayerDataInit( pPlayer );
		//g_Game.AlertMessage( at_console, "LowHealthMod: User data set on player " + pPlayer.pev.netname + " (phase 1)\n" );
	   
		return HOOK_CONTINUE;
	}

	HookReturnCode OnPlayerSpawn( CBasePlayer@ pPlayer )
	{
		CustomPlayerDataInit( pPlayer );
		//g_Game.AlertMessage( at_console, "LowHealthMod: User data set on player " + pPlayer.pev.netname + " (phase 2)\n" );
	   
		return HOOK_CONTINUE;
	}
	
	void Disable()
	{
		ShutDown();

		for ( int i = 1; i <= g_Engine.maxClients; i++ )
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( i );
			if ( pPlayer is null )
				continue;
				
			LowHealthFXOff( pPlayer );
		}
	}
	
	void LowHealthThink()
	{
		for ( int i = 1; i <= g_Engine.maxClients; i++ )
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( i );
			if ( pPlayer is null )
				continue;
				
			LowHealthUpdatePlayer( pPlayer );
		}
	}

	void CustomPlayerDataInit( CBasePlayer@ pPlayer )
	{
		int nState = ( pPlayer.pev.health > HEALTH_LOW ) ? 0 : -1;
		
		SetCustomInt( pPlayer, "$i_LowHealthState", nState );
		SetCustomFloat( pPlayer, "$f_LowHealthNextSpurt", 0.0f );
		SetCustomFloat( pPlayer, "$f_LowHealthSpurtPeriod", 0.0f );
	}
	
	void LowHealthUpdatePlayer( CBasePlayer@ pPlayer )
	{
		int nState = GetCustomInt( pPlayer, "$i_LowHealthState" );
		if ( nState < 0 )
			return;
	
		bool bState = nState > 0 ? true : false;
		
		// Is player low on health but still alive?
		if ( pPlayer.IsAlive() && pPlayer.pev.health + ( pPlayer.m_iDrownDmg - pPlayer.m_iDrownRestored ) <= HEALTH_LOW )
		{
			if ( !bState )
			{
				LowHealthFXOn( pPlayer );
				
			}
			else
			{
				LowHealthSpurt( pPlayer );
			}
		}
		// Player is dead or is not low on health
		else
		{
			if ( bState )
			{
				LowHealthFXOff( pPlayer );
				
				if ( !pPlayer.IsAlive() )
				{
					LowHealthFinalSpurt( pPlayer );
				}
			}
		}
	}

	void LowHealthFXOn( CBasePlayer@ pPlayer )
	{
		//g_Game.AlertMessage( at_console, "LowHealthMod: Enabling blood FX for player " + pPlayer.pev.netname + "\n" );
		
		// Effects
		g_PlayerFuncs.ScreenFade( pPlayer, Vector( 255, 0, 0 ), 0.5f, 0.5f, 160, ( FFADE_OUT | FFADE_MODULATE | FFADE_STAYOUT ) ); // Fades player screen to red
		g_SoundSystem.PlaySound( pPlayer.edict(), CHAN_STATIC, "player/heartbeat1.wav", 1.0f, 1.0f, 0, PITCH_NORM ); // Starts the heartbeat sound

		// Set player state
		SetCustomInt( pPlayer, "$i_LowHealthState", 1 );
		// Update bleeding period and timer
		float fSpurtPeriod = Math.RandomFloat( 1.5, 4.0 );
		SetCustomFloat( pPlayer, "$f_LowHealthSpurtPeriod", fSpurtPeriod );
		float fNextSpurt = g_Engine.time + fSpurtPeriod;
		SetCustomFloat( pPlayer, "$f_LowHealthNextSpurt", fNextSpurt );
	}

	void LowHealthFXOff( CBasePlayer@ pPlayer )
	{
		//g_Game.AlertMessage( at_console, "LowHealthMod: Disabling blood FX for player " + pPlayer.pev.netname + "\n" );

		// Effects
		g_PlayerFuncs.ScreenFade( pPlayer, Vector( 255, 0, 0 ), 0.5f, 0.0f, 160, ( FFADE_IN | FFADE_MODULATE ) ); // Fades player screen from red to clear
		g_SoundSystem.StopSound( pPlayer.edict(), CHAN_STATIC, "player/heartbeat1.wav" ); // Stops the heartbeat sound

		// Reset player state
		SetCustomInt( pPlayer, "$i_LowHealthState", 0 );
		// Reset bleeding period and timer
		SetCustomFloat( pPlayer, "$f_LowHealthSpurtPeriod", 0.0f );
		SetCustomFloat( pPlayer, "$f_LowHealthNextSpurt", 0.0f );
	}

	void LowHealthSpurt( CBasePlayer@ pPlayer )
	{
		// Checks if player is alive. Dead players should not bleed.
		if ( ( pPlayer.pev.effects & EF_NODRAW ) != 0 )
			return;
			
		// Checks if it is time for the player to spurt blood yet
		float fNextSpurt = GetCustomFloat( pPlayer, "$f_LowHealthNextSpurt" );
		if ( fNextSpurt > g_Engine.time ) 
			return;
		
		// Set the next spurt time
		// Player spurts out blood every X seconds according to random period value
		float fSpurtPeriod = GetCustomFloat( pPlayer, "$f_LowHealthSpurtPeriod" );
		fNextSpurt = g_Engine.time + fSpurtPeriod;
		SetCustomFloat( pPlayer, "$f_LowHealthNextSpurt", fNextSpurt );
		
		DoBloodSpurt( pPlayer, true );
	}

	void LowHealthFinalSpurt( CBasePlayer@ pPlayer )
	{
		//g_Game.AlertMessage( at_console, "LowHealthMod: Final Spurt\n" );
		
		// Make blood puddle where player died
		for ( int i = 0; i < 5; i++ )
		{
			DoBloodSpurt( pPlayer, false );
		}
	}

	Vector CustomRandomBloodVector()
	{
		return Vector( Math.RandomFloat(-0.75,+0.75), Math.RandomFloat(-0.75,+0.75), Math.RandomFloat(-1.0,-0.5) );
	}

	void DoBloodSpurt( CBasePlayer@ pPlayer, bool bStream )
	{
		Vector vecBlood = CustomRandomBloodVector();
		
		if ( bStream )
		{
			g_Utility.BloodStream( pPlayer.pev.origin, vecBlood, 72, 75); // Sprays blood from the player's location in random directions
		}
		
		Vector orig = pPlayer.pev.origin;
		Vector dir = orig + vecBlood * 75.0f;
		TraceResult tr;
		g_Utility.TraceLine( orig, dir, ignore_monsters, null, tr ); // Applies blood decals around player
		if ( tr.flFraction != 1.0 )
		{
			g_Utility.BloodDecalTrace( TraceResult(tr), BLOOD_COLOR_RED );
		}
	}
}

// Helper functions

int GetCustomInt(CBaseEntity@ ent, const string&in key)
{
    CustomKeyvalues@ cks = ent.GetCustomKeyvalues();
    CustomKeyvalue ck = cks.GetKeyvalue(key);
    return ck.Exists() ? ck.GetInteger() : 0;
}

void SetCustomInt(CBaseEntity@ ent, const string&in key, const int value)
{
    CustomKeyvalues@ cks = ent.GetCustomKeyvalues();
    cks.SetKeyvalue(key, value);
}

float GetCustomFloat(CBaseEntity@ ent, const string&in key)
{
    CustomKeyvalues@ cks = ent.GetCustomKeyvalues();
    CustomKeyvalue ck = cks.GetKeyvalue(key);
    return ck.Exists() ? ck.GetFloat() : 0.0f;
}

void SetCustomFloat(CBaseEntity@ ent, const string&in key, const float value)
{
    CustomKeyvalues@ cks = ent.GetCustomKeyvalues();
    cks.SetKeyvalue(key, value);
}

} // namespace ends here
