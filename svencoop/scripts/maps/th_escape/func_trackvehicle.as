/*
* func_trackvehicle
* This is a vehicle that drives on path_tracks like a tracktrain,
* but is controlled like a vehicle.
*
* Author: Sam "Solokiller" Vanheer
* Modified by: Tomas "GeckoN" Slavotinek
*/

namespace TrackVehicle
{

const string ENTITY_NAME = "func_trackvehicle";
const string CONTROLS_ENTITY_NAME = "func_trackvehiclecontrols";

const double VEHICLE_SPEED0_ACCELERATION = 0.005000000000000000;
const double VEHICLE_SPEED1_ACCELERATION = 0.002142857142857143;
const double VEHICLE_SPEED2_ACCELERATION = 0.003333333333333334;
const double VEHICLE_SPEED3_ACCELERATION = 0.004166666666666667;
const double VEHICLE_SPEED4_ACCELERATION = 0.004000000000000000;
const double VEHICLE_SPEED5_ACCELERATION = 0.003800000000000000;
const double VEHICLE_SPEED6_ACCELERATION = 0.004500000000000000;
const double VEHICLE_SPEED7_ACCELERATION = 0.004250000000000000;
const double VEHICLE_SPEED8_ACCELERATION = 0.002666666666666667;
const double VEHICLE_SPEED9_ACCELERATION = 0.002285714285714286;
const double VEHICLE_SPEED10_ACCELERATION = 0.001875000000000000;
const double VEHICLE_SPEED11_ACCELERATION = 0.001444444444444444;
const double VEHICLE_SPEED12_ACCELERATION = 0.001200000000000000;
const double VEHICLE_SPEED13_ACCELERATION = 0.000916666666666666;
const double VEHICLE_SPEED14_ACCELERATION = 0.001444444444444444;

float Fix(float angle)
{
	while (angle < 0)
		angle += 360;
	while (angle > 360)
		angle -= 360;

	return angle;
}
 
Vector FixupAngles(Vector v)
{
	v.x = Fix(v.x);
	v.y = Fix(v.y);
	v.z = Fix(v.z);

	return v;
}

CTrackVehicle@ GetInstance( CBaseEntity@ pEntity )
{
	if( pEntity.pev.ClassNameIs( ENTITY_NAME ) )
		return cast<CTrackVehicle@>( CastToScriptClass( pEntity ) );

	return null;
}
 
const int TRAIN_STARTPITCH				= 60;
const int TRAIN_MAXPITCH				= 200;
const int TRAIN_MAXSPEED 				= 1000; // approx max speed for sound pitch calculation
 
const int SF_TRACKTRAIN_NOPITCH			= 1;
const int SF_TRACKTRAIN_NOCONTROL		= 2;
const int SF_TRACKTRAIN_FORWARDONLY		= 4;
const int SF_TRACKTRAIN_PASSABLE		= 8;
const int SF_TRACKTRAIN_KEEPRUNNING		= 16;
const int SF_TRACKTRAIN_STARTOFF		= 32;
const int SF_TRACKTRAIN_KEEPSPEED		= 64; // Don't stop on "disable train" path track
 
class CTrackVehicle : ScriptBaseEntity
{
	float m_length;
//	float m_width;
	float m_height;
	float m_startSpeed;
	int m_sounds;
	float m_flVolume;
	float m_flBank;
	int m_acceleration;
	float m_flMaxSpeed;
	float m_oldSpeed;
	float m_dir;
	int m_state;
	
	float m_flStartPitch;
   
	Vector m_controlMins;
	Vector m_controlMaxs;
   
	CPathTrack@ m_ppath;
	
	int	ObjectCaps()
	{
		return (BaseClass.ObjectCaps() & ~FCAP_ACROSS_TRANSITION) | FCAP_DIRECTIONAL_USE;
	}
   
	bool KeyValue( const string& in szKey, const string& in szValue )
	{
		if (szKey == "wheels")
		{
			m_length = atof(szValue);
			return true;
		}
		/*else if (szKey == "width")
		{
			m_width = atof(szValue);
			return true;
		} */
		else if (szKey == "height")
		{
			m_height = atof(szValue);
			return true;
		}
		else if (szKey == "startspeed")
		{
			m_startSpeed = atof(szValue);
			return true;
		}
		else if (szKey == "sounds")
		{
			m_sounds = atoi(szValue);
			return true;
		}
		else if (szKey == "volume")
		{
			m_flVolume = float(atoi(szValue));
			m_flVolume *= 0.1;
			return true;
		}
		else if (szKey == "bank")
		{
			m_flBank = atof(szValue);
			return true;
		}
		else if (szKey == "acceleration")
		{
			m_acceleration = atoi(szValue);

			if (m_acceleration < 1)
				m_acceleration = 1;
			else if (m_acceleration > 10)
				m_acceleration = 10;

			return true;
		}
		else
		{
			return BaseClass.KeyValue( szKey, szValue );
		}
	}
	
