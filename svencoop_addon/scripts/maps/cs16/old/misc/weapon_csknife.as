//Counter-Strike 1.6 Knife
//Author: KernCore

#include "../base"

namespace CS_KNIFE
{ //Namespace Start

enum KnifeAnimation
{
	KNIFE_IDLE = 0,
	KNIFE_SLASH1,
	KNIFE_SLASH2,
	KNIFE_DRAW,
	KNIFE_STAB,
	KNIFE_STABMISS,
	KNIFE_MIDSLASH1,
	KNIFE_MIDSLASH2
};

// Models
const string W_MODEL 	= "models/cs16/csknife/w_knife.mdl";
const string V_MODEL 	= "models/cs16/csknife/v_knife.mdl";
const string P_MODEL 	= "models/cs16/csknife/p_knife.mdl";
// Sounds
const string SLASH_1S 	= "weapons/cs16/knife_slash1.wav";
const string SLASH_2S 	= "weapons/cs16/knife_slash2.wav";
// Information
const int MAX_CARRY 	= -1;
const int MAX_CLIP  	= WEAPON_NOCLIP;
const int DEFAULT_GIVE 	= 0;
const int WEIGHT    	= 5;
const int FLAGS     	= 0;
const uint DAMAGE   	= 21;
const uint SLOT     	= 0;
const uint POSITION 	= 5;
const string AMMO_TYPE 	= "";

class weapon_csknife : ScriptBasePlayerWeaponEntity, CS16BASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iSwing;
	private TraceResult m_trHit;
	private int GetBodygroup()
	{
		return 0;
	}
	private array<string> Sounds = {
		"weapons/cs16/knife_hit1.wav",
		"weapons/cs16/knife_hit2.wav",
		"weapons/cs16/knife_hit3.wav",
		"weapons/cs16/knife_hit4.wav",
		"weapons/cs16/knife_hitwall1.wav",
		"weapons/cs16/knife_stab.wav",
		"weapons/cs16/knife_deploy1.wav",
		SLASH_1S,
		SLASH_2S,
	};

	void Spawn()
	{
		Precache();
		self.m_iClip = -1;
		self.m_flCustomDmg = self.pev.dmg;
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
		//Sounds
		CS16BASE::PrecacheSound( Sounds );
		//Sprites
		g_Game.PrecacheModel( "sprites/cs16/640hud10.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud11.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud10.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud11.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_csknife.txt" );
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

	bool Deploy()
	{
		g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_ITEM, Sounds[6], 1, ATTN_NORM );
		return Deploy( V_MODEL, P_MODEL, KNIFE_DRAW, "crowbar", GetBodygroup(), (45.0/45.0) );
	}

	void Holster( int skipLocal = 0 )
	{
		m_iSwing = 0;
		CommonHolster();
		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		if( !Swing( 1 ) )
		{
			SetThink( ThinkFunction( this.SwingAgain ) );
			self.pev.nextthink = g_Engine.time + 0.01;
		}
	}

	void SwingAgain()
	{
		Swing( 0 );
	}

	void Smack()
	{
		g_WeaponFuncs.DecalGunshot( m_trHit, BULLET_PLAYER_CROWBAR );
	}

	bool Swing( int fFirst )
	{
		bool fDidHit = false;

		TraceResult tr;

		Math.MakeVectors( m_pPlayer.pev.v_angle );
		Vector vecSrc	= m_pPlayer.GetGunPosition();
		Vector vecEnd	= vecSrc + g_Engine.v_forward * 47;

		g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr );

		if ( tr.flFraction >= 1.0 )
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

