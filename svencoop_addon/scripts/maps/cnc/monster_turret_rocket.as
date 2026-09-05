//==============================================================//
// Author: Created by Valve, ported by Nero, modified by Rafael
//		   "Maestro Fénix" Bravo, with assistance of Sam "Solokiller" 
//		   VanHeer. 	
//
// Purpose: Implements a NPC based off the original
//			monster_turret, which fires semi-guided rockets.
//
//==============================================================//
/*
const int TURRET_SHOTS = 2;
const Vector TURRET_SPREAD = Vector( 0, 0, 0 );
const int TURRET_TURNRATE = 30; //angles per 0.1 second
const int TURRET_MAXWAIT = 15;	// seconds turret will stay active w/o a target
const float TURRET_MACHINE_VOLUME = 0.5;

const string TURRET_GLOW_SPRITE = "sprites/flare3.spr";
const string TURRET_SMOKE = "sprites/steam1.spr";

enum TURRET_ANIM
	{
		TURRET_ANIM_NONE = 0,
		TURRET_ANIM_FIRE,
		TURRET_ANIM_SPIN,
		TURRET_ANIM_DEPLOY,
		TURRET_ANIM_RETIRE,
		TURRET_ANIM_DIE,
	};*/

class monster_turret_rocket : ScriptBaseMonsterEntity
{
		CSprite@ m_pEyeGlow;
		int	m_eyeBrightness;

		int	m_iDeployHeight;
		int	m_iRetractHeight;
		int m_iMinPitch;

		int m_iBaseTurnRate;	// angles per second
		float m_fTurnRate;		// actual turn rate
		int m_iOrientation;		// 0 = floor, 1 = Ceiling
		bool m_iOn;
		bool m_fBeserk;			// Sometimes this bitch will just freak out
		bool m_iAutoStart;		// true if the turret auto deploys when a target enters its range

		Vector m_vecLastSight;
		float m_flLastSight;	// Last time we saw a target
		float m_flMaxWait;		// Max time to seach w/o a target
		int m_iSearchSpeed;		// Not Used!

		int m_fRange;
		
		// movement
		float	m_flStartYaw;
		Vector	m_vecCurAngles;
		Vector	m_vecGoalAngles;


		float	m_flPingTime;	// Time until the next ping, used when searching
		
		int g_sModelIndexSmoke; //Index for the smoke sprite
		
		int m_iBodyGibs;
		
		float m_fireLast;
		float rocketcount;
		float m_fireRate;

		CBaseEntity@ rocketquided;
		CBaseEntity@ pAttacker;
		
		bool bIsHealing;

	bool KeyValue( const string& in szKey, const string& in szValue )
	{
		if ( szKey == "maxsleep" )
		{
			m_flMaxWait = atof( szValue );
			return true;
		}
		else if ( szKey == "orientation" )
		{
			m_iOrientation = atoi( szValue );
			return true;

		}
		else if ( szKey == "searchspeed" )
		{
			m_iSearchSpeed = atoi( szValue );
			return true;

		}
		else if ( szKey == "turnrate" )
		{
			m_iBaseTurnRate = atoi( szValue );
			return true;
		}
		else if ( szKey == "fireRate" )
		{
			m_fireRate = atoi( szValue );
			return true;
		}
		else if ( szKey == "attackrange" )
		{
			m_fRange = atoi( szValue );
			return true;
		}
		else if ( ( szKey == "style" ) ||
				 ( szKey == "height" ) ||
				 ( szKey == "value1" ) ||
				 ( szKey == "value2" ) ||
				 ( szKey == "value3") )
			return true;
		else
			return BaseClass.KeyValue( szKey, szValue );
	}

