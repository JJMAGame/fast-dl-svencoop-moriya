//========= Created by Rafael "Maestro Fénix" Bravo ============//
//
// Purpose: Implements an entity that adds or substracts
//			money.
//
//==============================================================//
#include "cnc_economy"
#include "cnc_teams"

class trigger_money : ScriptBaseEntity
{
	float m_cost = 0;

	bool KeyValue( const string& in szKey, const string& in szValue )
	{
		if( szKey == "m_cost" )
		{
			m_cost = atoi( szValue );
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
		g_Game.AlertMessage( at_console, "Money is "+ m_cost +"\n" );
		pWallet.AddMoney( m_cost );
	}
}