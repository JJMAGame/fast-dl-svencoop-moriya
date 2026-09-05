//Counter-Strike 1.6 C4
//Author: Nero, Port to newer code - KernCore

#include "../base"

namespace CS_C4
{ //Namespace start

enum C4Animation
{
	C4_IDLE1 = 0,
	C4_DRAW,
	C4_DROP,
	C4_ARM
};

const int MAX_CARRY                 	= 5;//1 by default
const int MAX_CLIP                  	= WEAPON_NOCLIP;
const int DEFAULT_GIVE              	= 1;
const int WEIGHT                    	= 5;
const int FLAGS                     	= ITEM_FLAG_LIMITINWORLD | ITEM_FLAG_EXHAUSTIBLE;
const float DAMAGE                  	= 5000;//100 by default
const uint SLOT                     	= 5;
const uint POSITION                 	= 11;
const float TIMER                   	= 35;//45 by default

const bool m_bDamageOtherPlayers    	= false;//Set this to true to make C4 deal damage to other players.
const bool m_bUseBombZones          	= false;//Set this to true to only allow the C4 to be placed within range of an info_bomb_target

const int BOMB_RADIUS               	= 750;//500 by default
const float DELAY_FAIL              	= 1;

const string W_MODEL                	= "models/cs16/c4/w_c4.mdl";
const string V_MODEL                	= "models/cs16/c4/v_c4.mdl";
const string P_MODEL                	= "models/cs16/c4/p_c4.mdl";
const string BP_MODEL               	= "models/cs16/c4/w_backpack.mdl";

const string C4_SOUND_PLANT         	= "weapons/cs16/c4_plant.wav";
const string C4_SOUND_BEEP          	= "weapons/cs16/c4_beep.wav";
const string C4_SOUND_EXPLODE       	= "weapons/cs16/c4_explode1.wav";
const string C4_SOUND_BOMBPLANT     	= "weapons/cs16/c4_bombpl.wav";

const string C4_PLANT_AT_BOMB_SPOT  	= "C4 must be planted at a bomb site!\n";
const string C4_PLANT_MUST_BE_ON_GROUND	= "You must be standing on\nthe ground to plant the C4!\n";
const string C4_ARMING_CANCELLED    	= "Arming Sequence Cancelled\nC4 can only be placed at a Bomb Target.\n";
const string C4_BOMB_PLANTED        	= "The bomb has been planted!\n";

float m_flNextBlink;

class CWeaponC4 : ScriptBasePlayerWeaponEntity
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}

	bool m_bStartedArming, m_bBombPlacedAnimation;
	float m_fArmedTime;

	void Spawn()
	{
		Precache();
		m_bStartedArming = false;
		m_fArmedTime = 0;

		if( self.pev.targetname != "" )
		{
			self.pev.effects |= EF_NODRAW;
			g_EngineFuncs.DropToFloor( self.edict() );
			return;
		}

		CommonSpawn( W_MODEL, DEFAULT_GIVE );
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		//Models
		CommonPrecache();
		g_Game.PrecacheModel( V_MODEL );
		g_Game.PrecacheModel( P_MODEL );
		g_Game.PrecacheModel( W_MODEL );
		g_Game.PrecacheModel( BP_MODEL );
		//Sounds
		g_SoundSystem.PrecacheSound( "weapons/debris1.wav" );
		g_SoundSystem.PrecacheSound( "weapons/debris2.wav" );
		g_SoundSystem.PrecacheSound( "weapons/debris2.wav" );
		g_SoundSystem.PrecacheSound( C4_SOUND_PLANT );
		g_Game.PrecacheGeneric( "sound/" + C4_SOUND_PLANT );
		g_SoundSystem.PrecacheSound( C4_SOUND_BEEP );
		g_Game.PrecacheGeneric( "sound/" + C4_SOUND_BEEP );
		g_SoundSystem.PrecacheSound( C4_SOUND_EXPLODE );
		g_Game.PrecacheGeneric( "sound/" + C4_SOUND_EXPLODE );
		g_SoundSystem.PrecacheSound( C4_SOUND_BOMBPLANT );
		g_Game.PrecacheGeneric( "sound/" + C4_SOUND_BOMBPLANT );
		//Sprites
		g_Game.PrecacheModel( "sprites/zerogxplode.spr" );
		g_Game.PrecacheModel( "sprites/eexplo.spr" );
		g_Game.PrecacheModel( "sprites/fexplo.spr" );
		g_Game.PrecacheModel( "sprites/steam1.spr" );
		g_Game.PrecacheModel( "sprites/ledglow.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud1.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud4.spr" );
		g_Game.PrecacheModel( "sprites/cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud1.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud4.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/640hud7.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/crosshairs.spr" );
		g_Game.PrecacheGeneric( "sprites/" + "cs16/weapon_c4.txt" );
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= MAX_CARRY;
		info.iMaxAmmo2 	= -1;
		info.iMaxClip 	= MAX_CLIP;
		info.iSlot 		= SLOT;
		info.iPosition 	= POSITION;
		info.iId     	= g_ItemRegistry.GetIdForName( self.pev.classname );
		info.iFlags 	= FLAGS;
		info.iWeight 	= WEIGHT;

		return true;
	}

	void Materialize()
	{
		BaseClass.Materialize();
		SetTouch( TouchFunction( this.CustomTouch ) );
		SetUse( UseFunction( this.CustomUse ) );
	}

	void CustomTouch( CBaseEntity@ pOther )
	{
		if( !pOther.IsPlayer() || !pOther.IsAlive() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pOther );

		if( pPlayer.HasNamedPlayerItem( self.pev.classname ) !is null )
		{
			if( pPlayer.GiveAmmo( DEFAULT_GIVE, self.pev.classname, MAX_CARRY ) != -1 )
			{
				self.CheckRespawn();
				g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
				g_EntityFuncs.Remove( self );
			}
			return;
		}
		else if( pPlayer.AddPlayerItem( self ) != APIR_NotAdded )
		{
			self.AttachToPlayer( pPlayer );
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/gunpickup2.wav", 1, ATTN_NORM );
		}
	}

	void CustomUse( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float value )
	{
		if( !pActivator.IsPlayer() || !pActivator.IsAlive() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pActivator );

		if( pPlayer.HasNamedPlayerItem( self.pev.classname ) !is null )
		{
			if( pPlayer.GiveAmmo( DEFAULT_GIVE, self.pev.classname, MAX_CARRY ) != -1 )
			{
				self.CheckRespawn();
				g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/9mmclip1.wav", 1, ATTN_NORM );
				g_EntityFuncs.Remove( self );
			}
			return;
		}
		else if( pPlayer.AddPlayerItem( self ) != APIR_NotAdded )
		{
			self.AttachToPlayer( pPlayer );
			g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, "items/gunpickup2.wav", 1, ATTN_NORM );
		}
	}

	bool AddToPlayer( CBasePlayer@ pPlayer )
	{
		return CommonAddToPlayer( pPlayer );
	}

	bool Deploy()
	{
		m_bStartedArming = false;
		m_fArmedTime = 0;
		return Deploy( V_MODEL, P_MODEL, C4_DRAW, "trip", GetBodygroup(), (20.0/30.0) );;
	}

	void DestroyThink()
	{
		self.DestroyItem();
	}

	void Holster( int skipLocal = 0 )
	{
		m_bStartedArming = false;
		CommonHolster();

		if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) == 0 )
		{
			m_pPlayer.pev.weapons &= ~( 0 << g_ItemRegistry.GetIdForName( self.pev.classname ) );
			SetThink( ThinkFunction( DestroyThink ) );
			self.pev.nextthink = g_Engine.time + 0.1;
		}

		BaseClass.Holster( skipLocal );
	}

	void PrimaryAttack()
	{
		bool onGround = (m_pPlayer.pev.flags & FL_ONGROUND) != 0;
		CustomKeyvalues@ pCustom = m_pPlayer.GetCustomKeyvalues();
		bool onBombZone = pCustom.GetKeyvalue( "$i_inBombZone" ).GetInteger() == 1;

		if( !m_bStartedArming )
		{
			if( !onBombZone && m_bUseBombZones )
			{
				g_PlayerFuncs.ClientPrint( m_pPlayer, HUD_PRINTCENTER, C4_PLANT_AT_BOMB_SPOT );
				self.m_flNextPrimaryAttack = g_Engine.time + DELAY_FAIL;
				return;
			}

			if( !onGround )
			{
				g_PlayerFuncs.ClientPrint( m_pPlayer, HUD_PRINTCENTER, C4_PLANT_MUST_BE_ON_GROUND );
				self.m_flNextPrimaryAttack = g_Engine.time + DELAY_FAIL;
				return;
			}

			m_pPlayer.pev.maxspeed = 1;

			m_bStartedArming = true;
			m_bBombPlacedAnimation = false;
			m_fArmedTime = g_Engine.time + 3;
			self.SendWeaponAnim( C4_ARM );
			m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
			//m_pPlayer.SetProgressBarTime(3);
			self.m_flNextPrimaryAttack = g_Engine.time + 0.3f;
			self.m_flTimeWeaponIdle = g_Engine.time + Math.RandomFloat( 10, 15 );
		}
		else
		{
			if( !onGround || (!onBombZone && m_bUseBombZones) )
			{
				if( onBombZone && m_bUseBombZones )
					g_PlayerFuncs.ClientPrint( m_pPlayer, HUD_PRINTCENTER, C4_PLANT_MUST_BE_ON_GROUND );
				else
					g_PlayerFuncs.ClientPrint( m_pPlayer, HUD_PRINTCENTER, C4_ARMING_CANCELLED );

				m_bStartedArming = false;
				self.m_flNextPrimaryAttack = g_Engine.time + 1.5f;
				m_pPlayer.pev.maxspeed = 0;
				//m_pPlayer.SetProgressBarTime(0);
				//m_pPlayer.SetAnimation( PLAYER_HOLDBOMB );

				if( m_bBombPlacedAnimation == true )
					self.SendWeaponAnim( C4_DRAW );
				else
					self.SendWeaponAnim( C4_IDLE1 );

				return;
			}

			if( g_Engine.time > m_fArmedTime )
			{
				if( m_bStartedArming == true )
				{
					m_bStartedArming = false;
					m_fArmedTime = 0;
					g_SoundSystem.PlaySound( m_pPlayer.edict(), CHAN_STATIC, C4_SOUND_BOMBPLANT, 1, ATTN_NORM );

					auto pC4 = cs16_PlantC4( m_pPlayer, m_pPlayer.pev.origin, Vector(0, 0, 0), g_Engine.time + TIMER );

					g_PlayerFuncs.ClientPrintAll( HUD_PRINTCENTER, C4_BOMB_PLANTED );

					g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, C4_SOUND_PLANT, VOL_NORM, ATTN_NORM );

					m_pPlayer.pev.maxspeed = 0;
					//m_pPlayer.SetBombIcon(FALSE);
					m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) - 1 );

					if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
					{
						self.RetireWeapon();
						return;
					}
				}
			}
			else
			{
				if( g_Engine.time >= m_fArmedTime - 0.75f )
				{
					if( m_bBombPlacedAnimation == false )
					{
						m_bBombPlacedAnimation = true;
						self.SendWeaponAnim( C4_DROP );
						SetThink( ThinkFunction( DrawThink ) );
						self.pev.nextthink = g_Engine.time + 0.5;
						//m_pPlayer.SetAnimation( PLAYER_HOLDBOMB );
					}
				}
			}
		}

		self.m_flNextPrimaryAttack = g_Engine.time + 0.3f;
		self.m_flTimeWeaponIdle = g_Engine.time + Math.RandomFloat( 10, 15 );
	}

	void DrawThink()
	{
		self.SendWeaponAnim( C4_DRAW );
	}

	void WeaponIdle()
	{
		if( m_bStartedArming == true )
		{
			m_bStartedArming = false;
			m_pPlayer.pev.maxspeed = 0;
			self.m_flNextPrimaryAttack = g_Engine.time + 1;
			//m_pPlayer.SetProgressBarTime( 0 );

			if( m_bBombPlacedAnimation == true )
				self.SendWeaponAnim( C4_DRAW );
			else
				self.SendWeaponAnim( C4_IDLE1 );
		}

		if( self.m_flTimeWeaponIdle <= g_Engine.time )
		{
			if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			{
				self.RetireWeapon();
				return;
			}

			self.SendWeaponAnim( C4_DRAW );
			self.SendWeaponAnim( C4_IDLE1 );
		}
	}
}

