//Counter-Strike 1.6 Desert Eagle
//Author: KernCore

#include "../base"

namespace CS_DEAGLE
{ //Namespace Start

enum DeagleAnimation
{
	DEAGLE_IDLE = 0,
	DEAGLE_SHOOT1,
	DEAGLE_SHOOT2,
	DEAGLE_EMPTY,
	DEAGLE_RELOAD,
	DEAGLE_DRAW
};

// Models
const string W_MODEL 	= "models/cs16/csdeagle/w_deagle.mdl";
const string V_MODEL 	= "models/cs16/csdeagle/v_deagle.mdl";
const string P_MODEL 	= "models/cs16/csdeagle/p_deagle.mdl";
// Sounds
const string SHOOT_1S 	= "weapons/cs16/deagle-1.wav";
const string SHOOT_2S 	= "weapons/cs16/deagle-2.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 35 : 36;
const int MAX_CLIP  	= 7;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 5;
const int FLAGS     	= 0;
const uint DAMAGE   	= 39;
const uint SLOT     	= 1;
const uint POSITION 	= 7;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_50ae" : "357";

class weapon_csdeagle : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
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
		"weapons/cs16/de_clipin.wav",
		"weapons/cs16/de_clipout.wav",
		"weapons/cs16/de_deploy.wav",
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
		m_iShell = g_Game.PrecacheModel( CS16BASE::SHELL_PISTOL );
		//Sounds
		CS16BASE::PrecacheSound( Sounds );
		g_SoundSystem.PrecacheSound( CS16BASE::EMPTY_PISTOL_S );
		g_Game.PrecacheGeneric( "sound/" + CS16BASE::EMPTY_PISTOL_S );
		//Sprites
		g_Game.PrecacheModel( "sprites/cs16/640hud7.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud10.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud11.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud10.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud11.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_csdeagle.txt" );
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
		return Deploy( V_MODEL, P_MODEL, DEAGLE_DRAW, "onehanded", GetBodygroup(), (30.0/30.0) );
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

		self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		Vector accuracy = self.BulletAccuracy( VECTOR_CONE_2DEGREES, VECTOR_CONE_1DEGREES, g_vecZero );

		ShootWeapon( (Math.RandomLong( 0, 1 ) < 0.5) ? SHOOT_1S : SHOOT_2S, 1, accuracy, 4096, DAMAGE );

		self.SendWeaponAnim( (self.m_iClip > 0) ? DEAGLE_SHOOT1 + Math.RandomLong( 0, 1 ) : DEAGLE_EMPTY, 0, GetBodygroup() );

		m_pPlayer.pev.punchangle.x -= 3;
		m_pPlayer.m_iWeaponVolume = BIG_EXPLOSION_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		ShellEject( m_pPlayer, m_iShell, Vector( 15, 10, -6 ), true, false );
	}

	void SecondaryAttack()
	{
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.12;
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		Reload( MAX_CLIP, DEAGLE_RELOAD, (65.0/30.0), GetBodygroup() );

		BaseClass.Reload();
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( DEAGLE_IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_csdeagle";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CS_DEAGLE::weapon_csdeagle", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE ); // Register the weapon
}

} //Namespace end