//Counter-Strike 1.6 M249
//Author: KernCore

#include "../base"

namespace CS_M249
{ //Namespace Start

enum M249Animation
{
	M249_IDLE = 0,
	M249_SHOOT1,
	M249_SHOOT2,
	M249_RELOAD,
	M249_DRAW
};

// Models
const string W_MODEL 	= "models/cs16/m249/w_m249.mdl";
const string V_MODEL 	= "models/cs16/m249/v_m249.mdl";
const string P_MODEL 	= "models/cs16/m249/p_m249.mdl";
// Sounds
const string SHOOT_1S 	= "weapons/cs16/m249-1.wav";
const string SHOOT_2S 	= "weapons/cs16/m249-2.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 200 : 600;
const int MAX_CLIP  	= 100;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 30;
const int FLAGS     	= 0;
const uint DAMAGE   	= 21;
const uint SLOT     	= 5;
const uint POSITION 	= 7;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_556box" : "556";

class weapon_csm249 : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
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
		"weapons/cs16/m249_boxin.wav",
		"weapons/cs16/m249_boxout.wav",
		"weapons/cs16/m249_chain.wav",
		"weapons/cs16/m249_coverup.wav",
		"weapons/cs16/m249_coverdown.wav",
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
		g_Game.PrecacheModel( "sprites/cs16/640hud3.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud6.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud3.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud6.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_csm249.txt" );
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
		return Deploy( V_MODEL, P_MODEL, M249_DRAW, "saw", GetBodygroup(), (30.0/30.0) );
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

		self.SendWeaponAnim( M249_SHOOT1 + Math.RandomLong( 0, 1 ), 0, GetBodygroup() );

		//_pPlayer.pev.punchangle.x = Math.RandomFloat( -3.5f, -1.5f );
		if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
		{
			KickBack( 1.8, 0.65, 0.45, 0.125, 5.0, 3.5, 8 );
		}
		else if( m_pPlayer.pev.velocity.Length2D() > 0 )
		{
			KickBack( 1.1, 0.5, 0.3, 0.06, 4.0, 3.0, 8 );
		}
		else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
		{
			KickBack( 0.75, 0.325, 0.25, 0.025, 3.5, 2.5, 9 );
		}
		else
		{
			KickBack( 0.8, 0.35, 0.3, 0.03, 3.75, 3.0, 9 );
		}

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		ShellEject( m_pPlayer, m_iShell, Vector( 13, 9, -5 ), false, false );
	}

	void SecondaryAttack()
	{
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.1;
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		Reload( MAX_CLIP, M249_RELOAD, (140.0/30.0), GetBodygroup() );

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

		self.SendWeaponAnim( M249_IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_csm249";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CS_M249::weapon_csm249", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE ); // Register the weapon
}

} //Namespace end