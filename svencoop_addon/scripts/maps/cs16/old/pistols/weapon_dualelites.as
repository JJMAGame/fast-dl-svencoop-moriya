//Counter-Strike 1.6 Dual Berettas (AKA Elites)
//Author: KernCore

#include "../base"

namespace CS_ELITES
{ //Namespace Start

enum ElitesAnimation
{
	ELITES_IDLE = 0,
	ELITES_IDLE_LEFTEMPTY,
	ELITES_SHOOTLEFT1,
	ELITES_SHOOTLEFT2,
	ELITES_SHOOTLEFT3,
	ELITES_SHOOTLEFT4,
	ELITES_SHOOTLEFT5,
	ELITES_SHOOTLEFTLAST,
	ELITES_SHOOTRIGHT1,
	ELITES_SHOOTRIGHT2,
	ELITES_SHOOTRIGHT3,
	ELITES_SHOOTRIGHT4,
	ELITES_SHOOTRIGHT5,
	ELITES_SHOOTRIGHTLAST,
	ELITES_RELOAD,
	ELITES_DRAW
};

// Models
const string W_MODEL 	= "models/cs16/dualelites/w_elite.mdl";
const string V_MODEL 	= "models/cs16/dualelites/v_elite.mdl";
const string P_MODEL 	= "models/cs16/dualelites/p_elite.mdl";
// Sounds
const string SHOOT_S 	= "weapons/cs16/elite_fire.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 120 : 250;
const int MAX_CLIP  	= 30;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 5;
const int FLAGS     	= 0;
const uint DAMAGE   	= 22;
const uint SLOT     	= 1;
const uint POSITION 	= 9;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_9mm" : "9mm";

class weapon_dualelites : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
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
		"weapons/cs16/elite_deploy.wav",
		"weapons/cs16/elite_sliderelease.wav",
		"weapons/cs16/elite_twirl.wav",
		"weapons/cs16/elite_leftclipin.wav",
		"weapons/cs16/elite_clipout.wav",
		"weapons/cs16/elite_reloadstart.wav",
		"weapons/cs16/elite_sliderelease.wav",
		"weapons/cs16/elite_rightclipin.wav",
		SHOOT_S,
	};

	void Spawn()
	{
		Precache();
		ShootMode = CS16BASE::SHOOTPOS_LEFT;
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
		g_Game.PrecacheModel( "sprites/cs16/640hud14.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud15.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud14.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud15.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_dualelites.txt" );
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
		return Deploy( V_MODEL, P_MODEL, ELITES_DRAW, "uzis", GetBodygroup(), (32.0/30.0) );
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

		self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.125;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		Vector accuracy = self.BulletAccuracy( VECTOR_CONE_2DEGREES, VECTOR_CONE_1DEGREES, g_vecZero );

		ShootWeapon( SHOOT_S, 1, accuracy, 4096, DAMAGE, true );
		int randomseed = g_PlayerFuncs.SharedRandomLong( m_pPlayer.random_seed, 0, 4 );

		m_pPlayer.pev.punchangle.x -= 2.0f;

		m_pPlayer.m_iWeaponVolume = BIG_EXPLOSION_VOLUME;
		m_pPlayer.m_iWeaponFlash = DIM_GUN_FLASH;

		if( self.m_iClip == 1 )
			self.SendWeaponAnim( ELITES_SHOOTLEFTLAST, 0, GetBodygroup() );
		else if( self.m_iClip == 0 )
			self.SendWeaponAnim( ELITES_SHOOTRIGHTLAST, 0, GetBodygroup() );
		else
			self.SendWeaponAnim( (ShootMode == CS16BASE::SHOOTPOS_LEFT) ? ELITES_SHOOTRIGHT1 + randomseed : ELITES_SHOOTLEFT1 + randomseed, 0, GetBodygroup() );
		
		ShellEject( m_pPlayer, m_iShell, (ShootMode == CS16BASE::SHOOTPOS_LEFT) ? Vector( 21, -9, -7 ) : Vector( 21, 9, -7 ), true, false );
	}

	void SecondaryAttack()
	{
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.12;
	}

	void BackToNormal()
	{
		m_pPlayer.m_szAnimExtension = "uzis";
		SetThink( null );
	}

	void ReloadLeft()
	{
		SetThink( null );
		m_pPlayer.m_szAnimExtension = "uzis_left";
		BaseClass.Reload();

		SetThink( ThinkFunction( BackToNormal ) );
		self.pev.nextthink = WeaponTimeBase() + 2.1;
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		m_pPlayer.m_szAnimExtension = "uzis_right";

		self.pev.nextthink = WeaponTimeBase() + 2.4;
		SetThink( ThinkFunction( ReloadLeft ) );
		ShootMode = CS16BASE::SHOOTPOS_LEFT;

		Reload( MAX_CLIP, ELITES_RELOAD, (137.0/30.0), GetBodygroup() );

		BaseClass.Reload();
	}

	void WeaponIdle()
	{
		m_pPlayer.m_szAnimExtension = "uzis";
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( (self.m_iClip == 1) ? ELITES_IDLE_LEFTEMPTY : ELITES_IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_dualelites";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CS_ELITES::weapon_dualelites", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE ); // Register the weapon
}

} //Namespace end