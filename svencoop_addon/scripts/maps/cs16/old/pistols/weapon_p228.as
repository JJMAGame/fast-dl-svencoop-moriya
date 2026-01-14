//Counter-Strike 1.6 P228
//Author: KernCore

#include "../base"

namespace CS_P228
{ //Namespace Start

enum P228Animation
{
	P228_IDLE = 0,
	P228_SHOOT1,
	P228_SHOOT2,
	P228_SHOOT3,
	P228_EMPTY,
	P228_RELOAD,
	P228_DRAW
};

// Models
const string W_MODEL 	= "models/cs16/p228/w_p228.mdl";
const string V_MODEL 	= "models/cs16/p228/v_p228.mdl";
const string P_MODEL 	= "models/cs16/p228/p_p228.mdl";
// Sounds
const string SHOOT_S 	= "weapons/cs16/p228-1.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 52 : 250;
const int MAX_CLIP  	= 13;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 5;
const int FLAGS     	= 0;
const uint DAMAGE   	= 19;
const uint SLOT     	= 1;
const uint POSITION 	= 6;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_357sig" : "9mm";

class weapon_p228 : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
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
		"weapons/cs16/p228_sliderelease.wav",
		"weapons/cs16/p228_slidepull.wav",
		"weapons/cs16/p228_clipout.wav",
		"weapons/cs16/p228_clipin.wav",
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
		g_SoundSystem.PrecacheSound( CS16BASE::EMPTY_PISTOL_S );
		g_Game.PrecacheGeneric( "sound/" + CS16BASE::EMPTY_PISTOL_S );
		//Sprites
		g_Game.PrecacheModel( "sprites/cs16/640hud7.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud12.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud13.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud12.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud13.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_p228.txt" );
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
		return Deploy( V_MODEL, P_MODEL, P228_DRAW, "onehanded", GetBodygroup(), (30.0/30.0) );
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

		self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.12;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		Vector accuracy = self.BulletAccuracy( VECTOR_CONE_2DEGREES, VECTOR_CONE_1DEGREES, g_vecZero );

		ShootWeapon( SHOOT_S, 1, accuracy, 4096, DAMAGE );

		self.SendWeaponAnim( (self.m_iClip > 0) ? P228_SHOOT1 + Math.RandomLong( 0, 2 ) : P228_EMPTY, 0, GetBodygroup() );

		m_pPlayer.pev.punchangle.x -= 2;

		m_pPlayer.m_iWeaponVolume = BIG_EXPLOSION_VOLUME;
		m_pPlayer.m_iWeaponFlash = DIM_GUN_FLASH;

		ShellEject( m_pPlayer, m_iShell, Vector( 17, 10, -6 ), true, false );
	}

	void SecondaryAttack()
	{
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.12;
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		Reload( MAX_CLIP, P228_RELOAD, (95.0/35.0), GetBodygroup() );

		BaseClass.Reload();
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( P228_IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_p228";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CS_P228::weapon_p228", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE ); // Register the weapon
}

} //Namespace end