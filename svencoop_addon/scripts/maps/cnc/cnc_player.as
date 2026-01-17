/*
* Prototype Command & Conquer like game mode
* Players
*/
#include "cnc_constants"
#include "cnc_objects"
#include "cnc_economy"
#include "cnc_teams"
#include "cnc_resources"

namespace CNC
{
funcdef void UpdatePlayerHUDInfo( Player@ pPlayer );

final class Player
{
	private CBasePlayer@ m_pPlayer;
	
	private Resources@ m_pResources;
	
	private Team@ m_pTeam;
	
	private UpdatePlayerHUDInfo@ m_pUpdateFn = null;
	
	/*
	* The owning player
	*/
	CBasePlayer@ Player
	{
		get const { return m_pPlayer; }
	}
	
	/*
	* The resources that this player has
	*/
	Resources@ Resources
	{
		get const { return @m_pResources; }
	}
	
	/*
	* The team that this player is in.
	*/
	Team@ Team
	{
		get const { return m_pTeam; }
		
		set
		{
			@m_pTeam = value;
		}
	}
	
	/*
	* If set, this function will be used to update the player's HUD instead of using the default
	*/
	UpdatePlayerHUDInfo@ UpdateFn
	{
		get const { return m_pUpdateFn; }
		
		set
		{
			@m_pUpdateFn = value;
		}
	}
	
	Player( CBasePlayer@ pPlayer, Team@ pTeam )
	{
		@m_pPlayer = pPlayer;
		@m_pResources = CNC::Resources( @this );
		@Team = pTeam;
	}
	
	void UpdateHUDInfo()
	{
		if( m_pUpdateFn !is null )
		{
			m_pUpdateFn( @this );
		}
		else
		{
			string szMessage = "Credits: " + Team.Wallet.Money + "\nCarried Resources: " + Resources.GetResourceCount() + "/" + Team.CarryRules.MaxCarry + "\n";
	
			g_PlayerFuncs.HudMessage( Player, Team.HUDParams, szMessage );
		}
	}
}

Player@ PlayerFromPlayerEntity( CBasePlayer@ pPlayerEnt )
{
	if( pPlayerEnt is null )
		return null;
		
	dictionary@ pUserData = pPlayerEnt.GetUserData();
	
	Player@ pPlayer = null;
	
	if( pUserData.get( g_Settings.PlayerId, @pPlayer ) )
		return pPlayer;
	
	return null;
}

void SetPlayerOnPlayerEntity( CBasePlayer@ pPlayerEnt, Player@ pPlayer )
{
	if( pPlayerEnt is null )
		return;
		
	dictionary@ pUserData = pPlayerEnt.GetUserData();
	
	pUserData.set( g_Settings.PlayerId, @pPlayer );
}

void UpdateHUDInfoForPlayer( CBasePlayer@ pPlayerEnt )
{
	if( pPlayerEnt is null )
		return;
		
	Player@ pPlayer = PlayerFromPlayerEntity( pPlayerEnt );
	
	pPlayer.UpdateHUDInfo();
}

void UpdateHUDInfoForPlayers()
{
	for( int iIndex = 1; iIndex <= g_Engine.maxClients; ++iIndex )
	{
		CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iIndex );
		
		if( pPlayer !is null )
			UpdateHUDInfoForPlayer( pPlayer );
	}
}
}