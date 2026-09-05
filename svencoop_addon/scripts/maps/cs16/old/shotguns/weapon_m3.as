//Counter-Strike 1.6 Leone 12 Gauge Super
//Author: KernCore

#include "../base"
#include "../ammo/ammo_cs_buckshot"


namespace CS_M3
{ //Namespace Start

enum M3Animation
{
	M3_IDLE = 0,
	M3_SHOOT1,
	M3_SHOOT2,
	M3_INSERT,
	M3_AFTER_RELOAD,
	M3_START_RELOAD,
	M3_DRAW
};

// Models
const string W_MODEL 	= "models/cs16/m3/w_m3.mdl";
const string V_MODEL 	= "models/cs16/m3/v_m3.mdl";
const string P_MODEL 	= "models/cs16/m3/p_m3.mdl";
// Sounds
const string SHOOT_S 	= "weapons/cs16/m3-1.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 32 : 125;
const int MAX_CLIP  	= 8;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 20;
const int FLAGS     	= 0;
const uint DAMAGE   	= 8;
const uint SLOT     	= 2;
const uint POSITION 	= 10;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_buckshot" : "buckshot";
const uint PELLETS  	= 9;

class weapon_m3 : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
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
		"weapons/cs16/m3_pump.wav",
		"weapons/cs16/m3_insertshell.wav",
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
		g_Game.PrecacheModel( "sprites/cs16/640hud1.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud4.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud1.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud4.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_m3.txt" );
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
		return Deploy( V_MODEL, P_MODEL, M3_DRAW, "shotgun", GetBodygroup(), (30.0/30.0) );
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

		self.m_flNextPrimaryAttack = WeaponTimeBase() + GetFireRate( 68 );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		Vector accuracy = Vector( 0.0675, 0.0675, 0 );

		ShootWeapon( SHOOT_S, PELLETS, accuracy, 3048, DAMAGE );

		self.SendWeaponAnim( M3_SHOOT1 + Math.RandomLong( 0, 1 ), 0, GetBodygroup() );

		if( m_pPlayer.pev.flags & FL_ONGROUND != 0 )
			m_pPlayer.pev.punchangle.x -= g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed + 1, 3, 5 );
		else
			m_pPlayer.pev.punchangle.x -= g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed + 1, 7, 10 );

		m_pPlayer.m_iWeaponVolume = LOUD_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = NORMAL_GUN_FLASH;

		ShellEject( m_pPlayer, m_iShell, Vector( 21, 15, -5 ), true, false, TE_BOUNCE_SHOTSHELL );
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
			self.SendWeaponAnim( M3_START_RELOAD, 0, GetBodygroup() );
			m_pPlayer.m_flNextAttack = (15.0/30.0); //Always uses a relative time due to prediction
			self.m_flTimeWeaponIdle = WeaponTimeBase() + (15.0/30.0);
			m_flNextReload = self.m_flNextPrimaryAttack = WeaponTimeBase() + (15.0/30.0);
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

			self.SendWeaponAnim( M3_INSERT, 0, GetBodygroup() );

			m_flNextReload = self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = WeaponTimeBase() + (27.0/65.0);

			// Add them to the clip
			self.m_iClip += 1;
			m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) - 1 );

			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_ITEM, Sounds[1], 1, ATTN_NORM, 0, 85 + Math.RandomLong( 0, 0x1f ) );

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
					self.SendWeaponAnim( M3_AFTER_RELOAD, 0, GetBodygroup() );

					m_fShotgunReload = false;
					self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = g_Engine.time + (33.0/38.0);
				}
			}
			else
			{
				self.SendWeaponAnim( M3_IDLE, 0, GetBodygroup() );
				self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
			}
		}
	}
}

string GetName()
{
	return "weapon_m3";
}

void Register()
{
	if( !g_CustomEntityFuncs.IsCustomEntity( CSAMMO_SHOTGUN::GetName() ) )
		CSAMMO_SHOTGUN::Register();

	g_CustomEntityFuncs.RegisterCustomEntity( "CS_M3::weapon_m3", GetName() );
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE, "", CSAMMO_SHOTGUN::GetName() );
}

} //Namespace end