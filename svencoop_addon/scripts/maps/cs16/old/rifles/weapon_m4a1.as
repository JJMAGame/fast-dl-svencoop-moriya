//Counter-Strike 1.6 M4A1
//Author: KernCore

#include "../base"

namespace CS_M4A1
{ //Namespace Start

enum M4A1Animation
{
	M4A1_IDLE = 0,
	M4A1_SHOOT1,
	M4A1_SHOOT2,
	M4A1_SHOOT3,
	M4A1_RELOAD,
	M4A1_DRAW,
	M4A1_ADD_SILENCER,
	M4A1_IDLE_UNSIL,
	M4A1_SHOOT1_UNSIL,
	M4A1_SHOOT2_UNSIL,
	M4A1_SHOOT3_UNSIL,
	M4A1_RELOAD_UNSIL,
	M4A1_DRAW_UNSIL,
	M4A1_DETACH_SILENCER
};

// Models
const string W_MODEL 	= "models/cs16/m4a1/w_m4a1.mdl";
const string V_MODEL 	= "models/cs16/m4a1/v_m4a1.mdl";
const string P_MODEL 	= "models/cs16/m4a1/p_m4a1.mdl";
// Sounds
const string SHOOT_1U 	= "weapons/cs16/m4a1_unsil-1.wav";
const string SHOOT_2U 	= "weapons/cs16/m4a1_unsil-2.wav";
const string SHOOT_S 	= "weapons/cs16/m4a1-1.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 90 : 600;
const int MAX_CLIP  	= 30;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 20;
const int FLAGS     	= 0;
const uint DAMAGE   	= 24;
const uint SLOT     	= 3;
const uint POSITION 	= 6;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_556" : "556";

class weapon_m4a1 : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iShell;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"weapons/cs16/m4a1_silencer_off.wav",
		"weapons/cs16/m4a1_silencer_on.wav",
		"weapons/cs16/m4a1_deploy.wav",
		"weapons/cs16/m4a1_clipout.wav",
		"weapons/cs16/m4a1_clipin.wav",
		"weapons/cs16/m4a1_boltpull.wav",
		SHOOT_1U,
		SHOOT_2U,
		SHOOT_S
	};

	void Spawn()
	{
		Precache();
		WeaponSilMode = CS16BASE::NO_SUPPRESSOR;
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
		m_iShell = g_Game.PrecacheModel( CS16BASE::SHELL_RIFLE );
		//Sounds
		CS16BASE::PrecacheSound( Sounds );
		g_SoundSystem.PrecacheSound( CS16BASE::EMPTY_RIFLE_S );
		g_Game.PrecacheGeneric( "sound/" + CS16BASE::EMPTY_RIFLE_S );
		//Sprites
		g_Game.PrecacheModel( "sprites/cs16/640hud7.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud2.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud5.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud2.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud5.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_m4a1.txt" );
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
		return Deploy( V_MODEL, P_MODEL, (WeaponSilMode == CS16BASE::SUPPRESSED) ? M4A1_DRAW : M4A1_DRAW_UNSIL, "m16", GetBodygroup(), (40.0/40.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		CommonHolster();
		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		if( self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15f;
			return;
		}

		Vector accuracy = self.BulletAccuracy( VECTOR_CONE_2DEGREES, VECTOR_CONE_1DEGREES, g_vecZero );
		string unsilsound = (Math.RandomLong( 0, 1 ) < 0.5) ? SHOOT_1U : SHOOT_2U;

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + GetFireRate( 666 );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		ShootWeapon( (WeaponSilMode == CS16BASE::SUPPRESSED) ? SHOOT_S : unsilsound, 1, accuracy, 8192, DAMAGE );

		self.SendWeaponAnim( (WeaponSilMode == CS16BASE::SUPPRESSED) ? M4A1_SHOOT1 + Math.RandomLong( 0, 2 ) : M4A1_SHOOT1_UNSIL + Math.RandomLong( 0, 2 ), 0, GetBodygroup() );

		if( m_pPlayer.pev.velocity.Length2D() > 0 )
		{
			KickBack( 1.0, 0.45, 0.28, 0.045, 3.75, 3.0, 7 );
		}
		else if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
		{
			KickBack( 1.2, 0.5, 0.23, 0.15, 5.5, 3.5, 6 );
		}
		else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
		{
			KickBack( 0.6, 0.3, 0.2, 0.0125, 3.25, 2.0, 7 );
		}
		else
		{
			KickBack( 0.65, 0.35, 0.25, 0.015, 3.5, 2.25, 7 );
		}

		m_pPlayer.m_iWeaponVolume = (WeaponSilMode == CS16BASE::SUPPRESSED) ? 0 : NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = (WeaponSilMode == CS16BASE::SUPPRESSED) ? 0 : BRIGHT_GUN_FLASH;

		ShellEject( m_pPlayer, m_iShell, Vector( 15, 10, -5 ), true, false );
	}

	void SecondaryAttack()
	{
		self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = WeaponTimeBase() + (60.0/30.0);
		switch( WeaponSilMode )
		{
			case CS16BASE::NO_SUPPRESSOR:
			{
				WeaponSilMode = CS16BASE::SUPPRESSED;
				self.SendWeaponAnim( M4A1_ADD_SILENCER, 0, GetBodygroup() );
				break;
			}
			case CS16BASE::SUPPRESSED:
			{
				WeaponSilMode = CS16BASE::NO_SUPPRESSOR;
				self.SendWeaponAnim( M4A1_DETACH_SILENCER, 0, GetBodygroup() );
				break;
			}
		}
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		Reload( MAX_CLIP, (WeaponSilMode == CS16BASE::NO_SUPPRESSOR) ? M4A1_RELOAD_UNSIL : M4A1_RELOAD, (113.0/37.0), GetBodygroup() );

		BaseClass.Reload();
	}

	void WeaponIdle()
	{
		if( self.m_flNextPrimaryAttack < g_Engine.time )
			m_iShotsFired = 0;
			
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( (WeaponSilMode == CS16BASE::NO_SUPPRESSOR) ? M4A1_IDLE_UNSIL : M4A1_IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_m4a1";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CS_M4A1::weapon_m4a1", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE ); // Register the weapon
}

} //Namespace end