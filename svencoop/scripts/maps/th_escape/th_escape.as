/*
* They Hunger: Escape (th_escape)
* Main script file
*
* Created by Josh "JPolito" Polito -- JPolito@svencoop.com
* Modified by Tomas "GeckoN" Slavotinek
*/

#include "../RandNumMath"
#include "CustomHUD"
#include "LowHealthFX"
#include "PlayerCharacters"
#include "RndBreakables"
#include "func_vehicle_jp"
#include "func_trackvehicle"
#include "trigger_look"
#include "trigger_playercheck"
#include "../hunger/th_weapons"
#include "../hunger/monsters/monster_th_grunt_repel"

array<ItemMapping@> g_ItemMappings =
{ 
	ItemMapping( "weapon_9mmAR", THWeaponThompson::WEAPON_NAME ),
	ItemMapping( "weapon_shotgun", THWeaponSawedoff::WEAPON_NAME ),
	ItemMapping( "weapon_m16", THWeaponM16A1::WEAPON_NAME ),
	ItemMapping( "weapon_9mmhandgun", THWeaponM1911::WEAPON_NAME ),
	ItemMapping( "weapon_sniperrifle", THWeaponM14::WEAPON_NAME ),
	ItemMapping( "weapon_eagle", "weapon_357" )
};

LowHealth::LowHealthMod g_LowHealthMod();

enum GAMESTATE
{
	GAMESTATE_NEW = 0,
	GAMESTATE_RUNNING,
	GAMESTATE_FINISHED,
	GAMESTATE_FAILED
};

GAMESTATE g_gamestate = GAMESTATE_NEW;

enum DIFFICULTY
{
	DIFFICULTY_NORMAL = 0,
	DIFFICULTY_NIGHTMARE
};

