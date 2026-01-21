/*
* Prototype Command & Conquer like game mode
* Resource system
*/
#include "cnc_economy"
#include "cnc_player"

namespace CNC
{
	enum ResourceType
	{
		ResourceType_Invalid = -1,
		ResourceType_Regular = 0,
		ResourceType_Big,
		Count						//Must be last
	}

	string ResourceModelForType( const ResourceType type )
	{
		switch( type )
		{
		case ResourceType_Regular: 	return "models/cnc/tiberiumbig.mdl"; //models/cnc/tiberium.mdl
		case ResourceType_Big: 		return "models/cnc/tiberiumCluster.mdl";
		default: 					return "models/error.mdl";
		}
		
		return "models/error.mdl";
	}

	float Cmoney = 0;

	//array<int> m_Index;

	/*
	* A resource that a player can carry
	*/
	class Resource
	{
		private ResourceType m_Type;
		
		/*
		* The type of the resource.
		*/
		ResourceType Type
		{
			get const { return m_Type; }
		}
		
		Resource( const ResourceType type )
		{
			m_Type = type;
		}
		
		bool HasMoneyLeft() const
		{
			return m_Type != ResourceType_Invalid;
		}
		
		/*
		* Converts this resource to money. The resource loses its value after this.
		*/
		float ConvertToMoney()
		{
			if( !HasMoneyLeft() )
				return 0;
				
			//g_Game.AlertMessage( at_console, "Color money index is->" + m_Color + " this\n" );
			
			//g_Game.AlertMessage( at_console, "Color money is->" + Cmoney + " this\n" );

			g_Game.AlertMessage( at_console, "Resource money is->" + m_Type + " this\n" );		
				
			float flMoney = (Cmoney) * (g_Settings.MoneyForResourceType[ m_Type ]);
			
			m_Type = ResourceType_Invalid;
			
			//Cmoney = 0;
			
			return flMoney;
		}
	}

	/*
	* Contains all of the resources that a player has picked up and has not yet deposited
	*/
	class Resources
	{
		protected Player@ m_pPlayer;
		
		private ResourceCarryRules@ m_pRules;
		
		protected array<Resource@> m_Resources;
		
		//Fenix
		protected array<int> m_Index;
		
		Player@ Player
		{
			get const { return m_pPlayer; }
		}
		
		Resources( Player@ pPlayer )
		{
			@m_pPlayer = pPlayer;
		}
		
		uint GetResourceCount() const
		{
			return m_Resources.length();
		}
		
		bool HasResource( Resource@ pResource ) const
		{
			if( pResource is null )
				return false;
				
			return m_Resources.findByRef( @pResource ) != -1;
		}
		
		bool AddResource( Resource@ pResource )
		{
			if( pResource is null )
			{
				//g_Game.AlertMessage(at_console, "Resources: pResource is null!\n" );
				return false;
			}
				
			//No duplicates
			if( HasResource( pResource ) )
			{
				//g_Game.AlertMessage(at_console, "Resources: pResource already assigned!\n" );
				return false;
			}
				
			Team@ pTeam = Player.Team;
			
			//No team, no carrying
			if( pTeam is null )
			{
				//g_Game.AlertMessage(at_console, "Resources: pTeam is null!\n" );
				return false;
			}
				
			ResourceCarryRules@ pRules = pTeam.CarryRules;
				
			if( GetResourceCount() >= pRules.MaxCarry )
			{
				//g_Game.AlertMessage(at_console, "Resources: Maximum carry is reached!\n" );
				return false;
			}
			
			m_Resources.insertLast( @pResource );
			
			return true;
		}
		
		//Fenix
		bool AddColor( int pColor )
		{
			Team@ pTeam = Player.Team;
			
			//No team, no carrying
			if( pTeam is null )
				return false;
				
			m_Index.insertLast( pColor );
				
			return true;
		}
		
		void RemoveAllResources()
		{
			m_Resources.resize( 0 );
		}
		
		float ConvertAllToMoney()
		{
			float flTotal = 0;
			
			for( uint uiIndex = 0; uiIndex < m_Resources.length(); ++uiIndex )
			{
				Cmoney = ColorMoney(m_Index[uiIndex]);
				flTotal += m_Resources[ uiIndex ].ConvertToMoney();
			}
			
			RemoveAllResources();
			
			m_Index.resize( 0 );
			
			return flTotal;
		}
	}
	
	// For custom Resources object
	class HarvesterResources : Resources
	{
		private CBaseEntity@ m_pEnt;
		private uint m_uiMaxCarry;
		
		Player@ Player
		{
			get const { return m_pPlayer; }
			set
			{
				@m_pPlayer = @value;
				
				//g_Game.AlertMessage(at_console, "netname:: %1 !!\n", m_pPlayer.Player.pev.netname );
			}
		}
		