	// GeckoN: Used by pev.speed, Can go over the max. speed!
	void ForceSetSpeed( float flSpeed )
	{
		pev.speed = flSpeed;
	}
	
	// GeckoN: Added proper setter
	void SetSpeed( float flSpeed )
	{
		pev.speed = Math.min( flSpeed, m_flMaxSpeed );
	}
	
	// GeckoN: Added proper setter
	void SetMaxSpeed( float flSpeed )
	{
		m_flMaxSpeed = flSpeed;
		pev.impulse = int( m_flMaxSpeed );
		SetSpeed( pev.speed );
	}

	void NextThink(float thinkTime, const bool alwaysThink)
	{
			if (alwaysThink)
				self.pev.flags |= FL_ALWAYSTHINK;
			else
				self.pev.flags &= ~FL_ALWAYSTHINK;

			self.pev.nextthink = thinkTime;
	}

	void Blocked( CBaseEntity@ pOther )
	{
		entvars_t@ pevOther = pOther.pev;

		// Blocker is on-ground on the train
		if (pevOther.FlagBitSet(FL_ONGROUND) && pevOther.groundentity !is null && pevOther.groundentity.vars is self.pev)
		{
			float deltaSpeed = abs(self.pev.speed);
			if ( deltaSpeed > 50 )
				deltaSpeed = 50;
			if ( pevOther.velocity.z == 0 )
				pevOther.velocity.z += deltaSpeed;
			return;
		}
		else
		{
			pevOther.velocity = (pevOther.origin - self.pev.origin ).Normalize() * self.pev.dmg;
		}
		
		/*g_Game.AlertMessage( at_aiconsole, "Vehicle \"%1\" blocked by \"%2\" (dmg: %3)\n",
			string(self.pev.targetname), string(pOther.pev.classname), self.pev.dmg );*/
		if ( self.pev.dmg <= 0 )
			return;
		
		// we can't hurt this thing, so we're not concerned with it
		pOther.TakeDamage(self.pev, self.pev, self.pev.dmg, DMG_CRUSH);
	}

	void Use(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float value)
	{
		float delta = value;

		if (useType != USE_SET)
		{
			if (!self.ShouldToggle(useType, (self.pev.speed != 0)))
				return;

			if (self.pev.speed == 0)
			{
				self.pev.speed = m_flMaxSpeed * m_dir;
				Next();
			}
			else
			{
				self.pev.speed = 0;
				self.pev.velocity = g_vecZero;
				self.pev.avelocity = g_vecZero;
				StopSound();
				SetThink(null);
			}
		}

		if (delta < 10)
		{
			if (delta < 0 && self.pev.speed > 145)
				StopSound();

			if ( m_flMaxSpeed != 0 )
			{
				float flSpeedRatio = delta;

				if (delta > 0)
				{
					flSpeedRatio = self.pev.speed / m_flMaxSpeed;

					if (self.pev.speed < 0)
						flSpeedRatio = m_acceleration * 0.0005 + flSpeedRatio + VEHICLE_SPEED0_ACCELERATION;
					else if (self.pev.speed < 10)
						flSpeedRatio = m_acceleration * 0.0006 + flSpeedRatio + VEHICLE_SPEED1_ACCELERATION;
					else if (self.pev.speed < 20)
						flSpeedRatio = m_acceleration * 0.0007 + flSpeedRatio + VEHICLE_SPEED2_ACCELERATION;
					else if (self.pev.speed < 30)
						flSpeedRatio = m_acceleration * 0.0007 + flSpeedRatio + VEHICLE_SPEED3_ACCELERATION;
					else if (self.pev.speed < 45)
						flSpeedRatio = m_acceleration * 0.0007 + flSpeedRatio + VEHICLE_SPEED4_ACCELERATION;
					else if (self.pev.speed < 60)
						flSpeedRatio = m_acceleration * 0.0008 + flSpeedRatio + VEHICLE_SPEED5_ACCELERATION;
					else if (self.pev.speed < 80)
						flSpeedRatio = m_acceleration * 0.0008 + flSpeedRatio + VEHICLE_SPEED6_ACCELERATION;
					else if (self.pev.speed < 100)
						flSpeedRatio = m_acceleration * 0.0009 + flSpeedRatio + VEHICLE_SPEED7_ACCELERATION;
					else if (self.pev.speed < 150)
						flSpeedRatio = m_acceleration * 0.0008 + flSpeedRatio + VEHICLE_SPEED8_ACCELERATION;
					else if (self.pev.speed < 225)
						flSpeedRatio = m_acceleration * 0.0007 + flSpeedRatio + VEHICLE_SPEED9_ACCELERATION;
					else if (self.pev.speed < 300)
						flSpeedRatio = m_acceleration * 0.0006 + flSpeedRatio + VEHICLE_SPEED10_ACCELERATION;
					else if (self.pev.speed < 400)
						flSpeedRatio = m_acceleration * 0.0005 + flSpeedRatio + VEHICLE_SPEED11_ACCELERATION;
					else if (self.pev.speed < 550)
						flSpeedRatio = m_acceleration * 0.0005 + flSpeedRatio + VEHICLE_SPEED12_ACCELERATION;
					else if (self.pev.speed < 800)
						flSpeedRatio = m_acceleration * 0.0005 + flSpeedRatio + VEHICLE_SPEED13_ACCELERATION;
					else
						flSpeedRatio = m_acceleration * 0.0005 + flSpeedRatio + VEHICLE_SPEED14_ACCELERATION;
				}
				else if (delta < 0)
				{
					flSpeedRatio = self.pev.speed / m_flMaxSpeed;

					if (flSpeedRatio > 0)
						flSpeedRatio -= 0.0125;
					else if (flSpeedRatio <= 0 && flSpeedRatio > -0.05)
						flSpeedRatio -= 0.0075;
					else if (flSpeedRatio <= 0.05 && flSpeedRatio > -0.1)
						flSpeedRatio -= 0.01;
					else if (flSpeedRatio <= 0.15 && flSpeedRatio > -0.15)
						flSpeedRatio -= 0.0125;
					else if (flSpeedRatio <= 0.15 && flSpeedRatio > -0.22)
						flSpeedRatio -= 0.01375;
					else if (flSpeedRatio <= 0.22 && flSpeedRatio > -0.3)
						flSpeedRatio -= - 0.0175;
					else if (flSpeedRatio <= 0.3)
						flSpeedRatio -= 0.0125;
				}

				if (flSpeedRatio > 1)
					flSpeedRatio = 1;
				else if (flSpeedRatio < -0.35)
					flSpeedRatio = -0.35;

				self.pev.speed = m_flMaxSpeed * flSpeedRatio;
			}
			else
			{
				self.pev.speed = 0;
			}
			Next();
			
			if ( m_flAcceleratorDecay >= 0 )
				m_flAcceleratorDecay = g_Engine.time + 0.25;
		}
	}

