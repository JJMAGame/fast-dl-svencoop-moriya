//========= Created by Rafael "Maestro Fénix" Bravo ============//
//
// Purpose: Implements an entity that reads prices and makes
//			purchases as well as create a monster on sucess.
//
//==============================================================//
#include "cnc_economy"
#include "cnc_teams"
#include "cnc_settings"

class trigger_purchase_monster : ScriptBaseEntity
{
	int m_cost = 0;
	string szTargetEntity = "";

	bool KeyValue( const string& in szKey, const string& in szValue )
	{
		if( szKey == "m_cost" )
		{
			m_cost = atoi( szValue );
			return true;
		}
		else if( szKey == "szTargetEntity" )
		{
			szTargetEntity = szValue;
			return true;
		}
		else
			return BaseClass.KeyValue( szKey, szValue );
	}
	
	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue = 0.0f )
	{
		if( CNC::g_Settings.TeamDataAccessor is null )
		{
			g_Game.AlertMessage( at_console, "Team data accessor is null!\n" );
			return;
		}
		
		CNC::Market@ pMarket = CNC::g_Settings.TeamDataAccessor.GetMarket( pCaller );
		
		CNC::Wallet@ pWallet = CNC::g_Settings.TeamDataAccessor.GetWallet( pCaller );

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
		
		CNC::BuyResult result = pMarket.BuyUp( @pWallet, m_cost );
		
		if( result == CNC::Buy_Success )
		{
			g_Game.AlertMessage( at_console, "Unit purchased\n" );
			
			//g_EntityFuncs.FireTargets( szTargetEntity, @self, @self, USE_SET, flValue );
			CreateMonster();
			
		}
		else
		{
			g_Game.AlertMessage( at_console, "Could not purchase Unit\n" );
			return;
		}
	}
	
	void CreateMonster( void )
	{
		CBaseEntity@ pCrate = BrushTemplating::CreateBrushEntityFromTemplate( @CNC::g_Settings.BrushTemplates, CNC::g_Settings.CrateTemplate, "func_pushable" );
	
		if( pCrate is null )
		{
			g_Game.AlertMessage( at_console, "Unexpected null pointer while creating crate!\n" );
			return;
		}
		
		edict_t@ pEdict = pCrate.edict();
		
		//Set target to recover later the npc name and spawn it
		pCrate.pev.target =	szTargetEntity;
		
		//Update this to use another entity's origin when it's done
		pCrate.SetOrigin( CNC::g_Settings.CrateSpawnPoint );
		
		//Spawnflag 8 as defined in the fgd as "Breakable"
		pCrate.pev.spawnflags |= 1 << 7;
		
		//Calls the function at cnc_impl.as on death
		g_EntityFuncs.DispatchKeyValue( pEdict, "ondestroyfn", "spawnmonster" );
		
		//pCrate.pev.targetname = "cratebreakthis";
		
		g_EntityFuncs.DispatchKeyValue( pEdict, "health", "1" );
		g_EntityFuncs.DispatchKeyValue( pEdict, "material", "2" );
			
		g_EntityFuncs.DispatchSpawn( pEdict );
		
		//Set the rotation from the rotation arrow
		if( CNC::g_Settings.BuildingRotationEntity.IsValid() )
				pCrate.pev.angles = CNC::g_Settings.BuildingRotationEntity.GetEntity().pev.angles;
			else 
				pCrate.pev.angles = CNC::g_Settings.Rotation;
		
	}
}