	void Spawn()
	{ 
		Precache();
		
		g_EntityFuncs.SetModel( self, "models/cnc/cannonturret.mdl" );
		self.pev.health			= 1000;//1000
		self.m_HackedGunPos		= Vector( 0, 0, 12.75 );
		pev.view_ofs.z = 12.75;

		self.pev.nextthink		= g_Engine.time + 1;
		self.pev.movetype		= MOVETYPE_FLY;
		self.pev.sequence		= 0;
		self.pev.frame			= 0;
		self.pev.solid			= SOLID_SLIDEBOX;
		self.pev.takedamage		= DAMAGE_AIM;
		self.m_bloodColor		= DONT_BLEED;
		
		g_EntityFuncs.DispatchKeyValue( self.edict(), "displayname", "Turret Rocket" );

		self.pev.flags |= FL_MONSTER;
		
		SetUse( UseFunction( this.TurretUse) );

		if ( ( self.pev.spawnflags == 32 ) 
			 && !( self.pev.spawnflags == 64 ) ) //SF_MONSTER_TURRET_AUTOACTIVATE == 32 SF_MONSTER_TURRET_STARTINACTIVE == 64
		{
			m_iAutoStart = true;
		}

		self.ResetSequenceInfo( );
		self.SetBoneController( 0, 0 );
		self.SetBoneController( 1, 0 );
		self.m_flFieldOfView = VIEW_FIELD_FULL;

		m_iRetractHeight = 16;
		m_iDeployHeight = 32;
		m_iMinPitch	= -15;
		g_EntityFuncs.SetSize( pev, Vector(-32, -32, -m_iRetractHeight), Vector(32, 32, m_iRetractHeight));
		
		SetThink( ThinkFunction( this.Initialize ) );	

		@m_pEyeGlow = g_EntityFuncs.CreateSprite( TURRET_GLOW_SPRITE, self.pev.origin, false );
		m_pEyeGlow.SetTransparency( kRenderGlow, 255, 0, 0, 0, kRenderFxNoDissipation );
		m_pEyeGlow.SetAttachment( self.edict(), 2 );
		m_eyeBrightness = 0;

		//Just in case something fucks it over
		if ( m_fireRate <= 0 )
		{
			m_fireRate = 1.0;
		}
		
		if ( m_fRange <= 0 )
		{
			m_fRange = 4000;
		}
		
		self.pev.nextthink = g_Engine.time + 0.3; 
	}
	
	void Precache( void )
	{
		g_SoundSystem.PrecacheSound( "turret/tu_fire1.wav" );
		g_SoundSystem.PrecacheSound( "turret/tu_ping.wav" );
		g_SoundSystem.PrecacheSound( "turret/tu_active2.wav" );
		g_SoundSystem.PrecacheSound( "turret/tu_die.wav" );
		g_SoundSystem.PrecacheSound( "turret/tu_die2.wav" );
		g_SoundSystem.PrecacheSound( "turret/tu_die3.wav" );
		g_SoundSystem.PrecacheSound( "turret/tu_retract.wav" );
		g_SoundSystem.PrecacheSound( "turret/tu_deploy.wav" );
		g_SoundSystem.PrecacheSound( "turret/tu_spinup.wav" );
		g_SoundSystem.PrecacheSound( "turret/tu_spindown.wav" );
		g_SoundSystem.PrecacheSound( "turret/tu_search.wav" );
		g_SoundSystem.PrecacheSound( "turret/tu_alert.wav" );
		
		g_SoundSystem.PrecacheSound( "weapons/rocketfire1.wav" ); 
		
		g_SoundSystem.PrecacheSound( "weapons/ofmortar.wav" ); 

		g_Game.PrecacheModel( "models/cnc/cannonturret.mdl" );	

		g_Game.PrecacheModel( TURRET_GLOW_SPRITE );
		g_sModelIndexSmoke = g_Game.PrecacheModel(TURRET_SMOKE);// smoke
		
		m_iBodyGibs = g_Game.PrecacheModel( "models/computergibs.mdl" );
	}

	void Initialize( void )
	{
		m_iOn = false;
		m_fBeserk = false;

		self.SetBoneController( 0, 0 );
		self.SetBoneController( 1, 0 );

		if ( m_iBaseTurnRate == 0 )
			m_iBaseTurnRate = TURRET_TURNRATE;
			
		if ( m_flMaxWait == 0 )
			m_flMaxWait = TURRET_MAXWAIT;
			
		m_flStartYaw = pev.angles.y;
		
		if ( m_iOrientation == 1 )
		{
			self.pev.idealpitch = 180;
			self.pev.angles.x = 180;
			self.pev.view_ofs.z = -pev.view_ofs.z;
			self.pev.effects |= EF_INVLIGHT;
			self.pev.angles.y = self.pev.angles.y + 180;
			if ( self.pev.angles.y > 360 )
				self.pev.angles.y = self.pev.angles.y - 360;
		}

		m_vecGoalAngles.x = 0;

		if ( m_iAutoStart )
		{
			m_flLastSight = g_Engine.time + m_flMaxWait;
			SetThink( ThinkFunction( this.AutoSearchThink ) );	
			self.pev.nextthink = g_Engine.time + .1;
		}
		else
			SetThink( ThinkFunction( self.SUB_DoNothing ) );		
	}

