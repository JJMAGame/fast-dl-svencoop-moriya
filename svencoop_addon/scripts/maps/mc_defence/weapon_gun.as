// CS16 Script
// Author: Zorbos

// Convert from that
// Counters78 and [SvenCoop]TenKo

enum GUNAnimation
{
	GUN_IDLE = 0,
	GUN_IDLE2,
	GUN_LAUNCH,
	GUN_RELOAD,
	GUN_DEPLOY,
	GUN_FIRE1,
	GUN_FIRE2,
	GUN_FIRE3
};

const int GUN_DEFAULT_GIVE 	= 120;
const int GUN_MAX_CLIP     	= 30;
const int GUN_WEIGHT       	= 25;
const int GUN_MAX_CARRY		= 999;

class weapon_gun : ScriptBasePlayerWeaponEntity
{
	private CBasePlayer@ m_pPlayer = null;
	int m_iShell;

	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/mc_defence/w_gun.mdl" );
		
		self.m_iDefaultAmmo = GUN_DEFAULT_GIVE;
		
		self.FallInit();
	}
	
	void Precache()
	{
		self.PrecacheCustomModels();
		g_Game.PrecacheModel( "models/mc_defence/v_gun.mdl" );
		g_Game.PrecacheModel( "models/mc_defence/w_gun.mdl" );
		g_Game.PrecacheModel( "models/mc_defence/p_gun.mdl" );
		g_Game.PrecacheModel( "models/mc_defence/item_ammobox.mdl" );

		m_iShell = g_Game.PrecacheModel ( "models/shell.mdl" );
		
		g_Game.PrecacheGeneric( "sound/" + "weapons/dryfire_rifle.wav" );
		g_Game.PrecacheGeneric( "sound/" + "mc_defence/shoot.wav" );
		g_Game.PrecacheGeneric( "sound/" + "mc_defence/deploy.wav" );
		g_Game.PrecacheGeneric( "sound/" + "mc_defence/reload_clipin.wav" );
		g_Game.PrecacheGeneric( "sound/" + "mc_defence/reload_clipout.wav" );
		
		g_SoundSystem.PrecacheSound( "weapons/dryfire_rifle.wav" );
		g_SoundSystem.PrecacheSound( "mc_defence/shoot.wav" );
		g_SoundSystem.PrecacheSound( "mc_defence/deploy.wav" );
		g_SoundSystem.PrecacheSound( "mc_defence/reload_clipin.wav" );
		g_SoundSystem.PrecacheSound( "mc_defence/reload_clipout.wav" );

		g_Game.PrecacheGeneric( "sprites/" + "mc_defence/forgun.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "mc_defence/weapon_gun.txt" );
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= GUN_MAX_CARRY;
		info.iMaxAmmo2 	= -1;
		info.iMaxClip 	= GUN_MAX_CLIP;
		info.iSlot   	= 3;
		info.iPosition 	= 15;
		info.iFlags  	= 0;
		info.iWeight 	= GUN_WEIGHT;

		return true;
	}

	bool AddToPlayer( CBasePlayer@ pPlayer )
	{
		if( BaseClass.AddToPlayer( pPlayer ) )
		{
			@m_pPlayer = pPlayer;
			NetworkMessage gun( MSG_ONE, NetworkMessages::WeapPickup, pPlayer.edict() );
				gun.WriteLong( g_ItemRegistry.GetIdForName("weapon_gun") );
			gun.End();
			return true;
		}

		return false;
	}

	bool PlayEmptySound()
	{
		if( self.m_bPlayEmptySound )
		{
			self.m_bPlayEmptySound = false;
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_AUTO, "weapons/dryfire_rifle.wav", 0.9, ATTN_NORM, 0, PITCH_NORM );
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
			bResult = self.DefaultDeploy ( self.GetV_Model( "models/mc_defence/v_gun.mdl" ), self.GetP_Model( "models/mc_defence/p_gun.mdl" ), GUN_DEPLOY, "m16" );
		
			float deployTime = 1;
			self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = g_Engine.time + deployTime;
			return bResult;
		}
	}
	
	void Holster( int skipLocal = 0 )
	{
		self.m_fInReload = false;
		BaseClass.Holster( skipLocal );
	}
	
	void PrimaryAttack()
	{
		if( m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD || self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15f;
			return;
		}
		
		self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.095;
		
		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;
		
		--self.m_iClip;
		
		self.m_flTimeWeaponIdle = g_Engine.time + 1.5;
		
		m_pPlayer.pev.effects |= EF_MUZZLEFLASH;

		m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
		
		switch ( g_PlayerFuncs.SharedRandomLong( m_pPlayer.random_seed, 0, 2 ) )
		{
			case 0: self.SendWeaponAnim( GUN_FIRE1, 0, 0 ); break;
			case 1: self.SendWeaponAnim( GUN_FIRE2, 0, 0 ); break;
			case 2: self.SendWeaponAnim( GUN_FIRE3, 0, 0 ); break;
		}


		g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "mc_defence/shoot.wav", 0.9, ATTN_NORM, 0, PITCH_NORM );

		Vector vecSrc	 = m_pPlayer.GetGunPosition();
		Vector vecAiming = m_pPlayer.GetAutoaimVector( AUTOAIM_5DEGREES );
		
		int m_iBulletDamage = 26;
		
		m_pPlayer.FireBullets( 1, vecSrc, vecAiming, VECTOR_CONE_6DEGREES, 8192, BULLET_PLAYER_CUSTOMDAMAGE, 2, m_iBulletDamage );

		if( self.m_iClip == 0 && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			m_pPlayer.SetSuitUpdate( "!HEV_AMO0", false, 0 );

		m_pPlayer.pev.punchangle.x = Math.RandomFloat( -1.7f, -1.2f );

		//self.m_flNextPrimaryAttack = self.m_flNextPrimaryAttack + 0.15f;
		if( self.m_flNextPrimaryAttack < WeaponTimeBase() )
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15f;

		self.m_flTimeWeaponIdle = WeaponTimeBase() + Math.RandomFloat( 10, 15 );
		
		TraceResult tr;
		
		float x, y;
		
		g_Utility.GetCircularGaussianSpread( x, y );
		
		Vector vecDir = vecAiming + x * VECTOR_CONE_2DEGREES.x * g_Engine.v_right + y * VECTOR_CONE_2DEGREES.y * g_Engine.v_up;

		Vector vecEnd	= vecSrc + vecDir * 4096;

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
		MCFORSHELL( m_pPlayer, vecShellVelocity, vecShellOrigin, 21, 12, -9, true, false );
		//Lefthanded weapon, so invert the Y axis velocity to match.
		vecShellVelocity.y *= 1;
		g_EntityFuncs.EjectBrass( vecShellOrigin, vecShellVelocity, m_pPlayer.pev.angles[ 1 ], m_iShell, TE_BOUNCE_SHELL );
	}

	void Reload()
	{
		if( self.m_iClip == GUN_MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) == 0 )
			return;
		
		self.DefaultReload( GUN_MAX_CLIP, GUN_RELOAD, 1.459, 0 );
		BaseClass.Reload();
	}
	
	void WeaponIdle()
	{
		self.ResetEmptySound();

		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );
		
		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;
		
		self.SendWeaponAnim( GUN_IDLE );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + Math.RandomFloat( 10, 15 );
	}
}
class AMMOBOX : ScriptBasePlayerAmmoEntity
{
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/mc_defence/item_ammobox.mdl" );
		BaseClass.Spawn();
	}
	
	void Precache()
	{
		g_Game.PrecacheModel( "models/mc_defence/item_ammobox.mdl" );
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
	}

	bool AddAmmo( CBaseEntity@ pither )
	{
		int iGive;
		
		iGive = GUN_DEFAULT_GIVE;
		
		if( pither.GiveAmmo( iGive, "ammo_ammobox", GUN_MAX_CARRY ) != -1 )
		{
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
			return true;
		}
		return false;
	}
}

string GetAMMOBOX()
{
	return "ammo_ammobox";
}

void RegisterAMMOBOX()
{
	g_Game.PrecacheModel( "models/mc_defence/item_ammobox.mdl" );
	g_CustomEntityFuncs.RegisterCustomEntity( "AMMOBOX", GetAMMOBOX() );
}


string GetGUNName()
{
	return "weapon_gun";
}

void RegisterGUN()
{
	g_CustomEntityFuncs.RegisterCustomEntity( GetGUNName(), GetGUNName() );
	g_ItemRegistry.RegisterWeapon( GetGUNName(), "mc_defence", "ammo_ammobox" );
}