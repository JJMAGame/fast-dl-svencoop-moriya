/*
* They Hunger: Escape (th_escape)
* Player charaters
*
* Created by Tomas "GeckoN" Slavotinek
*/

#include "CustomHUD"

namespace PlayerCharacters
{

//=============================================================================
// Character Info
//=============================================================================

const float EFFECT_DURATION = 120; // [seconds]

array<array<string>> g_CharacterInfo =
{
//	type	name				model			message									effect	equip
	{ "d",	"player_civilian",	"", 			"You are a random civilian.",			"",		"" },
	{ "p",	"player_asylum",	"th_patient",	"You are the Asylum Patient.",			"",		"" },
	{ "p",	"player_priest",	"th_paul",		"You are the Priest.",					"",		"" },
	{ "p",	"player_gangster",	"th_gangster",	"You are Big Paul.",					"",		"" },
	{ "p",	"player_deputy",	"th_nypdcop",	"You are a Police Officer.",			"",		"weapon_colt1911;ammo_9mmclip" },
	{ "p",	"player_drunk",		"th_neil",		"You are a Drunk.",						"d",	"weapon_handgrenade" },
	{ "p",	"player_nurse",		"th_nurse",		"You are a Paramedic.",					"",		"weapon_medkit" },
	{ "p",	"player_mechanic",	"th_worker",	"You are the Mechanic.",				"",		"weapon_spanner" },
	{ "p",	"player_radio",		"th_host",		"You are the Radio Host.",				"",		"" },
	{ "p",	"player_sewer",		"th_cl_suit",	"You are a Water Treatment Engineer.",	"",		"" },
	{ "p",	"player_conductor",	"th_dave",		"You are the Railroad Engineer.",		"",		"weapon_spanner" },
	{ "s",	"player_orderly",	"th_orderly",	"You are a Paramedic.",					"",		"weapon_medkit" },
	{ "s",	"player_deputy2",	"th_jack",		"You are a Police Officer.",			"",		"weapon_357;ammo_357" },
	{ "s",	"player_drunk2",	"th_einar",		"You are a Drunk.",						"d",	"weapon_handgrenade" },
	{ "s",	"player_sewer2",	"th_cl_suit",	"You are a Water Treatment Engineer.",	"",		"" },
	{ "s",	"player_sewer3",	"th_cl_suit",	"You are a Water Treatment Engineer.",	"",		"weapon_spanner" }
};

// types:
// p - primary character
// s - secondary character
// d - default character (used if all other characters are assigned already)

// effects:
// d - drunk FX

// equip:
// item names separated by ';'

array<string> g_DefaultModels = { "th_civpaul", "th_einstein", "th_slick" };

//-----------------------------------------------------------------------------

string GetCharacterType( int id ) { return g_CharacterInfo[ id ][ 0 ]; }
string GetCharacterName( int id ) { return g_CharacterInfo[ id ][ 1 ]; }
string GetCharacterMessage( int id ) { return g_CharacterInfo[ id ][ 3 ]; }
string GetCharacterEffect( int id ) { return g_CharacterInfo[ id ][ 4 ]; }
string GetCharacterEquip( int id ) { return g_CharacterInfo[ id ][ 5 ]; }

string GetCharacterModel( int id )
{
	if ( g_CharacterInfo[ id ][ 2 ] != "" )
		return g_CharacterInfo[ id ][ 2 ];
	
	int iModel = Math.RandomLong( 0, g_DefaultModels.length() - 1 );
	//g_Game.AlertMessage( at_console, "Random player model \"%1\"\n", g_DefaultModels[ iModel ] );
	return g_DefaultModels[ iModel ];
	
}

uint GetNumCharacter() { return g_CharacterInfo.length(); }

int GetCharacterIndexByName( const string& in name )
{
	for ( uint i = 0; i < GetNumCharacter(); i++ )
	{
		if ( GetCharacterName( i ) == name )
			return i;
	}
	
	return -1;
}

//=============================================================================

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
int GetNumActivePlayers()
{
	int iNum = 0;
	
	for ( int i = 1; i <= g_Engine.maxClients; i++ )
	{
		CBasePlayer @ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
		if ( pPlayer is null || pPlayer.pev.targetname == "" )
			continue;
			
		iNum++;
	}
	
	return iNum;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void Set()
{
	// Create temporary arrays
	array<string> CharacterArrayPrimary, CharacterArraySecondary;
	string strCharacterDefault;
	
	for ( uint i = 0; i < GetNumCharacter(); i++ )
	{
		string strType = GetCharacterType( i );
		string strName = GetCharacterName( i );
		if  ( strType == "d" )
			strCharacterDefault = strName;
		else if (strType == "p" )
			CharacterArrayPrimary.insertLast( strName );
		else if ( strType == "s" )
			CharacterArraySecondary.insertLast( strName );
	}
	
	// Assign characters
	for ( int i = 1; i <= g_Engine.maxClients; i++ )
	{
		CBasePlayer @ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
		if ( pPlayer is null || pPlayer.pev.targetname != "" )
			continue;
			
		if ( CharacterArrayPrimary.length() > 0 )
		{
			int RandomArrayPosition = Math.RandomLong( 0, CharacterArrayPrimary.length() - 1 );
			pPlayer.pev.targetname = CharacterArrayPrimary[ RandomArrayPosition ];
			CharacterArrayPrimary.removeAt(RandomArrayPosition);
		}
		else
		{
			if ( CharacterArraySecondary.length() > 0 )
			{
				int RandomArrayPosition = Math.RandomLong( 0, CharacterArraySecondary.length() - 1 );
				pPlayer.pev.targetname = CharacterArraySecondary[ RandomArrayPosition ];
				CharacterArraySecondary.removeAt(RandomArrayPosition);
			}
			else
			{
				pPlayer.pev.targetname = strCharacterDefault;
			}
		}
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void Start()
{
	for ( int i = 1; i <= g_Engine.maxClients; i++ )
	{
		CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( i );
		if ( pPlayer is null || pPlayer.pev.targetname == "" )
			continue;
		
		int id = GetCharacterIndexByName( pPlayer.pev.targetname );
		if ( id < 0 )
			continue; // This should never happen 
			
		// Set player model
		string strModel = GetCharacterModel( id );
		if ( strModel != "" )
		{
			KeyValueBuffer@ pInfoBuffer = g_EngineFuncs.GetInfoKeyBuffer( pPlayer.edict() );
			pInfoBuffer.SetValue( "model", strModel );
		}
		
		// Reset health
		pPlayer.pev.health = 100.0f;
		
		// Show HUD message
		string strMessage = GetCharacterMessage( id );
		if ( strMessage != "" )
		{
			CustomHUD::Message( pPlayer, strMessage, -1, 0.65 );
		}
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void Equip()
{
	for ( int i = 1; i <= g_Engine.maxClients; i++ )
	{
		CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( i );
		if ( pPlayer is null || pPlayer.pev.targetname == "" )
			continue;
		
		int id = GetCharacterIndexByName( pPlayer.pev.targetname );
		if ( id < 0 )
			continue; // This should never happen 
		
		// Get character equip
		string strEquip = GetCharacterEquip( id );
		if ( strEquip != "" )
		{
			// Parse equip
			array<string>@ equip = strEquip.Split(";");
			for ( uint j = 0; j < equip.length(); j++ )
			{
				pPlayer.GiveNamedItem( equip[ j ] );
			}
		}
		
		// Special effects
		string strEffect = GetCharacterEffect( id );
		if ( strEffect == "d" )
		{
			g_PlayerFuncs.ConcussionEffect( pPlayer, 35, 1, 1 );
		}
	}
	
	g_Scheduler.SetTimeout( "EffectWearOff", EFFECT_DURATION );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void EffectWearOff()
{
	//g_Game.AlertMessage( at_console, "EffectWearOff() called\n" );
	
	for ( int i = 1; i <= g_Engine.maxClients; i++ )
	{
		CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( i );
		if ( pPlayer is null || pPlayer.pev.targetname == "" )
			continue;
			
		int id = GetCharacterIndexByName( pPlayer.pev.targetname );
		if ( id < 0 )
			continue; // This should never happen 
		
		string strEffect = GetCharacterEffect( id );
		if ( strEffect == "d" )
		{
			g_PlayerFuncs.ConcussionEffect( pPlayer, 0, 1, 60 );
		}
	}
}

} // end of namespace
