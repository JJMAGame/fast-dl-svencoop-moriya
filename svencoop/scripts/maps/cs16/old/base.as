// Usage suited for Counter-Strike Weapons in Sven Co-op
// Author: KernCore

namespace CS16BASE
{ //Namespace start

bool UseCustomAmmo = true;

enum CS16_ZOOM_OPTIONS
{
	ZOOM_OUT = 0,
	ZOOM_4X,
	ZOOM_8X
};

enum CS16_SUPPRESSOR_OPTIONS
{
	NO_SUPPRESSOR = 0,
	SUPPRESSED
};

enum CS16_BURST_OPTIONS
{
	NO_BURST = 0,
	BURST_ENGAGED
};

// For Dual Berettas
enum ShootPos
{
	SHOOTPOS_LEFT = 0,
	SHOOTPOS_RIGHT
};

enum FireModes
{
	MODE_NORMAL = 0,
	MODE_BURST
};

const string EMPTY_RIFLE_S  	= "weapons/cs16/dryfire_rifle.wav";
const string EMPTY_PISTOL_S 	= "weapons/cs16/dryfire_pistol.wav";
const string ZOOM_S         	= "weapons/cs16/zoom.wav";
const string SHELL_PISTOL   	= "models/cs16/shells/pshell.mdl";
const string SHELL_RIFLE    	= "models/cs16/shells/rshell.mdl";
const string SHELL_SNIPER   	= "models/cs16/shells/rshell_big.mdl";
const string SHELL_SHOTGUN  	= "models/hlclassic/shotgunshell.mdl";

// Precaches an array of sounds
void PrecacheSound( const array<string> pSound )
{
	for( uint i = 0; i < pSound.length(); i++ )
	{
		g_SoundSystem.PrecacheSound( pSound[i] );
		g_Game.PrecacheGeneric( "sound/" + pSound[i] );
	}
}

mixin class WeaponBase
{
	protected uint m_iShotsFired;
	protected int WeaponSilMode;
	protected int WeaponZoomMode;
	protected int WeaponFireMode;
	private bool m_iDirection = true;
	protected int ShootMode;

	string g_watersplash_spr = "sprites/wep_smoke_01.spr";

	void CommonPrecache()
	{
		g_Game.PrecacheModel( g_watersplash_spr );
		g_Game.PrecacheModel( "sprites/bubble.spr" );
		g_SoundSystem.PrecacheSound( "player/pl_slosh1.wav" );
		g_SoundSystem.PrecacheSound( "player/pl_slosh2.wav" );
		g_SoundSystem.PrecacheSound( "player/pl_slosh3.wav" );
		g_SoundSystem.PrecacheSound( "items/9mmclip1.wav" );
		g_SoundSystem.PrecacheSound( "items/gunpickup2.wav" );
	}

	void te_bubbletrail( Vector start, Vector end, string sprite = "sprites/bubble.spr", float height = 128.0f, uint8 count = 16, float speed = 16.0f )
	{
		NetworkMessage BTrail( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
			BTrail.WriteByte( TE_BUBBLETRAIL);
			BTrail.WriteCoord( start.x );
			BTrail.WriteCoord( start.y );
			BTrail.WriteCoord( start.z );
			BTrail.WriteCoord( end.x );
			BTrail.WriteCoord( end.y );
			BTrail.WriteCoord( end.z );
			BTrail.WriteCoord( height );
			BTrail.WriteShort( g_EngineFuncs.ModelIndex( sprite ) );
			BTrail.WriteByte( count );
			BTrail.WriteCoord( speed );
		BTrail.End();
	}

	void te_spritespray( Vector pos, Vector velocity, string sprite = "sprites/bubble.spr", uint8 count = 8, uint8 speed = 16, uint8 noise = 255 )
	{
		NetworkMessage SSpray( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
			SSpray.WriteByte( TE_SPRITE_SPRAY );
			SSpray.WriteCoord( pos.x );
			SSpray.WriteCoord( pos.y );
			SSpray.WriteCoord( pos.z );
			SSpray.WriteCoord( velocity.x );
			SSpray.WriteCoord( velocity.y );
			SSpray.WriteCoord( velocity.z );
			SSpray.WriteShort( g_EngineFuncs.ModelIndex( sprite ) );
			SSpray.WriteByte( count );
			SSpray.WriteByte( speed );
			SSpray.WriteByte( noise );
		SSpray.End();

		switch( Math.RandomLong( 0, 2 ) )
		{
			case 0: g_SoundSystem.PlaySound( self.edict(), CHAN_STREAM, "player/pl_slosh1.wav", 1, ATTN_NORM, 0, PITCH_NORM, 0, true, pos ); break;
			case 1: g_SoundSystem.PlaySound( self.edict(), CHAN_STREAM, "player/pl_slosh2.wav", 1, ATTN_NORM, 0, PITCH_NORM, 0, true, pos ); break;
			case 2: g_SoundSystem.PlaySound( self.edict(), CHAN_STREAM, "player/pl_slosh3.wav", 1, ATTN_NORM, 0, PITCH_NORM, 0, true, pos ); break;
		}
	}

	// water splashes and bubble trails for bullets
	void water_bullet_effects( Vector vecSrc, Vector vecEnd )
	{
		// bubble trails
		bool startInWater   	= g_EngineFuncs.PointContents( vecSrc ) == CONTENTS_WATER;
		bool endInWater     	= g_EngineFuncs.PointContents( vecEnd ) == CONTENTS_WATER;
		if( startInWater or endInWater )
		{
			Vector bubbleStart	= vecSrc;
			Vector bubbleEnd	= vecEnd;
			Vector bubbleDir	= bubbleEnd - bubbleStart;
			float waterLevel;

			// find water level relative to trace start
			Vector waterPos 	= (startInWater) ? bubbleStart : bubbleEnd;
			waterLevel      	= g_Utility.WaterLevel( waterPos, waterPos.z, waterPos.z + 1024 );
			waterLevel      	-= bubbleStart.z;

			// get percentage of distance travelled through water
			float waterDist	= 1.0f; 
			if( !startInWater or !endInWater )
				waterDist	-= waterLevel / (bubbleEnd.z - bubbleStart.z);
			if( !endInWater )
				waterDist	= 1.0f - waterDist;

			// clip trace to just the water portion
			if( !startInWater )
				bubbleStart	= bubbleEnd - bubbleDir*waterDist;
			else if( !endInWater )
				bubbleEnd 	= bubbleStart + bubbleDir*waterDist;

			// a shitty attempt at recreating the splash effect
			Vector waterEntry = (endInWater) ? bubbleStart : bubbleEnd;
			if( !startInWater or !endInWater )
			{
				te_spritespray( waterEntry, Vector( 0, 0, 1 ), g_watersplash_spr, 1, 64, 0);
			}

			// waterlevel must be relative to the starting point
			if( !startInWater or !endInWater )
				waterLevel = (bubbleStart.z > bubbleEnd.z) ? 0 : bubbleEnd.z - bubbleStart.z;

			// calculate bubbles needed for an even distribution
			int numBubbles = int( ( bubbleEnd - bubbleStart ).Length() / 128.0f );
			numBubbles = Math.max( 1, Math.min( 255, numBubbles ) );

			//te_bubbletrail( bubbleStart, bubbleEnd, "sprites/bubble.spr", waterLevel, numBubbles, 16.0f );
		}
	}

	void CommonSpawn( const string worldModel, const int GiveDefaultAmmo )
	{
		g_EntityFuncs.SetModel( self, worldModel );
		self.m_iDefaultAmmo = GiveDefaultAmmo;

		self.FallInit();
	}

	bool CommonAddToPlayer( CBasePlayer@ pPlayer )
	{
		if( !BaseClass.AddToPlayer( pPlayer ) )
			return false;

		NetworkMessage weapon( MSG_ONE, NetworkMessages::WeapPickup, pPlayer.edict() );
			weapon.WriteLong( g_ItemRegistry.GetIdForName( self.pev.classname ) );
		weapon.End();

		return true;
	}

	bool CheckButton()
	{
		return m_pPlayer.pev.button & IN_ATTACK != 0 || m_pPlayer.pev.button & IN_ATTACK2 != 0 || m_pPlayer.pev.button & IN_ALT1 != 0;
	}

	bool CommonPlayEmptySound( const string emptySound )
	{
		if( self.m_bPlayEmptySound )
		{
			//self.m_bPlayEmptySound = false;
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_STREAM, emptySound, 0.9, ATTN_NORM, 0, PITCH_NORM );
		}

		return false;
	}

	float WeaponTimeBase()
	{
		return g_Engine.time;
	}

	edict_t@ ENT( const entvars_t@ pev )
	{
		return pev.pContainingEntity;
	}

	void Reload( int iAmmo, int iAnim, float iTimer, int iBodygroup )
	{
		m_iShotsFired = 0;
		self.DefaultReload( iAmmo, iAnim, iTimer, iBodygroup );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + iTimer;
	}

	bool Deploy( string& in vmodel, string& in pmodel, int& in iAnim, string& in pAnim, int& in iBodygroup, float deployTime )
	{
		self.DefaultDeploy( self.GetV_Model( vmodel ), self.GetP_Model( pmodel ), iAnim, pAnim, 0, iBodygroup );
		self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = WeaponTimeBase() + deployTime;
		return true;
	}

	/*
	=================
	EV_GetDefaultShellInfo
	 
	Determine where to eject shells from
	Taken from the HL SDK
	Conversion by Solokiller
	Finetunning by KernCore
	=================
	*/
	/**
	*   This function calculates the origin and velocity for a shell ejected at the given location.
	*   @param pPlayer Player to use for calculations.
	*   @param ShellVelocity The velocity of the shell. The shell velocity will point to the right of the screen (righthanded weapon with ejection to the right).
	*   @param ShellOrigin The origin of the shell. This is where the shell starts.
	*   @param forwardScale X offset for the shell. Positive values move further out, negative values place it behind the player.
	*   @param rightScale Y offset for the shell. Positive values move to the right, negative values move to the left.
	*   @param upScale Z offset for the shell. Positive values move up, negative values move down.
	*   @param leftShell will send the shell to the left if true, to the right if false
	*   @param downShell will send the shell down if true, up if false
	*/

	// Precise shell casting
	void GetDefaultShellInfo( CBasePlayer@ pPlayer, Vector& out ShellVelocity, Vector& out ShellOrigin, float forwardScale, float rightScale, float upScale, bool leftShell, bool downShell )
	{
		Vector vecForward, vecRight, vecUp;

		g_EngineFuncs.AngleVectors( pPlayer.pev.v_angle, vecForward, vecRight, vecUp );

		const float fR = (leftShell == true) ? Math.RandomFloat( -120, -60 ) : Math.RandomFloat( 60, 120 );
		const float fU = (downShell == true) ? Math.RandomFloat( -150, -90 ) : Math.RandomFloat( 90, 150 );

		for( int i = 0; i < 3; ++i )
		{
			ShellVelocity[i] = pPlayer.pev.velocity[i] + vecRight[i] * fR + vecUp[i] * fU + vecForward[i] * Math.RandomFloat( 1, 50 );
			ShellOrigin[i]   = pPlayer.pev.origin[i] + pPlayer.pev.view_ofs[i] + vecUp[i] * upScale + vecForward[i] * forwardScale + vecRight[i] * rightScale;
		}
	}

	void KickBack( float up_base, float lateral_base, float up_modifier, float lateral_modifier, float up_max, float lateral_max, int direction_change )
	{
		float flFront, flSide;

		if( m_iShotsFired == 1 )
		{
			flFront = up_base;
			flSide = lateral_base;
		}
		else
		{
			flFront = m_iShotsFired * up_modifier + up_base;
			flSide = m_iShotsFired * lateral_modifier + lateral_base;
		}

		m_pPlayer.pev.punchangle.x -= flFront;

		if( m_pPlayer.pev.punchangle.x < -up_max )
			m_pPlayer.pev.punchangle.x = -up_max;

		if( m_iDirection )
		{
			m_pPlayer.pev.punchangle.y += flSide;

			if( m_pPlayer.pev.punchangle.y > lateral_max )
				m_pPlayer.pev.punchangle.y = lateral_max;
		}
		else
		{
			m_pPlayer.pev.punchangle.y -= flSide;

			if( m_pPlayer.pev.punchangle.y < -lateral_max )
				m_pPlayer.pev.punchangle.y = -lateral_max;
		}

		if( Math.RandomLong( 0, direction_change ) == 0 )
		{
			m_iDirection = !m_iDirection;
		}
	}

	void CommonHolster()
	{
		WeaponZoomMode = CS16BASE::ZOOM_OUT;
		self.m_fInReload = false;
		SetThink( null );
		m_iShotsFired = 0;
		m_pPlayer.pev.maxspeed = 0;
	}

	// Realistic Firerate
	float GetFireRate( float& in roundspmin )
	{
		float firerate;
		roundspmin = (roundspmin / 60);
		firerate = (1 / roundspmin);
		return firerate;
	}

	void DestroyThink()
	{
		self.DestroyItem();
	}

	void SetFOV( int fov )
	{
		m_pPlayer.pev.fov = m_pPlayer.m_iFOV = fov;
	}
	
	void ToggleZoom( int zoomedFOV )
	{
		if ( self.m_fInZoom == true )
		{
			SetFOV( 0 ); // 0 means reset to default fov
		}
		else if ( self.m_fInZoom == false )
		{
			SetFOV( zoomedFOV );
		}
	}

	void FoVOFF()
	{
		WeaponZoomMode = CS16BASE::ZOOM_OUT;
		ToggleZoom( 0 );
		m_pPlayer.pev.maxspeed = 0;
	}

	void ShellEject( CBasePlayer@ pPlayer, int& in mShell, Vector& in Pos, bool leftShell = false, bool downShell = false, TE_BOUNCE shelltype = TE_BOUNCE_SHELL )
	{
		Vector vecShellVelocity, vecShellOrigin;
		GetDefaultShellInfo( pPlayer, vecShellVelocity, vecShellOrigin, Pos.x, Pos.y, Pos.z, leftShell, downShell );
		vecShellVelocity.y *= 1;
		g_EntityFuncs.EjectBrass( vecShellOrigin, vecShellVelocity, pPlayer.pev.angles.y, mShell, shelltype );
	}

	void ShootWeapon( const string Sound, const uint numShots, Vector& in CONE, float maxDist, const int Damage, const bool isAkimbo = false )
	{
		--self.m_iClip;
		m_iShotsFired++;
		g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, Sound, Math.RandomFloat( 0.95, 1.0 ), ATTN_NORM, 0, 93 + Math.RandomLong( 0, 0xf ) );

		Vector vecSrc   	= m_pPlayer.GetGunPosition();
		Vector vecAiming 	= m_pPlayer.GetAutoaimVector( AUTOAIM_5DEGREES );

		m_pPlayer.FireBullets( numShots, vecSrc, vecAiming, CONE, maxDist, BULLET_PLAYER_CUSTOMDAMAGE, 2, Damage );

		if( self.m_iClip == 0 && m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			m_pPlayer.SetSuitUpdate( "!HEV_AMO0", false, 0 );

		m_pPlayer.pev.effects |= EF_MUZZLEFLASH;
		self.pev.effects |= EF_MUZZLEFLASH;

		if( isAkimbo )
		{
			switch( ShootMode )
			{
				case SHOOTPOS_LEFT:
				{
					m_pPlayer.m_szAnimExtension = "uzis_right";
					ShootMode = SHOOTPOS_RIGHT;
					break;
				}
				case SHOOTPOS_RIGHT:
				{
					m_pPlayer.m_szAnimExtension = "uzis_left";
					ShootMode = SHOOTPOS_LEFT;
					break;
				}
			}
		}

		m_pPlayer.SetAnimation( PLAYER_ATTACK1 );

		if( self.m_iClip == 0 )
			m_pPlayer.m_flNextAttack = 0.5;

		TraceResult tr;
		float x, y;

		for( uint uiPellet = 0; uiPellet < numShots; ++uiPellet )
		{
			g_Utility.GetCircularGaussianSpread( x, y );

			Vector vecDir = vecAiming + x * CONE.x * g_Engine.v_right + y * CONE.y * g_Engine.v_up;
			Vector vecEnd = vecSrc + vecDir * maxDist;

			g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr );

			if( tr.flFraction < 1.0 )
			{
				if( tr.pHit !is null )
				{
					CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );

					g_SoundSystem.PlayHitSound( tr, vecSrc, vecSrc + (vecEnd - vecSrc) * 2, BULLET_PLAYER_CUSTOMDAMAGE );

					if( tr.fInWater == 0.0 )
						water_bullet_effects( vecSrc, tr.vecEndPos );
					
					if( pHit is null || pHit.IsBSPModel() == true )
						g_WeaponFuncs.DecalGunshot( tr, BULLET_PLAYER_CUSTOMDAMAGE );
				}
			}
		}
	}

