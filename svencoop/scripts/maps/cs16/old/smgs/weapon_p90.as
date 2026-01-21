//Counter-Strike 1.6 P90
//Author: KernCore

#include "../base"

namespace CS_P90
{ //Namespace Start

enum P90Animation
{
	P90_IDLE = 0,
	P90_RELOAD,
	P90_DRAW,
	P90_SHOOT1,
	P90_SHOOT2,
	P90_SHOOT3
};

// Models
const string W_MODEL 	= "models/cs16/p90/w_p90.mdl";
const string V_MODEL 	= "models/cs16/p90/v_p90.mdl";
const string P_MODEL 	= "models/cs16/p90/p_p90.mdl";
// Sounds
const string SHOOT_S 	= "weapons/cs16/p90-1.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 100 : 600;
const int MAX_CLIP  	= 50;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 15;
const int FLAGS     	= 0;
const uint DAMAGE   	= 15;
const uint SLOT     	= 2;
const uint POSITION 	= 8;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_fn57" : "556";

class weapon_p90 : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
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
		"weapons/cs16/p90_boltpull.wav",
		"weapons/cs16/p90_cliprelease.wav",
		"weapons/cs16/p90_clipin.wav",
		"weapons/cs16/p90_clipout.wav",
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
		m_iShell = g_Game.PrecacheModel( CS16BASE::SHELL_RIFLE );
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
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_p90.txt" );
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
		return Deploy( V_MODEL, P_MODEL, P90_DRAW, "mp5", GetBodygroup(), (30.0/30.0) );
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

		self.m_flNextPrimaryAttack = WeaponTimeBase() + GetFireRate( 857 );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		Vector accuracy = self.BulletAccuracy( VECTOR_CONE_2DEGREES, VECTOR_CONE_1DEGREES, g_vecZero );

		ShootWeapon( SHOOT_S, 1, accuracy, 8192, DAMAGE );

		self.SendWeaponAnim( P90_SHOOT1 + Math.RandomLong( 0, 2 ), 0, GetBodygroup() );

		if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
		{
			KickBack( 0.9, 0.45, 0.35, 0.04, 5.25, 3.5, 4 );
		}
		else if( m_pPlayer.pev.velocity.Length2D() > 0 )
		{
			KickBack( 0.45, 0.3, 0.2, 0.0275, 4.0, 2.25, 7 );
		}
		else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
		{
			KickBack( 0.275, 0.2, 0.125, 0.02, 3.0, 1.0, 9 );
		}
		else
		{
			KickBack( 0.3, 0.225, 0.125, 0.02, 3.25, 1.25, 8 );
		}

		ShellEject( m_pPlayer, m_iShell, Vector( 15, 8, -5 ), false, true );
	}

	void SecondaryAttack()
	{
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.1;
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		Reload( MAX_CLIP, P90_RELOAD, (135.0/40.0), GetBodygroup() );

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

		self.SendWeaponAnim( P90_IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_p90";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CS_P90::weapon_p90", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE ); // Register the weapon
}

} //Namespace end