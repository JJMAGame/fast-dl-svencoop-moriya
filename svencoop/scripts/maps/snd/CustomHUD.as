/*
* SND
* Custom HUD
*
* Created by Hezus
* Based on original work by Tomas "GeckoN" Slavotinek
*/

namespace CustomHUD
{

const int HUD_CHAN_TICKETS = 0;
const int HUD_CHAN_CACHES = 1;
const int HUD_CHAN_ZONE1 = 2;
const int HUD_CHAN_ZONE2 = 3;
const int HUD_CHAN_ZONE3 = 4;
const int HUD_CHAN_ZONE4 = 5;

const string ENT_TICKET_CNT = "ticket_counter";
const string ENT_CACHE_CNT = "cache_counter";
const string ENT_ZONE1_STAT = "zone1_status";
const string ENT_ZONE2_STAT = "zone2_status";
const string ENT_ZONE3_STAT = "zone3_status";
const string ENT_ZONE4_STAT = "zone4_status";

bool g_fShowTickets;
int g_iTickets;
int g_iTicketsTotal;

bool g_fShowCaches;
int g_iCaches;
int g_iCachesTotal;

bool g_fShowZone1;
int g_iZone1;
int g_iZone1Total;

bool g_fShowZone2;
int g_iZone2;
int g_iZone2Total;

bool g_fShowZone3;
int g_iZone3;
int g_iZone3Total;

bool g_fShowZone4;
int g_iZone4;
int g_iZone4Total;

EHandle g_hTicketCounter;
EHandle g_hCacheCounter;
EHandle g_hZone1Counter;
EHandle g_hZone2Counter;
EHandle g_hZone3Counter;
EHandle g_hZone4Counter;

//=============================================================================
// Shared
//=============================================================================

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void Init()
{
	g_Hooks.RegisterHook( Hooks::Player::ClientPutInServer, @ClientPutInServer );
	
	g_fShowTickets = false;
	g_iTicketsTotal = 0;
	g_iTickets = 0;

	g_fShowCaches = false;
	g_iCachesTotal = 0;
	g_iCaches = 0;
	
	g_fShowZone1 = false;
	g_iZone1Total = 0;
	g_iZone1 = 0;
	
	g_fShowZone2 = false;
	g_iZone2Total = 0;
	g_iZone2 = 0;
	
	g_fShowZone3 = false;
	g_iZone3Total = 0;
	g_iZone3 = 0;
	
	g_fShowZone4 = false;
	g_iZone4Total = 0;
	g_iZone4 = 0;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
HookReturnCode ClientPutInServer( CBasePlayer@ pPlayer )
{
	if ( g_fShowTickets )
		SendTickets( pPlayer );
	if ( g_fShowCaches )
		SendCaches( pPlayer );
	if ( g_fShowZone1 )
		SendZone1( pPlayer );
	if ( g_fShowZone2 )
		SendZone2( pPlayer );
	if ( g_fShowZone3 )
		SendZone3( pPlayer );
	if ( g_fShowZone4 )
		SendZone4( pPlayer );
	return HOOK_CONTINUE;
}


//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void StartGame()
{
//Tickets
	CBaseEntity@ pEntity;

	@pEntity = g_EntityFuncs.FindEntityByTargetname( null, ENT_TICKET_CNT );
	if ( pEntity is null )
		g_Game.AlertMessage( at_error, "Ticket counter entity '%1' not found\n", ENT_TICKET_CNT );
	else
		g_hTicketCounter = EHandle( pEntity );

	g_Scheduler.SetInterval( "PeriodicUpdateTickets", 0.5, g_Scheduler.REPEAT_INFINITE_TIMES );

	UpdateTickets();	
	g_iTicketsTotal = g_iTickets;

	SendTickets( null );

//Caches
	@pEntity = g_EntityFuncs.FindEntityByTargetname( null, ENT_CACHE_CNT );
	if ( pEntity is null )
		g_Game.AlertMessage( at_error, "Cache counter entity '%1' not found\n", ENT_CACHE_CNT );
	else
		g_hCacheCounter = EHandle( pEntity );

	g_Scheduler.SetInterval( "PeriodicUpdateCaches", 0.5, g_Scheduler.REPEAT_INFINITE_TIMES );

	UpdateCaches();	
	g_iCachesTotal = g_iCaches;

	SendCaches( null );

//Zone1
	@pEntity = g_EntityFuncs.FindEntityByTargetname( null, ENT_ZONE1_STAT);
	if ( pEntity is null )
		g_Game.AlertMessage( at_error, "Zone1 status entity '%1' not found\n", ENT_ZONE1_STAT );
	else
		g_hZone1Counter = EHandle( pEntity );

	g_Scheduler.SetInterval( "PeriodicUpdateZone1", 0.5, g_Scheduler.REPEAT_INFINITE_TIMES );

	UpdateZone1();	
	g_iZone1Total = g_iZone1;

	SendZone1( null );

//Zone2
	@pEntity = g_EntityFuncs.FindEntityByTargetname( null, ENT_ZONE2_STAT);
	if ( pEntity is null )
		g_Game.AlertMessage( at_error, "Zone2 status entity '%1' not found\n", ENT_ZONE2_STAT );
	else
		g_hZone2Counter = EHandle( pEntity );

	g_Scheduler.SetInterval( "PeriodicUpdateZone2", 0.5, g_Scheduler.REPEAT_INFINITE_TIMES );

	UpdateZone2();	
	g_iZone2Total = g_iZone2;

	SendZone2( null );

//Zone3
	@pEntity = g_EntityFuncs.FindEntityByTargetname( null, ENT_ZONE3_STAT);
	if ( pEntity is null )
		g_Game.AlertMessage( at_error, "Zone3 status entity '%1' not found\n", ENT_ZONE3_STAT );
	else
		g_hZone3Counter = EHandle( pEntity );

	g_Scheduler.SetInterval( "PeriodicUpdateZone3", 0.5, g_Scheduler.REPEAT_INFINITE_TIMES );

	UpdateZone3();	
	g_iZone3Total = g_iZone3;

	SendZone3( null );

//Zone4
	@pEntity = g_EntityFuncs.FindEntityByTargetname( null, ENT_ZONE4_STAT);
	if ( pEntity is null )
		g_Game.AlertMessage( at_error, "Zone4 status entity '%1' not found\n", ENT_ZONE4_STAT );
	else
		g_hZone4Counter = EHandle( pEntity );

	g_Scheduler.SetInterval( "PeriodicUpdateZone4", 0.5, g_Scheduler.REPEAT_INFINITE_TIMES );

	UpdateZone4();	
	g_iZone4Total = g_iZone4;

	SendZone4( null );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
RGBA StringToRGBA( const string& in strColor )
{
	RGBA rgba = RGBA_WHITE;
	array<string>@ strComp = strColor.Split( " " );
	if ( strComp.length() == 4 )
	{
		rgba.r = atoi( strComp[ 0 ] );
		rgba.g = atoi( strComp[ 1 ] );
		rgba.b = atoi( strComp[ 2 ] );
		rgba.a = atoi( strComp[ 3 ] );
	}
	
	return rgba;
}

//-----------------------------------------------------------------------------
// Purpose: 
//-----------------------------------------------------------------------------
void Message( CBasePlayer@ pPlayer, const string& in text, float x = -1, float y = -1,
	RGBA color = RGBA_WHITE, float fin = 0.5, float fout = 0.5, float hold = 5.0 )
{
	HUDTextParams txtPrms;

	txtPrms.x = x;
	txtPrms.y = y;
	txtPrms.effect = 0;

	txtPrms.r1 = txtPrms.r2 = color.r;
	txtPrms.g1 = txtPrms.g2 = color.g;
	txtPrms.b1 = txtPrms.b2 = color.b;
	txtPrms.a1 = txtPrms.a2 = color.a;
	
	txtPrms.fadeinTime = fin;
	txtPrms.fadeoutTime = fout;
	txtPrms.holdTime = hold;
	txtPrms.fxTime = 0;//0.25f;
	txtPrms.channel = 1;
	
	if ( pPlayer !is null )
		g_PlayerFuncs.HudMessage( pPlayer, txtPrms, text );
	else
		g_PlayerFuncs.HudMessageAll( txtPrms, text );
}


//=============================================================================
// Tickets
//=============================================================================

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void UpdateTickets()
{
	if ( !g_hTicketCounter.IsValid() )
			return;
			
	CBaseEntity@ pEntity = g_hTicketCounter;
	g_iTickets = int( pEntity.pev.frags );
}

int g_iLastTickets = -1;

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void PeriodicUpdateTickets()
{
	if ( g_fShowTickets )
	{
		UpdateTickets();
		
		if ( g_iLastTickets != g_iTickets )
		{
			SendTickets( null );
			g_iLastTickets = g_iTickets;
		}
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void SendTickets( CBasePlayer@ pPlayer )
{
	g_fShowTickets = true;
	
	HUDNumDisplayParams params;
	
	params.channel = HUD_CHAN_TICKETS;
	params.flags = HUD_ELEM_SCR_CENTER_X | HUD_ELEM_DEFAULT_ALPHA;
	params.value = g_iTickets;
	params.x = 1;
	params.y = 0.9;
	params.defdigits = 2;
	params.maxdigits = 2;
	params.color1 = g_iTickets <= 1 ? RGBA_RED : RGBA_SVENCOOP;
	params.spritename = "snd/reinforcements.spr";
	
	g_PlayerFuncs.HudNumDisplay( pPlayer, params );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void ToggleTicketsDisplay( bool fVisible )
{
	/*if ( g_fShowTickets == fVisible )
		return;*/
	
	g_fShowTickets = fVisible;
	
	if ( g_fShowTickets )
	{
		SendTickets( null );
	}
	else
	{
		g_PlayerFuncs.HudToggleElement( null, HUD_CHAN_TICKETS, false );
	}
}

//=============================================================================
// Caches
//=============================================================================

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void UpdateCaches()
{
	if ( !g_hCacheCounter.IsValid() )
			return;
			
	CBaseEntity@ pEntity = g_hCacheCounter;
	g_iCaches = int( pEntity.pev.frags );
}

int g_iLastCaches = -1;

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void PeriodicUpdateCaches()
{
	if ( g_fShowCaches )
	{
		UpdateCaches();
		
		if ( g_iLastCaches != g_iCaches )
		{
			SendCaches( null );
			g_iLastCaches = g_iCaches;
		}
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void SendCaches( CBasePlayer@ pPlayer )
{
	g_fShowCaches = true;
	
	HUDNumDisplayParams params;
	
	params.channel = HUD_CHAN_CACHES;
	params.flags = HUD_ELEM_SCR_CENTER_X | HUD_ELEM_DEFAULT_ALPHA;
	params.value = g_iCaches;
	params.x = 1;
	params.y = 0.85;
	params.defdigits = 2;
	params.maxdigits = 2;
	params.color1 = g_iCaches <= 1 ? RGBA_RED : RGBA_SVENCOOP;
	params.spritename = "snd/caches.spr";
	
	g_PlayerFuncs.HudNumDisplay( pPlayer, params );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void ToggleCachesDisplay( bool fVisible )
{
	/*if ( g_fShowCaches == fVisible )
		return;*/
	
	g_fShowCaches = fVisible;
	
	if ( g_fShowCaches )
	{
		SendCaches( null );
	}
	else
	{
		g_PlayerFuncs.HudToggleElement( null, HUD_CHAN_CACHES, false );
	}
}

//=============================================================================
// Zone 1
//=============================================================================

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void UpdateZone1()
{
	if ( !g_hZone1Counter.IsValid() )
			return;
			
	CBaseEntity@ pEntity = g_hZone1Counter;
	g_iZone1 = int( pEntity.pev.frags );
}

int g_iLastZone1 = -1;

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void PeriodicUpdateZone1()
{
	if ( g_fShowZone1 )
	{
		UpdateZone1();
		
		if ( g_iLastZone1 != g_iZone1 )
		{
			SendZone1( null );
			g_iLastZone1 = g_iZone1;
		}
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void SendZone1( CBasePlayer@ pPlayer )
{
	g_fShowZone1 = true;
	
	HUDSpriteParams params;
	
	params.channel = HUD_CHAN_ZONE1;
	params.flags = HUD_ELEM_SCR_CENTER_X | HUD_ELEM_DEFAULT_ALPHA;
	params.x = 1;
	params.y = 0.65;
switch( g_iZone1 )
{
    case 0:
        params.color1 = RGBA_RED;
        break;

    case 1:
        params.color1 = RGBA_GREEN;
        break;

    case 2:
        params.color1 = RGBA_WHITE;
        break;
}
	params.spritename = "snd/zone1.spr";
	
	g_PlayerFuncs.HudCustomSprite( pPlayer, params );
}


//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void ToggleZone1Display( bool fVisible )
{
	/*if ( g_fShowZone1 == fVisible )
		return;*/
	
	g_fShowZone1 = fVisible;
	
	if ( g_fShowZone1 )
	{
		SendZone1( null );
	}
	else
	{
		g_PlayerFuncs.HudToggleElement( null, HUD_CHAN_ZONE1, false );
	}
}

//=============================================================================
// Zone 2
//=============================================================================

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void UpdateZone2()
{
	if ( !g_hZone2Counter.IsValid() )
			return;
			
	CBaseEntity@ pEntity = g_hZone2Counter;
	g_iZone2 = int( pEntity.pev.frags );
}

int g_iLastZone2 = -1;

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void PeriodicUpdateZone2()
{
	if ( g_fShowZone2 )
	{
		UpdateZone2();
		
		if ( g_iLastZone2 != g_iZone2 )
		{
			SendZone2( null );
			g_iLastZone2 = g_iZone2;
		}
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void SendZone2( CBasePlayer@ pPlayer )
{
	g_fShowZone2 = true;
	
	HUDSpriteParams params;
	
	params.channel = HUD_CHAN_ZONE2;
	params.flags = HUD_ELEM_SCR_CENTER_X | HUD_ELEM_DEFAULT_ALPHA;
	params.x = 1;
	params.y = 0.70;
switch( g_iZone2 )
{
    case 0:
        params.color1 = RGBA_RED;
        break;

    case 1:
        params.color1 = RGBA_GREEN;
        break;

    case 2:
        params.color1 = RGBA_WHITE;
        break;
}
	params.spritename = "snd/zone2.spr";
	
	g_PlayerFuncs.HudCustomSprite( pPlayer, params );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void ToggleZone2Display( bool fVisible )
{
	/*if ( g_fShowZone2 == fVisible )
		return;*/
	
	g_fShowZone2 = fVisible;
	
	if ( g_fShowZone2 )
	{
		SendZone2( null );
	}
	else
	{
		g_PlayerFuncs.HudToggleElement( null, HUD_CHAN_ZONE2, false );
	}
}

//=============================================================================
// Zone 3
//=============================================================================

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void UpdateZone3()
{
	if ( !g_hZone3Counter.IsValid() )
			return;
			
	CBaseEntity@ pEntity = g_hZone3Counter;
	g_iZone3 = int( pEntity.pev.frags );
}

int g_iLastZone3 = -1;

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void PeriodicUpdateZone3()
{
	if ( g_fShowZone3 )
	{
		UpdateZone3();
		
		if ( g_iLastZone3 != g_iZone3 )
		{
			SendZone3( null );
			g_iLastZone3 = g_iZone3;
		}
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void SendZone3( CBasePlayer@ pPlayer )
{
	g_fShowZone3 = true;
	
	HUDSpriteParams params;
	
	params.channel = HUD_CHAN_ZONE3;
	params.flags = HUD_ELEM_SCR_CENTER_X | HUD_ELEM_DEFAULT_ALPHA;
	params.x = 1;
	params.y = 0.75;
switch( g_iZone3 )
{
    case 0:
        params.color1 = RGBA_RED;
        break;

    case 1:
        params.color1 = RGBA_GREEN;
        break;

    case 2:
        params.color1 = RGBA_WHITE;
        break;
}
	params.spritename = "snd/zone3.spr";
	
	g_PlayerFuncs.HudCustomSprite( pPlayer, params );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void ToggleZone3Display( bool fVisible )
{
	/*if ( g_fShowZone3 == fVisible )
		return;*/
	
	g_fShowZone3 = fVisible;
	
	if ( g_fShowZone3 )
	{
		SendZone3( null );
	}
	else
	{
		g_PlayerFuncs.HudToggleElement( null, HUD_CHAN_ZONE3, false );
	}
}

//=============================================================================
// Zone 4
//=============================================================================

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void UpdateZone4()
{
	if ( !g_hZone4Counter.IsValid() )
			return;
			
	CBaseEntity@ pEntity = g_hZone4Counter;
	g_iZone4 = int( pEntity.pev.frags );
}

int g_iLastZone4 = -1;

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void PeriodicUpdateZone4()
{
	if ( g_fShowZone4 )
	{
		UpdateZone4();
		
		if ( g_iLastZone4 != g_iZone4 )
		{
			SendZone4( null );
			g_iLastZone4 = g_iZone4;
		}
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void SendZone4( CBasePlayer@ pPlayer )
{
	g_fShowZone4 = true;
	
	HUDSpriteParams params;
	
	params.channel = HUD_CHAN_ZONE4;
	params.flags = HUD_ELEM_SCR_CENTER_X | HUD_ELEM_DEFAULT_ALPHA;
	params.x = 1;
	params.y = 0.8;
switch( g_iZone4 )
{
    case 0:
        params.color1 = RGBA_RED;
        break;

    case 1:
        params.color1 = RGBA_GREEN;
        break;

    case 2:
        params.color1 = RGBA_WHITE;
        break;
}
	params.spritename = "snd/zone4.spr";
	
	g_PlayerFuncs.HudCustomSprite( pPlayer, params );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void ToggleZone4Display( bool fVisible )
{
	/*if ( g_fShowZone4 == fVisible )
		return;*/
	
	g_fShowZone4 = fVisible;
	
	if ( g_fShowZone4 )
	{
		SendZone4( null );
	}
	else
	{
		g_PlayerFuncs.HudToggleElement( null, HUD_CHAN_ZONE4, false );
	}
}

} //end namespace