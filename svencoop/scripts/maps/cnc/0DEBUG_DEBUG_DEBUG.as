/*
*	CNC DEBUG TOOLS
*	anggaranothing
*/

//#include "../point_checkpoint"

const bool CNC_DEBUG_MODE = false;

namespace CNC
{

	/*
	*	cnc_gotocrate
	*	Move player to crate spawn point.
	*/
	CClientCommand CC_GoToCrate( "cnc_gotocrate",  "", DEBUG_GoToCrate );
	void DEBUG_GoToCrate( const CCommand@ perintah )
	{
		if( CNC_DEBUG_MODE )
			return;
		
		CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();
		// Not alive?
		if( !pPlayer.IsAlive() )
			return;
		
		g_EntityFuncs.SetOrigin( pPlayer , g_Settings.CrateSpawnPoint );
	}

	/*
	*	cnc_spawncrate
	*	Spawn a build crate at crate spawnpoint
	*/
	CClientCommand CC_SpawnCrate( "cnc_spawncrate",  "Arguments : <building_name>", DEBUG_SpawnCrate );
	void DEBUG_SpawnCrate( const CCommand@ perintah )
	{
		if( CNC_DEBUG_MODE )
			return;
		
		CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();
		// Not alive?
		if( !pPlayer.IsAlive() )
			return;
		
		if( g_Settings.TeamDataAccessor is null )
		{
			g_Game.AlertMessage( at_console, "Team data accessor is null!\n" );
			return;
		}
		
		/*
		*	Arguments : building_name
		*/
		string szBuildingName =  perintah.Arg( 1 );
			
		Market@ pMarket = g_Settings.TeamDataAccessor.GetMarket( pPlayer );
		
		Wallet@ pWallet = g_Settings.TeamDataAccessor.GetWallet( pPlayer );
		
		SpawnBuildingCrate( pMarket, pWallet, szBuildingName );
	}
	
	/*
	*	cnc_givemoney
	*	Gives you amount of money
	*/
	CClientCommand CC_GiveMoney( "cnc_givemoney",  "Arguments : <amount>", DEBUG_GiveMoney );
	void DEBUG_GiveMoney( const CCommand@ perintah )
	{
		if( CNC_DEBUG_MODE )
			return;
		
		CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();
		// Not alive?
		if( !pPlayer.IsAlive() )
			return;
		
		if( g_Settings.TeamDataAccessor is null )
		{
			g_Game.AlertMessage( at_console, "Team data accessor is null!\n" );
			return;
		}
		
		/*
		*	Arguments : amount
		*/
		float fAmount =  atof( perintah.Arg( 1 ) );
		
		Wallet@ pWallet = g_Settings.TeamDataAccessor.GetWallet( pPlayer );
		
		pWallet.AddMoney( fAmount );
	}
	
	/*
	*	cnc_spawnharvester
	*	Spawn a harvester at player aim origin
	*/
	CClientCommand CC_SpawnHarvester( "cnc_spawnharvester",  "Arguments : <model> <isCenter>", DEBUG_SpawnHarvester );
	void DEBUG_SpawnHarvester( const CCommand@ perintah )
	{
		if( CNC_DEBUG_MODE )
			return;
		
		CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();
		// Not alive?
		if( !pPlayer.IsAlive() )
			return;
		
		/*
		*	Arguments : <model> <isCenter>
		*/
		string szModel =  perintah.Arg( 1 );
		int    iCenter =  atoi( perintah.Arg( 2 ) );
		
		Vector origin = pPlayer.pev.origin;
		
		if( iCenter < 1 )
		{
			TraceResult tr;
			Vector trStart = pPlayer.GetGunPosition();
			Math.MakeVectors( pPlayer.pev.v_angle );
			g_Utility.TraceLine( trStart, trStart + g_Engine.v_forward * 8192, dont_ignore_monsters, pPlayer.edict(), tr );
			origin = tr.vecEndPos;
		}
		
		// Add a few Z-axis value for stuck prevention
		//origin.z += 30.0;
		
		// Create unit but dont spawn
		CBaseEntity@ pEntity = g_EntityFuncs.Create( "func_vehicle_harvester", origin, g_vecZero, true );
		
		// Set model
		if( szModel != "" && szModel != "0" )
			g_EntityFuncs.SetModel( pEntity, szModel );
		
		//g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "model_center",	"12 1 16" );
		g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "length",			"0" );
		g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "width",			"0" );
		g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "height",			"0" );
		g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "startspeed",		"0" );
		g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "speed",			"256" );
		g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "acceleration",	"15" );
		g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "dmg",				"0" );
		g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "volume",			"3" );
		g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "bank",			"0" );
		g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "sounds",			"1" );
		g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "maxcarry",		"4" );
		g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "targetname",		"the_sampah" );
	
		// Spawn now
		g_EntityFuncs.DispatchSpawn( pEntity.edict() );
		
		// Drop to floor
		//g_EngineFuncs.DropToFloor( pEntity.edict() );
	}
	
	/*
	*	cnc_spawntiberium
	*	Spawn a tiberium crystal at player aim origin
	*/
	CClientCommand CC_SpawnTiberium( "cnc_spawntiberium",  "Arguments : <type> <isCenter>", DEBUG_SpawnTiberium );
	void DEBUG_SpawnTiberium( const CCommand@ perintah )
	{
		if( CNC_DEBUG_MODE )
			return;
		
		CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();
		// Not alive?
		if( !pPlayer.IsAlive() )
			return;
		
		/*
		*	Arguments : <type>
		*/
		string szType  =  perintah.Arg( 1 );
		int    iCenter =  atoi( perintah.Arg( 2 ) );
		
		Vector origin = pPlayer.pev.origin;
		
		if( iCenter < 1 )
		{
			TraceResult tr;
			Vector trStart = pPlayer.GetGunPosition();
			Math.MakeVectors( pPlayer.pev.v_angle );
			g_Utility.TraceLine( trStart, trStart + g_Engine.v_forward * 8192, dont_ignore_monsters, pPlayer.edict(), tr );
			origin = tr.vecEndPos;
		}
		
		// Add a few Z-axis value for stuck prevention
		//origin.z += 30.0;
		
		// Create unit but dont spawn
		CBaseEntity@ pEntity = g_EntityFuncs.Create( "cnc_resource", origin, g_vecZero, true );
		
		//g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "model_center",	"12 1 16" );
		g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "resourcetype",	szType );
	
		// Spawn now
		g_EntityFuncs.DispatchSpawn( pEntity.edict() );
		
		// Drop to floor
		//g_EngineFuncs.DropToFloor( pEntity.edict() );
	}
	
	void DEBUG_MapInit()
	{
		/*g_Game.PrecacheModel( "models/common/lambda.mdl" );
		g_Game.PrecacheModel( "sprites/exit1.spr" );
		g_SoundSystem.PrecacheSound( "../media/valve.mp3" );
		g_SoundSystem.PrecacheSound( "debris/beamstart7.wav" );
		g_SoundSystem.PrecacheSound( "ambience/port_suckout1.wav" );
		
		RegisterPointCheckPointEntity();*/
	}
}
