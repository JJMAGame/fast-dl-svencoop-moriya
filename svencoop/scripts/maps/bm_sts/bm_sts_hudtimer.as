// Display's round timer on player's HUD screen

const string g_szSpriteTimer = "bm_sts/sts_fulltimer.spr";

void StartTimer( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	HUDSpriteParams hTimer;
	hTimer.channel = 1;
	hTimer.flags = HUD_ELEM_SCR_CENTER_X;
	hTimer.spritename = g_szSpriteTimer;
	hTimer.x = 0;
	hTimer.y = 0;
	hTimer.left = 0;
	hTimer.top = 0;
	hTimer.width = 0;
	hTimer.height = 0;
	hTimer.numframes = 90; // I-ka. : Replaced the num back to 90, since it's spamming 'Sprite: no such frame 91'
	hTimer.framerate = 1.0;
	hTimer.color1 = RGBA_SVENCOOP;
	
	hTimer.frame = 0; 
	hTimer.holdTime = 90.0;
	
	for ( int iPlayerIndex = 1; iPlayerIndex <= g_Engine.maxClients; iPlayerIndex++ )
	{
		CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iPlayerIndex );
		if ( pPlayer !is null && pPlayer.IsConnected() )
		{
			g_PlayerFuncs.HudCustomSprite( pPlayer, hTimer );
			g_PlayerFuncs.HudToggleElement( pPlayer, 1, true );
		}
	}
}

void StopTimer( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	for ( int iPlayerIndex = 1; iPlayerIndex <= g_Engine.maxClients; iPlayerIndex++ )
	{
		CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iPlayerIndex );
		if ( pPlayer !is null && pPlayer.IsConnected() )
		{
			g_PlayerFuncs.HudToggleElement( pPlayer, 1, false );
		}
	}
}