	void TurretUse( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float value )
	{
		if ( !self.ShouldToggle( useType, m_iOn ) )
			return;

		if (m_iOn)
		{
			self.m_hEnemy = null;
			self.pev.nextthink = g_Engine.time + 0.1;
			m_iAutoStart = false;// switching off a turret disables autostart
			SetThink( ThinkFunction( this.Retire ) );
		}
		else 
		{
			self.pev.nextthink = g_Engine.time + 0.1; // turn on delay

			// if the turret is flagged as an autoactivate turret, re-enable it's ability open self.
			if ( self.pev.spawnflags == 32 )
			{
				m_iAutoStart = true;
			}
			SetThink( ThinkFunction( this.Deploy ) );
		}
	}

	void Ping( void )
	{
		// make the pinging noise every second while searching
		if ( m_flPingTime == 0 )
			m_flPingTime = g_Engine.time + 1;
		else if ( m_flPingTime <= g_Engine.time )
		{
			m_flPingTime = g_Engine.time + 1;
			g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_ITEM, "turret/tu_ping.wav", TURRET_MACHINE_VOLUME, ATTN_NORM, 0, 120);
			EyeOn( );
		}
		else if ( m_eyeBrightness > 0 )
		{
			EyeOff( );
		}
	}

	void EyeOn()
	{
		if ( m_pEyeGlow !is null )
		{
			if ( m_eyeBrightness != 255 )
			{
				m_eyeBrightness = 255;
			}
			m_pEyeGlow.SetBrightness( m_eyeBrightness );
		}
	}

	void EyeOff()
	{
		if ( m_pEyeGlow !is null )
		{
			if ( m_eyeBrightness > 0 )
			{
				m_eyeBrightness = Math.max( 0, m_eyeBrightness - 30 );
				m_pEyeGlow.SetBrightness( m_eyeBrightness );
			}
		}
	}

	void ActiveThink( void )
	{
		bool fAttack = false;
		Vector vecDirToEnemy;

		self.pev.nextthink = g_Engine.time + 0.1;
		self.StudioFrameAdvance( );
		
		if ( ( !m_iOn ) || ( self.m_hEnemy.GetEntity() is null ) )
		{
			self.m_hEnemy = null;
			m_flLastSight = g_Engine.time + m_flMaxWait;
			SetThink( ThinkFunction( this.SearchThink ) );
			return;
		}
		
		// if it's dead, look for something new
		if ( !self.m_hEnemy.GetEntity().IsAlive() )
		{
			if ( m_flLastSight <= 0.0 )
			{
				m_flLastSight = g_Engine.time + 0.5; // continue-shooting timeout
			}
			else
			{
				if ( g_Engine.time > m_flLastSight )
				{	
					self.m_hEnemy = null;
					m_flLastSight = g_Engine.time + m_flMaxWait;
					SetThink( ThinkFunction( this.SearchThink ) );
					return;
				}
			}
		}

		Vector vecMid = self.pev.origin + self.pev.view_ofs;
		Vector vecMidEnemy = self.m_hEnemy.GetEntity().BodyTarget( vecMid );

		// Look for our current enemy
		bool fEnemyVisible = FBoxVisible( self.pev, self.pev, vecMidEnemy );
		
		vecDirToEnemy = vecMidEnemy - vecMid;	// calculate dir and dist to enemy
		float flDistToEnemy = vecDirToEnemy.Length();

		Vector vec = Math.VecToAngles(vecMidEnemy - vecMid);	

		// Current enemy is not visible.
		if ( !fEnemyVisible || ( flDistToEnemy > m_fRange ) )
		{
			//g_Game.AlertMessage( at_console, "Not visible\n" );
			if ( m_flLastSight <= 0.0 )
				m_flLastSight = g_Engine.time + 0.5;
			else
			{
				// Should we look for a new target?
				if ( g_Engine.time > m_flLastSight )
				{
					//g_Game.AlertMessage( at_console, "Seeking new target\n" );
					self.m_hEnemy = null;
					m_flLastSight = g_Engine.time + m_flMaxWait;
					SetThink( ThinkFunction( this.SearchThink ) ); 
					return;
				}
			}
			fEnemyVisible = false;
		}
		else
		{
			m_vecLastSight = vecMidEnemy;
		}

		Math.MakeAimVectors( m_vecCurAngles );	
		
		Vector vecLOS = vecDirToEnemy;
		vecLOS = vecLOS.Normalize();

		// Is the Gun looking at the target
		if ( DotProduct( vecLOS, g_Engine.v_forward ) <= 0.866 ) // 30 degree slop
			fAttack = false;
		else
			fAttack = true;

		// fire the gun
		if ( ( fAttack && fEnemyVisible )  ||  m_fBeserk  )
		{
			Vector vecSrc, vecAng;
			self.GetAttachment( 0, vecSrc, vecAng );
			SetTurretAnim( TURRET_ANIM_FIRE );
			Shoot( vecSrc, g_Engine.v_forward );
			
			//Our rocket is in air? Then lets start guiding it :D
			if ( rocketquided !is null && ( !self.m_hEnemy.GetEntity().IsAlive() ) )
			{	
				rocketquided.pev.angles = Math.VecToAngles(vecDirToEnemy);
			}
		} 
		else
		{
			SetTurretAnim( TURRET_ANIM_SPIN );
		}

		//move the gun
		if ( m_fBeserk )
		{
			if ( Math.RandomLong( 0, 9 ) == 0 )
			{
				m_vecGoalAngles.y = Math.RandomFloat( 0, 360 );
				m_vecGoalAngles.x = Math.RandomFloat( 0, 90 ) - 90 * m_iOrientation;
				TakeDamage( pev, pev, 1, DMG_GENERIC ); // don't beserk forever
				return;
			}
		} 
		else if ( fEnemyVisible )
		{
			if ( vec.y > 360 )
				vec.y -= 360;

			if ( vec.y < 0 )
				vec.y += 360;
			
			if ( vec.x < -180 )
				vec.x += 360;

			if ( vec.x > 180 )
				vec.x -= 360;

			// now all numbers should be in [1...360]
			// pin to turret limitations to [-90...15]

			if ( m_iOrientation == 0 )
			{
				if ( vec.x > 90 )
					vec.x = 90;
				else if ( vec.x < m_iMinPitch )
					vec.x = m_iMinPitch;
			}
			else
			{
				if ( vec.x < -90 )
					vec.x = -90;
				else if ( vec.x > -m_iMinPitch )
					vec.x = -m_iMinPitch;
			}
			
			m_vecGoalAngles.y = vec.y;
			m_vecGoalAngles.x = vec.x;

		}

		MoveTurret();
	}


	void Shoot( Vector vecSrc, Vector vecDirToEnemy )
	{
		if ( m_fireLast != 0 ) 
		{
			rocketcount =  ( g_Engine.time - m_fireLast ) * m_fireRate;
			if (rocketcount > 0) 
			{
				@rocketquided = g_EntityFuncs.CreateRPGRocket(vecSrc, Math.VecToAngles(vecDirToEnemy), self.edict());
				
				g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_WEAPON, "weapons/rocketfire1.wav", 1, 0.6, 0, 120);
				
				rocketquided.pev.velocity = rocketquided.pev.velocity.Normalize() * 300;

				m_fireLast = g_Engine.time + (1.0 / m_fireRate);
			}
		}
		else
		{
			m_fireLast = g_Engine.time;
		}
	}

	void Deploy( void )
	{
		self.pev.nextthink = g_Engine.time + 0.1;
		self.StudioFrameAdvance( );

		if ( self.pev.sequence != TURRET_ANIM_DEPLOY )
		{
			m_iOn = true;
			SetTurretAnim( TURRET_ANIM_DEPLOY );
			g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_BODY, "turret/tu_deploy.wav", TURRET_MACHINE_VOLUME, ATTN_NORM, 0, 120);
			self.SUB_UseTargets( self, USE_ON, 0 );
		}

		if ( self.m_fSequenceFinished )
		{
			self.pev.maxs.z = m_iDeployHeight;
			self.pev.mins.z = -m_iDeployHeight;
			g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );

			m_vecCurAngles.x = 0;

			if (m_iOrientation == 1)
			{
				m_vecCurAngles.y = Math.AngleMod( pev.angles.y + 180 );
			}
			else
			{
				m_vecCurAngles.y = Math.AngleMod( pev.angles.y );
			}

			SetTurretAnim( TURRET_ANIM_SPIN );
			self.pev.framerate = 0;
			SetThink( ThinkFunction( this.SearchThink ) );
		}

		m_flLastSight = g_Engine.time + m_flMaxWait;
	}

	void Retire( void )
	{
		// make the turret level
		m_vecGoalAngles.x = 0;
		m_vecGoalAngles.y = m_flStartYaw;

		self.pev.nextthink = g_Engine.time + 0.1;

		self.StudioFrameAdvance( );

		EyeOff( );

		if ( MoveTurret() == 0 )
		{
			if ( self.pev.sequence != TURRET_ANIM_RETIRE )
			{
				SetTurretAnim( TURRET_ANIM_RETIRE );
				g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_BODY, "turret/tu_retract.wav", TURRET_MACHINE_VOLUME, ATTN_NORM, 0, 120);
				self.SUB_UseTargets( self, USE_OFF, 0 );
			}
			else if ( self.m_fSequenceFinished ) 
			{	
				m_iOn = false;
				m_flLastSight = 0;
				SetTurretAnim( TURRET_ANIM_NONE );
				self.pev.maxs.z = m_iRetractHeight;
				self.pev.mins.z = -m_iRetractHeight;
				g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
				if ( m_iAutoStart )
				{
					SetThink( ThinkFunction( this.AutoSearchThink ) );			
					self.pev.nextthink = g_Engine.time + .1;
				}
				else
					SetThink( ThinkFunction( self.SUB_DoNothing ) );
			}
		}
		else
		{
			SetTurretAnim( TURRET_ANIM_SPIN );
		}
	}

	void SetTurretAnim( TURRET_ANIM anim )
	{
		if (self.pev.sequence != anim)
		{
			switch( anim )
			{
			case TURRET_ANIM_FIRE:
				if ( self.pev.sequence != TURRET_ANIM_FIRE && self.pev.sequence != TURRET_ANIM_SPIN )
				{
					self.pev.frame = 0;
				}
				break;
			default:
				self.pev.frame = 0;
				break;
			}

			self.pev.sequence = anim;
			self.ResetSequenceInfo( );

			switch( anim )
			{
			case TURRET_ANIM_RETIRE:
				self.pev.frame			= 255;
				self.pev.framerate		= -1.0;
				break;
			case TURRET_ANIM_DIE:
				self.pev.framerate		= 1.0;
				break;
			}
		}
	}

	//
	// This search function will sit with the turret deployed and look for a new target. 
	// After a set amount of time, the barrel will spin down. After m_flMaxWait, the turret will
	// retact.
	//
	void SearchThink( )
	{
		// ensure rethink
		SetTurretAnim( TURRET_ANIM_SPIN );
		self.StudioFrameAdvance( );
		self.pev.nextthink = g_Engine.time + 0.1;

		Ping();
		
		// If we have a target and we're still healthy
		if ( self.m_hEnemy.GetEntity() !is null )
		{
			if ( !self.m_hEnemy.GetEntity().IsAlive() )
				self.m_hEnemy = null;// Dead enemy forces a search for new one
		}

		// Acquire Target
		if ( self.m_hEnemy.GetEntity() is null )
		{
			self.Look( m_fRange );
			self.m_hEnemy = BestVisibleEnemy();
		}

		// If we've found a target, spin up the barrel and start to attack
		if ( self.m_hEnemy.GetEntity() !is null )
		{
			m_flLastSight = 0;
	
			SetThink( ThinkFunction( this.ActiveThink ) );
		}
		else
		{
			// Are we out of time, do we need to retract?
			if ( g_Engine.time > m_flLastSight )
			{
				//Before we retrace, make sure that we are spun down.
				m_flLastSight = 0;

				SetThink( ThinkFunction( this.Retire ) );
			}
			
			// generic hunt for new victims
			m_vecGoalAngles.y = ( m_vecGoalAngles.y + 0.1 * m_fTurnRate );
			if ( m_vecGoalAngles.y >= 360 )
				m_vecGoalAngles.y -= 360;
			MoveTurret();
		}
	}

	// 
	// This think function will deploy the turret when something comes into range. This is for
	// automatically activated turrets.
	//
	void AutoSearchThink( )
	{
		// ensure rethink
		self.StudioFrameAdvance( );
		self.pev.nextthink = g_Engine.time + 0.3;

		// If we have a target and we're still healthy
		
		if ( self.m_hEnemy.GetEntity() !is null )
		{
			if ( !self.m_hEnemy.GetEntity().IsAlive() )
				self.m_hEnemy = null;// Dead enemy forces a search for new one
		}

		// Acquire Target

		if ( self.m_hEnemy.GetEntity() is null )
		{
			self.Look( m_fRange );
			self.m_hEnemy = BestVisibleEnemy();
		}

		if ( self.m_hEnemy.GetEntity() !is null )
		{
			SetThink( ThinkFunction( this.Deploy ) );
			g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_BODY, "turret/tu_alert.wav", TURRET_MACHINE_VOLUME, ATTN_NORM, 0, 120);
		}
	}

	void TurretDeath( void )
	{
		bool iActive = false;

		self.StudioFrameAdvance( );
		self.pev.nextthink = g_Engine.time + 0.1;

		if ( self.pev.deadflag != DEAD_DEAD )
		{
			self.pev.deadflag = DEAD_DEAD;

			float flRndSound = Math.RandomFloat( 0 , 1 );

			if ( flRndSound <= 0.33 )
				g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_BODY, "turret/tu_die.wav", TURRET_MACHINE_VOLUME, ATTN_NORM, 0, 120);
			else if ( flRndSound <= 0.66 )
				g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_BODY, "turret/tu_die2.wav", TURRET_MACHINE_VOLUME, ATTN_NORM, 0, 120);
			else 
				g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_BODY, "turret/tu_die3.wav", TURRET_MACHINE_VOLUME, ATTN_NORM, 0, 120);

			g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_STATIC, "turret/tu_active2.wav", 0, 0, SND_STOP, 100);
			
			if ( m_iOrientation == 0 )
				m_vecGoalAngles.x = -15;
			else
				m_vecGoalAngles.x = -90;

			SetTurretAnim( TURRET_ANIM_DIE ); 

			EyeOn( );	
		}

		EyeOff( );
		
		if ( self.pev.dmgtime + Math.RandomFloat( 0, 2 ) > g_Engine.time )
		{			
			// lots of smoke
			NetworkMessage smoke( MSG_PVS, NetworkMessages::SVC_TEMPENTITY );
				smoke.WriteByte( TE_SMOKE );
				smoke.WriteCoord( Math.RandomFloat( self.pev.absmin.x, self.pev.absmax.x ) );
				smoke.WriteCoord( Math.RandomFloat( self.pev.absmin.y, self.pev.absmax.y ) );
				smoke.WriteCoord( self.pev.origin.z - m_iOrientation * 64 );
				smoke.WriteShort( g_sModelIndexSmoke );
				smoke.WriteByte( 25 ); // scale * 10
				smoke.WriteByte( 10 - m_iOrientation * 5); // framerate
			smoke.End();
		}
		
		if ( self.pev.dmgtime + Math.RandomFloat( 0, 5 ) > g_Engine.time )
		{
			Vector vecSrc = Vector( Math.RandomFloat( self.pev.absmin.x, self.pev.absmax.x ), Math.RandomFloat( self.pev.absmin.y, self.pev.absmax.y ), 0 );
			if (m_iOrientation == 0)
				vecSrc = vecSrc + Vector( 0, 0, Math.RandomFloat( self.pev.origin.z, self.pev.absmax.z ) );
			else
				vecSrc = vecSrc + Vector( 0, 0, Math.RandomFloat( self.pev.absmin.z, self.pev.origin.z ) );

			g_Utility.Sparks( vecSrc );
		}
	
		if ( self.m_fSequenceFinished && ( MoveTurret() == 0 ) && self.pev.dmgtime + 5 < g_Engine.time )
		{	
			//Explodes
			g_EntityFuncs.CreateExplosion(self.pev.origin, self.pev.angles, self.edict(), 100, true);
			
			Vector vecSpot = self.pev.origin + (self.pev.mins + self.pev.maxs) * 0.5;
			
			uint8 shards = 10;
			uint8  durationshard = 5;
			
			//Gibs
			NetworkMessage gibs( MSG_PVS, NetworkMessages::SVC_TEMPENTITY, vecSpot );
			gibs.WriteByte( TE_BREAKMODEL );
			
			//Position
			gibs.WriteCoord( vecSpot.x );
			gibs.WriteCoord( vecSpot.y );
			gibs.WriteCoord( vecSpot.z );
			
			//Size
			gibs.WriteCoord( self.pev.size.x );
			gibs.WriteCoord( self.pev.size.y );
			gibs.WriteCoord( self.pev.size.z );
			
			//Velocity
			gibs.WriteCoord( 0 );
			gibs.WriteCoord( 0 );
			gibs.WriteCoord( 200 );
			
			//Randomization
			gibs.WriteByte( 20 );
			
			//Model
			gibs.WriteShort( m_iBodyGibs );
			
			//Number of gibs
			gibs.WriteByte( shards );
			
			//Duration
			gibs.WriteByte( durationshard );
			
			//Flags
			gibs.WriteByte( BREAK_METAL + 16 );
			gibs.End();
			
			self.pev.framerate = 0;
			g_EntityFuncs.Remove( self );
		}
	}

	void TraceAttack( entvars_t@ pevAttacker, float flDamage, Vector vecDir, TraceResult ptr, int bitsDamageType)
	{
		if ( ptr.iHitgroup == 10 )
		{
			// hit armor
			if ( self.pev.dmgtime != g_Engine.time || ( Math.RandomLong( 0,10 ) < 1 ) )
			{
				g_Utility.Ricochet( ptr.vecEndPos, Math.RandomFloat( 1, 2 ) );
				self.pev.dmgtime = g_Engine.time;
			}

			flDamage = 0.1;// don't hurt the monster much, but allow bits_COND_LIGHT_DAMAGE to be generated
		}

		if ( self.pev.takedamage == 0 )
			return;

		g_WeaponFuncs.AddMultiDamage( pevAttacker, self, flDamage, bitsDamageType );
	}

	// take damage. bitsDamageType indicates type of damage sustained, ie: DMG_BULLET
	int TakeDamage(entvars_t@ pevInflictor, entvars_t@ pevAttacker, float flDamage, int bitsDamageType)
	{
		if ( self.pev.takedamage == 0  )
			return 0;

		if (!m_iOn)
			flDamage /= 10.0;

		self.pev.health -= flDamage;
		if ( self.pev.health <= 0 )
		{
			self.pev.health = 0;
			self.pev.takedamage = DAMAGE_NO;
			self.pev.dmgtime = g_Engine.time;

			self.pev.flags &= ~FL_MONSTER; // why are they set in the first place???
			
			SetUse( null );
			SetThink( ThinkFunction( this.TurretDeath ) );
			self.SUB_UseTargets( self, USE_ON, 0 ); // wake up others
			self.pev.nextthink = g_Engine.time + 0.1;

			return 0;
		}

		if ( self.pev.health <= 10 )
		{
			if ( m_iOn )
			{
				m_fBeserk = true;
				SetThink( ThinkFunction( this.SearchThink ) );
			}
		}
		
		CBaseEntity@ ptest = g_EntityFuncs.Instance( pevAttacker ); 
		
		//Wrench repair check
		if ( ( ptest !is null ) && ( bitsDamageType == DMG_CLUB ) && CanRepairTurret( ptest ) && ( self.IRelationship( ptest ) <= R_NO ) )
		{
			//Heal
			bIsHealing = true; 
			self.TakeHealth( 25, DMG_CLUB, 1500);
		}
		
		return 1;
	}

	int MoveTurret( void )
	{
		int state = 0;
		// any x movement?
		
		if ( m_vecCurAngles.x != m_vecGoalAngles.x )
		{
			float flDir = m_vecGoalAngles.x > m_vecCurAngles.x ? 1 : -1 ;

			m_vecCurAngles.x += 0.1 * m_fTurnRate * flDir;

			// if we started below the goal, and now we're past, peg to goal
			if ( flDir == 1 )
			{
				if ( m_vecCurAngles.x > m_vecGoalAngles.x )
					m_vecCurAngles.x = m_vecGoalAngles.x;
			} 
			else
			{
				if ( m_vecCurAngles.x < m_vecGoalAngles.x )
					m_vecCurAngles.x = m_vecGoalAngles.x;
			}

			if ( m_iOrientation == 0 )
				self.SetBoneController( 1, -m_vecCurAngles.x );
			else
				self.SetBoneController( 1, m_vecCurAngles.x );
			state = 1;
		}

		if ( m_vecCurAngles.y != m_vecGoalAngles.y )
		{
			float flDir = m_vecGoalAngles.y > m_vecCurAngles.y ? 1 : -1 ;
			float flDist = ( m_vecGoalAngles.y - m_vecCurAngles.y ); //fabs
			
			if ( flDist > 180 )
			{
				flDist = 360 - flDist;
				flDir = -flDir;
			}
			if ( flDist > 30 )
			{
				if ( m_fTurnRate < m_iBaseTurnRate * 10 )
				{
					m_fTurnRate += m_iBaseTurnRate;
				}
			}
			else if ( m_fTurnRate > 45 )
			{
				m_fTurnRate -= m_iBaseTurnRate;
			}
			else
			{
				m_fTurnRate += m_iBaseTurnRate;
			}

			m_vecCurAngles.y += 0.1 * m_fTurnRate * flDir;

			if ( m_vecCurAngles.y < 0 )
				m_vecCurAngles.y += 360;
			else if ( m_vecCurAngles.y >= 360 )
				m_vecCurAngles.y -= 360;

			if ( flDist < ( 0.05 * m_iBaseTurnRate ) )
				m_vecCurAngles.y = m_vecGoalAngles.y;

			if ( m_iOrientation == 0 )
				self.SetBoneController( 0, m_vecCurAngles.y - pev.angles.y );
			else 
				self.SetBoneController( 0, pev.angles.y - 180 - m_vecCurAngles.y );
			state = 1;
		}

		if ( state == 0 )
			m_fTurnRate = m_iBaseTurnRate;

		return state;
	}

	//
	// ID as a machine
	//
	int	Classify ( void )
	{
		if ( m_iOn || m_iAutoStart )
		{
			return	CLASS_PLAYER_ALLY;
		}
		return CLASS_NONE;
	}
	
	//Implements BestVisibleEnemy()
	CBaseEntity@ BestVisibleEnemy()
	{
		CBaseEntity@ pReturn = null;
		
		//Seeks all possible enemies near
		while( ( @pReturn = g_EntityFuncs.FindEntityInSphere( pReturn, self.pev.origin, m_fRange, "monster_apache", "classname" ) ) !is null )
		{
			//Is hostile to us and still alive? Then consider it as target   
			if( self.IRelationship( pReturn ) > ( R_NO ) && pReturn.IsAlive() )
			{
				return pReturn;
			}

		}
		return pReturn;
	}

	//Implements FBoxVisible()
	bool FBoxVisible ( entvars_t@ pevLooker, entvars_t@ pevTarget, Vector vecTargetOrigin )
	{
		// don't look through water
		if ((pevLooker.waterlevel != 3 && pevTarget.waterlevel == 3) 
			|| (pevLooker.waterlevel == 3 && pevTarget.waterlevel == 0))
			return false;

		TraceResult tr;
		Vector	vecLookerOrigin = pevLooker.origin + pevLooker.view_ofs;//look through the monster's 'eyes'
		//for (int i = 0; i < 5; i++)
		//{
			Vector vecTarget = pevTarget.origin;//pevTarget.origin
			vecTarget.x += Math.RandomFloat( pevTarget.mins.x, pevTarget.maxs.x );
			vecTarget.y += Math.RandomFloat( pevTarget.mins.y, pevTarget.maxs.y );
			vecTarget.z += Math.RandomFloat( pevTarget.mins.z, pevTarget.maxs.z );
			
			CBaseEntity@ pHit2 = g_EntityFuncs.Instance( pevTarget );
			
			g_Utility.TraceLine(vecLookerOrigin, vecTarget, dont_ignore_monsters, self.edict(), tr); //ignore_monsters ignore_glass vecTarget pHit2.BodyTarget(pevTarget.origin)
			
			CBaseEntity@ test = g_EntityFuncs.Instance( tr.pHit );
			
			if ( tr.flFraction == 1.0 ) // || test.edict() == pHit2.edict()
			{
				//if ( !self.HasConditions( bits_COND_ENEMY_OCCLUDED ) )
				//{
				//CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );
				//CBaseEntity@ pHit2 = g_EntityFuncs.Instance( pevTarget );
				
				//if ( pHit == pHit2 ) 
				//{
				//if( self.FInViewCone( pHit2 ) )
				//{
					//g_Game.AlertMessage( at_console, "LoS\n" );
					vecTargetOrigin = vecTarget;
					return true;
				//}
				//}
				//}
				
				//return true;// line of sight is valid.
			}
		//}
		//g_Game.AlertMessage( at_console, "No LoS\n" );
		return false;// Line of sight is not established
	}
	
	//Allows to be repairable with the wrench
	bool CanRepairTurret( CBaseEntity @pAttacker )
	{
		if ( pAttacker !is null && pAttacker.IsPlayer() )
		{
			CBasePlayer @pPlayer = cast<CBasePlayer @>( pAttacker );
			if (pPlayer !is null)
			{
				CBasePlayerItem @pClientActiveItem = pPlayer.m_pActiveItem; //m_pClientActiveItem
				if ( pClientActiveItem !is null )
				{
					//Disabled as 01/06/16 is not possible to use sItemInfo
					//ItemInfo sItemInfo;
					//memset( sItemInfo, 0, sizeof( sItemInfo ) );
					//pClientActiveItem.GetItemInfo( sItemInfo );

					// Check m_iDamageGiven in order to prevent repairables from being repaired by thrown crowbars. -Nev
					//if ( sItemInfo.iId == WEAPON_PIPEWRENCH )//&& ( cast<CWrench @>( pClientActiveItem ) ).m_iDamageGiven > 0 )
						return true; //Player is using a pipewrench
				}
			}
		}
		return false;
	}
}

string GetTurretRocketName()
{
	return "monster_turret_rocket";
}

void RegisterTurretRocket()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "monster_turret_rocket", GetTurretRocketName() );
}