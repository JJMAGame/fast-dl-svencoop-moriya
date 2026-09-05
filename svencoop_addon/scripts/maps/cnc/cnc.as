/*
* Prototype Command & Conquer like game mode
* Single inclusion file for everything you need
*/
#include "cnc_constants"
#include "cnc_settings"
#include "cnc_objects"
#include "cnc_economy"
#include "cnc_teams"
#include "cnc_mapinterface"
#include "cnc_resources"
#include "cnc_player"

namespace CNC
{
void Initialize()
{
	RegisterResourceEntity();
}

CBaseEntity@ FindBuildingRotationEnt( const string& in szBuildingRotationEntName )
{
	return g_EntityFuncs.FindEntityByTargetname( null, szBuildingRotationEntName );
}

/*
* Initializes the CNC game mode system.
* Must be called in MapActivate.
*/
void Activate( const string& in szBuildingRotationEntName = "building_rotation" )
{
	if( !g_Settings.BuildingRotationEntity.IsValid() )
		g_Settings.BuildingRotationEntity = EHandle( FindBuildingRotationEnt( szBuildingRotationEntName ) );
	
	g_Settings.Lock();
	
	g_Settings.BrushTemplates.AddTemplate( g_Settings.CrateTemplate, true );
	
	g_Scheduler.SetInterval( "UpdateHUDInfoForPlayers", g_Settings.HUDUpdateInterval, g_Scheduler.REPEAT_INFINITE_TIMES );
}

/*
* Sets up single player team mode; one global team
*/
Team@ SetupGlobalTeam( ResourceCarryRules@ pCarryRules, Market@ pMarket, Wallet@ pWallet )
{
	Team@ pGlobalTeam = Team( @pCarryRules, @pMarket, @pWallet );
	
	@g_Settings.TeamDataAccessor = @GlobalTeamDataAccessor( pGlobalTeam );
	
	return pGlobalTeam;
}

Player@ PlayerJoined( CBasePlayer@ pPlayerEnt )
{
	Player player( pPlayerEnt, null );
	
	SetPlayerOnPlayerEntity( pPlayerEnt, @player );
	
	return @player;
}
}

/*
* Requirements:
* You must call CNC::Initialize in MapInit
* You must call CNC::Activate in MapActivate
* You must provide an instance for CNC::g_pTeamDataAccessor
* You must call CNC::PlayerJoined when a player first joins (Hooks::Player::ClientPutInServer)
* You must set a team for a player using CNC::SetPlayerTeam to allow per-team HUD messages to show up (ideally in Hooks::Player::ClientPutInServer)
*/

/*
* Recommendations:
* Set CNC::g_Settings.m_vecCrateSpawnPoint to a suitable default
*/

/*
* Usage:
* Adding buildings:
* Create a class that inherits from CNC::BaseBuyableBuilding
* Register it as a buyable object in the market for the team that should be able to buy it
* Example:

class Wall : CNC::BaseBuyableBuilding
{
	Wall( CNC::BuyableDescriptor@ pDescriptor )
	{
		super( pDescriptor );
		
		StartHealth = 10;
		
		Material = matCinderBlock;
	}
	
	void Spawn( const Vector& in vecOrigin )
	{
		CBaseEntity@ pBreakable = CreateBreakableBuilding( vecOrigin );
		
		AttachToEntity( pBreakable );
	}
}

CNC::BaseBuyableObject@ CreateWall( CNC::BuyableDescriptor@ pDescriptor )
{
	return Wall( pDescriptor );
}

Market market;

//Object name, cost, type, creation function, brush template entity name
market.AddBuyableObjectDescriptor( "wall", 10, CNC::Buyable_Building, @CreateWall, "wall_template" );

* To spawn a crate that can create buildings when destroyed:
* Use a trigger_script to trigger CNC::SpawnCrate. The caller must have a custom keyvalue named CNC::g_Settings.m_szBuildingNameKV (see declaration for default value), which names the building type
*
* To rotate the building by an arbitrary amount, create an entity named CNC::g_Settings.m_szBuildingRotationEntName. The angles of this entity are used for buildings. Use a momentary_rot_button for ease of rotation.
* To rotate the building by a preset amount per input, use a trigger_script to trigger CNC::AddBuildingRotation. For each trigger, CNC::g_Settings.m_vecRotationIncrement is added to the rotation.
* The preset amount overrides the arbitrary amount for easier snapping to angles.
*/