	void StopSound()
	{
		if (m_state <= 0 || string( self.pev.noise ).IsEmpty())
			return;
		
		if ( (self.pev.spawnflags & SF_TRACKTRAIN_KEEPRUNNING) != 0 )
		{
			m_state = 1;
		}
		else
		{
			g_SoundSystem.StopSound(self.edict(), CHAN_STATIC, self.pev.noise);
			m_state = 0;
		}
		/*if (m_sounds < 5)
			g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_ITEM, "th_escape/stickshift.flac", m_flVolume, ATTN_NORM, 0, 100 ); // "plats/ttrain_brake1.wav"
		*/
	}
	
	void UpdateSound()
	{
		if ( string( self.pev.noise ).IsEmpty())
			return;
			
		if ( m_state == -1 )
		{
			g_SoundSystem.EmitSoundDyn(self.edict(), CHAN_STATIC, self.pev.noise, m_flVolume, ATTN_NORM, m_flStartPitch == 100 ? 0 : SND_CHANGE_PITCH, int(m_flStartPitch));
			
			m_flStartPitch -= 1;
			if ( m_flStartPitch <= TRAIN_STARTPITCH )
			{
				m_flStartPitch = TRAIN_STARTPITCH;
				//m_state = 1;
			}
			return;
		}

		if ( m_state < 0 )
			return;

		float flpitch = TRAIN_STARTPITCH + (abs(int(self.pev.speed)) * (TRAIN_MAXPITCH - TRAIN_STARTPITCH) / TRAIN_MAXSPEED);

		if (m_state < 2)
		{
			// play startup sound for train
			//g_SoundSystem.EmitSoundDyn(self.edict(), CHAN_ITEM, "th_escape/shiftstick.flac", m_flVolume, ATTN_NORM, 0, 100); // "plats/ttrain_start1.wav"
			if (m_state < 1)
				g_SoundSystem.EmitSoundDyn(self.edict(), CHAN_STATIC, self.pev.noise, m_flVolume, ATTN_NORM, 0, int(flpitch));
			m_state = 2;
		}
		else
		{
			g_SoundSystem.EmitSoundDyn(self.edict(), CHAN_STATIC, self.pev.noise, m_flVolume, ATTN_NORM, SND_CHANGE_PITCH, int(flpitch));
		}
	}
	
