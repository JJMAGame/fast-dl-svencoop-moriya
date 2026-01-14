//Counter-Strike 1.6 AK-47
//Author: KernCore

#include "../base"
#include "../ammo/ammo_cs_762"

namespace CS_AK47
{ //Namespace Start

enum AK47Animation
{
	AK47_IDLE = 0,
	AK47_RELOAD,
	AK47_DRAW,
	AK47_SHOOT1,
	AK47_SHOOT2,
	AK47_SHOOT3
};

// Models
const string W_MODEL 	= "models/cs16/ak47/w_ak47.mdl";
const string V_MODEL 	= "models/cs16/ak47/v_ak47.mdl";
const string P_MODEL 	= "models/cs16/ak47/p_ak47.mdl";
// Sounds
const string SHOOT_1S 	= "weapons/cs16/ak47-1.wav";
const string SHOOT_2S 	= "weapons/cs16/ak47-2.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 90 : 600;
const int MAX_CLIP  	= 30;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 5;
const int FLAGS     	= 0;
const uint DAMAGE   	= 26;
const uint SLOT     	= 3;
const uint POSITION 	= 9;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_762" : "556";

class weapon_ak47 : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
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
		"weapons/cs16/ak47_boltpull.wav",
		"weapons/cs16/ak47_clipin.wav",
		"weapons/cs16/ak47_clipout.wav",
		SHOOT_1S,
		SHOOT_2S
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
		g_Game.PrecacheModel( "sprites/cs16/640hud10.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud11.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud10.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud11.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_ak47.txt" );
		//Entities
		g_Game.PrecacheOther( "ammo_cs_762" );
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= MAX_CARRY;
		info.iAmmo1Drop	= MAX_CLIP;
		info.iMaxAmmo2 	= -1;
		info.iAmmo2Drop	= -1;
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
		return Deploy( V_MODEL, P_MODEL, AK47_DRAW, "m16", GetBodygroup(), (30.0/30.0) );
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

		self.m_flNextPrimaryAttack = WeaponTimeBase() + GetFireRate( 600 );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		Vector accuracy = self.BulletAccuracy( VECTOR_CONE_2DEGREES, VECTOR_CONE_1DEGREES, g_vecZero );

		ShootWeapon( (Math.RandomLong( 0, 1 ) < 0.5) ? SHOOT_1S : SHOOT_2S, 1, accuracy, 8192, DAMAGE );

		self.SendWeaponAnim( AK47_SHOOT1 + Math.RandomLong( 0, 2 ), 0, GetBodygroup() );

		if( m_pPlayer.pev.velocity.Length2D() > 0 )
		{
			KickBack( 1.5, 0.45, 0.225, 0.05, 6.5, 2.5, 7 );
		}
		else if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
		{
			KickBack( 2.0, 1.0, 0.5, 0.35, 9.0, 6.0, 5 );
		}
		else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
		{
			KickBack( 0.9, 0.35, 0.15, 0.025, 5.5, 1.5, 9 );
		}
		else
		{
			KickBack( 1.0, 0.375, 0.175, 0.0375, 5.75, 1.75, 8 );
		}

		ShellEject( m_pPlayer, m_iShell, Vector( 21, 12, -9 ), true, false );
	}

	void SecondaryAttack()
	{
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.1;
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		Reload( MAX_CLIP, AK47_RELOAD, (90.0/37.0), GetBodygroup() );

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

		self.SendWeaponAnim( AK47_IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_ak47";
}

void Register()
{
	if( !g_CustomEntityFuncs.IsCustomEntity( CSAMMO_762::GetName() ) )
		CSAMMO_762::Register();

	g_CustomEntityFuncs.RegisterCustomEntity( "CS_AK47::weapon_ak47", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE, "", CSAMMO_762::GetName() ); // Register the weapon
}

} //Namespace end