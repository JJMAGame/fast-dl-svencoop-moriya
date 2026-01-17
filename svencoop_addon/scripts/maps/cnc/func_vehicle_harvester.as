/*
*	func_vehicle_harvester
*	Based on funch_vehicle_custom created by Solokiller
*
*	Anggara_nothing
*/

#include "cnc_stock_misc"

namespace CNC
{	
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

	const int VEHICLE_STARTPITCH = 60;
	const int VEHICLE_MAXPITCH = 200;
	const int VEHICLE_MAXSPEED = 1500;

	// Break Model Defines
	const uint8 BREAK_TYPEMASK		=	0x4F;
	const uint8 BREAK_GLASS			=	0x01;
	const uint8 BREAK_METAL			=	0x02;
	const uint8 BREAK_FLESH			=	0x04;
	const uint8 BREAK_WOOD			=	0x08;
	const uint8 BREAK_SMOKE			=	0x10;
	const uint8 BREAK_TRANS			=	0x20;
	const uint8 BREAK_CONCRETE		=	0x40;
	const uint8 BREAK_2				=	0x80;

	enum FuncVehicleHarvesterFlags
	{
		SF_HARVESTER_NODEFAULTCONTROLS = 1 << 0 //Don't make a controls volume by default
	}
	
	const string[] pSoundsWood =
	{
		"debris/wood1.wav",
		"debris/wood2.wav",
		"debris/wood3.wav",
	};

	const string[] pSoundsFlesh =
	{
		"debris/flesh1.wav",
		"debris/flesh2.wav",
		"debris/flesh3.wav",
		"debris/flesh5.wav",
		"debris/flesh6.wav",
		"debris/flesh7.wav",
	};

	const string[] pSoundsMetal =
	{
		"debris/metal1.wav",
		"debris/metal2.wav",
		"debris/metal3.wav",
	};

	const string[] pSoundsConcrete =
	{
		"debris/concrete1.wav",
		"debris/concrete2.wav",
		"debris/concrete3.wav",
	};

	const string[] pSoundsGlass =
	{
		"debris/glass1.wav",
		"debris/glass2.wav",
		"debris/glass3.wav",
	};

	class func_vehicle_harvester : ScriptBaseEntity
	{
		string[] MaterialSoundList( Materials precacheMaterial, int &out soundCount )
		{
			string[] pSoundList;

			switch( precacheMaterial )
			{
			case matWood:
				pSoundList = pSoundsWood;
				soundCount = pSoundsWood.length();
				break;
			case matFlesh:
				pSoundList = pSoundsFlesh;
				soundCount = pSoundsFlesh.length();
				break;
			case matComputer:
			case matUnbreakableGlass:
			case matGlass:
				pSoundList = pSoundsGlass;
				soundCount = pSoundsGlass.length();
				break;
			case matMetal:
				pSoundList = pSoundsMetal;
				soundCount = pSoundsMetal.length();
				break;
			case matCinderBlock:
			case matRocks:
				pSoundList = pSoundsConcrete;
				soundCount = pSoundsConcrete.length();
				break;
			case matCeilingTile:
			case matNone:
			default:
				soundCount = 0;
				break;
			}

			return pSoundList;
		}
		
		void MaterialSoundPrecache( Materials precacheMaterial )
		{
			string[] pSoundList;
			int i, soundCount = 0;

			pSoundList = MaterialSoundList( precacheMaterial, soundCount );

			for( i = 0; i < soundCount; i++ )
			{
				g_SoundSystem.PrecacheSound( pSoundList[i] );
			}
		}
		
		void PrecacheMaterials()
		{
			string pGibName;
			switch( m_Material )
			{
			case matWood:
				pGibName = "models/woodgibs.mdl";

				g_SoundSystem.PrecacheSound( "debris/bustcrate1.wav" );
				g_SoundSystem.PrecacheSound( "debris/bustcrate2.wav" );
				break;
			case matFlesh:
				pGibName = "models/fleshgibs.mdl";

				g_SoundSystem.PrecacheSound( "debris/bustflesh1.wav" );
				g_SoundSystem.PrecacheSound( "debris/bustflesh2.wav" );
				break;
			case matComputer:
				g_SoundSystem.PrecacheSound( "buttons/spark5.wav" );
				g_SoundSystem.PrecacheSound( "buttons/spark6.wav" );
				pGibName = "models/computergibs.mdl";

				g_SoundSystem.PrecacheSound( "debris/bustmetal1.wav" );
				g_SoundSystem.PrecacheSound( "debris/bustmetal2.wav" );
				break;
			case matUnbreakableGlass:
			case matGlass:
				pGibName = "models/glassgibs.mdl";

				g_SoundSystem.PrecacheSound( "debris/bustglass1.wav" );
				g_SoundSystem.PrecacheSound( "debris/bustglass2.wav" );
				break;
			case matMetal:
				pGibName = "models/metalplategibs.mdl";

				g_SoundSystem.PrecacheSound( "debris/bustmetal1.wav" );
				g_SoundSystem.PrecacheSound( "debris/bustmetal2.wav" );
				break;
			case matCinderBlock:
				pGibName = "models/cindergibs.mdl";

				g_SoundSystem.PrecacheSound( "debris/bustconcrete1.wav" );
				g_SoundSystem.PrecacheSound( "debris/bustconcrete2.wav" );
				break;
			case matRocks:
				pGibName = "models/rockgibs.mdl";

				g_SoundSystem.PrecacheSound( "debris/bustconcrete1.wav" );
				g_SoundSystem.PrecacheSound( "debris/bustconcrete2.wav" );
				break;
			case matCeilingTile:
				pGibName = "models/ceilinggibs.mdl";

				g_SoundSystem.PrecacheSound( "debris/bustceiling.wav" );  
				break;
			case matNone:
			case matLastMaterial:
				break;
			default:
				break;
			}
			MaterialSoundPrecache( Materials( m_Material ) );
			if( m_iszGibModel.IsEmpty() == false )
				pGibName = m_iszGibModel;

			m_idShard = g_Game.PrecacheModel( pGibName );
		}
		
		// play shard sound when func_breakable takes damage.
		// the more damage, the louder the shard sound.
		void DamageSound()
		{
			int pitch;
			float fvol;
			string[] rgpsz;
			int i = 0;
			int material = m_Material;

			//if( Math.RandomLong( 0, 1 ) )
			//	return;

			if( Math.RandomLong( 0, 2 ) > 0 )
				pitch = PITCH_NORM;
			else
				pitch = 95 + Math.RandomLong( 0, 34 );

			fvol = Math.RandomFloat( 0.75, 1.0 );

			if( material == matComputer && Math.RandomLong( 0, 1 ) > 0 )
				material = matMetal;

			rgpsz = MaterialSoundList( Materials( material ), i );

			if( i > 0 )
				g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, rgpsz[ Math.RandomLong( 0, i - 1 ) ], fvol, ATTN_NORM, 0, pitch );
		}
		