	void Next()
	{
		if ( m_flAcceleratorDecay >= 0 && g_Engine.time > m_flAcceleratorDecay)
		{
			if (self.pev.speed < 0)
			{
				self.pev.speed += 20;

				if (self.pev.speed > 0)
					self.pev.speed = 0;
			}
			else if (self.pev.speed > 0)
			{
				self.pev.speed -= 20;

				if (self.pev.speed < 0)
					self.pev.speed = 0;
			}
			
			m_flAcceleratorDecay = g_Engine.time + 0.1;
		}
		
		//g_Game.AlertMessage( at_console, "Vehicle \"%1\" speed is %1 Units/Sec, %2 MPH\n", self.pev.speed, (self.pev.speed * 15 / 352 ) );
		
		float time = 0.5;

		if ( self.pev.speed == 0 )
		{
			//g_Game.AlertMessage( at_aiconsole, "Vehicle \"%1\" speed is 0\n", string(self.pev.targetname) );
			if ( (self.pev.spawnflags & SF_TRACKTRAIN_KEEPRUNNING) != 0 )
			{
				UpdateSound();
				NextThink( self.pev.ltime + time, true );
			}
			else
			{
				StopSound();
			}

			self.pev.velocity = g_vecZero;
			self.pev.avelocity = g_vecZero;
			
			return;
		}

		if ( m_ppath is null )
		{      
			g_Game.AlertMessage( at_warning, "Vehicle \"%1\" lost path!\n", string(self.pev.targetname) );
			StopSound();
			return;
		}

		UpdateSound();

		Vector nextPos = self.pev.origin;

		nextPos.z -= m_height;
		CPathTrack@ pnext = m_ppath.LookAhead( nextPos, nextPos, self.pev.speed * 0.1, true );
		nextPos.z += m_height;

		self.pev.velocity = (nextPos - self.pev.origin) * 10;
		Vector nextFront = self.pev.origin;

		nextFront.z -= m_height;
		if ( m_length > 0 )
			m_ppath.LookAhead( nextFront, nextFront, m_length, false );
		else
			m_ppath.LookAhead( nextFront, nextFront, 100, false );
		nextFront.z += m_height;

		Vector delta = nextFront - self.pev.origin;
		Vector angles = Math.VecToAngles( delta );
		// The train actually points west
		angles.y += 180;

		// !!!  All of this crap has to be done to make the angles not wrap around, revisit this.
		angles = FixupAngles( angles );
		self.pev.angles = FixupAngles( self.pev.angles );

		if ( pnext is null || (delta.x == 0 && delta.y == 0) )
			angles = self.pev.angles;

		float vy, vx;
		if ( (self.pev.spawnflags & SF_TRACKTRAIN_NOPITCH) == 0 )
			vx = Math.AngleDistance( angles.x, self.pev.angles.x );
		else
			vx = 0;
		vy = Math.AngleDistance( angles.y, self.pev.angles.y );

		self.pev.avelocity.y = vy * 10;
		self.pev.avelocity.x = vx * 10;

		if ( m_flBank != 0 )
		{
			if ( self.pev.avelocity.y < -5 )
				self.pev.avelocity.z = Math.AngleDistance( Math.ApproachAngle( -m_flBank, self.pev.angles.z, m_flBank*2 ), self.pev.angles.z);
			else if ( self.pev.avelocity.y > 5 )
				self.pev.avelocity.z = Math.AngleDistance( Math.ApproachAngle( m_flBank, self.pev.angles.z, m_flBank*2 ), self.pev.angles.z);
			else
				self.pev.avelocity.z = Math.AngleDistance( Math.ApproachAngle( 0, self.pev.angles.z, m_flBank*4 ), self.pev.angles.z) * 4;
		}
		
		if ( pnext !is null )
		{
			if ( pnext != m_ppath )
			{
				CPathTrack@ pFire;
				if ( self.pev.speed >= 0 )
					@pFire = pnext;
				else
					@pFire = m_ppath;

				@m_ppath = pnext;
				// Fire the pass target if there is one
				if ( !string( pFire.pev.message ).IsEmpty() )
				{
					g_EntityFuncs.FireTargets( string(pFire.pev.message), self, self, USE_TOGGLE, 0 );
					if ( pFire.pev.SpawnFlagBitSet( SF_PATH_FIREONCE ) )
						pFire.pev.message = 0;
				}

				if ( ( pFire.pev.spawnflags & SF_PATH_DISABLE_TRAIN ) != 0 )
				{
					self.pev.spawnflags |= SF_TRACKTRAIN_NOCONTROL;
					if ( ( self.pev.spawnflags & SF_TRACKTRAIN_KEEPSPEED ) != 0 )
						m_flAcceleratorDecay = -1;
				}
				
				float flPrevSpeed = pev.speed;
			   
				// Don't override speed if under user control
				if ( ( self.pev.spawnflags & SF_TRACKTRAIN_NOCONTROL ) != 0 )
				{
					if ( pFire.pev.speed != 0 )
					{
						// don't copy speed from target if it is 0 (uninitialized)
						ForceSetSpeed( pFire.pev.speed );
					}
				}
				
				// GeckoN: Set new max. speed; ignore if it's -1 (not set)
				if ( pFire.m_flMaxSpeed >= 0 )
				{
					SetMaxSpeed( pFire.m_flMaxSpeed );
				}
				// GeckoN: Set new speed; ignore if it's -1 (not set)
				if ( pFire.m_flNewSpeed >= 0 )
				{
					SetSpeed( pFire.m_flNewSpeed );
				}

				if ( pev.speed != flPrevSpeed )
				{
					g_Game.AlertMessage( at_aiconsole, "TrackTrain %1 speed to %2\n", string(self.pev.targetname), self.pev.speed );
				}

			}
			SetThink( ThinkFunction( this.Next ) );
			NextThink( self.pev.ltime + time, true );
		}
		else    // end of path, stop
		{
			StopSound();
			self.pev.velocity = (nextPos - self.pev.origin);
			self.pev.avelocity = g_vecZero;
			float distance = self.pev.velocity.Length();
			m_oldSpeed = self.pev.speed;

			self.pev.speed = 0;
		   
			// Move to the dead end
		   
			// Are we there yet?
			if ( distance > 0 )
			{
				// no, how long to get there?
				time = distance / m_oldSpeed;
				self.pev.velocity = self.pev.velocity * (m_oldSpeed / distance);
				SetThink( ThinkFunction( this.DeadEnd ) );
				NextThink( self.pev.ltime + time, false );
			}
			else
			{
				DeadEnd();
			}
		}
	}
   