class CC4 : ScriptBaseEntity
{
	float m_flSoundTime, m_flBeepTime;

	void Spawn()
	{
		g_EntityFuncs.SetModel( self, W_MODEL );
		g_EntityFuncs.SetSize( self.pev, Vector(-3, -6, 0), Vector(3, 6, 8) );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		self.pev.nextthink = g_Engine.time + 0.1f;
		self.pev.movetype = MOVETYPE_TOSS;
		self.pev.solid = SOLID_BBOX;
		self.pev.dmg = DAMAGE;

		if( self.pev.dmgtime - g_Engine.time <= 10.0f )
			m_flBeepTime = 5;
		else
			m_flBeepTime = TIMER;

		SetTouch( TouchFunction(C4_Touch) );
		SetThink( ThinkFunction(C4_Think) );
	}

	void C4_Touch( CBaseEntity@ pOther ) {}

	void C4_Think()
	{
		if( self.pev.dmgtime <= g_Engine.time )
		{
			SetThink( ThinkFunction(C4_Detonate) );
			self.pev.nextthink = g_Engine.time + self.pev.dmgtime;
		}

		if( g_Engine.time >= m_flSoundTime )
		{
			g_SoundSystem.EmitSound( self.edict(), CHAN_STATIC, C4_SOUND_BEEP, 1, ATTN_NORM );
			m_flSoundTime = g_Engine.time + (m_flBeepTime/10);
		}

	   if( g_Engine.time >= m_flNextBlink )
	   {
			m_flNextBlink = g_Engine.time + 2;

			NetworkMessage c4glow( MSG_PAS, NetworkMessages::SVC_TEMPENTITY, self.pev.origin );
				c4glow.WriteByte( TE_GLOWSPRITE );
				c4glow.WriteCoord( self.pev.origin.x );
				c4glow.WriteCoord( self.pev.origin.y );
				c4glow.WriteCoord( self.pev.origin.z + 5 );
				c4glow.WriteShort( g_EngineFuncs.ModelIndex("sprites/ledglow.spr") );
				c4glow.WriteByte( 1 );
				c4glow.WriteByte( 3 );
				c4glow.WriteByte( 255 );
			c4glow.End();
	   }

		m_flBeepTime -= 0.1f;
		self.pev.nextthink = g_Engine.time + 0.1f;
	}

