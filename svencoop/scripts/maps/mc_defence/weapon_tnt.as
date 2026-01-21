const int DAMAGE_TNT			= 50;
const int TNT_DEFAULT_GIVE	= 3;
const int TNT_WEIGHT			= 5;
const int TNT_MAX_CARRY		= 3;

enum TNTAnimation 
{
	TNT_IDLE = 0,
	TNT_IDLE2,
	TNT_PULLPIN,
	TNT_THROW1,
	TNT_THROW2,
	TNT_THROW3,
	TNT_DEPLOY,
	TNT_HOLSTER
};

class weapon_tnt : ScriptBasePlayerWeaponEntity
{
	private CBasePlayer@ m_pPlayer = null;
	float m_flStartThrow;
	float m_flReleaseThrow;
	float time;
	CBaseEntity@ pGrenade;

	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/mc_defence/w_tnt.mdl" );
		self.pev.dmg = DAMAGE_TNT;
		self.m_iDefaultAmmo = TNT_DEFAULT_GIVE;

		self.KeyValue( "m_flCustomRespawnTime", 1 ); //fgsfds

		m_flReleaseThrow = -1.0f;
		time = 0;
		m_flStartThrow = 0;
		
		self.FallInit();
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		g_Game.PrecacheModel( "models/mc_defence/w_tnt.mdl" );
		g_Game.PrecacheModel( "models/mc_defence/v_tnt.mdl" );
		g_Game.PrecacheModel( "models/mc_defence/p_tnt.mdl" );

		g_Game.PrecacheGeneric( "sound/" + "mc_defence/fuse.ogg" );

		g_SoundSystem.PrecacheSound( "mc_defence/fuse.ogg" );