	void DeadEnd()
	{
		// Fire the dead-end target if there is one
		CPathTrack@ pTrack, pNext;

		@pTrack = m_ppath;

		g_Game.AlertMessage( at_warning, "Vehicle \"%1\" dead end\n", string(self.pev.targetname) );
		// Find the dead end path node
		// HACKHACK -- This is bugly, but the train can actually stop moving at a different node depending on it's speed
		// so we have to traverse the list to it's end.
		if ( pTrack !is null )
		{
			if ( m_oldSpeed < 0 )
			{
				do
				{
					@pNext = pTrack.ValidPath( pTrack.GetPrevious(), true );
					if ( pNext !is null )
						@pTrack = pNext;
				}
				while ( pNext !is null );
			}
			else
			{
				do
				{
					@pNext = pTrack.ValidPath( pTrack.GetNext(), true );
					if ( pNext !is null )
						@pTrack = pNext;
				}
				while ( pNext !is null );
			}
		}

		// GeckoN: TODO
		/*if ( m_flAcceleratorDecay < 0 )
			m_flAcceleratorDecay = g_Engine.time + 0.25;*/
		
		self.pev.velocity = g_vecZero;
		self.pev.avelocity = g_vecZero;
		if ( pTrack !is null )
		{
			g_Game.AlertMessage( at_aiconsole, "At \"%1\"\n", string(pTrack.pev.targetname) );
			if ( !string( pTrack.pev.netname ).IsEmpty() )
				g_EntityFuncs.FireTargets( string(pTrack.pev.netname), self, self, USE_TOGGLE, 0 );
		}
	}


	void SetControls( entvars_t@ pevControls )
	{
		Vector offset = pevControls.origin - self.pev.oldorigin;

		m_controlMins = pevControls.mins + offset;
		m_controlMaxs = pevControls.maxs + offset;
	}


	bool OnControls(entvars_t@ pevTest)
	{
		Vector offset = pevTest.origin - self.pev.origin;

		if ( ( self.pev.spawnflags & SF_TRACKTRAIN_NOCONTROL ) != 0 )
		{
			//g_Game.AlertMessage( at_console, "Can't use, vehicle controls disabled!\n" );
			return false;
		}

		// Transform offset into local coordinates
		Math.MakeVectors( self.pev.angles );
	   
		Vector local;
		local.x = DotProduct(offset, g_Engine.v_forward);
		local.y = -DotProduct(offset, g_Engine.v_right);
		local.z = DotProduct(offset, g_Engine.v_up);

		if (local.x >= m_controlMins.x && local.y >= m_controlMins.y && local.z >= m_controlMins.z &&
			local.x <= m_controlMaxs.x && local.y <= m_controlMaxs.y && local.z <= m_controlMaxs.z)
			return true;

		return false;
	}
   
	void  Find()
	{
		@m_ppath = cast<CPathTrack@>( g_EntityFuncs.FindEntityByTargetname( null, self.pev.target ) );
		if ( m_ppath is null )
			return;

		entvars_t@ pevTarget = m_ppath.pev;
		
		if (!pevTarget.ClassNameIs( "path_track" ))
		{
			g_Game.AlertMessage( at_error, "func_trackvehicle must be on a path of path_track\n" );
			@m_ppath = null;
			return;
		}

		Vector nextPos = pevTarget.origin;
		nextPos.z += m_height;

		Vector look = nextPos;
		look.z -= m_height;
		//g_Game.AlertMessage( at_console, "first path: %1\n", look.ToString() );
		m_ppath.LookAhead( look, look, m_length, false );
		look.z += m_height;
		//g_Game.AlertMessage( at_console, "second path: %1\n", look.ToString() );

		self.pev.angles = Math.VecToAngles( look - nextPos );
		// The train actually points west
		self.pev.angles.y += 180;

		if ( ( self.pev.spawnflags & SF_TRACKTRAIN_NOPITCH ) != 0 )
			self.pev.angles.x = 0;
			   
		g_EntityFuncs.SetOrigin( self, nextPos );
		NextThink( self.pev.ltime + 0.1, false );
		SetThink( ThinkFunction( this.Next ) );
		self.pev.speed = m_startSpeed;

		UpdateSound();
	}