DIFFICULTY g_difficulty = DIFFICULTY_NORMAL;

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void MapInit()
{
	// Register custom entities
	VehicleCustom::Register( true );
	TrackVehicle::Register( false ); // Don't register hooks for trackvehicle yet
	TriggerLook::Register();
	TriggerPlayerCheck::Register();
	
	// Register custom weapons
	THWeaponSawedoff::Register();
	THWeaponM16A1::Register();
	THWeaponM1911::Register();
	THWeaponThompson::Register();
	THWeaponM14::Register();
	THWeaponTeslagun::Register();
	THWeaponGreasegun::Register();
	THWeaponSpanner::Register();
	
	// Register custom monsters
	THMonsterGruntRepel::Register();
	
	// Initialize classic mode (item mapping only)
	g_ClassicMode.SetItemMappings( @g_ItemMappings );
	g_ClassicMode.ForceItemRemap( true );
	
	// Generates array of random "events". This array is used later on to spawn
	// things at random points during the vehicle repair sequence.
	InitRandomEvents();
	
	// Low health effect
	g_LowHealthMod.OnInit();
	g_LowHealthMod.OnMapInit();
	
	CustomHUD::Init();
	
	g_Hooks.RegisterHook( Hooks::Player::ClientDisconnect, @ClientDisconnect );
	g_Hooks.RegisterHook( Hooks::Player::PlayerKilled, @PlayerKilled );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void MapStart()
{
	RndBreakables::Init();
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
HookReturnCode ClientDisconnect( CBasePlayer@ pPlayer )
{
	CheckEndConditions();
	
	return HOOK_CONTINUE;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
HookReturnCode PlayerKilled( CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib )
{
	CheckEndConditions();
	
	return HOOK_CONTINUE;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void CheckEndConditions()
{
	//g_Game.AlertMessage( at_console, "CheckEndConditions() called\n" );
	
	if ( g_gamestate == GAMESTATE_RUNNING && GetLivingPlayersCount() == 0 )
	{
		g_gamestate = GAMESTATE_FAILED;
		
		TheEnd();
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
int GetLivingPlayersCount()
{
	int iLivingPlayers = 0;
	
	for( int iIndex = 1; iIndex <= g_Engine.maxClients; iIndex++ )
	{
		CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iIndex );
		
		if( pPlayer !is null && pPlayer.IsAlive() )
			iLivingPlayers++;
	}
	
	return iLivingPlayers;
}

//=============================================================================
// Random Events
//=============================================================================

const int REPAIR_COUNTER_MIN = 3;
const int REPAIR_COUNTER_MAX = 97;

const int REPAIR_EVENTS_MIN = 3; // At least # events during the repair seq.
const int REPAIR_EVENTS_MAX = 6; // Up to # events during the repair seq.

array<string> g_triggerTargets = 
{
	"priest_windowcop",
	"zspawn_conndr_mm",
	"attic_windowcop1",
	"attic_windowcop2",
	"skychickens",
	"hotel_door_mm"
};

array<int> g_triggerPercent;
array<int> g_triggerId;

int g_nextTriggerId = 0;

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void InitRandomEvents()
{
	uint iNumEvents = uint( Math.RandomLong( REPAIR_EVENTS_MIN, REPAIR_EVENTS_MAX ) );
	
	// GeckoN: TODO: This can be removed later on when we have enough triggers defined
	if ( iNumEvents > g_triggerTargets.length() )
		iNumEvents = g_triggerTargets.length();
		
	//g_Game.AlertMessage( at_console, "Number of random events: %1\n", iNumEvents );
	
	g_triggerPercent = RandNumMath::IncreasingSequence( iNumEvents, REPAIR_COUNTER_MIN, REPAIR_COUNTER_MAX, 4, 0.85 ); // GeckoN: TODO: Use definitions
	g_triggerId = RandNumMath::ShuffledSequence( iNumEvents );
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void ReadGameCounter(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	int iValue = int( pCaller.pev.frags );
	int iId = g_nextTriggerId;
	int iNumEvents = g_triggerPercent.length();
	
	while ( iId < iNumEvents && g_triggerPercent[ iId ] <= iValue )
	{
		string cszTargetname = g_triggerTargets[ g_triggerId[ iId ] ];
		g_EntityFuncs.FireTargets( cszTargetname, pActivator, pCaller, USE_TOGGLE, 0.0f, 0.0f );
		//g_Game.AlertMessage( at_console, "Triggering event #%1 ('%2')\n", iId, cszTargetname );
		
		g_nextTriggerId = ++iId;
	}
}

//=============================================================================
// Player Characters
//=============================================================================

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void SetCharacters(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE usetype, float fValue)
{
	//g_Game.AlertMessage( at_console, "SetCharacters() called\n" );
	PlayerCharacters::Set();
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void StartCharacters(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE usetype, float fValue)
{
	//g_Game.AlertMessage( at_console, "StartCharacters() called\n" );
	PlayerCharacters::Start();
	int iNumPlayers = PlayerCharacters::GetNumActivePlayers();
	
	RndBreakables::SetMode( int( g_difficulty ) );
	
	int iMinutes = ( g_difficulty == DIFFICULTY_NIGHTMARE ) ? 7 : 8;
	if ( iNumPlayers <= 4 )
		iMinutes += 1;
	CustomHUD::SetTarget( iMinutes * 60, "timesup_mm" );
	CustomHUD::SetWarningTarget( 60, "lastmin_mm_relay" );
	
	CustomHUD::ToggleTimeDisplay( true );
	CustomHUD::ToggleStatusIndicators( true );
	
	VehicleCustom::RemoveHooks();
	TrackVehicle::RegisterHooks();
	
	g_gamestate = GAMESTATE_RUNNING;
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void EquipCharacters(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE usetype, float fValue)
{
	//g_Game.AlertMessage( at_console, "EquipCharacters() called\n" );
	PlayerCharacters::Equip();
}

//=============================================================================
// Item inventory
//=============================================================================

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void TargetItemBattery( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::SetItemStatus( CustomHUD::ITEM_BATTERY, true );
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void TargetItemGasCan( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::SetItemStatus( CustomHUD::ITEM_GASCAN, true );
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void TargetItemToolbox( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::SetItemStatus( CustomHUD::ITEM_TOOLBOX, true );
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void AllItemsDroppedOff( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CustomHUD::ToggleStatusIndicators( false );
}

//=============================================================================
// Vehicle
//=============================================================================

const string VEHICLE_NAME = "veh1_drivable";

//-----------------------------------------------------------------------------
// Purpose: 
//-----------------------------------------------------------------------------
TrackVehicle::CTrackVehicle@ GetVehicle() 
{
	TrackVehicle::CTrackVehicle@ pVehicle = null;
	CBaseEntity@ pEntity = null;
	while ( ( @pEntity = g_EntityFuncs.FindEntityByClassname( pEntity, "func_trackvehicle" ) ) !is null )
	{
		if ( pEntity.pev.targetname == VEHICLE_NAME )
			@pVehicle = cast<TrackVehicle::CTrackVehicle@>( CastToScriptClass( pEntity ) );
	}
	
	if ( pVehicle is null )
	{
		g_Game.AlertMessage( at_error, "Vehicle \"%1\" not found!\n", VEHICLE_NAME );
	}
	
	return pVehicle;
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void VehicleIgnitionOn( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	//g_Game.AlertMessage( at_console, "VehicleIgnitionOn() called\n" );
	
	if ( g_gamestate != GAMESTATE_RUNNING )
		return;
	
	TrackVehicle::CTrackVehicle@ pVehicle = GetVehicle();
	
	if ( pVehicle !is null )
		pVehicle.IgnitionOn();
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void VehicleStarted( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	//g_Game.AlertMessage( at_console, "VehicleStarted() called\n" );
	
	if ( g_gamestate != GAMESTATE_RUNNING )
		return;
	
	TrackVehicle::CTrackVehicle@ pVehicle = GetVehicle();
	
	if ( pVehicle !is null )
		pVehicle.EnableControls();
}

//=============================================================================
// Global game state
//=============================================================================

//-----------------------------------------------------------------------------
// Purpose: Set the skill CVAR and reload the map skill config
//-----------------------------------------------------------------------------
void SetSkill()
{
	int iSkill = ( g_difficulty == DIFFICULTY_NIGHTMARE ) ? 2 : 1;
	g_EngineFuncs.CVarSetFloat( "skill", iSkill );
	if ( !g_Map.LoadMapSkillFile() )
	{
		g_Game.AlertMessage( at_error, "Unable to reload map skill file!\n" );
	}
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void NormalDifficulty( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	//g_Game.AlertMessage( at_console, "NormalDifficulty() called\n" );
	
	g_difficulty = DIFFICULTY_NORMAL;
	
	SetSkill();
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void NightmareDifficulty( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	//g_Game.AlertMessage( at_console, "NightmareDifficulty() called\n" );
	
	g_difficulty = DIFFICULTY_NIGHTMARE;
	
	SetSkill();
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void AbortGame( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	//g_Game.AlertMessage( at_console, "AbortGame() called\n" );
	
	if ( g_gamestate != GAMESTATE_RUNNING )
		return;
	
	g_gamestate = GAMESTATE_FAILED;
	
	CustomHUD::ToggleTimeDisplay( false );
	CustomHUD::ToggleStatusIndicators( false );
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void EndGame( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	//g_Game.AlertMessage( at_console, "EndGame() called\n" );
	
	if ( g_gamestate != GAMESTATE_RUNNING )
		return;
	
	g_gamestate = GAMESTATE_FINISHED;
	
	TheEnd();
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void TheEnd()
{
	CustomHUD::ToggleTimeDisplay( false );
	CustomHUD::ToggleStatusIndicators( false );
	
	g_LowHealthMod.Disable();

	SortPlayers();
	TriggerEnding();
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void GameOutro( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	RemoveEntityByClassname( "monster_human_grunt" );
}

//=============================================================================
// Game endings
//=============================================================================

array<string> g_winnars;
array<string> g_lastliving;
array<string> g_ghostboyes;

const string VOLUME_ENTITY_NAME = "detectendplayers";

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
bool IsPointInVolume( const Vector& in origin, CBaseEntity@ pVolume )
{
	if ( pVolume is null )
		return false;
	
	TraceResult tr;
	g_Utility.TraceModel( origin, origin, point_hull, pVolume.edict(), tr );
	
	return tr.pHit !is null;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void SortPlayers()
{
	CBaseEntity@ pVolumeEntity = g_EntityFuncs.FindEntityByTargetname( null, VOLUME_ENTITY_NAME );
	if ( pVolumeEntity is null )
	{
		g_Game.AlertMessage( at_error, "Volume entity '%1' not found\n", VOLUME_ENTITY_NAME );
		return;
	}

	g_winnars.resize( 0 );
	g_lastliving.resize( 0 );
	g_ghostboyes.resize( 0 );
	
	// Assign characters
	for ( int i = 1; i <= g_Engine.maxClients; i++ )
	{
		CBasePlayer @ pPlayer = g_PlayerFuncs.FindPlayerByIndex( i );
		if ( pPlayer is null || pPlayer.pev.targetname == "" )
			continue;

		if ( pPlayer.IsAlive() )
		{
			if ( IsPointInVolume( pPlayer.pev.origin, pVolumeEntity ) )
			{
				g_winnars.insertLast( pPlayer.pev.netname );
				pPlayer.pev.targetname = "winnars";
			}
			else
			{
				g_lastliving.insertLast( pPlayer.pev.netname );
				pPlayer.pev.targetname = "lastliving";
			}
		}
		else
		{
			g_ghostboyes.insertLast( pPlayer.pev.netname );
			pPlayer.pev.targetname = "ghostboyes";
		}
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void TriggerEnding()
{
	string strTarget;
	
	bool fWinnars = g_winnars.length() > 0;
	bool fLastLiving = g_lastliving.length() > 0;
	bool fGhostBoyes = g_ghostboyes.length() > 0;
	
	if ( fWinnars )
	{
		if ( fLastLiving )
			strTarget = "end_mixed1_mm";
		else if ( fGhostBoyes )
			strTarget = "end_mixed2_mm";
		else
			strTarget = "end_best_mm";
	}
	else
	{
		if ( fLastLiving )
			strTarget = "end_jail_mm";
		else
			strTarget = "everyonedied_rel";
	}
	
	//g_Game.AlertMessage( at_console, "Firing %1\n", strTarget );
	g_EntityFuncs.FireTargets( strTarget, null, null, USE_TOGGLE, 0.0f, 0.0f );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void RemoveEntityByClassname( string & in strClassname )
{
	if ( strClassname == "" )
		return;
	
	int iCount = 0;
	
	CBaseEntity@ pEntity = null;
	while ( ( @pEntity = g_EntityFuncs.FindEntityByClassname( pEntity, strClassname ) ) !is null )
	{
		g_EntityFuncs.Remove( pEntity );
		iCount++;
	}
	
	//g_Game.AlertMessage( at_console, "Removed %1 instance(s) of \"%2\"\n", iCount, strClassname );
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void ShowSurvivors( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	uint iNum = g_winnars.length();
	
	if ( iNum == 0 )
		return;
	
	string strText;
	if ( iNum == 1 )
		strText = "SURVIVOR";
	else
		strText = "SURVIVORS";
		
	strText += "\n\n";
	
	for ( uint i = 0; i < g_winnars.length(); i++ )
		strText += g_winnars[ i ] + "\n";
	
	CustomHUD::Message( null, strText );
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void ShowLosers( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	uint iNum = g_lastliving.length() + g_ghostboyes.length();
	
	if ( iNum == 0 )
		return;
	
	string strText;
	if ( iNum == 1 )
		strText = "LOSER";
	else
		strText = "LOSERS";
		
	strText += "\n\n";
	
	for ( uint i = 0; i < g_lastliving.length(); i++ )
		strText += g_lastliving[ i ] + "\n";
	for ( uint i = 0; i < g_ghostboyes.length(); i++ )
		strText += g_ghostboyes[ i ] + "\n";
	
	CustomHUD::Message( null, strText );
}