	void C4_Detonate()
	{
		TraceResult tr;
		Vector vecSpot = self.pev.origin + Vector(0, 0, 8);
		g_Utility.TraceLine( vecSpot, vecSpot + Vector(0, 0, -40), ignore_monsters, self.edict(), tr );
		C4_Explode( tr, DMG_BLAST );
	}

	void C4_Explode( TraceResult &in pTrace, int bitsDamageType )
	{
		self.pev.model = string_t();
		self.pev.solid = SOLID_NOT;
		self.pev.takedamage = DAMAGE_NO;
		g_PlayerFuncs.ScreenShake( pTrace.vecEndPos, 25, 150, 1, 3000 );

		if( pTrace.flFraction != 1 )
			self.pev.origin = pTrace.vecEndPos + (pTrace.vecPlaneNormal * (self.pev.dmg - 24) * 0.6f);

		int iContents = g_EngineFuncs.PointContents( self.pev.origin );

		NetworkMessage c4x1( MSG_PAS, NetworkMessages::SVC_TEMPENTITY, self.pev.origin );
			c4x1.WriteByte( TE_SPRITE );
			c4x1.WriteCoord( self.pev.origin.x );
			c4x1.WriteCoord( self.pev.origin.y );
			c4x1.WriteCoord( self.pev.origin.z - 10 );
			c4x1.WriteShort( g_EngineFuncs.ModelIndex("sprites/fexplo.spr") );
			c4x1.WriteByte( int(self.pev.dmg - 275) );
			c4x1.WriteByte( 150 );
		c4x1.End();

		NetworkMessage c4x2( MSG_PAS, NetworkMessages::SVC_TEMPENTITY, self.pev.origin );
			c4x2.WriteByte( TE_SPRITE );
			c4x2.WriteCoord( self.pev.origin.x + Math.RandomFloat(-512, 512) );
			c4x2.WriteCoord( self.pev.origin.y + Math.RandomFloat(-512, 512) );
			c4x2.WriteCoord( self.pev.origin.z + Math.RandomFloat(-10, 10) );
			c4x2.WriteShort( g_EngineFuncs.ModelIndex("sprites/eexplo.spr") );
			c4x2.WriteByte( int(self.pev.dmg - 275) );
			c4x2.WriteByte( 150 );
		c4x2.End();

		NetworkMessage c4x3( MSG_PAS, NetworkMessages::SVC_TEMPENTITY, self.pev.origin );
			c4x3.WriteByte( TE_SPRITE );
			c4x3.WriteCoord( self.pev.origin.x + Math.RandomFloat(-512, 512) );
			c4x3.WriteCoord( self.pev.origin.y + Math.RandomFloat(-512, 512) );
			c4x3.WriteCoord( self.pev.origin.z + Math.RandomFloat(-10, 10) );
			c4x3.WriteShort( g_EngineFuncs.ModelIndex("sprites/fexplo.spr") );
			c4x3.WriteByte( int(self.pev.dmg - 275) );
			c4x3.WriteByte( 150 );
		c4x3.End();

		NetworkMessage c4x4( MSG_PAS, NetworkMessages::SVC_TEMPENTITY, self.pev.origin );
			c4x4.WriteByte( TE_SPRITE );
			c4x4.WriteCoord( self.pev.origin.x + Math.RandomFloat(-512, 512) );
			c4x4.WriteCoord( self.pev.origin.y + Math.RandomFloat(-512, 512) );
			c4x4.WriteCoord( self.pev.origin.z + Math.RandomFloat(-10, 10) );
			c4x4.WriteShort( g_EngineFuncs.ModelIndex("sprites/zerogxplode.spr") );
			c4x4.WriteByte( int(self.pev.dmg - 275) );
			c4x4.WriteByte( 17 );
		c4x4.End();

		g_SoundSystem.EmitSound( self.edict(), CHAN_WEAPON, C4_SOUND_EXPLODE, 1, ATTN_NORM );

		entvars_t@ pevOwner;

		if( self.pev.owner !is null )
			@pevOwner = self.pev.owner.vars;
		else
			@pevOwner = null;

		@self.pev.owner = null;
		
		if( m_bDamageOtherPlayers )
			g_WeaponFuncs.RadiusDamage( self.pev.origin, self.pev, g_EntityFuncs.Instance(0).pev, DAMAGE, BOMB_RADIUS, CLASS_NONE, bitsDamageType );
		else
			g_WeaponFuncs.RadiusDamage( self.pev.origin, self.pev, pevOwner, DAMAGE, BOMB_RADIUS, CLASS_NONE, bitsDamageType );

		if( Math.RandomFloat(0, 1) < 0.5f )
			g_Utility.DecalTrace( pTrace, DECAL_SCORCH1 );
		else
			g_Utility.DecalTrace( pTrace, DECAL_SCORCH2 );

		switch( Math.RandomLong(0, 2) )
		{
			case 0: g_SoundSystem.EmitSound( self.edict(), CHAN_VOICE, "weapons/debris1.wav", 0.55f, ATTN_NORM ); break;
			case 1: g_SoundSystem.EmitSound( self.edict(), CHAN_VOICE, "weapons/debris2.wav", 0.55f, ATTN_NORM ); break;
			case 2: g_SoundSystem.EmitSound( self.edict(), CHAN_VOICE, "weapons/debris3.wav", 0.55f, ATTN_NORM ); break;
		}

		self.pev.effects |= EF_NODRAW;
		SetThink( ThinkFunction(C4_Smoke) );
		self.pev.velocity = g_vecZero;
		self.pev.nextthink = g_Engine.time + 0.85f;

		if( iContents != CONTENTS_WATER )
		{
			int sparkCount = Math.RandomLong(0, 3);

			for( int i = 0; i < sparkCount; i++ )
				g_EntityFuncs.Create( "spark_shower", self.pev.origin, pTrace.vecPlaneNormal, false );
		}
	}