	void NearestPath()
	{
		CBaseEntity@ pTrack = null;
		CBaseEntity@ pNearest = null;
		float dist = 0.0f;
		float closest = 1024;

		while ((@pTrack = @g_EntityFuncs.FindEntityInSphere( pTrack, self.pev.origin, 1024 )) !is null)
		{
			// filter out non-tracks
			if ( ( pTrack.pev.flags & (FL_CLIENT|FL_MONSTER) ) == 0 && pTrack.pev.ClassNameIs( "path_track" ) )
			{
				dist = (self.pev.origin - pTrack.pev.origin).Length();
				if ( dist < closest )
				{
					closest = dist;
					@pNearest = @pTrack;
				}
			}
		}

		if (pNearest is null)
		{
			g_Game.AlertMessage( at_console, "Vehicle \"%1\" can't find a nearby track!\n", self.pev.targetname );
			SetThink( null );
			return;
		}

		g_Game.AlertMessage( at_aiconsole, "Vehicle \"%1\" nearest track is %2\n", self.pev.targetname, pNearest.pev.targetname );
		
		// If I'm closer to the next path_track on this path, then it's my real path
		@pTrack = cast<CPathTrack@>(pNearest).GetNext();
	   
		if (pTrack !is null)
		{
			if ( (self.pev.origin - pTrack.pev.origin).Length() < (self.pev.origin - pNearest.pev.origin).Length() )
				@pNearest = pTrack;
		}

		@m_ppath = cast<CPathTrack@>(pNearest);

		if ( self.pev.speed != 0 )
		{
			NextThink( self.pev.ltime + 0.1, false );
			SetThink( ThinkFunction( this.Next ) );
		}
	}


	void OverrideReset()
	{
		NextThink( self.pev.ltime + 0.1, false );
		SetThink( ThinkFunction( this.NearestPath ) );
	}
	
	CBasePlayer@ GetDriver()
	{
		return m_pDriver;
	}
	
	void SetDriver( CBasePlayer@ pDriver )
	{
		@m_pDriver = @pDriver;

		if( pDriver !is null )
		{
			g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_ITEM, "th_escape/diesel_rev.flac", 0.8, ATTN_NORM, 0, PITCH_NORM ); // "plats/vehicle_ignition.wav"
		}
	}
	
	float m_flAcceleratorDecay;
	CBasePlayer@ m_pDriver;
	
	void IgnitionOn()
	{
		if ( m_state > -2 )
			return;
		
		NextThink( self.pev.ltime + 1.4, false );
		SetThink( ThinkFunction( this.Starting ) );
		
		g_SoundSystem.EmitSoundDyn(self.edict(), CHAN_ITEM, "th_escape/diesel_ignition-rev.flac", m_flVolume, ATTN_NORM, 0, 100); // "plats/ttrain_start1.wav"
		
	}
	
	void Starting()
	{
		if ( m_state == -2 )
		{
			if ( (self.pev.spawnflags & SF_TRACKTRAIN_KEEPRUNNING) != 0 )
			{
				m_state = -1;
				m_flStartPitch = 100;
			}
			else
			{
				m_state = 0;
			}
		}
		
		if ( m_state < 0 )
		{
			UpdateSound();
			NextThink( self.pev.ltime + 0.1, false );
		}
	}
	
	void EnableControls()
	{
		self.pev.spawnflags &= ~SF_TRACKTRAIN_NOCONTROL;
		m_state = 1;
		UpdateSound();
		NextThink( self.pev.ltime + 0.1, false );
		SetThink( ThinkFunction( this.Next ) );
	}
	
	int TRAIN_DEFAULT_SPEED = 100;
	
	void Spawn()
	{
		int iSpeed = int( pev.speed ); 
		SetMaxSpeed( iSpeed == 0 ? TRAIN_DEFAULT_SPEED : iSpeed );
		SetSpeed( 0 );

		self.pev.velocity = g_vecZero;
		self.pev.avelocity = g_vecZero;

		m_dir = 1;

		if ( string(self.pev.target) .IsEmpty() )
			g_Game.AlertMessage( at_console, "FuncTrain with no target" );

		if ( ( self.pev.spawnflags & SF_TRACKTRAIN_PASSABLE ) != 0 )
			self.pev.solid = SOLID_NOT;
		else
			self.pev.solid = SOLID_BSP;
		self.pev.movetype = MOVETYPE_PUSH;
		
		g_EntityFuncs.SetModel( self, self.pev.model );

		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		// Cache off placed origin for train controls
		self.pev.oldorigin = self.pev.origin;

		m_controlMins = self.pev.mins;
		m_controlMaxs = self.pev.maxs;
		m_controlMaxs.z += 72;
		// start trains on the next frame, to make sure their targets have had
		// a chance to spawn/activate
		NextThink( self.pev.ltime + 0.1, false );
		SetThink( ThinkFunction( this.Find ) );
		Precache();
		
		// GeckoN: HACK!
		self.pev.spawnflags |= SF_TRACKTRAIN_KEEPRUNNING | SF_TRACKTRAIN_STARTOFF | SF_TRACKTRAIN_KEEPSPEED;
		
		if ( (self.pev.spawnflags & SF_TRACKTRAIN_STARTOFF) != 0 )
		{
			m_state = -2;
			self.pev.spawnflags |= SF_TRACKTRAIN_NOCONTROL;
		}
		else if ( (self.pev.spawnflags & SF_TRACKTRAIN_KEEPRUNNING) != 0 )
		{
			float flpitch = TRAIN_STARTPITCH;
			g_SoundSystem.EmitSoundDyn(self.edict(), CHAN_STATIC, self.pev.noise, m_flVolume, ATTN_NORM, 0, int(flpitch));
			m_state = 1;
		}
		else
		{
			m_state = 0;
		}
	}

