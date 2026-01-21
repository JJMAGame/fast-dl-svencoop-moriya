// Poke646 Script
// Weapon Script: Bow Rifle
// Author: Zorbos

// Convert from that
// Counters78 and [SvenCoop]TenKo

const float BOW_MOD_DAMAGE = 100.0;
const float BOW_MOD_FIRERATE = 0;
const int BOW_MOD_PROJ_SPEED = 1500;
const int BOW_MOD_PROJ_SPEED_UNDERWATER = 1500;

const int BOW_DEFAULT_AMMO 	= 20;
const int BOW_MAX_CARRY 		= 50;
const int BOW_MAX_CLIP 		= 1;
const int BOW_WEIGHT 		= 8;

enum BOWAnimation
{
	BOW_IDLE1 = 0,
	BOW_IDLE2,
	BOW_SHOOT,
	BOW_RELOAD
};

class weapon_bow : ScriptBasePlayerWeaponEntity
{
	private CBasePlayer@ m_pPlayer = null;
	
	bool m_fInReload = false;
	int m_iZoomLevel;
	
	void Spawn()
	{
		Precache();
		g_EntityFuncs.SetModel( self, "models/mc_defence/w_bow.mdl" );
		
		self.m_iDefaultAmmo = BOW_DEFAULT_AMMO;

		self.FallInit();// get ready to fall
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		g_Game.PrecacheModel( "models/mc_defence/v_bow.mdl" );
		g_Game.PrecacheModel( "models/mc_defence/w_bow.mdl" );
		g_Game.PrecacheModel( "models/mc_defence/p_bow.mdl" );

		g_Game.PrecacheModel( "models/crossbow_bolt.mdl" );

		g_Game.PrecacheGeneric( "sound/" + "mc_defence/bow.wav" );
		g_SoundSystem.PrecacheSound( "mc_defence/bow.wav" );

		g_Game.PrecacheGeneric( "sprites/" + "mc_defence/weapon_bow.txt" );
	}

	bool AddToPlayer( CBasePlayer@ pPlayer )
	{
		if( BaseClass.AddToPlayer( pPlayer ) )
		{
			@m_pPlayer = pPlayer;
			NetworkMessage bow( MSG_ONE, NetworkMessages::WeapPickup, pPlayer.edict() );
				bow.WriteLong( g_ItemRegistry.GetIdForName("weapon_bow") );
			bow.End();
			return true;
		}
		
		return false;
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= BOW_MAX_CARRY;
		info.iMaxAmmo2 	= -1;
		info.iMaxClip 	= BOW_MAX_CLIP;
		info.iSlot 		= 2;
		info.iPosition 	= 13;
		info.iFlags 	= 0;
		info.iWeight 	= BOW_WEIGHT;

		return true;
	}

	bool Deploy()
	{
		m_iZoomLevel = 0; // Reset zoom state
		return self.DefaultDeploy( self.GetV_Model( "models/mc_defence/v_bow.mdl" ), self.GetP_Model( "models/mc_defence/p_bow.mdl" ), BOW_IDLE1, "bow" );
	}

	float WeaponTimeBase()
	{
		return g_Engine.time; //g_WeaponFuncs.WeaponTimeBase();
	}

	void Holster( int skipLocal = 0 )
	{
		self.m_fInReload = true;
		m_pPlayer.m_flNextAttack = WeaponTimeBase() + 0.7f;
		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		if( self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			self.m_flNextPrimaryAttack = WeaponTimeBase() + BOW_MOD_FIRERATE;
			return;
		}

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = NORMAL_GUN_FLASH;

		self.SendWeaponAnim( BOW_SHOOT, 0, 0 );

		--self.m_iClip;

		g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "mc_defence/bow.wav", 1.0, ATTN_NORM, 0, 95 + Math.RandomLong( 0, 10 ) );

		// player "shoot" animation
		m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
		
		Vector vecBoltOrigin = m_pPlayer.GetGunPosition();
		Vector vecDir = g_Engine.v_forward;
		Vector vecSpeed;
		
		if( m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD )
			vecSpeed = vecDir * BOW_MOD_PROJ_SPEED_UNDERWATER;
		else
			vecSpeed = vecDir * BOW_MOD_PROJ_SPEED;
		
		CBaseEntity@ pBolt = g_EntityFuncs.Create("crossbow_bolt", vecBoltOrigin, m_pPlayer.pev.v_angle, false, m_pPlayer.edict());
		pBolt.pev.dmg = BOW_MOD_DAMAGE;
		pBolt.pev.velocity = vecSpeed;
			
		m_pPlayer.pev.punchangle.x = Math.RandomLong( -3, 3 );

		self.m_flNextPrimaryAttack = WeaponTimeBase() + BOW_MOD_FIRERATE;

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed,  10, 15 );
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( BOW_IDLE1 );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed,  10, 15 );// how long till we do this again.
	}

	bool PlayEmptySound()
	{
		if( self.m_bPlayEmptySound )
		{
			self.m_bPlayEmptySound = false;
			
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/dryfire.wav", 0.8, ATTN_NORM, 0, PITCH_NORM );
		}
		
		return false;
	}

	void Reload()
	{
		if( WeaponTimeBase() < self.m_flNextPrimaryAttack )
			return;
			
		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 || self.m_iClip >= BOW_MAX_CLIP )
			return;

		self.DefaultReload( BOW_MAX_CLIP, BOW_RELOAD, 0.9, 0 );

		BaseClass.Reload();
		return;
	}
}

string GetBOWName()
{
	return "weapon_bow";
}

void RegisterBOW()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "weapon_bow", GetBOWName() );
	g_ItemRegistry.RegisterWeapon( GetBOWName(), "mc_defence", "bolts" );
}