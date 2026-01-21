//Counter-Strike 1.6 Scout
//Author: KernCore

#include "../base"
#include "../ammo/ammo_cs_762"

namespace CS_SCOUT
{ //Namespace Start

enum SCOUTAnimation
{
	SCOUT_IDLE1 = 0,
	SCOUT_SHOOT1,
	SCOUT_SHOOT2,
	SCOUT_RELOAD,
	SCOUT_DRAW
};

// Models
const string W_MODEL 	= "models/cs16/scout/w_scout.mdl";
const string V_MODEL 	= "models/cs16/scout/v_scout.mdl";
const string P_MODEL 	= "models/cs16/scout/p_scout.mdl";
// Sounds
const string SHOOT_S 	= "weapons/cs16/scout_fire-1.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 90 : 600;
const int MAX_CLIP  	= 10;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 15;
const int FLAGS     	= 0;
const uint DAMAGE   	= 63;
const uint SLOT     	= 5;
const uint POSITION 	= 5;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_762" : "556";

class weapon_scout : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
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
		"weapons/cs16/scout_clipout.wav",
		"weapons/cs16/scout_clipin.wav",
		"weapons/cs16/scout_bolt.wav",
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
		m_iShell = g_Game.PrecacheModel( CS16BASE::SHELL_SNIPER );
		//Sounds
		CS16BASE::PrecacheSound( Sounds );
		g_SoundSystem.PrecacheSound( CS16BASE::EMPTY_RIFLE_S );
		g_Game.PrecacheGeneric( "sound/" + CS16BASE::EMPTY_RIFLE_S );
		g_SoundSystem.PrecacheSound( CS16BASE::ZOOM_S );
		g_Game.PrecacheGeneric( "sound/" + CS16BASE::ZOOM_S );
		//Sprites
		g_Game.PrecacheModel( "sprites/cs16/640hud7.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud12.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud13.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr");
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud12.spr");
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud13.spr");
		g_Game.PrecacheGeneric( "sprites/" + "cs16/ch_sniper.spr");
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_scout.txt");
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
		return Deploy( V_MODEL, P_MODEL, SCOUT_DRAW, "sniper", GetBodygroup(), (30.0/30.0) );
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

		self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + GetFireRate( 48 );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		Vector accuracy = self.BulletAccuracy( (WeaponZoomMode != CS16BASE::ZOOM_OUT) ? VECTOR_CONE_2DEGREES : VECTOR_CONE_4DEGREES,
							(WeaponZoomMode != CS16BASE::ZOOM_OUT) ? VECTOR_CONE_1DEGREES : VECTOR_CONE_2DEGREES,
							(WeaponZoomMode != CS16BASE::ZOOM_OUT) ? g_vecZero : VECTOR_CONE_1DEGREES );

		ShootWeapon( SHOOT_S, 1, accuracy, 8192, DAMAGE );

		self.SendWeaponAnim( SCOUT_SHOOT1 + Math.RandomLong( 0, 1 ), 0, GetBodygroup() );

		m_pPlayer.pev.punchangle.x -= (WeaponZoomMode != CS16BASE::ZOOM_OUT) ? 4 : 6;

		m_pPlayer.m_iWeaponVolume = BIG_EXPLOSION_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		SetThink( ThinkFunction( this.BrassEjectThink ) );
		self.pev.nextthink = g_Engine.time + 0.48;
	}

	void BrassEjectThink()
	{
		ShellEject( m_pPlayer, m_iShell, Vector( 13, 9, -8 ), true, false );
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

		Reload( MAX_CLIP, SCOUT_RELOAD, (60.0/30.0), GetBodygroup() );

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

		self.SendWeaponAnim( SCOUT_IDLE1, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_scout";
}

void Register()
{
	if( !g_CustomEntityFuncs.IsCustomEntity( CSAMMO_762::GetName() ) )
		CSAMMO_762::Register();

	g_CustomEntityFuncs.RegisterCustomEntity( "CS_SCOUT::weapon_scout", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE, "", CSAMMO_762::GetName() ); // Register the weapon
}

} //Namespace end