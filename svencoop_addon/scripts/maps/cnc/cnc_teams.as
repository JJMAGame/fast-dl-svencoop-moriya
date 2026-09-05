/*
* Prototype Command & Conquer like game mode
* Team support
*/
#include "cnc_economy"
#include "cnc_player"
#include "cnc_resources"

namespace CNC
{
/*
* Represents a team
*/
class Team
{
	private ResourceCarryRules@ m_pCarryRules;
	
	private Market@ m_pMarket;
	
	private Wallet@ m_pWallet;
	
	protected HUDTextParams m_Params;
	
	ResourceCarryRules@ CarryRules
	{
		get const { return m_pCarryRules; }
	}
	
	Market@ Market
	{
		get const { return m_pMarket; }
	}
	
	Wallet@ Wallet
	{
		get const { return m_pWallet; }
	}
	
	HUDTextParams HUDParams
	{
		get const { return m_Params; }
	}
	
	Team( ResourceCarryRules@ pCarryRules, Market@ pMarket, Wallet@ pWallet )
	{
		@m_pCarryRules = pCarryRules;
		@m_pMarket = pMarket;
		@m_pWallet = pWallet;
		
		//Default HUD parameters
		//Subclasses can change this
		m_Params.x = 0.1;
		m_Params.y = 0.4;
		m_Params.r1 = m_Params.g1 = m_Params.b1 = 255;
		m_Params.r2 = m_Params.g2 = m_Params.b2 = 255;
		
		m_Params.a1 = m_Params.a2 = 255;
		
		m_Params.fadeinTime = 0;
		m_Params.fadeoutTime = 0;
		m_Params.holdTime = 2;
		m_Params.channel = 4;
		
		g_Settings.Teams.AddTeam( @this );
	}
	
	~Team()
	{
		g_Settings.Teams.RemoveTeam( @this );
	}
}

funcdef bool ForEachTeamFn( Team@ pTeam );

/*
* Manages all of the teams.
* Teams add themselves automatically.
*/
final class Teams
{
	private array<Team@> m_Teams;
	
	Teams()
	{
	}
	
	uint GetTeamCount() const
	{
		return m_Teams.length();
	}
	
	bool HasTeam( Team@ pTeam ) const
	{
		if( pTeam is null )
			return false;
			
		return m_Teams.findByRef( @pTeam ) != -1;
	}
	
	bool AddTeam( Team@ pTeam )
	{
		if( pTeam is null )
			return false;
			
		if( HasTeam( @pTeam ) )
			return false;
			
		m_Teams.insertLast( @pTeam );
		
		return true;
	}
	
	void RemoveTeam( Team@ pTeam )
	{
		if( pTeam is null )
			return;
			
		const int iIndex = m_Teams.findByRef( @pTeam );
		
		if( iIndex == -1 )
			return;
			
		m_Teams.removeAt( iIndex );
	}
	
	void RemoveAllTeams()
	{
		m_Teams.resize( 0 );
	}
	
	/*
	* Operate on each team in the list.
	* Return false in the callback to stop the loop.
	*/
	void ForEachTeam( ForEachTeamFn@ fn )
	{
		if( fn is null )
			return;
			
		for( uint uiIndex = 0; uiIndex < m_Teams.length(); ++uiIndex )
		{
			if( !fn( m_Teams[ uiIndex ] ) )
				break;
		}
	}
}

/*
* This lets a script define how access to the market and wallet are done.
* The game mode will ask for the market and wallet when it has to buy something, 
* so this lets you decide whether to use a global market and/or wallet, or to extract them from the buying entity (func_button in most cases)
*/
interface TeamDataAccessor
{
	Market@ GetMarket( CBaseEntity@ pEntity ) const;
	
	Wallet@ GetWallet( CBaseEntity@ pEntity ) const;
}

/*
* Global accessor.
*/
final class GlobalTeamDataAccessor : TeamDataAccessor
{
	private Team@ m_pTeam;
	
	GlobalTeamDataAccessor( Team@ pTeam )
	{
		@m_pTeam = pTeam;
	}
	
	Market@ GetMarket( CBaseEntity@ pEntity ) const
	{
		return m_pTeam.Market;
	}
	
	Wallet@ GetWallet( CBaseEntity@ pEntity ) const
	{
		return m_pTeam.Wallet;
	}
}

/*
* Entity user data accessor.
*/
final class EntityUserDataTeamDataAccessor : TeamDataAccessor
{
	Market@ GetMarket( CBaseEntity@ pEntity ) const
	{
		dictionary@ pUserData = pEntity.GetUserData();
		
		Team@ pTeam = null;
		
		if( pUserData.get( g_Settings.TeamId, @pTeam ) )
			return pTeam.Market;
		else
			return null;
	}
	
	Wallet@ GetWallet( CBaseEntity@ pEntity ) const
	{
		dictionary@ pUserData = pEntity.GetUserData();
		
		Team@ pTeam = null;
		
		if( pUserData.get( g_Settings.TeamId, @pTeam ) )
			return pTeam.Wallet;
		else
			return null;
	}
}

/*
* Used to set team data on an entity
*/
void SetTeamDataOnEntity( CBaseEntity@ pEntity, Team@ pTeam )
{
	if( pEntity is null )
	{
		g_Game.AlertMessage( at_console, "SetTeamDataOnEntity: null entity!" );
		return;
	}
	
	dictionary@ pUserData = pEntity.GetUserData();
	
	pUserData.set( g_Settings.TeamId, @pTeam );
}

/*
* Sets team data on a set of entities.
* If fDuplicates is true, all entities by the given names are set, not just the first found entity.
*/
void SetTeamDataOnEntities( array<string>@ entityNames, Team@ pTeam, const bool fDuplicates = false )
{
	if( entityNames is null )
		return;
		
	for( uint uiIndex = 0; uiIndex < entityNames.length(); ++uiIndex )
	{
		const string szEntityName = entityNames[ uiIndex ];
		
		CBaseEntity@ pEntity = g_EntityFuncs.FindEntityByTargetname( null, szEntityName );
		
		if( pEntity is null )
			continue;
			
		SetTeamDataOnEntity( pEntity, pTeam );
		
		if( fDuplicates )
		{
			while( ( @pEntity = g_EntityFuncs.FindEntityByTargetname( pEntity, szEntityName ) ) !is null )
			{
				SetTeamDataOnEntity( pEntity, pTeam );
			}
		}
	}
}

void SetPlayerTeam( CBasePlayer@ pPlayerEnt, Team@ pTeam )
{
	if( pPlayerEnt is null )
		return;
		
	Player@ pPlayer = PlayerFromPlayerEntity( pPlayerEnt );
	
	@pPlayer.Team = pTeam;
}
}