	void C4_Smoke()
	{
		if( g_EngineFuncs.PointContents(self.pev.origin) != CONTENTS_WATER )
		{
			NetworkMessage c4smoke( MSG_PVS, NetworkMessages::SVC_TEMPENTITY, self.pev.origin );
					c4smoke.WriteByte( TE_SMOKE );
					c4smoke.WriteCoord( self.pev.origin.x );
					c4smoke.WriteCoord( self.pev.origin.y );
					c4smoke.WriteCoord( self.pev.origin.z );
					c4smoke.WriteShort( g_EngineFuncs.ModelIndex( "sprites/steam1.spr" ) );
					c4smoke.WriteByte( 150 );
					c4smoke.WriteByte( 8 );
			c4smoke.End();
		}
		else
			g_Utility.Bubbles( self.pev.origin - Vector(64, 64, 64), self.pev.origin + Vector(64, 64, 64), 100 );

		g_EntityFuncs.Remove( self );
	}
}

CBaseEntity@ cs16_PlantC4( CBaseEntity@ owner, Vector origin, Vector angles, float time )
{
	dictionary keys;

	keys[ "origin" ] = origin.ToString();
	keys[ "angles" ] = angles.ToString();
	keys[ "velocity" ] = g_vecZero.ToString();
	keys[ "model" ] = "models/cs16/w_c4.mdl";

	CBaseEntity@ pC4 = g_EntityFuncs.CreateEntity( "c4", keys, false );
	@pC4.pev.owner = owner.edict();

	pC4.pev.dmgtime = time;
	m_flNextBlink = g_Engine.time + 2;

	g_EntityFuncs.DispatchSpawn( pC4.edict() );

	return pC4;
}