		if ( tr.flFraction >= 1.0 )
		{
			if( fFirst != 0 )
			{
				// miss
				switch( ( m_iSwing++ ) % 2 )
				{
				case 0:
					self.SendWeaponAnim( KNIFE_MIDSLASH1 ); break;
				case 1:
					self.SendWeaponAnim( KNIFE_MIDSLASH2 ); break;
				}
				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + 0.35;
				// play wiff or swish sound
				g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cs16/knife_slash2.wav", 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );

				// player "shoot" animation
				m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 
			}
		}
		else
		{
			// hit
			fDidHit = true;
			
			CBaseEntity@ pEntity = g_EntityFuncs.Instance( tr.pHit );

			switch( ( ( m_iSwing++ ) % 2 ) )
			{
			case 0:
				self.SendWeaponAnim( KNIFE_MIDSLASH1 ); break;
			case 1:
				self.SendWeaponAnim( KNIFE_MIDSLASH2 ); break;
			}

			// player "shoot" animation
			m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 

			// AdamR: Custom damage option
			float flDamage = 25;
			if ( self.m_flCustomDmg > 0 )
				flDamage = self.m_flCustomDmg;
			// AdamR: End

			g_WeaponFuncs.ClearMultiDamage();
			if ( self.m_flNextPrimaryAttack + 1 < g_Engine.time )
			{
				// first swing does full damage
				pEntity.TraceAttack( m_pPlayer.pev, flDamage, g_Engine.v_forward, tr, DMG_CLUB );  
			}
			else
			{
				// subsequent swings do 13% (Changed -Sniper/kerncore) (Half)
				pEntity.TraceAttack( m_pPlayer.pev, flDamage * 0.13, g_Engine.v_forward, tr, DMG_CLUB );  
			}	
			g_WeaponFuncs.ApplyMultiDamage( m_pPlayer.pev, m_pPlayer.pev );

			//m_flNextPrimaryAttack = gpGlobals->time + 0.30; //0.25

			// play thwack, smack, or dong sound
			float flVol = 1.0;
			bool fHitWorld = true;

			if( pEntity !is null )
			{
				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + 0.35; //0.25

				if( pEntity.Classify() != CLASS_NONE && pEntity.Classify() != CLASS_MACHINE && pEntity.BloodColor() != DONT_BLEED )
				{
	// aone
					if( pEntity.IsPlayer() )		// lets pull them
					{
						pEntity.pev.velocity = pEntity.pev.velocity + (self.pev.origin - pEntity.pev.origin).Normalize() * 120;
					}
	// end aone
					// play thwack or smack sound
					switch( Math.RandomLong( 0, 3 ) )
					{
					case 0:
						g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cs16/knife_hit1.wav", 1, ATTN_NORM ); break;
					case 1:
						g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cs16/knife_hit2.wav", 1, ATTN_NORM ); break;
					case 2:
						g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cs16/knife_hit3.wav", 1, ATTN_NORM ); break;
					case 3:
						g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cs16/knife_hit4.wav", 1, ATTN_NORM ); break;
					}
					m_pPlayer.m_iWeaponVolume = 128;
					if( !pEntity.IsAlive() )
						return true;
					else
						flVol = 0.1;

					fHitWorld = false;
				}
			}

			// play texture hit sound
			// UNDONE: Calculate the correct point of intersection when we hit with the hull instead of the line

			if( fHitWorld == true )
			{
				float fvolbar = g_SoundSystem.PlayHitSound( tr, vecSrc, vecSrc + ( vecEnd - vecSrc ) * 2, BULLET_PLAYER_CROWBAR );
				
				self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + 0.35; //0.25
				
				// override the volume here, cause we don't play texture sounds in multiplayer, 
				// and fvolbar is going to be 0 from the above call.

				fvolbar = 1;

				// also play crowbar strike
				
				g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cs16/knife_hitwall1.wav", fvolbar, ATTN_NORM, 0, 98 + Math.RandomLong( 0, 3 ) );
			}

			// delay the decal a bit
			m_trHit = tr;
			SetThink( ThinkFunction( Smack ) );
			self.pev.nextthink = g_Engine.time + 0.2;

			m_pPlayer.m_iWeaponVolume = int( flVol * 512 );
		}
		return fDidHit;
	}

	void SecondaryAttack()
	{
		self.m_flNextSecondaryAttack = WeaponTimeBase() + 0.1;
	}

	void WeaponIdle()
	{
		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( KNIFE_IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 12, 13 );
	}
}

