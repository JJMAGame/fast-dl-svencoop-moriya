//========= Created by Rafael "Maestro Fénix" Bravo ============//
//
// Purpose: Implements an entity that reads prices and makes
//			purchases as well firing a target on sucess.
//
//==============================================================//
#include "cnc_economy"
#include "cnc_teams"

class trigger_purchase : ScriptBaseEntity
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
			g_Game.AlertMessage( at_console, "Upgrade purchased\n" );
			
			g_EntityFuncs.FireTargets( szTargetEntity, @self, @self, USE_SET, flValue );
		}
		else
		{
			g_Game.AlertMessage( at_console, "Could not purchase upgrade\n" );
			return;
		}
	}
}