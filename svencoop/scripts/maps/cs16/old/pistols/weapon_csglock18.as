//Counter-Strike 1.6 Glock-18
//Author: KernCore

#include "../base"

namespace CS_GLOCK
{ //Namespace Start

enum GLOCKAnimation
{
	GLOCK_IDLE1 = 0,
	GLOCK_IDLE2, //Unused
	GLOCK_IDLE3, //Unused
	GLOCK_SHOOT1, //Unused
	GLOCK_SHOOT2, //Unused
	GLOCK_SHOOT3,
	GLOCK_SHOOTEMPTY,
	GLOCK_RELOAD,
	GLOCK_DRAW,
	GLOCK_HOLSTER,
	GLOCK_ADDSILENCER, //Unused
	GLOCK_DRAW2, //Unused
	GLOCK_RELOAD2 //Unused
};

// Models
const string W_MODEL 	= "models/cs16/glock18/w_glock18.mdl";
const string V_MODEL 	= "models/cs16/glock18/v_glock18.mdl";
const string P_MODEL 	= "models/cs16/glock18/p_glock18.mdl";
// Sounds
const string SHOOT_S 	= "weapons/cs16/glock18-2.wav";
// Information
const int MAX_CARRY 	= (CS16BASE::UseCustomAmmo) ? 120 : 250;
const int MAX_CLIP  	= 20;
const int DEFAULT_GIVE 	= MAX_CLIP * 3;
const int WEIGHT    	= 5;
const int FLAGS     	= 0;
const uint DAMAGE   	= 39;
const uint SLOT     	= 1;
const uint POSITION 	= 5;
const string AMMO_TYPE 	= (CS16BASE::UseCustomAmmo) ? "ammo_cs_9mm" : "9mm";

class weapon_csglock18 : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iShell;
	private int m_iBurstCount = 0, m_iBurstLeft = 0;
	private float m_flNextBurstFireTime = 0;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"weapons/cs16/clipout1.wav",
		"weapons/cs16/clipin1.wav",
		"weapons/cs16/slideback1.wav",
		"weapons/cs16/sliderelease1.wav",
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
		m_iShell = g_Game.PrecacheModel( CS16BASE::SHELL_PISTOL );
		//Sounds
		CS16BASE::PrecacheSound( Sounds );
		g_SoundSystem.PrecacheSound( CS16BASE::EMPTY_PISTOL_S );
		g_Game.PrecacheGeneric( "sound/" + CS16BASE::EMPTY_PISTOL_S );
		//Sprites
		g_Game.PrecacheModel( "sprites/cs16/640hud1.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud4.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud1.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud4.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_csglock18.txt" );
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
		return Deploy( V_MODEL, P_MODEL, GLOCK_DRAW, "onehanded", GetBodygroup(), (49.0/45.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		m_iBurstLeft = 0; //Cancel burst
		CommonHolster();
		BaseClass.Holster( skipLocal );
	}

	private void FireWeapon()
	{
		Vector accuracy = self.BulletAccuracy( VECTOR_CONE_2DEGREES, VECTOR_CONE_1DEGREES, g_vecZero );

		ShootWeapon( SHOOT_S, 1, accuracy, 4096, DAMAGE );

		self.SendWeaponAnim( (self.m_iClip > 0) ? GLOCK_SHOOT3 : GLOCK_SHOOTEMPTY, 0, GetBodygroup() );

		m_pPlayer.pev.punchangle.x -= 0.5;
		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = DIM_GUN_FLASH;

		ShellEject( m_pPlayer, m_iShell, Vector( 21, 10, -7 ), true, false );
	}

	void PrimaryAttack()
	{
		if( self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15f;
			return;
		}

		if( WeaponFireMode == CS16BASE::MODE_BURST )
		{
			//Fire at most 3 bullets.
			m_iBurstCount = Math.min( 3, self.m_iClip );
			m_iBurstLeft = m_iBurstCount - 1;

			m_flNextBurstFireTime = WeaponTimeBase() + GetFireRate( 1200 );
			//Prevent primary attack before burst finishes. Might need to be finetuned.
			self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.425;
		}
		else
		{
			if( ( m_pPlayer.m_afButtonPressed & IN_ATTACK == 0 ) )
				return;

			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15;
		}

		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		FireWeapon();
	}

	void ItemPostFrame()
	{
		if( WeaponFireMode == CS16BASE::MODE_BURST )
		{
			if( m_iBurstLeft > 0 )
			{
				if( m_flNextBurstFireTime < WeaponTimeBase() )
				{
					if( self.m_iClip <= 0 )
					{
						m_iBurstLeft = 0;
						return;
					}
					else
						--m_iBurstLeft;

					FireWeapon();

					if( m_iBurstLeft > 0 )
						m_flNextBurstFireTime = WeaponTimeBase() + GetFireRate( 1200 );
					else
						m_flNextBurstFireTime = 0;
				}

				//While firing a burst, don't allow reload or any other weapon actions. Might be best to let some things run though.
				return;
			}
		}

		BaseClass.ItemPostFrame();
	}

	void SecondaryAttack()
	{
		switch( WeaponFireMode )
		{
			case CS16BASE::MODE_NORMAL:
			{
				WeaponFireMode = CS16BASE::MODE_BURST;
				g_EngineFuncs.ClientPrintf( m_pPlayer, print_center, "Switched to Burst Fire\n" );
				break;
			}
			case CS16BASE::MODE_BURST:
			{
				WeaponFireMode = CS16BASE::MODE_NORMAL;
				g_EngineFuncs.ClientPrintf( m_pPlayer, print_center, "Switched to Semi Auto\n" );
				break;
			}
		}
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.3f;
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		Reload( MAX_CLIP, GLOCK_RELOAD, (75.0/35.0), GetBodygroup() );

		BaseClass.Reload();
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( GLOCK_IDLE1, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

string GetName()
{
	return "weapon_csglock18";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CS_GLOCK::weapon_csglock18", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE ); // Register the weapon
}

} //Namespace end

/*

const int GLOCK18_DEFAULT_GIVE 	= 50;
const int GLOCK18_MAX_CLIP    	= 20;
const int GLOCK18_WEIGHT      	= 5;

class weapon_csglock18 : ScriptBasePlayerWeaponEntity
{
	private CBasePlayer@ m_pPlayer = null;
	int g_iCurrentMode;
	int m_iShell;
	int m_iShotsFired;
	int m_iBurstLeft = 0;
	int m_iBurstCount = 0;
	float m_flNextBurstFireTime = 0;
	
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/cs16/glock18/w_glock18.mdl" );

		self.m_iDefaultAmmo = GLOCK18_DEFAULT_GIVE;
		m_iShotsFired = 0;
		g_iCurrentMode = CS16_MODE_NOBURST;

		self.FallInit();
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		g_Game.PrecacheModel( "models/cs16/glock18/v_glock18.mdl" );
		g_Game.PrecacheModel( "models/cs16/glock18/w_glock18.mdl" );
		g_Game.PrecacheModel( "models/cs16/glock18/p_glock18.mdl" );

		m_iShell = g_Game.PrecacheModel( "models/cs16/shells/pshell.mdl" );

		g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/dryfire_pistol.wav" );
		g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/glock18-1.wav" );
		g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/glock18-2.wav" );
		g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/clipout1.wav" );
		g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/clipin1.wav" );
		g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/slideback1.wav" );
		g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/sliderelease1.wav" );

		g_SoundSystem.PrecacheSound( "weapons/cs16/dryfire_pistol.wav" );
		g_SoundSystem.PrecacheSound( "weapons/cs16/glock18-1.wav" );
		g_SoundSystem.PrecacheSound( "weapons/cs16/glock18-2.wav" );
		g_SoundSystem.PrecacheSound( "weapons/cs16/clipout1.wav" );
		g_SoundSystem.PrecacheSound( "weapons/cs16/clipin1.wav" );
		g_SoundSystem.PrecacheSound( "weapons/cs16/slideback1.wav" );
		g_SoundSystem.PrecacheSound( "weapons/cs16/sliderelease1.wav" );
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1  = CS_9mm_MAX_CARRY;
		info.iMaxAmmo2  = -1;
		info.iMaxClip   = GLOCK18_MAX_CLIP;
		info.iSlot		= 1;
		info.iPosition  = 6;
		info.iFlags		= 0;
		info.iWeight	= GLOCK18_WEIGHT;

		return true;
	}

	bool AddToPlayer( CBasePlayer@ pPlayer )
	{
		if( BaseClass.AddToPlayer( pPlayer ) )
		{
			@m_pPlayer = pPlayer;
			NetworkMessage csglock( MSG_ONE, NetworkMessages::WeapPickup, pPlayer.edict() );
				csglock.WriteLong( g_ItemRegistry.GetIdForName("weapon_csglock18") );
			csglock.End();
			return true;
		}

		return false;
	}

	bool PlayEmptySound()
	{
		if( self.m_bPlayEmptySound )
		{
			self.m_bPlayEmptySound = false;
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_AUTO, "weapons/cs16/dryfire_pistol.wav", 0.9, ATTN_NORM, 0, PITCH_NORM );
		}

		return false;
	}

	float WeaponTimeBase()
	{
		return g_Engine.time;
	}

	bool Deploy()
	{
		bool bResult;
		{
			bResult = self.DefaultDeploy( self.GetV_Model( "models/cs16/glock18/v_glock18.mdl" ), self.GetP_Model( "models/cs16/glock18/p_glock18.mdl" ), GLOCK18_DRAW, "onehanded" );

			float deployTime = 1.1;
			g_iCurrentMode = CS16_MODE_NOBURST;
			self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + deployTime;
			return bResult;
		}
	}

	void Holster( int skipLocal = 0 )
	{
		self.m_fInReload = false;
		//Cancel burst.

		g_iCurrentMode = CS16_MODE_NOBURST;
		m_iBurstLeft = 0;

		BaseClass.Holster( skipLocal );
	}

	void FireABullet()
	{
		if( self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15f;
			return;
		}
		
		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;
		
		--self.m_iClip;
		
		m_pPlayer.pev.effects |= EF_MUZZLEFLASH;
		
		if( g_iCurrentMode == CS16_MODE_BURST )
		{
			switch ( g_PlayerFuncs.SharedRandomLong( m_pPlayer.random_seed, 0, 1 ) )
			{
				case 0: self.SendWeaponAnim( GLOCK18_SHOOT1, 0, 0 ); break;
				case 1: self.SendWeaponAnim( GLOCK18_SHOOT2, 0, 0 ); break;
			}
		}
		else
		{
			self.SendWeaponAnim( GLOCK18_SHOOT3, 0, 0 );
		}
		
		if( self.m_iClip <= 0 )
		{
			self.SendWeaponAnim( GLOCK18_SHOOTEMPTY, 0, 0 );
		}

		m_pPlayer.FireBullets( 1, m_pPlayer.GetGunPosition(), m_pPlayer.GetAutoaimVector( AUTOAIM_5DEGREES ), VECTOR_CONE_2DEGREES, 8192, BULLET_PLAYER_CUSTOMDAMAGE, 2, 29 );

		m_pPlayer.SetAnimation( PLAYER_ATTACK1 );

		Vector vecSrc	= m_pPlayer.GetGunPosition();
		Vector vecAiming = m_pPlayer.GetAutoaimVector( AUTOAIM_5DEGREES );	

		int m_iBulletDamage = 18;

		if( self.m_iClip == 0 && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			m_pPlayer.SetSuitUpdate( "!HEV_AMO0", false, 0 );

		m_pPlayer.pev.punchangle.x = Math.RandomFloat( -0.7, -0.4 );

		//self.m_flNextPrimaryAttack = self.m_flNextPrimaryAttack + 0.15f;
		if( self.m_flNextPrimaryAttack < WeaponTimeBase() )
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15f;

		TraceResult tr;
		float x, y;
		g_Utility.GetCircularGaussianSpread( x, y );

		Vector vecDir = vecAiming + x * VECTOR_CONE_2DEGREES.x * g_Engine.v_right + y * VECTOR_CONE_2DEGREES.y * g_Engine.v_up;
		Vector vecEnd = vecSrc + vecDir * 4096;

		g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr );

		if( tr.flFraction < 1.0 )
		{
			if( tr.pHit !is null )
			{
				CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );

				if( pHit is null || pHit.IsBSPModel() == true )
					g_WeaponFuncs.DecalGunshot( tr, BULLET_PLAYER_MP5 );
			}
		}
		Vector vecShellVelocity, vecShellOrigin;

		//The last 3 parameters are unique for each weapon (this should be using an attachment in the model to get the correct position, but most models don't have that).
		CS16GetDefaultShellInfo( m_pPlayer, vecShellVelocity, vecShellOrigin, 21, 10, -7, true, false );

		//Lefthanded weapon, so invert the Y axis velocity to match.
		vecShellVelocity.y *= 1;
		
		g_EntityFuncs.EjectBrass( vecShellOrigin, vecShellVelocity, m_pPlayer.pev.angles[ 1 ], m_iShell, TE_BOUNCE_SHELL );
	}

	private void PlayFireSound()
	{
		switch ( g_PlayerFuncs.SharedRandomLong( m_pPlayer.random_seed, 0, 2 ) )
			{
				case 0: g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cs16/glock18-2.wav", 0.9, ATTN_NORM, 0, PITCH_NORM ); break;
				case 1: g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cs16/glock18-2.wav", 0.9, ATTN_NORM, 0, PITCH_NORM ); break;
				case 2: g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cs16/glock18-2.wav", 0.9, ATTN_NORM, 0, PITCH_NORM ); break;
			}
	}

	void PrimaryAttack()
	{
		if( m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD || self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15f;
			return;
		}
	
		//Burst fire is 3 rounds, we fire one now, the other 2 later.
	
		if( g_iCurrentMode == CS16_MODE_BURST )
		{
			//Fire at most 3 bullets.
			m_iBurstCount = Math.min( 3, self.m_iClip );
			m_iBurstLeft = m_iBurstCount - 1;

			m_flNextBurstFireTime = WeaponTimeBase() + 0.05;
			//Prevent primary attack before burst finishes. Might need to be finetuned.
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.77;

			if( m_iBurstCount == 3 )
			{
				g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cs16/glock18-1.wav", 0.9, ATTN_NORM, 0, PITCH_NORM );
			}
			else
			{
				//Fewer than 3 bullets left, play individual fire sounds.
				PlayFireSound();
			}
		}
		else if (g_iCurrentMode == CS16_MODE_NOBURST)
		{
			m_iShotsFired++;
			if( m_iShotsFired > 1 )
			{
				return;
			}

			self.m_flTimeWeaponIdle = WeaponTimeBase() + Math.RandomFloat( 10, 15 );
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.11;

			PlayFireSound();
		}

		FireABullet();
	}

	void SecondaryAttack()
	{
		switch( g_iCurrentMode )
		{
			case CS16_MODE_NOBURST:
			{
				g_iCurrentMode = CS16_MODE_BURST;
				g_EngineFuncs.ClientPrintf( m_pPlayer, print_center, " Switched to Burst Fire \n" );
				break;
			}
			case CS16_MODE_BURST:
			{
				g_iCurrentMode = CS16_MODE_NOBURST;
				g_EngineFuncs.ClientPrintf( m_pPlayer, print_center, " Switched to Semi Auto \n" );
				break;
			}
		}
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.3f;
	}

	void Reload()
	{
		if( self.m_iClip == GLOCK18_MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) == 0 )
			return;

		BaseClass.Reload();
		m_iBurstLeft = 0;
		self.DefaultReload( GLOCK18_MAX_CLIP, GLOCK18_RELOAD, 2.17, 0 );
	}

	//Overridden to prevent WeaponIdle from being blocked by holding down buttons.
	void ItemPostFrame()
	{
		//If firing bursts, handle next shot.
		if( m_iBurstLeft > 0 )
		{
			if( m_flNextBurstFireTime < WeaponTimeBase() )
			{
				if( self.m_iClip <= 0 )
				{
					m_iBurstLeft = 0;
					return;
				}
				else
				{
					--m_iBurstLeft;
				}

				if( m_iBurstCount < 3 )
				{
					PlayFireSound();
				}

				FireABullet();

				if( m_iBurstLeft > 0 )
					m_flNextBurstFireTime = WeaponTimeBase() + 0.1;
				else
					m_flNextBurstFireTime = 0;
			}

			//While firing a burst, don't allow reload or any other weapon actions. Might be best to let some things run though.
			return;
		}

		BaseClass.ItemPostFrame();
	}

	void WeaponIdle()
	{
		if( g_iCurrentMode == CS16_MODE_NOBURST )
		{
			if( self.m_flNextPrimaryAttack < WeaponTimeBase() )
			{
			// If the player is still holding the attack button, m_iShotsFired won't reset to 0
			// Preventing the automatic firing of the weapon
				if( !( ( m_pPlayer.pev.button & IN_ATTACK ) != 0 ) )
				{
					// Player released the button, reset now
					m_iShotsFired = 0;
				}
			}
		}
		self.ResetEmptySound();

		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( GLOCK18_IDLE1 );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + Math.RandomFloat( 10, 15 );
	}
}
 
string GetGLOCK18Name()
{
	return "weapon_csglock18";
}
 
void RegisterGLOCK18()
{
	g_CustomEntityFuncs.RegisterCustomEntity( GetGLOCK18Name(), GetGLOCK18Name() );
	g_ItemRegistry.RegisterWeapon( GetGLOCK18Name(), "cs16", "ammo_cs_9mm" );
}*/