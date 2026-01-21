//Counter-Strike 1.6 TMP
//Author: KernCore

#include "../base"

namespace CS_TMP
{ //Namespace Start

enum TMPAnimation
{
	TMP_IDLE = 0,
	TMP_RELOAD,
	TMP_DRAW,
	TMP_SHOOT1,
	TMP_SHOOT2,
	TMP_SHOOT3
};

// Models
const string W_MODEL 	= "models/cs16/tmp/w_tmp.mdl";
const string V_MODEL 	= "models/cs16/tmp/v_tmp.mdl";
const string P_MODEL 	= "models/cs16/tmp/p_tmp.mdl";
// Sounds
const string SHOOT_1S 	= "weapons/cs16/tmp-1.wav";
const string SHOOT_2S 	= "weapons/cs16/tmp-2.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 120 : 250;
const int MAX_CLIP  	= 30;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 5;
const int FLAGS     	= 0;
const uint DAMAGE   	= 19;
const uint SLOT     	= 2;
const uint POSITION 	= 5;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_9mm" : "9mm";

class weapon_tmp : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
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
		"weapons/cs16/clipin1.wav",
		"weapons/cs16/clipout1.wav",
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
		g_SoundSystem.PrecacheSound( CS16BASE::EMPTY_RIFLE_S );
		g_Game.PrecacheGeneric( "sound/" + CS16BASE::EMPTY_RIFLE_S );
		//Sprites
		g_Game.PrecacheModel( "sprites/cs16/640hud2.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud5.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud2.spr");
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud5.spr");
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr");
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_tmp.txt" );
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
		return Deploy( V_MODEL, P_MODEL, TMP_DRAW, "onehanded", GetBodygroup(), (16.0/18.0) );
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

		ShootWeapon( (Math.RandomLong( 0, 1 ) < 0.5) ? SHOOT_1S : SHOOT_2S, 1, accuracy, 8192, DAMAGE );

		self.SendWeaponAnim( TMP_SHOOT1 + Math.RandomLong( 0, 2 ), 0, GetBodygroup() );

		if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
		{
			KickBack( 1.1, 0.5, 0.35, 0.045, 4.5, 3.5, 6 );
		}
		else if( m_pPlayer.pev.velocity.Length2D() > 0 )
		{
			KickBack( 0.8, 0.4, 0.2, 0.03, 3.0, 2.5, 7 );
		}
		else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
		{
			KickBack( 0.7, 0.35, 0.125, 0.025, 2.5, 2.0, 10 );
		}
		else
		{
			KickBack( 0.725, 0.375, 0.15, 0.025, 2.75, 2.25, 9 );
		}

		m_pPlayer.m_iWeaponVolume = 0;
		m_pPlayer.m_iWeaponFlash = 0;

		ShellEject( m_pPlayer, m_iShell, Vector( 10, 7, -8 ), true, false );
	}

	void SecondaryAttack()
	{
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.1;
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		Reload( MAX_CLIP, TMP_RELOAD, (53.0/25.0), GetBodygroup() );

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

		self.SendWeaponAnim( TMP_IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_tmp";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CS_TMP::weapon_tmp", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE ); // Register the weapon
}

} //Namespace end