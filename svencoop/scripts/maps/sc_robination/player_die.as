bool g_isDeathInfoEnabled = false;

void SetDeathInfoEnabled(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if (useType == USE_ON)
		g_isDeathInfoEnabled = true;
	else if (useType == USE_OFF)
		g_isDeathInfoEnabled = false;
	else if (useType == USE_TOGGLE)
		g_isDeathInfoEnabled = !g_isDeathInfoEnabled;
}

void OnGamePlayerDie(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if ( !g_isDeathInfoEnabled )
		return;
		
	if ( pActivator is null || !pActivator.IsPlayer() )
		return;
		
	CBasePlayer@ p = cast<CBasePlayer>(pActivator);
	g_Scheduler.SetTimeout("SendPlayerDeathNotices", 0.1f, p.entindex());
}

void SendPlayerDeathNotices(int deadPlayerIndex)
{
	HUDTextParams hudParams;
	hudParams.x = -1.0f;
	hudParams.y = 0.55;
	hudParams.r1 = 200;
	hudParams.g1 = 50;
	hudParams.b1 = 0;
	hudParams.r2 = 200;
	hudParams.g2 = 50;
	hudParams.b2 = 0;
	hudParams.effect = 0;
	hudParams.fadeinTime = 0.1f;
	hudParams.fadeoutTime = 0.2f;
	hudParams.holdTime = 2.8f;
	hudParams.fxTime = 0.25f;
	hudParams.channel = 2;
	
	CBasePlayer@ deadPlayer = g_PlayerFuncs.FindPlayerByIndex(deadPlayerIndex);
	if (@deadPlayer != null)
	{
		g_PlayerFuncs.HudMessage(@deadPlayer, hudParams, "You died.\nYou may wait for revival.");
	}
	
	CBaseEntity@ ent = null;
	while ( ( @ent = g_EntityFuncs.FindEntityByClassname(@ent, "player") ) !is null )
	{
		CBasePlayer@ anotherPlayer = cast<CBasePlayer>(ent);
		if (@anotherPlayer != null)
		{
			if (@anotherPlayer != @deadPlayer)
			{
				g_PlayerFuncs.HudMessage(@anotherPlayer, hudParams, "Someone died!");
			}
		}
	}
}