		void Die()
		{
			Vector vecSpot;// shard origin
			Vector vecVelocity;// shard velocity
			CBaseEntity@ pEntity = null;
			uint8 cFlag = 0;
			int pitch;
			float fvol;

			pitch = 95 + Math.RandomLong( 0, 29 );

			if( pitch > 97 && pitch < 103 )
				pitch = 100;

			// The more negative pev->health, the louder
			// the sound should be.

			fvol = Math.RandomFloat( 0.85, 1.0 ) + ( fabs( self.pev.health ) / 100.0 );

			if( fvol > 1.0 )
				fvol = 1.0;

			switch( m_Material )
			{
			case matGlass:
				switch( Math.RandomLong( 0, 1 ) )
				{
				case 0:
					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "debris/bustglass1.wav", fvol, ATTN_NORM, 0, pitch );
					break;
				case 1:
					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "debris/bustglass2.wav", fvol, ATTN_NORM, 0, pitch );
					break;
				}
				cFlag = BREAK_GLASS;
				break;
			case matWood:
				switch( Math.RandomLong( 0, 1 ) )
				{
				case 0:
					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "debris/bustcrate1.wav", fvol, ATTN_NORM, 0, pitch );
					break;
				case 1:
					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "debris/bustcrate2.wav", fvol, ATTN_NORM, 0, pitch );
					break;
				}
				cFlag = BREAK_WOOD;
				break;
			case matComputer:
			case matMetal:
				switch( Math.RandomLong( 0, 1 ) )
				{
				case 0:
					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "debris/bustmetal1.wav", fvol, ATTN_NORM, 0, pitch );
					break;
				case 1:
					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "debris/bustmetal2.wav", fvol, ATTN_NORM, 0, pitch );
					break;
				}
				cFlag = BREAK_METAL;
				break;
			case matFlesh:
				switch( Math.RandomLong( 0, 1 ) )
				{
				case 0:
					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "debris/bustflesh1.wav", fvol, ATTN_NORM, 0, pitch );
					break;
				case 1:
					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "debris/bustflesh2.wav", fvol, ATTN_NORM, 0, pitch );
					break;
				}
				cFlag = BREAK_FLESH;
				break;
			case matRocks:
			case matCinderBlock:
				switch( Math.RandomLong( 0, 1 ) )
				{
				case 0:
					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "debris/bustconcrete1.wav", fvol, ATTN_NORM, 0, pitch );
					break;
				case 1:
					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "debris/bustconcrete2.wav", fvol, ATTN_NORM, 0, pitch );
					break;
				}
				cFlag = BREAK_CONCRETE;
				break;
			case matCeilingTile:
				g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "debris/bustceiling.wav", fvol, ATTN_NORM, 0, pitch );
				break;
			case matNone:
			case matLastMaterial:
			case matUnbreakableGlass:
				break;
			default:
				break;
			}

			//if( m_Explosion == expDirected )
			//	vecVelocity = m_vecAttackDir * 200;
			//else
			{
				vecVelocity.x = 0;
				vecVelocity.y = 0;
				vecVelocity.z = 0;
			}

			vecSpot = self.pev.origin + ( self.pev.mins + self.pev.maxs ) * 0.5;
			CreateTempEnt_BreakModel( vecSpot, self.pev.size, vecVelocity, 10, m_idShard, 0, 25, cFlag );

			// !!! HACK  This should work!
			// Build a box above the entity that looks like an 8 pixel high sheet
			Vector mins = self.pev.absmin;
			Vector maxs = self.pev.absmax;
			mins.z = self.pev.absmax.z;
			maxs.z += 8;

			// BUGBUG -- can only find 256 entities on a breakable -- should be enough
			CBaseEntity@[] pList(256);
			int count = g_EntityFuncs.EntitiesInBox( pList, mins, maxs, FL_ONGROUND );
			if( count > 0 )
			{
				for( int i = 0; i < count; i++ )
				{
					if( pList[i].pev.FlagBitSet( FL_ONGROUND ) )
						pList[i].pev.flags &= ~FL_ONGROUND;
					
					@pList[i].pev.groundentity = null;
				}
			}

			// Don't fire something that could fire myself
			self.pev.targetname = 0;

			self.pev.solid = SOLID_NOT;

			// Fire targets on break
			self.SUB_UseTargets( null, USE_TOGGLE, 0 );

			if( self.pev.weapons > 0 )
			{
				g_EntityFuncs.CreateExplosion( self.Center(), self.pev.angles, self.edict(), self.pev.weapons, true );
			}
		}

		/*
		* The resources that this harvester has
		*/
		HarvesterResources@ Resources
		{
			get const { return @m_pResources; }
		}
	
		/*
		* How many resource items can a harvester carry at any time?
		*/
		uint MaxCarry 
		{ 
			get const { return m_uiMaxCarry; }
		}
		
		bool KeyValue( const string& in szKey, const string& in szValue )
		{
			if (szKey == "length")
			{
				m_length = atof(szValue);
				return true;
			}
			else if (szKey == "width")
			{
				m_width = atof(szValue);
				return true;
			}
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
			// New additions
			else if (szKey == "maxcarry")
			{
				if( atoui(szValue) > Math.UINT32_MAX )
					m_uiMaxCarry = Math.UINT32_MAX;
				else
					m_uiMaxCarry = atoui(szValue);
				
				return true;
			}
			else if (szKey == "class")
			{
				m_iClassification = atoi(szValue);
				return true;
			}
			else if (szKey == "material")
			{
				int i = atoi( szValue );

				// 0:glass, 1:metal, 2:flesh, 3:wood
				if( ( i < 0 ) || ( i >= matLastMaterial ) )
					m_Material = matWood;
				else
					m_Material = Materials(i);
				
				return true;
			}
			else if(szKey == "gibmodel")
			{
				m_iszGibModel = szValue;
				return true;
			}
			else
				return BaseClass.KeyValue( szKey, szValue );
		}
		
		void NextThink(float thinkTime, const bool alwaysThink)
		{
			if (alwaysThink)
				self.pev.flags |= FL_ALWAYSTHINK;
			else
				self.pev.flags &= ~FL_ALWAYSTHINK;

			self.pev.nextthink = thinkTime;
		}
		
		void Blocked(CBaseEntity@ pOther)
		{
			entvars_t@ pevOther   = pOther.pev;
			
			if (pevOther.FlagBitSet(FL_ONGROUND) && pevOther.groundentity !is null && pevOther.groundentity.vars is self.pev)
			{
				pevOther.velocity = self.pev.velocity;
				return;
			}
			else
			{
				pevOther.velocity = (pevOther.origin - self.pev.origin).Normalize() * self.pev.dmg;
				pevOther.velocity.z += 300;
				self.pev.velocity = self.pev.velocity * 0.85;
			}

			g_Game.AlertMessage(at_aiconsole, "TRAIN(%1): Blocked by %2 (dmg:%3)\n", self.pev.targetname, pOther.pev.classname, self.pev.dmg);
			Math.MakeVectors(self.pev.angles);

			Vector vFrontLeft = (g_Engine.v_forward * -1) * (m_length * 0.5);
			Vector vFrontRight = (g_Engine.v_right * -1) * (m_width * 0.5);
			Vector vBackLeft = self.pev.origin + vFrontLeft - vFrontRight;
			Vector vBackRight = self.pev.origin - vFrontLeft + vFrontRight;
			float minx = Math.min(vBackLeft.x, vBackRight.x);
			float maxx = Math.max(vBackLeft.x, vBackRight.x);
			float miny = Math.min(vBackLeft.y, vBackRight.y);
			float maxy = Math.max(vBackLeft.y, vBackRight.y);
			float minz = self.pev.origin.z;
			float maxz = self.pev.origin.z + (2 * abs(int(self.pev.mins.z - self.pev.maxs.z)));

			// anggaranothing
			if (pOther.pev.origin.x < minx || pOther.pev.origin.x > maxx || pOther.pev.origin.y < miny || pOther.pev.origin.y > maxy || pOther.pev.origin.z < minz || pOther.pev.origin.z > maxz)
			{
				pOther.TakeDamage(self.pev, self.pev, self.pev.dmg, DMG_CRUSH);
				self.pev.speed = 0;
				self.pev.velocity = g_vecZero;
				self.pev.avelocity = g_vecZero;
			}
		}
		
		// anggaranothing
		int TakeDamage( entvars_t@ pevInflictor, entvars_t@ pevAttacker, float flDamage, int bitsDamageType )
		{
			CBaseEntity@ pAttacker = g_EntityFuncs.Instance( pevAttacker );
			
			if( pAttacker is null || self.IRelationship( pAttacker ) <= R_NO )
				return 0;
			
			Vector vecTemp;
			vecTemp = pevInflictor.origin - ( self.pev.absmin + ( self.pev.size * 0.5 ) );
			// this variable is still used for glass and other non-monster killables, along with decals.
			m_vecAttackDir = vecTemp.Normalize();
			
			// Boxes / glass / etc. don't take much poison damage, just the impact of the dart - consider that 1%
			if( ( bitsDamageType & DMG_POISON ) != 0 )
				flDamage *= 0.01;
			
			int result = BaseClass.TakeDamage( pevInflictor, pevAttacker, flDamage, bitsDamageType );
			
			// Make a shard noise each time func breakable is hit.
			// Don't play shard noise if cbreakable actually died.
			if( result > 0 && flDamage > 1.0 )
				DamageSound();
			
			return result;
		}
		
		// anggaranothing
		void Killed( entvars_t@ pevAtttacker, int iGibbed )
		{
			if( m_pTrigger !is null )
			{
				m_pTrigger.KillTrigger();
			}
			
			// Stop it!
			self.pev.speed = 0;
			self.pev.velocity = g_vecZero;
			self.pev.avelocity = g_vecZero;
			self.pev.impulse = int(m_speed);
			m_flTurnStartTime = -1;
			m_flUpdateSound = -1;
			m_dir = 1;
			@m_pDriver = null;
			
			Die();
			BaseClass.Killed( pevAtttacker, iGibbed );
		}

		void Spawn()
		{
			Precache();
			
			if (self.pev.speed == 0)
				m_speed = 165;
			else
				m_speed = self.pev.speed;

			if (m_sounds == 0)
				m_sounds = 3;

			if( m_uiMaxCarry <= 0 )
				m_uiMaxCarry = 4;
			
			@m_pResources = @HarvesterResources( cast<CBaseEntity@>( @self ) );
			m_pResources.MaxCarry = m_uiMaxCarry;
			SetResourcesOnBaseEntity( cast<CBaseEntity@>( @self ), @m_pResources );
			
			g_Game.AlertMessage(at_console, "M_speed = %1\n", m_speed);

			self.pev.speed = 0;
			self.pev.velocity = g_vecZero;
			self.pev.avelocity = g_vecZero;
			self.pev.impulse = int(m_speed);
			m_acceleration = 5;
			m_dir = 1;
			m_flTurnStartTime = -1;

			if( string( self.pev.target ).IsEmpty() )
				g_Game.AlertMessage(at_console, "Vehicle with no target\n");

			/*
			if (self.pev.spawnflags & SF_TRACKTRAIN_PASSABLE)
				self.pev.solid = SOLID_NOT;
			else
			*/
				self.pev.solid = SOLID_BSP;

			self.pev.movetype = MOVETYPE_PUSH;

			g_EntityFuncs.SetModel(self, self.pev.model);
			g_EntityFuncs.SetSize(self.pev, self.pev.mins, self.pev.maxs);
			g_EntityFuncs.SetOrigin(self, self.pev.origin);

			self.pev.oldorigin = self.pev.origin;
			
			if( !self.pev.SpawnFlagBitSet( SF_HARVESTER_NODEFAULTCONTROLS ) )
			{
				m_controlMins = self.pev.mins;
				m_controlMaxs = self.pev.maxs;
				m_controlMaxs.z += 72;
			}

			NextThink(self.pev.ltime + 0.1, false);
			SetThink(ThinkFunction(this.Find));
			
			// anggaranothing
			self.pev.takedamage = DAMAGE_YES;
			
			if( self.pev.max_health <= 0 )
				self.pev.max_health	= 2000;
			
			if( self.pev.health <= 0 )
				self.pev.health = self.pev.max_health;
			
			self.SetClassification( m_iClassification );
			
			//self.pev.flags |= FL_MONSTER;
			
			//self.pev.groupinfo = int( 0xFFFFFFFF & ~1073741824 );
			
			@m_pTrigger = @HarvesterTrigger( @self, 10.0f, true );
			
			//g_EntityFuncs.SetModel( m_pTrigger.Child, self.pev.model );
		}

		void Restart()
		{
			g_Game.AlertMessage(at_console, "M_speed = %1\n", m_speed);

			self.pev.speed = 0;
			self.pev.velocity = g_vecZero;
			self.pev.avelocity = g_vecZero;
			self.pev.impulse = int(m_speed);
			m_flTurnStartTime = -1;
			m_flUpdateSound = -1;
			m_dir = 1;
			@m_pDriver = null;

			if( string( self.pev.target ).IsEmpty() )
				g_Game.AlertMessage(at_console, "Vehicle with no target\n");

			g_EntityFuncs.SetOrigin(self, self.pev.oldorigin);
			NextThink(self.pev.ltime + 0.1, false);
			SetThink(ThinkFunction(this.Find));
		}
		
		void Precache()
		{
			PrecacheMaterials();
			
			if (m_flVolume == 0)
				m_flVolume = 1;

			switch (m_sounds)
			{
				case 1: g_SoundSystem.PrecacheSound("plats/vehicle1.wav"); self.pev.noise = "plats/vehicle1.wav"; break;
				case 2: g_SoundSystem.PrecacheSound("plats/vehicle2.wav"); self.pev.noise = "plats/vehicle2.wav"; break;
				case 3: g_SoundSystem.PrecacheSound("plats/vehicle3.wav"); self.pev.noise = "plats/vehicle3.wav"; break;
				case 4: g_SoundSystem.PrecacheSound("plats/vehicle4.wav"); self.pev.noise = "plats/vehicle4.wav"; break;
				case 5: g_SoundSystem.PrecacheSound("plats/vehicle6.wav"); self.pev.noise = "plats/vehicle6.wav"; break;
				case 6: g_SoundSystem.PrecacheSound("plats/vehicle7.wav"); self.pev.noise = "plats/vehicle7.wav"; break;
			}

			g_SoundSystem.PrecacheSound("plats/vehicle_brake1.wav");
			g_SoundSystem.PrecacheSound("plats/vehicle_start1.wav");
			g_SoundSystem.PrecacheSound( "plats/vehicle_ignition.wav" );
		}

		void Use(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float value)
		{
			if( pActivator !is null && pActivator.IsPlayer() )
			{
				@m_pResources.Player = @PlayerFromPlayerEntity( cast<CBasePlayer@>( @pActivator ) );
			}
			
			float delta = value;

			if (useType != USE_SET)
			{
				if( !self.ShouldToggle( useType, self.pev.speed != 0 ))
					return;

				if (self.pev.speed == 0)
				{
					self.pev.speed = m_speed * m_dir;
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

				float flSpeedRatio = delta;

				if (delta > 0)
				{
					flSpeedRatio = self.pev.speed / m_speed;

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
					flSpeedRatio = self.pev.speed / m_speed;

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

				self.pev.speed = m_speed * flSpeedRatio;
				Next();
				m_flAcceleratorDecay = g_Engine.time + 0.25;
			}
			else
			{
				if (g_Engine.time > m_flCanTurnNow)
				{
					if (delta == 20)
					{
						m_iTurnAngle++;
						m_flSteeringWheelDecay = g_Engine.time + 0.075;

						if (m_iTurnAngle > 8)
							m_iTurnAngle = 8;
					}
					else if (delta == 30)
					{
						m_iTurnAngle--;
						m_flSteeringWheelDecay = g_Engine.time + 0.075;

						if (m_iTurnAngle < -8)
							m_iTurnAngle = -8;
					}

					m_flCanTurnNow = g_Engine.time + 0.05;
				}
			}
		}
		
		int ObjectCaps() { return (BaseClass.ObjectCaps() & ~FCAP_ACROSS_TRANSITION) | FCAP_DIRECTIONAL_USE; }
		
		void OverrideReset()
		{
			NextThink(self.pev.ltime + 0.1, false);
			SetThink(ThinkFunction(this.NearestPath));
		}
		
		void CheckTurning()
		{
			TraceResult tr;
			Vector vecStart, vecEnd;

			if (m_iTurnAngle < 0)
			{
				if (self.pev.speed > 0)
				{
					vecStart = m_vFrontLeft;
					vecEnd = vecStart - g_Engine.v_right * 16;
				}
				else if (self.pev.speed < 0)
				{
					vecStart = m_vBackLeft;
					vecEnd = vecStart + g_Engine.v_right * 16;
				}

				g_Utility.TraceLine(vecStart, vecEnd, ignore_monsters, dont_ignore_glass, self.edict(), tr);

				if (tr.flFraction != 1)
					m_iTurnAngle = 1;
			}
			else if (m_iTurnAngle > 0)
			{
				if (self.pev.speed > 0)
				{
					vecStart = m_vFrontRight;
					vecEnd = vecStart + g_Engine.v_right * 16;
				}
				else if (self.pev.speed < 0)
				{
					vecStart = m_vBackRight;
					vecEnd = vecStart - g_Engine.v_right * 16;
				}

				g_Utility.TraceLine(vecStart, vecEnd, ignore_monsters, dont_ignore_glass, self.edict(), tr);

				if (tr.flFraction != 1)
					m_iTurnAngle = -1;
			}

			if (self.pev.speed <= 0)
				return;

			float speed;
			int turning = int(abs(m_iTurnAngle));

			if (turning > 4)
			{
				if (m_flTurnStartTime != -1)
				{
					float time = g_Engine.time - m_flTurnStartTime;

					if (time >= 0)
						speed = m_speed * 0.98;
					else if (time > 0.3)
						speed = m_speed * 0.95;
					else if (time > 0.6)
						speed = m_speed * 0.9;
					else if (time > 0.8)
						speed = m_speed * 0.8;
					else if (time > 1)
						speed = m_speed * 0.7;
					else if (time > 1.2)
						speed = m_speed * 0.5;
					else
						speed = time;
				}
				else
				{
					m_flTurnStartTime = g_Engine.time;
					speed = m_speed;
				}
			}
			else
			{
				m_flTurnStartTime = -1;

				if (turning > 2)
					speed = m_speed * 0.9;
				else
					speed = m_speed;
			}

			if (speed < self.pev.speed)
				self.pev.speed -= m_speed * 0.1;
		}
		
		void CollisionDetection()
		{
			TraceResult tr;
			Vector vecStart, vecEnd;
			float flDot;

			if (self.pev.speed < 0)
			{
				vecStart = m_vBackLeft;
				vecEnd = vecStart + (g_Engine.v_forward * 16);
				g_Utility.TraceLine(vecStart, vecEnd, ignore_monsters, dont_ignore_glass, self.edict(), tr);

				if (tr.flFraction != 1)
				{
					flDot = DotProduct(g_Engine.v_forward, tr.vecPlaneNormal * -1);

					if (flDot < 0.7 && tr.vecPlaneNormal.z < 0.1)
					{
						m_vSurfaceNormal = tr.vecPlaneNormal;
						m_vSurfaceNormal.z = 0;
						self.pev.speed *= 0.99;
					}
					else if (tr.vecPlaneNormal.z < 0.65 || tr.fStartSolid != 0)
						self.pev.speed *= -1;
					else
						m_vSurfaceNormal = tr.vecPlaneNormal;

					
					/*CBaseEntity@ pHit = g_EntityFuncs.Instance(tr.pHit);

					entvars_t@ pevHit   = pHit.pev;
					string classnameHit = pevHit.classname.opImplConv();

					if (pHit !is null && classnameHit.StartsWith("cnc_") )
						g_Game.AlertMessage(at_console, "I hit %s\n", classnameHit);*/
						
				}

				vecStart = m_vBackRight;
				vecEnd = vecStart + (g_Engine.v_forward * 16);
				g_Utility.TraceLine(vecStart, vecEnd, ignore_monsters, dont_ignore_glass, self.edict(), tr);

				if (tr.flFraction == 1)
				{
					vecStart = m_vBack;
					vecEnd = vecStart + (g_Engine.v_forward * 16);
					g_Utility.TraceLine(vecStart, vecEnd, ignore_monsters, dont_ignore_glass, self.edict(), tr);

					if (tr.flFraction == 1)
						return;
				}

				flDot = DotProduct(g_Engine.v_forward, tr.vecPlaneNormal * -1);

				if (flDot >= 0.7)
				{
					if (tr.vecPlaneNormal.z < 0.65 || tr.fStartSolid != 0)
						self.pev.speed *= -1;
					else
						m_vSurfaceNormal = tr.vecPlaneNormal;
				}
				else if (tr.vecPlaneNormal.z < 0.1)
				{
					m_vSurfaceNormal = tr.vecPlaneNormal;
					m_vSurfaceNormal.z = 0;
					self.pev.speed *= 0.99;
				}
				else if (tr.vecPlaneNormal.z < 0.65 || tr.fStartSolid != 0)
					self.pev.speed *= -1;
				else
					m_vSurfaceNormal = tr.vecPlaneNormal;
			}
			else if (self.pev.speed > 0)
			{
				vecStart = m_vFrontRight;
				vecEnd = vecStart - (g_Engine.v_forward * 16);
				g_Utility.TraceLine(vecStart, vecEnd, dont_ignore_monsters, dont_ignore_glass, self.edict(), tr);

				if (tr.flFraction == 1)
				{
					vecStart = m_vFrontLeft;
					vecEnd = vecStart - (g_Engine.v_forward * 16);
					g_Utility.TraceLine(vecStart, vecEnd, ignore_monsters, dont_ignore_glass, self.edict(), tr);

					if (tr.flFraction == 1)
					{
						vecStart = m_vFront;
						vecEnd = vecStart - (g_Engine.v_forward * 16);
						g_Utility.TraceLine(vecStart, vecEnd, ignore_monsters, dont_ignore_glass, self.edict(), tr);

						if (tr.flFraction == 1)
							return;
					}
				}

				flDot = DotProduct(g_Engine.v_forward, tr.vecPlaneNormal * -1);

				if (flDot <= -0.7)
				{
					if (tr.vecPlaneNormal.z < 0.65 || tr.fStartSolid != 0)
						self.pev.speed *= -1;
					else
						m_vSurfaceNormal = tr.vecPlaneNormal;
				}
				else if (tr.vecPlaneNormal.z < 0.1)
				{
					m_vSurfaceNormal = tr.vecPlaneNormal;
					m_vSurfaceNormal.z = 0;
					self.pev.speed *= 0.99;
				}
				else if (tr.vecPlaneNormal.z < 0.65 || tr.fStartSolid != 0)
					self.pev.speed *= -1;
				else
					m_vSurfaceNormal = tr.vecPlaneNormal;
			}
		}

		void TerrainFollowing()
		{
			TraceResult tr;
			g_Utility.TraceLine(self.pev.origin, self.pev.origin + Vector(0, 0, (m_height + 48) * -1), ignore_monsters, dont_ignore_glass, self.edict(), tr);

			if (tr.flFraction != 1)
				m_vSurfaceNormal = tr.vecPlaneNormal;
			else if( tr.fInWater != 0 )
				m_vSurfaceNormal = Vector(0, 0, 1);
		}

		void Next()
		{
			Vector vGravityVector = g_vecZero;
			Math.MakeVectors(self.pev.angles);

			Vector forward = (g_Engine.v_forward * -1) * (m_length * 0.5);
			Vector right = (g_Engine.v_right * -1) * (m_width * 0.5);
			Vector up = g_Engine.v_up * 16;

			m_vFrontRight = self.pev.origin + forward - right + up;
			m_vFrontLeft = self.pev.origin + forward + right + up;
			m_vFront = self.pev.origin + forward + up;
			m_vBackLeft = self.pev.origin - forward - right + up;
			m_vBackRight = self.pev.origin - forward + right + up;
			m_vBack = self.pev.origin - forward + up;
			m_vSurfaceNormal = g_vecZero;

			CheckTurning();

			if (g_Engine.time > m_flSteeringWheelDecay)
			{
				m_flSteeringWheelDecay = g_Engine.time + 0.1;

				if (m_iTurnAngle < 0)
					m_iTurnAngle++;
				else if (m_iTurnAngle > 0)
					m_iTurnAngle--;
			}

			if (g_Engine.time > m_flAcceleratorDecay and m_flLaunchTime == -1)
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
			}
			
			//Moved here to make sure sounds are always handled correctly
			if (g_Engine.time > m_flUpdateSound)
			{
				UpdateSound();
				m_flUpdateSound = g_Engine.time + 1;
			}

			if (self.pev.speed == 0)
			{
				m_iTurnAngle = 0;
				self.pev.avelocity = g_vecZero;
				self.pev.velocity = g_vecZero;
				SetThink(ThinkFunction(this.Next));
				NextThink(self.pev.ltime + 0.1, true);
				return;
			}

			TerrainFollowing();
			CollisionDetection();

			if (m_vSurfaceNormal == g_vecZero)
			{
				if (m_flLaunchTime != -1)
				{
					vGravityVector = Vector(0, 0, 0);
					vGravityVector.z = (g_Engine.time - m_flLaunchTime) * -35;

					if (vGravityVector.z < -400)
						vGravityVector.z = -400;
				}
				else
				{
					m_flLaunchTime = g_Engine.time;
					vGravityVector = Vector(0, 0, 0);
					self.pev.velocity = self.pev.velocity * 1.5;
				}

				m_vVehicleDirection = g_Engine.v_forward * -1;
			}
			else
			{
				m_vVehicleDirection = CrossProduct(m_vSurfaceNormal, g_Engine.v_forward);
				m_vVehicleDirection = CrossProduct(m_vSurfaceNormal, m_vVehicleDirection);

				Vector angles = Math.VecToAngles(m_vVehicleDirection);
				angles.y += 180;

				if (m_iTurnAngle != 0)
					angles.y += m_iTurnAngle;

				angles = FixupAngles(angles);
				self.pev.angles = FixupAngles(self.pev.angles);

				float vx = Math.AngleDistance(angles.x, self.pev.angles.x);
				float vy = Math.AngleDistance(angles.y, self.pev.angles.y);

				if (vx > 10)
					vx = 10;
				else if (vx < -10)
					vx = -10;

				if (vy > 10)
					vy = 10;
				else if (vy < -10)
					vy = -10;

				self.pev.avelocity.y = int(vy * 10);
				self.pev.avelocity.x = int(vx * 10);
				m_flLaunchTime = -1;
				m_flLastNormalZ = m_vSurfaceNormal.z;
			}

			Math.VecToAngles(m_vVehicleDirection);

			/*
			if (g_Engine.time > m_flUpdateSound)
			{
				UpdateSound();
				m_flUpdateSound = g_Engine.time + 1;
			}
			*/

			if (m_vSurfaceNormal == g_vecZero)
				self.pev.velocity = self.pev.velocity + vGravityVector;
			else
				self.pev.velocity = m_vVehicleDirection.Normalize() * self.pev.speed;

			SetThink(ThinkFunction(this.Next));
			NextThink(self.pev.ltime + 0.1, true);
		}

		void Find()
		{
			@m_ppath = cast<CPathTrack@>( g_EntityFuncs.FindEntityByTargetname( null, self.pev.target ) );

			if (m_ppath is null)
				return;

			entvars_t@ pevTarget = m_ppath.pev;

			if (!pevTarget.ClassNameIs( "path_track" ))
			{
				g_Game.AlertMessage(at_error, "func_vehicle_harvester must be on a path of path_track\n");
				@m_ppath = null;
				return;
			}

			Vector nextPos = pevTarget.origin;
			nextPos.z += m_height;

			Vector look = nextPos;
			look.z -= m_height;
			m_ppath.LookAhead(look, look, m_length, true);
			look.z += m_height;

			self.pev.angles = Math.VecToAngles(look - nextPos);
			self.pev.angles.y += 180;

			/*
			if (self.pev.spawnflags & SF_TRACKTRAIN_NOPITCH)
				self.pev.angles.x = 0;
				*/

			g_EntityFuncs.SetOrigin(self, nextPos);
			NextThink(self.pev.ltime + 0.1, false);
			SetThink(ThinkFunction(this.Next));
			self.pev.speed = m_startSpeed;
			UpdateSound();
		}

		void NearestPath()
		{
			CBaseEntity@ pTrack = null;
			CBaseEntity@ pNearest = null;
			float dist = 0.0f;
			float closest = 1024;

			while ((@pTrack = @g_EntityFuncs.FindEntityInSphere(pTrack, self.pev.origin, 1024)) !is null)
			{
				if ((pTrack.pev.flags & (FL_CLIENT | FL_MONSTER)) == 0 && pTrack.pev.ClassNameIs( "path_track" ))
				{
					dist = (self.pev.origin - pTrack.pev.origin).Length();

					if (dist < closest)
					{
						closest = dist;
						@pNearest = @pTrack;
					}
				}
			}

			if (pNearest is null)
			{
				g_Game.AlertMessage(at_console, "Can't find a nearby track !!!\n");
				SetThink(null);
				return;
			}

			g_Game.AlertMessage(at_aiconsole, "TRAIN: %1, Nearest track is %2\n", self.pev.targetname, pNearest.pev.targetname);
			@pTrack = cast<CPathTrack@>(pNearest).GetNext();

			if (pTrack !is null)
			{
				if ((self.pev.origin - pTrack.pev.origin).Length() < (self.pev.origin - pNearest.pev.origin).Length())
					@pNearest = pTrack;
			}

			@m_ppath = cast<CPathTrack@>(pNearest);

			if (self.pev.speed != 0)
			{
				NextThink(self.pev.ltime + 0.1, false);
				SetThink(ThinkFunction(this.Next));
			}
		}

		void SetTrack(CPathTrack@ track) { @m_ppath = @track.Nearest(self.pev.origin); }
		
		void SetControls(entvars_t@ pevControls)
		{
			Vector offset = pevControls.origin - self.pev.oldorigin;
			m_controlMins = pevControls.mins + offset;
			m_controlMaxs = pevControls.maxs + offset;
		}

		bool OnControls(entvars_t@ pevTest)
		{
			Vector offset = pevTest.origin - self.pev.origin;

			/*
			if (self.pev.spawnflags & SF_TRACKTRAIN_NOCONTROL)
				return false;
			*/

			Math.MakeVectors(self.pev.angles);
			
			Vector local;
			local.x = DotProduct(offset, g_Engine.v_forward);
			local.y = -DotProduct(offset, g_Engine.v_right);
			local.z = DotProduct(offset, g_Engine.v_up);

			if (local.x >= m_controlMins.x && local.y >= m_controlMins.y && local.z >= m_controlMins.z && local.x <= m_controlMaxs.x && local.y <= m_controlMaxs.y && local.z <= m_controlMaxs.z)
				return true;

			return false;
		}
		
		void StopSound()
		{
			if (m_soundPlaying != 0 && !string( self.pev.noise ).IsEmpty())
			{
				g_SoundSystem.StopSound(self.edict(), CHAN_STATIC, self.pev.noise);
				if (m_sounds < 5)
					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_ITEM, "plats/vehicle_brake1.wav", m_flVolume, ATTN_NORM, 0, 100 );
			}

			m_soundPlaying = 0;
		}

		void UpdateSound()
		{
			if (string( self.pev.noise ).IsEmpty())
				return;

			float flpitch = VEHICLE_STARTPITCH + (abs(int(self.pev.speed)) * (VEHICLE_MAXPITCH - VEHICLE_STARTPITCH) / VEHICLE_MAXSPEED);

			if (flpitch > 200)
				flpitch = 200;

			if (m_soundPlaying == 0)
			{
				if (m_sounds < 5)
					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_ITEM, "plats/vehicle_brake1.wav", m_flVolume, ATTN_NORM, 0, 100 );

				g_SoundSystem.EmitSoundDyn(self.edict(), CHAN_STATIC, self.pev.noise, m_flVolume, ATTN_NORM, 0, int(flpitch));
				m_soundPlaying = 1;
			}
			else
			{
				g_SoundSystem.EmitSoundDyn(self.edict(), CHAN_STATIC, self.pev.noise, m_flVolume, ATTN_NORM, SND_CHANGE_PITCH, int(flpitch));
			}
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
				g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_ITEM, "plats/vehicle_ignition.wav", 0.8, ATTN_NORM, 0, PITCH_NORM );
			}
		}
		
		private float Fix(float angle)
		{
			while (angle < 0)
				angle += 360;
			while (angle > 360)
				angle -= 360;

			return angle;
		}

		private Vector FixupAngles(Vector v)
		{
			v.x = Fix(v.x);
			v.y = Fix(v.y);
			v.z = Fix(v.z);
			
			return v;
		}

		CPathTrack@ m_ppath;
		float m_length;
		float m_width;
		float m_height;
		float m_speed;
		float m_dir;
		float m_startSpeed;
		Vector m_controlMins;
		Vector m_controlMaxs;
		int m_soundPlaying;
		int m_sounds;
		int m_acceleration;
		float m_flVolume;
		float m_flBank;
		float m_oldSpeed;
		int m_iTurnAngle;
		float m_flSteeringWheelDecay;
		float m_flAcceleratorDecay;
		float m_flTurnStartTime;
		float m_flLaunchTime;
		float m_flLastNormalZ;
		float m_flCanTurnNow;
		float m_flUpdateSound;
		Vector m_vFrontLeft;
		Vector m_vFront;
		Vector m_vFrontRight;
		Vector m_vBackLeft;
		Vector m_vBack;
		Vector m_vBackRight;
		Vector m_vSurfaceNormal;
		Vector m_vVehicleDirection;
		CBasePlayer@ m_pDriver;
		
		private int    m_Material        = matMetal;
		private string m_iszGibModel;
		private int    m_idShard;
		private int    m_iClassification = CLASS_PLAYER;
		private uint   m_uiMaxCarry;
		private Vector m_vecAttackDir;
		private HarvesterResources@ m_pResources;
		private HarvesterTrigger@   m_pTrigger;
	}

	const string HARVESTER_RC_EHANDLE_KEY = "HARVESTER_RC_EHANDLE_KEY"; //Key into player user data used to keep track of vehicle RC state

	void TurnHarvesterRCControlOff( CBasePlayer@ pPlayer )
	{
		EHandle train = EHandle( pPlayer.GetUserData()[ HARVESTER_RC_EHANDLE_KEY ] );
					
		if( train.IsValid() )
		{
			func_vehicle_harvester@ ptrain = func_vehicle_harvester_Instance( train.GetEntity() );
			
			if( ptrain !is null )
				ptrain.SetDriver( null );
		}
				
		pPlayer.GetUserData()[ HARVESTER_RC_EHANDLE_KEY ] = EHandle();
								
		pPlayer.m_afPhysicsFlags &= ~PFLAG_ONTRAIN;
		pPlayer.m_iTrain = TRAIN_NEW|TRAIN_OFF;
	}

	func_vehicle_harvester@ func_vehicle_harvester_Instance( CBaseEntity@ pEntity )
	{
		if(	pEntity.pev.ClassNameIs( "func_vehicle_harvester" ) )
			return cast<func_vehicle_harvester@>( CastToScriptClass( pEntity ) );

		return null;
	}

	/*
	*	Call this to init func_vehicle_harvester
	*	If you want debugging code accessible through chat, set fAddDebugCode to true
	*/
	void VehicleHarvesterMapInit( bool fRegisterHooks = true, bool fAddDebugCode = false )
	{
		if( fRegisterHooks )
		{
			if( fAddDebugCode )
			{
				g_Hooks.RegisterHook( Hooks::Player::ClientSay, @VehicleHarvesterClientSay );
			}
			
			g_Hooks.RegisterHook( Hooks::Player::PlayerUse, @VehicleHarvesterPlayerUse );
			g_Hooks.RegisterHook( Hooks::Player::PlayerPreThink, @VehicleHarvesterPlayerPreThink );
			g_Hooks.RegisterHook( Hooks::Player::ClientPutInServer, @VehicleHarvesterClientPutInServer );
		}
		
		g_CustomEntityFuncs.RegisterCustomEntity( "CNC::func_vehicle_harvester",   "func_vehicle_harvester" );
		g_CustomEntityFuncs.RegisterCustomEntity( "CNC::trigger_harvester",      "trigger_harvester" );
	}

	HookReturnCode VehicleHarvesterClientPutInServer( CBasePlayer@ pPlayer )
	{
		dictionary@ userData = pPlayer.GetUserData();
		
		userData.set( HARVESTER_RC_EHANDLE_KEY, EHandle() );
		
		return HOOK_CONTINUE;
	}

	HookReturnCode VehicleHarvesterPlayerUse( CBasePlayer@ pPlayer, uint& out uiFlags )
	{
		if ( ( pPlayer.m_afButtonPressed & IN_USE ) != 0 )
		{
			if( EHandle( pPlayer.GetUserData()[ HARVESTER_RC_EHANDLE_KEY ] ).IsValid() )
			{
				uiFlags |= PlrHook_SkipUse;
				
				TurnHarvesterRCControlOff( pPlayer );
				
				return HOOK_CONTINUE;
			}
			
			if ( !pPlayer.m_hTank.IsValid() )
			{
				if ( ( pPlayer.m_afPhysicsFlags & PFLAG_ONTRAIN ) != 0 )
				{
					pPlayer.m_afPhysicsFlags &= ~PFLAG_ONTRAIN;
					pPlayer.m_iTrain = TRAIN_NEW|TRAIN_OFF;

					CBaseEntity@ pTrain = g_EntityFuncs.Instance( pPlayer.pev.groundentity );

					//Stop driving this vehicle if +use again
					if( pTrain !is null )
					{
						func_vehicle_harvester@ pVehicle = cast<func_vehicle_harvester@>( CastToScriptClass( pTrain ) );
						
						if( pVehicle !is null )
							pVehicle.SetDriver( null );
					}

					uiFlags |= PlrHook_SkipUse;
					
					return HOOK_CONTINUE;
				}
				else
				{	// Start controlling the train!
					CBaseEntity@ pTrain = g_EntityFuncs.Instance( pPlayer.pev.groundentity );
					
					if ( pTrain !is null && (pPlayer.pev.button & IN_JUMP) == 0 && pPlayer.pev.FlagBitSet( FL_ONGROUND ) && (pTrain.ObjectCaps() & FCAP_DIRECTIONAL_USE) != 0 && pTrain.OnControls(pPlayer.pev) )
					{
						pPlayer.m_afPhysicsFlags |= PFLAG_ONTRAIN;
						pPlayer.m_iTrain = TrainSpeed(int(pTrain.pev.speed), pTrain.pev.impulse);
						pPlayer.m_iTrain |= TRAIN_NEW;

						//Start driving this vehicle
						func_vehicle_harvester@ pVehicle = cast<func_vehicle_harvester@>( CastToScriptClass( pTrain ) );
							
						if( pVehicle !is null )
							pVehicle.SetDriver( pPlayer );
							
						uiFlags |= PlrHook_SkipUse;
						return HOOK_CONTINUE;
					}
				}
			}
		}
		
		return HOOK_CONTINUE;
	}

	//If player in air, disable control of train
	bool HandleDriverInAir( CBasePlayer@ pPlayer, CBaseEntity@ pTrain )
	{
		if ( !pPlayer.pev.FlagBitSet( FL_ONGROUND ) )
		{
			// Turn off the train if you jump, strafe, or the train controls go dead
			pPlayer.m_afPhysicsFlags &= ~PFLAG_ONTRAIN;
			pPlayer.m_iTrain = TRAIN_NEW|TRAIN_OFF;

			//Set driver to null if we stop driving the vehicle
			if( pTrain !is null )
			{
				func_vehicle_harvester@ pVehicle = cast<func_vehicle_harvester@>( CastToScriptClass( pTrain ) );
				
				if( pVehicle !is null )
					pVehicle.SetDriver( null );
			}
			
			if( EHandle( pPlayer.GetUserData()[ HARVESTER_RC_EHANDLE_KEY ] ).IsValid() )
			{
				TurnHarvesterRCControlOff( pPlayer );
			}
			
			return true;
		}
		
		return false;
	}

	HookReturnCode VehicleHarvesterPlayerPreThink( CBasePlayer@ pPlayer, uint& out uiFlags )
	{
		CBaseEntity@ pTrain = null;
		
		bool fUsingRC = EHandle( pPlayer.GetUserData()[ HARVESTER_RC_EHANDLE_KEY ] ).IsValid();
		
		if ( ( pPlayer.m_afPhysicsFlags & PFLAG_ONTRAIN ) != 0 || fUsingRC )
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

					//Set driver to null if we stop driving the vehicle
					if( pTrain !is null )
					{
						func_vehicle_harvester@ pVehicle = cast<func_vehicle_harvester@>( CastToScriptClass( pTrain ) );
						
						if( pVehicle !is null )
							pVehicle.SetDriver( null );
					}
					
					uiFlags |= PlrHook_SkipVehicles;
					return HOOK_CONTINUE;
				}
			}
			else if ( HandleDriverInAir( pPlayer, pTrain ) )
			{
				uiFlags |= PlrHook_SkipVehicles;
				return HOOK_CONTINUE;
			}

			float vel = 0;

			//Check if it's a func_vehicle - Solokiller 2014-10-24
			if( fUsingRC )
			{
				@pTrain = EHandle(pPlayer.GetUserData()[ HARVESTER_RC_EHANDLE_KEY ]).GetEntity();
				
				//fContinue = false;
			}
			
			if( pTrain is null )
				return HOOK_CONTINUE;
				
			func_vehicle_harvester@ pVehicle = cast<func_vehicle_harvester@>( CastToScriptClass( pTrain ) );
			
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

	HookReturnCode VehicleHarvesterClientSay( SayParameters@ pParams )
	{
		const CCommand@ pArguments = pParams.GetArguments();
		
		bool fHandled = false;
		
		if( pArguments.ArgC() >= 3 )
		{
			CBaseEntity@ pTrain = g_EntityFuncs.FindEntityByTargetname( null, pArguments[ 1 ] );
				
			if( pTrain !is null )
			{
				func_vehicle_harvester@ pVehicle = cast<func_vehicle_harvester@>( CastToScriptClass( pTrain ) );
				
				if( pVehicle !is null )
				{
					float flNewValue = atof( pArguments[ 2 ] );

					if( pArguments[ 0 ] == "vehicle_speed" )
					{
						pVehicle.m_speed = flNewValue;
						g_Game.AlertMessage( at_console, "changing speed to %1\n", flNewValue );
						
						fHandled = true;
					}
					else if( pArguments[ 0 ] == "vehicle_accel" )
					{
						pVehicle.m_acceleration = int(flNewValue);
						g_Game.AlertMessage( at_console, "changing acceleration to %1\n", flNewValue );
						
						fHandled = true;
					}
				}
			}
		}
		else if( pArguments.ArgC() >= 2 )
		{
			CBaseEntity@ pTrain = g_EntityFuncs.FindEntityByTargetname( null, pArguments[ 1 ] );
				
			if( pTrain !is null )
			{
				func_vehicle_harvester@ pVehicle = cast<func_vehicle_harvester@>( CastToScriptClass( pTrain ) );
				
				if( pVehicle !is null )
				{
					if( pArguments[ 0 ] == "vehicle_restart" )
					{
						pVehicle.Restart();
						g_Game.AlertMessage( at_console, "restarting vehicle\n" );
						
						fHandled = true;
					}
				}
			}
		}
		
		if( !fHandled )
			g_Game.AlertMessage( at_console, "not changing anything\n" );

		return HOOK_CONTINUE;
	}
	
	class HarvesterTrigger
	{
		private EHandle m_hParent;
		private EHandle m_hChild;
		private float   m_flExtraSize;

		CBaseEntity@ Parent
		{
			get const { return m_hParent.GetEntity(); }
			set       { m_hParent = EHandle(@value); }
		}
		
		CBaseEntity@ Child
		{
			get const { return m_hChild.GetEntity(); }
		}
		
		float ExtraSize
		{
			get const { return m_flExtraSize; }
			set       { m_flExtraSize = value; }
		}
		
		HarvesterTrigger( CBaseEntity@ parent, float extraSize = 5.0f, bool createAndAttach = false )
		{
			@this.Parent   = @parent;
			this.ExtraSize = extraSize;
			
			if( createAndAttach )
			{
				AttachToParent( m_hChild = CreateTrigger() );
			}
		}
		
		CBaseEntity@ CreateTrigger()
		{
			CBaseEntity@ pEntity = null;
			if( m_hParent )
			{
				@pEntity = g_EntityFuncs.Create( "trigger_harvester", m_hParent.GetEntity().pev.origin, m_hParent.GetEntity().pev.angles, true );
				
				g_EntityFuncs.DispatchSpawn( pEntity.edict() );
				
				Vector mins = m_hParent.GetEntity().pev.mins;
				Vector maxs = m_hParent.GetEntity().pev.maxs;				
				
				maxs.x  =  Math.max( maxs.x, maxs.y ) + m_flExtraSize;
				maxs.y  =  Math.max( maxs.x, maxs.y ) + m_flExtraSize;
				maxs.z  =  Math.clamp( mins.z , maxs.z , maxs.z * 0.25 );
				
				mins.x  = maxs.x * -1.0;
				mins.y  = maxs.y * -1.0;
				//mins.z  =  Math.clamp( mins.z , maxs.z , mins.z * 0.25 );
				
				g_EntityFuncs.SetSize( pEntity.pev, mins, maxs );
			}
			return @pEntity;
		}
		
		void KillTrigger()
		{
			if( m_hChild )
			{
				g_EntityFuncs.Remove( m_hChild.GetEntity() );
			}
		}
		
		void AttachToParent( CBaseEntity@ child , int iAttachment = 0 )
		{
			if( m_hParent && child !is null )
			{
				g_Game.AlertMessage(at_console, "%1: Attached to %2\n", child.pev.classname, m_hParent.GetEntity().pev.classname );
				
				child.pev.skin     = g_EntityFuncs.EntIndex( m_hParent.GetEntity().edict() );
				child.pev.body     = iAttachment;
				@child.pev.aiment   = @m_hParent.GetEntity().edict();
				@child.pev.owner    = @m_hParent.GetEntity().edict();
				child.pev.movetype = MOVETYPE_FOLLOW;
				
				SetResourcesOnBaseEntity( @child, ResourcesFromBaseEntity( @m_hParent.GetEntity() ) );
			}
		}
	}
	
	class trigger_harvester : ScriptBaseMonsterEntity
	{
		void Spawn()
		{
			//g_Game.AlertMessage(at_console, "trigger_harvester: Spawned\n" );
			self.Precache();
			BaseClass.Spawn();
			
			self.pev.solid    = SOLID_TRIGGER;

			g_EntityFuncs.SetSize(self.pev, self.pev.mins, self.pev.maxs);
			g_EntityFuncs.SetOrigin(self, self.pev.origin);
			
			self.pev.takedamage = DAMAGE_NO;
			
			self.pev.flags   &= ~FL_MONSTER;
			//self.pev.effects |= EF_NODRAW;
			
			self.SetClassification( CLASS_FORCE_NONE );
			
			//self.pev.groupinfo = 8;
			
			NextThink( g_Engine.time + 0.1, false );
			SetThink( ThinkFunction( this.TriggerThink ) );
		}
		
		void NextThink( float thinkTime, const bool alwaysThink )
		{
			if (alwaysThink)
				self.pev.flags |= FL_ALWAYSTHINK;
			else
				self.pev.flags &= ~FL_ALWAYSTHINK;

			self.pev.nextthink = thinkTime;
		}
		
		void TriggerThink()
		{
			SetObjectBox( self.pev , false );
			
			NextThink( g_Engine.time + 3, false );
		}
		
		void Touch(CBaseEntity@ pOther)
		{
			CBaseEntity@ pParent = g_EntityFuncs.Instance( self.pev.owner );
			
			if( pParent !is null )
			{
				pOther.Touch( @pParent );
				return;
			}
			
			BaseClass.Touch( @pOther );
		}
	}
}