	void Precache()
	{
		if (m_flVolume == 0.0)
			m_flVolume = 1.0;

		if ( m_sounds <= 0 )
		{
			// no sound
			self.pev.noise = "";
		}
		else
		{
			self.pev.noise = "th_escape/diesel_idle_loop.flac";
			g_SoundSystem.PrecacheSound( self.pev.noise );
		}

		g_SoundSystem.PrecacheSound( "th_escape/repairsnd02.flac" );
		g_SoundSystem.PrecacheSound( "th_escape/diesel_rev.flac" );
		g_SoundSystem.PrecacheSound( "th_escape/diesel_ignition-rev.flac" );
	}
}

class CTrackVehicleControls : ScriptBaseEntity
{
	int ObjectCaps()
	{
		return ( BaseClass.ObjectCaps() & ~FCAP_ACROSS_TRANSITION );
	}
	
	//Overriden because the default rules don't work correctly here
	bool IsBSPModel()
	{
		return true;
	}
	
	void Spawn()
	{
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;
		
		g_EntityFuncs.SetModel( self, self.pev.model );

		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		SetThink( ThinkFunction( Find ) );
		self.pev.nextthink = g_Engine.time;
	}
	
	void Find()
	{
		CBaseEntity@ pTarget = null;
		
		do
		{
			@pTarget = @g_EntityFuncs.FindEntityByTargetname(pTarget, self.pev.target);
		}
		while (pTarget !is null && !pTarget.pev.ClassNameIs( ENTITY_NAME ) );
		
		CTrackVehicle@ ptrain = null;

		if( pTarget !is null )
		{
			@ptrain = @GetInstance( pTarget );
			
			//Only set controls if this is a non-RC control
			if( ptrain !is null )
				ptrain.SetControls( self.pev );
		}
		else
			g_Game.AlertMessage( at_console, "No func_trackvehicle \"%1\"\n", self.pev.target );

		g_EntityFuncs.Remove( self );
	}
}

HookReturnCode VehiclePlayerUse( CBasePlayer@ pPlayer, uint& out uiFlags )
{
	if ( ( pPlayer.m_afButtonPressed & IN_USE ) == 0 )
		return HOOK_CONTINUE;
	
	if ( pPlayer.m_hTank.IsValid() )
		return HOOK_CONTINUE;
	
	if ( ( pPlayer.m_afPhysicsFlags & PFLAG_ONTRAIN ) != 0 )
	{
		pPlayer.m_afPhysicsFlags &= ~PFLAG_ONTRAIN;
		pPlayer.m_iTrain = TRAIN_NEW|TRAIN_OFF;

		CBaseEntity@ pTrain = g_EntityFuncs.Instance( pPlayer.pev.groundentity );

		// Stop driving this vehicle if +use again
		if( pTrain !is null )
		{
			CTrackVehicle@ pVehicle = cast<CTrackVehicle@>( CastToScriptClass( pTrain ) );
			
			if( pVehicle !is null )
				pVehicle.SetDriver( null );
		}

		uiFlags |= PlrHook_SkipUse;
	}
	else
	{
		// Start controlling the train!
		CBaseEntity@ pTrain = g_EntityFuncs.Instance( pPlayer.pev.groundentity );
		
		if ( pTrain !is null && (pPlayer.pev.button & IN_JUMP) == 0 && pPlayer.pev.FlagBitSet( FL_ONGROUND ) &&
			(pTrain.ObjectCaps() & FCAP_DIRECTIONAL_USE) != 0 && pTrain.OnControls(pPlayer.pev) )
		{
			pPlayer.m_afPhysicsFlags |= PFLAG_ONTRAIN;
			pPlayer.m_iTrain = TrainSpeed(int(pTrain.pev.speed), pTrain.pev.impulse);
			pPlayer.m_iTrain |= TRAIN_NEW;
			// Start driving this vehicle
			CTrackVehicle@ pVehicle = cast<CTrackVehicle@>( CastToScriptClass( pTrain ) );
				
			if( pVehicle !is null )
				pVehicle.SetDriver( pPlayer );
				
			uiFlags |= PlrHook_SkipUse;
		}
	}
	
	return HOOK_CONTINUE;
}

