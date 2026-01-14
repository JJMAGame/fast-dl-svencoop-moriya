//Counter-Strike 1.6 UMP-45
//Author: KernCore

#include "../base"

namespace CS_UMP45
{ //Namespace Start

enum UMP45Animation
{
	UMP45_IDLE = 0,
	UMP45_RELOAD,
	UMP45_DRAW,
	UMP45_SHOOT1,
	UMP45_SHOOT2,
	UMP45_SHOOT3
};

// Models
const string W_MODEL 	= "models/cs16/ump45/w_ump45.mdl";
const string V_MODEL 	= "models/cs16/ump45/v_ump45.mdl";
const string P_MODEL 	= "models/cs16/ump45/p_ump45.mdl";
// Sounds
const string SHOOT_S 	= "weapons/cs16/ump45-1.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 100 : 250;
const int MAX_CLIP  	= 25;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 5;
const int FLAGS     	= 0;
const uint DAMAGE   	= 26;
const uint SLOT     	= 2;
const uint POSITION 	= 9;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_45acp" : "9mm";

class weapon_ump45 : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
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
		"weapons/cs16/ump45_boltslap.wav",
		"weapons/cs16/ump45_clipin.wav",
		"weapons/cs16/ump45_clipout.wav",
		SHOOT_S,
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
		m_iShell = g_Game.PrecacheModel( CS16BASE::SHELL_PISTOL );
		//Sounds
		CS16BASE::PrecacheSound( Sounds );
		g_SoundSystem.PrecacheSound( CS16BASE::EMPTY_RIFLE_S );
		g_Game.PrecacheGeneric( "sound/" + CS16BASE::EMPTY_RIFLE_S );
		//Sprites
		g_Game.PrecacheModel( "sprites/cs16/640hud16.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud16.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_ump45.txt" );
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
		return Deploy( V_MODEL, P_MODEL, UMP45_DRAW, "mp5", GetBodygroup(), (30.0/30.0) );
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

		self.m_flNextPrimaryAttack = WeaponTimeBase() + GetFireRate( 571 );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		Vector accuracy = self.BulletAccuracy( VECTOR_CONE_2DEGREES, VECTOR_CONE_1DEGREES, g_vecZero );

		ShootWeapon( SHOOT_S, 1, accuracy, 8192, DAMAGE );

		self.SendWeaponAnim( UMP45_SHOOT1 + Math.RandomLong( 0, 2 ), 0, GetBodygroup() );

		if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
		{
			KickBack( 0.55, 0.3, 0.225, 0.03, 3.5, 2.5, 10 );
		}
		else if( m_pPlayer.pev.velocity.Length2D() > 0 )
		{
			KickBack( 0.55, 0.3, 0.225, 0.03, 3.5, 2.5, 10 );
		}
		else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
		{
			KickBack( 0.25, 0.175, 0.125, 0.02, 2.25, 1.25, 10 );
		}
		else
		{
			KickBack( 0.275, 0.2, 0.15, 0.0225, 2.5, 1.5, 10 );
		}

		ShellEject( m_pPlayer, m_iShell, Vector( 15, 7, -6 ), true, false );
	}

	void SecondaryAttack()
	{
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.1;
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		Reload( MAX_CLIP, UMP45_RELOAD, (115.0/33.0), GetBodygroup() );

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

		self.SendWeaponAnim( UMP45_IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_ump45";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CS_UMP45::weapon_ump45", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE ); // Register the weapon
}

} //Namespace end