	protected TraceResult m_trHit;

	bool Swing( int fFirst, float fldistance, int ianimation, int ibodygroup, float flattack_speed, float flDamage )
	{
		bool fDidHit = false;

		TraceResult tr;

		Math.MakeVectors( m_pPlayer.pev.v_angle );
		Vector vecSrc	= m_pPlayer.GetGunPosition();
		Vector vecEnd	= vecSrc + g_Engine.v_forward * fldistance;

		g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr );

		if( tr.flFraction >= 1.0 )
		{
			g_Utility.TraceHull( vecSrc, vecEnd, dont_ignore_monsters, head_hull, m_pPlayer.edict(), tr );
			if ( tr.flFraction < 1.0 )
			{
				// Calculate the point of intersection of the line (or hull) and the object we hit
				// This is and approximation of the "best" intersection
				CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );
				if ( pHit is null || pHit.IsBSPModel() )
					g_Utility.FindHullIntersection( vecSrc, tr, tr, VEC_DUCK_HULL_MIN, VEC_DUCK_HULL_MAX, m_pPlayer.edict() );

				vecEnd = tr.vecEndPos;	// This is the point on the actual surface (the hull could have hit space)
			}
		}

		if( tr.flFraction >= 1.0 )
		{
			if( fFirst != 0 )
			{
				// miss
				self.SendWeaponAnim( ianimation, 0, ibodygroup );

				//EffectsFOVOFF();
				//m_pPlayer.pev.punchangle.z = Math.RandomLong( -7, -5 );
				self.m_flNextPrimaryAttack  = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = g_Engine.time + flattack_speed;
				self.m_flTimeWeaponIdle = g_Engine.time + flattack_speed + 0.5f;
			}
		}
		else
		{
			// hit
			fDidHit = true;
			CBaseEntity@ pEntity = g_EntityFuncs.Instance( tr.pHit );

			self.SendWeaponAnim( ianimation, 0, ibodygroup );
			//EffectsFOVOFF();
			//m_pPlayer.pev.punchangle.z = Math.RandomLong( -7, -5 );

			if ( self.m_flCustomDmg > 0 )
				flDamage = self.m_flCustomDmg;

			g_WeaponFuncs.ClearMultiDamage();
			if ( self.m_flNextTertiaryAttack + flattack_speed < g_Engine.time )
			{
				// first swing does full damage and will launch the enemy a bit
				pEntity.TraceAttack( m_pPlayer.pev, flDamage, g_Engine.v_forward, tr, DMG_CLUB | DMG_LAUNCH );
			}
			else
			{
				// subsequent swings do 75% (Changed -Sniper/KernCore) (75% less damage)
				pEntity.TraceAttack( m_pPlayer.pev, flDamage * 0.75, g_Engine.v_forward, tr, DMG_CLUB | DMG_LAUNCH );
			}	
			g_WeaponFuncs.ApplyMultiDamage( m_pPlayer.pev, m_pPlayer.pev );

			float flVol = 1.0;
			bool fHitWorld = true;

			if( pEntity !is null )
			{
				self.m_flNextPrimaryAttack  = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = g_Engine.time + flattack_speed;
				self.m_flTimeWeaponIdle = g_Engine.time + flattack_speed + 0.5f;

				if( pEntity.Classify() != CLASS_NONE && pEntity.Classify() != CLASS_MACHINE && pEntity.BloodColor() != DONT_BLEED )
				{
					if( pEntity.IsPlayer() )
					{
						pEntity.pev.velocity = pEntity.pev.velocity + (self.pev.origin - pEntity.pev.origin).Normalize() * 120;
					}

					//g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_ITEM, BayoHitFlesh[ Math.RandomLong( 0, BayoHitFlesh.length() - 1 )], 1, ATTN_NORM );

					m_pPlayer.m_iWeaponVolume = 128; 
					if( !pEntity.IsAlive() )
						return true;
					else
						flVol = 0.1;

					fHitWorld = false;
				}
			}

			if( fHitWorld == true )
			{
				float fvolbar = g_SoundSystem.PlayHitSound( tr, vecSrc, vecSrc + (vecEnd - vecSrc) * 2, BULLET_PLAYER_CROWBAR | BULLET_NONE );
				
				self.m_flNextPrimaryAttack  = self.m_flNextSecondaryAttack = self.m_flNextTertiaryAttack = g_Engine.time + flattack_speed;
				self.m_flTimeWeaponIdle = g_Engine.time + flattack_speed + 0.5f;
				
				// override the volume here, cause we don't play texture sounds in multiplayer, 
				// and fvolbar is going to be 0 from the above call.
				fvolbar = 1;

				// also play crowbar strike
				//g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_ITEM, BayoHitWorld[ Math.RandomLong( 0, BayoHitWorld.length() - 1 )], fvolbar, ATTN_NORM, 0, 98 + Math.RandomLong( 0, 3 ) ); 
			}

			// delay the decal a bit
			m_trHit = tr;
			g_WeaponFuncs.DecalGunshot( m_trHit, BULLET_PLAYER_CROWBAR );
			m_pPlayer.m_iWeaponVolume = int( flVol * 512 ); 
		}
		return fDidHit;
	}
}

mixin class AmmoBase
{
	bool CommonAddAmmo( CBaseEntity@ pOther, int& in iAmmoClip, int& in iAmmoCarry, string& in iAmmoType )
	{
		if( pOther.GiveAmmo( iAmmoClip, iAmmoType, iAmmoCarry ) != -1 )
		{
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
			return true;
		}
		return false;
	}
}

}// Namespace end