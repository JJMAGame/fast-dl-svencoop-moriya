//Counter-Strike 1.6 Krieg 550
//Author: KernCore

#include "../base"

namespace CS_SG550
{ //Namespace Start

enum SG550Animation
{
	SG550_IDLE = 0,
	SG550_SHOOT1,
	SG550_SHOOT2,
	SG550_RELOAD,
	SG550_DRAW
};

// Models
const string W_MODEL 	= "models/cs16/sg550/w_sg550.mdl";
const string V_MODEL 	= "models/cs16/sg550/v_sg550.mdl";
const string P_MODEL 	= "models/cs16/sg550/p_sg550.mdl";
// Sounds
const string SHOOT_S 	= "weapons/cs16/sg550-1.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 90 : 600;
const int MAX_CLIP  	= 30;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 25;
const int FLAGS     	= 0;
const uint DAMAGE   	= 52;
const uint SLOT     	= 5;
const uint POSITION 	= 9;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_556" : "556";

class weapon_sg550 : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
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
		"weapons/cs16/sg550_clipout.wav",
		"weapons/cs16/sg550_boltpull.wav",
		"weapons/cs16/sg550_clipin.wav",
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
		g_SoundSystem.PrecacheSound( CS16BASE::ZOOM_S );
		g_Game.PrecacheGeneric( "sound/" + CS16BASE::ZOOM_S );
		//Sprites
		g_Game.PrecacheModel( "sprites/cs16/640hud7.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud14.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud15.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud14.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud15.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/ch_sniper.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_sg550.txt" );
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
		return Deploy( V_MODEL, P_MODEL, SG550_DRAW, "m16", GetBodygroup(), (30.0/30.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		CommonHolster();
		FoVOFF();

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

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + GetFireRate( 240 );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		Vector accuracy = self.BulletAccuracy( (WeaponZoomMode != CS16BASE::ZOOM_OUT) ? VECTOR_CONE_3DEGREES : VECTOR_CONE_4DEGREES,
							(WeaponZoomMode != CS16BASE::ZOOM_OUT) ? VECTOR_CONE_1DEGREES : VECTOR_CONE_2DEGREES,
							(WeaponZoomMode != CS16BASE::ZOOM_OUT) ? g_vecZero : VECTOR_CONE_1DEGREES );

		ShootWeapon( SHOOT_S, 1, accuracy, 8192, DAMAGE );

		self.SendWeaponAnim( SG550_SHOOT1 + Math.RandomLong( 0, 1 ), 0, GetBodygroup() );

		m_pPlayer.pev.punchangle.x -= g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed + 4, 1.25, 1.75 ) + m_pPlayer.pev.punchangle.x * 0.25f;
		m_pPlayer.pev.punchangle.y += g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed + 5, -0.75, 0.75 );

		m_pPlayer.m_iWeaponVolume = LOUD_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		ShellEject( m_pPlayer, m_iShell, Vector( 17, 11, -8 ), true, false );
	}

	void SecondaryAttack()
	{
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.3f;
		g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_ITEM, CS16BASE::ZOOM_S, 0.9, ATTN_NORM, 0, PITCH_NORM );
		switch( WeaponZoomMode )
		{
			case CS16BASE::ZOOM_OUT:
			{
				WeaponZoomMode = CS16BASE::ZOOM_4X;
				ToggleZoom( 40 );
				m_pPlayer.pev.maxspeed = 150;
				break;
			}
		
			case CS16BASE::ZOOM_4X:
			{
				WeaponZoomMode = CS16BASE::ZOOM_8X;
				ToggleZoom( 10 );
				m_pPlayer.pev.maxspeed = 150;
				break;
			}

			case CS16BASE::ZOOM_8X:
			{
				FoVOFF();
				break;
			}
		}
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		FoVOFF();

		Reload( MAX_CLIP, SG550_RELOAD, (106.0/28.0), GetBodygroup() );

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

		self.SendWeaponAnim( SG550_IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_sg550";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CS_SG550::weapon_sg550", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE ); // Register the weapon
}

} //Namespace end