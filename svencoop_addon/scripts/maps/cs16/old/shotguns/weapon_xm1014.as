//Counter-Strike 1.6 XM-1014
//Author: KernCore

#include "../base"
#include "../ammo/ammo_cs_buckshot"

namespace CS_XM1014
{ //Namespace Start

enum XM1014Animation
{
	XM1014_IDLE = 0,
	XM1014_SHOOT1,
	XM1014_SHOOT2,
	XM1014_INSERT,
	XM1014_AFTER_RELOAD,
	XM1014_START_RELOAD,
	XM1014_DRAW
};

// Models
const string W_MODEL 	= "models/cs16/xm1014/w_xm1014.mdl";
const string V_MODEL 	= "models/cs16/xm1014/v_xm1014.mdl";
const string P_MODEL 	= "models/cs16/xm1014/p_xm1014.mdl";
// Sounds
const string SHOOT_S 	= "weapons/cs16/xm1014-1.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 32 : 125;
const int MAX_CLIP  	= 7;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 20;
const int FLAGS     	= 0;
const uint DAMAGE   	= 10;
const uint SLOT     	= 5;
const uint POSITION 	= 10;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_buckshot" : "buckshot";
const uint PELLETS  	= 6;

class weapon_xm1014 : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iShell;
	private float m_flNextReload;
	private bool m_fShotgunReload;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"weapons/cs16/de_deploy.wav",
		"hlclassic/weapons/reload3.wav",
		"hlclassic/weapons/reload1.wav",
		SHOOT_S
	};

	void Spawn()
	{
		Precache();
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
		m_iShell = g_Game.PrecacheModel( CS16BASE::SHELL_SHOTGUN );
		//Sounds
		CS16BASE::PrecacheSound( Sounds );
		g_SoundSystem.PrecacheSound( CS16BASE::EMPTY_RIFLE_S );
		g_Game.PrecacheGeneric( "sound/" + CS16BASE::EMPTY_RIFLE_S );
		//Sprites
		g_Game.PrecacheModel( "sprites/cs16/640hud7.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud12.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud13.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud12.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud13.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_xm1014.txt" );
		//Entities
		g_Game.PrecacheOther( "ammo_cs_buckshot" );
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

	bool AddToPlayer( CBasePlayer@ pPlayer )
	{
		return CommonAddToPlayer( pPlayer );
	}

	bool PlayEmptySound()
	{
		return CommonPlayEmptySound( CS16BASE::EMPTY_RIFLE_S );
	}

	bool Deploy()
	{
		return Deploy( V_MODEL, P_MODEL, XM1014_DRAW, "shotgun", GetBodygroup(), (30.0/30.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		m_fShotgunReload = false;
		CommonHolster();
		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		if( m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD || self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15f;
			return;
		}

		self.m_flNextPrimaryAttack = WeaponTimeBase() + GetFireRate( 240 );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		Vector accuracy = Vector( 0.0725, 0.0725, 0.0 );

		ShootWeapon( SHOOT_S, PELLETS, accuracy, 3048, DAMAGE );

		self.SendWeaponAnim( XM1014_SHOOT1 + Math.RandomLong( 0, 1 ), 0, GetBodygroup() );

		if( m_pPlayer.pev.flags & FL_ONGROUND != 0 )
			m_pPlayer.pev.punchangle.x -= g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed + 1, 3, 5 );
		else
			m_pPlayer.pev.punchangle.x -= g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed + 1, 7, 10 );

		m_pPlayer.m_iWeaponVolume = LOUD_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = NORMAL_GUN_FLASH;

		ShellEject( m_pPlayer, m_iShell, Vector( 19, 12, -7 ), true, false, TE_BOUNCE_SHOTSHELL );
	}

	void SecondaryAttack()
	{
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.1;
	}

	void ItemPostFrame()
	{
		// Checks if the player pressed one of the attack buttons, stops the reload and then attack
		if( m_pPlayer.pev.button & IN_ATTACK != 0 && m_fShotgunReload && m_flNextReload <= g_Engine.time && self.m_iClip != 0 )
		{
			self.m_flTimeWeaponIdle = g_Engine.time + m_flNextReload;
			m_fShotgunReload = false;
		}
		BaseClass.ItemPostFrame();
	}

	void Reload()
	{
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 || self.m_iClip == MAX_CLIP )
			return;

		if( m_flNextReload >  WeaponTimeBase() )
			return;

		// don't reload until recoil is done
		if( self.m_flNextPrimaryAttack > WeaponTimeBase() && !m_fShotgunReload )
			return;

		// check to see if we're ready to reload
		if( !m_fShotgunReload )
		{
			self.SendWeaponAnim( XM1014_START_RELOAD, 0, GetBodygroup() );
			m_pPlayer.m_flNextAttack = (20.0/30.0); //Always uses a relative time due to prediction
			self.m_flTimeWeaponIdle = WeaponTimeBase() + (20.0/30.0);
			m_flNextReload = self.m_flNextPrimaryAttack = WeaponTimeBase() + (20.0/30.0);
			m_fShotgunReload = true;
			return;
		}
		else if( m_fShotgunReload )
		{
			if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
				return;

			if( self.m_iClip == MAX_CLIP )
			{
				m_fShotgunReload = false;
				return;
			}

			self.SendWeaponAnim( XM1014_INSERT, 0, GetBodygroup() );

			m_flNextReload = self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = WeaponTimeBase() + (35.0/90.0);

			// Add them to the clip
			self.m_iClip += 1;
			m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 1 );

			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_ITEM, (Math.RandomLong( 0, 1 ) < 0.5) ? Sounds[1] : Sounds[2], 1, ATTN_NORM, 0, 85 + Math.RandomLong( 0, 0x1f ) );

		}
		BaseClass.Reload();
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle < g_Engine.time )
		{
			if( self.m_iClip == 0 && !m_fShotgunReload && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) != 0 )
			{
				self.Reload();
			}
			else if( m_fShotgunReload )
			{
				if( self.m_iClip != MAX_CLIP && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) > 0 )
				{
					self.Reload();
				}
				else
				{
					self.SendWeaponAnim( XM1014_AFTER_RELOAD, 0, GetBodygroup() );

					m_fShotgunReload = false;
					self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = g_Engine.time + (12.0/30.0);
				}
			}
			else
			{
				self.SendWeaponAnim( XM1014_IDLE, 0, GetBodygroup() );
				self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
			}
		}
	}
}

string GetName()
{
	return "weapon_xm1014";
}

void Register()
{
	if( !g_CustomEntityFuncs.IsCustomEntity( CSAMMO_SHOTGUN::GetName() ) )
		CSAMMO_SHOTGUN::Register();

	g_CustomEntityFuncs.RegisterCustomEntity( "CS_XM1014::weapon_xm1014", GetName() );
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE, "", CSAMMO_SHOTGUN::GetName() );
}

} //Namespace end