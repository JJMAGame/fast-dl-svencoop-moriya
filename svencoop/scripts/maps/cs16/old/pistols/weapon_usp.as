//Counter-Strike 1.6 USP
//Author: KernCore

#include "../base"

namespace CS_USP
{ //Namespace Start

enum USPAnimation
{
	USP_IDLE = 0,
	USP_SHOOT1,
	USP_SHOOT2,
	USP_SHOOT3,
	USP_SHOOTLAST,
	USP_RELOAD,
	USP_DRAW,
	USP_ADD_SILENCER,
	USP_IDLE_UNSIL,
	USP_SHOOT1_UNSIL,
	USP_SHOOT2_UNSIL,
	USP_SHOOT3_UNSIL,
	USP_SHOOTLAST_UNSIL,
	USP_RELOAD_UNSIL,
	USP_DRAW_UNSIL,
	USP_DETACH_SILENCER
};

// Models
const string W_MODEL 	= "models/cs16/usp/w_usp.mdl";
const string V_MODEL 	= "models/cs16/usp/v_usp.mdl";
const string P_MODEL 	= "models/cs16/usp/p_usp.mdl";
// Sounds
const string SHOOT_U 	= "weapons/cs16/usp_unsil-1.wav";
const string SHOOT_S 	= "weapons/cs16/usp1.wav";
const string SHOOT_2S 	= "weapons/cs16/usp2.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 100 : 250;
const int MAX_CLIP  	= 12;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 5;
const int FLAGS     	= 0;
const uint DAMAGE   	= 21;
const uint SLOT     	= 1;
const uint POSITION 	= 4;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_45acp" : "9mm";

class weapon_usp : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
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
		"weapons/cs16/usp_silencer_off.wav",
		"weapons/cs16/usp_silencer_on.wav",
		"weapons/cs16/usp_clipout.wav",
		"weapons/cs16/usp_clipin.wav",
		"weapons/cs16/usp_slideback.wav",
		"weapons/cs16/usp_sliderelease.wav",
		SHOOT_U,
		SHOOT_S,
		SHOOT_2S
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
		m_iShell = g_Game.PrecacheModel( CS16BASE::SHELL_PISTOL );
		//Sounds
		CS16BASE::PrecacheSound( Sounds );
		g_SoundSystem.PrecacheSound( CS16BASE::EMPTY_PISTOL_S );
		g_Game.PrecacheGeneric( "sound/" + CS16BASE::EMPTY_PISTOL_S );
		//Sprites
		g_Game.PrecacheModel( "sprites/cs16/640hud7.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud1.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud4.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud1.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud4.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_usp.txt" );
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
		return CommonPlayEmptySound( CS16BASE::EMPTY_PISTOL_S );
	}

	bool Deploy()
	{
		return Deploy( V_MODEL, P_MODEL, (WeaponSilMode == CS16BASE::SUPPRESSED) ? USP_DRAW : USP_DRAW_UNSIL, "onehanded", GetBodygroup(), (48.0/48.0) );
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

		if( ( m_pPlayer.m_afButtonPressed & IN_ATTACK == 0 ) )
			return;

		Vector accuracy = self.BulletAccuracy( VECTOR_CONE_2DEGREES, VECTOR_CONE_1DEGREES, g_vecZero );
		string silsound = (Math.RandomLong( 0, 1 ) < 0.5) ? SHOOT_2S : SHOOT_S;

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.117;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		ShootWeapon( (WeaponSilMode == CS16BASE::SUPPRESSED) ? silsound : SHOOT_U, 1, accuracy, 4096, DAMAGE );

		if( WeaponSilMode == CS16BASE::SUPPRESSED )
		{
			self.SendWeaponAnim( (self.m_iClip > 0) ? USP_SHOOT1 + Math.RandomLong( 0, 2 ) : USP_SHOOTLAST, 0, GetBodygroup() );
		}
		else if( WeaponSilMode == CS16BASE::NO_SUPPRESSOR )
		{
			self.SendWeaponAnim( (self.m_iClip > 0) ? USP_SHOOT1_UNSIL + Math.RandomLong( 0, 2 ) : USP_SHOOTLAST_UNSIL, 0, GetBodygroup() );
		}

		m_pPlayer.pev.punchangle.x -= 2;

		m_pPlayer.m_iWeaponVolume = (WeaponSilMode == CS16BASE::SUPPRESSED) ? 0 : BIG_EXPLOSION_VOLUME;
		m_pPlayer.m_iWeaponFlash = (WeaponSilMode == CS16BASE::SUPPRESSED) ? 0 : DIM_GUN_FLASH;

		ShellEject( m_pPlayer, m_iShell, Vector( 16, 7, -6 ), true, false );
	}

	void SecondaryAttack()
	{
		self.m_flTimeWeaponIdle = self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = WeaponTimeBase() + (115.0/37.0);
		switch( WeaponSilMode )
		{
			case CS16BASE::NO_SUPPRESSOR:
			{
				WeaponSilMode = CS16BASE::SUPPRESSED;
				self.SendWeaponAnim( USP_ADD_SILENCER, 0, GetBodygroup() );
				break;
			}
			case CS16BASE::SUPPRESSED:
			{
				WeaponSilMode = CS16BASE::NO_SUPPRESSOR;
				self.SendWeaponAnim( USP_DETACH_SILENCER, 0, GetBodygroup() );
				break;
			}
		}
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		Reload( MAX_CLIP, (WeaponSilMode == CS16BASE::NO_SUPPRESSOR) ? USP_RELOAD_UNSIL : USP_RELOAD, (100.0/37.0), GetBodygroup() );

		BaseClass.Reload();
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( (WeaponSilMode == CS16BASE::NO_SUPPRESSOR) ? USP_IDLE_UNSIL : USP_IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_usp";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CS_USP::weapon_usp", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE ); // Register the weapon
}

} //Namespace end