//Counter-Strike 1.6 High Explosive Grenade
//Author: KernCore, base from Nero

#include "../base"

namespace CS_HEGRENADE
{ //Namespace Start

enum HEGRENADEAnimation 
{
	HEGRENADE_IDLE = 0,
	HEGRENADE_PULLPIN,
	HEGRENADE_THROW,
	HEGRENADE_DRAW
};

// Models
const string W_MODEL 	= "models/cs16/hegrenade/w_hegrenade.mdl";
const string V_MODEL 	= "models/cs16/hegrenade/v_hegrenade.mdl";
const string P_MODEL 	= "models/cs16/hegrenade/p_hegrenade.mdl";
// Sounds
const string SHOOT_S 	= "weapons/cs16/ct_fireinhole.wav";
// Information
const int MAX_CARRY 	= 10;
const int MAX_CLIP  	= WEAPON_NOCLIP;
const int DEFAULT_GIVE 	= 1;
const int WEIGHT    	= 5;
const int FLAGS     	= ITEM_FLAG_LIMITINWORLD | ITEM_FLAG_EXHAUSTIBLE;
const uint DAMAGE   	= 150;
const uint SLOT     	= 4;
const uint POSITION 	= 6;
const string AMMO_TYPE 	= GetName();
const float TIMER    	= 1.5;

class weapon_hegrenade : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private bool m_bInAttack, m_bThrown;
	private float m_fAttackStart, m_flStartThrow;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"weapons/cs16/pinpull.wav",
		SHOOT_S
	};

	void Spawn()
	{
		Precache();
		self.pev.dmg = DAMAGE;
		CommonSpawn( W_MODEL, DEFAULT_GIVE );
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		//Models
		CommonPrecache();
		g_Game.PrecacheModel( W_MODEL );
		g_Game.PrecacheModel( V_MODEL );
		g_Game.PrecacheModel( P_MODEL );
		//Sounds
		CS16BASE::PrecacheSound( Sounds );
		//Sprites
		g_Game.PrecacheModel( "sprites/cs16/640hud7.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud3.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud6.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud3.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud6.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_hegrenade.txt" );
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= MAX_CARRY;
		info.iMaxAmmo2 	= -1;
		info.iMaxClip 	= MAX_CLIP;
		info.iSlot  	= SLOT;
		info.iPosition 	= POSITION;
		info.iId     	= g_ItemRegistry.GetIdForName( self.pev.classname );
		info.iFlags 	= FLAGS;
		info.iWeight 	= WEIGHT;

		return true;
	}

	void Materialize()
	{
		BaseClass.Materialize();
		SetTouch( TouchFunction( this.CustomTouch ) );
		SetUse( UseFunction( this.CustomUse ) );
	}

	void CustomTouch( CBaseEntity@ pOther )
	{
		if( !pOther.IsPlayer() || !pOther.IsAlive() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pOther );

		if( pPlayer.HasNamedPlayerItem( self.pev.classname ) !is null )
		{
			if( pPlayer.GiveAmmo( DEFAULT_GIVE, self.pev.classname, MAX_CARRY ) != -1 )
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

	void CustomUse( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float value )
	{
		if( !pActivator.IsPlayer() || !pActivator.IsAlive() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pActivator );

		if( pPlayer.HasNamedPlayerItem( self.pev.classname ) !is null )
		{
			if( pPlayer.GiveAmmo( DEFAULT_GIVE, self.pev.classname, MAX_CARRY ) != -1 )
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

	bool AddToPlayer( CBasePlayer@ pPlayer )
	{
		return CommonAddToPlayer( pPlayer );
	}

	bool Deploy()
	{
		return Deploy( V_MODEL, P_MODEL, HEGRENADE_DRAW, "crowbar", GetBodygroup(), (20.0/30.0) );
	}

	bool CanHolster()
	{
		if( m_fAttackStart != 0 )
			return false;

		return true;
	}

	bool CanDeploy()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType) == 0 )
			return false;

		return true;
	}

	//int iCount = 0;
	void Holster( int skipLocal = 0 )
	{
		m_bThrown = false;
		m_bInAttack = false;
		m_fAttackStart = 0;
		m_flStartThrow = 0;

		CommonHolster();

		//g_Game.AlertMessage( at_console, "[Holster]The amount of primary ammo " + m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) + "\n" );
		//iCount++;
		//g_Game.AlertMessage( at_console, "[Holster]Amount of times called " + iCount + "\n" );

		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) == 0 )
		{
			m_pPlayer.pev.weapons &= ~( 0 << g_ItemRegistry.GetIdForName( self.pev.classname ) );
			SetThink( ThinkFunction( DestroyThink ) );
			self.pev.nextthink = g_Engine.time + 0.1;
		}

		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0  )
			return;

		if( m_fAttackStart < 0 || m_fAttackStart > 0 )
			return;

		self.m_flNextPrimaryAttack = WeaponTimeBase() + (40.0/41.0);
		self.SendWeaponAnim( HEGRENADE_PULLPIN, 0, GetBodygroup() );

		m_bInAttack = true;
		m_fAttackStart = g_Engine.time + (40.0/41.0);

		self.m_flTimeWeaponIdle = g_Engine.time + (40.0/41.0) + (23.0/30.0);
	}

	void SecondaryAttack()
	{
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.1;
	}

	void LaunchThink()
	{
		g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_VOICE, SHOOT_S, VOL_NORM, ATTN_NORM, 0, PITCH_NORM );
		Vector angThrow = m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle;

		if ( angThrow.x < 0 )
			angThrow.x = -10 + angThrow.x * ( (90 - 10) / 90.0 );
		else
			angThrow.x = -10 + angThrow.x * ( (90 + 10) / 90.0 );

		float flVel = (90.0f - angThrow.x) * 6;

		if ( flVel > 750.0f )
			flVel = 750.0f;

		Math.MakeVectors( angThrow );

		Vector vecSrc = m_pPlayer.pev.origin + m_pPlayer.pev.view_ofs + g_Engine.v_forward * 16;
		Vector vecThrow = g_Engine.v_forward * flVel + m_pPlayer.pev.velocity;

		CBaseEntity@ pGrenade = g_EntityFuncs.ShootTimed( m_pPlayer.pev, vecSrc, vecThrow, TIMER );
		g_EntityFuncs.SetModel( pGrenade, W_MODEL );

		m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 1 );
		m_fAttackStart = 0;
	}

	void ItemPreFrame()
	{
		if( m_fAttackStart == 0 && m_bThrown == true && m_bInAttack == false && self.m_flTimeWeaponIdle < g_Engine.time )
		{
			if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) == 0 )
			{
				self.Holster();
			}
			else
			{
				self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = WeaponTimeBase() + (20.0/30.0);
				self.SendWeaponAnim( HEGRENADE_DRAW, 0, GetBodygroup() );
				m_bThrown = false;
				m_bInAttack = false;
				m_fAttackStart = 0;
			}
		}

		if( !m_bInAttack || m_pPlayer.pev.button & IN_ATTACK != 0 || g_Engine.time < m_fAttackStart )
			return;

		self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = WeaponTimeBase() + (23.0/30.0);
		self.SendWeaponAnim( HEGRENADE_THROW, 0, GetBodygroup() );
		m_bThrown = true;
		m_bInAttack = false;
		m_pPlayer.SetAnimation( PLAYER_ATTACK1 );

		SetThink( ThinkFunction( LaunchThink ) );
		self.pev.nextthink = g_Engine.time + 0.26;

		BaseClass.ItemPreFrame();
	}

	void WeaponIdle()
	{
		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( HEGRENADE_IDLE, 0, GetBodygroup() );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_hegrenade";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CS_HEGRENADE::weapon_hegrenade", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE ); // Register the weapon
}

} //Namespace end