class CInfoBombTarget : ScriptBaseEntity
{
	private float m_flRadius = 256;
	private int m_iVisible = 0, m_iRingType = 1;
	private string SPRITE_RING = "sprites/laserbeam.spr";
	private array<int> m_iRingColor =
	{
		250,
		179,
		209,
		100
	};

	CustomKeyvalues@ pCustom;

	bool KeyValue( const string& in szKey, const string& in szValue )
	{
		if( szKey == "radius" )
		{
			m_flRadius = abs( atof( szValue ) );
			return true;
		}
		else if( szKey == "visible" )
		{
			m_iVisible = atoi(szValue);
			return true;
		}
		else if( szKey == "ringtype" )
		{
			m_iRingType = Math.clamp( 1, 3, atoi(szValue) );
			return true;
		}
		else if( szKey == "color" )
		{
			for( uint i = 0; i <= 3; i++ )
				m_iRingColor[i] = Math.clamp( 0, 255, atoi(szValue.Split( " " )[i]) );

			return true;
		}
		else
			return BaseClass.KeyValue( szKey, szValue );
	}

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_NOT;
		SetThink( ThinkFunction(BombTargetThink) );
		pev.nextthink = g_Engine.time + 0.1f;

		g_EntityFuncs.SetOrigin( self, pev.origin );
	}

	void Precache()
	{
		BaseClass.Precache();
		g_Game.PrecacheModel( self, SPRITE_RING );
	}

	void BombTargetThink()
	{
		if( m_iVisible == 1 )
		{
			if( m_iRingType == 1 )
			{
				NetworkMessage ringmsg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, pev.origin );
					ringmsg.WriteByte( TE_BEAMDISK );
					ringmsg.WriteCoord( pev.origin.x );//center position
					ringmsg.WriteCoord( pev.origin.y );//center position
					ringmsg.WriteCoord( pev.origin.z );//center position
					ringmsg.WriteCoord( pev.origin.x );//axis and radius
					ringmsg.WriteCoord( pev.origin.y );//axis and radius
					ringmsg.WriteCoord( pev.origin.z + m_flRadius );//radius
					ringmsg.WriteShort( g_EngineFuncs.ModelIndex(SPRITE_RING) );
					ringmsg.WriteByte( 0 );//starting frame
					ringmsg.WriteByte( 0 );//frame rate
					ringmsg.WriteByte( int(m_flRadius/23) );//life
					ringmsg.WriteByte( 32 );//line width
					ringmsg.WriteByte( 0 );//noise
					ringmsg.WriteByte( m_iRingColor[0] );//red
					ringmsg.WriteByte( m_iRingColor[1] );//green
					ringmsg.WriteByte( m_iRingColor[2] );//blue
					ringmsg.WriteByte( m_iRingColor[3] );//brightness
					ringmsg.WriteByte( 0 );//scroll speed
				ringmsg.End();
			}
			else if( m_iRingType == 2 )
			{
				NetworkMessage ringmsg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, pev.origin );
					ringmsg.WriteByte( TE_BEAMCYLINDER );
					ringmsg.WriteCoord( pev.origin.x );//center position
					ringmsg.WriteCoord( pev.origin.y );//center position
					ringmsg.WriteCoord( pev.origin.z );//center position
					ringmsg.WriteCoord( pev.origin.x );//axis and radius
					ringmsg.WriteCoord( pev.origin.y );//axis and radius
					ringmsg.WriteCoord( pev.origin.z + m_flRadius );//radius
					ringmsg.WriteShort( g_EngineFuncs.ModelIndex(SPRITE_RING) );
					ringmsg.WriteByte( 0 );//starting frame
					ringmsg.WriteByte( 0 );//frame rate
					ringmsg.WriteByte( int(m_flRadius/25) );//life
					ringmsg.WriteByte( 32 );//line width
					ringmsg.WriteByte( 0 );//noise
					ringmsg.WriteByte( m_iRingColor[0] );//red
					ringmsg.WriteByte( m_iRingColor[1] );//green
					ringmsg.WriteByte( m_iRingColor[2] );//blue
					ringmsg.WriteByte( m_iRingColor[3] );//brightness
					ringmsg.WriteByte( 0 );//scroll speed
				ringmsg.End();
			}
			else if( m_iRingType == 3 )
			{
				NetworkMessage ringmsg( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null );
					ringmsg.WriteByte( TE_BEAMTORUS );
					ringmsg.WriteCoord( pev.origin.x );//center position
					ringmsg.WriteCoord( pev.origin.y );//center position
					ringmsg.WriteCoord( pev.origin.z );//center position
					ringmsg.WriteCoord( pev.origin.x );//axis and radius
					ringmsg.WriteCoord( pev.origin.y );//axis and radius
					ringmsg.WriteCoord( pev.origin.z + m_flRadius );//radius
					ringmsg.WriteShort( g_EngineFuncs.ModelIndex(SPRITE_RING) );
					ringmsg.WriteByte( 0 );//starting frame
					ringmsg.WriteByte( 16 );//frame rate
					ringmsg.WriteByte( int(m_flRadius/24) );//life
					ringmsg.WriteByte( 8 );//line width
					ringmsg.WriteByte( 0 );//noise
					ringmsg.WriteByte( m_iRingColor[0] );//red
					ringmsg.WriteByte( m_iRingColor[1] );//green
					ringmsg.WriteByte( m_iRingColor[2] );//blue
					ringmsg.WriteByte( m_iRingColor[3] );//brightness
					ringmsg.WriteByte( 0 );//scroll speed
				ringmsg.End();
			}
		}

		for( int iPlayer = 1; iPlayer <= g_Engine.maxClients; ++iPlayer )
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iPlayer );

			if( pPlayer is null || !pPlayer.IsConnected() )
				continue;

			if( (pPlayer.pev.origin - pev.origin).Length() <= m_flRadius )
			{
				@pCustom = pPlayer.GetCustomKeyvalues();
				pCustom.SetKeyvalue( "$i_inBombZone", 1 );
			}
			else
			{
				@pCustom = pPlayer.GetCustomKeyvalues();
				pCustom.SetKeyvalue( "$i_inBombZone", 0 );
			}
		}

		pev.nextthink = g_Engine.time + 0.1f;
	}

	void UpdateOnRemove()
	{
		for( int iPlayer = 1; iPlayer <= g_Engine.maxClients; ++iPlayer )
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iPlayer );

			if( pPlayer is null || !pPlayer.IsConnected() )
				continue;

			@pCustom = pPlayer.GetCustomKeyvalues();
			pCustom.SetKeyvalue( "$i_inBombZone", 0 );
		}
	}
}
//int CountPlayersInBrushVolume(const bool fIgnoreDeadPlayers, CBaseEntity@ pBrushVolume,int& out iOutPlayersInsideVolume, int& out iOutPlayersOutsideVolume, PlayerInVolumeListener@ pListener)

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CWeaponC4", "weapon_c4" );
	g_ItemRegistry.RegisterWeapon( "weapon_c4", "cs16", "c4" );

	g_CustomEntityFuncs.RegisterCustomEntity( "CC4", "c4" );

	g_CustomEntityFuncs.RegisterCustomEntity( "CInfoBombTarget", "info_bomb_target" );
}

} //Namespace end