		g_Game.PrecacheGeneric( "sprites/" + "mc_defence/weapon_tnt.txt" );
	}

	bool AddToPlayer( CBasePlayer@ pPlayer )
	{
		if( BaseClass.AddToPlayer( pPlayer ) )
		{
			@m_pPlayer = pPlayer;
			NetworkMessage TNT( MSG_ONE, NetworkMessages::WeapPickup, pPlayer.edict() );
				TNT.WriteLong( g_ItemRegistry.GetIdForName("weapon_tnt") );
			TNT.End();
			return true;
		}

		return false;
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1	= TNT_MAX_CARRY;
		info.iMaxAmmo2	= -1;
		info.iMaxClip	= WEAPON_NOCLIP;
		info.iSlot  	= 4;
		info.iPosition	= 16;
		info.iWeight	= TNT_WEIGHT;
		info.iFlags 	= ITEM_FLAG_LIMITINWORLD | ITEM_FLAG_EXHAUSTIBLE;

		return true;
	}

	float WeaponTimeBase()
	{
		return g_Engine.time;
	}

	bool Deploy()
	{
		bool bResult;
		{
			m_flReleaseThrow = -1;
			bResult = self.DefaultDeploy( self.GetV_Model( "models/mc_defence/v_tnt.mdl" ), self.GetP_Model( "models/mc_defence/p_tnt.mdl" ), TNT_DEPLOY, "crowbar" );

			float deployTime = 0.7;
			self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + deployTime;
			return bResult;
		}
	}

	//fgsfds
	void Materialize()
	{
		BaseClass.Materialize();
		
		SetTouch( TouchFunction( CustomTouch ) );
	}

	void CustomTouch( CBaseEntity@ pOther )
	{
		if( !pOther.IsPlayer() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@> (pOther);

		if( pPlayer.HasNamedPlayerItem( "weapon_tnt" ) !is null ) 
		{
			if( pPlayer.GiveAmmo( TNT_DEFAULT_GIVE, "weapon_tnt", TNT_MAX_CARRY ) != -1 )
			{
				self.CheckRespawn();
				g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
				g_EntityFuncs.Remove( self );
			}
			return;
		}
		else if( pPlayer.AddPlayerItem( self ) != APIR_NotAdded )
		{
			self.AttachToPlayer( pPlayer );
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/gunpickup2.wav", 1, ATTN_NORM );
		}
	}
	//fgsfds

	bool CanHolster()
	{
		// can only holster hand grenades when not primed!
		return m_flStartThrow == 0;
	}

	bool CanDeploy()
	{
		return m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType) != 0;
	}

	void DestroyThink()
	{
		self.DestroyItem();
	}

	void Holster( int skiplocal )
	{
		self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.5f;
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.5f;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 0.5f;

		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) == 0 )
		{
			m_pPlayer.pev.weapons &= ~( 0 << g_ItemRegistry.GetIdForName("weapon_tnt") );
			SetThink( ThinkFunction( DestroyThink ) );
			self.pev.nextthink = g_Engine.time + 0.1;
		}

		m_flStartThrow = 0;
		m_flReleaseThrow = -1.0f;
		BaseClass.Holster( skiplocal );
	}

	void PrimaryAttack()
	{
		if( m_flStartThrow == 0 && m_pPlayer.m_rgAmmo ( self.m_iPrimaryAmmoType ) > 0 )
		{
			m_flReleaseThrow = 0;
			m_flStartThrow = g_Engine.time;
		
			self.SendWeaponAnim( TNT_PULLPIN );
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "mc_defence/fuse.ogg", VOL_NORM, ATTN_NORM );
			self.m_flTimeWeaponIdle = WeaponTimeBase() + 0.75;
		}
	}

	void WeaponIdle()
	{
		if ( m_flReleaseThrow == 0 && m_flStartThrow > 0.0 )
			m_flReleaseThrow = g_Engine.time;

		if ( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		if ( m_flStartThrow > 0.0 )
		{
			Vector angThrow = m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle;

			if ( angThrow.x < 0 )
				angThrow.x = -10 + angThrow.x * ( ( 90 - 10 ) / 90.0 );
			else
				angThrow.x = -10 + angThrow.x * ( ( 90 + 10 ) / 90.0 );

			float flVel = ( 90.0f - angThrow.x ) * 6;

			if ( flVel > 750.0f )
				flVel = 750.0f;

			Math.MakeVectors ( angThrow );

			Vector vecSrc = m_pPlayer.pev.origin + m_pPlayer.pev.view_ofs + g_Engine.v_forward * 16;
			Vector vecThrow = g_Engine.v_forward * flVel + m_pPlayer.pev.velocity;

			// always explode 2 seconds after the grenade was thrown
			time = m_flStartThrow - g_Engine.time + 2.0;
			if( time < 2.0 )
				time = 2.0;

			@pGrenade = g_EntityFuncs.ShootTimed( m_pPlayer.pev, vecSrc, vecThrow, time );
			g_EntityFuncs.SetModel( pGrenade, "models/mc_defence/w_tnt.mdl" );

		switch ( g_PlayerFuncs.SharedRandomLong( m_pPlayer.random_seed, 0, 2 ) )
		{
			case 0: self.SendWeaponAnim( TNT_THROW1, 0, 0 ); break;
			case 1: self.SendWeaponAnim( TNT_THROW2, 0, 0 ); break;
			case 2: self.SendWeaponAnim( TNT_THROW3, 0, 0 ); break;
		}
			if( m_flReleaseThrow < g_Engine.time )

			// player "shoot" animation
			m_pPlayer.SetAnimation( PLAYER_ATTACK1 );

			m_flReleaseThrow = g_Engine.time;
			m_flStartThrow = 0;
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 1.31;
			self.m_flTimeWeaponIdle = WeaponTimeBase() + 0.75;

			m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 1 );

			if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) == 0 )
			{
				// just threw last grenade
				// set attack times in the future, and weapon idle in the future so we can see the whole throw
				// animation, weapon idle will automatically retire the weapon for us.
				self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.75;
			}
			return;
		}
		else if( m_flReleaseThrow > 0 )
		{
			m_flStartThrow = 0;

			if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) > 0 )
			{
				self.SendWeaponAnim( TNT_DEPLOY );
			}
			else
			{
				self.RetireWeapon();
				return;
			}

			self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 10, 15 );
			m_flReleaseThrow = -1;
			return;
		}

		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) > 0 )
		{
			int iAnim;
			float flRand = g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 0, 1 );
			if( flRand <= 1.0 )
			{
				iAnim = TNT_IDLE;
				self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 10, 15 );
			}
			else
			{
				iAnim = TNT_IDLE2;
				self.m_flTimeWeaponIdle = WeaponTimeBase() + 2.5;
			}

			self.SendWeaponAnim( iAnim );
		}
	}
}

string GetTNTName()
{
	return "weapon_tnt";
}

void RegisterTNT()
{
	g_CustomEntityFuncs.RegisterCustomEntity( GetTNTName(), GetTNTName() );
	g_ItemRegistry.RegisterWeapon( GetTNTName(), "mc_defence", "weapon_tnt" );
	g_ItemRegistry.RegisterItem( GetTNTName(), "mc_defence", "weapon_tnt" );
}