string GetName()
{
	return "weapon_csknife";
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CS_KNIFE::weapon_csknife", GetName() ); // Register the weapon entity
	g_ItemRegistry.RegisterWeapon( GetName(), "cs16", AMMO_TYPE ); // Register the weapon
}

} //Namespace end
/*



class weapon_csknife : ScriptBasePlayerWeaponEntity
{
	private CBasePlayer@ m_pPlayer = null;
	int m_iSwing;
	TraceResult m_trHit;
	
	void Spawn()
	{
		self.Precache();
		g_EntityFuncs.SetModel( self, self.GetW_Model( "models/cs16/csknife/w_knife.mdl") );
		self.m_iClip    	= -1;
		self.m_flCustomDmg	= self.pev.dmg;

		self.FallInit();
	}
	
	void Precache()
	{
		self.PrecacheCustomModels();

		g_Game.PrecacheModel( "models/cs16/csknife/w_knife.mdl" );
		g_Game.PrecacheModel( "models/cs16/csknife/v_knife.mdl" );
		g_Game.PrecacheModel( "models/cs16/csknife/p_knife.mdl" );

		//Precache the Sprites as well
		
		
		g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/knife_hit1.wav" );
        g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/knife_hit2.wav" );
        g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/knife_hit3.wav" );
        g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/knife_hit4.wav" );
        g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/knife_hitwall1.wav" );
        g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/knife_slash1.wav" );
		g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/knife_slash2.wav" );
		g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/knife_stab.wav" );
		g_Game.PrecacheGeneric( "sound/" + "weapons/cs16/knife_deploy1.wav" );
		
		g_SoundSystem.PrecacheSound( "weapons/cs16/knife_hit1.wav" );
		g_SoundSystem.PrecacheSound( "weapons/cs16/knife_hit2.wav" );
		g_SoundSystem.PrecacheSound( "weapons/cs16/knife_hit3.wav" );
		g_SoundSystem.PrecacheSound( "weapons/cs16/knife_hit4.wav" );
		g_SoundSystem.PrecacheSound( "weapons/cs16/knife_hitwall1.wav" );
		g_SoundSystem.PrecacheSound( "weapons/cs16/.wav" );
		g_SoundSystem.PrecacheSound( "weapons/cs16/.wav" );
		g_SoundSystem.PrecacheSound( "weapons/cs16/knife_stab.wav" );
		g_SoundSystem.PrecacheSound( "weapons/cs16/knife_deploy1.wav" );
		
		
	}
	
	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1		= -1;
		info.iMaxAmmo2		= -1;
		info.iMaxClip		= WEAPON_NOCLIP;
		info.iSlot			= 0;
		info.iPosition		= 5;
		info.iWeight		= 0;
		return true;
	}
	
	bool AddToPlayer( CBasePlayer@ pPlayer )
	{
		if( BaseClass.AddToPlayer ( pPlayer ) )
		{
			@m_pPlayer = pPlayer;
			NetworkMessage csknife( MSG_ONE, NetworkMessages::WeapPickup, pPlayer.edict() );
				csknife.WriteLong( g_ItemRegistry.GetIdForName("weapon_csknife") );
			csknife.End();
			return true;
		}
	   
		return false;
	}
	
	bool Deploy()
	{
		bool bResult;
		{
			bResult = self.DefaultDeploy( self.GetV_Model( "models/cs16/csknife/v_knife.mdl" ), self.GetP_Model( "models/cs16/csknife/p_knife.mdl" ), KNIFE_DRAW, "crowbar" );
			
			float deployTime = 1;
			self.m_flTimeWeaponIdle = self.m_flNextPrimaryAttack = self.m_flNextSecondaryAttack = g_Engine.time + deployTime;
			g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cs16/knife_deploy1.wav", 1, ATTN_NORM );
			return bResult;
		}
	}
	
	void WeaponIdle()
	{
		if( self.m_flTimeWeaponIdle > g_Engine.time )
			return;
		
		self.SendWeaponAnim( KNIFE_IDLE );
		self.m_flTimeWeaponIdle = g_Engine.time + Math.RandomFloat( 10, 15 );
	}
		
	
	void Holster( int skiplocal )
	{
		self.m_fInReload = false;// cancel any reload in progress.
		m_iSwing = 0;
		SetThink( null );

		m_pPlayer.m_flNextAttack = g_Engine.time + 0.5; 

		m_pPlayer.pev.viewmodel = string_t();
	}
	
	void PrimaryAttack()
	{
		if( !Swing( 1 ) )
		{
			SetThink( ThinkFunction( this.SwingAgain ) );
			self.pev.nextthink = g_Engine.time + 0.01;
		}
	}
	
	void SecondaryAttack()
	{
		if( !HeavySmack( 1 ) )
		{	
			SetThink( ThinkFunction( this.DoHeavyAttack ) );
			self.pev.nextthink = g_Engine.time + 0.01;
		}
	}
	
	void DoHeavyAttack()
	{
		HeavySmack( 0 );
	}
	
	void Smack()
	{
		g_WeaponFuncs.DecalGunshot( m_trHit, BULLET_PLAYER_CROWBAR );
	}
	
	void SwingAgain()
	{
		Swing( 0 );
	}
	
	bool HeavySmack( int fFirst )
	{
		TraceResult tr;
		bool fDidHit = false;

		Math.MakeVectors( m_pPlayer.pev.v_angle );
		Vector vecSrc	= m_pPlayer.GetGunPosition();
		Vector vecEnd	= vecSrc + g_Engine.v_forward * 37;

		g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr );

		if( tr.flFraction >= 1.0 )
		{
			g_Utility.TraceHull( vecSrc, vecEnd, dont_ignore_monsters, head_hull, m_pPlayer.edict(), tr );
			if( tr.flFraction < 1.0 )
			{
				// Calculate the point of intersection of the line (or hull) and the object we hit
				// This is and approximation of the "best" intersection
				CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );
				if( pHit is null || pHit.IsBSPModel() )
					g_Utility.FindHullIntersection( vecSrc, tr, tr, VEC_DUCK_HULL_MIN, VEC_DUCK_HULL_MAX, m_pPlayer.edict() );
				vecEnd = tr.vecEndPos;	// This is the point on the actual surface (the hull could have hit space)
			}
		}

		if( tr.flFraction >= 1.0 )
		{
			if( fFirst != 0 )
			{
				// miss
				switch( ( m_iSwing++ ) % 1 )
				{
				case 0:
					self.SendWeaponAnim( KNIFE_STABMISS ); break;
				}
				self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = g_Engine.time + 0.9;
				// play wiff or swish sound
				g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cs16/knife_slash1.wav", 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );

				// player "shoot" animation
				m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 
			}
		}
		else
		{
			// hit
			fDidHit = true;
			
			CBaseEntity@ pEntity = g_EntityFuncs.Instance( tr.pHit );

			switch( ( ( m_iSwing++ ) % 2 ) )
			{
			case 0:
				self.SendWeaponAnim( KNIFE_STAB ); break;
			case 1:
				self.SendWeaponAnim( KNIFE_STAB ); break;
			}

			// player "shoot" animation
			m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 

			// AdamR: Custom damage option
			float flDamage = 65;
			if( self.m_flCustomDmg > 0 )
				flDamage = self.m_flCustomDmg;
			// AdamR: End

			g_WeaponFuncs.ClearMultiDamage();
			if( self.m_flNextSecondaryAttack + 1 < g_Engine.time )
			{
				// first swing does full damage
				pEntity.TraceAttack( m_pPlayer.pev, flDamage, g_Engine.v_forward, tr, DMG_CLUB );  
			}
			else
			{
				// subsequent swings do 13% (Changed -Sniper/kerncore) (Half)
				pEntity.TraceAttack( m_pPlayer.pev, flDamage * 0.13, g_Engine.v_forward, tr, DMG_CLUB );  
			}	
			g_WeaponFuncs.ApplyMultiDamage( m_pPlayer.pev, m_pPlayer.pev );

			//m_flNextPrimaryAttack = gpGlobals->time + 0.30; //0.25

			// play thwack, smack, or dong sound
			float flVol = 1.0;
			bool fHitWorld = true;

			if( pEntity !is null )
			{
				self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = g_Engine.time + 0.9; //0.25

				if( pEntity.Classify() != CLASS_NONE && pEntity.Classify() != CLASS_MACHINE && pEntity.BloodColor() != DONT_BLEED )
				{
	// aone
					if( pEntity.IsPlayer() )		// lets pull them
					{
						pEntity.pev.velocity = pEntity.pev.velocity + ( self.pev.origin - pEntity.pev.origin ).Normalize() * 120;
					}
	// end aone
					// play thwack or smack sound
					switch( Math.RandomLong( 0, 0 ) )
					{
					case 0:
						g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cs16/knife_stab.wav", 1, ATTN_NORM ); break;
					}
					m_pPlayer.m_iWeaponVolume = 128; 
					if( !pEntity.IsAlive() )
						return true;
					else
						flVol = 0.1;

					fHitWorld = false;
				}
			}

			// play texture hit sound
			// UNDONE: Calculate the correct point of intersection when we hit with the hull instead of the line

			if( fHitWorld == true )
			{
				float fvolbar = g_SoundSystem.PlayHitSound( tr, vecSrc, vecSrc + ( vecEnd - vecSrc ) * 2, BULLET_PLAYER_CROWBAR );
				
				self.m_flNextSecondaryAttack = self.m_flNextPrimaryAttack = g_Engine.time + 0.9; //0.25
				
				// override the volume here, cause we don't play texture sounds in multiplayer, 
				// and fvolbar is going to be 0 from the above call.

				fvolbar = 1;

				// also play crowbar strike
				g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cs16/knife_hitwall1.wav", fvolbar, ATTN_NORM, 0, 98 + Math.RandomLong( 0, 3 ) );
			}

			// delay the decal a bit
			m_trHit = tr;
			SetThink( ThinkFunction( this.Smack ) );
			self.pev.nextthink = g_Engine.time + 0.1;

			m_pPlayer.m_iWeaponVolume = int( flVol * 512 ); 
		}
		return fDidHit;
	}
	
	
}

string GetCSKNIFEName()
{
	return "weapon_csknife";
}

void RegisterCSKNIFE()
{
	g_CustomEntityFuncs.RegisterCustomEntity( GetCSKNIFEName(), GetCSKNIFEName() );
	g_ItemRegistry.RegisterWeapon( GetCSKNIFEName(), "cs16" );
}*/