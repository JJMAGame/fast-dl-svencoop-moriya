/*
* Bridge3/suspension
* Custom HUD
*
* Created by Tomas "GeckoN" Slavotinek
*/

namespace CustomHUD
{

const int HUD_CHAN_TICKETS = 0;
const int HUD_CHAN_AWARD = 1;

const string ENT_TICKET_CNT = "ticket_counter"; // entity name
const string ENT_DEATH_CNT = "death_counter"; // entity name

const float HUD_RESULTS_DELAY = 1; // # of seconds before showing the results
const float HUD_RESULTS_HOLD = 10; // hold the results for # seconds
const float HUD_AWARD_DELAY = 1; // # of seconds before showing the award
const float HUD_AWARD_HOLD = 10; // hold the award for # seconds

bool g_fShowTickets;
int g_iTickets;
int g_iTicketsTotal;

float g_flStartTime;
float g_flEndTime;

EHandle g_hTicketCounter;
EHandle g_hDeathCounter;

//=============================================================================
// AWARDS
//=============================================================================

array<array<string>> g_AwardInfo =
{
//	deaths	sprite name			message												message color		sound
	{ "0",	"award_platinum",	"PLATINIUM AWARD\nExcellent!",						"200 200 200 200",	"bridge/epicwin.wav" },
	{ "5",	"award_gold",		"GOLD AWARD\nGreat!",								"210 175 66 200",	"bridge/applause.wav" },
	{ "10",	"award_silver",		"SILVER AWARD\nWell done!",							"140 150 150 200",	"bridge/applause.wav" },
	{ "20",	"award_bronze",		"BRONZE AWARD\nNot bad!",							"220 160 96 200",	"bridge/applause.wav" },
	{ "30",	"award_stone",		"STONE AWARD\nGive it another shot!",				"130 130 130 200",	"bridge/fail.wav" },
	{ "40",	"award_noob",		"N00B AWARD\nYou weren't even trying, were you?",	"60 120 180 200",	"bridge/fail.wav" }
};

int GetAwardInfoIndex( int iDeaths )
{
	uint iNum = g_AwardInfo.length();
	
	for ( uint i = 0; i < iNum; i++ )
	{
		if ( iDeaths <= atoi( g_AwardInfo[ i ][ 0 ] ) )
			return i;
	}

	return iNum - 1;
}

void AwardInfoPrecacheSounds()
{
	uint iNum = g_AwardInfo.length();

	for ( uint i = 0; i < iNum; i++ )
	{
		g_SoundSystem.PrecacheSound( GetAwardSoundName( i ) );
	}
}

string GetAwardSpriteName( int id ) { return g_AwardInfo[ id ][ 1 ]; }
string GetAwardMessage( int id ) { return g_AwardInfo[ id ][ 2 ]; }
string GetAwardMessageColor( int id ) { return g_AwardInfo[ id ][ 3 ]; }
string GetAwardSoundName( int id ) { return g_AwardInfo[ id ][ 4 ]; }

//=============================================================================
// Shared
//=============================================================================

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void Init()
{
	g_Hooks.RegisterHook( Hooks::Player::ClientPutInServer, @ClientPutInServer );
	//g_Hooks.RegisterHook( Hooks::Player::PlayerSpawn, @PlayerSpawn );
	
	g_fShowTickets = false;
	g_iTicketsTotal = 0;
	g_iTickets = 0;
	
	g_flStartTime = 0.0;
	g_flEndTime = 0.0;
	
	AwardInfoPrecacheSounds();
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
HookReturnCode ClientPutInServer( CBasePlayer@ pPlayer )
{
	if ( g_fShowTickets )
		SendTickets( pPlayer );
	
	return HOOK_CONTINUE;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void StartGame()
{
	CBaseEntity@ pEntity;

	@pEntity = g_EntityFuncs.FindEntityByTargetname( null, ENT_TICKET_CNT );
	if ( pEntity is null )
		g_Game.AlertMessage( at_error, "Ticket counter entity '%1' not found\n", ENT_TICKET_CNT );
	else
		g_hTicketCounter = EHandle( pEntity );
	
	@pEntity = g_EntityFuncs.FindEntityByTargetname( null, ENT_DEATH_CNT );
	if ( pEntity is null )
		g_Game.AlertMessage( at_error, "Death counter entity '%1' not found\n", ENT_DEATH_CNT );
	else
		g_hDeathCounter = EHandle( pEntity );
	
	g_Scheduler.SetInterval( "PeriodicUpdate", 0.5, g_Scheduler.REPEAT_INFINITE_TIMES );
	
	g_flStartTime = g_Engine.time;
	
	ResetDeaths();
	
	UpdateTickets();	
	g_iTicketsTotal = g_iTickets;
	
	SendTickets( null );
}

int g_iDeaths = 0;

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void EndGame( int iDeathsOverride = -1 )
{
	g_flEndTime = g_Engine.time;
	
	ToggleTicketsDisplay( false );
	
	g_iDeaths = GetDeaths();
	
	if ( iDeathsOverride >= 0 )
	{
		g_Game.AlertMessage( at_error, "Overriding number of deaths to %1\n", iDeathsOverride );
		g_iDeaths = iDeathsOverride;
	}
	
	g_Scheduler.SetTimeout( "ShowResults", HUD_RESULTS_DELAY );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void ShowResults()
{
	string strText;
	
	float flTime = g_flEndTime - g_flStartTime;
	int iMinutes = int( flTime ) / 60;
	int iSeconds = int( flTime ) % 60;
	
	snprintf( strText, "GAME RESULTS\n\nTotal Deaths\n%1\n\nTotal time\n%2:%3",
		g_iDeaths,
		formatInt( iMinutes, "0", 1 ),
		formatInt( iSeconds, "0", 2 ) );
	
	Message( null, strText, -1, -1, RGBA_WHITE, 0.5, 0.5, HUD_RESULTS_HOLD );
	
	g_Scheduler.SetTimeout( "ShowAward", HUD_RESULTS_HOLD + HUD_AWARD_DELAY );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
int GetDeaths()
{
	if ( !g_hDeathCounter.IsValid() )
			return 0;
			
	CBaseEntity@ pEntity = g_hDeathCounter;
	return int( pEntity.pev.frags );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void ResetDeaths()
{
	if ( !g_hDeathCounter.IsValid() )
			return;
			
	CBaseEntity@ pEntity = g_hDeathCounter;
	pEntity.pev.frags = 0;
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
void PeriodicUpdate()
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
	params.x = 0;
	params.y = 1;
	params.defdigits = 2;
	params.maxdigits = 2;
	params.color1 = g_iTickets <= 1 ? RGBA_RED : RGBA_SVENCOOP;
	params.spritename = "bridge/tickets.spr";
	
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
// Awards
//=============================================================================

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void ShowAward()
{
	int id = GetAwardInfoIndex( g_iDeaths );
	string strMsg = "Your team has achieved:\n" + GetAwardMessage( id );
	
	SendAward( null, GetAwardSpriteName( id ), HUD_AWARD_HOLD );
	RGBA rgba = StringToRGBA( GetAwardMessageColor( id ) );
	Message( null, strMsg, -1, 0.55, rgba, 0, 0, HUD_AWARD_HOLD );

	CBaseEntity@ pWorld = g_EntityFuncs.Instance( 0 );
	g_SoundSystem.PlaySound( pWorld.edict(), CHAN_MUSIC, GetAwardSoundName( id ), 1.0, ATTN_NONE, 0, 100 );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void SendAward( CBasePlayer@ pPlayer, const string& in strAwardName, float hold = 5.0 )
{
	string strName;
	snprintf( strName, "bridge/%1.spr", strAwardName );

	HUDSpriteParams params;
	
	params.channel = HUD_CHAN_AWARD;
	params.flags = HUD_ELEM_ABSOLUTE_Y | HUD_ELEM_SCR_CENTER_Y | HUD_ELEM_SCR_CENTER_X | HUD_SPR_MASKED;
	params.spritename = strName;
	params.x = 0;
	params.y = -128;
	params.holdTime = hold;
	params.color1 = RGBA_WHITE;

	g_PlayerFuncs.HudCustomSprite( pPlayer, params );
}

} // end of namespace
