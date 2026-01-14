/*
*	This file defines the interface to the bot manager
*	This is a sample script.
*/

namespace BotManager
{
/*
*	Base class for bots.
*/
abstract class BaseBot
{
	private CBasePlayer@ m_pPlayer;

	private int m_iMSecInterval = 0;
	private float m_flLastRunMove = 0;

	protected Vector m_vecVelocity;

	CBasePlayer@ Player
	{
		get const { return m_pPlayer; }
	}

	BaseBot( CBasePlayer@ pPlayer )
	{
		@m_pPlayer = pPlayer;
	}

	void Spawn()
	{
		m_pPlayer.pev.fixangle = FAM_FORCEVIEWANGLES;
	}

	void Think()
	{
	}

	private void UpdateMSec() final
	{
		m_iMSecInterval = int( ( g_Engine.time - m_flLastRunMove ) * 1000 );

		if( m_iMSecInterval > 255 )
			m_iMSecInterval = 0;
	}

	void RunPlayerMove() final
	{
		UpdateMSec();

		m_flLastRunMove = g_Engine.time;

		g_EngineFuncs.RunPlayerMove( m_pPlayer.edict(), m_pPlayer.pev.angles,
			m_vecVelocity.x, m_vecVelocity.y, m_vecVelocity.z,
			m_pPlayer.pev.button, m_pPlayer.pev.impulse, uint8( m_iMSecInterval ) );
	}
}

funcdef BaseBot@ CreateBotFn( CBasePlayer@ pPlayer );

/*
*	Bot manager class.
*/
final class BotManager
{
	private array<BaseBot@> m_Bots;

	private CScheduledFunction@ m_pScheduledFunction;

	private CreateBotFn@ m_pCreateBotFn;

	private bool m_bInitialized = false;

	BotManager( CreateBotFn@ pCreateBotFn )
	{
		@m_pCreateBotFn = pCreateBotFn !is null ? pCreateBotFn : @CreateDefaultBot;
	}

	~BotManager()
	{
		if( m_bInitialized )
		{
			g_Hooks.RemoveHook( Hooks::Game::MapChange, MapChangeHook( this.MapChange ) );
			g_Hooks.RemoveHook( Hooks::Player::ClientDisconnect, ClientDisconnectHook( this.ClientDisconnect ) );
		}
	}

	private BaseBot@ CreateBot( CBasePlayer@ pPlayer ) const
	{
		return m_pCreateBotFn( pPlayer );
	}

	void PluginInit()
	{
		if( m_bInitialized )
			return;

		m_bInitialized = true;

		g_Hooks.RegisterHook( Hooks::Game::MapChange, MapChangeHook( this.MapChange ) );
		g_Hooks.RegisterHook( Hooks::Player::ClientDisconnect, ClientDisconnectHook( this.ClientDisconnect ) );

		@m_pScheduledFunction = g_Scheduler.SetInterval( @this, "Think", 0.1 );

		//If the plugin was reloaded, find all bots and add them again.
		for( int iPlayer = 1; iPlayer <= g_Engine.maxClients; ++iPlayer )
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iPlayer );

			if( pPlayer is null )
				continue;

			if( ( pPlayer.pev.flags & FL_FAKECLIENT ) == 0 )
				continue;

			g_Game.AlertMessage( at_console, "BotManager: Found bot %1\n", pPlayer.pev.netname );

			m_Bots.insertLast( @CreateBot( @pPlayer ) );
		}
	}

	HookReturnCode PlayerSpawn( CBasePlayer@ pPlayer )
	{
		//Note: this will be called when a bot gets created. The Bot instance for it is created afterwards, so Spawn gets called in CreateBot instead.
		BaseBot@ pBot = FindBot( pPlayer );

		if( pBot !is null )
			pBot.Spawn();

		return HOOK_CONTINUE;
	}

	HookReturnCode ClientDisconnect( CBasePlayer@ pPlayer )
	{
		if( ( pPlayer.pev.flags & FL_FAKECLIENT ) != 0 )
			RemoveBot( pPlayer, false );

		return HOOK_CONTINUE;
	}

	HookReturnCode MapChange( const string& in szNewLevel )
	{
		m_Bots.resize( 0 );

		return HOOK_CONTINUE;
	}

	uint GetBotCount() const
	{
		return m_Bots.length();
	}

	BaseBot@ GetBot( const uint uiIndex ) const
	{
		if( uiIndex >= m_Bots.length() )
			return null;

		return m_Bots[ uiIndex ];
	}

	BaseBot@ FindBot( CBasePlayer@ pPlayer ) const
	{
		if( pPlayer is null )
			return null;

		for( uint uiIndex = 0; uiIndex < m_Bots.length(); ++uiIndex )
		{
			BaseBot@ pBot = m_Bots[ uiIndex ];

			if( pBot !is null && pPlayer is pBot.Player )
			{
				return pBot;
			}
		}

		return null;
	}

	BaseBot@ CreateBot( const string& in szName )
	{
		CBasePlayer@ pPlayer = g_PlayerFuncs.CreateBot( szName );

		if( pPlayer is null )
			return null;

		BaseBot@ pBot = CreateBot( pPlayer );

		m_Bots.insertLast( pBot );

		pBot.Spawn();

		return pBot;
	}

	void RemoveBot( BaseBot@ pBot, const bool bDisconnect )
	{
		if( pBot is null )
			return;

		int iIndex = m_Bots.findByRef( @pBot );

		if( iIndex != -1 )
		{
			m_Bots.removeAt( uint( iIndex ) );

			if( bDisconnect )
				g_PlayerFuncs.BotDisconnect( pBot.Player );
		}
	}

	void RemoveBot( CBasePlayer@ pPlayer, const bool bDisconnect )
	{
		if( pPlayer is null )
			return;

		BaseBot@ pBot = FindBot( pPlayer );

		if( pBot !is null && pPlayer is pBot.Player )
		{
			RemoveBot( pBot, bDisconnect );
		}
	}

	void Think()
	{
		for( uint uiIndex = 0; uiIndex < m_Bots.length(); ++uiIndex )
		{
			BaseBot@ pBot = m_Bots[ uiIndex ];

			pBot.Think();
			pBot.RunPlayerMove();
		}
	}
}

/*
*	Default bot. Will stand in place and do nothing.
*/
final class DefaultBot : BaseBot
{
	DefaultBot( CBasePlayer@ pPlayer )
	{
		super( pPlayer );
	}
}

BaseBot@ CreateDefaultBot( CBasePlayer@ pPlayer )
{
	return @DefaultBot( pPlayer );
}
}