//If player in air, disable control of train
bool HandlePlayerInAir( CBasePlayer@ pPlayer, CBaseEntity@ pTrain )
{
	if ( !pPlayer.pev.FlagBitSet( FL_ONGROUND ) )
	{
		// Turn off the train if you jump, strafe, or the train controls go dead
		pPlayer.m_afPhysicsFlags &= ~PFLAG_ONTRAIN;
		pPlayer.m_iTrain = TRAIN_NEW|TRAIN_OFF;
		
		return true;
	}
	
	return false;
}

HookReturnCode VehiclePlayerPreThink( CBasePlayer@ pPlayer, uint& out uiFlags )
{
	CBaseEntity@ pTrain = null;
	
	if ( ( pPlayer.m_afPhysicsFlags & PFLAG_ONTRAIN ) != 0 )
	{
		pPlayer.pev.flags |= FL_ONTRAIN;
	
		@pTrain = @g_EntityFuncs.Instance( pPlayer.pev.groundentity );
		
		if ( pTrain is null )
		{
			TraceResult trainTrace;
			// Maybe this is on the other side of a level transition
			g_Utility.TraceLine( pPlayer.pev.origin, pPlayer.pev.origin + Vector(0,0,-38), ignore_monsters, pPlayer.edict(), trainTrace );

			// HACKHACK - Just look for the func_tracktrain classname
			if ( trainTrace.flFraction != 1.0 && trainTrace.pHit !is null )
				@pTrain = @g_EntityFuncs.Instance( trainTrace.pHit );

			if ( pTrain is null || (pTrain.ObjectCaps() & FCAP_DIRECTIONAL_USE) == 0 || !pTrain.OnControls(pPlayer.pev) )
			{
				//ALERT( at_error, "In train mode with no train!\n" );
				pPlayer.m_afPhysicsFlags &= ~PFLAG_ONTRAIN;
				pPlayer.m_iTrain = TRAIN_NEW|TRAIN_OFF;

				//Set driver to NULL if we stop driving the vehicle
				if( pTrain !is null )
				{
					CTrackVehicle@ pVehicle = cast<CTrackVehicle@>( CastToScriptClass( pTrain ) );
					
					if( pVehicle !is null )
						pVehicle.SetDriver( null );
				}
				
				uiFlags |= PlrHook_SkipVehicles;
				return HOOK_CONTINUE;
			}
		}
		else if ( HandlePlayerInAir( pPlayer, pTrain ) )
		{
			g_Game.AlertMessage( at_console, "in air\n" );
			uiFlags |= PlrHook_SkipVehicles;
			return HOOK_CONTINUE;
		}

		float vel = 0;
			
		CTrackVehicle@ pVehicle = cast<CTrackVehicle@>( CastToScriptClass( pTrain ) );
		
		if( pVehicle is null )
			return HOOK_CONTINUE;
			
		int buttons = pPlayer.pev.button;
		
		if( ( buttons & IN_FORWARD ) != 0 )
		{
			vel = 1;
			pTrain.Use( pPlayer, pPlayer, USE_SET, vel );
		}

		if( ( buttons & IN_BACK ) != 0 )
		{
			vel = -1;
			pTrain.Use( pPlayer, pPlayer, USE_SET, vel );
		}

		if( ( buttons & IN_MOVELEFT ) != 0 )
		{
			vel = 20;
			pTrain.Use( pPlayer, pPlayer, USE_SET, vel );
		}

		if( ( buttons & IN_MOVERIGHT ) != 0 )
		{
			vel = 30;
			pTrain.Use( pPlayer, pPlayer, USE_SET, vel );
		}

		if (vel != 0)
		{
			pPlayer.m_iTrain = TrainSpeed(int(pTrain.pev.speed), pTrain.pev.impulse);
			pPlayer.m_iTrain |= TRAIN_ACTIVE|TRAIN_NEW;
		}
	}
	else 
		pPlayer.pev.flags &= ~FL_ONTRAIN;
	
	return HOOK_CONTINUE;
}

void RegisterHooks()
{
	g_Hooks.RegisterHook( Hooks::Player::PlayerUse, @TrackVehicle::VehiclePlayerUse );
	g_Hooks.RegisterHook( Hooks::Player::PlayerPreThink, @TrackVehicle::VehiclePlayerPreThink );
}

void RemoveHooks()
{
	g_Hooks.RemoveHook( Hooks::Player::PlayerUse, @TrackVehicle::VehiclePlayerUse );
	g_Hooks.RemoveHook( Hooks::Player::PlayerPreThink, @TrackVehicle::VehiclePlayerPreThink );
}

void Register( bool fRegisterHooks = true )
{
	g_CustomEntityFuncs.RegisterCustomEntity( "TrackVehicle::CTrackVehicle", ENTITY_NAME );
	g_CustomEntityFuncs.RegisterCustomEntity( "TrackVehicle::CTrackVehicleControls", CONTROLS_ENTITY_NAME );
	
	if ( fRegisterHooks )
	{
		RegisterHooks();
	}
}

} // end of namespace