		uint MaxCarry
		{
			get const { return m_uiMaxCarry; }
			set { m_uiMaxCarry = value; }
		}
		
		CBaseEntity@ Harvester
		{
			get const { return m_pEnt; }
		}
		
		HarvesterResources( CBaseEntity@ pEntity )
		{
			super( null );
			@m_pEnt = @pEntity;
		}
		
		bool AddResource( Resource@ pResource )
		{
			if( pResource is null ) {
				//g_Game.AlertMessage(at_console, "HarvesterResources: pResource is null!\n" );
				return false;
			}
				
			//No duplicates
			if( HasResource( pResource ) ) {
				//g_Game.AlertMessage(at_console, "HarvesterResources: pResource already assigned!\n" );
				return false;
			}
				
			if( GetResourceCount() >= m_uiMaxCarry ) {
				//g_Game.AlertMessage(at_console, "HarvesterResources: Maximum carry is reached!\n" );
				return false;
			}
				
			m_Resources.insertLast( @pResource );
			
			return true;
		}
		
		//Fenix
		bool AddColor( int pColor )
		{		
			m_Index.insertLast( pColor );
				
			return true;
		}
	}

	class cnc_resource : ScriptBaseItemEntity
	{
		ResourceType m_Type = ResourceType_Regular;
		
		int m_Color = 0;
		
		bool KeyValue( const string& in szKey, const string& in szValue )
		{
			if( szKey == "resourcetype" )
			{
				m_Type = ResourceType( atoi( szValue ) );
				//g_Game.AlertMessage( at_console, "Size is->" + m_Type + " this\n" );
			
				return true;
			}
			else if( szKey == "crystalcolor" )
			{
				m_Color = atoi( szValue );
				//g_Game.AlertMessage( at_console, "Color is->" + m_Color + " this\n" );
				return true;
			}
			else
				return BaseClass.KeyValue( szKey, szValue );
		}
		
		void Precache()
		{
			BaseClass.Precache();
			
			g_Game.PrecacheModel( ResourceModelForType( m_Type ) );
		}
		
		void Spawn()
		{
			self.Precache();
			
			self.pev.skin = m_Color;
			
			//Random angles
			self.pev.angles = Vector( 0, Math.RandomLong( 0, 360 ), 0 );
			
			BaseClass.Spawn();
			
			if( self !is null )
			{
				SetTouch( TouchFunction( this.MyItemTouch ) );
				
				//Get the defined size and color type
				g_EntityFuncs.SetModel( self, ResourceModelForType( m_Type ) );
				g_EntityFuncs.SetSize( self.pev, Vector( -16, -16, 0 ), Vector( 16, 16, 36 ) );
				
				//Make them float instead of sink into the infested soil
				SetMovetypeState( false );
				self.pev.solid		= SOLID_TRIGGER;
				
				//self.pev.groupinfo  = 1073741824;
			}
		}
		
		CBaseEntity@ Respawn( void )
		{
			CBaseEntity@ temp = self.Respawn();
			
			SetThink( ThinkFunction( this.MyMaterialize ) );
			
			return @temp;
		}

		// anggaranothing
		void MyMaterialize()
		{
			self.Materialize();
			
			SetTouch( TouchFunction( this.MyItemTouch ) );
			
			//SetMovetypeState( true );
		}
		
		// This is for player entity
		bool MyTouch( CBasePlayer@ pPlayerEnt )
		{	
			Player@ pPlayer = PlayerFromPlayerEntity( pPlayerEnt );
			
			if( pPlayer.Resources.AddResource( @Resource( m_Type ) ) )
			{
				//Cmoney = ColorMoney(m_Color);
				//m_Index.insertLast( m_Color );
				pPlayer.Resources.AddColor( m_Color );
				g_SoundSystem.EmitSound( pPlayerEnt.edict(), CHAN_STATIC, TIBERIUM_SOUND_PICKUP, 1.0f, ATTN_NORM ); 
				return true;
			}
			
			//Player has max, let other players pick it up
			return false;
		}
		
		// anggaranothing
		// This is for non-player entities
		void MyItemTouch(CBaseEntity@ pOther)
		{
			if( pOther.IsPlayer() == false )
			{
				//g_Game.AlertMessage(at_console, "Touch (%1)\n", pOther.pev.classname );
				
				Resources@ pResources = @ResourcesFromBaseEntity( @pOther );
				
				if( pResources !is null && pResources.AddResource( @Resource( m_Type ) ) )
				{
					g_Game.AlertMessage(at_console, "cnc_resource: Harvested by %1\n", pOther.pev.classname );
					
					//SetMovetypeState( false );
					
					self.SUB_UseTargets( @pOther, USE_TOGGLE, 0 );
					SetTouch( null );
					
					//Cmoney = ColorMoney(m_Color);
					//m_Index.insertLast( m_Color );
					pResources.AddColor( m_Color );
					g_SoundSystem.EmitSound( pOther.edict(), CHAN_ITEM, TIBERIUM_SOUND_PICKUP, 1.0f, ATTN_NORM ); 
					
					if( self.pev.SpawnFlagBitSet( SF_NORESPAWN ) == false )
					{
						Respawn();
					}
					else
					{
						g_EntityFuncs.Remove( self );
					}
					
					return;
				}
			}
			
			self.ItemTouch( @pOther );
		}
		
