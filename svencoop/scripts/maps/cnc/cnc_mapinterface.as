/*
* Prototype Command & Conquer like game mode
* Interface for maps to use
*/
#include "cnc_economy"
#include "cnc_teams"

namespace CNC
{
/*
* Spawns a crate that, when destroyed, spawns a building
* pCaller has a custom keyvalue g_Settings.BuildingNameKV that indicates which building to spawn
*/
void SpawnBuildingCrate( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	if( pCaller is null )
		return;
		
	if( g_Settings.TeamDataAccessor is null )
	{
		g_Game.AlertMessage( at_console, "Team data accessor is null!\n" );
		return;
	}
		
	Market@ pMarket = g_Settings.TeamDataAccessor.GetMarket( pCaller );
	
	Wallet@ pWallet = g_Settings.TeamDataAccessor.GetWallet( pCaller );
		
	CustomKeyvalues@ pCustom = pCaller.GetCustomKeyvalues();
	
	CustomKeyvalue buildingName = pCustom.GetKeyvalue( g_Settings.BuildingNameKV );
	
	if( !buildingName.Exists() )
		return;
		
	const string szBuildingName = buildingName.GetString();
	
	SpawnBuildingCrate( pMarket, pWallet, szBuildingName );
}

/*
* Spawns a crate that, when destroyed, spawns a building
* szBuildingName is the name of the building that the crate should spawn
*/
void SpawnBuildingCrate( Market@ pMarket, Wallet@ pWallet, const string& in szBuildingName )
{
	if( pMarket is null )
	{
		g_Game.AlertMessage( at_console, "Market is null!\n" );
		return;
	}
	
	if( pWallet is null )
	{
		g_Game.AlertMessage( at_console, "Wallet is null!\n" );
		return;
	}
	
	if( szBuildingName.IsEmpty() )
	{
		g_Game.AlertMessage( at_console, "Building name is empty!\n" );
		return;
	}
		
	/*if( !g_Settings.BrushTemplates.TemplateExists( g_Settings.CrateTemplate ) )
	{
		g_Game.AlertMessage( at_console, "Crate template is not exists!\n" );
		return;
	}*/
	
	BaseBuyableObject@ pObject = null;
	
	BuyResult result = pMarket.Buy( szBuildingName, @pWallet, @pObject );
	
	BaseBuyableBuilding@ pBuilding = cast<BaseBuyableBuilding@>( pObject );
	
	if( result == Buy_Success )
	{
		g_Game.AlertMessage( at_console, "Spawning building\n" );
		
		if( pBuilding !is null )
		{
			//The rotation entity has g_Settings.m_vecRotation applied to it
			if( g_Settings.BuildingRotationEntity.IsValid() )
				pBuilding.Rotation = g_Settings.BuildingRotationEntity.GetEntity().pev.angles;
			else 
				pBuilding.Rotation = g_Settings.Rotation;
		}
		else
		{
			g_Game.AlertMessage( at_console, "Object was not a building!\n" );
			return;
		}
	}
	else
	{
		g_Game.AlertMessage( at_console, "Could not create building\n" );
		
		if( result == Buy_NotEnoughMoney )
		{
			g_Game.AlertMessage( at_console, "Team resource(s) is not enough\n" );
			g_SoundSystem.EmitAmbientSound( g_EngineFuncs.PEntityOfEntIndex( 0 ), g_vecZero, PURCHASE_SOUND_INSUFFICIENT, 1.0, ATTN_NONE, 0, PITCH_NORM );
		}
		
		return;
	}
	
	SpawnWeaponDeployer( g_Settings.CrateSpawnPoint , pObject );
	
	/*
	//This could really use proper template instancing (copy an existing entity as a whole)
		
	CBaseEntity@ pCrate = BrushTemplating::CreateBrushEntityFromTemplate( @g_Settings.BrushTemplates, g_Settings.CrateTemplate, "func_pushable" );
	
	if( pCrate is null )
	{
		g_Game.AlertMessage( at_console, "Unexpected null pointer while creating crate!\n" );
		return;
	}
	
	edict_t@ pEdict = pCrate.edict();
	
	//Update this to use another entity's origin when it's done
	pCrate.SetOrigin( g_Settings.CrateSpawnPoint );
	
	//Spawnflag 8 as defined in the fgd as "Breakable"
	pCrate.pev.spawnflags |= 1 << 7;
	
	g_EntityFuncs.DispatchKeyValue( pEdict, "ondestroyfn", "CNC::SpawnBuilding" );
	
	g_EntityFuncs.DispatchKeyValue( pEdict, "health", "1" );
	g_EntityFuncs.DispatchKeyValue( pEdict, "material", "1" );
	
	//Set the object representing the building as user data
	dictionary@ userdata = pCrate.GetUserData();
	
	userdata.set( g_Settings.BuildingId, @pObject );
	
	g_EntityFuncs.DispatchSpawn( pEdict );
	
	pCrate.pev.angles = pBuilding.Rotation;*/
}

// 
// Spawn weapon_deployentity at crate position
// anggaranothing
// 
void BuildingCrateDestroyed( CBaseEntity@ pEntity )
{
	if( pEntity is null )
		return;
	
	dictionary@ userdata = pEntity.GetUserData();
	
	BaseBuyableObject@ pObject = null;
	
	if( !userdata.get( g_Settings.BuildingId, @pObject ) )
	{
		g_Game.AlertMessage( at_console, "Failed to get building object out of crate\n" );
		return;
	}
		
	SpawnWeaponDeployer( pEntity.pev.origin, pObject );
}

// 
// Spawn weapon_deployentity
// anggaranothing
// 
void SpawnWeaponDeployer( const Vector &in origin, BaseBuyableObject@ pObject )
{
	CBaseEntity@ pWeaponEntity = g_EntityFuncs.Create( GetWeaponDeployEntityName(), origin, g_vecZero, true );
	
	if( pWeaponEntity is null )
	{
		g_Game.AlertMessage( at_console, "Unexpected null pointer while create weapon_deployentity!\n" );
		return;
	}
	
	g_EntityFuncs.DispatchKeyValue( pWeaponEntity.edict(), "spawnflags", "1024" );	// dont respawn!
	//Set the object representing the building as user data
	pWeaponEntity.GetUserData().set( g_Settings.BuildingId, @pObject );
	g_EntityFuncs.DispatchSpawn( pWeaponEntity.edict() );
}

/*
* Spawns a building
* pEntity has user data g_Settings.BuildingId that holds the building handle
*/
void SpawnBuilding( CBaseEntity@ pEntity )
{
	if( pEntity is null )
		return;
	
	dictionary@ userdata = pEntity.GetUserData();
	
	BaseBuyableObject@ pObject = null;
	
	if( !userdata.get( g_Settings.BuildingId, @pObject ) )
	{
		g_Game.AlertMessage( at_console, "Failed to get building object out of crate\n" );
		return;
	}
		
	pObject.Spawn( pEntity.pev.origin );
}

/*
* Increments the angular offset added to the rotation of all spawned buildings.
* Each call increments it by a preset amount.
*/
void AddBuildingRotation( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	Vector vecRotation = g_Settings.Rotation + g_Settings.RotationIncrement;
	
	//Clamp to prevent problems in the engine
	//Could probably be done in a better way
	while( vecRotation.x > 360 )
		vecRotation.x -= 360;
		
	while( vecRotation.x < 0 )
		vecRotation.x += 360;
		
	while( vecRotation.y > 360 )
		vecRotation.y -= 360;
		
	while( vecRotation.y < 0 )
		vecRotation.y += 360;
		
	while( vecRotation.z > 360 )
		vecRotation.z -= 360;
		
	while( vecRotation.z < 0 )
		vecRotation.z += 360;
		
	g_Settings.Rotation = vecRotation;
	
	if( g_Settings.BuildingRotationEntity.IsValid() )
	{
		CBaseEntity@ pEnt = g_Settings.BuildingRotationEntity.GetEntity();
		
		//Set angles on visible rotation entity
		pEnt.pev.angles = g_Settings.Rotation;
	}
}
}