		void SetMovetypeState( bool isSolid = true )
		{
			self.pev.movetype	= ( isSolid ? MOVETYPE_FLY : MOVETYPE_NONE );
		}
	}

	string GetCNCResourceItemName()
	{
		return "cnc_resource";
	}

	void RegisterResourceEntity()
	{
		g_CustomEntityFuncs.RegisterCustomEntity( "CNC::cnc_resource", GetCNCResourceItemName() );
	}

	/*
	* Adds the resources carried by the activator (a player) to the player's team
	*/
	void AddResourcesToTeam( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if( pActivator is null || pCaller is null /*|| pActivator.IsPlayer() == false*/ )
			return;
			
		//If the caller has a team set, only players with a matching team can use this trigger
		Team@ pCallerTeam = null;
			
		{
			dictionary@ pUserData = pCaller.GetUserData();
			pUserData.get( g_Settings.TeamId, @pCallerTeam );
		}
		
		Player@ pPlayer;
		Resources@ pResources;
		
		if( pActivator.IsPlayer() == true ) {
			CBasePlayer@ pPlayerEnt = cast<CBasePlayer@>( pActivator );
			
			@pPlayer = @PlayerFromPlayerEntity( pPlayerEnt );
			
			@pResources = @pPlayer.Resources;
		}
		else
		{
			//g_Game.AlertMessage(at_console, "(%1) (%2)\n", pActivator.pev.classname, pCaller.pev.classname );
			
			@pResources = @ResourcesFromBaseEntity( @pActivator );
			
			if( pResources is null ) {
				g_Game.AlertMessage(at_console, "pResources is null !!!\n" );
				return;
			}
			
			@pPlayer    = @pResources.Player;
		}
		
		if( pPlayer is null ) {
			g_Game.AlertMessage(at_console, "pPlayer is null !!!\n" );
			return;
		}
		
		Team@ pTeam = pPlayer.Team;
			
		//Team specific trigger; disallow
		if( pCallerTeam !is null && pCallerTeam !is pTeam )
			return;
		
		Wallet@ pWallet = pTeam.Wallet;
		
		const float flMoney = pResources.ConvertAllToMoney();
		
		pWallet.AddMoney( flMoney );
		
		if( flMoney > 0 )
			g_SoundSystem.EmitSound( pActivator.edict(), CHAN_STATIC, TIBERIUM_SOUND_DROPOFF, 1.0f, ATTN_NORM ); 
	}

	bool UpgradeMaxCarryAllTeamsFn( Team@ pTeam )
	{
		pTeam.CarryRules.UpgradeMaxCarry();
		
		return true;
	}

	/*
	* Upgrades max carry for either all teams, or the team associated with the caller
	*/
	void UpgradeMaxCarry( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if( pCaller is null )
			return;
			
		Team@ pCallerTeam = null;
			
		{
			dictionary@ pUserData = pCaller.GetUserData();
			pUserData.get( g_Settings.TeamId, @pCallerTeam );
		}
		
		if( pCallerTeam is null )
		{
			g_Settings.Teams.ForEachTeam( @UpgradeMaxCarryAllTeamsFn );
		}
		else
			UpgradeMaxCarryAllTeamsFn( pCallerTeam );
	}

	float ColorMoney(int money)
	{
		Cmoney = g_Settings.MoneyForCrystalType[ money ];
		
		g_Game.AlertMessage( at_console, "Color money is->" + Cmoney + " this\n" );
		
		return Cmoney;
	}
	
	// anggaranothing
	Resources@ ResourcesFromBaseEntity( CBaseEntity@ pEnt )
	{
		if( pEnt is null )
			return null;
			
		dictionary@ pUserData = pEnt.GetUserData();
		
		Resources@ pResources = null;
		
		if( pUserData.get( "CNC_HARVESTER", @pResources ) )
			return @pResources;
		
		return null;
	}

	// anggaranothing
	void SetResourcesOnBaseEntity( CBaseEntity@ pEnt, Resources@ pResources )
	{
		if( pEnt is null )
			return;
			
		dictionary@ pUserData = pEnt.GetUserData();
		
		pUserData.set( "CNC_HARVESTER", @pResources );
	}
}