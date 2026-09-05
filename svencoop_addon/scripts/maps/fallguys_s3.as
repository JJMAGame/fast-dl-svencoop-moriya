
const int PhysicShapeDirection_X = 0;
const int PhysicShapeDirection_Y = 1;
const int PhysicShapeDirection_Z = 2;

const int PhysicShape_Box = 1;
const int PhysicShape_Sphere = 2;
const int PhysicShape_Capsule = 3;
const int PhysicShape_Cylinder = 4;
const int PhysicShape_MultiSphere = 5;

const int PhysicObject_HasClippingHull = 1;
const int PhysicObject_HasImpactImpulse = 2;
const int PhysicObject_Freeze = 4;

const int PhysicWheel_Front = 1;
const int PhysicWheel_Engine = 2;
const int PhysicWheel_Brake = 4;
const int PhysicWheel_Steering = 8;
const int PhysicWheel_NoSteering = 0x10;

const int FollowEnt_CopyOriginX = 1;
const int FollowEnt_CopyOriginY = 2;
const int FollowEnt_CopyOriginZ = 4;
const int FollowEnt_CopyAnglesP = 8;
const int FollowEnt_CopyAnglesY = 0x10;
const int FollowEnt_CopyAnglesR = 0x20;
const int FollowEnt_CopyOrigin = (FollowEnt_CopyOriginX | FollowEnt_CopyOriginY | FollowEnt_CopyOriginZ);
const int FollowEnt_CopyAngles = (FollowEnt_CopyAnglesP | FollowEnt_CopyAnglesY | FollowEnt_CopyAnglesR);
const int FollowEnt_CopyNoDraw = 0x40;
const int FollowEnt_CopyRenderMode = 0x80;
const int FollowEnt_CopyRenderAmt = 0x100;
const int FollowEnt_ApplyLinearVelocity = 0x200;
const int FollowEnt_ApplyAngularVelocity = 0x400;

const int EnvStudioAnim_AnimatedStudio = 1;
const int EnvStudioAnim_AnimatedSprite = 2;
const int EnvStudioAnim_StaticFrame = 4;
const int EnvStudioAnim_RemoveOnAnimFinished = 8;
const int EnvStudioAnim_RemoveOnBoundExcceeded = 0x10;
const int EnvStudioAnim_AnimatedRenderAmt = 0x20;
const int EnvStudioAnim_AnimatedScale = 0x40;

const int LOD_BODY = 1;
const int LOD_MODELINDEX = 2;
const int LOD_SCALE = 4;
const int LOD_SCALE_INTERP = 8;

const float c_PlayerImpactPlayer_MinimumCosAngle = 0.3;
const float c_PlayerImpactPlayer_MinimumImpactVelocity = 100;
const float c_PlayerImpactPlayer_VelocityTransferEfficiency = 0.75;

const float c_PlayerGrab_Range = 48.0;
const float c_PlayerGrab_HandRange = 16.0;
const float c_PlayerGrab_Velocity = 2500.0;

const float c_PlayerDefaultMaxSpeed = 270.0;
const float c_PlayerMass = 20.0;

const int HitEffect_Large = 0;
const int HitEffect_Medium = 1;
const int HitEffect_Small = 2;
const int HitEffect_GrabBreak = 3;
//Only for internal usage
const int HitEffect_BurstCircleSprite = 4;
const int HitEffect_BurstLineSprite = 5;
const int HitEffect_BurstLineModel = 0;

const int FL_CONVEYOR	 = (1<<2);
const int FL_ONGROUND = (1<<9);
const int FL_BASEVELOCITY = (1<<22);
const int EF_FRAMEANIMTEXTURES =  512;
const int EF_NODECALS =  2048;

const int TS_AT_TOP = 0;
const int TS_AT_BOTTOM = 1;
const int TS_GOING_UP = 2;
const int TS_GOING_DOWN = 3;

const int SF_BRUSH_ROTATE_INSTANT = 1;
const int SF_BRUSH_ROTATE_BACKWARDS = 2;
const int SF_BRUSH_ROTATE_Z_AXIS = 4;
const int SF_BRUSH_ROTATE_X_AXIS = 8;
const int SF_BRUSH_ACCDCC = 16;

const int SF_CONVEYOR_VISUAL = 0x0001;
const int SF_CONVEYOR_NOTSOLID = 0x0002;

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

const int SF_TRAIN_WAIT_RETRIGGER	 = 1;
const int SF_TRAIN_START_ON		 = 4;		// Train is initially moving
const int SF_TRAIN_PASSABLE		= 8;

const int SF_CORNER_WAITFORTRIG  = 1;
const int SF_CORNER_TELEPORT = 2;
const int SF_CORNER_FIREONCE = 4;

const int SF_DOOR_ROTATE_Y = 0;
const int SF_DOOR_START_OPEN = 1;
const int SF_DOOR_ROTATE_BACKWARDS = 2;
const int SF_DOOR_PASSABLE = 8;
const int SF_DOOR_ONEWAY = 16;
const int SF_DOOR_NO_AUTO_RETURN = 32;
const int SF_DOOR_ROTATE_Z = 64;
const int SF_DOOR_ROTATE_X = 128;
const int SF_DOOR_USE_ONLY = 256;
const int SF_DOOR_NOMONSTERS = 512;

//const int SF_ENV_PHYSMODEL_BOX = 1;
//const int SF_ENV_PHYSMODEL_SPHERE = 2;
//const int SF_ENV_PHYSMODEL_CYLINDER = 4;
//const int SF_ENV_PHYSMODEL_MULTISPHERE = 8;
//const int SF_ENV_PHYSMODEL_CAPSULE = 16;
const int SF_ENV_PHYSMODEL_CLIPPINGHULL = 128;
const int SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER = 256;
const int SF_ENV_PHYSMODEL_FREEZE = 512;

const int SF_ENV_STUDIOMODEL_COPY_ORIGIN = 1;
const int SF_ENV_STUDIOMODEL_COPY_ANGLES = 2;
const int SF_ENV_STUDIOMODEL_SET_SKIN = 4;
const int SF_ENV_STUDIOMODEL_SET_BODY = 8;
const int SF_ENV_STUDIOMODEL_COPY_ORIGIN_Z = 32;
const int SF_ENV_STUDIOMODEL_COPY_NODRAW = 64;
const int SF_ENV_STUDIOMODEL_ANIMATED_STUDIO = 128;
const int SF_ENV_STUDIOMODEL_PLAY_SEQUENCE_ON_TOGGLE = 256;
const int SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH = 512;
const int SF_ENV_STUDIOMODEL_ANIMATED_SPRITE = 1024;
const int SF_ENV_STUDIOMODEL_REMOVE_ON_BOUND_EXCCEEDED = 2048;
const int SF_ENV_STUDIOMODEL_STATIC_FRAME = 0x1000;
const int SF_ENV_STUDIOMODEL_ANIMATED_RENDERAMT = 0x2000;
const int SF_ENV_STUDIOMODEL_ANIMATED_SCALE = 0x4000;

const int SF_TRIGGER_PHYSIC_ON = 1;
const int SF_TRIGGER_PHYSIC_TELEPORT_ON_TOUCH = 2;
const int SF_TRIGGER_PHYSIC_DELETE_ON_TOUCH = 4;

const int SF_TRIGGER_FREEZE_ON = 1;
const int SF_TRIGGER_FREEZE_SET_CHECKPOINT = 2;

const int SF_TRIGGER_REVIVE_ZONE_ON = 1;

const int SF_TRIGGER_PHYSIC_CANNON_START_ON = 0x1000;

const int SF_TEAMPLAY_HAS_BLUE = 1;
const int SF_TEAMPLAY_HAS_RED = 2;
const int SF_TEAMPLAY_HAS_YELLOW = 4;
const int SF_TEAMPLAY_HAS_GREEN = 8;

const int FCAP_CUSTOMSAVE = 0x00000001;
const int FCAP_ACROSS_TRANSITION = 0x00000002;
const int FCAP_MUST_SPAWN = 0x00000004;
const int FCAP_IMPULSE_USE = 0x00000008;
const int FCAP_CONTINUOUS_USE = 0x00000010;
const int FCAP_ONOFF_USE = 0x00000020;
const int FCAP_DIRECTIONAL_USE = 0x00000040;
const int FCAP_MASTER = 0x00000080;
const int FCAP_FORCE_TRANSITION = 0x00000080;

const int TASKSTATUS_NEW				= 0;			// Just started
const int TASKSTATUS_RUNNING			= 1;			// Running task & movement
const int TASKSTATUS_RUNNING_MOVEMENT	= 2;			// Just running movement
const int TASKSTATUS_RUNNING_TASK		= 3;			// Just running task
const int TASKSTATUS_COMPLETE			= 4;			// Completed, get next task

const int FL_WORLDBRUSH	 = (1<<25);
const int FL_KILLME = (1<<30);

/*class EnvStudioKeyframe
{
	EnvStudioKeyframe()
	{
		frame = 0;
		renderamt = 255;
		scale = 1;
	}

	float frame;
	float renderamt;
	float scale;
};*/

class CPlayerBlockStateItem
{
	CPlayerBlockStateItem(){
		IsBlocking = false;
		flLastBlockTime = 0;
		flLastSoundTime = 0;
		flStartBlockTime = 0;
	}
	bool IsBlocking;
	float flLastBlockTime;
	float flLastSoundTime;
	float flStartBlockTime;
	string szPlayingSound;
}

class CPlayerFreezeStateItem
{
	CPlayerFreezeStateItem(){
		bIsFreezing = false;
		bIsNoDraw = false;
		flUnfreezeTime = 0;
		iLastFreezerEntity = 0;
	}
	bool bIsFreezing;
	bool bIsNoDraw;
	float flUnfreezeTime;
	int iLastFreezerEntity;
}

array<CPlayerBlockStateItem> g_ArrayBlockPlayer(33);
array<CPlayerFreezeStateItem> g_ArrayFreezePlayer(33);

array<int> g_ArrayGrabPlayer(33);
array<Vector> g_ArrayGrabPlayerHandPosition(33);
array<Vector> g_ArrayGrabPlayerVelocity(33);

array<Vector> g_ArrayVelocityPlayer(33);
array<Vector> g_ArrayBounceVelocityPlayer(33);
array<float> g_ArrayBouncePlayer(33);
array<float> g_ArraySlidePlayer(33);
array<float> g_ArrayJumpPlayer(33);
array<int> g_ArrayPlayerJumpState(33);
array<int> g_ArrayPlayerJumpPreGroundEntity(33);

array<bool> g_ArrayFallingPlayer(33);
array<string> g_ArrayFallingPlayerPlayingSound(33);

array<int> g_ArrayTopColorPlayer(33);
array<int> g_ArrayBotColorPlayer(33);
array<EHandle> g_ArrayArrowEntityPlayer(33);
array<EHandle> g_ArrayHatEntityPlayer(33);

array<string> g_ArrayCheckPointPlayer(33);

array<bool> g_ArraySpectatorPlayer(33);

array<string> g_szPlayerQualifiedSound = {
	"fallguys/playervictory01.ogg",
	"fallguys/playervictory02.ogg",
	"fallguys/playervictory03.ogg",
	"fallguys/playervictory04.ogg",
	"fallguys/playervictory05.ogg",
	"fallguys/playervictory06.ogg",
	"fallguys/playervictory07.ogg",
	"fallguys/playervictory08.ogg"
};

array<string> g_szPlayerJumpSound = {
	"fallguys/playerjump1.ogg",
	"fallguys/playerjump2.ogg",
	"fallguys/playerjump3.ogg",
	"fallguys/playerjump4.ogg",
	"fallguys/playerjump5.ogg",
	"fallguys/playerjump6.ogg",
	"fallguys/playerjump7.ogg",
	"fallguys/playerjump8.ogg"
};

array<string> g_szPlayerHitSound = {
	"fallguys/playerhit1.ogg",
	"fallguys/playerhit2.ogg",
	"fallguys/playerhit3.ogg",
	"fallguys/playerhit4.ogg",
	"fallguys/playerhit5.ogg",
	"fallguys/playerhit6.ogg",
	"fallguys/playerhit7.ogg"
};

array<string> g_szFootStepPlasticSound = {
	"fallguys/footstepplastic01.ogg",
	"fallguys/footstepplastic02.ogg",
	"fallguys/footstepplastic03.ogg",
	"fallguys/footstepplastic04.ogg",
	"fallguys/footstepplastic05.ogg",
	"fallguys/footstepplastic06.ogg",
	"fallguys/footstepplastic07.ogg"
};

array<string> g_szFootStepSlipperySound = {
	"fallguys/footstepslippery01.ogg",
	"fallguys/footstepslippery02.ogg",
	"fallguys/footstepslippery03.ogg",
	"fallguys/footstepslippery04.ogg",
	"fallguys/footstepslippery05.ogg",
	"fallguys/footstepslippery06.ogg",
	"fallguys/footstepslippery07.ogg"
};

array<string> g_szJumpPlasticSound = {
	"fallguys/jumpplastic01.ogg",
	"fallguys/jumpplastic02.ogg",
	"fallguys/jumpplastic03.ogg",
	"fallguys/jumpplastic04.ogg",
	"fallguys/jumpplastic05.ogg",
	"fallguys/jumpplastic06.ogg",
	"fallguys/jumpplastic07.ogg"
};

array<string> g_szJumpSlipperySound = {
	"fallguys/jumpslippery01.ogg",
	"fallguys/jumpslippery02.ogg",
	"fallguys/jumpslippery03.ogg",
	"fallguys/jumpslippery04.ogg",
	"fallguys/jumpslippery05.ogg",
	"fallguys/jumpslippery06.ogg",
	"fallguys/jumpslippery07.ogg"
};

array<string> g_szImpactPlasticSound = {
	"fallguys/impactplastic01.ogg",
	"fallguys/impactplastic02.ogg",
	"fallguys/impactplastic03.ogg"
};

array<string> g_szPlayerFallingSound = {
	"fallguys/playerfall1.ogg",
	"fallguys/playerfall2.ogg"
};

const string g_szPlayerGrabSound = "fallguys/grab.ogg";
const string g_szPlayerGrabReleaseSound = "fallguys/grabrelease.ogg";

array<string> g_szPlayerHitEffectSprite = {
	"sprites/fallguys/hitlarge.spr",
	"sprites/fallguys/hitmedium.spr",
	"sprites/fallguys/hitsmall.spr",
	"sprites/fallguys/grabbreak.spr",
	"sprites/fallguys/burstcircle.spr",
	"sprites/fallguys/burststar.spr"
};

array<int> g_iPlayerHitEffectSprite = {
	0,
	0,
	0,
	0,
	0,
	0
};

array<string> g_szPlayerJumpEffectSprite = {
	"sprites/fallguys/puff.spr"
};

array<int> g_iPlayerJumpEffectSprite = {
	0
};

array<string> g_szPlayerHitEffectModel = {
	"models/fallguys/burstline2.mdl"
};

array<int> g_iPlayerHitEffectModel = {
	0
};

const string g_szPlayerArrowSprite = "sprites/fallguys/playerarrow.spr";
const string g_szPlayerArrowSprite2 = "sprites/fallguys/playerarrow2.spr";

const string g_szBlueMarkSprite = "sprites/fallguys/bluemark.spr";
const string g_szBlueMarkSprite2 = "sprites/fallguys/bluemark2.spr";

const string g_szYellowMarkSprite = "sprites/fallguys/yellowmark.spr";
const string g_szYellowMarkSprite2 = "sprites/fallguys/yellowmark2.spr";

int g_iPlayerArrowSpriteModelIndex = 0;
int g_iPlayerArrowSprite2ModelIndex = 0;

int g_iBlueMarkSpriteModelIndex = 0;
int g_iBlueMarkSprite2ModelIndex = 0;

int g_iYellowMarkSpriteModelIndex = 0;
int g_iYellowMarkSprite2ModelIndex = 0;

const int SF_SKINBUTTON_USABLE = 1;
const int SF_SKINBUTTON_HIDE_WHEN_OFF = 2;
const int SF_SKINBUTTON_KEEP_ACTIVATOR = 4;

class CEnvSkinButton : ScriptBaseEntity
{
	Vector m_vecMinHullSize = g_vecZero;
	Vector m_vecMaxHullSize = g_vecZero;
	int m_iMinSkin = 0;
	int m_iMaxSkin = 0;
	int m_iTriggerState = 0;
	float m_flClickDelay = 0.1;
	float m_flLastClick = 0;

	string m_szPressSound = "";

	void Precache()
	{
		BaseClass.Precache();

		g_Game.PrecacheModel( self.pev.model );

		if(!m_szPressSound.IsEmpty())
			g_SoundSystem.PrecacheSound( m_szPressSound );
	}

	int ObjectCaps() { 
		return FCAP_IMPULSE_USE;
	}

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_BBOX;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, m_vecMinHullSize, m_vecMaxHullSize );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "minhullsize"){
			g_Utility.StringToVector( m_vecMinHullSize, szValue );
			return true;
		}

		if(szKey == "maxhullsize"){
			g_Utility.StringToVector( m_vecMaxHullSize, szValue );
			return true;
		}

		if(szKey == "minskin"){
			m_iMinSkin = atoi(szValue);
			return true;
		}

		if(szKey == "maxskin"){
			m_iMaxSkin = atoi(szValue);
			return true;
		}

		if(szKey == "triggerstate"){
			m_iTriggerState = atoi(szValue);
			return true;
		}

		if(szKey == "clickdelay"){
			m_flClickDelay = atof(szValue);
			return true;
		}

		if(szKey == "presssound"){
			m_szPressSound = szValue;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_ON)
		{
			self.pev.spawnflags |= 1;
			if((self.pev.spawnflags & SF_SKINBUTTON_HIDE_WHEN_OFF) == SF_SKINBUTTON_HIDE_WHEN_OFF)
			{
				self.pev.effects &= ~EF_NODRAW;
			}
		}
		else if(useType == USE_OFF)
		{
			self.pev.spawnflags &= ~1;
			if((self.pev.spawnflags & SF_SKINBUTTON_HIDE_WHEN_OFF) == SF_SKINBUTTON_HIDE_WHEN_OFF)
			{
				self.pev.effects |= EF_NODRAW;
			}
		}
		else if(useType == USE_SET && flValue == 1)
		{
			if((self.pev.spawnflags & SF_SKINBUTTON_USABLE) == SF_SKINBUTTON_USABLE)
			{
				if(g_Engine.time > m_flLastClick + m_flClickDelay)
				{
					m_flLastClick = g_Engine.time;

					self.pev.skin = self.pev.skin + 1;
					if(self.pev.skin > m_iMaxSkin)
						self.pev.skin = m_iMinSkin;

					if(!m_szPressSound.IsEmpty() && pActivator !is null && pActivator.IsPlayer()){
						
						g_SoundSystem.EmitSoundDyn( pActivator.edict(), CHAN_ITEM, m_szPressSound, 1, ATTN_NORM, 0, PITCH_NORM );

					}

					if(!string(self.pev.target).IsEmpty())
					{
						g_EntityFuncs.FireTargets( string(self.pev.target), ((self.pev.spawnflags & SF_SKINBUTTON_KEEP_ACTIVATOR) == SF_SKINBUTTON_KEEP_ACTIVATOR) ? pActivator : self, self, USE_TYPE(m_iTriggerState), self.pev.skin );
					}
				}
			}
		}
	}
}

class CEnvHexagonTile : ScriptBaseEntity
{
	Vector m_vecHalfExtent = Vector(1.0, 1.0, 1.0);
	array<int> m_TileStates(5);
	array<float> m_TileChangeState(5);

	void Precache()
	{
		BaseClass.Precache();

		g_Game.PrecacheModel( self.pev.model );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "halfextent"){
			g_Utility.StringToVector( m_vecHalfExtent, szValue );
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Restart()
	{
		self.pev.solid = SOLID_BBOX;
		self.pev.movetype = MOVETYPE_NOCLIP;

		g_EntityFuncs.SetModel( self, self.pev.model );

		Vector mins = m_vecHalfExtent * -1;
		Vector maxs = m_vecHalfExtent;
		g_EntityFuncs.SetSize( self.pev, mins, maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		self.pev.sequence = 0;
		self.pev.skin = 0;
		self.pev.effects &= ~EF_NODRAW;

		m_TileStates[0] = 0;
		m_TileStates[1] = 0;
		m_TileStates[2] = 0;
		m_TileStates[3] = 0;
		m_TileStates[4] = 0;
		m_TileChangeState[0] = 0; 
		m_TileChangeState[1] = 0; 
		m_TileChangeState[2] = 0; 
		m_TileChangeState[3] = 0; 
		m_TileChangeState[4] = 0; 
	}

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_BBOX;
		self.pev.movetype = MOVETYPE_NOCLIP;

		g_EntityFuncs.SetModel( self, self.pev.model );

		Vector mins = m_vecHalfExtent * -1;
		Vector maxs = m_vecHalfExtent;
		g_EntityFuncs.SetSize( self.pev, mins, maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		m_TileStates[0] = 0;
		m_TileStates[1] = 0;
		m_TileStates[2] = 0;
		m_TileStates[3] = 0;
		m_TileStates[4] = 0;
		m_TileChangeState[0] = 0; 
		m_TileChangeState[1] = 0; 
		m_TileChangeState[2] = 0; 
		m_TileChangeState[3] = 0; 
		m_TileChangeState[4] = 0;

		if((self.pev.spawnflags & 1) == 1)
		{
			Vector halfextent = Vector(128.0, 128.0, 512.0);
			Vector halfextent2 = Vector(256.0, 256.0, 512.0);

			g_EntityFuncs.CreateSolidOptimizer(self.edict(), 0, halfextent, halfextent2);
			g_EntityFuncs.CreateSolidOptimizer(self.edict(), 1, halfextent, halfextent2);
			g_EntityFuncs.CreateSolidOptimizer(self.edict(), 2, halfextent, halfextent2);
			g_EntityFuncs.CreateSolidOptimizer(self.edict(), 3, halfextent, halfextent2);
			g_EntityFuncs.CreateSolidOptimizer(self.edict(), 4, halfextent, halfextent2);
		}
	}

	void Touch( CBaseEntity@ pOther )
	{
		if(pOther.IsPlayer() && pOther.IsAlive())
		{
			if((pOther.pev.flags & FL_ONGROUND) == FL_ONGROUND && (pOther.pev.groundentity is self.edict() ))
			{
				CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pOther);

				if(pPlayer.GetMaxSpeedOverride() == 0)
					return;

				int tileIndex = g_Engine.trace_hitgroup;
				if(m_TileStates[tileIndex] == 0)
				{
					self.pev.skin |= (1 << tileIndex);

					m_TileStates[tileIndex] = 1;
					m_TileChangeState[tileIndex] = g_Engine.time + 0.75;
					
					self.pev.nextthink = g_Engine.time + 0.1;
					SetThink(ThinkFunction(this.Animate));
				}
			}
		}
	}

	void Animate()
	{
		bool bStateChanging = false;

		for(int tileIndex = 0; tileIndex < 5; ++tileIndex)
		{
			if(m_TileStates[tileIndex] == 1)
			{
				if(g_Engine.time > m_TileChangeState[tileIndex])
				{
					self.pev.sequence |= (1 << tileIndex);
					m_TileStates[tileIndex] = 2;

					if(self.pev.sequence == 31){
						self.pev.effects |= EF_NODRAW;
						self.pev.solid = SOLID_NOT;
					}
				}
				else
				{
					bStateChanging = true;
				}
			}
		}

		if(bStateChanging)
		{
			self.pev.nextthink = g_Engine.time + 0.1;
			SetThink(ThinkFunction(this.Animate));
		}
		else
		{
			SetThink(null);
		}
	}
}

class CEnvPhysicModel : ScriptBaseEntity
{
	Vector m_vecHalfExtent = Vector(1.0, 1.0, 1.0);
	string m_szPointRadius = "";
	int m_iShapeType = PhysicShape_Box;
	int m_iShapeDirection = PhysicShapeDirection_Z;
	int m_iClippingHullShapeType = PhysicShape_Box;
	int m_iClippingHullShapeDirection = PhysicShapeDirection_Z;
	float m_flMass = 10.0;
	float m_flLinearFriction = 1.0;
	float m_flRollingFriction = 1.0;
	float m_flRestitution = 0.0;
	float m_flCCDRadius = 0.0;
	float m_flCCDThreshold = 0.0;
	float m_flImpactImpulseThreshold = 1000000;
	float m_flImpactImpulseVolumeFactor = 5000000;
	float m_flImpactImpulseThresholdLargeHit = 100000;
	float m_flImpactImpulseThresholdMediumHit = 10000;
	float m_flImpactSoundAttenuation = 0.33;

	array<string> m_szImpactSound;
	array<string> m_szSmokeSprite;

	float m_flSpawnTime = 0;
	float m_flLifeTime = 0;
	float m_flLastImpactSound = 0;

	Vector m_vecLivingMins = Vector(-999999, -999999, -999999);
	Vector m_vecLivingMaxs = Vector(999999, 999999, 999999);

	void Precache()
	{
		BaseClass.Precache();

		for(int i = 0;i < int(m_szImpactSound.length()); ++i)
		{
			g_SoundSystem.PrecacheSound( m_szImpactSound[i] );
		}

		for(int i = 0;i < int(m_szSmokeSprite.length()); ++i)
		{
			g_Game.PrecacheModel( m_szSmokeSprite[i] );
		}

		g_Game.PrecacheModel( self.pev.model );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "lod1"){
			self.pev.fuser1 = atof(szValue);
			return true;
		}
		if(szKey == "lod1body"){
			self.pev.iuser1 = atoi(szValue);
			return true;
		}
		if(szKey == "lod2"){
			self.pev.fuser2 = atof(szValue);
			return true;
		}
		if(szKey == "lod2body"){
			self.pev.iuser2 = atoi(szValue);
			return true;
		}
		if(szKey == "lod3"){
			self.pev.fuser3 = atof(szValue);
			return true;
		}
		if(szKey == "lod3body"){
			self.pev.iuser3 = atoi(szValue);
			return true;
		}

		if(szKey == "mass"){
			m_flMass = atof(szValue);
			return true;
		}
		if(szKey == "linearfriction"){
			m_flLinearFriction = atof(szValue);
			return true;
		}
		if(szKey == "rollingfriction"){
			m_flRollingFriction = atof(szValue);
			return true;
		}
		if(szKey == "restitution"){
			m_flRestitution = atof(szValue);
			return true;
		}
		if(szKey == "ccdradius"){
			m_flCCDRadius = atof(szValue);
			return true;
		}
		if(szKey == "ccdthreshold"){
			m_flCCDThreshold = atof(szValue);
			return true;
		}
		if(szKey == "impactimpulsethreshold"){
			m_flImpactImpulseThreshold = atof(szValue);
			return true;
		}
		if(szKey == "impactimpulsevolumefactor"){
			m_flImpactImpulseVolumeFactor = atof(szValue);
			return true;
		}
		if(szKey == "impactsoundattenuation"){
			m_flImpactSoundAttenuation = atof(szValue);
			return true;
		}
		if(szKey == "impactimpulsethresholdlargehit"){
			m_flImpactImpulseThresholdLargeHit = atof(szValue);
			return true;
		}
		if(szKey == "impactimpulsethresholdmediumhit"){
			m_flImpactImpulseThresholdMediumHit = atof(szValue);
			return true;
		}

		if(szKey == "halfextent"){
			g_Utility.StringToVector( m_vecHalfExtent, szValue );
			return true;
		}
		
		if(szKey == "shapetype")
		{
			m_iShapeType = atoi(szValue);
			return true;
		}
		if(szKey == "shapedirection")
		{
			m_iShapeDirection = atoi(szValue);
			return true;
		}

		if(szKey == "clippinghull_shapetype")
		{
			m_iClippingHullShapeType = atoi(szValue);
			return true;
		}
		if(szKey == "clippinghull_shapedirection")
		{
			m_iClippingHullShapeDirection = atoi(szValue);
			return true;
		}
		if(szKey == "pointradius")
		{
			m_szPointRadius = szValue;
			return true;
		}

		if(szKey == "livingmins"){
			g_Utility.StringToVector( m_vecLivingMins, szValue );
			return true;
		}

		if(szKey == "livingmaxs"){
			g_Utility.StringToVector( m_vecLivingMaxs, szValue );
			return true;
		}

		if(szKey.StartsWith("impactsound_")){
			m_szImpactSound.insertLast(szValue);
			return true;
		}

		if(szKey.StartsWith("smokesprite_")){
			m_szSmokeSprite.insertLast(szValue);
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_BBOX;
		self.pev.movetype = MOVETYPE_NOCLIP;

		g_EntityFuncs.SetModel( self, self.pev.model );

		Vector mins = m_vecHalfExtent * -1;
		Vector maxs = m_vecHalfExtent;
		g_EntityFuncs.SetSize( self.pev, mins, maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		if(m_iShapeType == PhysicShape_Box)
		{
			PhysicShapeParams shapeParams;
			shapeParams.type = PhysicShape_Box;
			shapeParams.size = m_vecHalfExtent;

			PhysicObjectParams objectParams;
			objectParams.mass = m_flMass;
			objectParams.linearfriction = m_flLinearFriction;
			objectParams.rollingfriction = m_flRollingFriction;
			objectParams.restitution = m_flRestitution;
			objectParams.ccdradius = m_flCCDRadius;
			objectParams.ccdthreshold = m_flCCDThreshold;

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_CLIPPINGHULL) == SF_ENV_PHYSMODEL_CLIPPINGHULL)
			{
				objectParams.flags |= PhysicObject_HasClippingHull;
				objectParams.clippinghull_shapetype = m_iClippingHullShapeType;
				objectParams.clippinghull_shapedirection = m_iClippingHullShapeDirection;
				objectParams.clippinghull_size = m_vecHalfExtent;
			}

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER) == SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER)
			{
				objectParams.flags |= PhysicObject_HasImpactImpulse;
				objectParams.impactimpulse_threshold = m_flImpactImpulseThreshold;
			}

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_FREEZE) == SF_ENV_PHYSMODEL_FREEZE)
			{
				objectParams.flags |= PhysicObject_Freeze;
			}

			g_EntityFuncs.CreatePhysicObject(self.edict(), shapeParams, objectParams);

			SetTouch(TouchFunction(this.PhysicTouch));
			SetThink(ThinkFunction(this.PhysicThink));
			self.pev.nextthink = g_Engine.time + 1.0;
		}
		else if(m_iShapeType == PhysicShape_Sphere)
		{
			PhysicShapeParams shapeParams;
			shapeParams.type = PhysicShape_Sphere;
			shapeParams.size = m_vecHalfExtent;

			PhysicObjectParams objectParams;
			objectParams.mass = m_flMass;
			objectParams.linearfriction = m_flLinearFriction;
			objectParams.rollingfriction = m_flRollingFriction;
			objectParams.restitution = m_flRestitution;
			objectParams.ccdradius = m_flCCDRadius;
			objectParams.ccdthreshold = m_flCCDThreshold;
			objectParams.impactimpulse_threshold = m_flImpactImpulseThreshold;

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_CLIPPINGHULL) == SF_ENV_PHYSMODEL_CLIPPINGHULL)
			{
				objectParams.flags |= PhysicObject_HasClippingHull;
				objectParams.clippinghull_shapetype = m_iClippingHullShapeType;
				objectParams.clippinghull_shapedirection = m_iClippingHullShapeDirection;
				objectParams.clippinghull_size = m_vecHalfExtent;
			}

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER) == SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER)
			{
				objectParams.flags |= PhysicObject_HasImpactImpulse;
				objectParams.impactimpulse_threshold = m_flImpactImpulseThreshold;
			}

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_FREEZE) == SF_ENV_PHYSMODEL_FREEZE)
			{
				objectParams.flags |= PhysicObject_Freeze;
			}

			g_EntityFuncs.CreatePhysicObject(self.edict(), shapeParams, objectParams);

			SetTouch(TouchFunction(this.PhysicTouch));
			SetThink(ThinkFunction(this.PhysicThink));
			self.pev.nextthink = g_Engine.time + 1.0;
		}
		else if(m_iShapeType == PhysicShape_Cylinder)
		{
			PhysicShapeParams shapeParams;
			shapeParams.type = PhysicShape_Cylinder;
			shapeParams.size = m_vecHalfExtent;
			shapeParams.direction = m_iShapeDirection;

			PhysicObjectParams objectParams;
			objectParams.mass = m_flMass;
			objectParams.linearfriction = m_flLinearFriction;
			objectParams.rollingfriction = m_flRollingFriction;
			objectParams.restitution = m_flRestitution;
			objectParams.ccdradius = m_flCCDRadius;
			objectParams.ccdthreshold = m_flCCDThreshold;
			objectParams.impactimpulse_threshold = m_flImpactImpulseThreshold;

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_CLIPPINGHULL) == SF_ENV_PHYSMODEL_CLIPPINGHULL)
			{
				objectParams.flags |= PhysicObject_HasClippingHull;
				objectParams.clippinghull_shapetype = m_iClippingHullShapeType;
				objectParams.clippinghull_shapedirection = m_iClippingHullShapeDirection;
				objectParams.clippinghull_size = m_vecHalfExtent;
			}

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER) == SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER)
			{
				objectParams.flags |= PhysicObject_HasImpactImpulse;
				objectParams.impactimpulse_threshold = m_flImpactImpulseThreshold;
			}

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_FREEZE) == SF_ENV_PHYSMODEL_FREEZE)
			{
				objectParams.flags |= PhysicObject_Freeze;
			}

			g_EntityFuncs.CreatePhysicObject(self.edict(), shapeParams, objectParams);

			SetTouch(TouchFunction(this.PhysicTouch));
			SetThink(ThinkFunction(this.PhysicThink));
			self.pev.nextthink = g_Engine.time + 1.0;
		}
		else if(m_iShapeType == PhysicShape_Capsule)
		{
			PhysicShapeParams shapeParams;
			shapeParams.type = PhysicShape_Capsule;
			shapeParams.size = m_vecHalfExtent;
			shapeParams.direction = m_iShapeDirection;

			PhysicObjectParams objectParams;
			objectParams.mass = m_flMass;
			objectParams.linearfriction = m_flLinearFriction;
			objectParams.rollingfriction = m_flRollingFriction;
			objectParams.restitution = m_flRestitution;
			objectParams.ccdradius = m_flCCDRadius;
			objectParams.ccdthreshold = m_flCCDThreshold;
			objectParams.impactimpulse_threshold = m_flImpactImpulseThreshold;

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_CLIPPINGHULL) == SF_ENV_PHYSMODEL_CLIPPINGHULL)
			{
				objectParams.flags |= PhysicObject_HasClippingHull;
				objectParams.clippinghull_shapetype = m_iClippingHullShapeType;
				objectParams.clippinghull_shapedirection = m_iClippingHullShapeDirection;
				objectParams.clippinghull_size = m_vecHalfExtent;
			}

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER) == SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER)
			{
				objectParams.flags |= PhysicObject_HasImpactImpulse;
				objectParams.impactimpulse_threshold = m_flImpactImpulseThreshold;
			}

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_FREEZE) == SF_ENV_PHYSMODEL_FREEZE)
			{
				objectParams.flags |= PhysicObject_Freeze;
			}

			g_EntityFuncs.CreatePhysicObject(self.edict(), shapeParams, objectParams);

			SetTouch(TouchFunction(this.PhysicTouch));
			SetThink(ThinkFunction(this.PhysicThink));
			self.pev.nextthink = g_Engine.time + 1.0;
		}
		else if(m_iShapeType == PhysicShape_MultiSphere)
		{
			array<string>@ vPointRadiusString = m_szPointRadius.Split(" ");

			array<float> vPointRadiusArray;
				
			for(int i = 0;i < int(vPointRadiusString.length()); ++i)
			{
				string val = vPointRadiusString[i];
				vPointRadiusArray.insertLast(atof(val));
			}

			PhysicShapeParams shapeParams;
			shapeParams.type = PhysicShape_MultiSphere;
			@shapeParams.multispheres = @vPointRadiusArray;

			PhysicObjectParams objectParams;
			objectParams.mass = m_flMass;
			objectParams.linearfriction = m_flLinearFriction;
			objectParams.rollingfriction = m_flRollingFriction;
			objectParams.restitution = m_flRestitution;
			objectParams.ccdradius = m_flCCDRadius;
			objectParams.ccdthreshold = m_flCCDThreshold;
			objectParams.impactimpulse_threshold = m_flImpactImpulseThreshold;

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_CLIPPINGHULL) == SF_ENV_PHYSMODEL_CLIPPINGHULL)
			{
				objectParams.flags |= PhysicObject_HasClippingHull;
				objectParams.clippinghull_shapetype = m_iClippingHullShapeType;
				objectParams.clippinghull_shapedirection = m_iClippingHullShapeDirection;
				objectParams.clippinghull_size = m_vecHalfExtent;
			}

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER) == SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER)
			{
				objectParams.flags |= PhysicObject_HasImpactImpulse;
				objectParams.impactimpulse_threshold = m_flImpactImpulseThreshold;
			}

			if((self.pev.spawnflags & SF_ENV_PHYSMODEL_FREEZE) == SF_ENV_PHYSMODEL_FREEZE)
			{
				objectParams.flags |= PhysicObject_Freeze;
			}

			g_EntityFuncs.CreatePhysicObject(self.edict(), shapeParams, objectParams);

			SetTouch(TouchFunction(this.PhysicTouch));
			SetThink(ThinkFunction(this.PhysicThink));
			self.pev.nextthink = g_Engine.time + 1.0;
		}

		if(self.pev.fuser1 > 0 || self.pev.fuser2 > 0 || self.pev.fuser3 > 0)
		{
			g_EntityFuncs.SetEntityLevelOfDetail(self.edict(), 
				LOD_BODY,
				0, 0, //LoD 0
				self.pev.iuser1, 0, self.pev.fuser1, //LoD 1
				self.pev.iuser2, 0, self.pev.fuser2, //LoD 2
				self.pev.iuser3, 0, self.pev.fuser3 //LoD 3
			);
		}

		m_flSpawnTime = g_Engine.time;
	}

	void PhysicTouch( CBaseEntity@ pOther )
	{
		Vector vecImpactPosition = g_vecZero;
		Vector vecImpactDirection = g_vecZero;
		float flImpactImpulse = 0;
		edict_t @pImpactEntity = g_EntityFuncs.GetCurrentPhysicImpactEntity(vecImpactPosition, vecImpactDirection, flImpactImpulse);
		if(pImpactEntity !is null)
		{
			if(m_szImpactSound.length() > 0 && g_Engine.time > m_flLastImpactSound + 0.2)
			{
				float flVolume = (flImpactImpulse / m_flImpactImpulseVolumeFactor);

				if(flVolume > 1.0)
					flVolume = 1.0;
				if(flVolume < 0.1)
					flVolume = 0.1;

				g_SoundSystem.PlaySound( self.edict(), CHAN_BODY, m_szImpactSound[Math.RandomLong(0, m_szImpactSound.length() - 1)], flVolume, m_flImpactSoundAttenuation, 0, 90 + Math.RandomLong(0, 20), 0, true, vecImpactPosition );

				m_flLastImpactSound = g_Engine.time;

				//g_Game.AlertMessage( at_console, "%1 is touching %2 %3 impulse %4\n", string(pOther.pev.targetname), string(pOther.pev.classname), string(pOther.pev.targetname), flImpactImpulse);
			}
		}

		if(pOther.IsPlayer() && pOther.IsAlive())
		{
			if((pOther.pev.flags & FL_ONGROUND) == FL_ONGROUND && (pOther.pev.groundentity is self.edict() ))
			{
				
			}
			else
			{
				if(g_EngineFuncs.GetRunPlayerMovePlayerIndex() == pOther.entindex())
				{
					//called from PlayerMove
					if((self.pev.spawnflags & SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER) == SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER)
					{
						if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()])
						{
							pOther.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );

							Vector vecImpactPosition2 = vecImpactPosition;

							if(vecImpactPosition2 != g_vecZero)
							{
								Vector vecImpactDirection2 = (pOther.pev.origin - self.pev.origin).Normalize();
								vecImpactDirection2.z *= 72.0 / 32.0;

								vecImpactPosition2 = pOther.pev.origin - vecImpactDirection2 * 12;
							}

							EmitPlayerHitEffect(pOther, flImpactImpulse > m_flImpactImpulseThresholdMediumHit ? HitEffect_Medium : HitEffect_Small, vecImpactPosition2, vecImpactDirection);

							g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 1.0;
						}
					}
				}
				else
				{
					//called from EndFrame
					if((self.pev.spawnflags & SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER) == SF_ENV_PHYSMODEL_PLAYSOUND_WHEN_IMPACTPLAYER)
					{
						if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()])
						{
							pOther.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );

							Vector vecImpactPosition2 = vecImpactPosition;

							if(vecImpactPosition2 != g_vecZero)
							{
								Vector vecImpactDirection2 = (pOther.pev.origin - self.pev.origin).Normalize();
								vecImpactDirection2.z *= 72.0 / 32.0;

								vecImpactPosition2 = pOther.pev.origin - vecImpactDirection2 * 12;
							}

							EmitPlayerHitEffect(pOther, flImpactImpulse > m_flImpactImpulseThresholdLargeHit ? HitEffect_Large : HitEffect_Medium, vecImpactPosition2, vecImpactDirection);

							g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
						}
					}
				}
			}
		}
		else
		{
			//g_Game.AlertMessage( at_console, "%1 is touching %1 %2\n", string(pOther.pev.targetname), string(pOther.pev.classname), string(pOther.pev.targetname));
		}
	}

	void Smokelit()
	{
		for(int i = 0; i < 5; ++i)
		{
			float flRandom = Math.RandomFloat(0, 1);

			Vector vecSmokeSource = (self.pev.origin + self.pev.mins) * flRandom + (self.pev.origin + self.pev.maxs) * (1 - flRandom);

			CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecSmokeSource, g_vecZero, false);

			g_EntityFuncs.SetModel(pEntity, m_szSmokeSprite[Math.RandomLong(0, int(m_szSmokeSprite.length()) - 1 )]);

			pEntity.pev.scale = Math.RandomFloat(0.15, 0.25);
			pEntity.pev.solid = SOLID_NOT;
			pEntity.pev.movetype = MOVETYPE_NOCLIP;
			pEntity.pev.rendermode = kRenderTransAlpha;
			pEntity.pev.renderamt = 160;

			Vector Color1 = Vector(255, 190, 240);
			Vector Color2 = Vector(255, 255, 255);
			float ColorMix = Math.RandomFloat(0.0, 1.0);
			pEntity.pev.rendercolor = Color1 * ColorMix + Color2 * (1.0 - ColorMix);
			pEntity.pev.velocity = Vector(0, 0, 50);
			pEntity.pev.avelocity = Vector(0, 0, Math.RandomFloat(30, 60));
			pEntity.pev.framerate = 20;
			pEntity.pev.spawnflags = 0;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_RENDERAMT;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SCALE;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_STATIC_FRAME;
			pEntity.pev.frame = Math.RandomLong(0, 8);

			CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));
			pStudio.m_flUpdateRate = 0.0;
			pStudio.m_flMaxFrame = 10;

			EnvStudioKeyframe keyframe0;
			keyframe0.frame = 0;
			keyframe0.renderamt = 160;
			keyframe0.scale = pEntity.pev.scale * 0.6;
			pStudio.m_Keyframes.insertLast(keyframe0);

			EnvStudioKeyframe keyframe1;
			keyframe1.frame = 2;
			keyframe1.renderamt = 255;
			keyframe1.scale = pEntity.pev.scale * 0.8;
			pStudio.m_Keyframes.insertLast(keyframe1);

			EnvStudioKeyframe keyframe2;
			keyframe2.frame = 5;
			keyframe2.renderamt = 100;
			keyframe2.scale = pEntity.pev.scale;
			pStudio.m_Keyframes.insertLast(keyframe2);

			EnvStudioKeyframe keyframe3;
			keyframe3.frame = 10;
			keyframe3.renderamt = 0;
			keyframe3.scale = pEntity.pev.scale * 1.1;
			pStudio.m_Keyframes.insertLast(keyframe3);

			pStudio.StartSpriteAnim(0);
		}
	}

	void PhysicThink()
	{
		if(self.pev.origin.x > m_vecLivingMaxs.x || self.pev.origin.y > m_vecLivingMaxs.y || self.pev.origin.z > m_vecLivingMaxs.z ||
			self.pev.origin.x < m_vecLivingMins.x || self.pev.origin.y < m_vecLivingMins.y || self.pev.origin.z < m_vecLivingMins.z)
		{
			self.pev.flags |= FL_KILLME;
		}

		if(m_flLifeTime > 0 && g_Engine.time >= m_flSpawnTime + m_flLifeTime)
		{
			self.pev.flags |= FL_KILLME;

			Smokelit();
		}

		self.pev.nextthink = g_Engine.time + 0.2;
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_ON)
		{
			g_EntityFuncs.SetPhysicObjectFreeze(self.edict(), false);
		}
		else if(useType == USE_OFF)
		{
			g_EntityFuncs.SetPhysicObjectFreeze(self.edict(), true);
		}
		else if(useType == USE_SET)
		{
			
		}
		else if(useType == USE_TOGGLE)
		{

		}
	}
}

class CEnvStudioModel : ScriptBaseAnimating
{
	CBaseEntity @m_CopyFromEntity = null;
	Vector m_OriginOffset = g_vecZero;
	Vector m_AnglesOffset = g_vecZero;
	float m_flUpdateRate = 0;
	float m_flLastTime = 0;
	float m_flCurFrame = 0;
	float m_flMaxFrame = 0;

	array<EnvStudioKeyframe> m_Keyframes;

	void Precache()
	{
		BaseClass.Precache();

		if(!string(self.pev.model).IsEmpty())
			g_Game.PrecacheModel( self.pev.model );
	}

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		if(!string(self.pev.target).IsEmpty())
		{
			m_flLastTime = g_Engine.time;
			self.pev.nextthink = g_Engine.time + 1.0;
			SetThink(ThinkFunction(this.UpdateThink));
		}

		if(self.pev.fuser1 > 0 || self.pev.fuser2 > 0 || self.pev.fuser3 > 0)
		{
			g_EntityFuncs.SetEntityLevelOfDetail(self.edict(), 
				LOD_BODY,
				0, 0, //LoD 0
				self.pev.iuser1, 0, self.pev.fuser1, //LoD 1
				self.pev.iuser2, 0, self.pev.fuser2, //LoD 2
				self.pev.iuser3, 0, self.pev.fuser3 //LoD 3
			);
		}
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "lod1"){
			self.pev.fuser1 = atof(szValue);
			return true;
		}
		if(szKey == "lod1body"){
			self.pev.iuser1 = atoi(szValue);
			return true;
		}
		if(szKey == "lod2"){
			self.pev.fuser2 = atof(szValue);
			return true;
		}
		if(szKey == "lod2body"){
			self.pev.iuser2 = atoi(szValue);
			return true;
		}
		if(szKey == "lod3"){
			self.pev.fuser3 = atof(szValue);
			return true;
		}
		if(szKey == "lod3body"){
			self.pev.iuser3 = atoi(szValue);
			return true;
		}

		if(szKey == "origin_offset"){
			g_Utility.StringToVector( m_OriginOffset, szValue );
			return true;
		}

		if(szKey == "angles_offset"){
			g_Utility.StringToVector( m_AnglesOffset, szValue );
			return true;
		}

		if(szKey == "updaterate"){
			m_flUpdateRate = atof(szValue);
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_ON)
		{
			self.pev.effects &= ~EF_NODRAW;
		}
		else if(useType == USE_OFF)
		{
			self.pev.effects |= EF_NODRAW;
		}
		else if(useType == USE_SET)
		{
			if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_SET_SKIN) == SF_ENV_STUDIOMODEL_SET_SKIN)
			{
				self.pev.skin = int(flValue);
			}
			if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_SET_BODY) == SF_ENV_STUDIOMODEL_SET_BODY)
			{
				self.pev.body = int(flValue);
			}
		}
		else if(useType == USE_TOGGLE)
		{
			if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_PLAY_SEQUENCE_ON_TOGGLE) == SF_ENV_STUDIOMODEL_PLAY_SEQUENCE_ON_TOGGLE)
			{
				StartStudioSequence(atoi(flValue));
			}
		}
	}

	int ConvertToEnvStudioAnimFlags(int spawnflags)
	{
		int flags = 0;

		if((spawnflags & SF_ENV_STUDIOMODEL_ANIMATED_STUDIO) == SF_ENV_STUDIOMODEL_ANIMATED_STUDIO)
			flags |= EnvStudioAnim_AnimatedStudio;

		if((spawnflags & SF_ENV_STUDIOMODEL_ANIMATED_SPRITE) == SF_ENV_STUDIOMODEL_ANIMATED_SPRITE)
			flags |= EnvStudioAnim_AnimatedSprite;

		if((spawnflags & SF_ENV_STUDIOMODEL_STATIC_FRAME) == SF_ENV_STUDIOMODEL_STATIC_FRAME)
			flags |= EnvStudioAnim_StaticFrame;

		if((spawnflags & SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH) == SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH)
			flags |= EnvStudioAnim_RemoveOnAnimFinished;

		if((spawnflags & SF_ENV_STUDIOMODEL_REMOVE_ON_BOUND_EXCCEEDED) == SF_ENV_STUDIOMODEL_REMOVE_ON_BOUND_EXCCEEDED)
			flags |= EnvStudioAnim_RemoveOnBoundExcceeded;

		if((spawnflags & SF_ENV_STUDIOMODEL_ANIMATED_RENDERAMT) == SF_ENV_STUDIOMODEL_ANIMATED_RENDERAMT)
			flags |= EnvStudioAnim_AnimatedRenderAmt;

		if((spawnflags & SF_ENV_STUDIOMODEL_ANIMATED_SCALE) == SF_ENV_STUDIOMODEL_ANIMATED_SCALE)
			flags |= EnvStudioAnim_AnimatedScale;

		return flags;
	}

	void StartSpriteAnim(float frame)
	{
		m_flCurFrame = frame;

		if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_STATIC_FRAME) == 0)
			self.pev.frame = m_flCurFrame;

		if ((self.pev.spawnflags & (SF_ENV_STUDIOMODEL_ANIMATED_STUDIO | SF_ENV_STUDIOMODEL_ANIMATED_SPRITE)) != 0)
		{
			if(g_EntityFuncs.SetEntityEnvStudioAnim(self.edict(), ConvertToEnvStudioAnimFlags(self.pev.spawnflags), m_flCurFrame, m_flMaxFrame, m_Keyframes))
			{
				self.pev.spawnflags &= ~SF_ENV_STUDIOMODEL_ANIMATED_STUDIO;
				self.pev.spawnflags &= ~SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
				return;
			}
		}

		if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_ANIMATED_SPRITE) == SF_ENV_STUDIOMODEL_ANIMATED_SPRITE)
		{
			m_flLastTime = g_Engine.time;
			self.pev.nextthink = g_Engine.time + m_flUpdateRate;
			SetThink(ThinkFunction(this.UpdateThink));
		}
	}

	void StartStudioSequence(int sequence)
	{
		self.pev.sequence = sequence;
		self.pev.gaitsequence = sequence;
		self.pev.frame = 0;
		self.ResetSequenceInfo();

		if ((self.pev.spawnflags & (SF_ENV_STUDIOMODEL_ANIMATED_STUDIO | SF_ENV_STUDIOMODEL_ANIMATED_SPRITE)) != 0)
		{
			if(g_EntityFuncs.SetEntityEnvStudioAnim(self.edict(), ConvertToEnvStudioAnimFlags(self.pev.spawnflags), m_flCurFrame, -1, m_Keyframes))
			{
				self.pev.spawnflags &= ~SF_ENV_STUDIOMODEL_ANIMATED_STUDIO;
				self.pev.spawnflags &= ~SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
				return;
			}
		}

		if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_ANIMATED_STUDIO) == SF_ENV_STUDIOMODEL_ANIMATED_STUDIO)
		{
			m_flLastTime = g_Engine.time;
			self.pev.nextthink = g_Engine.time + m_flUpdateRate;
			SetThink(ThinkFunction(this.UpdateThink));
		}
	}

	int ConvertToFollowEntFlags(int spawnflags)
	{
		int flags = 0;

		if((spawnflags & SF_ENV_STUDIOMODEL_COPY_ORIGIN) == SF_ENV_STUDIOMODEL_COPY_ORIGIN)
			flags |= FollowEnt_CopyOrigin;

		if((spawnflags & SF_ENV_STUDIOMODEL_COPY_ORIGIN_Z) == SF_ENV_STUDIOMODEL_COPY_ORIGIN_Z)
			flags |= FollowEnt_CopyOriginZ;

		if((spawnflags & SF_ENV_STUDIOMODEL_COPY_ANGLES) == SF_ENV_STUDIOMODEL_COPY_ANGLES)
			flags |= FollowEnt_CopyAngles;

		if((spawnflags & SF_ENV_STUDIOMODEL_COPY_NODRAW) == SF_ENV_STUDIOMODEL_COPY_NODRAW)
			flags |= FollowEnt_CopyNoDraw;

		return flags;
	}

	void UpdateKeyframeAnim(float frame)
	{
		if(m_Keyframes.length() > 0)
		{
			for(int i = 1;i < int(m_Keyframes.length()); ++i)
			{
				float startframe = m_Keyframes[i - 1].frame;
				float endframe = m_Keyframes[i].frame;
				float totalframe = endframe - startframe;
				if(frame >= startframe && frame < endframe)
				{
					float factor = (frame - startframe) / totalframe;

					if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_ANIMATED_RENDERAMT) == SF_ENV_STUDIOMODEL_ANIMATED_RENDERAMT)
					{
						self.pev.renderamt = (1.0 - factor) * m_Keyframes[i - 1].renderamt + factor * m_Keyframes[i].renderamt;
					}

					if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_ANIMATED_SCALE) == SF_ENV_STUDIOMODEL_ANIMATED_SCALE)
					{
						self.pev.scale = (1.0 - factor) * m_Keyframes[i - 1].scale + factor * m_Keyframes[i].scale;
					}
						
					break;
				}
			}
		}
	}

	void UpdateThink()
	{
		if(m_CopyFromEntity is null)
		{
			CBaseEntity @pTarget = g_EntityFuncs.FindEntityByTargetname( null, self.pev.target );

			if(pTarget !is null)
			{
				@m_CopyFromEntity = @pTarget;

				self.pev.movetype = MOVETYPE_NOCLIP;

				if(g_EntityFuncs.SetEntityFollow(self.edict(), m_CopyFromEntity.edict(), ConvertToFollowEntFlags(self.pev.spawnflags), m_OriginOffset, m_AnglesOffset))
				{
					self.pev.spawnflags &= ~SF_ENV_STUDIOMODEL_COPY_ORIGIN;
					self.pev.spawnflags &= ~SF_ENV_STUDIOMODEL_COPY_ORIGIN_Z;
					self.pev.spawnflags &= ~SF_ENV_STUDIOMODEL_COPY_ANGLES;
					self.pev.spawnflags &= ~SF_ENV_STUDIOMODEL_COPY_NODRAW;
				}
			}
		}

		//Stop thinking if has nothing to do
		if((self.pev.spawnflags & (
			SF_ENV_STUDIOMODEL_COPY_ORIGIN | 
			SF_ENV_STUDIOMODEL_COPY_ORIGIN_Z | 
			SF_ENV_STUDIOMODEL_COPY_ANGLES | 
			SF_ENV_STUDIOMODEL_COPY_NODRAW | 
			SF_ENV_STUDIOMODEL_ANIMATED_STUDIO | 
			SF_ENV_STUDIOMODEL_ANIMATED_SPRITE)) == 0)
		{
			return;
		}

		if(m_CopyFromEntity !is null)
		{
			if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_COPY_ORIGIN) == SF_ENV_STUDIOMODEL_COPY_ORIGIN)
			{
				self.pev.origin = m_CopyFromEntity.pev.origin;
				self.pev.origin = self.pev.origin + m_OriginOffset;
			}

			if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_COPY_ANGLES) == SF_ENV_STUDIOMODEL_COPY_ANGLES)
			{
				self.pev.angles = m_CopyFromEntity.pev.angles;
				self.pev.angles = self.pev.angles + m_AnglesOffset;
			}

			if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_COPY_ORIGIN_Z) == SF_ENV_STUDIOMODEL_COPY_ORIGIN_Z)
			{
				self.pev.origin.z = m_CopyFromEntity.pev.origin.z;
				self.pev.origin = self.pev.origin + m_OriginOffset;
			}	

			if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_COPY_NODRAW) == SF_ENV_STUDIOMODEL_COPY_NODRAW)
			{
				if((m_CopyFromEntity.pev.effects & EF_NODRAW) == EF_NODRAW)
					self.pev.effects |= EF_NODRAW;
				else
					self.pev.effects &= ~EF_NODRAW;
			}
		}

		if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_ANIMATED_STUDIO) == SF_ENV_STUDIOMODEL_ANIMATED_STUDIO)
		{
			self.StudioFrameAdvance();

			UpdateKeyframeAnim(self.pev.frame);
			
			if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH) == SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH)
			{
				if (self.m_fSequenceFinished)
				{
					self.pev.flags |= FL_KILLME;
				}
			}
		}

		if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_ANIMATED_SPRITE) == SF_ENV_STUDIOMODEL_ANIMATED_SPRITE )
		{
			m_flCurFrame += self.pev.framerate * (g_Engine.time - m_flLastTime);

			if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_STATIC_FRAME) == 0)
				self.pev.frame = m_flCurFrame;

			UpdateKeyframeAnim(m_flCurFrame);

			if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH) == SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH)
			{
				if(m_flCurFrame >= m_flMaxFrame)
				{
					self.pev.flags |= FL_KILLME;
				}
			}
			if((self.pev.spawnflags & SF_ENV_STUDIOMODEL_REMOVE_ON_BOUND_EXCCEEDED) == SF_ENV_STUDIOMODEL_REMOVE_ON_BOUND_EXCCEEDED )
			{
				if(self.pev.origin.x > self.pev.vuser2.x || self.pev.origin.y > self.pev.vuser2.y || self.pev.origin.z > self.pev.vuser2.z ||
					self.pev.origin.x < self.pev.vuser1.x || self.pev.origin.y < self.pev.vuser1.y || self.pev.origin.z < self.pev.vuser1.z)
				{
					self.pev.flags |= FL_KILLME;
				}
			}
		}

		self.pev.nextthink = g_Engine.time + m_flUpdateRate;
		m_flLastTime = g_Engine.time;
	}
}

class CFuncRotatingFg : ScriptBaseEntity
{
	float m_flFanFriction = 1.0;
	float m_flInitialSpeed = 1.0;
	float m_flInitialHealth = 0.0;

	Vector m_vecInitialAngles;

	float m_flPushForce = 0.0;
	float m_flUpForce = 0.0;
	float m_flOutForce = 0.0;
	float m_flBlockUpForce = 0.0;
	float m_flBlockOutForce = 0.0;
	float m_flSlideForce = 0.0;
	float m_flMaxVelocity = 0.0;
	float m_flDynamicForce = 0.0;
	float m_flBlockCrushTime = 4.0;

	float m_flBounceDrumForce = 0.0;
	float m_flBounceDrumPitch = 0.0;
	string m_szBounceDrumStudioModel = "";
	float m_flLastBounceTime = 0.0;

	bool m_bIsSuperPusher = false;

	array<string> m_szHitSoundName = {
		"fallguys/impact1.ogg",
		"fallguys/impact2.ogg",
		"fallguys/impact3.ogg"
	};

	string m_szBlockSoundName = "fallguys/mecha.ogg";
	string m_szSlideSoundName = "fallguys/slide.ogg";

	array<string> m_szBounceSoundName = {
		"fallguys/bounce.ogg",
		"fallguys/bounce2.ogg",
		"fallguys/bounce3.ogg"
	};

	void Precache()
	{
		BaseClass.Precache();

		g_SoundSystem.PrecacheSound( m_szHitSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szHitSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szHitSoundName[2] );

		g_SoundSystem.PrecacheSound( m_szBlockSoundName );
		g_SoundSystem.PrecacheSound( m_szSlideSoundName );
	}

	void Restart()
	{
		self.pev.speed = m_flInitialSpeed;
		self.pev.health = m_flInitialHealth;
		self.pev.deadflag = DEAD_NO;

		/*if(self.pev.health > 0)
		{
			self.pev.takedamage = DAMAGE_YES;
		}
		else
		{
			self.pev.takedamage = DAMAGE_NO;
		}

		if(( int(self.pev.frags) & Round_Final) == Round_Final)
		{
			self.pev.takedamage = DAMAGE_NO;
		}*/

		self.pev.avelocity = g_vecZero;
		self.pev.angles = m_vecInitialAngles;

		if ((self.pev.spawnflags & SF_BRUSH_ROTATE_INSTANT) == SF_BRUSH_ROTATE_INSTANT)
		{
			NextThink(self.pev.ltime + 1.5, false);
			SetThink(ThinkFunction(this.SUB_CallUseToggle));
		}
		else
		{
			NextThink(self.pev.ltime + 10.0, false);
			SetThink(ThinkFunction(this.Rotate));
		}
	}

	void Spawn()
	{
		Precache();

		if(self.pev.speed > 0)
			m_flInitialSpeed = self.pev.speed;

		m_vecInitialAngles = self.pev.angles;

		if (m_flFanFriction == 0.0)
			m_flFanFriction = 1.0;

		self.pev.solid = SOLID_BSP;
		self.pev.movetype = MOVETYPE_PUSH;
		self.pev.deadflag = DEAD_NO;

		m_flInitialHealth = self.pev.health;

		if(self.pev.health > 0)
		{
			self.pev.takedamage = DAMAGE_YES;
		}
		else
		{
			self.pev.takedamage = DAMAGE_NO;
		}

		if ((self.pev.spawnflags & SF_BRUSH_ROTATE_Z_AXIS) == SF_BRUSH_ROTATE_Z_AXIS)
			self.pev.movedir = Vector(0.0, 0.0, 1.0);
		else if ((self.pev.spawnflags & SF_BRUSH_ROTATE_X_AXIS) == SF_BRUSH_ROTATE_X_AXIS)
			self.pev.movedir = Vector(1.0, 0.0, 0.0);
		else
			self.pev.movedir = Vector(0.0, 1.0, 0.0);

		if ((self.pev.spawnflags & SF_BRUSH_ROTATE_BACKWARDS) == SF_BRUSH_ROTATE_BACKWARDS)
			self.pev.movedir =  self.pev.movedir * (-1.0);

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		if ((self.pev.spawnflags & SF_BRUSH_ROTATE_INSTANT) == SF_BRUSH_ROTATE_INSTANT)
		{
			NextThink(self.pev.ltime + 1.5, false);
			SetThink(ThinkFunction(this.SUB_CallUseToggle));
		}
		else
		{
			NextThink(self.pev.ltime + 10.0, false);
			SetThink(ThinkFunction(this.Rotate));
		}

		if(m_bIsSuperPusher)
			g_EntityFuncs.SetEntitySuperPusher(self.edict(), true);
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "fanfriction"){
			m_flFanFriction = atof(szValue) / 100.0;
			return true;
		}

		if(szKey == "pushforce"){
			m_flPushForce = atof(szValue);
			return true;
		}

		if(szKey == "upforce"){
			m_flUpForce = atof(szValue);
			return true;
		}

		if(szKey == "outforce"){
			m_flOutForce = atof(szValue);
			return true;
		}

		if(szKey == "blockupforce"){
			m_flBlockUpForce = atof(szValue);
			return true;
		}

		if(szKey == "blockoutforce"){
			m_flBlockOutForce = atof(szValue);
			return true;
		}

		if(szKey == "slideforce"){
			m_flSlideForce = atof(szValue);
			return true;
		}

		if(szKey == "maxvelocity"){
			m_flMaxVelocity = atof(szValue);
			return true;
		}

		if(szKey == "dynamicforce"){
			m_flDynamicForce = atof(szValue);
			return true;
		}

		if(szKey == "bouncedrumforce"){
			m_flBounceDrumForce = atof(szValue);
			return true;
		}

		if(szKey == "bouncedrumpitch"){
			m_flBounceDrumPitch = atof(szValue);
			return true;
		}

		if(szKey == "bouncedrumstudio"){
			m_szBounceDrumStudioModel = szValue;
			return true;
		}

		if(szKey == "hitsound0"){
			m_szHitSoundName[0] = szValue;
			return true;
		}

		if(szKey == "hitsound2"){
			m_szHitSoundName[1] = szValue;
			return true;
		}

		if(szKey == "hitsound2"){
			m_szHitSoundName[2] = szValue;
			return true;
		}

		if(szKey == "bouncesound0"){
			m_szBounceSoundName[0] = szValue;
			return true;
		}

		if(szKey == "bouncesound2"){
			m_szBounceSoundName[1] = szValue;
			return true;
		}

		if(szKey == "bouncesound2"){
			m_szBounceSoundName[2] = szValue;
			return true;
		}

		if(szKey == "blocksound"){
			m_szBlockSoundName = szValue;
			return true;
		}

		if(szKey == "blockcrushtime"){
			m_flBlockCrushTime = atof(szValue);
			return true;
		}

		if(szKey == "slidesound"){
			m_szSlideSoundName = szValue;
			return true;
		}

		if(szKey == "superpusher"){
			m_bIsSuperPusher = atoi(szValue) > 0 ? true : false;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	int TakeDamage( entvars_t@ pevInflictor, entvars_t@ pevAttacker, float flDamage, int bitsDamageType)
	{	
		if(self.pev.takedamage == DAMAGE_NO)
			return 0;

		if(self.pev.deadflag != DEAD_NO)
			return 0;

		self.pev.health -= flDamage;

		if (self.pev.health <= 0)
		{
			self.pev.deadflag = DEAD_DEAD;
			/*self.pev.takedamage = DAMAGE_NO;
			self.pev.deadflag = DEAD_DEAD;
			self.pev.effects |= EF_NODRAW;
			self.pev.solid = SOLID_NOT;*/

			if(!string(self.pev.target).IsEmpty())
			{
				g_EntityFuncs.FireTargets( string(self.pev.target), self, self, USE_TOGGLE );
			}
		}

		return 0;
	}

	bool IsRotating()
	{
		return (self.pev.avelocity.x == 0.0 && self.pev.avelocity.y == 0.0 && self.pev.avelocity.z == 0.0) ? false : true;
	}

	float GetCurrentRotateSpeed()
	{
		float speed = 0.0;
		if(self.pev.movedir.x != 0.0) 
		{
			speed = self.pev.avelocity.x;
		}
		else if(self.pev.movedir.y != 0.0)
		{
			speed = self.pev.avelocity.y;
		}
		else
		{
			speed = self.pev.avelocity.z;
		}
		return abs(speed);
	}

	float GetCurrentRotateDirection()
	{
		float vecdir = 0.0;
		if(self.pev.movedir.x != 0.0) 
		{
			vecdir = self.pev.movedir.x;
		}
		else if(self.pev.movedir.y != 0.0)
		{
			vecdir = self.pev.movedir.y;
		}
		else
		{
			vecdir = self.pev.movedir.z;
		}
		return vecdir;
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if ((self.pev.spawnflags & SF_BRUSH_ACCDCC) == SF_BRUSH_ACCDCC)
		{
			if(useType == USE_TOGGLE)
			{
				if (!IsRotating())
				{
					NextThink(self.pev.ltime + 0.1, false);
					SetThink(ThinkFunction(this.SpinUp));
				}
				else
				{
					NextThink(self.pev.ltime + 0.1, false);
					SetThink(ThinkFunction(this.SpinDown));
				}
			}
			else if(useType == USE_ON)
			{
				if (!IsRotating())
				{
					NextThink(self.pev.ltime + 0.1, false);
					SetThink(ThinkFunction(this.SpinUp));
				}
			}
			else if(useType == USE_OFF)
			{
				if (IsRotating())
				{
					NextThink(self.pev.ltime + 0.1, false);
					SetThink(ThinkFunction(this.SpinDown));
				}
			}
			else if(useType == USE_SET && flValue > 0.0)
			{
				if (!IsRotating())
				{
					self.pev.speed = flValue;
				}
				else
				{
					if(self.pev.speed < flValue)
					{
						self.pev.speed = flValue;
						NextThink(self.pev.ltime + 0.1, false);
						SetThink(ThinkFunction(this.SpinUp));
					}
					else if(self.pev.speed > flValue)
					{
						self.pev.speed = flValue;
						NextThink(self.pev.ltime + 0.1, false);
						SetThink(ThinkFunction(this.SpinDownToLowSpeed));
					}
				}
			}
			else if(useType == USE_SET && flValue < 0.0)
			{
				Restart();
				return;
			}
		}
		else
		{
			if(useType == USE_TOGGLE)
			{
				if (!IsRotating())
				{
					self.pev.avelocity = self.pev.movedir * self.pev.speed;
					NextThink(self.pev.ltime + 0.1, false);
					SetThink(ThinkFunction(this.Rotate));
				}
				else
				{
					self.pev.avelocity = g_vecZero;
					NextThink(self.pev.ltime + 0.1, false);
					SetThink(ThinkFunction(this.Rotate));
				}
			}
			else if(useType == USE_ON)
			{
				if (!IsRotating())
				{
					self.pev.avelocity = self.pev.movedir * self.pev.speed;
					NextThink(self.pev.ltime + 0.1, false);
					SetThink(ThinkFunction(this.Rotate));
				}
			}
			else if(useType == USE_OFF)
			{
				if (IsRotating())
				{
					self.pev.avelocity = g_vecZero;
					NextThink(self.pev.ltime + 0.1, false);
					SetThink(ThinkFunction(this.Rotate));
				}
			}
			else if(useType == USE_SET && flValue > 0.0)
			{
				if (!IsRotating())
				{
					self.pev.speed = flValue;
				}
				else
				{
					if(self.pev.speed != flValue)
					{
						self.pev.speed = flValue;
						self.pev.avelocity = self.pev.movedir * self.pev.speed;
						NextThink(self.pev.ltime + 0.1, false);
						SetThink(ThinkFunction(this.Rotate));
					}
				}
			}
			else if(useType == USE_SET && flValue < 0.0)
			{
				Restart();
				return;
			}
		}
	}

	float CalcDynamicForce(float flValue)
	{
		if(m_flDynamicForce > 0)
		{
			float flCurrentSpeed = GetCurrentRotateSpeed();
			if(flCurrentSpeed > 0)
				return flValue * pow(flCurrentSpeed / m_flInitialSpeed, m_flDynamicForce);
			else
				return flValue;
		}
		return flValue;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		//This is not PM code, velocity works
		Vector vecSuperPusherPushingVector;
		if(g_EntityFuncs.GetCurrentSuperPusher(vecSuperPusherPushingVector) is self.edict())
		{
			if(m_flPushForce > 0)
			{
				float flForce = CalcDynamicForce(m_flPushForce);

				Vector vecImpactDirection = vecSuperPusherPushingVector;

				vecImpactDirection = vecImpactDirection.Normalize();

				pOther.pev.velocity = vecImpactDirection * flForce;

				if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

					g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szHitSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

					pOther.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );

					Vector vecImpactDirection2 = vecImpactDirection;
					vecImpactDirection2.z *= 72.0 / 32.0;

					Vector vecImpactPosition2 = pOther.pev.origin - vecImpactDirection2 * 16;

					EmitPlayerHitEffect(pOther, HitEffect_Large, vecImpactPosition2, vecImpactDirection);

					g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
				}
			}

			if(m_flUpForce > 0)
			{
				float flForce = CalcDynamicForce(m_flUpForce);

				if(pOther.pev.velocity.z < flForce)
					pOther.pev.velocity.z = flForce;
			}

			if(m_flOutForce > 0)
			{
				float flForce = CalcDynamicForce(m_flOutForce);

				Math.MakeVectors( self.pev.angles );

				Vector vOut = g_Engine.v_forward;

				if(m_flMaxVelocity > 0)
				{
					float flMaxVelocity = m_flMaxVelocity;
					if(m_flDynamicForce > 0)
					{
						flMaxVelocity = flMaxVelocity * (GetCurrentRotateSpeed() / m_flInitialSpeed) * m_flDynamicForce;
					}

					if(DotProduct(pOther.pev.velocity, vOut) > flMaxVelocity)
						return;
				}

				pOther.pev.velocity = vOut * flForce;
			}
			return;
		}

		//PM code, velocity not works
		if((self.pev.spawnflags & (SF_BRUSH_ROTATE_Z_AXIS | SF_BRUSH_ROTATE_X_AXIS)) == 0)
		{
			if(m_flBounceDrumForce > 0)
			{
				if(g_Engine.time > m_flLastBounceTime)
				{
					Vector vBounceAngles = self.pev.angles;

					vBounceAngles.x = -m_flBounceDrumPitch;

					Math.MakeVectors( vBounceAngles );

					Vector vecBounceVector = g_Engine.v_forward;

					g_ArrayBounceVelocityPlayer[pOther.entindex()] = vecBounceVector * m_flBounceDrumForce;

					g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szBounceSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

					if(!m_szBounceDrumStudioModel.IsEmpty())
					{
						g_EntityFuncs.FireTargets( m_szBounceDrumStudioModel, self, self, USE_TOGGLE, 1 );
					}

					m_flLastBounceTime = g_Engine.time + 0.5;
				}
			}

			if(m_flSlideForce > 0)
			{
				float flForce = CalcDynamicForce(m_flSlideForce);

				if((pOther.pev.flags & FL_ONGROUND) == FL_ONGROUND && (pOther.pev.groundentity is self.edict() ))
				{
					Math.MakeVectors( self.pev.angles );

					Vector vRight = g_Engine.v_right;
					Vector vLeft = -g_Engine.v_right;
					Vector vDiff = (pOther.pev.origin - self.pev.origin);
					vDiff.z = 0;
					vDiff = vDiff.Normalize();

					if(self.pev.movedir.y > 0)
					{
						if(m_flMaxVelocity > 0)
						{
							float flMaxVelocity = CalcDynamicForce(m_flMaxVelocity);

							if(DotProduct(g_ArrayVelocityPlayer[pOther.entindex()], vRight) > flMaxVelocity)
								return;
						}

						pOther.pev.basevelocity = vRight * flForce;
						
						g_ArraySlidePlayer[pOther.entindex()] = g_Engine.time;

						if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

							g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szSlideSoundName, 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

							g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
						}
					}
					else if(self.pev.movedir.y < 0)
					{
						if(m_flMaxVelocity > 0)
						{
							float flMaxVelocity = CalcDynamicForce(m_flMaxVelocity);

							if(DotProduct(g_ArrayVelocityPlayer[pOther.entindex()], vLeft) > flMaxVelocity)
								return;
						}

						pOther.pev.basevelocity = vLeft * flForce;

						g_ArraySlidePlayer[pOther.entindex()] = g_Engine.time;

						if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){
							
							g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szSlideSoundName, 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

							g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
						}
					}
				}
			}
		}
	}

	void Blocked( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		if(g_ArrayBlockPlayer[pOther.entindex()].IsBlocking)
		{
			if(g_Engine.time > g_ArrayBlockPlayer[pOther.entindex()].flStartBlockTime + m_flBlockCrushTime)
			{
				pOther.TakeDamage(self.pev, self.pev, 999999, DMG_CRUSH);
			}
			g_ArrayBlockPlayer[pOther.entindex()].flLastBlockTime = g_Engine.time;
		}
		else
		{
			g_ArrayBlockPlayer[pOther.entindex()].flStartBlockTime = g_Engine.time;
			g_ArrayBlockPlayer[pOther.entindex()].flLastBlockTime = g_Engine.time;
			g_ArrayBlockPlayer[pOther.entindex()].IsBlocking = true;

			if(g_Engine.time > g_ArrayBlockPlayer[pOther.entindex()].flLastSoundTime + 1.0){
				g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szBlockSoundName, 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );
				g_ArrayBlockPlayer[pOther.entindex()].szPlayingSound = m_szBlockSoundName;
				g_ArrayBlockPlayer[pOther.entindex()].flLastSoundTime = g_Engine.time;
			}
		}

		if(m_flBlockOutForce > 0)
		{
			float flForce = CalcDynamicForce(m_flBlockOutForce);

			Vector vDir = pOther.pev.origin - self.pev.origin;
			vDir = vDir.Normalize();
			pOther.pev.velocity = vDir * flForce;

			if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()])
			{
				g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szHitSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

				pOther.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );

				g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
			}
		}

		if(m_flBlockUpForce > 0)
		{
			float flForce = CalcDynamicForce(m_flBlockUpForce);

			if(pOther.pev.velocity.z < flForce)
				pOther.pev.velocity.z = flForce;
		}
	}

	void NextThink(float thinkTime, const bool alwaysThink)
	{
		if (alwaysThink)
			self.pev.flags |= FL_ALWAYSTHINK;
		else
			self.pev.flags &= ~FL_ALWAYSTHINK;

		self.pev.nextthink = thinkTime;
	}

	void SUB_CallUseToggle()
	{
		self.Use(self, self, USE_ON, 0.0);
	}

	void Rotate()
	{
		NextThink(self.pev.ltime + 10.0, false);
		SetThink(ThinkFunction(this.Rotate));
	}

	void SpinUp()
	{
		NextThink(self.pev.ltime + 0.1, false);
		SetThink(ThinkFunction(this.SpinUp));

		self.pev.avelocity = self.pev.avelocity + (self.pev.movedir * (self.pev.speed * m_flFanFriction));

		Vector vecAVel = self.pev.avelocity;

		if (abs(vecAVel.x) >= abs(self.pev.movedir.x * self.pev.speed) &&
		 abs(vecAVel.y) >= abs(self.pev.movedir.y * self.pev.speed) &&
		 abs(vecAVel.z) >= abs(self.pev.movedir.z * self.pev.speed))
		{
			self.pev.avelocity = self.pev.movedir * self.pev.speed;

			SetThink(ThinkFunction(this.Rotate));
		}
	}

	void SpinDown()
	{
		NextThink(self.pev.ltime + 0.1, false);
		SetThink(ThinkFunction(this.SpinDown));

		self.pev.avelocity = self.pev.avelocity - (self.pev.movedir * (self.pev.speed * m_flFanFriction));

		Vector vecAVel = self.pev.avelocity;
		float vecdir = GetCurrentRotateDirection();

		if (((vecdir > 0.0) && (vecAVel.x <= 0.0 && vecAVel.y <= 0.0 && vecAVel.z <= 0.0)) || ((vecdir < 0.0) && (vecAVel.x >= 0.0 && vecAVel.y >= 0.0 && vecAVel.z >= 0.0)))
		{
			self.pev.avelocity = g_vecZero;
			SetThink(ThinkFunction(this.Rotate));
		}
	}

	void SpinDownToLowSpeed()
	{
		NextThink(self.pev.ltime + 0.1, false);
		SetThink(ThinkFunction(this.SpinDownToLowSpeed));

		self.pev.avelocity = self.pev.avelocity - (self.pev.movedir * (self.pev.speed * m_flFanFriction));

		Vector vecAVel = self.pev.avelocity;

		if (abs(vecAVel.x) <= abs(self.pev.movedir.x * self.pev.speed) &&
		 abs(vecAVel.y) <= abs(self.pev.movedir.y * self.pev.speed) &&
		 abs(vecAVel.z) <= abs(self.pev.movedir.z * self.pev.speed))
		{
			self.pev.avelocity = self.pev.movedir * self.pev.speed;

			SetThink(ThinkFunction(this.Rotate));
		}
	}
}

class CFuncDoorFg : ScriptBaseEntity
{
	float m_flWait = 0.0;
	float m_flLip = 0;
	Vector m_vecFinalDest;
	Vector m_vecPosition1;
	Vector m_vecPosition2;
	Vector m_vecInitialAngles;
	int m_toggle_state;
	bool m_bIsOnlyTrigger = false;
	
	float m_flBounceForce = 0.0;
	float m_flPushForce = 0.0;
	float m_flUpForce = 0.0;
	float m_flBlockPushForce = 0.0;
	float m_flBlockUpForce = 0.0;
	float m_flBlockCrushTime = 4.0;

	bool m_bIsSuperPusher = false;

	array<string> m_szBounceSoundName = {
		"fallguys/bounce.ogg",
		"fallguys/bounce2.ogg",
		"fallguys/bounce3.ogg"
	};

	array<string> m_szHitSoundName = {
		"fallguys/impact1.ogg",
		"fallguys/impact2.ogg",
		"fallguys/impact3.ogg"
	};
	
	string m_szBlockSoundName = "fallguys/mecha.ogg";

	void Precache()
	{
		BaseClass.Precache();

		g_SoundSystem.PrecacheSound( m_szBounceSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[2] );

		g_SoundSystem.PrecacheSound( m_szHitSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szHitSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szHitSoundName[2] );

		g_SoundSystem.PrecacheSound( m_szBlockSoundName );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		if(szKey == "lip"){
			m_flLip = atof(szValue);
			return true;
		}

		if(szKey == "wait"){
			m_flWait = atof(szValue);
			return true;
		}

		if(szKey == "bounceforce"){
			m_flBounceForce = atof(szValue);
			return true;
		}

		if(szKey == "pushforce"){
			m_flPushForce = atof(szValue);
			return true;
		}

		if(szKey == "upforce"){
			m_flUpForce = atof(szValue);
			return true;
		}

		if(szKey == "blockpushforce"){
			m_flBlockPushForce = atof(szValue);
			return true;
		}

		if(szKey == "blockupforce"){
			m_flBlockUpForce = atof(szValue);
			return true;
		}

		if(szKey == "hitsound0"){
			m_szHitSoundName[0] = szValue;
			return true;
		}

		if(szKey == "hitsound2"){
			m_szHitSoundName[1] = szValue;
			return true;
		}

		if(szKey == "hitsound2"){
			m_szHitSoundName[2] = szValue;
			return true;
		}

		if(szKey == "bouncesound0"){
			m_szBounceSoundName[0] = szValue;
			return true;
		}

		if(szKey == "bouncesound2"){
			m_szBounceSoundName[1] = szValue;
			return true;
		}

		if(szKey == "bouncesound2"){
			m_szBounceSoundName[2] = szValue;
			return true;
		}

		if(szKey == "blocksound"){
			m_szBlockSoundName = szValue;
			return true;
		}

		if(szKey == "blockcrushtime"){
			m_flBlockCrushTime = atof(szValue);
			return true;
		}

		if(szKey == "superpusher"){
			m_bIsSuperPusher = atoi(szValue) > 0 ? true : false;
			return true;
		}

		if(szKey == "onlytrigger"){
			m_bIsOnlyTrigger = atoi(szValue) > 0 ? true : false;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Restart()
	{
		self.pev.angles = m_vecInitialAngles;

		if (self.pev.angles == Vector(0, -1, 0))
		{
			self.pev.movedir = Vector(0, 0, 1);
		}
		else if (self.pev.angles == Vector(0, -2, 0))
		{
			self.pev.movedir = Vector(0, 0, -1);
		}
		else
		{
			Math.MakeVectors( self.pev.angles );
			self.pev.movedir = g_Engine.v_forward;
		}

		self.pev.angles = g_vecZero;

		if (self.pev.skin == 0)
		{
			if ((self.pev.spawnflags & SF_DOOR_PASSABLE) == SF_DOOR_PASSABLE)
				self.pev.solid = SOLID_NOT;
			else
				self.pev.solid = SOLID_BSP;
		}
		else
		{
			self.pev.solid = SOLID_NOT;
		}

		self.pev.movetype = MOVETYPE_PUSH;

		m_toggle_state = TS_AT_BOTTOM;
		DoorGoDown();
	}

	void Spawn()
	{
		Precache();

		m_vecInitialAngles = self.pev.angles;

		if (self.pev.angles == Vector(0, -1, 0))
		{
			self.pev.movedir = Vector(0, 0, 1);
		}
		else if (self.pev.angles == Vector(0, -2, 0))
		{
			self.pev.movedir = Vector(0, 0, -1);
		}
		else
		{
			Math.MakeVectors( self.pev.angles );
			self.pev.movedir = g_Engine.v_forward;
		}

		self.pev.angles = g_vecZero;

		if (self.pev.skin == 0)
		{
			if ((self.pev.spawnflags & SF_DOOR_PASSABLE) == SF_DOOR_PASSABLE)
				self.pev.solid = SOLID_NOT;
			else
				self.pev.solid = SOLID_BSP;
		}
		else
		{
			self.pev.solid = SOLID_NOT;
		}

		self.pev.movetype = MOVETYPE_PUSH;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		m_vecPosition1 = self.pev.origin;
		m_vecPosition2 = m_vecPosition1 + (self.pev.movedir * (abs(self.pev.movedir.x * (self.pev.size.x - 2)) + abs(self.pev.movedir.y * (self.pev.size.y - 2)) + abs(self.pev.movedir.z * (self.pev.size.z - 2)) - m_flLip));

		if ((self.pev.spawnflags & SF_DOOR_START_OPEN) == SF_DOOR_START_OPEN)
		{
			g_EntityFuncs.SetOrigin(self, m_vecPosition2);
			m_vecPosition2 = m_vecPosition1;
			m_vecPosition1 = self.pev.origin;
		}

		m_toggle_state = TS_AT_BOTTOM;

		if(m_bIsSuperPusher)
			g_EntityFuncs.SetEntitySuperPusher(self.edict(), true);
	}

	void Touch( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;

		if(!pOther.IsAlive())
			return;

		if ((self.pev.spawnflags & SF_DOOR_USE_ONLY) == 0 && !m_bIsOnlyTrigger && m_toggle_state == TS_AT_BOTTOM)
		{
			DoorActivate();
		}

		//not PM code, velocity works
		Vector vecSuperPusherPushingVector;
		if(g_EntityFuncs.GetCurrentSuperPusher(vecSuperPusherPushingVector) is self.edict())
		{
			if(m_flPushForce > 0.0)
			{
				Vector vDir = vecSuperPusherPushingVector;

				vDir = vDir.Normalize();
				
				pOther.pev.velocity = vDir * m_flPushForce;		

				if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

					if(m_flBounceForce > 0)
					{
						g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szBounceSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );
					}
					else
					{
						g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szHitSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );
						
						pOther.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );

						Vector vecImpactPosition2 = pOther.pev.origin - vDir * 16;

						EmitPlayerHitEffect(pOther, HitEffect_Large, vecImpactPosition2, vDir);
					}
					g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
				}
			}

			if(m_flUpForce > 0)
			{
				if(pOther.pev.velocity.z < m_flUpForce)
					pOther.pev.velocity.z = m_flUpForce;
			}

			return;
		}

		//PM code
		if(m_flBounceForce > 0)
		{
			if((pOther.pev.flags & FL_ONGROUND) == FL_ONGROUND && (pOther.pev.groundentity is self.edict() ))
			{

			}
			else
			{
				Vector vDiff = pOther.pev.origin - self.pev.origin;
				vDiff.z = 0;
				vDiff = vDiff.Normalize();

				g_ArrayBounceVelocityPlayer[pOther.entindex()] = vDiff * m_flBounceForce;

				if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

					g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szBounceSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

					g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
				}
			}
		}
	}

	void Blocked( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		if(g_ArrayBlockPlayer[pOther.entindex()].IsBlocking)
		{
			if(g_Engine.time > g_ArrayBlockPlayer[pOther.entindex()].flStartBlockTime + m_flBlockCrushTime)
			{
				pOther.TakeDamage(self.pev, self.pev, 999999, DMG_CRUSH);
			}
			g_ArrayBlockPlayer[pOther.entindex()].flLastBlockTime = g_Engine.time;
		}
		else
		{
			g_ArrayBlockPlayer[pOther.entindex()].flStartBlockTime = g_Engine.time;
			g_ArrayBlockPlayer[pOther.entindex()].flLastBlockTime = g_Engine.time;
			g_ArrayBlockPlayer[pOther.entindex()].IsBlocking = true;

			if(g_Engine.time > g_ArrayBlockPlayer[pOther.entindex()].flLastSoundTime + 1.0){
				g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szBlockSoundName, 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );
				g_ArrayBlockPlayer[pOther.entindex()].szPlayingSound = m_szBlockSoundName;
				g_ArrayBlockPlayer[pOther.entindex()].flLastSoundTime = g_Engine.time;
			}
		}

		if(m_flBlockPushForce > 0.0)
		{
			Vector vDir = pOther.pev.origin - self.pev.origin;
			vDir = vDir.Normalize();
			pOther.pev.velocity = vDir * m_flBlockPushForce;

			if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

				g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szHitSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

				pOther.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );

				g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
			}
		}

		if(m_flBlockUpForce > 0)
		{
			if(pOther.pev.velocity.z < m_flBlockUpForce)
				pOther.pev.velocity.z = m_flBlockUpForce;
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if (useType == USE_TOGGLE)
		{
			if(m_bIsOnlyTrigger && pCaller.IsPlayer())
				return;

			if (m_toggle_state == TS_AT_BOTTOM || ((self.pev.spawnflags & SF_DOOR_NO_AUTO_RETURN) == SF_DOOR_NO_AUTO_RETURN && m_toggle_state == TS_AT_TOP))
				DoorActivate();
		}
		else if (useType == USE_ON)
		{
			
		}
		else if (useType == USE_OFF)
		{
			
		}
		else if (useType == USE_SET)
		{
			if(flValue < 0)
			{
				Restart();
				return;
			}
		}
	}

	void DoorActivate()
	{
		if ((self.pev.spawnflags & SF_DOOR_NO_AUTO_RETURN) == SF_DOOR_NO_AUTO_RETURN && m_toggle_state == TS_AT_TOP)
		{
			DoorGoDown();
		}
		else
		{
			DoorGoUp();
		}
	}

	void NextThink(float thinkTime, const bool alwaysThink)
	{
		if (alwaysThink)
			self.pev.flags |= FL_ALWAYSTHINK;
		else
			self.pev.flags &= ~FL_ALWAYSTHINK;

		self.pev.nextthink = thinkTime;
	}

	void DoorGoDown(void)
	{
		m_toggle_state = TS_GOING_DOWN;

		LinearMove(m_vecPosition1, self.pev.speed);
	}

	void DoorGoUp(void)
	{
		bool isReversing = (m_toggle_state == TS_GOING_DOWN) ? true : false;

		m_toggle_state = TS_GOING_UP;

		LinearMove(m_vecPosition2, self.pev.speed);
	}

	void LinearMove(Vector vecDest, float flSpeed)
	{
		m_vecFinalDest = vecDest;

		if (vecDest == self.pev.origin)
		{
			LinearMoveDone();
			return;
		}

		Vector vecDestDelta = vecDest - self.pev.origin;
		float flTravelTime = vecDestDelta.Length() / flSpeed;
		NextThink( self.pev.ltime + flTravelTime, false );
		SetThink( ThinkFunction( this.LinearMoveDone ) );
		self.pev.velocity = vecDestDelta / flTravelTime;
	}

	void LinearMoveDone()
	{
		g_EntityFuncs.SetOrigin(self, m_vecFinalDest);
		self.pev.velocity = g_vecZero;
		self.pev.nextthink = -1;

		if(m_toggle_state == TS_GOING_UP)
		{
			m_toggle_state = TS_AT_TOP;

			if ((self.pev.spawnflags & SF_DOOR_NO_AUTO_RETURN) == SF_DOOR_NO_AUTO_RETURN)
			{
				
			}
			else
			{	
				NextThink(m_flWait, false);
				SetThink(ThinkFunction(this.DoorGoDown));

				if (m_flWait == -1)
					self.pev.nextthink = -1;
			}

			if (!string(self.pev.netname).IsEmpty() && (self.pev.spawnflags & SF_DOOR_START_OPEN) == 0)
				g_EntityFuncs.FireTargets(string(self.pev.netname), self, self, USE_TOGGLE, 0);
		}
		else if(m_toggle_state == TS_GOING_UP)
		{
			m_toggle_state = TS_GOING_DOWN;

			if (!string(self.pev.netname).IsEmpty() && (self.pev.spawnflags & SF_DOOR_START_OPEN) == 0)
				g_EntityFuncs.FireTargets(string(self.pev.netname), self, self, USE_TOGGLE, 0);
		}
	}
}

class CFuncTrainFg : ScriptBaseEntity
{
	float m_flWait = 0.0;
	Vector m_vecFinalDest;
	Vector m_vecSaveOrigin;
	CBaseEntity @m_pSaveTarget = null;
	CBaseEntity @m_pCurrentTarget = null;
	float m_flInitialSpeed = 0;
	string m_szInitialTarget = "";
	int m_iInitialSpawnFlags = 0;
	bool m_activated = false;
	
	float m_flBounceForce = 0.0;
	float m_flPushForce = 0.0;
	float m_flUpForce = 0.0;
	float m_flBlockPushForce = 0.0;
	float m_flBlockUpForce = 0.0;
	float m_flBlockCrushTime = 4.0;

	bool m_bIsSuperPusher = false;

	array<string> m_szBounceSoundName = {
		"fallguys/bounce.ogg",
		"fallguys/bounce2.ogg",
		"fallguys/bounce3.ogg"
	};

	array<string> m_szHitSoundName = {
		"fallguys/impact1.ogg",
		"fallguys/impact2.ogg",
		"fallguys/impact3.ogg"
	};
	
	string m_szBlockSoundName = "fallguys/mecha.ogg";

	void Precache()
	{
		BaseClass.Precache();

		g_SoundSystem.PrecacheSound( m_szBounceSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[2] );

		g_SoundSystem.PrecacheSound( m_szHitSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szHitSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szHitSoundName[2] );

		g_SoundSystem.PrecacheSound( m_szBlockSoundName );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{		
		if(szKey == "wait"){
			m_flWait = atof(szValue);
			return true;
		}

		if(szKey == "bounceforce"){
			m_flBounceForce = atof(szValue);
			return true;
		}

		if(szKey == "pushforce"){
			m_flPushForce = atof(szValue);
			return true;
		}

		if(szKey == "upforce"){
			m_flUpForce = atof(szValue);
			return true;
		}

		if(szKey == "blockpushforce"){
			m_flBlockPushForce = atof(szValue);
			return true;
		}

		if(szKey == "blockupforce"){
			m_flBlockUpForce = atof(szValue);
			return true;
		}

		if(szKey == "hitsound0"){
			m_szHitSoundName[0] = szValue;
			return true;
		}

		if(szKey == "hitsound2"){
			m_szHitSoundName[1] = szValue;
			return true;
		}

		if(szKey == "hitsound2"){
			m_szHitSoundName[2] = szValue;
			return true;
		}

		if(szKey == "bouncesound0"){
			m_szBounceSoundName[0] = szValue;
			return true;
		}

		if(szKey == "bouncesound2"){
			m_szBounceSoundName[1] = szValue;
			return true;
		}

		if(szKey == "bouncesound2"){
			m_szBounceSoundName[2] = szValue;
			return true;
		}

		if(szKey == "blocksound"){
			m_szBlockSoundName = szValue;
			return true;
		}

		if(szKey == "blockcrushtime"){
			m_flBlockCrushTime = atof(szValue);
			return true;
		}

		if(szKey == "superpusher"){
			m_bIsSuperPusher = atoi(szValue) > 0 ? true : false;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Restart()
	{
		self.pev.speed = m_flInitialSpeed;
		self.pev.movetype = MOVETYPE_PUSH;
		self.pev.spawnflags = m_iInitialSpawnFlags;

		if ((self.pev.spawnflags & SF_TRAIN_PASSABLE) == SF_TRAIN_PASSABLE)
			self.pev.solid = SOLID_NOT;
		else
			self.pev.solid = SOLID_BSP;

		if(!m_szInitialTarget.IsEmpty())
			self.pev.target = m_szInitialTarget;

		@m_pCurrentTarget = @m_pSaveTarget;

		g_EntityFuncs.SetOrigin(self, m_vecSaveOrigin);

		self.pev.nextthink = 0;
		self.pev.velocity = g_vecZero;

		m_activated = false;

		Activate();
	}

	void Spawn()
	{
		Precache();

		if (self.pev.speed == 0)
			self.pev.speed = 100;

		m_flInitialSpeed = self.pev.speed;
		m_szInitialTarget = string(self.pev.target);
		m_iInitialSpawnFlags = self.pev.spawnflags;

		if (string(self.pev.target).IsEmpty())
			g_Game.AlertMessage( at_console, "FuncTrain %1 with no target", string(self.pev.targetname));

		if(m_pSaveTarget is null){
			@m_pSaveTarget = @m_pCurrentTarget;
		} else {
			@m_pCurrentTarget = @m_pSaveTarget;
		}

		if(m_vecSaveOrigin == g_vecZero){
			m_vecSaveOrigin = self.pev.origin;
		} else {
			self.pev.origin = m_vecSaveOrigin;
		}

		self.pev.movetype = MOVETYPE_PUSH;

		if ((self.pev.spawnflags & SF_TRAIN_PASSABLE) == SF_TRAIN_PASSABLE)
			self.pev.solid = SOLID_NOT;
		else
			self.pev.solid = SOLID_BSP;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		m_activated = false;

		if(m_bIsSuperPusher)
			g_EntityFuncs.SetEntitySuperPusher(self.edict(), true);
	}

	void Touch( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;

		if(!pOther.IsAlive())
			return;

		//not PM code, velocity works
		Vector vecSuperPusherPushingVector;
		if(g_EntityFuncs.GetCurrentSuperPusher(vecSuperPusherPushingVector) is self.edict())
		{
			if(m_flPushForce > 0.0)
			{
				Vector vDir = vecSuperPusherPushingVector;

				vDir = vDir.Normalize();
				
				pOther.pev.velocity = vDir * m_flPushForce;		

				if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

					if(m_flBounceForce > 0)
					{
						g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szBounceSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );
					}
					else
					{
						g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szHitSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );
						
						pOther.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );
						
						Vector vecImpactPosition2 = pOther.pev.origin - vDir * 16;

						EmitPlayerHitEffect(pOther, HitEffect_Large, vecImpactPosition2, vDir);
					}
					g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
				}
			}

			if(m_flUpForce > 0)
			{
				if(pOther.pev.velocity.z < m_flUpForce)
					pOther.pev.velocity.z = m_flUpForce;
			}

			return;
		}

		//PM code
		if(m_flBounceForce > 0)
		{
			if((pOther.pev.flags & FL_ONGROUND) == FL_ONGROUND && (pOther.pev.groundentity is self.edict() ))
			{

			}
			else
			{
				Vector vDiff = pOther.pev.origin - self.pev.origin;
				vDiff.z = 0;
				vDiff = vDiff.Normalize();

				g_ArrayBounceVelocityPlayer[pOther.entindex()] = vDiff * m_flBounceForce;

				if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

					g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szBounceSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

					g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
				}
			}
		}
	}

	void Blocked( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		if(g_ArrayBlockPlayer[pOther.entindex()].IsBlocking)
		{
			if(g_Engine.time > g_ArrayBlockPlayer[pOther.entindex()].flStartBlockTime + m_flBlockCrushTime)
			{
				pOther.TakeDamage(self.pev, self.pev, 999999, DMG_CRUSH);
			}
			g_ArrayBlockPlayer[pOther.entindex()].flLastBlockTime = g_Engine.time;
		}
		else
		{
			g_ArrayBlockPlayer[pOther.entindex()].flStartBlockTime = g_Engine.time;
			g_ArrayBlockPlayer[pOther.entindex()].flLastBlockTime = g_Engine.time;
			g_ArrayBlockPlayer[pOther.entindex()].IsBlocking = true;

			if(g_Engine.time > g_ArrayBlockPlayer[pOther.entindex()].flLastSoundTime + 1.0){
				g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szBlockSoundName, 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );
				g_ArrayBlockPlayer[pOther.entindex()].szPlayingSound = m_szBlockSoundName;
				g_ArrayBlockPlayer[pOther.entindex()].flLastSoundTime = g_Engine.time;
			}
		}

		if(m_flBlockPushForce > 0.0)
		{
			Vector vDir = pOther.pev.origin - self.pev.origin;
			vDir = vDir.Normalize();
			pOther.pev.velocity = vDir * m_flBlockPushForce;

			if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

				g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szHitSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

				pOther.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );

				g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
			}
		}

		if(m_flBlockUpForce > 0)
		{
			if(pOther.pev.velocity.z < m_flBlockUpForce)
				pOther.pev.velocity.z = m_flBlockUpForce;
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if (useType == USE_TOGGLE)
		{
			if ((self.pev.spawnflags & SF_TRAIN_WAIT_RETRIGGER) == SF_TRAIN_WAIT_RETRIGGER)
			{
				self.pev.spawnflags &= ~SF_TRAIN_WAIT_RETRIGGER;
				Next();
			}
			else
			{
				self.pev.spawnflags |= SF_TRAIN_WAIT_RETRIGGER;

				if (m_pCurrentTarget !is null)
				{
					self.pev.target = m_pCurrentTarget.pev.targetname;
				}

				self.pev.nextthink = 0;
				self.pev.velocity = g_vecZero;
			}
		}
		else if (useType == USE_ON)
		{
			Next();
		}
		else if (useType == USE_OFF)
		{
			self.pev.nextthink = 0;
			self.pev.velocity = g_vecZero;
		}
		else if (useType == USE_SET)
		{
			if(flValue < 0)
			{
				Restart();
				return;
			}
		}
	}

	void NextThink(float thinkTime, const bool alwaysThink)
	{
		if (alwaysThink)
			self.pev.flags |= FL_ALWAYSTHINK;
		else
			self.pev.flags &= ~FL_ALWAYSTHINK;

		self.pev.nextthink = thinkTime;
	}

	void Activate()
	{
		if (!m_activated)
		{
			m_activated = true;
			
			if(string(self.pev.target).IsEmpty())
				return;

			CBaseEntity @pTarget = g_EntityFuncs.FindEntityByTargetname( null, self.pev.target );

			if(pTarget is null)
				return;

			self.pev.target = pTarget.pev.target;
			@m_pCurrentTarget = @pTarget;
			g_EntityFuncs.SetOrigin(self, pTarget.pev.origin - (self.pev.mins + self.pev.maxs) * 0.5);

			if (string(self.pev.targetname).IsEmpty())
			{
				NextThink( self.pev.ltime + 0.1, false );
				SetThink( ThinkFunction( this.Next ) );
			}
			else
			{
				self.pev.spawnflags |= SF_TRAIN_WAIT_RETRIGGER;
			}
		}
	}

	void Wait()
	{
		if(m_pCurrentTarget is null)
			return;

		if (!string(m_pCurrentTarget.pev.message).IsEmpty())
		{
			//g_Game.AlertMessage(at_aiconsole, "Train %1 fire %2\n", string(self.pev.targetname), string(m_pCurrentTarget.pev.message));

			g_EntityFuncs.FireTargets( string(m_pCurrentTarget.pev.message), self, self, USE_TOGGLE, 0 );

			if ((m_pCurrentTarget.pev.spawnflags & SF_CORNER_FIREONCE) == SF_CORNER_FIREONCE)
				m_pCurrentTarget.pev.message = 0;
		}

		if ((m_pCurrentTarget.pev.spawnflags & SF_TRAIN_WAIT_RETRIGGER) == SF_TRAIN_WAIT_RETRIGGER || 
				(self.pev.spawnflags & SF_TRAIN_WAIT_RETRIGGER) == SF_TRAIN_WAIT_RETRIGGER)
		{
			self.pev.spawnflags |= SF_TRAIN_WAIT_RETRIGGER;

			self.pev.nextthink = 0;
			return;
		}

		if (m_flWait != 0)
		{
			NextThink( self.pev.ltime + m_flWait, false );
			SetThink( ThinkFunction( this.Next ) );
		}
		else
		{
			Next();
		}
	}

	void Next()
	{
		CBaseEntity @pTarget = self.GetNextTarget();

		if (pTarget is null)
		{
			return;
		}

		self.pev.message = self.pev.target;
		self.pev.target = pTarget.pev.target;
		m_flWait = pTarget.GetDelay();

		if (m_pCurrentTarget !is null && m_pCurrentTarget.pev.speed != 0)
		{
			self.pev.speed = m_pCurrentTarget.pev.speed;
			//g_Game.AlertMessage(at_aiconsole, "Train %1 speed to %2\n", string(self.pev.targetname), self.pev.speed);
		}

		@m_pCurrentTarget = @pTarget;

		if ((m_pCurrentTarget.pev.spawnflags & SF_CORNER_TELEPORT) == SF_CORNER_TELEPORT)
		{
			self.pev.effects |= EF_NOINTERP;
			g_EntityFuncs.SetOrigin(self, pTarget.pev.origin - (self.pev.mins + self.pev.maxs) * 0.5);
			Wait();
		}
		else
		{
			self.pev.effects &= ~EF_NOINTERP;
			LinearMove(pTarget.pev.origin - (self.pev.mins + self.pev.maxs) * 0.5, self.pev.speed);
		}
	}

	void LinearMove(Vector vecDest, float flSpeed)
	{
		m_vecFinalDest = vecDest;

		if (vecDest == self.pev.origin)
		{
			LinearMoveDone();
			return;
		}

		Vector vecDestDelta = vecDest - self.pev.origin;
		float flTravelTime = vecDestDelta.Length() / flSpeed;
		NextThink( self.pev.ltime + flTravelTime, false );
		SetThink( ThinkFunction( this.LinearMoveDone ) );
		self.pev.velocity = vecDestDelta / flTravelTime;
	}

	void LinearMoveDone()
	{
		g_EntityFuncs.SetOrigin(self, m_vecFinalDest);
		self.pev.velocity = g_vecZero;
		self.pev.nextthink = -1;

		Wait();
	}
}

class CFuncTrackTrainFg : ScriptBaseEntity
{
	CPathTrack@ m_ppath = null;
	float m_length = 0.0;
	float m_height = 0.0;
	float m_speed = 0.0;
	float m_dir = 0.0;
	float m_startSpeed = 0.0;
	float m_flBank = 0.0;
	float m_oldSpeed = 0.0;

	//for restart
	float m_flInitialSpeed = 0.0;
	string m_szInitialTarget = "";
	
	float m_flPushForce = 0.0;
	float m_flUpForce = 0.0;
	float m_flBlockPushForce = 0.0;
	float m_flBlockUpForce = 0.0;
	float m_flBlockCrushTime = 4.0;

	bool m_bIsSuperPusher = false;

	array<string> m_szHitSoundName = {
		"fallguys/impact1.ogg",
		"fallguys/impact2.ogg",
		"fallguys/impact3.ogg"
	};
	
	string m_szBlockSoundName = "fallguys/mecha.ogg";

	void Precache()
	{
		BaseClass.Precache();

		g_SoundSystem.PrecacheSound( m_szHitSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szHitSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szHitSoundName[2] );

		g_SoundSystem.PrecacheSound( m_szBlockSoundName );
	}

	void Restart()
	{
		//g_Game.AlertMessage( at_console, "TRACKTRAIN (%1) restart", string(self.pev.targetname) );

		self.pev.speed = 0;
		self.pev.velocity = g_vecZero;
		self.pev.avelocity = g_vecZero;
		self.pev.impulse = int(m_speed);
		m_dir = 1;

		self.pev.target = m_szInitialTarget;

		if ( string(self.pev.target).IsEmpty() )
			g_Game.AlertMessage( at_console, "TRACKTRAIN (%1) has no target", string(self.pev.targetname) );

		g_EntityFuncs.SetOrigin(self, self.pev.oldorigin);
		NextThink( self.pev.ltime + 0.1, false );
		SetThink( ThinkFunction( this.Find ) );
	}

	void Spawn()
	{
		if (self.pev.speed == 0)
			m_speed = 165;
		else
			m_speed = self.pev.speed;

		m_flInitialSpeed = m_speed;

		self.pev.speed = 0;
		self.pev.velocity = g_vecZero;
		self.pev.avelocity = g_vecZero;
		self.pev.impulse = int(m_speed);
		m_dir = 1;

		if ( string(self.pev.target).IsEmpty() )
			g_Game.AlertMessage( at_console, "TRACKTRAIN (%1) has no target", string(self.pev.targetname) );

		m_szInitialTarget = string(self.pev.target);

		if ( ( self.pev.spawnflags & SF_TRACKTRAIN_PASSABLE ) != 0 )
			self.pev.solid = SOLID_NOT;
		else
			self.pev.solid = SOLID_BSP;
	
		self.pev.movetype = MOVETYPE_PUSH;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		self.pev.oldorigin = self.pev.origin;

		NextThink( self.pev.ltime + 0.1, false );
		SetThink( ThinkFunction( this.Find ) );
		Precache();

		if(m_bIsSuperPusher)
			g_EntityFuncs.SetEntitySuperPusher(self.edict(), true);
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "wheels"){
			m_length = atof(szValue);
			return true;
		}
		
		if(szKey == "height"){
			m_height = atof(szValue);
			return true;
		}

		if(szKey == "startspeed"){
			m_startSpeed = atof(szValue);
			return true;
		}
			
		if(szKey == "bank"){
			m_flBank = atof(szValue);
			return true;
		}

		if(szKey == "pushforce"){
			m_flPushForce = atof(szValue);
			return true;
		}

		if(szKey == "upforce"){
			m_flUpForce = atof(szValue);
			return true;
		}

		if(szKey == "blockpushforce"){
			m_flBlockPushForce = atof(szValue);
			return true;
		}

		if(szKey == "blockupforce"){
			m_flBlockUpForce = atof(szValue);
			return true;
		}

		if(szKey == "blockcrushtime"){
			m_flBlockCrushTime = atof(szValue);
			return true;
		}

		if(szKey == "hitsound0"){
			m_szHitSoundName[0] = szValue;
			return true;
		}

		if(szKey == "hitsound2"){
			m_szHitSoundName[1] = szValue;
			return true;
		}

		if(szKey == "hitsound2"){
			m_szHitSoundName[2] = szValue;
			return true;
		}

		if(szKey == "blocksound"){
			m_szBlockSoundName = szValue;
			return true;
		}

		if(szKey == "blockcrushtime"){
			m_flBlockCrushTime = atof(szValue);
			return true;
		}

		if(szKey == "superpusher"){
			m_bIsSuperPusher = atoi(szValue) > 0 ? true : false;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if (useType == USE_ON)
		{
			if (self.pev.speed == 0)
			{
				self.pev.speed = m_speed * m_dir;
				Next();
			}
		}
		else if (useType == USE_OFF)
		{
			if (self.pev.speed == 0)
			{

			}
			else
			{
				self.pev.speed = 0;
				self.pev.velocity = g_vecZero;
				self.pev.avelocity = g_vecZero;
				SetThink(null);
			}
		}
		else if (useType == USE_TOGGLE)
		{
			if (!self.ShouldToggle(useType, (self.pev.speed != 0)))
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
				SetThink(null);
			}
		}
		else if (useType == USE_SET)
		{
			if(flValue < 0)
			{
				Restart();
				return;
			}

			float delta = flValue;
			delta = (int(self.pev.speed * 4) / int(m_speed)) * 0.25 + 0.25 * delta;

			if (delta > 1)
				delta = 1;
			else if (delta < -1)
				delta = -1;

			if ((self.pev.spawnflags & SF_TRACKTRAIN_FORWARDONLY) == SF_TRACKTRAIN_FORWARDONLY)
			{
				if (delta < 0)
					delta = 0;
			}

			self.pev.speed = m_speed * delta;

			Next();

			//g_Game.AlertMessage(at_aiconsole, "TRACKTRAIN (%1): change speed to %2\n", string(self.pev.targetname), self.pev.speed);
		}
	}

	void Touch( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		//Not PM code
		Vector vecSuperPusherPushingVector;
		if(g_EntityFuncs.GetCurrentSuperPusher(vecSuperPusherPushingVector) is self.edict())
		{
			if(m_flPushForce > 0)
			{
				Vector vDir = vecSuperPusherPushingVector;
				
				vDir = vDir.Normalize();

				pOther.pev.velocity = vDir * m_flPushForce;		

				if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

					g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szHitSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

					pOther.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );

					g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
				}
			}

			if(m_flUpForce > 0)
			{
				if(pOther.pev.velocity.z < m_flUpForce)
					pOther.pev.velocity.z = m_flUpForce;
			}
		}
	}

	void Blocked( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		if(g_ArrayBlockPlayer[pOther.entindex()].IsBlocking)
		{
			if(g_Engine.time > g_ArrayBlockPlayer[pOther.entindex()].flStartBlockTime + m_flBlockCrushTime)
			{
				pOther.TakeDamage(self.pev, self.pev, 999999, DMG_CRUSH);
			}
			g_ArrayBlockPlayer[pOther.entindex()].flLastBlockTime = g_Engine.time;
		}
		else
		{
			g_ArrayBlockPlayer[pOther.entindex()].flStartBlockTime = g_Engine.time;
			g_ArrayBlockPlayer[pOther.entindex()].flLastBlockTime = g_Engine.time;
			g_ArrayBlockPlayer[pOther.entindex()].IsBlocking = true;

			if(g_Engine.time > g_ArrayBlockPlayer[pOther.entindex()].flLastSoundTime + 1.0){
				g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szBlockSoundName, 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );
				g_ArrayBlockPlayer[pOther.entindex()].szPlayingSound = m_szBlockSoundName;
				g_ArrayBlockPlayer[pOther.entindex()].flLastSoundTime = g_Engine.time;
			}
		}

		if(m_flBlockPushForce > 0.0)
		{
			Vector vDir = pOther.pev.origin - self.pev.origin;
			vDir = vDir.Normalize();
			pOther.pev.velocity = vDir * m_flBlockPushForce;

			if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

				g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szHitSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

				pOther.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );

				g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
			}
		}

		if(m_flBlockUpForce > 0)
		{
			if(pOther.pev.velocity.z < m_flBlockUpForce)
				pOther.pev.velocity.z = m_flBlockUpForce;
		}
	}

	void NextThink(float thinkTime, const bool alwaysThink)
	{
		if (alwaysThink)
			self.pev.flags |= FL_ALWAYSTHINK;
		else
			self.pev.flags &= ~FL_ALWAYSTHINK;

		self.pev.nextthink = thinkTime;
	}

	void SUB_CallUseToggle()
	{
		self.Use(self, self, USE_ON, 0.0);
	}

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

	void Next()
	{
		float time = 0.5;

		if (self.pev.speed == 0.0)
		{
			g_Game.AlertMessage( at_aiconsole, "TRACKTRAIN(%1): Speed is 0\n", string(self.pev.targetname));
			return;
		}

		if (m_ppath is null)
		{
			g_Game.AlertMessage( at_aiconsole, "TRACKTRAIN(%1): Lost path\n", string(self.pev.targetname));
			return;
		}

		Vector nextPos = self.pev.origin;
		nextPos.z -= m_height;
		CPathTrack@ pnext = m_ppath.LookAhead(nextPos, nextPos, self.pev.speed * 0.1, true);
		nextPos.z += m_height;

		self.pev.velocity = (nextPos - self.pev.origin) * 10;
		Vector nextFront = self.pev.origin;
		nextFront.z -= m_height;

		if (m_length > 0)
			m_ppath.LookAhead(nextFront, nextFront, m_length, false);
		else
			m_ppath.LookAhead(nextFront, nextFront, 100, false);

		nextFront.z += m_height;

		Vector delta = nextFront - self.pev.origin;
		Vector angles = Math.VecToAngles(delta);
		angles.y += 180;

		angles = FixupAngles( angles );
		self.pev.angles = FixupAngles( self.pev.angles );

		if ( pnext is null || (delta.x == 0 && delta.y == 0) )
			angles = self.pev.angles;

		float vy, vx;

		if ((self.pev.spawnflags & SF_TRACKTRAIN_NOPITCH) == 0)
			vx = Math.AngleDistance(angles.x, self.pev.angles.x);
		else
			vx = 0;

		vy = Math.AngleDistance(angles.y, self.pev.angles.y);
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
			if (pnext != m_ppath)
			{
				CPathTrack@ pFire = (self.pev.speed >= 0) ? pnext : m_ppath;
				@m_ppath = pnext;

				if ( !string( pFire.pev.message ).IsEmpty() )
				{
					g_EntityFuncs.FireTargets( string(pFire.pev.message), self, self, USE_TOGGLE, 0 );

					if ((pFire.pev.spawnflags & SF_PATH_FIREONCE) == SF_PATH_FIREONCE)
						pFire.pev.message = 0;
				}

				if ((pFire.pev.spawnflags & SF_PATH_DISABLE_TRAIN) == SF_PATH_DISABLE_TRAIN)
					self.pev.spawnflags |= SF_TRACKTRAIN_NOCONTROL;

				if ((self.pev.spawnflags & SF_TRACKTRAIN_NOCONTROL) == SF_TRACKTRAIN_NOCONTROL)
				{
					if ( pFire.pev.speed != 0 )
					{
						self.pev.speed = pFire.pev.speed;
						g_Game.AlertMessage( at_aiconsole, "TRACKTRAIN (%1) change speed to %2\n", string(self.pev.targetname), self.pev.speed);
					}
				}
			}

			SetThink( ThinkFunction( this.Next ) );
			NextThink( self.pev.ltime + time, true );
		}
		else
		{
			self.pev.velocity = (nextPos - self.pev.origin);
			self.pev.avelocity = g_vecZero;

			float distance = self.pev.velocity.Length();
			m_oldSpeed = self.pev.speed;
			self.pev.speed = 0;

			if (distance > 0)
			{
				time = distance / m_oldSpeed;
				self.pev.velocity = self.pev.velocity * (m_oldSpeed / distance);
				SetThink( ThinkFunction( this.DeadEnd ) );
				NextThink( self.pev.ltime + time, false );
			}
			else
				DeadEnd();
		}
	}

	void DeadEnd()
	{
		CPathTrack@ pTrack = m_ppath;

		g_Game.AlertMessage( at_aiconsole, "TRACKTRAIN (%1) dead end\n", string(self.pev.targetname) );

		if ( pTrack !is null )
		{
			CPathTrack@ pNext = null;

			if (m_oldSpeed < 0)
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

		self.pev.velocity = g_vecZero;
		self.pev.avelocity = g_vecZero;

		if ( pTrack !is null )
		{
			g_Game.AlertMessage(at_aiconsole, "TRACKTRAIN (%1) dead end\n", string(pTrack.pev.targetname));

			if ( !string( pTrack.pev.netname ).IsEmpty() )
				g_EntityFuncs.FireTargets(string(pTrack.pev.netname), self, self, USE_TOGGLE, 0 );
		}
	}

	void Find()
	{
		@m_ppath = cast<CPathTrack@>( g_EntityFuncs.FindEntityByTargetname( null, self.pev.target ) );

		if ( m_ppath is null ){
			g_Game.AlertMessage( at_error,  "TRACKTRAIN (%1) found no target\n", string(self.pev.targetname) );
			return;
		}

		entvars_t@ pevTarget = m_ppath.pev;

		if (!pevTarget.ClassNameIs( "path_track" ))
		{
			g_Game.AlertMessage( at_error,  "TRACKTRAIN (%1) must be on a path of path_track\n", string(self.pev.targetname) );
			@m_ppath = null;
			return;
		}

		Vector nextPos = pevTarget.origin;
		nextPos.z += m_height;

		Vector look = nextPos;
		look.z -= m_height;
		m_ppath.LookAhead( look, look, m_length, false );
		look.z += m_height;

		self.pev.angles = Math.VecToAngles( look - nextPos );
		self.pev.angles.y += 180;

		if ( ( self.pev.spawnflags & SF_TRACKTRAIN_NOPITCH ) != 0 )
			self.pev.angles.x = 0;

		g_EntityFuncs.SetOrigin(self, nextPos);
		NextThink( self.pev.ltime + 0.1, false );
		SetThink( ThinkFunction( this.Next ) );
		self.pev.speed = m_startSpeed;
	}

	void NearestPath()
	{
		CBaseEntity@ pTrack = null;
		CBaseEntity@ pNearest = null;
		float closest = 1024;

		while ((@pTrack = @g_EntityFuncs.FindEntityInSphere( pTrack, self.pev.origin, 1024 )) !is null)
		{
			if ( ( pTrack.pev.flags & (FL_CLIENT|FL_MONSTER) ) == 0 && pTrack.pev.ClassNameIs( "path_track" ) )
			{
				float dist = (self.pev.origin - pTrack.pev.origin).Length();

				if (dist < closest)
				{
					closest = dist;
					@pNearest = @pTrack;
				}
			}
		}

		if (pNearest is null)
		{
			g_Game.AlertMessage(at_console, "TRACKTRAIN (%1): Can't find a nearby track !!!\n", string(self.pev.targetname));
			SetThink( null );
			return;
		}

		g_Game.AlertMessage(at_aiconsole, "TRACKTRAIN (%1), Nearest track is %2\n", string(self.pev.targetname), string(pNearest.pev.targetname));

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
}

class CFuncTurnstile : ScriptBaseEntity
{
	float m_flInertia = 1.0;
	float m_flDamping = 0.9;
	array<int> m_PushState(33);
	array<Vector> m_PushForce(33);
	array<Vector> m_PushPlaneNormal(33);
	array<Vector> m_PushPlanePos(33);

	array<string> m_szStartSpinSoundName = {
		"fallguys/turnstilestart1.ogg",
		"fallguys/turnstilestart2.ogg",
		"fallguys/turnstilestart3.ogg"
	};

	array<string> m_szStopSpinSoundName = {
		"fallguys/turnstilestop1.ogg",
		"fallguys/turnstilestop2.ogg",
		"fallguys/turnstilestop3.ogg"
	};

	bool m_bLastSpinState = false;
	float m_flLastSpinTime = 0;

	void Precache()
	{
		BaseClass.Precache();
		
		g_SoundSystem.PrecacheSound( m_szStartSpinSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szStartSpinSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szStartSpinSoundName[2] );

		g_SoundSystem.PrecacheSound( m_szStopSpinSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szStopSpinSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szStopSpinSoundName[2] );
	}

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_BSP;
		self.pev.movetype = MOVETYPE_PUSH;

		self.pev.movedir = Vector(0, 1, 0);

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		NextThink(self.pev.ltime + 0.1, false);
		SetThink(ThinkFunction(this.Spin));
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "inertia"){
			m_flInertia = atof(szValue);
			return true;
		}
		if(szKey == "damping"){
			m_flDamping = atof(szValue);
			return true;
		}

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

	void Touch( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		int playerIndex = pOther.entindex();

		if(g_EngineFuncs.GetRunPlayerMovePlayerIndex() == playerIndex)
		{
			//PM code, velocity not work
			if((pOther.pev.flags & FL_ONGROUND) == FL_ONGROUND && (pOther.pev.groundentity is self.edict() ))
			{
				//Stand on top of turnstile?
			}
			else
			{
				//g_Game.AlertMessage( at_console, "Found %1 pushing me, vel (%2, %3, %4), norm (%5, %6, %7)\n", 
				//pOther.pev.netname, 
				//pOther.pev.velocity.x, pOther.pev.velocity.y, pOther.pev.velocity.z,
				//g_Engine.trace_plane_normal.x, g_Engine.trace_plane_normal.y, g_Engine.trace_plane_normal.z );
				m_PushState[playerIndex] = 1;
				m_PushForce[playerIndex] = pOther.pev.velocity;
				m_PushPlaneNormal[playerIndex] = g_Engine.trace_plane_normal;
				m_PushPlanePos[playerIndex] = g_Engine.trace_endpos;
			}
		}
	}

	void AngleMatrix (Vector angles, array<float>@ matrix )
	{
		const float M_PI	=	3.14159265358979323846;
		float		angle;
		float		sr, sp, sy, cr, cp, cy;
		
		angle = angles.y * (M_PI*2.0 / 360.0);
		sy = sin(angle);
		cy = cos(angle);
		angle = angles.x * (M_PI*2.0 / 360.0);
		sp = sin(angle);
		cp = cos(angle);
		angle = angles.z * (M_PI*2.0 / 360.0);
		sr = sin(angle);
		cr = cos(angle);

		// matrix = (Z * Y) * X
		matrix[0* 4 + 0] = cp*cy;
		matrix[1* 4 + 0] = cp*sy;
		matrix[2* 4 + 0] = -sp;
		matrix[0* 4 + 1] = sr*sp*cy+cr*-sy;
		matrix[1* 4 + 1] = sr*sp*sy+cr*cy;
		matrix[2* 4 + 1] = sr*cp;
		matrix[0* 4 + 2] = (cr*sp*cy+-sr*-sy);
		matrix[1* 4 + 2] = (cr*sp*sy+-sr*cy);
		matrix[2* 4 + 2] = cr*cp;
		matrix[0* 4 + 3] = 0.0;
		matrix[1* 4 + 3] = 0.0;
		matrix[2* 4 + 3] = 0.0;
	}

	Vector VectorTransform(Vector in1, array<float>@ matrix)
	{
		Vector vout;

		Vector in2_0 = Vector(matrix[0 * 4 + 0], matrix[0 * 4 + 1], matrix[0 * 4 + 2]);
		Vector in2_1 = Vector(matrix[1 * 4 + 0], matrix[1 * 4 + 1], matrix[1 * 4 + 2]);
		Vector in2_2 = Vector(matrix[2 * 4 + 0], matrix[2 * 4 + 1], matrix[2 * 4 + 2]);

		vout.x = DotProduct(in1, in2_0) + matrix[0 * 4 + 3];
		vout.y = DotProduct(in1, in2_1) + matrix[1 * 4 + 3];
		vout.z = DotProduct(in1, in2_2) + matrix[2 * 4 + 3];

		return vout;
	}

	void Spin()
	{
		float flNumForce = 0;
		float flMomentOfForceTotal = 0;

		Vector vCenter = self.pev.origin;
		Vector vHalfExtent = (self.pev.maxs - self.pev.mins) * 0.5;

		array<float> matrix(16);
		AngleMatrix(self.pev.angles, matrix);

		array<Vector> vSides(4);
		array<Vector> vNormal(4);

		vSides[0] = Vector(1, 0, 0);
		vSides[0] = VectorTransform(vSides[0], matrix);

		vNormal[0] = Vector(0, -1, 0);
		vNormal[0] = VectorTransform(vNormal[0], matrix);

		vSides[1] = Vector(0, -1, 0);
		vSides[1] = VectorTransform(vSides[1], matrix);

		vNormal[1] = Vector(-1, 0, 0);
		vNormal[1] = VectorTransform(vNormal[1], matrix);

		vSides[2] = Vector(-1, 0, 0);
		vSides[2] = VectorTransform(vSides[2], matrix);

		vNormal[2] = Vector(0, 1, 0);
		vNormal[2] = VectorTransform(vNormal[2], matrix);

		vSides[3] = Vector(0, 1, 0);
		vSides[3] = VectorTransform(vSides[3], matrix);

		vNormal[3] = Vector(1, 0, 0);
		vNormal[3] = VectorTransform(vNormal[3], matrix);

		for (int i = 1; i <= g_Engine.maxClients; i++)
		{
			if(m_PushState[i] == 1)
			{
				CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
				if(pPlayer !is null && pPlayer.IsAlive())
				{
					Vector vPushNormal = m_PushPlaneNormal[i] * -1;

					Vector vPlanePos = m_PushPlanePos[i];
					vPlanePos.z = vCenter.z;

					Vector vPushForce = m_PushForce[i];					
					vPushForce.z = 0;

					Vector vDiff = vPlanePos - vCenter;
					Vector vDiffNorm = vDiff.Normalize();

					float vAngleDiff_0 = DotProduct(vDiffNorm, vSides[0]);
					float vAngleDiff_1 = DotProduct(vDiffNorm, vSides[1]);
					float flDiff = vDiff.Length();
					Vector vPushDir;

					if(vAngleDiff_0 > vAngleDiff_1 && vAngleDiff_1 > 0)
					{
						//Push side 0 from right-bottom
						vPushDir = vNormal[0];
						flDiff = DotProduct(vDiff, vSides[0]);

						/*g_Game.AlertMessage( at_console, "Push side 0 right-bottom, vPushDir(%1, %2, %3) vPushForce(%4, %5, %6)\n",
											vPushDir.x, vPushDir.y, vPushDir.z,
											vPushForce.x, vPushForce.y, vPushForce.z
											);*/
					}
					else if(vAngleDiff_1 > vAngleDiff_0 && vAngleDiff_0 > 0)
					{
						//Push side 1 from right-bottom
						vPushDir = vNormal[1];
						flDiff = DotProduct(vDiff, vSides[1]);

						/*g_Game.AlertMessage( at_console, "Push side 1 right-bottom, vPushDir(%1, %2, %3) vPushForce(%4, %5, %6)\n",
											vPushDir.x, vPushDir.y, vPushDir.z,
											vPushForce.x, vPushForce.y, vPushForce.z
											);*/
					}
					else
					{
						float vAngleDiff_2 = DotProduct(vDiffNorm, vSides[2]);
						if(vAngleDiff_1 > vAngleDiff_2 && vAngleDiff_2 > 0)
						{
							//Push side 1 from left-bottom
							vPushDir = vNormal[1];
							flDiff = DotProduct(vDiff, vSides[1]);

							/*g_Game.AlertMessage( at_console, "Push side 1 left-bottom, vPushDir(%1, %2, %3) vPushForce(%4, %5, %6)\n",
												vPushDir.x, vPushDir.y, vPushDir.z,
												vPushForce.x, vPushForce.y, vPushForce.z
												);*/
						}
						else if(vAngleDiff_2 > vAngleDiff_1 && vAngleDiff_1 > 0)
						{
							//Push side 2 from left-bottom
							vPushDir = vNormal[2];
							flDiff = DotProduct(vDiff, vSides[2]);

							/*g_Game.AlertMessage( at_console, "Push side 2 left-bottom, vPushDir(%1, %2, %3) vPushForce(%4, %5, %6)\n",
												vPushDir.x, vPushDir.y, vPushDir.z,
												vPushForce.x, vPushForce.y, vPushForce.z
												);*/
						}
						else
						{
							float vAngleDiff_3 = DotProduct(vDiffNorm, vSides[3]);
							if(vAngleDiff_2 > vAngleDiff_3 && vAngleDiff_3 > 0)
							{
								//Push side 2 from left-top
								vPushDir = vNormal[2];
								flDiff = DotProduct(vDiff, vSides[2]);

									/*g_Game.AlertMessage( at_console, "Push side 2 left-top, vPushDir(%1, %2, %3) vPushForce(%4, %5, %6)\n",
														vPushDir.x, vPushDir.y, vPushDir.z,
														vPushForce.x, vPushForce.y, vPushForce.z
														);*/
							}
							else if(vAngleDiff_3 > vAngleDiff_2 && vAngleDiff_2 > 0)
							{
								//Push side 3 from left-top
								vPushDir = vNormal[3];
								flDiff = DotProduct(vDiff, vSides[3]);

									/*g_Game.AlertMessage( at_console, "Push side 3 left-top, vPushDir(%2, %3, %4) vPushForce(%5, %6, %7)\n",
														vPushDir.x, vPushDir.y, vPushDir.z,
														vPushForce.x, vPushForce.y, vPushForce.z
														);*/
							}
							else
							{
								if(vAngleDiff_3 > vAngleDiff_0 && vAngleDiff_0 > 0)
								{
									//Push side 3 from right-top
									vPushDir = vNormal[3];
									flDiff = DotProduct(vDiff, vSides[3]);

									/*g_Game.AlertMessage( at_console, "Push side 3 right-top, vPushDir(%2, %3, %4) vPushForce(%5, %6, %7)\n",
														vPushDir.x, vPushDir.y, vPushDir.z,
														vPushForce.x, vPushForce.y, vPushForce.z
														);*/
								}
								else if(vAngleDiff_0 > vAngleDiff_3 && vAngleDiff_3 > 0)
								{
									//Push side 0 from right-top
									vPushDir = vNormal[0];
									flDiff = DotProduct(vDiff, vSides[0]);

									
									/*g_Game.AlertMessage( at_console, "Push side 0 right-top, vPushDir(%2, %3, %4) vPushForce(%5, %6, %7)\n",
														vPushDir.x, vPushDir.y, vPushDir.z,
														vPushForce.x, vPushForce.y, vPushForce.z
														);*/
								}
								else
								{
									/*g_Game.AlertMessage( at_console, "Push nothing, vPushDir(%2, %3, %4) vPushForce(%5, %6, %7)\n",
														vPushDir.x, vPushDir.y, vPushDir.z,
														vPushForce.x, vPushForce.y, vPushForce.z
														);*/
								}
							}
						}
					}
					
					if(abs(DotProduct(vPushNormal, vPushDir)) > 0.866)
					{
						float flPercent = (flDiff / vHalfExtent.x);
						float flMomentOfForce = DotProduct(vPushDir, vPushForce) * -1;
						
						flMomentOfForceTotal += flMomentOfForce * flPercent;
						flNumForce += 1.0;
					}

					m_PushState[i] = 0;
				}
			}
		}

		float flAngleAcc = 0;
		if(flNumForce > 0)
		{
			flAngleAcc = (flMomentOfForceTotal / flNumForce) * m_flInertia;
			self.pev.avelocity.y += (flAngleAcc * g_Engine.frametime);

			NextThink(self.pev.ltime + 0.1, true);
			SetThink(ThinkFunction(this.Spin));

			if(!m_bLastSpinState)
			{
				g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_WEAPON, m_szStartSpinSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

				m_flLastSpinTime = g_Engine.time;
				m_bLastSpinState = true;
			}
		}
		else
		{
			self.pev.avelocity.y *= m_flDamping;

			if(abs(self.pev.avelocity.y) < 1)
				self.pev.avelocity = g_vecZero;

			NextThink(self.pev.ltime + 0.1, false);
			SetThink(ThinkFunction(this.Spin));

			if(m_bLastSpinState && g_Engine.time > m_flLastSpinTime + 3.0)
			{
				g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_WEAPON, m_szStopSpinSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

				m_bLastSpinState = false;
			}
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_SET && flValue < 0)
		{
			self.pev.angles = g_vecZero;
			self.pev.avelocity = g_vecZero;
			
			m_bLastSpinState = false;
			m_flLastSpinTime = 0;
		}
	}
}

class CFuncLever : ScriptBaseEntity
{
	float m_flInertia = 1.0;
	float m_flLimitAngle = 80.0;
	float m_flLimitBounceVelocity = 10.0;
	float m_flLimitBounceFriction = 0.5;
	float m_flReturnAngle = 45.0;
	float m_flReturnForce = 0;

	array<string> m_szStartSpinSoundName = {
		"fallguys/seesawstart.ogg",
		"fallguys/seesawstart2.ogg",
		"fallguys/seesawstart3.ogg",
		"fallguys/seesawstart4.ogg"
	};

	array<string> m_szStopSpinSoundName = {
		"fallguys/seesawstop.ogg",
		"fallguys/seesawstop2.ogg",
		"fallguys/seesawstop3.ogg"
	};

	bool m_bLastSpinState = false;
	float m_flLastSpinTime = 0;

	void Precache()
	{
		BaseClass.Precache();
		
		g_SoundSystem.PrecacheSound( m_szStartSpinSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szStartSpinSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szStartSpinSoundName[2] );
		g_SoundSystem.PrecacheSound( m_szStartSpinSoundName[3] );

		g_SoundSystem.PrecacheSound( m_szStopSpinSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szStopSpinSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szStopSpinSoundName[2] );
	}

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_BSP;
		self.pev.movetype = MOVETYPE_PUSH;

		if ((self.pev.spawnflags & 1) == 1)
			self.pev.movedir = Vector(0, 0, 1);
		else if ((self.pev.spawnflags & 2) == 2)
			self.pev.movedir = Vector(1, 0, 0);

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		NextThink(self.pev.ltime + 0.1, false);
		SetThink(ThinkFunction(this.Spin));
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "inertia"){
			m_flInertia = atof(szValue);
			return true;
		}
		if(szKey == "limitangle"){
			m_flLimitAngle = atof(szValue);
			return true;
		}
		if(szKey == "limitbouncevelocity"){
			m_flLimitBounceVelocity = atof(szValue);
			return true;
		}
		if(szKey == "limitbouncefriction"){
			m_flLimitBounceFriction = atof(szValue);
			return true;
		}
		if(szKey == "returnangle"){
			m_flReturnAngle = atof(szValue);
			return true;
		}
		if(szKey == "returnforce"){
			m_flReturnForce = atof(szValue);
			return true;
		}
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

	void Spin()
	{
		//g_Game.AlertMessage( at_console, "My avel %1 %2 %3\n", self.pev.avelocity.x, self.pev.avelocity.y, self.pev.avelocity.z );
		//g_Game.AlertMessage( at_console, "My angle %1 %2 %3\n", self.pev.angles.x, self.pev.angles.y, self.pev.angles.z );

		float flNumForce = 0;
		float flMomentOfForceTotal = 0;

		int iLimited = 0;

		if ((self.pev.spawnflags & 1) == 1)
		{
			if(self.pev.angles.z > m_flLimitAngle)
			{
				if(self.pev.avelocity.z > m_flLimitBounceVelocity)
					self.pev.avelocity.z *= -m_flLimitBounceFriction;
				else
					self.pev.avelocity.z = -m_flLimitBounceVelocity * m_flLimitBounceFriction;
				iLimited = 1;
			}
			else if(self.pev.angles.z < -m_flLimitAngle)
			{
				if(self.pev.avelocity.z < -m_flLimitBounceVelocity)
					self.pev.avelocity.z *= -m_flLimitBounceFriction;
				else
					self.pev.avelocity.z = m_flLimitBounceVelocity * m_flLimitBounceFriction;
				iLimited = 2;
			}
			else if(self.pev.angles.z > m_flReturnAngle)
			{
				flNumForce += 1.0;
				flMomentOfForceTotal -= m_flReturnForce;
				iLimited = -1;
			}
			else if(self.pev.angles.z < -m_flReturnAngle)
			{
				flNumForce += 1.0;
				flMomentOfForceTotal += m_flReturnForce;
				iLimited = -2;
			}
		}
		else if ((self.pev.spawnflags & 2) == 2)
		{
			if(self.pev.angles.x > m_flLimitAngle)
			{
				if(self.pev.avelocity.x > m_flLimitBounceVelocity)
					self.pev.avelocity.x *= -m_flLimitBounceFriction;
				else
					self.pev.avelocity.x = -m_flLimitBounceVelocity * m_flLimitBounceFriction;
				iLimited = 1;
			}
			else if(self.pev.angles.x < -m_flLimitAngle)
			{
				if(self.pev.avelocity.x < -m_flLimitBounceVelocity)
					self.pev.avelocity.x *= -m_flLimitBounceFriction;
				else
					self.pev.avelocity.x = m_flLimitBounceVelocity * m_flLimitBounceFriction;
				iLimited = 2;
			}
			else if(self.pev.angles.x > m_flReturnAngle)
			{
				flNumForce += 1.0;
				flMomentOfForceTotal -= m_flReturnForce;
				iLimited = -1;
			}
			else if(self.pev.angles.x < -m_flReturnAngle)
			{
				flNumForce += 1.0;
				flMomentOfForceTotal += m_flReturnForce;
				iLimited = -2;
			}
		}

		if(iLimited <= 0)
		{
			for (int i = 1; i <= g_Engine.maxClients; i++)
			{
				CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
				if(pPlayer !is null && pPlayer.IsAlive())
				{
					if ( g_ArrayPlayerJumpState[i] == 2 && g_ArrayPlayerJumpPreGroundEntity[i] == self.entindex() )
					{
						//g_Game.AlertMessage( at_console, "someone is jumping\n" );

						float flAngle = 0;
						float flOffset = 0;
						Vector v1 = pPlayer.pev.origin;
						Vector v2 = self.pev.origin;
						if ((self.pev.spawnflags & 1) == 1)
						{
							v1.x = v2.x;
							v1.z -= pPlayer.pev.maxs.z;
							flOffset = (v1-v2).Length();
							flAngle = self.pev.angles.z;

							if(v1.y > v2.y)
								flOffset *= -1.0;
						}
						else if ((self.pev.spawnflags & 2) == 2)
						{
							v1.y = v2.y;
							v1.z -= pPlayer.pev.maxs.z;
							flOffset = (v1-v2).Length();
							flAngle = self.pev.angles.x;

							if(v1.x > v2.x)
								flOffset *= -1.0;
						}

						float flGravity = 800 * 50;

						float flAngleDiff = 90 - flAngle;
						float flMomentOfForce = flGravity * flOffset * sin(flAngleDiff * 2 * 3.14159 / 360.0);
						
						flMomentOfForceTotal += flMomentOfForce;
						flNumForce += 1.0;
					}

					else if((pPlayer.pev.flags & FL_ONGROUND) == FL_ONGROUND && (pPlayer.pev.groundentity is self.edict() ))
					{
						float flAngle = 0;
						float flOffset = 0;
						Vector v1 = pPlayer.pev.origin;
						Vector v2 = self.pev.origin;
						if ((self.pev.spawnflags & 1) == 1)
						{
							v1.x = v2.x;
							v1.z -= pPlayer.pev.maxs.z;
							flOffset = (v1-v2).Length();
							flAngle = self.pev.angles.z;

							if(v1.y > v2.y)
								flOffset *= -1.0;
						}
						else if ((self.pev.spawnflags & 2) == 2)
						{
							v1.y = v2.y;
							v1.z -= pPlayer.pev.maxs.z;
							flOffset = (v1-v2).Length();
							flAngle = self.pev.angles.x;

							if(v1.x > v2.x)
								flOffset *= -1.0;
						}

						float flGravity = 800;

						float flAngleDiff = 90 - flAngle;
						float flMomentOfForce = flGravity * flOffset * sin(flAngleDiff * 2 * 3.14159 / 360.0);
						
						flMomentOfForceTotal += flMomentOfForce;
						flNumForce += 1.0;

						//g_Game.AlertMessage( at_console, "Found %1 on me, flOffset %2, flAngleDiff %3, flMomentOfForce %4 %5\n", pPlayer.pev.netname, flOffset, flAngleDiff, flMomentOfForce, pPlayer.pev.maxs.z );
					}
				}
			}
		}

		float flAngleAcc = 0;
		if(flNumForce > 0)
		{
			flAngleAcc = (flMomentOfForceTotal / flNumForce) / m_flInertia;
			self.pev.avelocity = self.pev.avelocity + self.pev.movedir * (flAngleAcc * g_Engine.frametime);

			NextThink(self.pev.ltime + 0.1, true);
			SetThink(ThinkFunction(this.Spin));

			if(!m_bLastSpinState)
			{
				g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_WEAPON, m_szStartSpinSoundName[Math.RandomLong(0, 3)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

				m_flLastSpinTime = g_Engine.time;
				m_bLastSpinState = true;
			}
		}
		else
		{
			NextThink(self.pev.ltime + 0.1, false);
			SetThink(ThinkFunction(this.Spin));

			if(m_bLastSpinState && g_Engine.time > m_flLastSpinTime + 3.0)
			{
				g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_WEAPON, m_szStopSpinSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

				m_bLastSpinState = false;
			}
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_SET && flValue < 0)
		{
			self.pev.angles = g_vecZero;
			self.pev.avelocity = g_vecZero;
			m_bLastSpinState = false;
			m_flLastSpinTime = 0;
		}
	}
}

class CFuncBarrier : ScriptBaseEntity
{
	Vector m_vecLeft;
	Vector m_vecRight;
	Vector m_vecForward;

	float m_flSlideForce = 0.0;
	float m_flSlideMaxVelocity = 0.0;
	float m_flBounceForce = 0.0;

	array<string> m_szBounceSoundName = {
		"fallguys/bounce.ogg",
		"fallguys/bounce2.ogg",
		"fallguys/bounce3.ogg"
	};

	string m_szSlideSoundName = "fallguys/slide.ogg";

	void Precache()
	{
		BaseClass.Precache();
		
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[2] );

		g_SoundSystem.PrecacheSound( m_szSlideSoundName );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "slideforce"){
			m_flSlideForce = atof(szValue);
			return true;
		}
		if(szKey == "slidemaxvelocity"){
			m_flSlideMaxVelocity = atof(szValue);
			return true;
		}

		if(szKey == "bounceforce"){
			m_flBounceForce = atof(szValue);
			return true;
		}

		if(szKey == "bouncesound0"){
			m_szBounceSoundName[0] = szValue;
			return true;
		}

		if(szKey == "bouncesound1"){
			m_szBounceSoundName[1] = szValue;
			return true;
		}

		if(szKey == "bouncesound2"){
			m_szBounceSoundName[2] = szValue;
			return true;
		}

		if(szKey == "slidesound"){
			m_szSlideSoundName = szValue;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_BSP;
		self.pev.movetype = MOVETYPE_PUSH;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );

		if(self.pev.origin.x == 0.0 && self.pev.origin.y == 0.0 && self.pev.origin.z == 0.0)
		{
			self.pev.origin = (self.pev.mins + self.pev.maxs) * 0.5;
		}

		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		Vector angles = self.pev.angles;

		Math.MakeVectors( angles );

		m_vecLeft = g_Engine.v_right * -1.0;
		m_vecRight = g_Engine.v_right;
		m_vecForward = g_Engine.v_forward;

		self.pev.angles = g_vecZero;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		//PM code, velocity not work
		if((pOther.pev.flags & FL_ONGROUND) == FL_ONGROUND && (pOther.pev.groundentity is self.edict() ))
		{
			if(m_flSlideForce > 0)
			{
				Vector vDiff = (pOther.pev.origin - self.pev.origin);
				vDiff.z = 0;
				vDiff = vDiff.Normalize();

				if(DotProduct(vDiff, m_vecLeft) > 0)
				{
					if(m_flSlideMaxVelocity > 0 && DotProduct(g_ArrayVelocityPlayer[pOther.entindex()], m_vecLeft) > m_flSlideMaxVelocity)
						return;

					pOther.pev.basevelocity = m_vecLeft * m_flSlideForce;

					g_ArraySlidePlayer[pOther.entindex()] = g_Engine.time;

					if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

						if(!m_szSlideSoundName.IsEmpty())
							g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szSlideSoundName, 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

						g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
					}
				}
				else if(DotProduct(vDiff, m_vecRight) > 0)
				{
					if(m_flSlideMaxVelocity > 0 && DotProduct(g_ArrayVelocityPlayer[pOther.entindex()], m_vecRight) > m_flSlideMaxVelocity)
						return;

					pOther.pev.basevelocity = m_vecRight * m_flSlideForce;

					g_ArraySlidePlayer[pOther.entindex()] = g_Engine.time;

					if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){
						
						if(!m_szSlideSoundName.IsEmpty())
							g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szSlideSoundName, 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

						g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
					}
				}
			}
		}
		else
		{
			if(m_flBounceForce > 0)
			{
				if(g_Engine.time < g_ArraySlidePlayer[pOther.entindex()] + 0.1)
					return;

				Vector vDiff = (pOther.pev.origin - self.pev.origin);
				vDiff.z = 0;
				vDiff = vDiff.Normalize();

				if(DotProduct(vDiff, m_vecLeft) > 0)
				{
					g_ArrayBounceVelocityPlayer[pOther.entindex()] = m_vecLeft * m_flBounceForce;

					if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

						g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szBounceSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

						g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
					}
				}
				else if(DotProduct(vDiff, m_vecRight) > 0)
				{
					g_ArrayBounceVelocityPlayer[pOther.entindex()] = m_vecRight * m_flBounceForce;

					if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){
						
						g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szBounceSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

						g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
					}
				}
			}
		}
	}
}

class CFuncBouncer : ScriptBaseEntity
{
	int m_iDirection = 0;
	float m_flBounceForce = 0.0;
	float m_flUpForce = 0.0;

	array<string> m_szBounceSoundName = {
		"fallguys/bounce.ogg",
		"fallguys/bounce2.ogg",
		"fallguys/bounce3.ogg"
	};

	void Precache()
	{
		BaseClass.Precache();
		
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[2] );
	}

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_BSP;
		self.pev.movetype = MOVETYPE_PUSH;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "direction"){
			m_iDirection = atoi(szValue);
			return true;
		}

		if(szKey == "upforce"){
			m_flUpForce = atof(szValue);
			return true;
		}

		if(szKey == "bounceforce"){
			m_flBounceForce = atof(szValue);
			return true;
		}

		if(szKey == "bouncesound0"){
			m_szBounceSoundName[0] = szValue;
			return true;
		}

		if(szKey == "bouncesound1"){
			m_szBounceSoundName[1] = szValue;
			return true;
		}

		if(szKey == "bouncesound2"){
			m_szBounceSoundName[2] = szValue;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Touch( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		if((pOther.pev.flags & FL_ONGROUND) == FL_ONGROUND && (pOther.pev.groundentity is self.edict() ))
		{
			if(m_flBounceForce > 0.0)
			{
				Vector vecImpactDirection;

				if(m_iDirection == 1)
				{
					Vector vecPush = g_Engine.trace_plane_normal * m_flBounceForce;
					vecPush.z += m_flUpForce;

					vecImpactDirection = g_Engine.trace_plane_normal;

					g_ArrayBounceVelocityPlayer[pOther.entindex()] = vecPush;
				}
				else if(m_iDirection == 2)
				{
					Vector vDiff = pOther.pev.origin - self.pev.origin;
					vDiff.z = 0;
					vDiff = vDiff.Normalize();

					vecImpactDirection = vDiff;

					Vector vecPush = vDiff * m_flBounceForce;
					vecPush.z += m_flUpForce;

					g_ArrayBounceVelocityPlayer[pOther.entindex()] = vecPush;
				}
				else
				{
					g_ArrayBounceVelocityPlayer[pOther.entindex()] = Vector(0.0, 0.0, m_flBounceForce);
				}

				if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

					g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szBounceSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

					Vector vecImpactDirection2 = vecImpactDirection;
					vecImpactDirection2.z *= 72.0 / 32.0;

					Vector vecImpactPosition2 = pOther.pev.origin - vecImpactDirection2 * 12;

					EmitPlayerHitEffect(pOther, HitEffect_Medium, vecImpactPosition2, vecImpactDirection);

					g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
				}
			}
		}
		else
		{
			if(m_flBounceForce > 0.0)
			{
				Vector vecImpactDirection;

				Vector vDiff = pOther.pev.origin - self.pev.origin;
				vDiff.z = 0;
				vDiff = vDiff.Normalize();

				vecImpactDirection = vDiff;

				g_ArrayBounceVelocityPlayer[pOther.entindex()] = vDiff * m_flBounceForce;

				if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

					g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szBounceSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

					Vector vecImpactDirection2 = vecImpactDirection;
					vecImpactDirection2.z *= 72.0 / 32.0;

					Vector vecImpactPosition2 = pOther.pev.origin - vecImpactDirection2 * 12;

					EmitPlayerHitEffect(pOther, HitEffect_Medium, vecImpactPosition2, vecImpactDirection);

					g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
				}
			}
		}
	}
}

class CFuncBounceDrum : ScriptBaseEntity
{
	float m_flBounceForce = 0.0;
	Vector m_vecBounceVector = Vector(0, 0, 1);
	float m_flLastBounceTime = 0.0;

	array<string> m_szBounceSoundName = {
		"fallguys/bounce.ogg",
		"fallguys/bounce2.ogg",
		"fallguys/bounce3.ogg"
	};

	void Precache()
	{
		BaseClass.Precache();
		
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[2] );
	}

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_BSP;
		self.pev.movetype = MOVETYPE_PUSH;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "bounceforce"){
			m_flBounceForce = atof(szValue);
			return true;
		}

		if(szKey == "bounceangles"){
			Vector angles;
			g_Utility.StringToVector( angles, szValue );

			Math.MakeVectors( angles );

			m_vecBounceVector = g_Engine.v_forward;
			return true;
		}

		if(szKey == "bouncesound0"){
			m_szBounceSoundName[0] = szValue;
			return true;
		}

		if(szKey == "bouncesound1"){
			m_szBounceSoundName[1] = szValue;
			return true;
		}

		if(szKey == "bouncesound2"){
			m_szBounceSoundName[2] = szValue;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Touch( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		if((pOther.pev.flags & FL_ONGROUND) == FL_ONGROUND && (pOther.pev.groundentity is self.edict() ))
		{
			if(m_flBounceForce > 0.0)
			{
				g_ArrayBounceVelocityPlayer[pOther.entindex()] = m_vecBounceVector* m_flBounceForce;

				if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

					g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szBounceSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

					g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
				}

				if(g_Engine.time > m_flLastBounceTime){

					if(!string(self.pev.target).IsEmpty())
					{
						g_EntityFuncs.FireTargets( self.pev.target, self, self, USE_SET, 0.075 );
					}

					m_flLastBounceTime = g_Engine.time + 0.5;
				}
			}
		}
		else
		{
			if(m_flBounceForce > 0.0)
			{
				g_ArrayBounceVelocityPlayer[pOther.entindex()] = m_vecBounceVector * m_flBounceForce;
				
				if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

					g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szBounceSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

					g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
				}

				if(g_Engine.time > m_flLastBounceTime){

					if(!string(self.pev.target).IsEmpty())
					{
						g_EntityFuncs.FireTargets( self.pev.target, self, self, USE_SET, 0.075 );
					}

					m_flLastBounceTime = g_Engine.time + 0.5;
				}
			}
		}
	}
}

class CFuncPendulum2 : ScriptBaseEntity
{
	Vector m_vecInitialAngles;

	float m_flDistance = 0.0;
	float m_flConstant = 0.0;

	float m_flBounceForce = 0.0;
	float m_flPushForce = 0.0;
	float m_flUpForce = 0.0;
	float m_flBlockPushForce = 0.0;
	float m_flBlockUpForce = 0.0;
	float m_flBlockCrushTime = 4.0;

	bool m_bIsSuperPusher = false;

	array<string> m_szHitSoundName = {
		"fallguys/impact1.ogg",
		"fallguys/impact2.ogg",
		"fallguys/impact3.ogg"
	};

	array<string> m_szBounceSoundName = {
		"fallguys/bounce.ogg",
		"fallguys/bounce2.ogg",
		"fallguys/bounce3.ogg"
	};

	string m_szBlockSoundName = "fallguys/mecha.ogg";

	void Precache()
	{
		BaseClass.Precache();

		g_SoundSystem.PrecacheSound( m_szHitSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szHitSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szHitSoundName[2] );
		
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[1] );		
		g_SoundSystem.PrecacheSound( m_szBounceSoundName[2] );

		g_SoundSystem.PrecacheSound( m_szBlockSoundName );
	}

	void Restart()
	{
		self.pev.angles = m_vecInitialAngles;
		self.pev.avelocity = g_vecZero;
		NextThink(self.pev.ltime + 0.1, false);
		SetThink(ThinkFunction(this.Rotate));
	}

	void Spawn()
	{
		Precache();

		if ((self.pev.spawnflags & SF_DOOR_PASSABLE) == SF_DOOR_PASSABLE)
			self.pev.solid = SOLID_NOT;
		else
			self.pev.solid = SOLID_BSP;

		self.pev.movetype = MOVETYPE_PUSH;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		if ((self.pev.spawnflags & SF_DOOR_ROTATE_Z) == SF_DOOR_ROTATE_Z)
			self.pev.movedir = Vector(0.0, 0.0, 1.0);
		else if ((self.pev.spawnflags & SF_DOOR_ROTATE_X) == SF_DOOR_ROTATE_X)
			self.pev.movedir = Vector(1.0, 0.0, 0.0);
		else
			self.pev.movedir = Vector(0.0, 1.0, 0.0);

		if (self.pev.speed == 0)
			self.pev.speed = 100;

		m_vecInitialAngles = self.pev.angles;

		m_flConstant = (self.pev.speed * self.pev.speed) * 0.5;

		if(m_flDistance > 90)
			m_flDistance = 90;

		if(m_flDistance < 10)
			m_flDistance = 10;

		if ((self.pev.spawnflags & SF_BRUSH_ROTATE_INSTANT) == SF_BRUSH_ROTATE_INSTANT)
		{
			//g_Game.AlertMessage( at_console, "Starting %1\n", string(self.pev.targetname));
			
			NextThink(g_Engine.time + 1.5, false);
			SetThink(ThinkFunction(this.SUB_CallUseToggle));
		}

		if(m_bIsSuperPusher)
			g_EntityFuncs.SetEntitySuperPusher(self.edict(), true);
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "distance"){
			m_flDistance = atof(szValue);
			return true;
		}

		if(szKey == "pushforce"){
			m_flPushForce = atof(szValue);
			return true;
		}

		if(szKey == "upforce"){
			m_flUpForce = atof(szValue);
			return true;
		}

		if(szKey == "blockpushforce"){
			m_flBlockPushForce = atof(szValue);
			return true;
		}

		if(szKey == "blockupforce"){
			m_flBlockUpForce = atof(szValue);
			return true;
		}

		if(szKey == "bounceforce"){
			m_flBounceForce = atof(szValue);
			return true;
		}

		if(szKey == "bouncesound0"){
			m_szBounceSoundName[0] = szValue;
			return true;
		}

		if(szKey == "bouncesound1"){
			m_szBounceSoundName[1] = szValue;
			return true;
		}

		if(szKey == "bouncesound2"){
			m_szBounceSoundName[2] = szValue;
			return true;
		}

		if(szKey == "blockcrushtime"){
			m_flBlockCrushTime = atof(szValue);
			return true;
		}

		if(szKey == "superpusher"){
			m_bIsSuperPusher = atoi(szValue) > 0 ? true : false;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	bool IsRotating()
	{
		return (self.pev.avelocity.x == 0.0 && self.pev.avelocity.y == 0.0 && self.pev.avelocity.z == 0.0) ? false : true;
	}

	float GetCurrentRotateAngle()
	{
		float ang = 0.0;
		if(self.pev.movedir.x != 0.0) 
		{
			ang = self.pev.angles.x;
		}
		else if(self.pev.movedir.y != 0.0)
		{
			ang = self.pev.angles.y;
		}
		else
		{
			ang = self.pev.angles.z;
		}
		return ang;
	}

	float GetCurrentRotateDirection()
	{
		float vecdir = 0.0;
		if(self.pev.movedir.x != 0.0) 
		{
			vecdir = self.pev.avelocity.x;
		}
		else if(self.pev.movedir.y != 0.0)
		{
			vecdir = self.pev.avelocity.y;
		}
		else
		{
			vecdir = self.pev.avelocity.z;
		}
		return vecdir;
	}

	float GetCurrentRotateSpeed()
	{
		float speed = 0.0;
		if(self.pev.movedir.x != 0.0) 
		{
			speed = self.pev.avelocity.x;
		}
		else if(self.pev.movedir.y != 0.0)
		{
			speed = self.pev.avelocity.y;
		}
		else
		{
			speed = self.pev.avelocity.z;
		}
		return abs(speed);
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_TOGGLE)
		{
			if (!IsRotating())
			{
				NextThink(self.pev.ltime + 0.1, true);
				SetThink(ThinkFunction(this.Swing));
			}
			else
			{
				self.pev.avelocity = g_vecZero;
				NextThink(self.pev.ltime + 0.1, false);
				SetThink(ThinkFunction(this.Rotate));
			}
		}
		else if(useType == USE_ON)
		{
			//g_Game.AlertMessage( at_console, "Turning on %1\n", string(self.pev.targetname));

			if (!IsRotating())
			{
				NextThink(self.pev.ltime + 0.1, true);
				SetThink(ThinkFunction(this.Swing));
			}
		}
		else if(useType == USE_OFF)
		{
			//g_Game.AlertMessage( at_console, "Turning Off %1\n", string(self.pev.targetname));

			if (IsRotating())
			{
				self.pev.avelocity = g_vecZero;
				NextThink(self.pev.ltime + 0.1, false);
				SetThink(ThinkFunction(this.Rotate));
			}
		}
		else if(useType == USE_SET && flValue > 0.0)
		{

		}
		else if(useType == USE_SET && flValue < 0.0)
		{
			Restart();
		}
	}

	void Touch( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;

		if(!pOther.IsAlive())
			return;

		//Not PM code, velocity works
		Vector vecSuperPusherPushingVector;
		if(g_EntityFuncs.GetCurrentSuperPusher(vecSuperPusherPushingVector) is self.edict())
		{
			if(m_flPushForce > 0.0)
			{
				Vector vDir = vecSuperPusherPushingVector;
				vDir = vDir.Normalize();
				pOther.pev.velocity = vDir * m_flPushForce;		

				if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

					if(m_flBounceForce > 0)
					{
						g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szBounceSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );
					}
					else
					{
						g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szHitSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );
						
						pOther.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );
						
						Vector vecImpactDirection = vDir;
						Vector vecImpactDirection2 = vecImpactDirection;
						vecImpactDirection2.z *= 72.0 / 32.0;

						Vector vecImpactPosition2 = pOther.pev.origin - vecImpactDirection2 * 16;

						EmitPlayerHitEffect(pOther, HitEffect_Large, vecImpactPosition2, vecImpactDirection);

					}
					g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
				}
			}

			if(m_flUpForce > 0)
			{
				if(pOther.pev.velocity.z < m_flUpForce)
					pOther.pev.velocity.z = m_flUpForce;
			}

			return;
		}

		//PM code, velocity don't work
		if(m_flBounceForce > 0)
		{
			if((pOther.pev.flags & FL_ONGROUND) == FL_ONGROUND && (pOther.pev.groundentity is self.edict() ))
			{

			}
			else
			{
				Vector vDiff = pOther.pev.origin - self.pev.origin;
				vDiff.z = 0;
				vDiff = vDiff.Normalize();

				g_ArrayBounceVelocityPlayer[pOther.entindex()] = vDiff * m_flBounceForce;

				if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

					g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szBounceSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

					g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
				}
			}
		}
	}

	void Blocked( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		if(g_ArrayBlockPlayer[pOther.entindex()].IsBlocking)
		{
			if(g_Engine.time > g_ArrayBlockPlayer[pOther.entindex()].flStartBlockTime + m_flBlockCrushTime)
			{
				pOther.TakeDamage(self.pev, self.pev, 999999, DMG_CRUSH);
			}
			g_ArrayBlockPlayer[pOther.entindex()].flLastBlockTime = g_Engine.time;
		}
		else
		{
			g_ArrayBlockPlayer[pOther.entindex()].flStartBlockTime = g_Engine.time;
			g_ArrayBlockPlayer[pOther.entindex()].flLastBlockTime = g_Engine.time;
			g_ArrayBlockPlayer[pOther.entindex()].IsBlocking = true;

			if(g_Engine.time > g_ArrayBlockPlayer[pOther.entindex()].flLastSoundTime + 1.0){
				g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szBlockSoundName, 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );
				g_ArrayBlockPlayer[pOther.entindex()].szPlayingSound = m_szBlockSoundName;
				g_ArrayBlockPlayer[pOther.entindex()].flLastSoundTime = g_Engine.time;
			}
		}

		if(m_flBlockPushForce > 0.0)
		{
			Vector vDir = pOther.pev.origin - self.pev.origin;
			vDir = vDir.Normalize();
			pOther.pev.velocity = vDir * m_flBlockPushForce;

			if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

				g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_BODY, m_szHitSoundName[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

				pOther.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );

				g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
			}
		}

		if(m_flBlockUpForce > 0)
		{
			if(pOther.pev.velocity.z < m_flBlockUpForce)
				pOther.pev.velocity.z = m_flBlockUpForce;
		}
	}

	void NextThink(float thinkTime, const bool alwaysThink)
	{
		if (alwaysThink)
			self.pev.flags |= FL_ALWAYSTHINK;
		else
			self.pev.flags &= ~FL_ALWAYSTHINK;

		self.pev.nextthink = thinkTime;
	}

	void SUB_CallUseToggle()
	{
		self.Use(self, self, USE_ON, 0.0);
	}

	void Rotate()
	{
		NextThink(self.pev.ltime + 10.0, false);
		SetThink(ThinkFunction(this.Rotate));
	}

	void Swing()
	{
		NextThink(self.pev.ltime + 0.1, true);
		SetThink(ThinkFunction(this.Swing));

		float flCurrentAngle = GetCurrentRotateAngle();
		float flCurrentDirection = GetCurrentRotateDirection();

		float flNewSpeed = sqrt(m_flConstant * (1.0 + cos( flCurrentAngle * (2 * 3.1415926 / 360.0) * (180 / m_flDistance) ) ));
		
		//g_Game.AlertMessage( at_console, "Swing %1 flCurrentAngle %2 m_flConstant %3 flNewSpeed %4\n", string(self.pev.targetname), flCurrentAngle, m_flConstant, flNewSpeed);

		if(flCurrentAngle > 0)
		{
			if(flCurrentAngle < (m_flDistance - 1))
			{
				if(flCurrentDirection > 0)
				{
					self.pev.avelocity = self.pev.movedir * flNewSpeed;
				}
				else
				{
					self.pev.avelocity = self.pev.movedir * -flNewSpeed;
				}
			}
			else
			{
				self.pev.avelocity = self.pev.movedir * -flNewSpeed;
			}			
		}
		else
		{
			if(flCurrentAngle > -(m_flDistance - 1))
			{
				if(flCurrentDirection < 0)
				{
					self.pev.avelocity = self.pev.movedir * -flNewSpeed;
				}
				else
				{
					self.pev.avelocity = self.pev.movedir * flNewSpeed;
				}
			}
			else
			{
				self.pev.avelocity = self.pev.movedir * flNewSpeed;
			}
		}
	}
}

class CFuncConveyor2 : ScriptBaseEntity
{
	Vector m_vecInitialAngles;

	float m_flTexcoordSpeedScale = 1.0;

	void Precache()
	{
		BaseClass.Precache();
	}

	void Restart()
	{
		self.pev.angles = m_vecInitialAngles;

		if (self.pev.angles == Vector(0, -1, 0))
		{
			self.pev.movedir = Vector(0, 0, 1);
		}
		else if (self.pev.angles == Vector(0, -2, 0))
		{
			self.pev.movedir = Vector(0, 0, -1);
		}
		else
		{
			Math.MakeVectors( self.pev.angles );
			self.pev.movedir = g_Engine.v_forward;
		}

		self.pev.angles = g_vecZero;

		UpdateSpeed(self.pev.speed);
	}

	void UpdateSpeed(float speed)
	{
		int speedCode = int(abs(speed) * 16.0);

		if (speed < 0.0)
			self.pev.rendercolor.x = 1;
		else
			self.pev.rendercolor.x = 0;

		self.pev.rendercolor.y = (speedCode >> 8);
		self.pev.rendercolor.z = (speedCode & 0xFF);
	}

	void Spawn()
	{
		Precache();

		if ((self.pev.spawnflags & SF_CONVEYOR_NOTSOLID) == SF_CONVEYOR_NOTSOLID)
			self.pev.solid = SOLID_NOT;
		else
			self.pev.solid = SOLID_BSP;

		self.pev.movetype = MOVETYPE_PUSH;
		self.pev.flags |= FL_WORLDBRUSH;

		if ((self.pev.spawnflags & SF_CONVEYOR_VISUAL) == 0)
			self.pev.flags |= FL_CONVEYOR;

		m_vecInitialAngles = self.pev.angles;

		if (self.pev.angles == Vector(0, -1, 0))
		{
			self.pev.movedir = Vector(0, 0, 1);
		}
		else if (self.pev.angles == Vector(0, -2, 0))
		{
			self.pev.movedir = Vector(0, 0, -1);
		}
		else
		{
			Math.MakeVectors( self.pev.angles );
			self.pev.movedir = g_Engine.v_forward;
		}

		if (self.pev.speed == 0)
			self.pev.speed = 100;

		UpdateSpeed(self.pev.speed);

		self.pev.angles = g_vecZero;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "texcoord_speed_scale"){
			m_flTexcoordSpeedScale = atof(szValue);
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	bool IsMoving()
	{
		return (self.pev.speed > 0) ? true : false;
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_SET && flValue > 0.0)
		{
			self.pev.speed = flValue;
			UpdateSpeed(self.pev.speed);
		}
		else if(useType == USE_SET && flValue < 0.0)
		{
			Restart();
		}
	}
}

class CFuncBreakDoor : ScriptBaseEntity
{
	int m_iInitialSpawnFlags = 0;
	float m_flMinImpactVelocity = 0.0;
	Vector m_vecImpactAngles = g_vecZero;
	Vector m_vecImpactDir = g_vecZero;
	Vector m_vecLivingMins = Vector(-999999, -999999, -999999);
	Vector m_vecLivingMaxs = Vector(999999, 999999, 999999);

	string m_szGibModelLeft = "models/fallguys/door4.mdl";
	string m_szGibModelRight = "models/fallguys/door5.mdl";
	string m_szGibModelTop = "models/fallguys/door6.mdl";

	int m_iGibModelLeft = 0;
	int m_iGibModelRight = 0;
	int m_iGibModelTop = 0;

	string m_szBeepSoundName = "fallguys/doorbeep.ogg";

	array<string> m_szHitSoundName = {
		"fallguys/doorhit.ogg",
		"fallguys/doorhit2.ogg",
		"fallguys/doorhit3.ogg",
		"fallguys/doorhit4.ogg"
	};

	array<string> m_szSmokeSprite = {
		"sprites/fallguys/smokelit2.spr"
	};

	void Precache()
	{
		BaseClass.Precache();
		
		g_SoundSystem.PrecacheSound( m_szBeepSoundName );

		g_SoundSystem.PrecacheSound( m_szHitSoundName[0] );
		g_SoundSystem.PrecacheSound( m_szHitSoundName[1] );
		g_SoundSystem.PrecacheSound( m_szHitSoundName[2] );
		g_SoundSystem.PrecacheSound( m_szHitSoundName[3] );

		m_iGibModelLeft = g_Game.PrecacheModel( m_szGibModelLeft );
		m_iGibModelRight = g_Game.PrecacheModel( m_szGibModelRight );
		m_iGibModelTop = g_Game.PrecacheModel( m_szGibModelTop );
		
		for(int i = 0;i < int(m_szSmokeSprite.length()); ++i)
		{
			g_Game.PrecacheModel( m_szSmokeSprite[i] );
		}
	}

	void Spawn()
	{
		Precache();

		if(self.pev.health > 0)
			self.pev.takedamage = DAMAGE_YES;
		else
			self.pev.takedamage = DAMAGE_NO;

		self.pev.deadflag = DEAD_NO;
		self.pev.solid = SOLID_BSP;
		self.pev.movetype = MOVETYPE_PUSH;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		m_iInitialSpawnFlags = self.pev.spawnflags;

		Math.MakeVectors( m_vecImpactAngles );

		m_vecImpactDir = g_Engine.v_forward;

	}

	void Restart()
	{
		if(self.pev.health > 0)
			self.pev.takedamage = DAMAGE_YES;
		else
			self.pev.takedamage = DAMAGE_NO;
			
		self.pev.effects &= ~EF_NODRAW;
		self.pev.deadflag = DEAD_NO;
		self.pev.solid = SOLID_BSP;
		self.pev.movetype = MOVETYPE_PUSH;

		self.pev.spawnflags = m_iInitialSpawnFlags;
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "minimpactvelocity"){
			m_flMinImpactVelocity = atof(szValue);
			return true;
		}

		if(szKey == "impactangles"){

			g_Utility.StringToVector( m_vecImpactAngles, szValue );
	
			return true;
		}

		if(szKey == "livingmins"){

			g_Utility.StringToVector( m_vecLivingMins, szValue );
	
			return true;
		}

		if(szKey == "livingmaxs"){

			g_Utility.StringToVector( m_vecLivingMaxs, szValue );
	
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Touch( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		//Stand on me? ignored
		if((pOther.pev.flags & FL_ONGROUND) == FL_ONGROUND && (pOther.pev.groundentity is self.edict() ))
		{
			
		}
		else
		{
			float flImpactVelocity = DotProduct(m_vecImpactDir, pOther.pev.velocity);
			if(flImpactVelocity > m_flMinImpactVelocity)
			{
				if((self.pev.spawnflags & 1) == 1)
				{
					self.pev.takedamage = DAMAGE_NO;
					self.pev.deadflag = DEAD_DEAD;
					self.pev.solid = SOLID_NOT;
					self.pev.effects |= EF_NODRAW;

					ShootGibLeft(pOther.pev.origin, pOther.pev.velocity, flImpactVelocity, m_vecLivingMins, m_vecLivingMaxs);
					ShootGibRight(pOther.pev.origin, pOther.pev.velocity, flImpactVelocity, m_vecLivingMins, m_vecLivingMaxs);
					ShootGibTop(pOther.pev.origin, pOther.pev.velocity, flImpactVelocity, m_vecLivingMins, m_vecLivingMaxs);

					if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

						g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szHitSoundName[Math.RandomLong(0, 3)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

						g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
					}
				}
				else
				{
					//Only beep
					if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

						g_SoundSystem.EmitSoundDyn( pOther.edict(), CHAN_STATIC, m_szBeepSoundName, 1.0, 1.0, 0, 100 );

						g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
					}
				}				
			}
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_ON)
		{
			self.pev.spawnflags |= 1;
		}
		else if(useType == USE_OFF)
		{
			self.pev.spawnflags &= ~1;
		}
		else if(useType == USE_SET && flValue < 0)
		{
			Restart();
		}
	}

	void ShootGibLeft(Vector origin, Vector velocity, float impactvel, Vector livingmins, Vector livingmaxs)
	{
		Vector vOrigin = (self.pev.mins + self.pev.maxs) * 0.5;
		vOrigin.y -= 44;
		vOrigin.z -= 18;

		Vector vVelocity = velocity;
		vVelocity.z = 64;
		vVelocity = vVelocity.Normalize();
		vVelocity = vVelocity * impactvel * 1.5;

		CBaseEntity@ pEntity = g_EntityFuncs.Create("env_physicmodel", vOrigin, g_vecZero, true);

		CEnvPhysicModel@pPhysic = cast<CEnvPhysicModel@>(CastToScriptClass(pEntity));

		pEntity.pev.model = m_szGibModelLeft;
		pEntity.pev.velocity = vVelocity;
		pPhysic.m_iShapeType = PhysicShape_Box;
		pPhysic.m_vecHalfExtent = Vector(12, 38, 52);
		pPhysic.m_flMass = 20.0;
		pPhysic.m_flCCDRadius = 12;
		pPhysic.m_flCCDThreshold = 50;
		pPhysic.m_vecLivingMins = livingmins;
		pPhysic.m_vecLivingMaxs = livingmaxs;
		pPhysic.m_flLifeTime = 1.6;
		pPhysic.m_szSmokeSprite = m_szSmokeSprite;

		//LoD setup
		pEntity.pev.iuser1 = 1;
		pEntity.pev.iuser2 = 2;
		pEntity.pev.iuser3 = 3;
		pEntity.pev.fuser1 = 500;
		pEntity.pev.fuser2 = 1000;
		pEntity.pev.fuser3 = 2000;

		g_EntityFuncs.DispatchSpawn(pEntity.edict());
	}

	void ShootGibRight(Vector origin, Vector velocity, float impactvel, Vector livingmins, Vector livingmaxs)
	{
		Vector vOrigin = (self.pev.mins + self.pev.maxs) * 0.5;
		vOrigin.y += 44;
		vOrigin.z -= 18;

		Vector vVelocity = velocity;
		vVelocity.z = 64;
		vVelocity = vVelocity.Normalize();
		vVelocity = vVelocity * impactvel * 1.5;

		CBaseEntity@ pEntity = g_EntityFuncs.Create("env_physicmodel", vOrigin, g_vecZero, true);

		CEnvPhysicModel@pPhysic = cast<CEnvPhysicModel@>(CastToScriptClass(pEntity));

		pEntity.pev.model = m_szGibModelRight;
		pEntity.pev.velocity = vVelocity;
		pPhysic.m_iShapeType = PhysicShape_Box;
		pPhysic.m_vecHalfExtent = Vector(12, 38, 52);
		pPhysic.m_flMass = 20.0;
		pPhysic.m_flCCDRadius = 12;
		pPhysic.m_flCCDThreshold = 50;
		pPhysic.m_vecLivingMins = livingmins;
		pPhysic.m_vecLivingMaxs = livingmaxs;
		pPhysic.m_flLifeTime = 1.6;
		pPhysic.m_szSmokeSprite = m_szSmokeSprite;

		//LoD setup
		pEntity.pev.iuser1 = 1;
		pEntity.pev.iuser2 = 2;
		pEntity.pev.iuser3 = 3;
		pEntity.pev.fuser1 = 500;
		pEntity.pev.fuser2 = 1000;
		pEntity.pev.fuser3 = 2000;

		g_EntityFuncs.DispatchSpawn(pEntity.edict());
	}

	void ShootGibTop(Vector origin, Vector velocity, float impactvel, Vector livingmins, Vector livingmaxs)
	{
		Vector vOrigin = (self.pev.mins + self.pev.maxs) * 0.5;
		vOrigin.z += 80;

		Vector vVelocity = velocity;
		vVelocity.z = 64;
		vVelocity = vVelocity.Normalize();
		vVelocity = vVelocity * impactvel * 1.5;

		CBaseEntity@ pEntity = g_EntityFuncs.Create("env_physicmodel", vOrigin, g_vecZero, true);

		CEnvPhysicModel@pPhysic = cast<CEnvPhysicModel@>(CastToScriptClass(pEntity));

		pEntity.pev.model = m_szGibModelTop;
		pEntity.pev.velocity = vVelocity;
		pPhysic.m_iShapeType = PhysicShape_Box;
		pPhysic.m_vecHalfExtent = Vector(26, 75, 33);
		pPhysic.m_flMass = 20.0;
		pPhysic.m_flCCDRadius = 26;
		pPhysic.m_flCCDThreshold = 50;
		pPhysic.m_vecLivingMins = livingmins;
		pPhysic.m_vecLivingMaxs = livingmaxs;
		pPhysic.m_flLifeTime = 1.6;
		pPhysic.m_szSmokeSprite = m_szSmokeSprite;

		//LoD setup
		pEntity.pev.iuser1 = 1;
		pEntity.pev.iuser2 = 2;
		pEntity.pev.iuser3 = 3;
		pEntity.pev.fuser1 = 500;
		pEntity.pev.fuser2 = 1000;
		pEntity.pev.fuser3 = 2000;

		g_EntityFuncs.DispatchSpawn(pEntity.edict());
	}
}

class CFuncMatchFloor : ScriptBaseEntity
{
	int m_iInitialSpawnFlags = 0;

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();

		self.pev.takedamage = DAMAGE_NO;
		self.pev.deadflag = DEAD_NO;
		self.pev.solid = SOLID_BSP;
		self.pev.movetype = MOVETYPE_PUSH;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		m_iInitialSpawnFlags = self.pev.spawnflags;
		self.pev.frame = 0;
	}

	void Restart()
	{
		self.pev.deadflag = DEAD_NO;
		self.pev.effects &= ~EF_NODRAW;
		self.pev.solid = SOLID_BSP;
		self.pev.movetype = MOVETYPE_PUSH;
		self.pev.spawnflags = m_iInitialSpawnFlags;
		self.pev.frame = 0;
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		return BaseClass.KeyValue( szKey, szValue );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_ON)
		{
			//2s icon display procedure
			if(self.pev.health == flValue)
				self.pev.frame = self.pev.frags;
		}
		else if(useType == USE_TOGGLE)
		{
			//Floor disappear procedure
			if(!string(self.pev.target).IsEmpty())
			{
				CBaseEntity @pTarget = g_EntityFuncs.FindEntityByTargetname( null, self.pev.target );
				if(pTarget !is null)
				{
					if(self.pev.frags != pTarget.pev.frags)
					{
						self.pev.effects |= EF_NODRAW;
						self.pev.solid = SOLID_NOT;
					}
				}
			}
			//Show up icon
			self.pev.frame = self.pev.frags;
		}
		else if(useType == USE_SET && flValue > 0)
		{
			if(flValue >= 100){
				self.pev.health = flValue - 100;
			} else {
				self.pev.frags = flValue;
			}
		}
		else if(useType == USE_SET && flValue < 0)
		{
			Restart();
		}
	}
}

class CFuncTipTile : ScriptBaseEntity
{
	int m_iInitialSpawnFlags = 0;
	int m_iSpriteTexture = 0;
	string m_szFakeTileSoundName = "fallguys/faketile.ogg";

	void Precache()
	{
		m_iSpriteTexture = g_Game.PrecacheModel("sprites/boom.spr");

		if(m_szFakeTileSoundName != ""){
			g_SoundSystem.PrecacheSound( m_szFakeTileSoundName );
		}

		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();

		self.pev.takedamage = DAMAGE_NO;
		self.pev.deadflag = DEAD_NO;
		self.pev.movetype = MOVETYPE_PUSH;

		if((self.pev.spawnflags & 1) == 1)
		{
			self.pev.solid = SOLID_TRIGGER;
		}
		else
		{
			self.pev.solid = SOLID_BSP;
		}

		self.pev.rendermode = kRenderNormal;
		self.pev.renderamt = 255;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		self.pev.effects |= EF_FRAMEANIMTEXTURES;
		self.pev.frame = 0;

		m_iInitialSpawnFlags = self.pev.spawnflags;
	}

	void Restart()
	{
		self.pev.takedamage = DAMAGE_NO;
		self.pev.deadflag = DEAD_NO;
		self.pev.movetype = MOVETYPE_PUSH;
		self.pev.rendermode = kRenderNormal;
		self.pev.renderamt = 255;

		if((self.pev.spawnflags & 1) == 1)
		{
			self.pev.solid = SOLID_TRIGGER;
		}
		else
		{
			self.pev.solid = SOLID_BSP;
		}

		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		self.pev.effects |= EF_FRAMEANIMTEXTURES;
		self.pev.frame = 0;

		self.pev.spawnflags = m_iInitialSpawnFlags;
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		return BaseClass.KeyValue( szKey, szValue );
	}

	void Touch( CBaseEntity@ pOther )
	{
		if(pOther.IsPlayer() && pOther.IsAlive())
		{
			if((self.pev.spawnflags & 1) == 1)
			{
				//Fake tile
				if(self.pev.renderamt >= 240) //smoke?
				{
					Vector vecSmoke = self.pev.origin;
					vecSmoke.z -= 4.0;

					NetworkMessage m(MSG_PVS, NetworkMessages::SVC_TEMPENTITY, vecSmoke);
					m.WriteByte(TE_BUBBLES);
					m.WriteCoord(self.pev.absmin.x);
					m.WriteCoord(self.pev.absmin.y);
					m.WriteCoord(self.pev.absmin.z);
					m.WriteCoord(self.pev.absmax.x);
					m.WriteCoord(self.pev.absmax.y);
					m.WriteCoord(self.pev.absmax.z);
					m.WriteCoord(64.0);
					m.WriteShort(m_iSpriteTexture);
					m.WriteByte(32);
					m.WriteCoord(0.125);
					m.End();

					g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_STATIC, m_szFakeTileSoundName, 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );
				}

				self.pev.rendermode = kRenderTransTexture;
				self.pev.renderamt = 0;
				NextThink(self.pev.ltime + 6.0, false);
				SetThink(ThinkFunction(this.RestoreFx));
			}
			else
			{
				//Real tile
				self.pev.frame = 9;
				NextThink(self.pev.ltime + 6.0, false);
				SetThink(ThinkFunction(this.RestoreFx));
			}
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_ON)
		{
			//Set as real
			self.pev.spawnflags &= ~1;
			self.pev.solid = SOLID_BSP;
			g_EntityFuncs.SetOrigin( self, self.pev.origin );
		}
		else if(useType == USE_OFF)
		{
			//Set as fake
			self.pev.spawnflags |= 1;
			self.pev.solid = SOLID_TRIGGER;
			g_EntityFuncs.SetOrigin( self, self.pev.origin );
		}
		else if(useType == USE_TOGGLE)
		{
			if((self.pev.spawnflags & 1) == 1)
			{
				//Set as real
				self.pev.spawnflags &= ~1;
				self.pev.solid = SOLID_BSP;
				g_EntityFuncs.SetOrigin( self, self.pev.origin );
			}
			else
			{
				//Set as fake
				self.pev.spawnflags |= 1;
				self.pev.solid = SOLID_TRIGGER;
				g_EntityFuncs.SetOrigin( self, self.pev.origin );
			}
		}
		else if(useType == USE_SET && flValue > 0)
		{
			
		}
		else if(useType == USE_SET && flValue < 0)
		{
			Restart();
		}
	}

	void NextThink(float thinkTime, const bool alwaysThink)
	{
		if (alwaysThink)
			self.pev.flags |= FL_ALWAYSTHINK;
		else
			self.pev.flags &= ~FL_ALWAYSTHINK;

		self.pev.nextthink = thinkTime;
	}

	void RestoreFx()
	{
		if(self.pev.renderamt < 255)
		{
			self.pev.renderamt = self.pev.renderamt + 1;
			if(self.pev.renderamt > 255)
			{
				self.pev.renderamt = 255;
				self.pev.rendermode = kRenderNormal;
				SetThink(null);
			}
			else
			{
				NextThink(self.pev.ltime + 0.05, false);
				SetThink(ThinkFunction(this.RestoreFx));
			}
		}
		else if(self.pev.frame > 0)
		{
			self.pev.frame = self.pev.frame - 1;
			if(self.pev.frame < 0)
			{
				self.pev.frame = 0;
				SetThink(null);
			}
			else
			{
				NextThink(self.pev.ltime + 0.1, false);
				SetThink(ThinkFunction(this.RestoreFx));
			}
		}
		else
		{
			SetThink(null);
		}
	}
}

class CTriggerHUDSprite : ScriptBaseEntity
{
	string m_szText = "";
	float m_flTextOffsetX = 0;
	float m_flTextOffsetY = 0;
	int m_iTextChannel = 1;

	string m_szSpriteName = "";
	string m_szSoundName = "";
	int m_nFrameNum = 0;
	float m_flOffsetX = 0;
	float m_flOffsetY = 0;
	int m_nSprWidth = 0;
	int m_nSprHeight = 0;
	int m_iChannel = 14;
	float m_flHoldTime = 1.0;
	RGBA m_Color = RGBA_WHITE;

	void Precache()
	{
		BaseClass.Precache();
		if(!m_szSpriteName.IsEmpty()){
			g_Game.PrecacheModel( "sprites/" +  m_szSpriteName );
    		g_Game.PrecacheGeneric("sprites/" + m_szSpriteName );
		}
		if(!m_szSoundName.IsEmpty()){
			g_SoundSystem.PrecacheSound( m_szSoundName );
		}
	}

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		if(szKey == "sprite"){
		    m_szSpriteName = szValue;
			return true;
		}
		if(szKey == "framenum"){
			m_nFrameNum = atoi(szValue);
			return true;
		}
		if(szKey == "holdtime"){
			m_flHoldTime = atof(szValue);
			return true;
		}
		if(szKey == "sound"){
		    m_szSoundName = szValue;
			return true;
		}
		if(szKey == "offsetx"){
		    m_flOffsetX = atof(szValue);
			return true;
		}
		if(szKey == "offsety"){
		    m_flOffsetY = atof(szValue);
			return true;
		}
		if(szKey == "channel"){
		    m_iChannel = atoi(szValue);
			return true;
		}
		if(szKey == "sprwidth"){
		    m_nSprWidth = atoi(szValue);
			return true;
		}
		if(szKey == "sprheight"){
		    m_nSprHeight = atoi(szValue);
			return true;
		}
		if(szKey == "text"){
		    m_szText = szValue;
			return true;
		}
		if(szKey == "textoffsetx"){
		    m_flTextOffsetX = atof(szValue);
			return true;
		}
		if(szKey == "textoffsety"){
		    m_flTextOffsetY = atof(szValue);
			return true;
		}
		if(szKey == "textchannel"){
		    m_iTextChannel = atoi(szValue);
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void SendText( CBasePlayer@ pPlayer, const string& in str, float hold = 0.8 )
	{
		g_PlayerFuncs.HudToggleElement(pPlayer, m_iTextChannel, true);

		HUDTextParams textParams;
		textParams.x = -1;
		textParams.y = 0.70;
		textParams.effect = 0;
		textParams.r1 = 255;
		textParams.g1 = 255;
		textParams.b1 = 255;
		textParams.a1 = 255;
		textParams.r2 = 255;
		textParams.g2 = 255;
		textParams.b2 = 255;
		textParams.a2 = 255;
		textParams.fadeinTime = 0.1;
		textParams.fadeoutTime = 0.1;
		textParams.holdTime = hold;
		textParams.fxTime = 0.0;
		textParams.channel = m_iTextChannel;
		g_PlayerFuncs.HudMessage(pPlayer, textParams, str);
	}
	
	void SendSprite( CBasePlayer@ pPlayer, const string& in strName, uint framenum = 0, float hold = 0.8 )
	{
		g_PlayerFuncs.HudToggleElement(pPlayer, m_iChannel, true);

		HUDSpriteParams params;
		params.channel = m_iChannel;
		params.flags = HUD_SPR_MASKED; 
		if((self.pev.spawnflags & 1) == 1)
			params.flags |= HUD_ELEM_SCR_CENTER_X;
		if((self.pev.spawnflags & 2) == 2)
			params.flags |= HUD_ELEM_SCR_CENTER_Y;
		params.spritename = strName;
		params.x = m_flOffsetX;
		params.y = m_flOffsetY;
		params.framerate = 0;
		params.frame = framenum;
		params.holdTime = hold;
		params.color1 = m_Color;
		params.fadeoutTime = 0.1;
		params.width = m_nSprWidth;
		params.height = m_nSprHeight;
		g_PlayerFuncs.HudCustomSprite( pPlayer, params );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(!m_szSpriteName.IsEmpty())
		{
			if(useType == USE_OFF)
			{
				if(pActivator !is null && pActivator.IsPlayer() && pActivator.IsNetClient())
				{
					CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pActivator);
					if(pPlayer.IsConnected())
						g_PlayerFuncs.HudToggleElement(pPlayer, m_iChannel, false);
				}
				else
				{
					for (int i = 1; i <= g_Engine.maxClients; i++)
					{
						CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
						if(pPlayer !is null && pPlayer.IsConnected())
							g_PlayerFuncs.HudToggleElement(pPlayer, m_iChannel, false);
					}
				}
			}
			else
			{
				if(pActivator !is null && pActivator.IsPlayer() && pActivator.IsNetClient())
				{
					CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pActivator);
					if(pPlayer.IsConnected())
						SendSprite(pPlayer, m_szSpriteName, m_nFrameNum, m_flHoldTime);
				}
				else
				{
					for (int i = 1; i <= g_Engine.maxClients; i++)
					{
						CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
						if(pPlayer !is null && pPlayer.IsConnected())
							SendSprite(pPlayer, m_szSpriteName, m_nFrameNum, m_flHoldTime);
					}
				}
			}
		}

		if(!m_szSoundName.IsEmpty())
		{
			if(useType == USE_OFF)
			{

			}
			else
			{
				if(pActivator !is null && pActivator.IsPlayer() && pActivator.IsNetClient())
				{
					CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pActivator);
					
					g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_MUSIC, m_szSoundName, 1, 0.01, 0, PITCH_NORM, pPlayer.entindex());
				}
				else
				{
					for (int i = 1; i <= g_Engine.maxClients; i++)
					{
						CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
						if(pPlayer !is null && pPlayer.IsConnected())
						{
							g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_MUSIC, m_szSoundName, 1, 0.01, 0, PITCH_NORM, pPlayer.entindex());
						}
					}
				}
			}
		}

		if(!m_szText.IsEmpty())
		{
			if(useType == USE_OFF)
			{

			}
			else
			{
				if(pActivator !is null && pActivator.IsPlayer() && pActivator.IsNetClient())
				{
					CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pActivator);

					if((self.pev.spawnflags & 8) == 8){
						SendText(pPlayer, m_szText + int(flValue), m_flHoldTime);
					} else {
						SendText(pPlayer, m_szText, m_flHoldTime);
					}
				}
				else
				{
					for (int i = 1; i <= g_Engine.maxClients; i++)
					{
						CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
						if(pPlayer !is null && pPlayer.IsConnected())
						{
							if((self.pev.spawnflags & 8) == 8){
								SendText(pPlayer, m_szText + int(flValue), m_flHoldTime);
							} else {
								SendText(pPlayer, m_szText, m_flHoldTime);
							}
						}
					}
				}
			}
		}
	}
}

class CTriggerHUDCountdown : ScriptBaseEntity
{
	int m_nCountNum = 0;
	int m_nCurrentCount = 0;
	int m_nCurrentAccum = 0;
	float m_flOffsetX = 0;
	float m_flOffsetY = 0;
	int m_iChannel = 15;
	RGBA m_Color = RGBA_WHITE;
	string m_szFinalTarget = "";
	int m_iTriggerState = USE_TOGGLE;
	float m_flTriggerValue = 0;

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		if(szKey == "countnum"){
			m_nCountNum = atoi(szValue);
			return true;
		}
		if(szKey == "offsetx"){
		    m_flOffsetX = atof(szValue);
			return true;
		}
		if(szKey == "offsety"){
		    m_flOffsetY = atof(szValue);
			return true;
		}
		if(szKey == "channel"){
		    m_iChannel = atoi(szValue);
			return true;
		}
		if(szKey == "finaltarget"){
		    m_szFinalTarget = szValue;
			return true;
		}

		if(szKey == "triggerstate"){
			m_iTriggerState = atoi(szValue);
			return true;
		}

		if(szKey == "triggervalue"){
			m_flTriggerValue = atof(szValue);
			return true;
		}
		
		return BaseClass.KeyValue( szKey, szValue );
	}

	void SendCountdown( CBasePlayer@ pPlayer, float countnum = 0.0, float hold = 0.8 )
	{
		g_PlayerFuncs.HudToggleElement(pPlayer, m_iChannel, true);

		HUDNumDisplayParams params;
		params.channel = m_iChannel;
		params.flags = HUD_TIME_MINUTES | HUD_TIME_SECONDS | HUD_TIME_COUNT_DOWN; 
		if((self.pev.spawnflags & 1) == 1)
			params.flags |= HUD_ELEM_SCR_CENTER_X;
		if((self.pev.spawnflags & 2) == 2)
			params.flags |= HUD_ELEM_SCR_CENTER_Y;
		params.value = countnum;
		params.defdigits = 4;
		params.maxdigits = 4;
		params.x = m_flOffsetX;
		params.y = m_flOffsetY;
		params.holdTime = hold;
		params.color1 = m_Color;
		params.fadeoutTime = 0.2;

		g_PlayerFuncs.HudTimeDisplay(pPlayer, params);

		//g_Game.AlertMessage( at_console, "Send Countdown to %1\n", pPlayer.pev.netname );
	}

	void UpdateCountdown( CBasePlayer@ pPlayer, float countnum = 0.0 )
	{
		g_PlayerFuncs.HudUpdateTime(pPlayer, m_iChannel, countnum);
	}

	void Think()
	{
		if(m_nCurrentCount > 0)
		{
			for (int i = 1; i <= g_Engine.maxClients; i++)
			{
				CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
				if(pPlayer !is null && pPlayer.IsConnected())
				{
					if((m_nCurrentAccum % 5) == 0)
						SendCountdown(pPlayer, m_nCurrentCount, m_nCurrentCount);
					else
						UpdateCountdown(pPlayer, m_nCurrentCount);
				}
			}

			m_nCurrentAccum += 1;
			m_nCurrentCount -= 1;

			//Fire target when count down to zero?
			if(m_nCurrentCount == 0)
			{
				if(!m_szFinalTarget.IsEmpty())
				{
					g_EntityFuncs.FireTargets( m_szFinalTarget, self, self, USE_TYPE(m_iTriggerState), m_flTriggerValue );
				}
			}
			else
			{
				if(!string(self.pev.target).IsEmpty())
				{
					g_EntityFuncs.FireTargets( self.pev.target, self, self, USE_SET, float(m_nCurrentCount) );
				}
			}

			self.pev.nextthink = g_Engine.time + 1.0;
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_TOGGLE)
		{
			if(m_nCurrentCount == 0)
			{
				m_nCurrentCount = m_nCountNum;
				m_nCurrentAccum = 0;
				Think();
			}
			else
			{
				m_nCurrentCount = m_nCountNum;
				m_nCurrentAccum = 0;
				self.pev.nextthink = 0;
			}
		}
		else if(useType == USE_ON)
		{
			m_nCurrentCount = m_nCountNum;
			m_nCurrentAccum = 0;
			Think();
		}
		else if(useType == USE_OFF)
		{
			if(m_nCurrentCount > 0)
			{
				for (int i = 1; i <= g_Engine.maxClients; i++)
				{
					CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
					if(pPlayer !is null && pPlayer.IsConnected())
					{
						SendCountdown(pPlayer, 0, 0);
					}
				}
			}

			m_nCurrentCount = m_nCountNum;
			m_nCurrentAccum = 0;
			self.pev.nextthink = 0;
		}
		else if(useType == USE_SET && flValue > 0)
		{
			//Update countdown on the fly?
			if(int(flValue) < m_nCurrentCount)
			{
				//g_Game.AlertMessage( at_console, "Reset Countdown to %1\n", int(flValue) );
				
				m_nCurrentCount = int(flValue);
				m_nCurrentAccum = 0;
				Think();
			}
		}
	}
}

class CTriggerSpectator : ScriptBaseEntity
{
	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		return BaseClass.KeyValue( szKey, szValue );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_TOGGLE)
		{
			if ( pActivator is null || !pActivator.IsPlayer())
				return;

			CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pActivator);

			pPlayer.pev.health = 0.0;
			pPlayer.pev.deadflag = DEAD_DYING;
			pPlayer.pev.takedamage = DAMAGE_NO;
			pPlayer.pev.movetype = MOVETYPE_NOCLIP;
			pPlayer.pev.solid = SOLID_NOT;
			pPlayer.pev.gamestate = 1;
			pPlayer.pev.effects |= EF_NODRAW;
			pPlayer.GetObserver().StartObserver( pPlayer.pev.origin, pPlayer.pev.angles, false );
			pPlayer.GetObserver().SetMode(OBS_CHASE_LOCKED);
			pPlayer.GetObserver().SetObserverModeControlEnabled(true);
			pPlayer.SetMaxSpeedOverride( -1 );
			pPlayer.m_flRespawnDelayTime = 999999;

			//Persistent
			if((self.pev.spawnflags & 1) == 1)
			{
				g_ArraySpectatorPlayer[pPlayer.entindex()] = true;
			}
		}
		else if(useType == USE_ON)
		{
			
		}
		else if(useType == USE_OFF)
		{
			
		}
	}
}

class CTriggerSortScore : ScriptBaseEntity
{
	int m_iSortType = 0;
	float m_flTriggerDelay = 0;
	string m_szFinalTarget = "";
	string m_szPitchSound = "";
	int m_iBasePitch = 100.0;
	int m_iAddPitch = 0.0;

	int m_iLastTriggerPlayerIndex = 0;
	int m_iTriggerPlayerCount = 0;
	USE_TYPE m_iLastUseType = USE_TOGGLE;
	float m_flEstFrags = 0;

	void Precache()
	{
		BaseClass.Precache();
		
		g_SoundSystem.PrecacheSound( m_szPitchSound );
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		if(szKey == "sorttype"){
			m_iSortType = atoi(szValue);
			return true;
		}
		if(szKey == "delay"){
			m_flTriggerDelay = atof(szValue);
			return true;
		}
		if(szKey == "finaltarget"){
			m_szFinalTarget = szValue;
			return true;
		}
		if(szKey == "pitchsound"){
			m_szPitchSound = szValue;
			return true;
		}
		if(szKey == "basepitch"){
			m_iBasePitch = atoi(szValue);
			return true;
		}
		if(szKey == "addpitch"){
			m_iAddPitch = atoi(szValue);
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Think()
	{
		if(m_flTriggerDelay > 0 && m_iLastTriggerPlayerIndex > 0)
		{
			for (int i = m_iLastTriggerPlayerIndex + 1; i <= g_Engine.maxClients; i++)
			{
				CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
				if(IsPlayerAvailable(pPlayer))
				{
					if((m_iSortType == 0 && pPlayer.pev.frags == m_flEstFrags) ||
						(m_iSortType == 1 && pPlayer.pev.frags < m_flEstFrags)){
						
						g_EntityFuncs.FireTargets( self.pev.target, cast<CBaseEntity@>(@pPlayer), self, m_iLastUseType );

						if(m_szPitchSound != ""){
							int iPitch = (m_iBasePitch + m_iTriggerPlayerCount * m_iAddPitch);
							if(iPitch > 255)
								iPitch = 255;
							if(iPitch < 50)
								iPitch = 50;
							g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_STATIC, m_szPitchSound, 1.0, 0.01, 0, iPitch );
						}

						m_iLastTriggerPlayerIndex = i;
						m_iTriggerPlayerCount ++;
						
						self.pev.nextthink = g_Engine.time + m_flTriggerDelay;
						return;
					}
					else if((m_iSortType == 2 && pPlayer.pev.frags == m_flEstFrags) ||
						(m_iSortType == 3 && pPlayer.pev.frags > m_flEstFrags)){
						
						g_EntityFuncs.FireTargets( self.pev.target, cast<CBaseEntity@>(@pPlayer), self, m_iLastUseType );
						
						if(m_szPitchSound != ""){
							int iPitch = (m_iBasePitch + m_iTriggerPlayerCount * m_iAddPitch);
							if(iPitch > 255)
								iPitch = 255;
							if(iPitch < 50)
								iPitch = 50;
							g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_STATIC, m_szPitchSound, 1.0, 0.01, 0, iPitch );
						}

						m_iLastTriggerPlayerIndex = i;
						m_iTriggerPlayerCount ++;
						
						self.pev.nextthink = g_Engine.time + m_flTriggerDelay;
						return;
					}
				}
			}

			//No player found, end progress
			m_iLastTriggerPlayerIndex = 0;
			m_iTriggerPlayerCount = 0;

			if(m_szFinalTarget != "")
			{
				g_EntityFuncs.FireTargets( m_szFinalTarget, self, self, m_iLastUseType );
			}
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		//Denied if in progress

		if(m_flTriggerDelay > 0 && m_iLastTriggerPlayerIndex > 0)
			return;

		if(m_iSortType == 0 || m_iSortType == 1)
		{
			float highestfrags = -99999.0;
			bool bFoundHighest = false;
			bool bHasNext = false;
			for (int i = 1; i <= g_Engine.maxClients; i++)
			{
				CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
				if(IsPlayerAvailable(pPlayer))
				{
					if(!bFoundHighest || pPlayer.pev.frags > highestfrags){
						bFoundHighest = true;
						highestfrags = pPlayer.pev.frags;
					}
				}
			}
			
			if(bFoundHighest){

				m_flEstFrags = highestfrags;
				m_iLastUseType = useType;

				//g_Game.AlertMessage( at_console, "highestfrags - %1\n", highestfrags );

				for (int i = 1; i <= g_Engine.maxClients; i++)
				{
					CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
					if(IsPlayerAvailable(pPlayer))
					{
						if((m_iSortType == 0 && pPlayer.pev.frags == highestfrags) || (m_iSortType == 1 && pPlayer.pev.frags < highestfrags))
						{
							g_EntityFuncs.FireTargets( self.pev.target, cast<CBaseEntity@>(@pPlayer), self, useType );

							if(m_szPitchSound != ""){
								int iPitch = (m_iBasePitch + m_iTriggerPlayerCount * m_iAddPitch);
								if(iPitch > 255)
									iPitch = 255;
								if(iPitch < 50)
									iPitch = 50;
								g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_STATIC, m_szPitchSound, 1.0, 0.01, 0, iPitch );
								//g_EntityFuncs.FireTargets( m_szPitchSound, cast<CBaseEntity@>(@pPlayer), self, USE_SET, flPitch);
							}
							
							m_iLastTriggerPlayerIndex = i;
							m_iTriggerPlayerCount ++;

							//g_Game.AlertMessage( at_console, "Trigger player %1\n", pPlayer.pev.netname );

							if(m_flTriggerDelay > 0){
								bHasNext = true;
								self.pev.nextthink = g_Engine.time + m_flTriggerDelay;
								return;
							}
						}
					}
				}

				if(!bHasNext && m_szFinalTarget != "")
				{
					g_EntityFuncs.FireTargets( m_szFinalTarget, self, self, useType );
				}
			}
		}
		else if(m_iSortType == 2 || m_iSortType == 3)
		{
			float lowestfrags = 99999.0;
			bool bFoundLowest = false;
			bool bHasNext = false;
			for (int i = 1; i <= g_Engine.maxClients; i++)
			{
				CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
				if(IsPlayerAvailable(pPlayer))
				{
					if(!bFoundLowest || lowestfrags < pPlayer.pev.frags){
						bFoundLowest = true;
						lowestfrags = pPlayer.pev.frags;
					}
				}
			}
			
			if(bFoundLowest){

				m_flEstFrags = lowestfrags;
				m_iLastUseType = useType;

				for (int i = 1; i <= g_Engine.maxClients; i++)
				{
					CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
					if(IsPlayerAvailable(pPlayer))
					{
						if((m_iSortType == 2 && pPlayer.pev.frags == lowestfrags) || (m_iSortType == 3 && pPlayer.pev.frags > lowestfrags))
						{
							g_EntityFuncs.FireTargets( self.pev.target, cast<CBaseEntity@>(@pPlayer), self, useType );
							
							if(m_szPitchSound != ""){
								int iPitch = (m_iBasePitch + m_iTriggerPlayerCount * m_iAddPitch);
								if(iPitch > 255)
									iPitch = 255;
								if(iPitch < 50)
									iPitch = 50;
								g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_STATIC, m_szPitchSound, 1.0, 0.01, 0, iPitch );
								//g_EntityFuncs.FireTargets( m_szPitchSound, cast<CBaseEntity@>(@pPlayer), self, USE_SET, flPitch);
							}

							m_iLastTriggerPlayerIndex = i;
							m_iTriggerPlayerCount ++;

							if(m_flTriggerDelay > 0){
								bHasNext = true;
								self.pev.nextthink = g_Engine.time + m_flTriggerDelay;
								return;
							}
						}
					}
				}

				if(!bHasNext && m_szFinalTarget != "")
				{
					g_EntityFuncs.FireTargets( m_szFinalTarget, self, self, useType );
				}
			}
		}
	}
}

class CTriggerRespawnUnstuck : ScriptBaseEntity
{
	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		return BaseClass.KeyValue( szKey, szValue );
	}

	void RespawnAllPlayers()
	{
		array<CBaseEntity@> spawnpoints = {};
		array<CBasePlayer@> players = {};

		for (int i = 1; i <= g_Engine.maxClients; i++)
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
			if( IsPlayerAvailable(pPlayer) )
			{
				players.insertLast(pPlayer);
			}
		}

		if(players.length() > 0)
		{
			CBaseEntity@ pEntity = null;
			while((@pEntity = g_EntityFuncs.FindEntityByClassname(pEntity, "info_player_deathmatch")) !is null)
			{
				if(g_PlayerFuncs.IsSpawnPointValid(pEntity, players[0]))
				{
					spawnpoints.insertLast(pEntity);
				}
			}
		}

		for (int i = 0; i < int(players.length()); i++)
		{
			CBasePlayer@ pPlayer = players[i];
			if(spawnpoints.length() > 0)
			{
				int randomIndex = Math.RandomLong(0, spawnpoints.length() - 1);
				CBaseEntity@ pEntity = spawnpoints[randomIndex];

				g_PlayerFuncs.RespawnPlayer(pPlayer, true, true);
				g_EntityFuncs.SetOrigin(pPlayer, pEntity.pev.origin);
				pPlayer.pev.velocity = Vector(0, 0, 0);
				pPlayer.pev.angles = pEntity.pev.angles;

				spawnpoints.removeAt(randomIndex);
			}
			else
			{
				break;
			}
		}
	}

	void RespawnTeamPlayers(int team)
	{
		array<CBaseEntity@> spawnpoints = {};
		array<CBasePlayer@> players = {};

		for (int i = 1; i <= g_Engine.maxClients; i++)
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
			if( IsPlayerAvailable(pPlayer) && pPlayer.Classify() == team )
			{
				players.insertLast(pPlayer);
			}
		}

		if(players.length() > 0)
		{
			CBaseEntity@ pEntity = null;
			while((@pEntity = g_EntityFuncs.FindEntityByClassname(pEntity, "info_player_deathmatch")) !is null)
			{
				if(g_PlayerFuncs.IsSpawnPointValid(pEntity, players[0]) && int(pEntity.pev.frags) == team)
				{
					spawnpoints.insertLast(pEntity);
				}
			}
		}

		for (int i = 0; i < int(players.length()); i++)
		{
			CBasePlayer@ pPlayer = players[i];
			if(spawnpoints.length() > 0)
			{
				int randomIndex = Math.RandomLong(0, spawnpoints.length() - 1);
				CBaseEntity@ pEntity = spawnpoints[randomIndex];

				g_PlayerFuncs.RespawnPlayer(pPlayer, true, true);
				g_EntityFuncs.SetOrigin(pPlayer, pEntity.pev.origin);
				pPlayer.pev.velocity = Vector(0, 0, 0);
				pPlayer.pev.angles = pEntity.pev.angles;

				spawnpoints.removeAt(randomIndex);
			}
			else
			{
				break;
			}
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if((self.pev.spawnflags & SF_TEAMPLAY_HAS_BLUE) == SF_TEAMPLAY_HAS_BLUE)
		{
			RespawnTeamPlayers(16);
		}

		if((self.pev.spawnflags & SF_TEAMPLAY_HAS_RED) == SF_TEAMPLAY_HAS_RED)
		{
			RespawnTeamPlayers(17);
		}
		
		if((self.pev.spawnflags & SF_TEAMPLAY_HAS_YELLOW) == SF_TEAMPLAY_HAS_YELLOW)
		{
			RespawnTeamPlayers(18);
		}

		if((self.pev.spawnflags & SF_TEAMPLAY_HAS_GREEN) == SF_TEAMPLAY_HAS_GREEN)
		{
			RespawnTeamPlayers(19);
		}
		
		if((self.pev.spawnflags & (SF_TEAMPLAY_HAS_BLUE | SF_TEAMPLAY_HAS_RED | SF_TEAMPLAY_HAS_YELLOW | SF_TEAMPLAY_HAS_GREEN)) == 0)
		{
			RespawnAllPlayers();
		}
	}
}

class CTriggerRotControl : ScriptBaseEntity
{
	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		return BaseClass.KeyValue( szKey, szValue );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		//g_Game.AlertMessage( at_console, "Accelerating by %1, target %2\n", self.pev.targetname, self.pev.target);

		if(string(self.pev.target).IsEmpty())
			return;

		if(useType == USE_TOGGLE || useType == USE_ON)
		{
			if(string(self.pev.target) == "!activator")
			{
				pActivator.Use(self, self, USE_SET, self.pev.speed);
			}
			else
			{
				g_EntityFuncs.FireTargets( self.pev.target, self, self, USE_SET, self.pev.speed );
			}
		}
	}
}

class CTriggerRandomCounter : ScriptBaseEntity
{
	int m_iMinValue = 0;
	int m_iMaxValue = 1;
	array<string> m_szTargetArray = {};

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		if(szKey == "minvalue"){
			m_iMinValue = atoi(szValue);
			return true;
		}

		if(szKey == "maxvalue"){
			m_iMaxValue = atoi(szValue);
			return true;
		}

		if(szKey.StartsWith("target") && szKey != "targetname")
		{
			m_szTargetArray.insertLast(szValue);
		}
	
		return BaseClass.KeyValue( szKey, szValue );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if((self.pev.spawnflags & 1) == 1)
		{
			array<int> rnd( m_szTargetArray.length() );

			for (int i = 0; i < int(m_szTargetArray.length()); i++)
			{
				rnd[i] = (i % (1 + m_iMaxValue - m_iMinValue)) + m_iMinValue;
			}

			for (int i = int(m_szTargetArray.length()) - 1; i >= 0; i --) {
				int randomIndex = g_PlayerFuncs.SharedRandomLong( uint(g_Engine.time * 100.0) + i, 0, i );//Math.RandomLong(0, i);
				int temp = rnd[randomIndex];
				rnd[randomIndex] = rnd[i];
				rnd[i] = temp;
			}

			for (int i = 0; i < int(m_szTargetArray.length()); i++)
			{
				g_EntityFuncs.FireTargets( m_szTargetArray[i], ((self.pev.spawnflags & 16) == 16) ? pActivator : self, self, USE_SET, float(rnd[i]) );
				//g_Game.AlertMessage( at_console, "SetAverage %1 to %2\n", m_szTargetArray[i], float(rnd[i]) );
			}
		}
		else
		{
			for (int i = 0; i < int(m_szTargetArray.length()); i++)
			{
				int rnd = g_PlayerFuncs.SharedRandomLong( uint(g_Engine.time * 100.0) + i, m_iMinValue, m_iMaxValue );
				g_EntityFuncs.FireTargets( m_szTargetArray[i], ((self.pev.spawnflags & 16) == 16) ? pActivator : self, self, USE_SET, float(rnd) );
				//g_Game.AlertMessage( at_console, "Set %1 to %2\n", m_szTargetArray[i], float(rnd) );
			}
		}
	}
}

class CTriggerRandomMultiple : ScriptBaseEntity
{
	int m_iMinCount = 0;
	int m_iMaxCount = 1;
	array<string> m_szTargetArray = {};

	int m_iTriggerState = -1;
	float m_flTriggerValue = 0.0;

	float m_flFireDuration = 0;

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		if(szKey == "mincount"){
			m_iMinCount = atoi(szValue);
			return true;
		}

		if(szKey == "maxcount"){
			m_iMaxCount = atoi(szValue);
			return true;
		}

		if(szKey == "triggerstate"){
			m_iTriggerState = atoi(szValue);
			return true;
		}

		if(szKey == "triggervalue"){
			m_flTriggerValue = atof(szValue);
			return true;
		}

		if(szKey.StartsWith("target") && szKey != "targetname" && szKey != "target_count")
		{
			m_szTargetArray.insertLast(szValue);
		}

		if(szKey == "fireduration"){
			m_flFireDuration = atof(szValue);
			return true;
		}
	
		return BaseClass.KeyValue( szKey, szValue );
	}

	void FireInternal( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		array<int> rnd( m_szTargetArray.length() );

		for (int i = 0; i < int(m_szTargetArray.length()); i++)
		{
			rnd[i] = i;
		}

		for (int i = int(m_szTargetArray.length()) - 1; i >= 0; i --) {
			int randomIndex = g_PlayerFuncs.SharedRandomLong( uint(g_Engine.time * 100.0) + i, 0, i );//Math.RandomLong(0, i);
			int temp = rnd[randomIndex];
			rnd[randomIndex] = rnd[i];
			rnd[i] = temp;
		}

		int count = g_PlayerFuncs.SharedRandomLong( uint(g_Engine.time * 100.0), m_iMinCount, m_iMaxCount );

		for (int i = 0; i < count; i++)
		{
			if(m_iTriggerState < 0)
			{
				g_EntityFuncs.FireTargets( m_szTargetArray[rnd[i]], ((self.pev.spawnflags & 16) == 16) ? pActivator : self, self, useType, flValue );
			}
			else
			{
				g_EntityFuncs.FireTargets( m_szTargetArray[rnd[i]], ((self.pev.spawnflags & 16) == 16) ? pActivator : self, self, USE_TYPE(m_iTriggerState), m_flTriggerValue );
			}
			//g_Game.AlertMessage( at_console, "TriggerRandom %1\n", m_szTargetArray[rnd[i]] );
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if((self.pev.spawnflags & 1) == 1)
		{
			if(useType == USE_ON)
			{
				SetThink(ThinkFunction(this.FireThink));
				self.pev.nextthink = g_Engine.time + m_flFireDuration;
				return;
			}
			else if(useType == USE_OFF)
			{
				SetThink(null);
				self.pev.nextthink = 0;
				return;
			}
		}

		FireInternal(pActivator, pCaller, useType, flValue);
	}

	void FireThink()
	{
		FireInternal(self, self, USE_TYPE(m_iTriggerState), m_flTriggerValue);

		self.pev.nextthink = g_Engine.time + m_flFireDuration;
	}
}

class CTriggerRandomPath : ScriptBaseEntity
{
	int m_iColCount = 0;
	int m_iRowCount = 0;
	string m_szTargetNamePrefix = "";

	int m_iTriggerState = -1;
	float m_flTriggerValue = 0.0;

	string m_szCellConnector = "";

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		if(szKey == "colcount"){
			m_iColCount = atoi(szValue);
			return true;
		}

		if(szKey == "rowcount"){
			m_iRowCount = atoi(szValue);
			return true;
		}

		if(szKey == "targetname_prefix"){
			m_szTargetNamePrefix = szValue;
			return true;
		}

		if(szKey == "cellconnector"){
			m_szCellConnector = szValue;
			return true;
		}

		if(szKey == "triggerstate"){
			m_iTriggerState = atoi(szValue);
			return true;
		}

		if(szKey == "triggervalue"){
			m_flTriggerValue = atof(szValue);
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	int GetCellIndex(int row, int col)
	{
		return row * m_iColCount + col;
	}

	int GetCellColumn(int idx)
	{
		return idx % m_iColCount;
	}

	int GetCellRow(int idx)
	{
		return idx / m_iColCount;
	}

	void FireCell(int cell, CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(m_szTargetNamePrefix.IsEmpty())
			return;

		string targetname = m_szTargetNamePrefix + cell;

		//g_Game.AlertMessage( at_console, "Fire %1 \n", targetname);

		if(m_iTriggerState < 0)
		{
			g_EntityFuncs.FireTargets( targetname, ((self.pev.spawnflags & 16) == 16) ? pActivator : self, self, useType, flValue );
		}
		else
		{
			g_EntityFuncs.FireTargets( targetname, ((self.pev.spawnflags & 16) == 16) ? pActivator : self, self, USE_TYPE(m_iTriggerState), m_flTriggerValue );
		}
	}

	void FireConnector(int cell_1, int cell_2, CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(m_szCellConnector.IsEmpty())
			return;

		//g_Game.AlertMessage( at_console, "FireConnector %1 %2 \n", cell_1, cell_2);

		string targetname_1 = m_szTargetNamePrefix + cell_1;

		CBaseEntity @pCell_1 = g_EntityFuncs.FindEntityByTargetname( null, targetname_1 );

		if(pCell_1 is null)
			return;

		string targetname_2 = m_szTargetNamePrefix + cell_2;

		CBaseEntity @pCell_2 = g_EntityFuncs.FindEntityByTargetname( null, targetname_2 );

		if(pCell_2 is null)
			return;

		CBaseEntity @pConnector = g_EntityFuncs.FindEntityByTargetname( null, m_szCellConnector );

		if(pConnector is null)
			return;

		pConnector.pev.origin = (pCell_1.pev.origin + pCell_2.pev.origin) * 0.5;
		pConnector.Use(((self.pev.spawnflags & 16) == 16) ? pActivator : self, self, USE_TYPE(m_iTriggerState), m_flTriggerValue);
	}

	void FireQuadConnector(int cell_1, int cell_2, int cell_3, int cell_4, CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(m_szCellConnector.IsEmpty())
			return;

		//g_Game.AlertMessage( at_console, "FireQuadConnector %1 %2 %3 %4 \n", cell_1, cell_2, cell_3, cell_4);

		string targetname_1 = m_szTargetNamePrefix + cell_1;

		CBaseEntity @pCell_1 = g_EntityFuncs.FindEntityByTargetname( null, targetname_1 );

		if(pCell_1 is null)
			return;

		string targetname_2 = m_szTargetNamePrefix + cell_2;

		CBaseEntity @pCell_2 = g_EntityFuncs.FindEntityByTargetname( null, targetname_2 );

		if(pCell_2 is null)
			return;

		string targetname_3 = m_szTargetNamePrefix + cell_3;

		CBaseEntity @pCell_3 = g_EntityFuncs.FindEntityByTargetname( null, targetname_3 );

		if(pCell_3 is null)
			return;

		string targetname_4 = m_szTargetNamePrefix + cell_4;

		CBaseEntity @pCell_4 = g_EntityFuncs.FindEntityByTargetname( null, targetname_4 );

		if(pCell_4 is null)
			return;

		CBaseEntity @pConnector = g_EntityFuncs.FindEntityByTargetname( null, m_szCellConnector );

		if(pConnector is null)
			return;

		pConnector.pev.origin = (pCell_1.pev.origin + pCell_2.pev.origin + pCell_3.pev.origin + pCell_4.pev.origin) * 0.25;
		pConnector.Use(((self.pev.spawnflags & 16) == 16) ? pActivator : self, self, USE_TYPE(m_iTriggerState), m_flTriggerValue);
	}

	array<int> GetReachableCell(array<int>@ matrix, int currentCell)
	{
		array<int> reachable = {};

		int row = GetCellRow(currentCell);
		int col = GetCellColumn(currentCell);
		if(col == 0)
		{
			if(row == m_iRowCount - 1){
				if(matrix[GetCellIndex(row, col + 1)] == 0)
					reachable.insertLast(GetCellIndex(row, col + 1));
				return reachable;
			}

			if(matrix[GetCellIndex(row + 1, col)] == 0)
				reachable.insertLast(GetCellIndex(row + 1, col));

			if(matrix[GetCellIndex(row, col + 1)] == 0)
				reachable.insertLast(GetCellIndex(row, col + 1));

			return reachable;
		}
		else if(col == m_iColCount - 1)
		{
			if(row == m_iRowCount - 1){
				if(matrix[GetCellIndex(row, col - 1)] == 0)
					reachable.insertLast(GetCellIndex(row, col - 1));
				return reachable;
			}

			if(matrix[GetCellIndex(row + 1, col)] == 0)	
				reachable.insertLast(GetCellIndex(row + 1, col));
			
			if(matrix[GetCellIndex(row, col - 1)] == 0)	
				reachable.insertLast(GetCellIndex(row, col - 1));
			
			return reachable;
		}

		if(row == m_iRowCount - 1){
			if(matrix[GetCellIndex(row, col - 1)] == 0)	
				reachable.insertLast(GetCellIndex(row, col - 1));

			if(matrix[GetCellIndex(row, col + 1)] == 0)	
				reachable.insertLast(GetCellIndex(row, col + 1));
		
			return reachable;
		}

		if(matrix[GetCellIndex(row + 1, col)] == 0)	
			reachable.insertLast(GetCellIndex(row + 1, col));

		if(matrix[GetCellIndex(row, col - 1)] == 0)	
			reachable.insertLast(GetCellIndex(row, col - 1));
		
		if(matrix[GetCellIndex(row, col + 1)] == 0)	
			reachable.insertLast(GetCellIndex(row, col + 1));

		return reachable;
	}

	array<int> GetLinkableCell(array<int>@ matrix, int currentCell)
	{
		array<int> linkable = {};

		int row = GetCellRow(currentCell);
		int col = GetCellColumn(currentCell);
		if(col == 0)
		{
			if(row == m_iRowCount - 1){

				if(matrix[GetCellIndex(row, col + 1)] == 1)
					linkable.insertLast(GetCellIndex(row, col + 1));

				if(row > 0 && matrix[GetCellIndex(row - 1, col)] == 1)
					linkable.insertLast(GetCellIndex(row - 1, col));

				return linkable;
			}

			if(matrix[GetCellIndex(row + 1, col)] == 1)
				linkable.insertLast(GetCellIndex(row + 1, col));

			if(matrix[GetCellIndex(row, col + 1)] == 1)
				linkable.insertLast(GetCellIndex(row, col + 1));

			if(row > 0 && matrix[GetCellIndex(row - 1, col)] == 1)
				linkable.insertLast(GetCellIndex(row - 1, col));

			return linkable;
		}
		else if(col == m_iColCount - 1)
		{
			if(row == m_iRowCount - 1){

				if(col > 0 && matrix[GetCellIndex(row, col - 1)] == 1)
					linkable.insertLast(GetCellIndex(row, col - 1));

				if(row > 0 && matrix[GetCellIndex(row - 1, col - 1)] == 1)
					linkable.insertLast(GetCellIndex(row - 1, col - 1));

				return linkable;
			}

			if(matrix[GetCellIndex(row + 1, col)] == 1)	
				linkable.insertLast(GetCellIndex(row + 1, col));
			
			if(col > 0 && matrix[GetCellIndex(row, col - 1)] == 1)	
				linkable.insertLast(GetCellIndex(row, col - 1));
			
			if(row > 0 && matrix[GetCellIndex(row - 1, col)] == 1)	
				linkable.insertLast(GetCellIndex(row - 1, col));
			
			return linkable;
		}

		if(row == m_iRowCount - 1){

			if(col > 0 && matrix[GetCellIndex(row, col - 1)] == 1)	
				linkable.insertLast(GetCellIndex(row, col - 1));

			if(matrix[GetCellIndex(row, col + 1)] == 1)	
				linkable.insertLast(GetCellIndex(row, col + 1));
		
			if(row > 0 && matrix[GetCellIndex(row - 1, col)] == 1)	
				linkable.insertLast(GetCellIndex(row - 1, col));
		
			return linkable;
		}

		if(matrix[GetCellIndex(row + 1, col)] == 1)	
			linkable.insertLast(GetCellIndex(row + 1, col));

		if(col > 0 && matrix[GetCellIndex(row, col - 1)] == 1)	
			linkable.insertLast(GetCellIndex(row, col - 1));
		
		if(matrix[GetCellIndex(row, col + 1)] == 1)	
			linkable.insertLast(GetCellIndex(row, col + 1));

		if(row > 0 && matrix[GetCellIndex(row - 1, col)] == 1)	
			linkable.insertLast(GetCellIndex(row - 1, col));

		return linkable;
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_TOGGLE)
		{
			uint seed = uint(g_Engine.time * 100.0);

			array<int> matrix(m_iRowCount * m_iColCount);
			array<int> links;
			array<int> undirected_links;

			for(int i = 0;i < int(matrix.length()); ++i)
			{
				matrix[i] = 0;
			}

			int currentCell = GetCellIndex(0, g_PlayerFuncs.SharedRandomLong(seed, 0, m_iColCount - 1 ));

			int loopCount = 0;

			while(loopCount < m_iRowCount * m_iColCount)
			{
				matrix[currentCell] = 1;

				if(GetCellRow(currentCell) == m_iRowCount - 1)
				{
					break;
				}

				array<int> reachable = GetReachableCell(matrix, currentCell);

				if(reachable.length() > 0)
				{
					currentCell = reachable[g_PlayerFuncs.SharedRandomLong(seed + loopCount , 0, reachable.length() - 1 )];
				}
				else
				{
					break;
				}

				loopCount ++;
			}

			for(int cell = 0;cell < int(matrix.length()); ++cell)
			{
				if(matrix[cell] == 1)
				{
					FireCell(cell, pActivator, pCaller, useType, flValue);

					array<int> linkable = GetLinkableCell(matrix, cell);
					for(int j = 0; j < int(linkable.length()); ++j){
						int packedCells = (cell & 0xFFFF)  | ((linkable[j] & 0xFFFF) << 16);
						int packedCellsR = (linkable[j] & 0xFFFF) | ((cell & 0xFFFF) << 16);

						if(undirected_links.find(packedCells) < 0 && undirected_links.find(packedCellsR) < 0)
						{
							links.insertLast(packedCells);
						}
						undirected_links.insertLast(packedCells);
						undirected_links.insertLast(packedCellsR);
					}
				}
			}

			for(int linkIdx = 0;linkIdx < int(links.length()); ++linkIdx)
			{
				int packedCells = links[linkIdx];
				int cell_1 = (packedCells & 0xFFFF);
				int cell_2 = ((packedCells >> 16) & 0xFFFF);
				FireConnector(cell_1, cell_2, pActivator, pCaller, useType, flValue);
			}

			for(int cell = 0;cell < int(matrix.length()); ++cell)
			{
				int row = GetCellRow(cell);
				int col = GetCellColumn(cell);
				if(matrix[cell] == 1)
				{
					if( row + 1 < m_iRowCount && matrix[GetCellIndex(row + 1, col)] == 1)
					{
						if( col + 1 < m_iColCount && matrix[GetCellIndex(row, col + 1)] == 1)
						{
							if( row + 1 < m_iRowCount && col + 1 < m_iColCount && matrix[GetCellIndex(row + 1, col + 1)] == 1)
							{
								FireQuadConnector(cell,
								 GetCellIndex(row + 1, col), 
								 GetCellIndex(row, col + 1), 
								 GetCellIndex(row + 1, col + 1),
								pActivator, pCaller, useType, flValue );
							}
						}
					}
				}
			}
		}
	}
}

class CTriggerEntityItor2 : ScriptBaseEntity
{
	string m_szNameFilter = "";
	string m_szNameStartWith = "";
	string m_szClassnameFilter = "";
	int m_iStatusFilter = 0;
	int m_iTriggerState = 0;
	float m_flTriggerValue = 0.0;
	int m_iClassifyFilter = 0;

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		if(szKey == "name_filter"){
			m_szNameFilter = szValue;
			return true;
		}

		if(szKey == "name_startwith"){
			m_szNameStartWith = szValue;
			return true;
		}

		if(szKey == "classname_filter"){
			m_szClassnameFilter = szValue;
			return true;
		}

		if(szKey == "status_filter"){
			m_iStatusFilter = atoi(szValue);
			return true;
		}
	
		if(szKey == "classify_filter"){
			m_iClassifyFilter = atoi(szValue);
			return true;
		}

		if(szKey == "triggerstate"){
			m_iTriggerState = atoi(szValue);
			return true;
		}
	
		if(szKey == "triggervalue"){
			m_flTriggerValue = atof(szValue);
			return true;
		}
		return BaseClass.KeyValue( szKey, szValue );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		CBaseEntity@ pEntity = null;
		while((@pEntity = g_EntityFuncs.FindEntityByClassname(pEntity, m_szClassnameFilter)) !is null)
		{
			if( !m_szNameFilter.IsEmpty() && m_szNameFilter == string(pEntity.pev.targetname) )
			{
				if(m_iStatusFilter == 1 && pEntity.pev.deadflag != DEAD_NO)
					continue;
				else if(m_iStatusFilter == 2 && pEntity.pev.deadflag == DEAD_NO)
					continue;

				if (m_iClassifyFilter != 0 && pEntity.Classify() != m_iClassifyFilter)
					continue;

				g_EntityFuncs.FireTargets( self.pev.target, pEntity, self, USE_TYPE(m_iTriggerState), m_flTriggerValue );
			}
			else if( !m_szNameStartWith.IsEmpty() && string(pEntity.pev.targetname).StartsWith(m_szNameStartWith))
			{
				if(m_iStatusFilter == 1 && pEntity.pev.deadflag != DEAD_NO)
					continue;
				else if(m_iStatusFilter == 2 && pEntity.pev.deadflag == DEAD_NO)
					continue;

				if (m_iClassifyFilter != 0 && pEntity.Classify() != m_iClassifyFilter)
					continue;

				g_EntityFuncs.FireTargets( self.pev.target, pEntity, self, USE_TYPE(m_iTriggerState), m_flTriggerValue );
			} 
			else if(m_szNameStartWith.IsEmpty() && m_szNameFilter.IsEmpty())
			{
				if(m_iStatusFilter == 1 && pEntity.pev.deadflag != DEAD_NO)
					continue;
				else if(m_iStatusFilter == 2 && pEntity.pev.deadflag == DEAD_NO)
					continue;

				if (m_iClassifyFilter != 0 && pEntity.Classify() != m_iClassifyFilter)
					continue;

				g_EntityFuncs.FireTargets( self.pev.target, pEntity, self, USE_TYPE(m_iTriggerState), m_flTriggerValue );
			}
		}
	}
}

class CTriggerEntityItor3 : ScriptBaseEntity
{
	string m_szNameFilter = "";
	string m_szNameStartWith = "";
	string m_szClassnameFilter = "";
	int m_iStatusFilter = 0;
	int m_iTriggerState = 0;
	float m_flTriggerValue = 0.0;
	int m_iClassifyFilter = 0;

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		if(szKey == "name_filter"){
			m_szNameFilter = szValue;
			return true;
		}

		if(szKey == "name_startwith"){
			m_szNameStartWith = szValue;
			return true;
		}

		if(szKey == "classname_filter"){
			m_szClassnameFilter = szValue;
			return true;
		}

		if(szKey == "status_filter"){
			m_iStatusFilter = atoi(szValue);
			return true;
		}
	
		if(szKey == "classify_filter"){
			m_iClassifyFilter = atoi(szValue);
			return true;
		}
	
		if(szKey == "triggerstate"){
			m_iTriggerState = atoi(szValue);
			return true;
		}
	
		if(szKey == "triggervalue"){
			m_flTriggerValue = atof(szValue);
			return true;
		}
	
		return BaseClass.KeyValue( szKey, szValue );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		CBaseEntity@ pEntity = null;
		while((@pEntity = g_EntityFuncs.FindEntityByClassname(pEntity, m_szClassnameFilter)) !is null)
		{
			if( !m_szNameStartWith.IsEmpty() && string(pEntity.pev.targetname).StartsWith(m_szNameStartWith)){

				if(m_iStatusFilter == 1 && pEntity.pev.deadflag != DEAD_NO)
					continue;
				else if(m_iStatusFilter == 2 && pEntity.pev.deadflag == DEAD_NO)
					continue;

				if (m_iClassifyFilter != 0 && pEntity.Classify() != m_iClassifyFilter)
					continue;

				if(m_iTriggerState == -1){
					g_EntityFuncs.Remove(pEntity);
				} else {
					pEntity.Use( pActivator, self, USE_TYPE(m_iTriggerState), m_flTriggerValue );
				}
			}
			else if( !m_szNameFilter.IsEmpty() && string(pEntity.pev.targetname) == m_szNameFilter){

				if(m_iStatusFilter == 1 && pEntity.pev.deadflag != DEAD_NO)
					continue;
				else if(m_iStatusFilter == 2 && pEntity.pev.deadflag == DEAD_NO)
					continue;

				if (m_iClassifyFilter != 0 && pEntity.Classify() != m_iClassifyFilter)
					continue;

				if(m_iTriggerState == -1){
					g_EntityFuncs.Remove(pEntity);
				} else {
					pEntity.Use( pActivator, self, USE_TYPE(m_iTriggerState), m_flTriggerValue );
				}
			}
			else if(m_szNameStartWith.IsEmpty() && m_szNameFilter.IsEmpty())
			{
				if(m_iStatusFilter == 1 && pEntity.pev.deadflag != DEAD_NO)
					continue;
				else if(m_iStatusFilter == 2 && pEntity.pev.deadflag == DEAD_NO)
					continue;

				if (m_iClassifyFilter != 0 && pEntity.Classify() != m_iClassifyFilter)
					continue;

				if(m_iTriggerState == -1){
					g_EntityFuncs.Remove(pEntity);
				} else {
					pEntity.Use( pActivator, self, USE_TYPE(m_iTriggerState), m_flTriggerValue );
				}
			}
		}
	}
}

const int Round_Normal = 0;
const int Round_Final = 1;
const int Round_TeamPlay2 = 2;
const int Round_TeamPlay3 = 4;

class CGameRoundManager : ScriptBaseEntity
{
	float m_flDelay = 1.0;
	string m_szPlayedCountTarget;
	string m_szToPlayCountTarget;
	EHandle m_PlayedCountTarget;
	EHandle m_ToPlayCountTarget;

	int m_iOldPlayedCount = 0;
	int m_iOldToPlayCount = 0;
	int m_iOldPlayerCount = 0;

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		if((self.pev.spawnflags & 1) == 1){
			NextThink(g_Engine.time + 1.0, false);
			SetThink(ThinkFunction(this.CounterThink));
		}
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		if(szKey == "delay"){
			m_flDelay = atof(szValue);
			return true;
		}

		if(szKey == "played"){
			m_szPlayedCountTarget = szValue;
			return true;
		}

		if(szKey == "toplay"){
			m_szToPlayCountTarget = szValue;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void ActivatePanel(CBaseEntity @pTarget)
	{
		pTarget.pev.takedamage = DAMAGE_YES;
		pTarget.pev.rendermode = kRenderNormal;
		pTarget.pev.renderamt = 255;
		g_EntityFuncs.SetOrigin( pTarget, pTarget.pev.origin );
	}

	void DeactivatePanel(CBaseEntity @pTarget)
	{
		pTarget.pev.takedamage = DAMAGE_NO;
		pTarget.pev.rendermode = kRenderTransTexture;
		pTarget.pev.renderamt = 128;
		g_EntityFuncs.SetOrigin( pTarget, pTarget.pev.origin );
	}

	bool UpdatePanels()
	{
		int iAlivePlayerCount = 0;
		int iDeadPlayerCount = 0;
		int iPlayerCount = GetPlayerCountEx(iAlivePlayerCount, iDeadPlayerCount);

		self.pev.max_health = float(iPlayerCount);
		self.pev.frags = float(iAlivePlayerCount);
		self.pev.armorvalue = float(iDeadPlayerCount);

		if(!m_PlayedCountTarget.IsValid())
		{
			CBaseEntity @pTarget = g_EntityFuncs.FindEntityByTargetname( null, m_szPlayedCountTarget );
			if(pTarget !is null)
			{
				m_PlayedCountTarget = EHandle(pTarget);
			}
		}

		if(!m_ToPlayCountTarget.IsValid())
		{
			CBaseEntity @pTarget = g_EntityFuncs.FindEntityByTargetname( null, m_szToPlayCountTarget );
			if(pTarget !is null)
			{
				m_ToPlayCountTarget = EHandle(pTarget);
			}
		}

		int iToPlayCount = 0;
		int iPlayedCount = 0;

		if(m_PlayedCountTarget.IsValid() && m_ToPlayCountTarget.IsValid())
		{
			CBaseEntity @PlayedCountTarget = m_PlayedCountTarget.GetEntity();
			CBaseEntity @ToPlayCountTarget = m_ToPlayCountTarget.GetEntity();
			
			iToPlayCount = int(ToPlayCountTarget.pev.skin);
			iPlayedCount = int(PlayedCountTarget.pev.skin);

			if(m_iOldPlayerCount != iPlayerCount || m_iOldPlayedCount != iPlayedCount || m_iOldToPlayCount != iToPlayCount)
			{
				m_iOldPlayerCount = iPlayerCount;
				m_iOldPlayedCount = iPlayedCount;
				m_iOldToPlayCount = iToPlayCount;

				int iRemainCount = iToPlayCount - iPlayedCount;

				int iActivePanelCount = 0;

				if(iToPlayCount == 0)
				{
					CBaseEntity@ pTarget = null;
					while((@pTarget = g_EntityFuncs.FindEntityByClassname(pTarget, "func_rotating_fg")) !is null)
					{
						if(string(pTarget.pev.targetname).StartsWith("game_start_rot"))
						{
							DeactivatePanel(pTarget);
							iActivePanelCount ++;
						}
					}
				}
				else if(iRemainCount == 1 && iPlayerCount > 1)//final round, last man standing
				{
					CBaseEntity@ pTarget = null;
					while((@pTarget = g_EntityFuncs.FindEntityByClassname(pTarget, "func_rotating_fg")) !is null)
					{
						if(string(pTarget.pev.targetname).StartsWith("game_start_rot"))
						{
							if(( int(pTarget.pev.frags) & Round_Final) == Round_Final)
							{
								ActivatePanel(pTarget);
								iActivePanelCount ++;
							}
							else
							{
								DeactivatePanel(pTarget);
							}
						}
					}
				}
				else
				{
					CBaseEntity@ pTarget = null;
					while((@pTarget = g_EntityFuncs.FindEntityByClassname(pTarget, "func_rotating_fg")) !is null)
					{
						if(string(pTarget.pev.targetname).StartsWith("game_start_rot"))
						{
							if(( int(pTarget.pev.frags) & Round_Final) == Round_Final)//final round, last man standing
							{
								DeactivatePanel(pTarget);
							}
							else
							{
								if(( int(pTarget.pev.frags) & Round_TeamPlay2) == Round_TeamPlay2)//teamplay, N vs N
								{
									if((iPlayerCount % Round_TeamPlay2) == 0 && iPlayerCount >= Round_TeamPlay2)
									{
										ActivatePanel(pTarget);
										iActivePanelCount ++;
									}
									else
									{
										DeactivatePanel(pTarget);
									}
								}
								else if(( int(pTarget.pev.frags) & Round_TeamPlay3) == Round_TeamPlay3)//teamplay, N vs N vs N
								{
									if((iPlayerCount % 3) == 0 && iPlayerCount >= 3)
									{
										ActivatePanel(pTarget);
										iActivePanelCount ++;
									}
									else
									{
										DeactivatePanel(pTarget);
									}
								}
								else
								{
									ActivatePanel(pTarget);
									iActivePanelCount ++;
								}								
							}
						}
					}
				}

				if (iActivePanelCount == 0 && !string(self.pev.message).IsEmpty())
				{
					g_EntityFuncs.FireTargets( self.pev.message, self, self, USE_TOGGLE, 0 );
					return false;
				}
			}
		}

		return true;
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_ON)
		{
			self.pev.spawnflags |= 1;

			NextThink(g_Engine.time + 1.0, false);
			SetThink(ThinkFunction(this.CounterThink));
		}
		else if(useType == USE_OFF)
		{
			self.pev.spawnflags &= ~1;

			SetThink(null);
			self.pev.nextthink = -1;
		}
		else if(useType == USE_TOGGLE || useType == USE_SET)
		{
			UpdatePanels();
		}
	}

	void NextThink(float thinkTime, const bool alwaysThink)
	{
		if (alwaysThink)
			self.pev.flags |= FL_ALWAYSTHINK;
		else
			self.pev.flags &= ~FL_ALWAYSTHINK;

		self.pev.nextthink = thinkTime;
	}

	void CounterThink()
	{
		if((self.pev.spawnflags & 1) == 1){

			if(UpdatePanels())
			{
				NextThink(g_Engine.time + m_flDelay, false);
				SetThink(ThinkFunction(this.CounterThink));
			}
		}
	}
}

class CGameTeamPlayManager : ScriptBaseEntity
{
	void StartTeamPlay()
	{
		array<CBasePlayer@> players;
		for (int i = 1; i <= g_Engine.maxClients; i++)
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
			if(IsPlayerAvailable(pPlayer))
			{
				players.insertLast(pPlayer);
			}
		}

		//players.sort(function(CBasePlayer@ pA, CBasePlayer@ pB){return pA.pev.frags < pB.pev.frags;});

		int size = int(players.length());
		for (int step = 0; step < size; ++step)
		{
			for (int i = 0; i < size - step - 1; ++i)
			{
				if (players[i].pev.frags < players[i + 1].pev.frags)
				{
					CBasePlayer@ temp = @players[i];
					@players[i] = @players[i + 1];
					@players[i + 1] = @temp;
				}
			}
		}

		array<int> teams;

		if((self.pev.spawnflags & SF_TEAMPLAY_HAS_BLUE) == SF_TEAMPLAY_HAS_BLUE)
		{
			teams.insertLast(16);
		}
		if((self.pev.spawnflags & SF_TEAMPLAY_HAS_RED) == SF_TEAMPLAY_HAS_RED)
		{
			teams.insertLast(17);
		}
		if((self.pev.spawnflags & SF_TEAMPLAY_HAS_YELLOW) == SF_TEAMPLAY_HAS_YELLOW)
		{
			teams.insertLast(18);
		}
		if((self.pev.spawnflags & SF_TEAMPLAY_HAS_GREEN) == SF_TEAMPLAY_HAS_GREEN)
		{
			teams.insertLast(19);
		}

		if(0 == teams.length())
			return;

		int iLastTeam = 0;
		for (int i = 0; i < int(players.length()); i++)
		{
			CBasePlayer@ pPlayer = @players[i];
			
			int team = teams[i % int(teams.length()) ];
			pPlayer.SetClassification(team);
			pPlayer.SendScoreInfo();
			//g_Game.AlertMessage( at_console, "Set team %1 for %2\n", team, string(pPlayer.pev.netname) );
		}
	}

	void EndTeamPlay()
	{
		for (int i = 1; i <= g_Engine.maxClients; i++)
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
			if(IsPlayerAvailable(pPlayer))
			{
				pPlayer.SetClassification(CLASS_PLAYER);
				pPlayer.SendScoreInfo();
			}
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_ON)
		{
			StartTeamPlay();
		}
		else if(useType == USE_OFF)
		{
			EndTeamPlay();
		}
	}
}

class CTriggerRelay2 : ScriptBaseEntity
{
	int m_iTriggerState = 0;
	float m_flTriggerValue = 0.0;

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "triggerstate"){
			m_iTriggerState = atoi(szValue);
			return true;
		}
	
		if(szKey == "triggervalue"){
			m_flTriggerValue = atof(szValue);
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_ON)
		{
			self.pev.spawnflags |= 1;
		}
		else if(useType == USE_OFF)
		{
			self.pev.spawnflags &= ~1;
		}
		else if(useType == USE_TOGGLE)
		{
			if((self.pev.spawnflags & 1) == 1)
			{
				g_EntityFuncs.FireTargets( self.pev.target, pActivator, self, USE_TYPE(m_iTriggerState), m_flTriggerValue );
			}
			else
			{
				//or what
			}
		}
	}
}

class CTriggerToggleBSP : ScriptBaseEntity
{
	int m_iNewRenderState = -1;
	int m_iNewTakeDamageState = -1;
	int m_iNewRenderAmt = -1;

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "newrenderstate"){
			m_iNewRenderState = atoi(szValue);
			return true;
		}
		if(szKey == "newtakedamagestate"){
			m_iNewTakeDamageState = atoi(szValue);
			return true;
		}
		if(szKey == "newrenderamt"){
			m_iNewRenderAmt = atoi(szValue);
			return true;
		}
		return BaseClass.KeyValue( szKey, szValue );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(string(self.pev.target).IsEmpty())
			return;

		if(useType == USE_ON)
		{
			if(string(self.pev.target) == "!activator")
			{
				pActivator.pev.solid = SOLID_BSP;
				pActivator.pev.effects &= ~EF_NODRAW;
				g_EntityFuncs.SetOrigin( pActivator, pActivator.pev.origin );
			}
			else
			{
				if((self.pev.spawnflags & 1) == 1)
				{
					CBaseEntity@ pTarget = null;
					while((@pTarget = g_EntityFuncs.FindEntityByTargetname(pTarget, self.pev.target)) !is null)
					{
						pTarget.pev.solid = SOLID_BSP;
						pTarget.pev.effects &= ~EF_NODRAW;
						g_EntityFuncs.SetOrigin( pTarget, pTarget.pev.origin );
					}
					return;
				}
				else
				{
					CBaseEntity @pTarget = g_EntityFuncs.FindEntityByTargetname( null, self.pev.target );
					if(pTarget !is null)
					{
						pTarget.pev.solid = SOLID_BSP;
						pTarget.pev.effects &= ~EF_NODRAW;
						g_EntityFuncs.SetOrigin( pTarget, pTarget.pev.origin );
					}
				}
			}
		}
		else if(useType == USE_OFF)
		{
			if(string(self.pev.target) == "!activator")
			{
				pActivator.pev.solid = SOLID_NOT;
				pActivator.pev.effects |= EF_NODRAW;
				g_EntityFuncs.SetOrigin( pActivator, pActivator.pev.origin );
			}
			else
			{
				if((self.pev.spawnflags & 1) == 1)
				{
					CBaseEntity@ pTarget = null;
					while((@pTarget = g_EntityFuncs.FindEntityByTargetname(pTarget, self.pev.target)) !is null)
					{
						pTarget.pev.solid = SOLID_NOT;
						pTarget.pev.effects |= EF_NODRAW;
						g_EntityFuncs.SetOrigin( pTarget, pTarget.pev.origin );
					}
					return;
				}
				else
				{
					CBaseEntity @pTarget = g_EntityFuncs.FindEntityByTargetname( null, self.pev.target );
					if(pTarget !is null)
					{
						pTarget.pev.solid = SOLID_NOT;
						pTarget.pev.effects |= EF_NODRAW;
						g_EntityFuncs.SetOrigin( pTarget, pTarget.pev.origin );
					}
				}
			}
		}
		else if(useType == USE_TOGGLE)
		{
			if(string(self.pev.target) == "!activator")
			{
				if(m_iNewRenderState == 2)
				{
					if((pActivator.pev.effects & EF_NODRAW) == EF_NODRAW)
					{
						pActivator.pev.solid = SOLID_BSP;
						pActivator.pev.effects &= ~EF_NODRAW;
						g_EntityFuncs.SetOrigin( pActivator, pActivator.pev.origin );
					}
					else
					{
						pActivator.pev.solid = SOLID_NOT;
						pActivator.pev.effects |= EF_NODRAW;
						g_EntityFuncs.SetOrigin( pActivator, pActivator.pev.origin );
					}
				}
				else if(m_iNewRenderState == 1)
				{
					pActivator.pev.solid = SOLID_BSP;
					pActivator.pev.effects &= ~EF_NODRAW;
					g_EntityFuncs.SetOrigin( pActivator, pActivator.pev.origin );
				}
				else if(m_iNewRenderState == 0)
				{
					pActivator.pev.solid = SOLID_NOT;
					pActivator.pev.effects |= EF_NODRAW;
					g_EntityFuncs.SetOrigin( pActivator, pActivator.pev.origin );
				}

				if(m_iNewTakeDamageState == 2)
				{
					if(pActivator.pev.takedamage == DAMAGE_YES)
					{
						pActivator.pev.takedamage = DAMAGE_NO;
					}
					else
					{
						pActivator.pev.takedamage = DAMAGE_YES;
					}
				}
				else if(m_iNewTakeDamageState == 1)
				{
					pActivator.pev.takedamage = DAMAGE_YES;
				}
				else if(m_iNewTakeDamageState == 0)
				{
					pActivator.pev.takedamage = DAMAGE_NO;
				}

				if(m_iNewRenderAmt >= 0)
				{
					pActivator.pev.renderamt = m_iNewRenderAmt;
				}
			}
			else
			{
				if((self.pev.spawnflags & 1) == 1)
				{
					CBaseEntity@ pTarget = null;
					while((@pTarget = g_EntityFuncs.FindEntityByTargetname(pTarget, self.pev.target)) !is null)
					{
						if(m_iNewRenderState == 2)
						{
							if((pTarget.pev.effects & EF_NODRAW) == EF_NODRAW)
							{
								pTarget.pev.solid = SOLID_BSP;
								pTarget.pev.effects &= ~EF_NODRAW;
								g_EntityFuncs.SetOrigin( pTarget, pTarget.pev.origin );
							}
							else
							{
								pTarget.pev.solid = SOLID_NOT;
								pTarget.pev.effects |= EF_NODRAW;
								g_EntityFuncs.SetOrigin( pTarget, pTarget.pev.origin );
							}
						}
						else if(m_iNewRenderState == 1)
						{
							pTarget.pev.solid = SOLID_BSP;
							pTarget.pev.effects &= ~EF_NODRAW;
							g_EntityFuncs.SetOrigin( pTarget, pTarget.pev.origin );
						}
						else if(m_iNewRenderState == 0)
						{
							pTarget.pev.solid = SOLID_NOT;
							pTarget.pev.effects |= EF_NODRAW;
							g_EntityFuncs.SetOrigin( pTarget, pTarget.pev.origin );
						}

						if(m_iNewTakeDamageState == 2)
						{
							if(pTarget.pev.takedamage == DAMAGE_YES)
							{
								pTarget.pev.takedamage = DAMAGE_NO;
							}
							else
							{
								pTarget.pev.takedamage = DAMAGE_YES;
							}
						}
						else if(m_iNewTakeDamageState == 1)
						{
							pTarget.pev.takedamage = DAMAGE_YES;
						}
						else if(m_iNewTakeDamageState == 0)
						{
							pTarget.pev.takedamage = DAMAGE_NO;
						}

						if(m_iNewRenderAmt >= 0)
						{
							pTarget.pev.renderamt = m_iNewRenderAmt;
						}
					}
					return;
				}
				else
				{
					CBaseEntity @pTarget = g_EntityFuncs.FindEntityByTargetname( null, self.pev.target );
					if(pTarget !is null)
					{
						if(m_iNewRenderState == 2)
						{
							if((pTarget.pev.effects & EF_NODRAW) == EF_NODRAW)
							{
								pTarget.pev.solid = SOLID_BSP;
								pTarget.pev.effects &= ~EF_NODRAW;
								g_EntityFuncs.SetOrigin( pTarget, pTarget.pev.origin );
							}
							else
							{
								pTarget.pev.solid = SOLID_NOT;
								pTarget.pev.effects |= EF_NODRAW;
								g_EntityFuncs.SetOrigin( pTarget, pTarget.pev.origin );
							}
						}
						else if(m_iNewRenderState == 1)
						{
							pTarget.pev.solid = SOLID_BSP;
							pTarget.pev.effects &= ~EF_NODRAW;
							g_EntityFuncs.SetOrigin( pTarget, pTarget.pev.origin );
						}
						else if(m_iNewRenderState == 0)
						{
							pTarget.pev.solid = SOLID_NOT;
							pTarget.pev.effects |= EF_NODRAW;
							g_EntityFuncs.SetOrigin( pTarget, pTarget.pev.origin );
						}

						if(m_iNewTakeDamageState == 2)
						{
							if(pTarget.pev.takedamage == DAMAGE_YES)
							{
								pTarget.pev.takedamage = DAMAGE_NO;
							}
							else
							{
								pTarget.pev.takedamage = DAMAGE_YES;
							}
						}
						else if(m_iNewTakeDamageState == 1)
						{
							pTarget.pev.takedamage = DAMAGE_YES;
						}
						else if(m_iNewTakeDamageState == 0)
						{
							pTarget.pev.takedamage = DAMAGE_NO;
						}

						if(m_iNewRenderAmt >= 0)
						{
							pTarget.pev.renderamt = m_iNewRenderAmt;
						}
					}
				}
			}
		}
		else if(useType == USE_SET)
		{
			
		}
	}
}

class CTriggerCreateEnts : ScriptBaseEntity
{
	string m_iszCrtEntChildName;
	string m_iszCrtEntChildClass;

	Vector m_RowOffset = g_vecZero;
	int m_iRowCount = 0;

	Vector m_ColOffset = g_vecZero;
	int m_iColumnCount = 0;

	float m_flHexRadius = 0;

	dictionary m_KeyValues;

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "rowcount"){
			m_iRowCount = atoi(szValue);
			return true;
		}

		if(szKey == "colcount"){
			m_iColumnCount = atoi(szValue);
			return true;
		}
		
		if(szKey == "hexradius"){
			m_flHexRadius = atof(szValue);
			return true;
		}
		
		if(szKey == "rowoffset"){
			g_Utility.StringToVector( m_RowOffset, szValue );
			return true;
		}

		if(szKey == "coloffset"){
			g_Utility.StringToVector( m_ColOffset, szValue );
			return true;
		}

		if(szKey == "m_iszCrtEntChildClass"){
			m_iszCrtEntChildClass = szValue;
			return true;
		}
		
		if(szKey == "m_iszCrtEntChildName"){
			m_iszCrtEntChildName = szValue;
			return true;
		}

		if(szKey.StartsWith("-")){
			m_KeyValues[szKey.SubString(1)] = szValue;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void CreateHexagons( CBaseEntity @pTarget )
	{
		for(int i = -m_iRowCount + 1;i < m_iRowCount; ++i)
		{
			for(int j = -m_iColumnCount + 1;j < m_iColumnCount; ++j)
			{
				Vector vecOrigin = self.pev.origin;
				vecOrigin = vecOrigin + m_RowOffset * float(i);
				vecOrigin = vecOrigin + m_ColOffset * float(j);

				Vector vDiff = vecOrigin - self.pev.origin;
				if(vDiff.Length() > m_flHexRadius)
					continue;

				CBaseEntity@ pEntity = g_EntityFuncs.CreateEntity(m_iszCrtEntChildClass, m_KeyValues, false);
				pEntity.pev.angles = g_vecZero;
				pEntity.pev.origin = vecOrigin;
				pEntity.pev.model = pTarget.pev.model;

				int cell = (j + i * m_iColumnCount);
				pEntity.pev.targetname = m_iszCrtEntChildName + cell;

				g_EntityFuncs.DispatchSpawn(pEntity.edict());
			}
		}
	}

	void CreateQuads( CBaseEntity @pTarget )
	{
		for(int i = 0;i < m_iRowCount; ++i)
		{
			for(int j = 0;j < m_iColumnCount; ++j)
			{
				Vector vecOrigin = self.pev.origin;
				vecOrigin = vecOrigin + m_RowOffset * float(i);
				vecOrigin = vecOrigin + m_ColOffset * float(j);

				CBaseEntity@ pEntity = g_EntityFuncs.CreateEntity(m_iszCrtEntChildClass, m_KeyValues, false);
				pEntity.pev.angles = g_vecZero;
				pEntity.pev.origin = vecOrigin;
				pEntity.pev.model = pTarget.pev.model;

				int cell = (j + i * m_iColumnCount);
				pEntity.pev.targetname = m_iszCrtEntChildName + cell;

				g_EntityFuncs.DispatchSpawn(pEntity.edict());
			}
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_TOGGLE || useType == USE_ON || useType == USE_SET)
		{
			if(m_iszCrtEntChildClass.IsEmpty())
				return;

			if(string(self.pev.target).IsEmpty())
				return;

			CBaseEntity @pTarget = g_EntityFuncs.FindEntityByTargetname( null, self.pev.target );

			if(pTarget is null)
				return;

			if((self.pev.spawnflags & 2) == 2)
			{
				CreateHexagons(pTarget);
			}
			else
			{
				CreateQuads(pTarget);
			}
		}
	}
}

class CTriggerPlayerHat : ScriptBaseEntity
{
	string m_szHatModel;

	void Precache()
	{
		g_Game.PrecacheModel(m_szHatModel);

		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "hatmodel"){
			m_szHatModel = szValue;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(m_szHatModel.IsEmpty())
			return;

		if(useType == USE_TOGGLE || useType == USE_SET || useType == USE_ON)
		{
			if(pActivator !is null && pActivator.IsPlayer())
			{				
				CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pActivator);
				PlayerShowHat(pPlayer, pPlayer.entindex(), m_szHatModel);
			}
		}
	}
}

class CTriggerPhysicCannon : ScriptBaseEntity
{
	string m_iszCrtEntChildName;
	string m_szPhysEntModel;
	Vector m_vecFireOffset = Vector(100.0, 0.0, 0.0);
	Vector m_vecHalfExtent = Vector(0.0, 0.0, 0.0);
	Vector m_vecLivingMins = Vector(-999999, -999999, -999999);
	Vector m_vecLivingMaxs = Vector(999999, 999999, 999999);
	Vector m_vecShootAngles = g_vecZero;
	string m_szPointRadius = "";
	int m_iShapeType = PhysicShape_Box;
	int m_iShapeDirection = PhysicShapeDirection_Z;
	int m_iClippingHullShapeType = PhysicShape_Box;
	int m_iClippingHullShapeDirection = PhysicShapeDirection_Z;
	float m_flMass = 10.0;
	float m_flRestitution = 0.0;
	float m_flLinearFriction = 1.0;
	float m_flRollingFriction = 1.0;
	float m_flCCDRadius = 0.0;
	float m_flCCDThreshold = 0.0;
	float m_flImpactImpulseThreshold = 1000000;
	float m_flImpactImpulseVolumeFactor = 5000000;
	float m_flImpactImpulseThresholdLargeHit = 100000;
	float m_flImpactImpulseThresholdMediumHit = 10000;
	float m_flImpactSoundAttenuation = 0.33;
	float m_flUpMin = 0.0;
	float m_flUpMax = 0.0;
	float m_flRightMin = 0.0;
	float m_flRightMax = 0.0;
	float m_flVelocityMin = 1000.0;
	float m_flVelocityMax = 1000.0;
	float m_flFireDuration = 5.0;
	array<string> m_szImpactSound;
	array<string> m_szFireSound;
	array<string> m_szSmokeSprite;

	int m_iTriggerState = USE_TOGGLE;
	float m_flTriggerValue = 0;

	int m_iMinSkin = 0;
	int m_iMaxSkin = 0;
	float m_flLifeTime = 0;

	void Precache()
	{
		g_Game.PrecacheModel(m_szPhysEntModel);

		for(int i = 0;i < int(m_szImpactSound.length()); ++i)
		{
			g_SoundSystem.PrecacheSound( m_szImpactSound[i] );
		}

		for(int i = 0;i < int(m_szFireSound.length()); ++i)
		{
			g_SoundSystem.PrecacheSound( m_szFireSound[i] );
		}

		for(int i = 0;i < int(m_szSmokeSprite.length()); ++i)
		{
			g_Game.PrecacheModel( m_szSmokeSprite[i] );
		}

		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		if ((self.pev.spawnflags & SF_TRIGGER_PHYSIC_CANNON_START_ON) == SF_TRIGGER_PHYSIC_CANNON_START_ON && m_flFireDuration > 0)
		{
			self.pev.nextthink = g_Engine.time + m_flFireDuration;
			SetThink(ThinkFunction(this.Shoot));

			self.pev.spawnflags &= ~SF_TRIGGER_PHYSIC_CANNON_START_ON;
		}
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "triggerstate"){
			m_iTriggerState = atoi(szValue);
			return true;
		}

		if(szKey == "triggervalue"){
			m_flTriggerValue = atof(szValue);
			return true;
		}
		
		if(szKey == "m_iszCrtEntChildName"){
			m_iszCrtEntChildName = szValue;
			return true;
		}

		if(szKey == "physentmodel"){
			m_szPhysEntModel = szValue;
			return true;
		}

		if(szKey == "fireoffset")
		{
			g_Utility.StringToVector( m_vecFireOffset, szValue );
			return true;
		}

		if(szKey == "halfextent")
		{
			g_Utility.StringToVector( m_vecHalfExtent, szValue );
			return true;
		}

		if(szKey == "shootangles")
		{
			g_Utility.StringToVector( m_vecShootAngles, szValue );
			return true;
		}

		if(szKey == "shapetype")
		{
			m_iShapeType = atoi(szValue);
			return true;
		}

		if(szKey == "shapedirection")
		{
			m_iShapeDirection = atoi(szValue);
			return true;
		}
		if(szKey == "clippinghull_shapetype")
		{
			m_iClippingHullShapeType = atoi(szValue);
			return true;
		}
		if(szKey == "clippinghull_shapedirection")
		{
			m_iClippingHullShapeDirection = atoi(szValue);
			return true;
		}
		if(szKey == "pointradius")
		{
			m_szPointRadius = szValue;
			return true;
		}

		if(szKey == "livingmins"){
			g_Utility.StringToVector( m_vecLivingMins, szValue );
			return true;
		}

		if(szKey == "livingmaxs"){
			g_Utility.StringToVector( m_vecLivingMaxs, szValue );
			return true;
		}

		if(szKey == "lifetime"){
			m_flLifeTime = atof(szValue);
			return true;
		}
		if(szKey == "minskin"){
			m_iMinSkin = atoi(szValue);
			return true;
		}
		if(szKey == "maxskin"){
			m_iMaxSkin = atoi(szValue);
			return true;
		}
		if(szKey == "lod1"){
			self.pev.fuser1 = atof(szValue);
			return true;
		}
		if(szKey == "lod1body"){
			self.pev.iuser1 = atoi(szValue);
			return true;
		}
		if(szKey == "lod2"){
			self.pev.fuser2 = atof(szValue);
			return true;
		}
		if(szKey == "lod2body"){
			self.pev.iuser2 = atoi(szValue);
			return true;
		}
		if(szKey == "lod3"){
			self.pev.fuser3 = atof(szValue);
			return true;
		}
		if(szKey == "lod3body"){
			self.pev.iuser3 = atoi(szValue);
			return true;
		}
		if(szKey == "mass")
		{
			m_flMass = atof(szValue);
			return true;
		}

		if(szKey == "restitution")
		{
			m_flRestitution = atof(szValue);
			return true;
		}

		if(szKey == "linearfriction")
		{
			m_flLinearFriction = atof(szValue);
			return true;
		}

		if(szKey == "rollingfriction")
		{
			m_flRollingFriction = atof(szValue);
			return true;
		}

		if(szKey == "ccdradius")
		{
			m_flCCDRadius = atof(szValue);
			return true;
		}

		if(szKey == "ccdthreshold")
		{
			m_flCCDThreshold = atof(szValue);
			return true;
		}

		if(szKey == "impactimpulsethreshold")
		{
			m_flImpactImpulseThreshold = atof(szValue);
			return true;
		}

		if(szKey == "impactimpulsevolumefactor")
		{
			m_flImpactImpulseVolumeFactor = atof(szValue);
			return true;
		}

		if(szKey == "impactsoundattenuation"){
			m_flImpactSoundAttenuation = atof(szValue);
			return true;
		}
		if(szKey == "impactimpulsethresholdlargehit"){
			m_flImpactImpulseThresholdLargeHit = atof(szValue);
			return true;
		}
		if(szKey == "impactimpulsethresholdmediumhit"){
			m_flImpactImpulseThresholdMediumHit = atof(szValue);
			return true;
		}

		if(szKey == "upmin")
		{
			m_flUpMin = atof(szValue);
			return true;
		}
		if(szKey == "upmax")
		{
			m_flUpMax = atof(szValue);
			return true;
		}
		if(szKey == "rightmin")
		{
			m_flRightMin = atof(szValue);
			return true;
		}
		if(szKey == "rightmax")
		{
			m_flRightMax = atof(szValue);
			return true;
		}

		if(szKey == "velocitymin")
		{
			m_flVelocityMin = atof(szValue);
			return true;
		}
		if(szKey == "velocitymax")
		{
			m_flVelocityMax = atof(szValue);
			return true;
		}
		if(szKey == "fireduration")
		{
			m_flFireDuration = atof(szValue);
			return true;
		}	
		
		if(szKey.StartsWith("impactsound_")){
			m_szImpactSound.insertLast(szValue);
			return true;
		}

		if(szKey.StartsWith("firesound_")){
			m_szFireSound.insertLast(szValue);
			return true;
		}

		if(szKey.StartsWith("smokesprite_")){
			m_szSmokeSprite.insertLast(szValue);
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

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

	void Smokelit(const Vector &in vecAimDir, const Vector &in vecAimRight, const Vector &in vecAimUp)
	{
		if(m_szSmokeSprite.length() == 0)
			return;

		array<float> vRightUpArray = { 
				0.000, 1.000,
				0.707, 0.707,
				1.000, 0.000,
				0.707, -0.707,
				0.000, -1.000,
				-0.707, -0.707,
				-1.000, 0.000,
				-0.707, 0.707
		};
		for(int i = 0;i < int(vRightUpArray.length()) / 2; i++)
		{
			if(Math.RandomLong(0, 3) == 0)
				continue;

			Vector vecSmokeSource = self.pev.origin + vecAimDir * 80.0 + vecAimRight * vRightUpArray[i * 2 + 0] * 64.0 + vecAimUp * vRightUpArray[i * 2 + 1] * 64.0;
			Vector vecSmokeDirection = vecAimDir + vecAimRight * vRightUpArray[i * 2 + 0] + vecAimUp * vRightUpArray[i * 2 + 1];
			vecSmokeDirection.z += 2.4;
			vecSmokeDirection = vecSmokeDirection.Normalize();

			CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecSmokeSource, g_vecZero, false);

			g_EntityFuncs.SetModel(pEntity, m_szSmokeSprite[Math.RandomLong(0, int(m_szSmokeSprite.length()) - 1 )]);

			pEntity.pev.scale = Math.RandomFloat(0.2, 1.0);
			pEntity.pev.solid = SOLID_NOT;
			pEntity.pev.movetype = MOVETYPE_NOCLIP;
			pEntity.pev.rendermode = kRenderTransAlpha;
			pEntity.pev.renderamt = 192;

			Vector Color1 = Vector(255, 190, 240);
			Vector Color2 = Vector(255, 255, 255);
			float ColorMix = Math.RandomFloat(0.0, 1.0);
			pEntity.pev.rendercolor = Color1 * ColorMix + Color2 * (1.0 - ColorMix);
			pEntity.pev.velocity = vecSmokeDirection * 80;
			pEntity.pev.avelocity = Vector(0, 0, Math.RandomFloat(30, 60));
			pEntity.pev.framerate = 20;
			pEntity.pev.spawnflags = 0;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_RENDERAMT;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SCALE;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_STATIC_FRAME;
			pEntity.pev.frame = Math.RandomLong(0, 8);

			CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));
			pStudio.m_flUpdateRate = 0.0;
			pStudio.m_flMaxFrame = 10;

			EnvStudioKeyframe keyframe0;
			keyframe0.frame = 0;
			keyframe0.renderamt = 192;
			keyframe0.scale = pEntity.pev.scale * 0.6;
			pStudio.m_Keyframes.insertLast(keyframe0);

			EnvStudioKeyframe keyframe1;
			keyframe1.frame = 2;
			keyframe1.renderamt = 255;
			keyframe1.scale = pEntity.pev.scale * 0.8;
			pStudio.m_Keyframes.insertLast(keyframe1);

			EnvStudioKeyframe keyframe2;
			keyframe2.frame = 5;
			keyframe2.renderamt = 200;
			keyframe2.scale = pEntity.pev.scale;
			pStudio.m_Keyframes.insertLast(keyframe2);

			EnvStudioKeyframe keyframe3;
			keyframe3.frame = 10;
			keyframe3.renderamt = 32;
			keyframe3.scale = pEntity.pev.scale * 0.3;
			pStudio.m_Keyframes.insertLast(keyframe3);

			pStudio.StartSpriteAnim(0);
		}
	}

	void ShootPhysicInternal()
	{
		if(m_szPhysEntModel.IsEmpty())
			return;

		Vector vecSrc = self.pev.origin;

		Vector vecAimDir = GetAimDir(self);

		Vector vecAimRight = g_Engine.v_right;

		Vector vecAimUp = g_Engine.v_up;

		Vector vecOrigin = vecSrc + vecAimDir * m_vecFireOffset.x + vecAimRight * m_vecFireOffset.y + vecAimUp * m_vecFireOffset.z;

		Vector vecVelocity = vecAimDir + vecAimRight * Math.RandomFloat(m_flRightMin, m_flRightMax) + vecAimUp * Math.RandomFloat(m_flUpMin, m_flUpMax);

		vecVelocity = vecVelocity.Normalize();

		vecVelocity = vecVelocity * Math.RandomFloat(m_flVelocityMin, m_flVelocityMax);

		CBaseEntity@ pEntity = g_EntityFuncs.Create("env_physicmodel", vecOrigin, g_vecZero, true);

		CEnvPhysicModel@ pPhysic = cast<CEnvPhysicModel@>(CastToScriptClass(pEntity));

		pEntity.pev.targetname = m_iszCrtEntChildName;
		pEntity.pev.model = m_szPhysEntModel;
		pEntity.pev.skin = Math.RandomLong(m_iMinSkin, m_iMaxSkin);
		pEntity.pev.velocity = vecVelocity;
		pPhysic.m_vecLivingMins = m_vecLivingMins;
		pPhysic.m_vecLivingMaxs = m_vecLivingMaxs;
		pPhysic.m_flRestitution = m_flRestitution;
		pPhysic.m_flMass = m_flMass;
		pPhysic.m_flLinearFriction = m_flLinearFriction;
		pPhysic.m_flRollingFriction = m_flRollingFriction;
		pPhysic.m_flCCDRadius = m_flCCDRadius;
		pPhysic.m_flCCDThreshold = m_flCCDThreshold;
		pPhysic.m_vecHalfExtent = m_vecHalfExtent;
		pPhysic.m_iShapeType = m_iShapeType;
		pPhysic.m_iClippingHullShapeType = m_iClippingHullShapeType;
		pPhysic.m_iShapeDirection = m_iShapeDirection;
		pPhysic.m_szPointRadius = m_szPointRadius;
		pPhysic.m_flImpactImpulseThreshold = m_flImpactImpulseThreshold;
		pPhysic.m_flImpactImpulseVolumeFactor = m_flImpactImpulseVolumeFactor;
		pPhysic.m_flImpactImpulseThresholdLargeHit = m_flImpactImpulseThresholdLargeHit;
		pPhysic.m_flImpactImpulseThresholdMediumHit = m_flImpactImpulseThresholdMediumHit;
		pPhysic.m_flImpactSoundAttenuation = m_flImpactSoundAttenuation;
		pPhysic.m_szImpactSound = m_szImpactSound;
		pPhysic.m_flLifeTime = m_flLifeTime;

		//LoD setup
		pEntity.pev.iuser1 = self.pev.iuser1;
		pEntity.pev.iuser2 = self.pev.iuser2;
		pEntity.pev.iuser3 = self.pev.iuser3;
		pEntity.pev.fuser1 = self.pev.fuser1;
		pEntity.pev.fuser2 = self.pev.fuser2;
		pEntity.pev.fuser3 = self.pev.fuser3;

		//Must set spawnflags before pfnSpawn call
		pEntity.pev.spawnflags |= self.pev.spawnflags;

		Vector vecLaunchDirection = vecVelocity.Normalize();

		pEntity.pev.angles = Math.VecToAngles(vecLaunchDirection);

		g_EntityFuncs.DispatchSpawn(pEntity.edict());

		g_EntityFuncs.SetPhysicObjectTransform(pEntity.edict(), pEntity.pev.origin, m_vecShootAngles);

		/*array<EnvStudioKeyframe> Keyframes;

		EnvStudioKeyframe keyframe0;
		keyframe0.frame = 0;
		keyframe0.scale = 0.1;
		keyframe0.renderamt = 255;
		Keyframes.insertLast(keyframe0);

		EnvStudioKeyframe keyframe1;
		keyframe1.frame = 100;
		keyframe1.scale = 1;
		keyframe1.renderamt = 255;
		Keyframes.insertLast(keyframe1);

		pEntity.pev.framerate = 100;
		pEntity.pev.scale = 0.1;

		g_EntityFuncs.SetEntityEnvStudioAnim(pEntity.edict(), EnvStudioAnim_StaticFrame | EnvStudioAnim_AnimatedStudio | EnvStudioAnim_AnimatedScale, Keyframes);*/

		if(m_szFireSound.length() != 0)
		{
			g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_STATIC, m_szFireSound[Math.RandomLong(0, m_szFireSound.length() - 1)], 1, 0.33, 0, 90 + Math.RandomLong(0, 20));
		}

		if(!string(self.pev.target).IsEmpty())
		{
			g_EntityFuncs.FireTargets( string(self.pev.target), ((self.pev.spawnflags & 1) == 1) ? pEntity : self, self, USE_TYPE(m_iTriggerState), m_flTriggerValue );
		}

		Smokelit(vecAimDir, vecAimRight, vecAimUp);
	}

	void Shoot()
	{
		ShootPhysicInternal();

		if(m_flFireDuration > 0)
		{
			self.pev.nextthink = g_Engine.time + m_flFireDuration;
			SetThink(ThinkFunction(this.Shoot));
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_TOGGLE)
		{
			ShootPhysicInternal();
		}
		else if(useType == USE_ON)
		{
			self.pev.nextthink = g_Engine.time + m_flFireDuration;
			SetThink(ThinkFunction(this.Shoot));
		}
		else if(useType == USE_OFF)
		{
			self.pev.nextthink = -1;
			SetThink(null);
		}
	}
}

class CTriggerQualifier : ScriptBaseEntity
{
	string m_szSoundName = "";

	string m_szSpriteName = "";
	int m_nFrameNum = 0;
	float m_flOffsetX = 0;
	float m_flOffsetY = 0;
	int m_nSprWidth = 0;
	int m_nSprHeight = 0;
	int m_iChannel = 14;
	float m_flHoldTime = 1.0;
	RGBA m_Color = RGBA_WHITE;

	float m_flGiveFragsFirst = 0;
	float m_flGiveFragsTopFifty = 0;
	float m_flGiveFrags = 0;

	string m_szGiveFragsFirstEntity = "";
	string m_szGiveFragsTopFiftyEntity = "";
	string m_szGiveFragsEntity = "";

	string m_szWinCounter = "";
	string m_szCountdownTimer = "";
	float m_flCountdownValue = 0;

	void Precache()
	{
		BaseClass.Precache();
		if(!m_szSpriteName.IsEmpty()){
			g_Game.PrecacheModel( "sprites/" +  m_szSpriteName );
    		g_Game.PrecacheGeneric("sprites/" + m_szSpriteName );
		}
		if(!m_szSoundName.IsEmpty()){
			g_SoundSystem.PrecacheSound( m_szSoundName );
		}
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		if(szKey == "sprite"){
		    m_szSpriteName = szValue;
			return true;
		}
		if(szKey == "framenum"){
			m_nFrameNum = atoi(szValue);
			return true;
		}
		if(szKey == "holdtime"){
			m_flHoldTime = atof(szValue);
			return true;
		}
		if(szKey == "sound"){
		    m_szSoundName = szValue;
			return true;
		}
		if(szKey == "offsetx"){
		    m_flOffsetX = atof(szValue);
			return true;
		}
		if(szKey == "offsety"){
		    m_flOffsetY = atof(szValue);
			return true;
		}
		if(szKey == "channel"){
		    m_iChannel = atoi(szValue);
			return true;
		}
		if(szKey == "sprwidth"){
		    m_nSprWidth = atoi(szValue);
			return true;
		}
		if(szKey == "sprheight"){
		    m_nSprHeight = atoi(szValue);
			return true;
		}

		if(szKey == "givefragsfirst"){
		    m_flGiveFragsFirst = atof(szValue);
			return true;
		}
		if(szKey == "givefragsfirstent"){
		    m_szGiveFragsFirstEntity = szValue;
			return true;
		}
		if(szKey == "givefragstopfifty"){
		    m_flGiveFragsTopFifty = atof(szValue);
			return true;
		}
		if(szKey == "givefragstopfiftyent"){
		    m_szGiveFragsTopFiftyEntity = szValue;
			return true;
		}
		if(szKey == "givefrags"){
		    m_flGiveFrags = atof(szValue);
			return true;
		}
		if(szKey == "givefragsent"){
		    m_szGiveFragsEntity = szValue;
			return true;
		}

		if(szKey == "wincounter"){
		    m_szWinCounter = szValue;
			return true;
		}

		if(szKey == "countdowntimer"){
		    m_szCountdownTimer = szValue;
			return true;
		}
		if(szKey == "countdownval"){
		    m_flCountdownValue = atof(szValue);
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}
	
	void SendSprite( CBasePlayer@ pPlayer, const string& in strName, uint framenum = 0, float hold = 0.8 )
	{
		g_PlayerFuncs.HudToggleElement(pPlayer, m_iChannel, true);

		HUDSpriteParams params;
		params.channel = m_iChannel;
		params.flags = HUD_SPR_MASKED; 
		if((self.pev.spawnflags & 1) == 1)
			params.flags |= HUD_ELEM_SCR_CENTER_X;
		if((self.pev.spawnflags & 2) == 2)
			params.flags |= HUD_ELEM_SCR_CENTER_Y;
		params.spritename = strName;
		params.x = m_flOffsetX;
		params.y = m_flOffsetY;
		params.framerate = 0;
		params.frame = framenum;
		params.holdTime = hold;
		params.color1 = m_Color;
		params.fadeoutTime = 0.1;
		params.width = m_nSprWidth;
		params.height = m_nSprHeight;
		g_PlayerFuncs.HudCustomSprite( pPlayer, params );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(!m_szSpriteName.IsEmpty())
		{
			if(useType == USE_OFF)
			{
				if(pActivator !is null && pActivator.IsPlayer() && pActivator.IsNetClient())
				{
					CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pActivator);
					if(pPlayer.IsConnected())
						g_PlayerFuncs.HudToggleElement(pPlayer, m_iChannel, false);
				}
				else
				{
					for (int i = 1; i <= g_Engine.maxClients; i++)
					{
						CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
						if(pPlayer !is null && pPlayer.IsConnected())
							g_PlayerFuncs.HudToggleElement(pPlayer, m_iChannel, false);
					}
				}
			}
			else
			{
				if(pActivator !is null && pActivator.IsPlayer() && pActivator.IsNetClient())
				{
					CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pActivator);
					if(pPlayer.IsConnected())
						SendSprite(pPlayer, m_szSpriteName, m_nFrameNum, m_flHoldTime);
				}
				else
				{
					for (int i = 1; i <= g_Engine.maxClients; i++)
					{
						CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
						if(pPlayer !is null && pPlayer.IsConnected())
							SendSprite(pPlayer, m_szSpriteName, m_nFrameNum, m_flHoldTime);
					}
				}
			}
		}

		if(!m_szSoundName.IsEmpty())
		{
			if(useType == USE_OFF)
			{

			}
			else
			{
				if(pActivator !is null && pActivator.IsPlayer() && pActivator.IsNetClient())
				{
					CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pActivator);
					
					g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_STATIC, m_szSoundName, 0.5, 0.01, 0, PITCH_NORM, pPlayer.entindex());

					PlayerQualified(pPlayer);
				}
				else
				{
					for (int i = 1; i <= g_Engine.maxClients; i++)
					{
						CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
						if(IsPlayerAvailable(pPlayer))
						{
							g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_STATIC, m_szSoundName, 0.5, 0.01, 0, PITCH_NORM, pPlayer.entindex());
							
							PlayerQualified(pPlayer);
						}
					}
				}
			}
		}

		float flGiveFrags = m_flGiveFrags;
		string szGiveFragsEntity = m_szGiveFragsEntity;
		if(flGiveFrags > 0)
		{
			if(!m_szWinCounter.IsEmpty())
			{
				CBaseEntity @pTarget = g_EntityFuncs.FindEntityByTargetname( null, m_szWinCounter );
				if(pTarget !is null)
				{
					if(m_flGiveFragsFirst > 0 && pTarget.pev.frags == 0 )
					{
						flGiveFrags = m_flGiveFragsFirst;
						szGiveFragsEntity = m_szGiveFragsFirstEntity;
					}
					else if(m_flGiveFragsTopFifty > 0 && pTarget.pev.frags <= GetPlayerCount() * 0.5 )
					{
						flGiveFrags = m_flGiveFragsTopFifty;
						szGiveFragsEntity = m_szGiveFragsTopFiftyEntity;
					}
				}
			}
			else
			{
				if(m_flGiveFragsFirst > 0)
				{
					flGiveFrags = m_flGiveFragsFirst;
					szGiveFragsEntity = m_szGiveFragsFirstEntity;
				}
			}

			if(useType == USE_OFF)
			{

			}
			else
			{
				if(pActivator !is null && pActivator.IsPlayer() && pActivator.IsNetClient())
				{
					CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pActivator);

					pPlayer.pev.frags += flGiveFrags;

					if(!szGiveFragsEntity.IsEmpty())
						g_EntityFuncs.FireTargets( szGiveFragsEntity, pActivator, self, USE_TOGGLE, flGiveFrags );

					if((self.pev.spawnflags & 4) == 4)
					{
						pPlayer.pev.health = 0.0;
						pPlayer.pev.deadflag = DEAD_DYING;
						pPlayer.pev.takedamage = DAMAGE_NO;
						pPlayer.pev.movetype = MOVETYPE_NOCLIP;
						pPlayer.pev.solid = SOLID_NOT;
						pPlayer.pev.gamestate = 1;
						pPlayer.pev.effects |= EF_NODRAW;
						pPlayer.GetObserver().StartObserver( pPlayer.pev.origin, pPlayer.pev.angles, false );
						pPlayer.GetObserver().SetMode(OBS_CHASE_LOCKED);
						pPlayer.GetObserver().SetObserverModeControlEnabled(true);
						pPlayer.SetMaxSpeedOverride( -1 );
						pPlayer.m_flRespawnDelayTime = 999999;
					}
				}
				else
				{
					for (int i = 1; i <= g_Engine.maxClients; i++)
					{
						CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
						if(IsPlayerAvailable(pPlayer))
						{
							pPlayer.pev.frags += flGiveFrags;

							if(!szGiveFragsEntity.IsEmpty())
								g_EntityFuncs.FireTargets( szGiveFragsEntity, pPlayer, self, USE_TOGGLE, flGiveFrags );
							
							if((self.pev.spawnflags & 4) == 4)
							{
								pPlayer.pev.health = 0.0;
								pPlayer.pev.deadflag = DEAD_DYING;
								pPlayer.pev.takedamage = DAMAGE_NO;
								pPlayer.pev.movetype = MOVETYPE_NOCLIP;
								pPlayer.pev.solid = SOLID_NOT;
								pPlayer.pev.gamestate = 1;
								pPlayer.pev.effects |= EF_NODRAW;
								pPlayer.GetObserver().StartObserver( pPlayer.pev.origin, pPlayer.pev.angles, false );
								pPlayer.GetObserver().SetMode(OBS_CHASE_LOCKED);
								pPlayer.GetObserver().SetObserverModeControlEnabled(true);
								pPlayer.SetMaxSpeedOverride( -1 );
								pPlayer.m_flRespawnDelayTime = 999999;
							}
						}
					}
				}
			}
		}

		if(!m_szWinCounter.IsEmpty())
		{
			g_EntityFuncs.FireTargets( m_szWinCounter, pActivator, self, USE_ON, 0 );
		}

		if(!m_szCountdownTimer.IsEmpty())
		{
			g_EntityFuncs.FireTargets( m_szCountdownTimer, pActivator, self, USE_SET, m_flCountdownValue );
		}
	}
}

class CTriggerReviveFx : ScriptBaseEntity
{
	string m_szSoundName = "fallguys/revive.ogg";
	string m_szBurstSpriteName = "sprites/fallguys/burstline2.spr";
	string m_szSwirlModelName = "models/fallguys/respawnswirl.mdl";
	string m_szBurstModelName = "models/fallguys/burstline.mdl";

	int m_iBurstSprite = 0;
	int m_iBurstSpriteFrame = 0;
	int m_iSwirlModel = 0;
	int m_iBurstModel = 0;

	void Precache()
	{
		BaseClass.Precache();

		g_SoundSystem.PrecacheSound(m_szSoundName);
		
		m_iSwirlModel = g_Game.PrecacheModel(m_szSwirlModelName);
		
		m_iBurstModel = g_Game.PrecacheModel(m_szBurstModelName);

		m_iBurstSprite = g_Game.PrecacheModel(m_szBurstSpriteName);

		m_iBurstSpriteFrame = g_EngineFuncs.ModelFrames(m_iBurstSprite);
	}

	int m_iTickCount = 0;
	int m_iEmitState = 0;
	int m_iPlayerIndex = 0;

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		self.pev.nextthink = g_Engine.time;
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		return BaseClass.KeyValue( szKey, szValue );
	}

	void ReviveSound()
	{
		g_SoundSystem.EmitSoundDyn(self.edict(), CHAN_STATIC, m_szSoundName, 1, ATTN_NORM, 0, PITCH_NORM );
	}

	void SwirlModel()
	{
		CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", self.pev.origin, g_vecZero, false);

		g_EntityFuncs.SetModel(pEntity, m_szSwirlModelName);

		pEntity.pev.framerate = 1.0;
		pEntity.pev.scale = 1.0;
		pEntity.pev.solid = SOLID_NOT;
		pEntity.pev.movetype = MOVETYPE_NOCLIP;
		pEntity.pev.rendermode = kRenderNormal;
		pEntity.pev.spawnflags = 0;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_STUDIO;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;

		CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));

		pStudio.m_flUpdateRate = 0.1;
		pStudio.StartStudioSequence(0);
	}

	void BurstLine()
	{
		Vector vecMins = Vector(self.pev.origin.x - 24, self.pev.origin.y - 24, self.pev.origin.z + 24);
		Vector vecMaxs = Vector(self.pev.origin.x + 24, self.pev.origin.y + 24, self.pev.origin.z + 48);
		Vector vecRandom = Vector(
			Math.RandomFloat(vecMins.x, vecMaxs.x), 
			Math.RandomFloat(vecMins.y, vecMaxs.y), 
			Math.RandomFloat(vecMins.z, vecMaxs.z));

		Vector vecDirection = vecRandom - self.pev.origin;
		vecDirection = vecDirection.Normalize();
		vecDirection = vecDirection * 10.0;
		vecDirection.z += 140;

		CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecRandom, g_vecZero, false);

		g_EntityFuncs.SetModel(pEntity, m_szBurstSpriteName);
		
		pEntity.pev.scale = Math.RandomFloat(0.14, 0.18);
		pEntity.pev.solid = SOLID_NOT;
		pEntity.pev.movetype = MOVETYPE_NOCLIP;
		pEntity.pev.rendermode = kRenderTransAlpha;
		pEntity.pev.renderamt = 255;
		pEntity.pev.rendercolor = Vector(255, 255, 255);
		pEntity.pev.velocity = vecDirection;
		pEntity.pev.framerate = 15.0;
		pEntity.pev.spawnflags = 0;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_BOUND_EXCCEEDED;
		pEntity.pev.vuser1 = Vector(-999999, -999999, -999999);
		pEntity.pev.vuser2 = Vector(999999, 999999, 999999);
		pEntity.pev.vuser2.z = self.pev.origin.z + 128;

		CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));
		pStudio.m_flUpdateRate = 0.1;
		pStudio.m_flMaxFrame = float(m_iBurstSpriteFrame - 1);

		pStudio.StartSpriteAnim(0);
	}

	void BurstLineSmall()
	{
		Vector vecMins = Vector(self.pev.origin.x - 24, self.pev.origin.y - 24, self.pev.origin.z + 24);
		Vector vecMaxs = Vector(self.pev.origin.x + 24, self.pev.origin.y + 24, self.pev.origin.z + 48);
		Vector vecRandom = Vector(
			Math.RandomFloat(vecMins.x, vecMaxs.x), 
			Math.RandomFloat(vecMins.y, vecMaxs.y), 
			Math.RandomFloat(vecMins.z, vecMaxs.z));

		Vector vecDirection = vecRandom - self.pev.origin;
		vecDirection = vecDirection.Normalize();
		vecDirection = vecDirection * 10.0;
		vecDirection.z += 200;

		CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecRandom, g_vecZero, false);

		g_EntityFuncs.SetModel(pEntity, m_szBurstSpriteName);
		
		pEntity.pev.scale = Math.RandomFloat(0.08, 0.12);
		pEntity.pev.solid = SOLID_NOT;
		pEntity.pev.movetype = MOVETYPE_NOCLIP;
		pEntity.pev.rendermode = kRenderTransAlpha;
		pEntity.pev.renderamt = 255;
		pEntity.pev.rendercolor = Vector(255, 255, 255);
		pEntity.pev.velocity = vecDirection;
		pEntity.pev.framerate = 0;
		pEntity.pev.spawnflags = 0;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_BOUND_EXCCEEDED;
		pEntity.pev.vuser1 = Vector(-999999, -999999, -999999);
		pEntity.pev.vuser2 = Vector(999999, 999999, 999999);
		pEntity.pev.vuser2.z = self.pev.origin.z + 128;

		CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));
		pStudio.m_flUpdateRate = 0.02;
		pStudio.m_flMaxFrame = float(m_iBurstSpriteFrame - 1);

		pStudio.StartSpriteAnim(float(Math.RandomLong(m_iBurstSpriteFrame - 2, m_iBurstSpriteFrame - 1)));
	}

	void BurstLineShoot()
	{
		Vector vecMins = Vector(self.pev.origin.x - 4, self.pev.origin.y - 4, self.pev.origin.z + 1.5);
		Vector vecMaxs = Vector(self.pev.origin.x + 4, self.pev.origin.y + 4, self.pev.origin.z + 5.5);
		Vector vecRandom = Vector(
			Math.RandomFloat(vecMins.x, vecMaxs.x), 
			Math.RandomFloat(vecMins.y, vecMaxs.y), 
			Math.RandomFloat(vecMins.z, vecMaxs.z));

		Vector vecDirection = vecRandom - self.pev.origin;
		vecDirection = vecDirection.Normalize();

		CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecRandom, Math.VecToAngles(vecDirection), false);

		vecDirection = vecDirection * 300;

		g_EntityFuncs.SetModel(pEntity, m_szBurstModelName);

		pEntity.pev.framerate = 1.0;
		pEntity.pev.scale = 1.0;
		pEntity.pev.solid = SOLID_NOT;
		pEntity.pev.movetype = MOVETYPE_NOCLIP;
		pEntity.pev.rendermode = kRenderNormal;
		pEntity.pev.spawnflags = 0;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_STUDIO;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;
		pEntity.pev.velocity = vecDirection;

		CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));

		pStudio.m_flUpdateRate = 0.02;
		pStudio.StartStudioSequence(0);
	}

	void Think()
	{
		if((m_iEmitState & 1) == 0)
		{
			ReviveSound();

			m_iEmitState |= 1;
		}
		
		if((m_iEmitState & 2) == 0)
		{
			SwirlModel();

			m_iEmitState |= 2;
		}

		if((m_iEmitState & 4) == 0 && m_iTickCount >= 4 && m_iTickCount <= 12)
		{
			if((m_iTickCount % 2) == 0)
				BurstLine();
			else
				BurstLineSmall();
		}
		
		if((m_iEmitState & 8) == 0 && m_iTickCount >= 7 && m_iTickCount <= 9)
		{
			int burstCount = Math.RandomLong(1, 3);

			for(int i = 0;i < burstCount; ++i)
				BurstLineShoot();
		}

		m_iTickCount ++;
		self.pev.nextthink = g_Engine.time + 0.1;

		if(m_iTickCount >= 20)
		{
			self.pev.flags |= FL_KILLME;
		}
	}
}

class CTriggerFallBallGoal : ScriptBaseEntity
{
	string m_szSoundName = "fallguys/fallballgoal.ogg";

	int m_iGoalTeam = 0;
	int m_iChannel = 15;
	int m_nCurrentTick = 0;
	float m_flStartTime = 0;
	float m_flHoldTime = 1;
	float m_flOffsetX = 0;
	float m_flOffsetY = 0;

	array<string> m_szSmokeSprite;

	string m_szConfettitModel = "models/fallguys/confettit.mdl";
	int m_iConfettitModel = 0;

	string m_szConfettitShortModel = "models/fallguys/confettit2.mdl";
	int m_iConfettitShortModel = 0;

	string m_szVFXStarSprite = "sprites/fallguys/vfxstar.spr";
	int m_iVFXStarSprite = 0;

	void Precache()
	{
		BaseClass.Precache();

		g_SoundSystem.PrecacheSound(m_szSoundName);

		for(int i = 0;i < int(m_szSmokeSprite.length()); ++i)
		{
			g_Game.PrecacheModel( m_szSmokeSprite[i] );
		}

		m_iConfettitModel = g_Game.PrecacheModel( m_szConfettitModel );
		m_iConfettitShortModel = g_Game.PrecacheModel( m_szConfettitShortModel );
		m_iVFXStarSprite = g_Game.PrecacheModel( m_szVFXStarSprite );
	}

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "goalteam"){
			m_iGoalTeam = atoi(szValue);
			return true;
		}
		if(szKey == "channel"){
			m_iChannel = atoi(szValue);
			return true;
		}
		if(szKey == "holdtime"){
			m_flHoldTime = atof(szValue);
			return true;
		}
		if(szKey == "offsetx"){
		    m_flOffsetX = atof(szValue);
			return true;
		}
		if(szKey == "offsety"){
		    m_flOffsetY = atof(szValue);
			return true;
		}
		if(szKey.StartsWith("smokesprite_")){
			m_szSmokeSprite.insertLast(szValue);
			return true;
		}
		return BaseClass.KeyValue( szKey, szValue );
	}

	void SendScore( CBasePlayer@ pPlayer, float score, float hold = 0.8 )
	{
		g_PlayerFuncs.HudToggleElement(pPlayer, m_iChannel, true);

		HUDNumDisplayParams numParams;
		numParams.x = m_flOffsetX;
		numParams.y = m_flOffsetY;
		numParams.effect = 0;
		numParams.color1 = RGBA_WHITE;
		numParams.color2 = RGBA_WHITE;
		numParams.fadeinTime = 0.1;
		numParams.fadeoutTime = 0.1;
		numParams.holdTime = hold;
		numParams.fxTime = 0.0;
		numParams.channel = m_iChannel;
		numParams.defdigits = 1;
		numParams.maxdigits = 2;
		numParams.value = score;
		g_PlayerFuncs.HudNumDisplay(pPlayer, numParams);
	}
	
	void UpdateScore( CBasePlayer@ pPlayer, float score )
	{
		g_PlayerFuncs.HudUpdateNum(pPlayer, m_iChannel, score);
	}

	void SendScores()
	{
		for (int i = 1; i <= g_Engine.maxClients; i++)
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
			if(pPlayer !is null && pPlayer.IsConnected())
			{
				if((m_nCurrentTick % 5) == 0)
					SendScore(pPlayer, self.pev.frags, m_flStartTime + m_flHoldTime - g_Engine.time);
				else
					UpdateScore(pPlayer, self.pev.frags);
			}
		}

		m_nCurrentTick += 1;
	}

	void HideScore( CBasePlayer@ pPlayer )
	{
		g_PlayerFuncs.HudToggleElement(pPlayer, m_iChannel, false);
	}

	void HideScores()
	{
		for (int i = 1; i <= g_Engine.maxClients; i++)
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
			if(pPlayer !is null && pPlayer.IsConnected())
			{
				HideScore(pPlayer);
			}
		}
	}

	void PlayELight()
	{
		NetworkMessage m(MSG_PVS, NetworkMessages::SVC_TEMPENTITY, self.pev.origin);
		m.WriteByte(TE_ELIGHT);
		m.WriteShort(self.entindex());
		m.WriteCoord(self.pev.origin.x);
		m.WriteCoord(self.pev.origin.y);
		m.WriteCoord(self.pev.origin.z);
		m.WriteCoord(128);
		m.WriteByte(255);
		m.WriteByte(255);
		m.WriteByte(255);
		m.WriteByte(5);
		m.WriteCoord(50);
		m.End();
	}

	void PlayDLight()
	{
		NetworkMessage m(MSG_PVS, NetworkMessages::SVC_TEMPENTITY, self.pev.origin);
		m.WriteByte(TE_DLIGHT);
		m.WriteCoord(self.pev.origin.x);
		m.WriteCoord(self.pev.origin.y);
		m.WriteCoord(self.pev.origin.z);
		m.WriteByte(50);
		m.WriteByte(255);
		m.WriteByte(255);
		m.WriteByte(255);
		m.WriteByte(5);
		m.WriteByte(50);
		m.End();
	}

	void VFXStars(const Vector &in vecAimDir, const Vector &in vecAimRight, const Vector &in vecAimUp)
	{
		NetworkMessage m(MSG_PVS, NetworkMessages::SVC_TEMPENTITY, self.pev.origin);
		m.WriteByte(TE_BUBBLES);
		m.WriteCoord(self.pev.origin.x - 100);
		m.WriteCoord(self.pev.origin.y - 600);
		m.WriteCoord(self.pev.origin.z - 200);
		m.WriteCoord(self.pev.origin.x + 100);
		m.WriteCoord(self.pev.origin.y + 600);
		m.WriteCoord(self.pev.origin.z + 0);
		m.WriteCoord(300);
		m.WriteShort(m_iVFXStarSprite);
		m.WriteByte(20);
		m.WriteCoord(50);
		m.End();
	}

	void ColorfulConfettits(const Vector &in vecAimDir, const Vector &in vecAimRight, const Vector &in vecAimUp)
	{
		Vector vecSource = self.pev.origin;
		Vector vecDirection = vecAimDir + vecAimUp * 1.5;
		vecDirection = vecDirection.Normalize();

		Vector vecVelocity = vecDirection * 300;

		if(m_iConfettitShortModel > 0)
		{
			NetworkMessage m(MSG_PVS, NetworkMessages::SVC_TEMPENTITY, vecSource);
			m.WriteByte(TE_BREAKMODEL);
			m.WriteCoord(vecSource.x);
			m.WriteCoord(vecSource.y);
			m.WriteCoord(vecSource.z);
			m.WriteCoord(200);
			m.WriteCoord(600);
			m.WriteCoord(200);
			m.WriteCoord(vecVelocity.x);
			m.WriteCoord(vecVelocity.y);
			m.WriteCoord(vecVelocity.z);
			m.WriteByte(10);
			m.WriteShort(m_iConfettitShortModel);
			m.WriteByte(40);
			m.WriteByte(25);
			m.WriteByte(0);
			m.End();
		}

		if(m_iConfettitModel > 0)
		{
			NetworkMessage m(MSG_PVS, NetworkMessages::SVC_TEMPENTITY, vecSource);
			m.WriteByte(TE_BREAKMODEL);
			m.WriteCoord(vecSource.x);
			m.WriteCoord(vecSource.y);
			m.WriteCoord(vecSource.z);
			m.WriteCoord(200);
			m.WriteCoord(600);
			m.WriteCoord(200);
			m.WriteCoord(vecVelocity.x);
			m.WriteCoord(vecVelocity.y);
			m.WriteCoord(vecVelocity.z);
			m.WriteByte(10);
			m.WriteShort(m_iConfettitModel);
			m.WriteByte(8);
			m.WriteByte(25);
			m.WriteByte(0x10);
			m.End();
		}
	}

	void ColorfulSmokelit(const Vector &in vecAimDir, const Vector &in vecAimRight, const Vector &in vecAimUp)
	{
		if(m_szSmokeSprite.length() == 0)
			return;

		array<float> vRightUpArray = { 
				0.000, 1.000,
				0.707, 0.707,
				1.000, 0.000,
				0.707, -0.707,
				0.000, -1.000,
				-0.707, -0.707,
				-1.000, 0.000,
				-0.707, 0.707
		};
		for(int i = 0;i < int(vRightUpArray.length()) / 2; i++)
		{
			//if(Math.RandomLong(0, 3) == 0)
			//	continue;

			Vector vecSmokeSource = self.pev.origin;
			Vector vecSmokeDirection = vecAimDir + vecAimRight * vRightUpArray[i * 2 + 0] + vecAimUp * vRightUpArray[i * 2 + 1] * 0.25;
			vecSmokeDirection.z += 0.1;
			vecSmokeDirection = vecSmokeDirection.Normalize();

			vecSmokeSource = vecSmokeSource + vecSmokeDirection * Math.RandomFloat(100, 200);

			CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecSmokeSource, g_vecZero, false);

			g_EntityFuncs.SetModel(pEntity, m_szSmokeSprite[Math.RandomLong(0, int(m_szSmokeSprite.length()) - 1 )]);

			pEntity.pev.scale = Math.RandomFloat(0.4, 0.8);
			pEntity.pev.solid = SOLID_NOT;
			pEntity.pev.movetype = MOVETYPE_NOCLIP;
			pEntity.pev.rendermode = kRenderTransAlpha;
			pEntity.pev.renderamt = 192;

			Vector Color1 = Vector(200, 0, 252);
			Vector Color2 = Vector(0, 200, 0);
			Vector Color3 = Vector(255, 0, 0);
			Vector Color4 = Vector(0, 255, 0);
			Vector Color5 = Vector(200, 0, 0);
			array<Vector> colors = {Color1, Color2, Color3, Color4, Color5, Color1, Color1, Color1};
			pEntity.pev.rendercolor = colors[Math.RandomLong(0, int(colors.length() - 1))];
			pEntity.pev.velocity = vecSmokeDirection * 200;
			pEntity.pev.avelocity = Vector(0, 0, Math.RandomFloat(30, 60));
			pEntity.pev.framerate = 10;
			pEntity.pev.spawnflags = 0;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_RENDERAMT;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SCALE;
			pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_STATIC_FRAME;
			pEntity.pev.frame = Math.RandomLong(0, 8);

			CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));
			pStudio.m_flUpdateRate = 0.0;
			pStudio.m_flMaxFrame = 10;

			EnvStudioKeyframe keyframe0;
			keyframe0.frame = 0;
			keyframe0.renderamt = 192;
			keyframe0.scale = pEntity.pev.scale * 0.6;
			pStudio.m_Keyframes.insertLast(keyframe0);

			EnvStudioKeyframe keyframe1;
			keyframe1.frame = 2;
			keyframe1.renderamt = 255;
			keyframe1.scale = pEntity.pev.scale * 0.8;
			pStudio.m_Keyframes.insertLast(keyframe1);

			EnvStudioKeyframe keyframe2;
			keyframe2.frame = 5;
			keyframe2.renderamt = 80;
			keyframe2.scale = pEntity.pev.scale;
			pStudio.m_Keyframes.insertLast(keyframe2);

			EnvStudioKeyframe keyframe3;
			keyframe3.frame = 10;
			keyframe3.renderamt = 0;
			keyframe3.scale = pEntity.pev.scale * 1.1;
			pStudio.m_Keyframes.insertLast(keyframe3);

			pStudio.StartSpriteAnim(0);
		}
	}

	void PlayFX(CBaseEntity@ pActivator, CBaseEntity@ pCaller)
	{
		PlayDLight();
		PlayELight();

		Vector vecAimDir = GetAimDir(self);

		Vector vecAimRight = g_Engine.v_right;

		Vector vecAimUp = g_Engine.v_up;
		
		ColorfulSmokelit(vecAimDir, vecAimRight, vecAimUp);
		ColorfulConfettits(vecAimDir, vecAimRight, vecAimUp);
		VFXStars(vecAimDir, vecAimRight, vecAimUp);

		g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_STATIC, m_szSoundName, 1, 0.01, 0, PITCH_NORM );
	}

	void GetPlayers()
	{
		self.pev.health = 0;
		for (int i = 1; i <= g_Engine.maxClients; i++)
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
			if(IsPlayerAvailable(pPlayer) && pPlayer.Classify() == m_iGoalTeam)
			{
				self.pev.health += 1;
			}
		}
	}

	void UpdateThink()
	{
		SendScores();
		GetPlayers();

		self.pev.nextthink = g_Engine.time + 1.0;
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_ON)
		{
			m_flStartTime = g_Engine.time;
			m_nCurrentTick = 0;

			SetThink(ThinkFunction(this.UpdateThink));
			self.pev.nextthink = g_Engine.time + 0.0;
		}
		else if(useType == USE_OFF)
		{
			HideScores();

			m_flStartTime = 0;
			m_nCurrentTick = 0;

			SetThink(null);
			self.pev.nextthink = 0;
		}
		else if(useType == USE_TOGGLE)
		{
			self.pev.frags += 1;

			PlayFX(pActivator, pCaller);

			if(!string(self.pev.target).IsEmpty())
			{
				g_EntityFuncs.FireTargets( string(self.pev.target), pActivator, self, USE_TOGGLE, 0 );
			}
		}
		else if(useType == USE_SET)
		{
			
		}
	}
}

class CTriggerReviver : ScriptBaseEntity
{
	string m_szSoundName = "fallguys/revive.ogg";
	string m_szBurstSpriteName = "sprites/fallguys/burstline2.spr";
	string m_szSwirlModelName = "models/fallguys/respawnswirl.mdl";
	string m_szBurstModelName = "models/fallguys/burstline.mdl";

	int m_iBurstSprite = 0;
	int m_iBurstSpriteFrame = 0;
	int m_iSwirlModel = 0;
	int m_iBurstModel = 0;
	
	void Precache()
	{
		BaseClass.Precache();

		g_SoundSystem.PrecacheSound(m_szSoundName);
		
		m_iSwirlModel = g_Game.PrecacheModel(m_szSwirlModelName);
		
		m_iBurstModel = g_Game.PrecacheModel(m_szBurstModelName);

		m_iBurstSprite = g_Game.PrecacheModel(m_szBurstSpriteName);

		m_iBurstSpriteFrame = g_EngineFuncs.ModelFrames(m_iBurstSprite);
	}

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		return BaseClass.KeyValue( szKey, szValue );
	}

	void PlayFX(CBaseEntity@ pActivator, CBaseEntity@ pCaller)
	{
		if(!pActivator.IsPlayer())
			return;

		if(!pActivator.IsAlive())
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pActivator);

		CBaseEntity@ pEntity = g_EntityFuncs.Create("trigger_revive_fx", pPlayer.pev.origin, g_vecZero, false);

		TraceResult tr;
		g_Utility.TraceLine(pPlayer.pev.origin, pPlayer.pev.origin + Vector(0, 0, -64), ignore_monsters, dont_ignore_glass, pPlayer.edict(), tr);

		pEntity.pev.origin = tr.vecEndPos + Vector(0, 0, 8);

		CTriggerReviveFx@ pFxEntity = cast<CTriggerReviveFx@>(CastToScriptClass(pEntity));
		pFxEntity.m_iPlayerIndex = pPlayer.entindex();

		PlayerStartFreeze(pPlayer, pPlayer.entindex(), pCaller, 0, 0.0001, 1, 0.8, true);
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_ON)
		{
			
		}
		else if(useType == USE_OFF)
		{
			
		}
		else if(useType == USE_TOGGLE)
		{
			PlayFX(pActivator, pCaller);
		}
		else if(useType == USE_SET)
		{
			
		}
	}
}

class CTriggerCheckPointer : ScriptBaseEntity
{
	string m_szSoundName = "fallguys/checkpoint.ogg";

	string m_szCircleModelName = "models/fallguys/checkpoint.mdl";

	int m_iCircleModel = 0;
	
	void Precache()
	{
		BaseClass.Precache();

		g_SoundSystem.PrecacheSound(m_szSoundName);

		m_iCircleModel = g_Game.PrecacheModel(m_szCircleModelName);
	}

	void Spawn()
	{
		Precache();

		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		return BaseClass.KeyValue( szKey, szValue );
	}

	void CheckPointSound(CBaseEntity @pOther)
	{
		g_SoundSystem.PlaySound(pOther.edict(), CHAN_MUSIC, m_szSoundName, 1, 0.01, 0, PITCH_NORM, pOther.entindex());
	}

	void CircleModel(CBasePlayer @pPlayer, const Vector & in origin, const Vector & in angles)
	{
		CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", origin, angles, false);

		g_EntityFuncs.SetModel(pEntity, m_szCircleModelName);

		pEntity.pev.skin = Math.RandomLong(0, 3);
		pEntity.pev.framerate = 1.0;
		pEntity.pev.scale = 1.0;
		pEntity.pev.solid = SOLID_NOT;
		pEntity.pev.movetype = MOVETYPE_NOCLIP;
		pEntity.pev.rendermode = kRenderNormal;
		pEntity.pev.spawnflags = 0;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_STUDIO;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;

		CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));

		pStudio.m_flUpdateRate = 0.1;
		pStudio.StartStudioSequence(0);

		g_EntityFuncs.SetEntitySemiVisible(pEntity.edict(), (1 << (pPlayer.entindex() - 1)) );
	}

	void PlayFX(CBaseEntity@ pActivator, CBaseEntity@ pCaller)
	{
		if(!pActivator.IsPlayer())
			return;

		if(!pActivator.IsAlive())
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pActivator);

		Vector angles = Vector(-90, g_EngineFuncs.VecToYaw(pPlayer.pev.velocity), 0);
		
		Vector vel = pPlayer.pev.velocity;
		
		vel.z = 0;

		Vector origin = pPlayer.pev.origin + vel * 0.33;

		CircleModel(pPlayer, origin, angles);

		CheckPointSound(pActivator);
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_ON)
		{
			
		}
		else if(useType == USE_OFF)
		{
			
		}
		else if(useType == USE_TOGGLE)
		{
			PlayFX(pActivator, pCaller);
		}
		else if(useType == USE_SET)
		{
			
		}
	}
}

class CTriggerSortPanel : ScriptBaseEntity
{
	string m_szNameStartWith;
	string m_szClassnameFilter;
	int m_iStatusFilter = 0;

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "name_startwith"){			
			m_szNameStartWith = szValue;
			return true;
		}
		if(szKey == "classname_filter"){			
			m_szClassnameFilter = szValue;
			return true;
		}
		if(szKey == "status_filter"){			
			m_iStatusFilter = atoi(szValue);
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void ClearErrors()
	{
		//Clear load_script_error
		CBaseEntity@ pEntity = null;

		while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, "error_load")) !is null)
		{
			g_EntityFuncs.Remove(pEntity);
		}
	}

	void SortPanels()
	{
		array<CBaseEntity@> arrayPanelEntities = {};

		CBaseEntity@ pEntity = null;
		while((@pEntity = g_EntityFuncs.FindEntityByClassname(pEntity, m_szClassnameFilter)) !is null)
		{
			if( string(pEntity.pev.targetname).StartsWith(m_szNameStartWith)){

				if(m_iStatusFilter == 1 && pEntity.pev.deadflag != DEAD_NO)
					continue;
				else if(m_iStatusFilter == 2 && pEntity.pev.deadflag == DEAD_NO)
					continue;

				arrayPanelEntities.insertLast(pEntity);
			}
		}

		if(arrayPanelEntities.length() > 0)
		{
			//Shuffule
			array<int> rnd( arrayPanelEntities.length() );

			for (int i = 0; i < int(arrayPanelEntities.length()); i++)
			{
				rnd[i] = i;
			}

			if((self.pev.spawnflags & 1) == 1)
			{
				for (int i = int(arrayPanelEntities.length()) - 1; i >= 0; i --)
				{
					int randomIndex = g_PlayerFuncs.SharedRandomLong( uint(g_Engine.time * 100.0) + i, 0, i );//Math.RandomLong(0, i);
					int temp = rnd[randomIndex];
					rnd[randomIndex] = rnd[i];
					rnd[i] = temp;
				}
			}

			float yaw = 360.0 / float(arrayPanelEntities.length());

			for (int i = 0; i < int(arrayPanelEntities.length()); i++)
			{
				arrayPanelEntities[i].pev.angles = Vector(0, yaw * rnd[i], 0);
				g_EntityFuncs.SetOrigin( arrayPanelEntities[i], arrayPanelEntities[i].pev.origin );
			}
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_ON)
		{
			ClearErrors();
			SortPanels();
		}
		else if(useType == USE_OFF)
		{
			
		}
		else if(useType == USE_TOGGLE)
		{
			ClearErrors();
			SortPanels();
		}
		else if(useType == USE_SET)
		{
			
		}
	}
}

class CTriggerFindBrush : ScriptBaseEntity
{
	string m_szFilterClassName = "";
	string m_szFilterTargetName = "";

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		if(szKey == "filter_classname"){
			m_szFilterClassName = szValue;
			return true;
		}
		if(szKey == "filter_targetname"){
			m_szFilterTargetName = szValue;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		Vector vecMins = self.pev.mins;
		Vector vecMaxs = self.pev.maxs;
		if((self.pev.spawnflags & 1) == 1){
			vecMins.x += pActivator.pev.origin.x;
			vecMins.y += pActivator.pev.origin.y;
			vecMins.z += pActivator.pev.origin.z;

			vecMaxs.x += pActivator.pev.origin.x;
			vecMaxs.y += pActivator.pev.origin.y;
			vecMaxs.z += pActivator.pev.origin.z;
		}

		//g_Game.AlertMessage( at_console, "Activator is %1 %2\n", pActivator.pev.netname, pActivator.pev.targetname);
		//g_Game.AlertMessage( at_console, "Search mins %1 %2 %3\n", vecMins.x, vecMins.y, vecMins.z );
		//g_Game.AlertMessage( at_console, "Search maxs %1 %2 %3\n", vecMaxs.x, vecMaxs.y, vecMaxs.z );

		array<CBaseEntity@> brushes( 32 );
    	int iNumBrushes = g_EntityFuncs.BrushEntsInBox( @brushes, vecMins, vecMaxs );

		if(iNumBrushes < 1)
			return;

		for (int i = 0; i < iNumBrushes; i++)
		{
			if(m_szFilterClassName != "")
			{
				if(brushes[i].pev.classname != m_szFilterClassName)
					continue;
			}

			if(m_szFilterTargetName != "")
			{
				if(brushes[i].pev.targetname != m_szFilterTargetName)
					continue;
			}

			g_EntityFuncs.FireTargets( self.pev.target, brushes[i], self, useType );
		}
	}
}

class CTriggerPhysicTrigger : ScriptBaseEntity
{
	int m_iTriggerState = USE_TOGGLE;
	float m_flTriggerValue = 0;
	float m_flDelay = 1.0;
	float m_flNextTrigger = 0;
	string m_szTeleportTarget;

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_NOT;
		self.pev.movetype = MOVETYPE_NONE;
		self.pev.effects |= EF_NODRAW;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

		g_EntityFuncs.CreatePhysicTrigger(self.edict());

		m_flNextTrigger = g_Engine.time;

		if((self.pev.spawnflags & SF_TRIGGER_PHYSIC_ON) == SF_TRIGGER_PHYSIC_ON)
		{
			SetTouch(TouchFunction(this.PhysicTouch));
		}
		else
		{
			SetTouch(null);
		}
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "triggerstate"){
			m_iTriggerState = atoi(szValue);
			return true;
		}

		if(szKey == "triggervalue"){
			m_flTriggerValue = atof(szValue);
			return true;
		}

		if(szKey == "delay"){
			m_flDelay = atof(szValue);
			return true;
		}

		if(szKey == "teleport_target"){
			m_szTeleportTarget = szValue;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}
	
	void PhysicTouch( CBaseEntity@ pOther )
	{
		if((self.pev.spawnflags & SF_TRIGGER_PHYSIC_ON) == SF_TRIGGER_PHYSIC_ON)
		{
			if(!string(self.pev.target).IsEmpty() && g_Engine.time > m_flNextTrigger)
			{
				g_EntityFuncs.FireTargets( string(self.pev.target), pOther, self, USE_TYPE(m_iTriggerState), m_flTriggerValue );

				if((self.pev.spawnflags & SF_TRIGGER_PHYSIC_TELEPORT_ON_TOUCH) == SF_TRIGGER_PHYSIC_TELEPORT_ON_TOUCH)
				{
					if(!m_szTeleportTarget.IsEmpty())
					{
						CBaseEntity @pTarget = g_EntityFuncs.FindEntityByTargetname( null, m_szTeleportTarget );

						if(pTarget !is null)
						{
							//Clear linear velocity and angular velocity
							pOther.pev.vuser1 = g_vecZero;
							pOther.pev.vuser2 = g_vecZero;
							g_EntityFuncs.SetPhysicObjectTransform(pOther.edict(), pTarget.pev.origin, pTarget.pev.angles);
						}
					}
				}
				else if((self.pev.spawnflags & SF_TRIGGER_PHYSIC_DELETE_ON_TOUCH) == SF_TRIGGER_PHYSIC_DELETE_ON_TOUCH)
				{
					pOther.pev.flags |= FL_KILLME;
				}

				m_flNextTrigger = g_Engine.time + m_flDelay;
			}
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_TOGGLE)
		{
			if((self.pev.spawnflags & SF_TRIGGER_PHYSIC_ON) == SF_TRIGGER_PHYSIC_ON)
			{
				self.pev.spawnflags &= ~SF_TRIGGER_PHYSIC_ON;
				SetTouch(null);
			}
			else
			{
				self.pev.spawnflags |= SF_TRIGGER_PHYSIC_ON;
				SetTouch(TouchFunction(this.PhysicTouch));
			}
		}
		else if(useType == USE_ON)
		{
			self.pev.spawnflags |= SF_TRIGGER_PHYSIC_ON;
				SetTouch(TouchFunction(this.PhysicTouch));
		}
		else if(useType == USE_OFF)
		{
			if((self.pev.spawnflags & SF_TRIGGER_PHYSIC_ON) == SF_TRIGGER_PHYSIC_ON)
			{
				self.pev.spawnflags &= ~SF_TRIGGER_PHYSIC_ON;
				SetTouch(null);
			}
		}
		else if(useType == USE_SET)
		{
			
		}
	}
}

class CTriggerFreeze : ScriptBaseEntity
{
	int m_iNewMaxSpeed = 0;
	float m_flNewGravity = 1;
	float m_flNewFriction = 1;
	string m_szNewCheckPoint = "";

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_TRIGGER;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "newmaxspeed"){
			m_iNewMaxSpeed = atoi(szValue);
			return true;
		}
		if(szKey == "newgravity"){
			m_flNewGravity = atof(szValue);
			return true;
		}
		if(szKey == "newfriction"){
			m_flNewFriction = atof(szValue);
			return true;
		}
		if(szKey == "newcheckpoint"){
			m_szNewCheckPoint = szValue;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}
	
	void Touch( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		if((self.pev.spawnflags & SF_TRIGGER_FREEZE_ON) == SF_TRIGGER_FREEZE_ON)
		{
			CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pOther);

			PlayerStartFreeze(pPlayer, pPlayer.entindex(), self, m_iNewMaxSpeed, m_flNewGravity, m_flNewFriction, 0.05, false );
		
			if((self.pev.spawnflags & SF_TRIGGER_FREEZE_SET_CHECKPOINT) == SF_TRIGGER_FREEZE_SET_CHECKPOINT)
			{
				PlayerSetCheckPoint(pPlayer, pPlayer.entindex(), m_szNewCheckPoint);
			}
		}
	}

	void UnfreezePlayers()
	{
		for (int i = 1; i <= g_Engine.maxClients; i++)
		{
			CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
			if(pPlayer !is null &&
				pPlayer.IsConnected() &&
				g_ArrayFreezePlayer[i].bIsFreezing &&
				g_ArrayFreezePlayer[i].iLastFreezerEntity == self.entindex()
				)
			{
				pPlayer.SetMaxSpeedOverride(-1);
				pPlayer.pev.gravity = 1;

				g_ArrayFreezePlayer[i].bIsFreezing = false;
				g_ArrayFreezePlayer[i].flUnfreezeTime = 0;
				g_ArrayFreezePlayer[i].iLastFreezerEntity = 0;
			}
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_TOGGLE)
		{
			if((self.pev.spawnflags & SF_TRIGGER_FREEZE_ON) == SF_TRIGGER_FREEZE_ON)
			{
				self.pev.spawnflags &= ~SF_TRIGGER_FREEZE_ON;
				
				UnfreezePlayers();
			}
			else
			{
				self.pev.spawnflags |= SF_TRIGGER_FREEZE_ON;
			}
		}
		else if(useType == USE_ON)
		{
			self.pev.spawnflags |= SF_TRIGGER_FREEZE_ON;

		}
		else if(useType == USE_OFF)
		{
			if((self.pev.spawnflags & SF_TRIGGER_FREEZE_ON) == SF_TRIGGER_FREEZE_ON)
			{
				self.pev.spawnflags &= ~SF_TRIGGER_FREEZE_ON;
				
				UnfreezePlayers();
			}
		}
		else if(useType == USE_SET)
		{
			
		}
	}
}

class CTriggerReviveZone : ScriptBaseEntity
{
	int m_iTriggerState = USE_TOGGLE;
	float m_flTriggerValue = 0;
	string m_szDefaultCheckPoint = "";

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_TRIGGER;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if(szKey == "triggerstate"){
			m_iTriggerState = atoi(szValue);
			return true;
		}

		if(szKey == "triggervalue"){
			m_flTriggerValue = atof(szValue);
			return true;
		}

		if(szKey == "defaultcheckpoint"){
			m_szDefaultCheckPoint = szValue;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}
	
	void Touch( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		if((self.pev.spawnflags & SF_TRIGGER_REVIVE_ZONE_ON) == SF_TRIGGER_REVIVE_ZONE_ON)
		{
			CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pOther);

			int iResult = PlayerTeleportToCheckPoint(pPlayer, pPlayer.entindex(), g_ArrayCheckPointPlayer[pPlayer.entindex()]);
			if(-1 == iResult)
			{
				iResult = PlayerTeleportToCheckPoint(pPlayer, pPlayer.entindex(), m_szDefaultCheckPoint);
			}

			if(iResult > 0)
			{
				if(!string(self.pev.target).IsEmpty())
				{
					g_EntityFuncs.FireTargets( string(self.pev.target), pOther, self, USE_TYPE(m_iTriggerState), m_flTriggerValue );
				}
			}
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_TOGGLE)
		{
			if((self.pev.spawnflags & SF_TRIGGER_REVIVE_ZONE_ON) == SF_TRIGGER_REVIVE_ZONE_ON)
			{
				self.pev.spawnflags &= ~SF_TRIGGER_REVIVE_ZONE_ON;
			}
			else
			{
				self.pev.spawnflags |= SF_TRIGGER_REVIVE_ZONE_ON;
			}
		}
		else if(useType == USE_ON)
		{
			self.pev.spawnflags |= SF_TRIGGER_REVIVE_ZONE_ON;
		}
		else if(useType == USE_OFF)
		{
			if((self.pev.spawnflags & SF_TRIGGER_REVIVE_ZONE_ON) == SF_TRIGGER_REVIVE_ZONE_ON)
			{
				self.pev.spawnflags &= ~SF_TRIGGER_REVIVE_ZONE_ON;
			}
		}
		else if(useType == USE_SET)
		{
			
		}
	}
}

const int SF_TRIGGER_CHECKPOINT_ZONE_ON = 1;

class CTriggerCheckPointZone : ScriptBaseEntity
{
	string m_szNewCheckPoint;
	int m_iTriggerState = USE_TOGGLE;
	float m_flTriggerValue = 0;

	void Precache()
	{
		BaseClass.Precache();
	}

	void Spawn()
	{
		Precache();
		self.pev.solid = SOLID_TRIGGER;
		self.pev.movetype = MOVETYPE_NONE;

		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{	
		if(szKey == "triggerstate"){
			m_iTriggerState = atoi(szValue);
			return true;
		}

		if(szKey == "triggervalue"){
			m_flTriggerValue = atof(szValue);
			return true;
		}

		if(szKey == "newcheckpoint"){
			m_szNewCheckPoint = szValue;
			return true;
		}

		return BaseClass.KeyValue( szKey, szValue );
	}
	
	void Touch( CBaseEntity@ pOther )
	{
		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		if((self.pev.spawnflags & SF_TRIGGER_CHECKPOINT_ZONE_ON) == SF_TRIGGER_CHECKPOINT_ZONE_ON)
		{
			CBasePlayer@ pPlayer = cast<CBasePlayer@>(@pOther);

			if(PlayerSetCheckPoint(pPlayer, pPlayer.entindex(), m_szNewCheckPoint))
			{
				if(!string(self.pev.target).IsEmpty())
				{
					g_EntityFuncs.FireTargets( string(self.pev.target), pOther, self, USE_TYPE(m_iTriggerState), m_flTriggerValue );
				}
			}
		}
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_TOGGLE)
		{
			if((self.pev.spawnflags & SF_TRIGGER_CHECKPOINT_ZONE_ON) == SF_TRIGGER_CHECKPOINT_ZONE_ON)
			{
				self.pev.spawnflags &= ~SF_TRIGGER_CHECKPOINT_ZONE_ON;
			}
			else
			{
				self.pev.spawnflags |= SF_TRIGGER_CHECKPOINT_ZONE_ON;
			}
		}
		else if(useType == USE_ON)
		{
			self.pev.spawnflags |= SF_TRIGGER_CHECKPOINT_ZONE_ON;
		}
		else if(useType == USE_OFF)
		{
			if((self.pev.spawnflags & SF_TRIGGER_CHECKPOINT_ZONE_ON) == SF_TRIGGER_CHECKPOINT_ZONE_ON)
			{
				self.pev.spawnflags &= ~SF_TRIGGER_CHECKPOINT_ZONE_ON;
			}
		}
		else if(useType == USE_SET)
		{
			
		}
	}
}

const int RHINO_LOAD_ATTACK = 1;
const int RHINO_DO_ATTACK = 2;
const int RHINO_END_ATTACK = 3;

const int RHINO_LOAD_DASH = 4;
const int RHINO_DO_DASH = 5;

const int RHINO_LOAD_KICK = 6;
const int RHINO_DO_KICK = 7;
const int RHINO_END_KICK = 8;

const int RHINO_START_WALK = 10;

array<ScriptSchedule@>@ monster_rhino_schedules;

ScriptSchedule slRhinoDash(
	bits_COND_ENEMY_OCCLUDED |
	bits_COND_NO_AMMO_LOADED,
	0,
	"Rhino Dash");

class CMonsterRhino : ScriptBaseMonsterEntity
{
	int m_iSpriteTexture = 0;
	bool m_bIsDashing = false;
	float m_flNextDashSmoke = 0;
	float m_flPushForce = 800;
	Vector m_vecDashDir;
	Vector m_vecDashTarget;
	Vector m_vecInitialOrigin;
	Vector m_vecInitialAngles;

	array<string> m_szSmokeSprite = {
		"sprites/fallguys/smokelit2.spr"
	};

	CMonsterRhino()
	{
		@this.m_Schedules = @monster_rhino_schedules;
	}

	void Precache()
	{
		BaseClass.Precache();

		g_Game.PrecacheModel("models/fallguys/rhino.mdl");

		g_SoundSystem.PrecacheSound("fallguys/rhinoidle.ogg");
		g_SoundSystem.PrecacheSound("fallguys/rhinoattack.ogg");
		g_SoundSystem.PrecacheSound("fallguys/rhinoloadattack.ogg");
		g_SoundSystem.PrecacheSound("fallguys/rhinoendattack.ogg");
		
		for(int i = 0;i < int(m_szSmokeSprite.length()); ++i)
		{
			g_Game.PrecacheModel( m_szSmokeSprite[i] );
		}
	}
	
	void Spawn()
	{
		Precache();

		if( !self.SetupModel() )
			g_EntityFuncs.SetModel( self, "models/fallguys/rhino.mdl" );
			
		g_EntityFuncs.SetSize(self.pev, Vector(-110, -110, 0), Vector(110, 110, 140));
		
		self.pev.solid = SOLID_SLIDEBOX;
		self.pev.movetype = MOVETYPE_STEP;
		self.pev.spawnflags |= 0x10;

		self.pev.flags |= FL_MONSTERCLIP;
		
		self.m_bloodColor			= BLOOD_COLOR_RED;
		self.m_flFieldOfView		= 0.5;
		self.m_MonsterState			= MONSTERSTATE_NONE;
		self.m_afCapability			= bits_CAP_DOORS_GROUP;
		
		self.m_FormattedName		= "Rhino";

		self.MonsterInit();

		self.pev.takedamage = DAMAGE_NO;

		m_vecInitialOrigin = self.pev.origin;
		m_vecInitialAngles = self.pev.angles;

		//Use hull1 as move hull
		g_EntityFuncs.SetEntityCustomMoveSize(self.edict(), Vector(-18, -18, 0), Vector(18, 18, 140));

		SetTouch(null);
	}

	void Reset()
	{
		self.pev.origin = m_vecInitialOrigin;
		self.pev.angles = m_vecInitialAngles;

		m_bIsDashing = false;
		self.TaskComplete();
		SetTouch(null);
		self.m_IdealActivity = ACT_IDLE;
		
		self.pev.spawnflags |= 0x10;
	}

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		if(useType == USE_ON)
		{
			self.pev.spawnflags &= ~0x10;
		}
		else if(useType == USE_OFF)
		{
			self.pev.spawnflags |= 0x10;
		}
		else if(useType == USE_SET)
		{
			if(flValue < 0)
			{
				Reset();
			}
		}
	}
	
	int	Classify()
	{
		return self.GetClassification( CLASS_ALIEN_MONSTER );
	}
	
	void SetYawSpeed()
	{
		switch ( self.m_Activity )
		{
			case ACT_RANGE_ATTACK1:
				if(m_bIsDashing)
					self.pev.yaw_speed = 0;
				else
					self.pev.yaw_speed = 60;

				break;

			default:
				self.pev.yaw_speed = 60;
				break;
		}
	}
	
	void Killed(entvars_t@ pevAttacker, int iGib)
	{
		BaseClass.Killed(pevAttacker, iGib);
	}
	
	void DeathSound()
	{
		
	}
	
	void PainSound()
	{	
	
	}
	
	void AlertSound()
	{	
	
	}
	
	void AttackSound()
	{

	}

	int TakeDamage( entvars_t@ pevInflictor, entvars_t@ pevAttacker, float flDamage, int bitsDamageType)
	{	
		return 0;
	}

	float GetPointsForDamage(float flDamage)
	{
		return 0;
	}
	
	bool CheckMeleeAttack1( float flDot, float flDist )
	{
		if (self.m_flNextAttack > g_Engine.time)
		{
			return false;
		}

		CBaseEntity@ pEnemy = self.m_hEnemy.GetEntity();

		if(pEnemy !is null)
		{
			if((pEnemy.pev.flags & FL_ONGROUND) == FL_ONGROUND && pEnemy.pev.groundentity is self.edict())
			{
				return false;
			}
		}

		if (flDot >= 0.7)
		{
			if (flDist <= 180)
			{
				return true;
			}
		}

		return false;
	}

	bool CheckMeleeAttack2( float flDot, float flDist )
	{
		if (self.m_flNextAttack > g_Engine.time)
		{
			return false;
		}

		CBaseEntity@ pEnemy = self.m_hEnemy.GetEntity();

		if(pEnemy !is null)
		{
			if((pEnemy.pev.flags & FL_ONGROUND) == FL_ONGROUND && pEnemy.pev.groundentity is self.edict())
			{
				return true;
			}
		}

		return false;
	}

	bool CheckRangeAttack1(float flDot, float flDist)
	{	
		if(m_bIsDashing)
			return false;

		if (flDot >= 0.86)
		{
			if (flDist >= 400)
			{
				return true;
			}
		}
		return false;
	}

	bool CheckRangeAttack2(float flDot, float flDist)
	{	
		return false;
	}

	void LoadMeleeAttack()
	{
		g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_WEAPON, "fallguys/rhinoloadattack.ogg", 1, ATTN_NORM, 0, PITCH_NORM );
	}

	void DoMeleeAttack()
	{
		g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_STATIC, "fallguys/rhinoattack.ogg", 1, ATTN_NORM, 0, PITCH_NORM );

		Vector vecSrc = self.pev.origin;

		Vector dir = GetAimDir(self);
		
		Vector vecTarget = vecSrc + dir * 160.0;

		vecTarget.z += 80;

		CBaseEntity@ pEntity = null;
		
		while((@pEntity = g_EntityFuncs.FindEntityInSphere(pEntity, vecTarget, 160.0, "player", "classname")) !is null)
		{
			CBasePlayer@ pPlayer = cast<CBasePlayer@>(pEntity);
			if(pPlayer.IsAlive())
			{
				pPlayer.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );

				Vector vecPushVelocity = g_Engine.v_forward * m_flPushForce * 0.75 + g_Engine.v_up * m_flPushForce * 0.5;

				Vector vecImpactDirection = vecPushVelocity.Normalize();
				Vector vecImpactDirection2 = vecImpactDirection;
				vecImpactDirection2.z *= 72.0 / 32.0;

				Vector vecImpactPosition2 = pPlayer.pev.origin - vecImpactDirection2 * 16;

				EmitPlayerHitEffect(pPlayer, HitEffect_Large, vecImpactPosition2, vecImpactDirection);

				pPlayer.pev.velocity = pPlayer.pev.velocity + vecPushVelocity;
			}
		}

		self.m_flNextAttack = g_Engine.time + 1.5;
	}
	
	void EndMeleeAttack()
	{
		g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_WEAPON, "fallguys/rhinoendattack.ogg", 1, ATTN_NORM, 0, PITCH_NORM );
	}

	void LoadKick()
	{
		g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_WEAPON, "fallguys/rhinoloadattack.ogg", 1, ATTN_NORM, 0, PITCH_NORM );
	}

	void DoKick()
	{
		g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_STATIC, "fallguys/rhinoattack.ogg", 1, ATTN_NORM, 0, PITCH_NORM );

		Vector vecSrc = self.pev.origin;

		Vector dir = GetAimDir(self);
		
		Vector vecTarget = vecSrc;

		vecTarget.z += 128;

		CBaseEntity@ pEntity = null;
		
		while((@pEntity = g_EntityFuncs.FindEntityInSphere(pEntity, vecTarget, 256.0, "player", "classname")) !is null)
		{
			CBasePlayer@ pPlayer = cast<CBasePlayer@>(pEntity);
			if(pPlayer.IsAlive())
			{
				if((pPlayer.pev.flags & FL_ONGROUND) == FL_ONGROUND && pPlayer.pev.groundentity is self.edict())
				{
					pPlayer.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );

					Vector vecPushVelocity = g_Engine.v_forward * m_flPushForce * 0.75 + g_Engine.v_up * m_flPushForce * 0.75;

					Vector vecImpactDirection = vecPushVelocity.Normalize();
					Vector vecImpactDirection2 = vecImpactDirection;
					vecImpactDirection2.z *= 72.0 / 32.0;

					Vector vecImpactPosition2 = pPlayer.pev.origin - vecImpactDirection2 * 16;

					EmitPlayerHitEffect(pPlayer, HitEffect_Large, vecImpactPosition2, vecImpactDirection);

					pPlayer.pev.velocity = pPlayer.pev.velocity + vecPushVelocity;
				}
			}
		}

		self.m_flNextAttack = g_Engine.time + 2.0;
	}
	
	void EndKick()
	{
		g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_WEAPON, "fallguys/rhinoendattack.ogg", 1, ATTN_NORM, 0, PITCH_NORM );
	}

	void StartWalk()
	{
		//g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "fallguys/rhinoidle.ogg", 1.0, ATTN_NORM, 0, PITCH_NORM );
	}

	void DashSmoke()
	{
		if(g_Engine.time > m_flNextDashSmoke)
		{
			int iSmokeCount = Math.RandomLong(2, 4);
			for(int i = 0; i < iSmokeCount; ++i)
			{
				float flRandom = Math.RandomFloat(0, 1);

				Vector vecSmokeSource = (self.pev.origin + self.pev.mins) * flRandom + (self.pev.origin + self.pev.maxs) * (1 - flRandom);

				vecSmokeSource.z = self.pev.origin.z + 12;

				CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecSmokeSource, g_vecZero, false);

				g_EntityFuncs.SetModel(pEntity, m_szSmokeSprite[Math.RandomLong(0, int(m_szSmokeSprite.length()) - 1 )]);

				pEntity.pev.scale = Math.RandomFloat(0.4, 0.6);
				pEntity.pev.solid = SOLID_NOT;
				pEntity.pev.movetype = MOVETYPE_NOCLIP;
				pEntity.pev.rendermode = kRenderTransAlpha;
				pEntity.pev.renderamt = 200;

				Vector Color1 = Vector(150, 150, 150);
				Vector Color2 = Vector(250, 250, 250);
				float ColorMix = Math.RandomFloat(0.0, 1.0);
				pEntity.pev.rendercolor = Color1 * ColorMix + Color2 * (1.0 - ColorMix);
				pEntity.pev.velocity = Vector(0, 0, 50);
				pEntity.pev.avelocity = Vector(0, 0, Math.RandomFloat(30, 60));
				pEntity.pev.framerate = 20;
				pEntity.pev.spawnflags = 0;
				pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
				pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;
				pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_RENDERAMT;
				pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SCALE;
				pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_STATIC_FRAME;
				pEntity.pev.frame = Math.RandomLong(0, 8);

				CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));
				pStudio.m_flUpdateRate = 0.0;
				pStudio.m_flMaxFrame = 10;

				EnvStudioKeyframe keyframe0;
				keyframe0.frame = 0;
				keyframe0.renderamt = 100;
				keyframe0.scale = pEntity.pev.scale * 0.6;
				pStudio.m_Keyframes.insertLast(keyframe0);

				EnvStudioKeyframe keyframe1;
				keyframe1.frame = 2;
				keyframe1.renderamt = 255;
				keyframe1.scale = pEntity.pev.scale * 0.8;
				pStudio.m_Keyframes.insertLast(keyframe1);

				EnvStudioKeyframe keyframe2;
				keyframe2.frame = 5;
				keyframe2.renderamt = 100;
				keyframe2.scale = pEntity.pev.scale;
				pStudio.m_Keyframes.insertLast(keyframe2);

				EnvStudioKeyframe keyframe3;
				keyframe3.frame = 10;
				keyframe3.renderamt = 0;
				keyframe3.scale = pEntity.pev.scale * 1.1;
				pStudio.m_Keyframes.insertLast(keyframe3);

				pStudio.StartSpriteAnim(0);
			}
		
			m_flNextDashSmoke = g_Engine.time + 0.1;
		}
	}

	void LoadDash()
	{
		m_bIsDashing = false;

		g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_WEAPON, "fallguys/rhinoloadattack.ogg", 1, ATTN_NORM, 0, PITCH_NORM );

		Math.MakeVectors( self.pev.angles );

		Vector vecSmoke = self.pev.origin + g_Engine.v_forward * (-100);
		vecSmoke.z += 40;

		/*NetworkMessage m(MSG_PVS, NetworkMessages::SVC_TEMPENTITY, vecSmoke);
		m.WriteByte(TE_EXPLOSION);
		m.WriteCoord(vecSmoke.x);
		m.WriteCoord(vecSmoke.y);
		m.WriteCoord(vecSmoke.z);
		m.WriteShort(m_iSpriteTexture);
		m.WriteByte(40);//scale
		m.WriteByte(30);//framerate
		m.WriteByte(2 | 4 | 8);
		m.End();*/
	}

	void DoDash()
	{
		g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "fallguys/rhinoidle.ogg", 1, ATTN_NORM, 0, PITCH_NORM );

		Math.MakeVectors( self.pev.angles );

		m_bIsDashing = true;
		m_flNextDashSmoke = g_Engine.time;
		
		if (self.m_hEnemy.IsValid())
		{
			CBaseEntity @pEnemy = self.m_hEnemy.GetEntity();
			Vector vecDash = pEnemy.pev.origin - self.pev.origin;
			vecDash.z = 0;
			vecDash = vecDash.Normalize();
			m_vecDashDir = vecDash;
			m_vecDashTarget = pEnemy.pev.origin + m_vecDashDir * 150;
			m_vecDashTarget.z = self.pev.origin.z;
			self.pev.angles = Math.VecToAngles(m_vecDashDir);
		}
		else
		{
			m_vecDashDir = g_Engine.v_forward;
			m_vecDashTarget = self.pev.origin + m_vecDashDir * 1200;
		}

		self.pev.velocity = m_vecDashDir * 1200;
	}

	//Not PM code, velocity works
	void DashTouch(CBaseEntity @pOther)
	{
		if(pOther is null)
			return;

		if(!pOther.IsPlayer())
			return;
			
		if(!pOther.IsAlive())
			return;

		Vector vecPushVelocity = m_vecDashDir * m_flPushForce * 1.0;
		vecPushVelocity.z += m_flPushForce * 0.75;

		Vector vDiff = pOther.pev.origin - self.pev.origin;
		vDiff.z = 0;
		vDiff = vDiff.Normalize();

		float flCosAngle = DotProduct(vDiff, m_vecDashDir);

		if(flCosAngle > 0)
		{		
			pOther.pev.velocity = vecPushVelocity * flCosAngle;
		}

		if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

			pOther.TakeDamage( self.pev, self.pev, 1, DMG_SLASH );

			Vector vecImpactDirection = vecPushVelocity.Normalize();
			Vector vecImpactDirection2 = vecImpactDirection;
			vecImpactDirection2.z *= 72.0 / 32.0;

			Vector vecImpactPosition2 = pOther.pev.origin - vecImpactDirection2 * 8;

			EmitPlayerHitEffect(pOther, HitEffect_Large, vecImpactPosition2, vecImpactDirection);

			g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
		}
	}

	void StartTask ( Task@ pTask )
	{
		self.m_iTaskStatus = TASKSTATUS_RUNNING;

		switch ( pTask.iTask )
		{
			case TASK_RANGE_ATTACK1:
			{
				//g_Game.AlertMessage( at_console, "StartTask TASK_RANGE_ATTACK1\n");

				self.m_IdealActivity = ACT_RANGE_ATTACK1;
				SetTouch(TouchFunction(this.DashTouch));
				break;
			}
			default:
			{
				BaseClass.StartTask( pTask );
				break;
			}
		}
	}

	void RunTask(Task@ pTask)
	{
		switch ( pTask.iTask )
		{
			case TASK_RANGE_ATTACK1:
			{
				if ( self.m_fSequenceFinished )
				{
					//g_Game.AlertMessage( at_console, "RunTask m_fSequenceFinished\n");

					g_SoundSystem.StopSound( self.edict(), CHAN_VOICE, "fallguys/rhinoidle.ogg" );

					m_bIsDashing = false;
					self.TaskComplete();
					SetTouch(null);
					self.m_IdealActivity = ACT_IDLE;
				}
				else
				{
					if(m_bIsDashing)
					{
						if(self.pev.velocity.Length() < 50)
						{
							g_Game.AlertMessage( at_console, "RunTask low velocity\n");

							g_SoundSystem.StopSound( self.edict(), CHAN_VOICE, "fallguys/rhinoidle.ogg" );

							m_bIsDashing = false;
							self.TaskComplete();
							SetTouch(null);
							self.m_IdealActivity = ACT_IDLE;
						}
						else
						{
							Vector vDiff = m_vecDashTarget - self.pev.origin;
							vDiff.z = 0;
							vDiff = vDiff.Normalize();
							if(DotProduct(vDiff, m_vecDashDir) > 0)
							{
								self.pev.velocity = m_vecDashDir * 1200;

								DashSmoke();								

								//g_Game.AlertMessage( at_console, "RunTask dashing\n");
							}
							else
							{
								//g_Game.AlertMessage( at_console, "RunTask not dashing\n");
							}
						}
					}
					else
					{
						//g_Game.AlertMessage( at_console, "RunTask not dashing 2\n");
					}
				}
				break;
			}
			default:
			{
				BaseClass.RunTask(pTask);
				break;
			}
		}
	}

	Schedule@ GetScheduleOfType( int Type )
	{
		switch( Type )
		{
		case SCHED_RANGE_ATTACK1:
			return slRhinoDash;
		}

		return BaseClass.GetScheduleOfType( Type );
	}

	void HandleAnimEvent(MonsterEvent@ pEvent)
	{
		switch(pEvent.event)
		{
			case RHINO_LOAD_ATTACK:
				LoadMeleeAttack();
				break;
			case RHINO_DO_ATTACK:
				DoMeleeAttack();
				break;
			case RHINO_END_ATTACK:
				EndMeleeAttack();
				break;
			case RHINO_LOAD_DASH:
				LoadDash();
				break;
			case RHINO_DO_DASH:
				DoDash();
				break;
				
			case RHINO_LOAD_KICK:
				LoadKick();
				break;
			case RHINO_DO_KICK:
				DoKick();
				break;
			case RHINO_END_KICK:
				EndKick();
				break;

			case RHINO_START_WALK:
				StartWalk();
				break;
			default:
				BaseClass.HandleAnimEvent(pEvent);
		}
	}
}

HookReturnCode PlayerMovePlaySoundFX( CBasePlayer@ pPlayer, int playerindex, Vector origin, int type, const string& in sound, float vol, float att, int flags, int pitch, uint& out uiFlags )
{
	if(sound.StartsWith("player/pl_step"))
	{
		g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_BODY, g_szFootStepPlasticSound[Math.RandomLong(0, 6)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

		uiFlags |= 1;
		return HOOK_HANDLED;
	}
	else if(sound.StartsWith("player/pl_wade") || sound.StartsWith("player/pl_slosh"))
	{
		g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_BODY, g_szFootStepSlipperySound[Math.RandomLong(0, 6)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

		uiFlags |= 1;
		return HOOK_HANDLED;
	}
	else if(sound.StartsWith("player/pl_jump"))
	{
		g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_BODY, g_szJumpPlasticSound[Math.RandomLong(0, 6)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

		uiFlags |= 1;
		return HOOK_HANDLED;
	}
	else if(sound == "player/pl_fallpain3.wav")
	{
		g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_BODY, g_szImpactPlasticSound[Math.RandomLong(0, 2)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

		uiFlags |= 1;
		return HOOK_HANDLED;
	}

    return HOOK_CONTINUE;
}

HookReturnCode PlayerTouchPlayer( CBasePlayer@ pPlayer, CBasePlayer@ pOther )
{
	//g_Game.AlertMessage( at_console, "PlayerTouchPlayer %1 touches %2 with impact velocity %3", string(pPlayer.pev.netname), string(pOther.pev.targetname), pPlayer.pev.velocity.Length() );

	if(pOther.IsPlayer() && pOther.IsAlive())
	{
		Vector vDiff = pOther.pev.origin - pPlayer.pev.origin;
		vDiff = vDiff.Normalize();

		Vector vecImpactVelocity = pPlayer.pev.velocity;

		float flImpactVelocity = vecImpactVelocity.Length();

		vecImpactVelocity = vecImpactVelocity.Normalize();

		float flCosAngle = DotProduct(vDiff, vecImpactVelocity);

		if(flCosAngle > c_PlayerImpactPlayer_MinimumCosAngle && flImpactVelocity > c_PlayerImpactPlayer_MinimumImpactVelocity)
		{
			Vector vecAddVelocity = vDiff * flImpactVelocity * flCosAngle * c_PlayerImpactPlayer_VelocityTransferEfficiency; 

			g_ArrayBounceVelocityPlayer[pOther.entindex()] = vecAddVelocity;

			if(g_Engine.time > g_ArrayBouncePlayer[pOther.entindex()]){

				pOther.TakeDamage( pPlayer.pev, pPlayer.pev, 1, DMG_SLASH );

				Vector vecImpactDirection2 = vecImpactVelocity;
				vecImpactDirection2.z *= 72.0 / 32.0;

				Vector vecImpactPosition2 = pOther.pev.origin - vecImpactDirection2 * 12;

				EmitPlayerHitEffect(pOther, (vecAddVelocity.Length() > 180) ? HitEffect_Medium : HitEffect_Small, vecImpactPosition2, vecImpactVelocity);

				g_ArrayBouncePlayer[pOther.entindex()] = g_Engine.time + 0.5;
			}
		}
	}

    return HOOK_CONTINUE;
}

void DelayRespawn(CBasePlayer@ pPlayer)
{
	if(!pPlayer.IsConnected())
		return;

	if(pPlayer.IsDormant())
		return;

	array<CBaseEntity@> spawnpoints = {};

	CBaseEntity@ pEntity = null;
	while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, "game_start_spawnpoint")) !is null)
	{
		if(g_PlayerFuncs.IsSpawnPointValid(pEntity, pPlayer))
		{
			spawnpoints.insertLast(pEntity);
		}
	}

	if(spawnpoints.length() > 0)
	{
		int randomIndex = Math.RandomLong(0, spawnpoints.length() - 1);
		CBaseEntity@ pSpawnPoint = spawnpoints[randomIndex];

		g_PlayerFuncs.RespawnPlayer(pPlayer, true, true);
		g_EntityFuncs.SetOrigin(pPlayer, pSpawnPoint.pev.origin);
		pPlayer.pev.velocity = Vector(0, 0, 0);
		pPlayer.pev.angles = pSpawnPoint.pev.angles;

		spawnpoints.removeAt(randomIndex);
	}
}

HookReturnCode ClientPutInServer( CBasePlayer@ pPlayer )
{
	int playerIndex = pPlayer.entindex();

	KeyValueBuffer@ pInfoBuffer = g_EngineFuncs.GetInfoKeyBuffer(pPlayer.edict());

	g_ArrayTopColorPlayer[playerIndex] = atoi(pInfoBuffer.GetValue("topcolor"));
	g_ArrayBotColorPlayer[playerIndex] = atoi(pInfoBuffer.GetValue("bottomcolor"));
	g_ArraySpectatorPlayer[playerIndex] = false;

	g_Scheduler.SetTimeout("DelayRespawn", 1, @pPlayer);

    return HOOK_CONTINUE;
}

HookReturnCode ClientDisconnect(CBasePlayer@ pPlayer)
{
	int playerIndex = pPlayer.entindex();

	PlayerHideArrow(pPlayer, playerIndex);
	PlayerHideHat(pPlayer, playerIndex);

	g_ArraySpectatorPlayer[playerIndex] = false;

    return HOOK_CONTINUE;
}

HookReturnCode PlayerSpawn(CBasePlayer@ pPlayer)
{
    if(pPlayer is null || !pPlayer.IsNetClient())
        return HOOK_CONTINUE;

	NetworkMessage message( MSG_ONE, NetworkMessages::SVC_STUFFTEXT, pPlayer.edict() );
		message.WriteString("thirdperson;cam_idealdist 100;\n");
	message.End();

	pPlayer.SetMaxSpeed(c_PlayerDefaultMaxSpeed);
	pPlayer.pev.solid = SOLID_SLIDEBOX;

	PlayerSetCheckPoint(pPlayer, pPlayer.entindex(), "");

    return HOOK_CONTINUE;
}

void PlayerQualified(CBasePlayer @pPlayer)
{
	g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_VOICE, g_szPlayerQualifiedSound[Math.RandomLong(0, int(g_szPlayerQualifiedSound.length()) - 1)], 1, 0.01, 0, PITCH_NORM, pPlayer.entindex());
}

void EmitPlayerHitEffect_Sprite(CBaseEntity @pHitEntity, int type, const Vector & in vecPosition, const Vector & in vecDirection)
{
	if(type == HitEffect_Large)
	{
		CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecPosition, g_vecZero, false);

		g_EntityFuncs.SetModel(pEntity, g_szPlayerHitEffectSprite[type]);

		pEntity.pev.scale = Math.RandomFloat(0.45, 0.55);
		pEntity.pev.solid = SOLID_NOT;
		pEntity.pev.movetype = MOVETYPE_NOCLIP;
		pEntity.pev.rendermode = kRenderTransAlpha;
		pEntity.pev.renderamt = 255;
		pEntity.pev.rendercolor = Vector(255, 255, 255);
		pEntity.pev.framerate = 180.0;
		pEntity.pev.spawnflags = 0;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;

		CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));
		pStudio.m_flUpdateRate = 0.01;
		pStudio.m_flMaxFrame = float(g_EngineFuncs.ModelFrames(g_iPlayerHitEffectSprite[type]) - 1);

		pStudio.StartSpriteAnim(0);
	}
	else if(type == HitEffect_Medium)
	{
		CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecPosition, g_vecZero, false);

		g_EntityFuncs.SetModel(pEntity, g_szPlayerHitEffectSprite[type]);

		pEntity.pev.scale = Math.RandomFloat(0.35, 0.45);
		pEntity.pev.solid = SOLID_NOT;
		pEntity.pev.movetype = MOVETYPE_NOCLIP;
		pEntity.pev.rendermode = kRenderTransAlpha;
		pEntity.pev.renderamt = 255;
		pEntity.pev.rendercolor = Vector(255, 255, 255);
		pEntity.pev.framerate = 180.0;
		pEntity.pev.spawnflags = 0;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;

		CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));
		pStudio.m_flUpdateRate = 0.01;
		pStudio.m_flMaxFrame = float(g_EngineFuncs.ModelFrames(g_iPlayerHitEffectSprite[type]) - 1);

		pStudio.StartSpriteAnim(0);
	}
	else if(type == HitEffect_Small)
	{
		CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecPosition, g_vecZero, false);

		g_EntityFuncs.SetModel(pEntity, g_szPlayerHitEffectSprite[type]);

		pEntity.pev.scale = Math.RandomFloat(0.25, 0.35);
		pEntity.pev.solid = SOLID_NOT;
		pEntity.pev.movetype = MOVETYPE_NOCLIP;
		pEntity.pev.rendermode = kRenderTransAlpha;
		pEntity.pev.renderamt = 255;
		pEntity.pev.rendercolor = Vector(255, 255, 255);
		pEntity.pev.framerate = 180.0;
		pEntity.pev.spawnflags = 0;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;

		CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));
		pStudio.m_flUpdateRate = 0.01;
		pStudio.m_flMaxFrame = float(g_EngineFuncs.ModelFrames(g_iPlayerHitEffectSprite[type]) - 1);

		pStudio.StartSpriteAnim(0);
	}
	else if(type == HitEffect_GrabBreak)
	{
		CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecPosition, g_vecZero, false);

		g_EntityFuncs.SetModel(pEntity, g_szPlayerHitEffectSprite[type]);

		pEntity.pev.scale = Math.RandomFloat(0.5, 0.7);
		pEntity.pev.solid = SOLID_NOT;
		pEntity.pev.movetype = MOVETYPE_NOCLIP;
		pEntity.pev.rendermode = kRenderTransAlpha;
		pEntity.pev.renderamt = 255;
		pEntity.pev.rendercolor = Vector(255, 255, 255);
		pEntity.pev.framerate = 180.0;
		pEntity.pev.spawnflags = 0;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
		pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;

		CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));
		pStudio.m_flUpdateRate = 0.01;
		pStudio.m_flMaxFrame = float(g_EngineFuncs.ModelFrames(g_iPlayerHitEffectSprite[type]) - 1);

		pStudio.StartSpriteAnim(0);
	}
}

void EmitPlayerHitEffect_BurstCircle(CBaseEntity @pHitEntity, int type, const Vector & in vecPosition, const Vector & in vecDirection)
{
	CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecPosition, g_vecZero, false);

	g_EntityFuncs.SetModel(pEntity, g_szPlayerHitEffectSprite[HitEffect_BurstCircleSprite]);

	pEntity.pev.scale = 0.08;
	pEntity.pev.solid = SOLID_NOT;
	pEntity.pev.movetype = MOVETYPE_NOCLIP;
	pEntity.pev.rendermode = kRenderTransAdd;
	pEntity.pev.renderamt = 255;
	pEntity.pev.rendercolor = Vector(255, 255, 255);
	pEntity.pev.framerate = 80.0;
	pEntity.pev.spawnflags = 0;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_RENDERAMT;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SCALE;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_STATIC_FRAME;

	CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));
	pStudio.m_flUpdateRate = 0.0;
	pStudio.m_flMaxFrame = 10;

	EnvStudioKeyframe keyframe0;
	keyframe0.frame = 0;
	keyframe0.renderamt = pEntity.pev.renderamt;
	keyframe0.scale = pEntity.pev.scale;
	pStudio.m_Keyframes.insertLast(keyframe0);

	EnvStudioKeyframe keyframe1;
	keyframe1.frame = 10;
	keyframe1.renderamt = 150;
	keyframe1.scale = pEntity.pev.scale + 0.04;
	pStudio.m_Keyframes.insertLast(keyframe1);

	pStudio.StartSpriteAnim(0);
}

void EmitPlayerHitEffect_BurstStar(CBaseEntity @pHitEntity, int type, const Vector & in vecPosition, const Vector & in vecDirection)
{
	CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecPosition, g_vecZero, false);

	g_EntityFuncs.SetModel(pEntity, g_szPlayerHitEffectSprite[HitEffect_BurstLineSprite]);

	pEntity.pev.scale = 0.04;
	pEntity.pev.solid = SOLID_NOT;
	pEntity.pev.movetype = MOVETYPE_NOCLIP;
	pEntity.pev.rendermode = kRenderTransAdd;
	pEntity.pev.renderamt = 255;
	pEntity.pev.rendercolor = Vector(255, 255, 255);
	pEntity.pev.framerate = 80.0;
	pEntity.pev.spawnflags = 0;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_RENDERAMT;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SCALE;	
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_STATIC_FRAME;

	CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));
	pStudio.m_flUpdateRate = 0.0;
	pStudio.m_flMaxFrame = 10;

	EnvStudioKeyframe keyframe0;
	keyframe0.frame = 0;
	keyframe0.renderamt = pEntity.pev.renderamt;
	keyframe0.scale = pEntity.pev.scale;
	pStudio.m_Keyframes.insertLast(keyframe0);

	EnvStudioKeyframe keyframe1;
	keyframe1.frame = 10;
	keyframe1.renderamt = 180;
	keyframe1.scale = pEntity.pev.scale + 0.12;
	pStudio.m_Keyframes.insertLast(keyframe1);

	pStudio.StartSpriteAnim(0);
}

void EmitPlayerHitEffect_BurstLineShoot(CBaseEntity @pHitEntity, int skin, const Vector & in vecPosition, const Vector & in vecDirection)
{
	if(skin < 0)
		return;

	Vector vecAngles = Math.VecToAngles(vecDirection);

	Math.MakeVectors(vecAngles);

	Vector vecRandom = g_Engine.v_forward + Math.RandomFloat(0.1, 0.5) * g_Engine.v_right + Math.RandomFloat(0.1, 0.5) * g_Engine.v_up;
	vecRandom = vecRandom.Normalize();

	CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecPosition + vecRandom * 12, Math.VecToAngles(vecRandom), false);

	g_EntityFuncs.SetModel(pEntity, g_szPlayerHitEffectModel[HitEffect_BurstLineModel]);

	pEntity.pev.skin = skin;
	pEntity.pev.framerate = 1.0;
	pEntity.pev.scale = 1.0;
	pEntity.pev.solid = SOLID_NOT;
	pEntity.pev.movetype = MOVETYPE_NOCLIP;
	pEntity.pev.rendermode = kRenderTransAdd;
	pEntity.pev.renderamt = 255;
	pEntity.pev.spawnflags = 0;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_STUDIO;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_RENDERAMT;
	pEntity.pev.velocity = vecRandom * 400;

	CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));

	pStudio.m_flUpdateRate = 0.0;

	EnvStudioKeyframe keyframe0;
	keyframe0.frame = 0;
	keyframe0.renderamt = pEntity.pev.renderamt;
	pStudio.m_Keyframes.insertLast(keyframe0);

	EnvStudioKeyframe keyframe1;
	keyframe1.frame = 255;
	keyframe1.renderamt = 100;
	pStudio.m_Keyframes.insertLast(keyframe1);

	pStudio.StartStudioSequence(0);
}

void EmitPlayerHitEffect(CBaseEntity @pHitEntity, int type, const Vector & in vecPosition, const Vector & in vecDirection)
{
	if(type == HitEffect_Large && vecDirection != g_vecZero && Math.RandomLong(0, 2) == 0)
	{
		EmitPlayerHitEffect_BurstCircle(pHitEntity, type, vecPosition, vecDirection);
		EmitPlayerHitEffect_BurstStar(pHitEntity, type, vecPosition, vecDirection);
		array<int> shootArray = {
			0,-1,-1,
			1,-1,-1,
			2,-1,-1,
			0, 1,-1,
			0, 2,-1,
			0, 3,-1,
			1, 2,-1,
			1, 3,-1,
			2, 3,-1,
			0, 1, 2,
			0, 2, 3,
			1, 2, 3
		};
		int shootIndex = Math.RandomLong(0, int(shootArray.length()) / 3 - 1 );
		EmitPlayerHitEffect_BurstLineShoot(pHitEntity, shootArray[shootIndex * 3 + 0], vecPosition, vecDirection);
		EmitPlayerHitEffect_BurstLineShoot(pHitEntity, shootArray[shootIndex * 3 + 1], vecPosition, vecDirection);
		EmitPlayerHitEffect_BurstLineShoot(pHitEntity, shootArray[shootIndex * 3 + 2], vecPosition, vecDirection);
	}
	else if(type == HitEffect_Medium && vecDirection != g_vecZero && Math.RandomLong(0, 4) == 0)
	{
		EmitPlayerHitEffect_BurstCircle(pHitEntity, type, vecPosition, vecDirection);
		EmitPlayerHitEffect_BurstStar(pHitEntity, type, vecPosition, vecDirection);
		EmitPlayerHitEffect_BurstLineShoot(pHitEntity, Math.RandomLong(0, 3), vecPosition, vecDirection);
	}
	else
	{
		EmitPlayerHitEffect_Sprite(pHitEntity, type, vecPosition, vecDirection);
	}
}

void PlayerJumpEffect_Puff(CBasePlayer @pPlayer, const Vector & in vecPosition, const Vector & in vecDirection)
{
	CBaseEntity@ pEntity = g_EntityFuncs.Create("env_studiomodel", vecPosition + vecDirection * 12, g_vecZero, false);

	g_EntityFuncs.SetModel(pEntity, g_szPlayerJumpEffectSprite[0]);

	pEntity.pev.scale = Math.RandomFloat(0.08, 0.02);
	pEntity.pev.solid = SOLID_NOT;
	pEntity.pev.movetype = MOVETYPE_NOCLIP;
	pEntity.pev.rendermode = kRenderTransAlpha;
	pEntity.pev.renderfx = 0;
	pEntity.pev.renderamt = 255;
	pEntity.pev.rendercolor = Vector(255, 230, 200);
	pEntity.pev.framerate = 20.0;
	pEntity.pev.spawnflags = 0;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SPRITE;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_REMOVE_ON_ANIM_FINISH;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_RENDERAMT;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_ANIMATED_SCALE;
	pEntity.pev.spawnflags |= SF_ENV_STUDIOMODEL_STATIC_FRAME;

	pEntity.pev.velocity = vecDirection * 25;
	pEntity.pev.angles[2] = Math.RandomFloat(0.0, 359.0);

	CEnvStudioModel@ pStudio = cast<CEnvStudioModel@>(CastToScriptClass(pEntity));
	pStudio.m_flUpdateRate = 0.0;
	pStudio.m_flMaxFrame = 10;

	EnvStudioKeyframe keyframe0;
	keyframe0.frame = 0;
	keyframe0.renderamt = pEntity.pev.renderamt;
	keyframe0.scale = pEntity.pev.scale;
	pStudio.m_Keyframes.insertLast(keyframe0);

	EnvStudioKeyframe keyframe1;
	keyframe1.frame = 10;
	keyframe1.renderamt = 80;
	keyframe1.scale = pEntity.pev.scale * 0.2;
	pStudio.m_Keyframes.insertLast(keyframe1);

	pStudio.StartSpriteAnim(0);
}

void EmitPlayerJumpEffect(CBasePlayer @pPlayer)
{
	Vector vecSrc = pPlayer.pev.origin + Vector(0, 0, -12);

	Vector angles = pPlayer.pev.angles;

	angles.x = 0;

	Math.MakeVectors( angles );
	
	array<float> offsetArray = {
		1.0, 0.0,
		//0.866, 0.5,
		0.5, 0.866,
		//0.0, 1.0,
		-0.5, 0.866,
		//-0.866, 0.5,
		-1.0, 0.0,
		//-0.866, -0.5,
		-0.5, -0.866,
		//0.0, -1.0,
		0.5, -0.866,
		//0.866, -0.5
	};

	for(int i = 0;i < int(offsetArray.length()) / 2; ++i)
	{
		Vector vecDirection = g_Engine.v_forward * offsetArray[i * 2 + 0] + g_Engine.v_right * offsetArray[i * 2 + 1];
		PlayerJumpEffect_Puff(pPlayer, vecSrc, vecDirection);
	}
}

HookReturnCode PlayerTakeDamage(DamageInfo@ info)
{
	if(info.flDamage < 10)
	{
		CBasePlayer@ pPlayer = cast<CBasePlayer@>(info.pVictim);
		CBaseEntity@ pInflictor = info.pInflictor;

		info.flDamage = 0;

		g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_VOICE, g_szPlayerHitSound[Math.RandomLong(0, 6)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

		return HOOK_HANDLED;
	}

    return HOOK_CONTINUE;
}

void PlayerJump(CBasePlayer@ pPlayer, int playerIndex)
{
	if ((pPlayer.pev.flags & FL_WATERJUMP) == FL_WATERJUMP)
		return;

	if (pPlayer.pev.waterlevel >= 2)
		return;

	if ((pPlayer.pev.flags & FL_ONGROUND) == 0)
		return;

	g_ArrayPlayerJumpState[playerIndex] = 1;

	if(pPlayer.pev.groundentity !is null)
	{
		g_ArrayPlayerJumpPreGroundEntity[playerIndex] = g_EngineFuncs.IndexOfEdict(pPlayer.pev.groundentity);
	}
	else
	{
		g_ArrayPlayerJumpPreGroundEntity[playerIndex] = 0;
	}
}

void PlayerJumped(CBasePlayer@ pPlayer, int playerIndex)
{
	if(g_ArrayPlayerJumpState[playerIndex] != 1)
		return;

	if(g_Engine.time > g_ArrayJumpPlayer[playerIndex]){

		g_ArrayPlayerJumpState[playerIndex] = 2;

		g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_VOICE, g_szPlayerJumpSound[Math.RandomLong(0, 7)], 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );
	
		EmitPlayerJumpEffect(pPlayer);

		g_ArrayJumpPlayer[playerIndex] = g_Engine.time + 0.5;
	}
}

void PlayerFalling(CBasePlayer@ pPlayer, int playerIndex)
{
	if(g_ArrayFallingPlayer[playerIndex] == false){

		string szSoundName = g_szPlayerFallingSound[Math.RandomLong(0, 1)];

		g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_VOICE, szSoundName, 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

		g_ArrayFallingPlayer[playerIndex] = true;
		g_ArrayFallingPlayerPlayingSound[playerIndex] = szSoundName;
	}
}

void PlayerStopFall(CBasePlayer@ pPlayer, int playerIndex)
{
	if(g_ArrayFallingPlayer[playerIndex] == true){

		g_SoundSystem.StopSound( pPlayer.edict(), CHAN_VOICE, g_ArrayFallingPlayerPlayingSound[playerIndex] );

		g_ArrayFallingPlayer[playerIndex] = false;
	}
}

void PlayerStopBlock(CBasePlayer@ pPlayer, int playerIndex)
{
	if(g_ArrayBlockPlayer[playerIndex].IsBlocking &&
		g_Engine.time > g_ArrayBlockPlayer[playerIndex].flLastBlockTime + 0.1)
	{
		g_ArrayBlockPlayer[playerIndex].IsBlocking = false;

		if(g_ArrayBlockPlayer[playerIndex].flLastSoundTime > 0 && 
			!g_ArrayBlockPlayer[playerIndex].szPlayingSound.IsEmpty())
		{
			g_SoundSystem.StopSound( pPlayer.edict(), CHAN_BODY, g_ArrayBlockPlayer[playerIndex].szPlayingSound );

			g_ArrayBlockPlayer[playerIndex].flLastSoundTime = 0;
		}
	}
}

void PlayerStartFreeze(CBasePlayer@ pPlayer, int playerIndex, CBaseEntity@ pFreezer, int maxspeed, float gravity, float friction, float duration, bool noDraw)
{
	g_ArrayFreezePlayer[playerIndex].bIsFreezing = true;
	g_ArrayFreezePlayer[playerIndex].bIsNoDraw = noDraw;
	g_ArrayFreezePlayer[playerIndex].flUnfreezeTime = g_Engine.time + duration;
	g_ArrayFreezePlayer[playerIndex].iLastFreezerEntity = pFreezer.entindex();
	pPlayer.SetMaxSpeedOverride(maxspeed);
	pPlayer.pev.gravity = gravity;
	pPlayer.pev.friction = friction;
	if(noDraw)
	{
		pPlayer.pev.effects |= EF_NODRAW;
	}
}

void PlayerStopFreeze(CBasePlayer@ pPlayer, int playerIndex)
{
	if(g_ArrayFreezePlayer[playerIndex].bIsFreezing)
	{
		if(g_Engine.time > g_ArrayFreezePlayer[playerIndex].flUnfreezeTime)
		{
			pPlayer.SetMaxSpeedOverride(-1);
			pPlayer.pev.gravity = 1;

			if(g_ArrayFreezePlayer[playerIndex].bIsNoDraw)
			{
				pPlayer.pev.effects &= ~EF_NODRAW;
			}

			g_ArrayFreezePlayer[playerIndex].bIsNoDraw = false;
			g_ArrayFreezePlayer[playerIndex].bIsFreezing = false;
			g_ArrayFreezePlayer[playerIndex].flUnfreezeTime = 0;
			g_ArrayFreezePlayer[playerIndex].iLastFreezerEntity = 0;
		}
	}
}

bool PlayerSetCheckPoint(CBasePlayer@ pPlayer, int playerIndex, const string & in targetname)
{
	if(g_ArrayCheckPointPlayer[playerIndex] != targetname)
	{
		g_ArrayCheckPointPlayer[playerIndex] = targetname;
		return true;
	}
	return false;
}

int PlayerTeleportToCheckPoint(CBasePlayer@ pPlayer, int playerIndex, const string & in targetname)
{
	array<CBaseEntity@> spawnpoints = {};

	if(!targetname.IsEmpty())
	{
		CBaseEntity@ pEntity = null;
		while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, targetname)) !is null)
		{
			if(pPlayer.Classify() >= 16 && pPlayer.Classify() <= 19 && int(pEntity.pev.frags) != pPlayer.Classify())
			{
				continue;
			}

			spawnpoints.insertLast(pEntity);
		}
	}
	else
	{
		return -1;
	}

	if(spawnpoints.length() == 0)
	{
		return -2;
	}

	//Shuffule
	array<int> rnd( spawnpoints.length() );

	for (int i = 0; i < int(spawnpoints.length()); i++)
	{
		rnd[i] = i;
	}

	for (int i = int(spawnpoints.length()) - 1; i >= 0; i --)
	{
		int randomIndex = g_PlayerFuncs.SharedRandomLong( uint(g_Engine.time * 100.0) + i, 0, i );//Math.RandomLong(0, i);
		int temp = rnd[randomIndex];
		rnd[randomIndex] = rnd[i];
		rnd[i] = temp;
	}

	//This is a simplified version of UTIL_TeleportEntity
	for(int i = 0;i < int(spawnpoints.length()); ++i)
	{
		CBaseEntity@ pEntity = spawnpoints[rnd[i]];

		array<CBaseEntity@> entarray = {};
		
		Vector mins = pEntity.pev.origin - Vector(16, 16, 32);
		Vector maxs = pEntity.pev.origin + Vector(16, 16, 32);

		g_EntityFuncs.EntitiesInBox(entarray, mins, maxs, FL_CLIENT | FL_MONSTER);

		int countSolid = 0;
		for(int j = 0;j < int(entarray.length()); ++j)
		{
			if(entarray[j].pev.solid > SOLID_TRIGGER && entarray[j].pev.movetype != MOVETYPE_NOCLIP)
			{
				countSolid ++;
			}
		}

		if(countSolid == 0)
		{
			//g_PlayerFuncs.RespawnPlayer(pPlayer, true, true);
			Vector tmp = pEntity.pev.origin;
			tmp.z -= pPlayer.pev.mins.z;
			tmp.z++;
			g_EntityFuncs.SetOrigin(pPlayer, tmp);
			pPlayer.pev.flags &= ~FL_ONGROUND;
			pPlayer.pev.velocity = Vector(0, 0, 0);
			pPlayer.pev.angles = pEntity.pev.angles;
			pPlayer.pev.v_angle = pEntity.pev.angles;
			pPlayer.pev.fixangle = 1;

			return 1;
		}
	}

	return -3;
}

void PlayerSetArrowDefault(CBasePlayer@ pPlayer, int playerIndex, CBaseEntity @pEntity)
{
	if(pPlayer.Classify() != pEntity.pev.playerclass)
	{
		KeyValueBuffer@ pInfoBuffer = g_EngineFuncs.GetInfoKeyBuffer(pPlayer.edict());
		pInfoBuffer.SetValue( "topcolor", g_ArrayTopColorPlayer[playerIndex]);
		pInfoBuffer.SetValue( "bottomcolor", g_ArrayTopColorPlayer[playerIndex]);
	}

	pEntity.pev.playerclass = pPlayer.Classify();
	pEntity.pev.sequence = 0;
	pEntity.pev.frame = 0;
	pEntity.pev.scale = 0.15;
	@pEntity.pev.aiment = pPlayer.edict();
	pEntity.pev.movetype = MOVETYPE_FOLLOW;
	pEntity.pev.rendermode = kRenderNormal;
	
	g_EntityFuncs.SetEntitySemiVisible(pEntity.edict(), (1 << (pPlayer.entindex() - 1)) );
	g_EntityFuncs.SetEntityLevelOfDetail(pEntity.edict(),
		LOD_MODELINDEX | LOD_SCALE_INTERP, //modelindex LoD
		g_iPlayerArrowSpriteModelIndex, 0.15,      //LoD 0
		g_iPlayerArrowSpriteModelIndex, 0.15, 300, //Lod 1
		g_iPlayerArrowSprite2ModelIndex, 0.75, 700, //Lod 2
		g_iPlayerArrowSprite2ModelIndex, 0.75, 1000 //Lod 3
	);
}

void PlayerSetArrowTeamMark(CBasePlayer@ pPlayer, int playerIndex, CBaseEntity @pEntity)
{
	pEntity.pev.playerclass = pPlayer.Classify();
	pEntity.pev.sequence = 0;
	pEntity.pev.frame = 0;
	pEntity.pev.scale = 0.15;
	@pEntity.pev.aiment = pPlayer.edict();
	pEntity.pev.movetype = MOVETYPE_FOLLOW;
	pEntity.pev.rendermode = kRenderNormal;

	g_EntityFuncs.SetEntitySemiVisible(pEntity.edict(), 0 );

	if(pPlayer.Classify() == 16)
	{
		g_EntityFuncs.SetEntityLevelOfDetail(pEntity.edict(),
			LOD_MODELINDEX | LOD_SCALE_INTERP, //modelindex LoD
			g_iBlueMarkSpriteModelIndex, 0.15,      //LoD 0
			g_iBlueMarkSpriteModelIndex, 0.35, 300, //Lod 1
			g_iBlueMarkSprite2ModelIndex, 0.75, 700, //Lod 2
			g_iBlueMarkSprite2ModelIndex, 0.75, 1000 //Lod 3
		);
		KeyValueBuffer@ pInfoBuffer = g_EngineFuncs.GetInfoKeyBuffer(pPlayer.edict());

        g_ArrayTopColorPlayer[playerIndex] = atoi(pInfoBuffer.GetValue("topcolor"));
        g_ArrayBotColorPlayer[playerIndex] = atoi(pInfoBuffer.GetValue("bottomcolor"));

		pInfoBuffer.SetValue( "topcolor", 145);
		pInfoBuffer.SetValue( "bottomcolor", 145);
	}
	else if(pPlayer.Classify() == 18)
	{
		g_EntityFuncs.SetEntityLevelOfDetail(pEntity.edict(),
			LOD_MODELINDEX | LOD_SCALE_INTERP, //modelindex LoD
			g_iYellowMarkSpriteModelIndex, 0.15,      //LoD 0
			g_iYellowMarkSpriteModelIndex, 0.35, 300, //Lod 1
			g_iYellowMarkSprite2ModelIndex, 0.75, 700, //Lod 2
			g_iYellowMarkSprite2ModelIndex, 0.75, 1000 //Lod 3
		);
		KeyValueBuffer@ pInfoBuffer = g_EngineFuncs.GetInfoKeyBuffer(pPlayer.edict());
        g_ArrayTopColorPlayer[playerIndex] = atoi(pInfoBuffer.GetValue("topcolor"));
        g_ArrayBotColorPlayer[playerIndex] = atoi(pInfoBuffer.GetValue("bottomcolor"));
		pInfoBuffer.SetValue( "topcolor", 34);
		pInfoBuffer.SetValue( "bottomcolor", 34);
	}
}

void PlayerShowArrow(CBasePlayer@ pPlayer, int playerIndex)
{
	EHandle eHandle = g_ArrayArrowEntityPlayer[playerIndex];

	if(eHandle.IsValid())
	{
		CBaseEntity @pEntity = eHandle.GetEntity();

		if(pEntity.pev.playerclass != pPlayer.Classify())
		{
			if(pPlayer.Classify() >= 16 && pPlayer.Classify() <= 19)
			{
				PlayerSetArrowTeamMark(pPlayer, playerIndex, pEntity);
			}
			else
			{
				PlayerSetArrowDefault(pPlayer, playerIndex, pEntity);
			}
		}
	}
	else
	{
		CBaseEntity@ pEntity = g_EntityFuncs.Create("info_target", pPlayer.pev.origin, pPlayer.pev.angles, false);
		g_EntityFuncs.SetModel(pEntity, g_szPlayerArrowSprite);
		g_ArrayArrowEntityPlayer[pPlayer.entindex()] = EHandle(@pEntity);

		if(pPlayer.Classify() >= 16 && pPlayer.Classify() <= 19)
		{
			PlayerSetArrowTeamMark(pPlayer, playerIndex, pEntity);
		}
		else
		{
			PlayerSetArrowDefault(pPlayer, playerIndex, pEntity);
		}
	}
}

void PlayerHideArrow(CBasePlayer@ pPlayer, int playerIndex)
{
	EHandle eHandle = g_ArrayArrowEntityPlayer[playerIndex];

	if(!eHandle.IsValid())
		return;

	CBaseEntity @pEntity = eHandle.GetEntity();

	if(pEntity.pev.playerclass >= 16 && pEntity.pev.playerclass <= 19)
	{
		KeyValueBuffer@ pInfoBuffer = g_EngineFuncs.GetInfoKeyBuffer(pPlayer.edict());
		pInfoBuffer.SetValue( "topcolor", g_ArrayTopColorPlayer[playerIndex]);
		pInfoBuffer.SetValue( "bottomcolor", g_ArrayTopColorPlayer[playerIndex]);
	}

	g_EntityFuncs.Remove(pEntity);
}

void PlayerShowHat(CBasePlayer@ pPlayer, int playerIndex, string szHatModel)
{
	EHandle eHandle = g_ArrayHatEntityPlayer[playerIndex];

	if(eHandle.IsValid())
		return;

	CBaseEntity@ pEntity = g_EntityFuncs.Create("info_target", pPlayer.pev.origin, pPlayer.pev.angles, false);
	g_EntityFuncs.SetModel(pEntity, szHatModel);
	pEntity.pev.sequence = 0;
	pEntity.pev.frame = 0;
	@pEntity.pev.aiment = pPlayer.edict();
	pEntity.pev.movetype = MOVETYPE_FOLLOW;
	pEntity.pev.rendermode = kRenderNormal;

	g_ArrayHatEntityPlayer[pPlayer.entindex()] = EHandle(@pEntity);
}

void PlayerHideHat(CBasePlayer@ pPlayer, int playerIndex)
{
	EHandle eHandle = g_ArrayHatEntityPlayer[playerIndex];

	if(!eHandle.IsValid())
		return;

	g_EntityFuncs.Remove(eHandle.GetEntity());
}

void PlayerQuitSpectator(CBasePlayer@ pPlayer, int playerIndex)
{
	if(pPlayer.GetObserver().IsObserver() && g_ArraySpectatorPlayer[playerIndex] == true)
	{
		g_ArraySpectatorPlayer[playerIndex] = false;

		g_Scheduler.SetTimeout("DelayRespawn", 0.1, @pPlayer);
	}
}

HookReturnCode PlayerPreThink(CBasePlayer@ pPlayer, uint& out uiFlags)
{
	if(pPlayer is null || !pPlayer.IsConnected())
		return HOOK_CONTINUE;

	int playerIndex = pPlayer.entindex();

	g_ArrayPlayerJumpState[playerIndex] = 0;

	if(pPlayer.IsAlive())
	{
		pPlayer.SetMaxSpeed(c_PlayerDefaultMaxSpeed);
		
		if((pPlayer.pev.button & IN_JUMP) == IN_JUMP && (pPlayer.pev.oldbuttons & IN_JUMP) == 0)
		{
			PlayerJump(pPlayer, playerIndex);
		}

		if(g_ArrayBounceVelocityPlayer[playerIndex] != g_vecZero)
		{
			pPlayer.pev.velocity = pPlayer.pev.velocity + g_ArrayBounceVelocityPlayer[playerIndex];
			g_ArrayBounceVelocityPlayer[playerIndex] = g_vecZero;
		}
	}
	else
	{
		if((pPlayer.pev.button & IN_RELOAD) == IN_RELOAD && (pPlayer.pev.oldbuttons & IN_RELOAD) == 0)
		{
			PlayerQuitSpectator(pPlayer, playerIndex);
		}
	}

	//Real velocity, Used in PlayerMove->pfnTouch
	g_ArrayVelocityPlayer[playerIndex] = pPlayer.pev.velocity;

	return HOOK_CONTINUE;
}

HookReturnCode PlayerPostThink(CBasePlayer@ pPlayer)
{
	if(pPlayer is null || !pPlayer.IsConnected())
		return HOOK_CONTINUE;

	int playerIndex = pPlayer.entindex();

	//Real velocity, Used in pfnTouch
	g_ArrayVelocityPlayer[playerIndex] = pPlayer.pev.velocity;

	PlayerStopBlock(pPlayer, playerIndex);
	PlayerStopFreeze(pPlayer, playerIndex);

	if(pPlayer.IsAlive())
	{
		PlayerShowArrow(pPlayer, playerIndex);
	}
	else
	{
		PlayerHideArrow(pPlayer, playerIndex);
	}

	if(pPlayer.IsAlive())
	{
		pPlayer.m_iWeaponVolume = LOUD_GUN_VOLUME;

		if((pPlayer.pev.flags & FL_ONGROUND) == 0)
		{
			PlayerJumped(pPlayer, playerIndex);

			if(pPlayer.pev.velocity.z < -400.0)
			{
				PlayerFalling(pPlayer, playerIndex);
			}
		}
		else
		{
			PlayerStopFall(pPlayer, playerIndex);
		}
	}
	else
	{
		PlayerStopFall(pPlayer, playerIndex);
	}

    return HOOK_CONTINUE;
}

HookReturnCode PlayerPostThinkPost(CBasePlayer@ pPlayer)
{
	if(pPlayer is null || !pPlayer.IsConnected() || !pPlayer.IsAlive())
		return HOOK_CONTINUE;

	if(g_ArrayGrabPlayer[pPlayer.entindex()] != 0)
	{
		pPlayer.pev.sequence = 43;
		pPlayer.pev.frame = 100.0;
	}

    return HOOK_CONTINUE;
}

Vector GetViewDir(CBaseEntity@ plr) {
	Vector angles = plr.pev.v_angle;

	Math.MakeVectors( angles );
	
	return g_Engine.v_forward;
}

Vector GetAimDir(CBaseEntity@ ent) {
	Vector angles = ent.pev.angles;

	angles.x = -angles.x;

	Math.MakeVectors( angles );
	
	return g_Engine.v_forward;
}

bool PlayerGrab( CBaseEntity@ pPlayer)
{
	CBasePlayer@ pGrabber = cast<CBasePlayer@>(@pPlayer);

	Vector vecSrc = pGrabber.pev.origin;

	Vector dir = GetViewDir(pGrabber);
	
	Vector vecTarget = vecSrc + dir * c_PlayerGrab_Range;

	TraceResult tr;
	g_Utility.TraceHull( vecSrc, vecTarget, dont_ignore_monsters, head_hull, pGrabber.edict(), tr );

	CBaseEntity@ pHitEnt = g_EntityFuncs.Instance(tr.pHit);

	if((pHitEnt !is null) && pHitEnt.IsPlayer() && pHitEnt.IsAlive())
	{
		if(pHitEnt.entindex() != pGrabber.entindex())
		{
			if(pHitEnt.entindex() != g_ArrayGrabPlayer[pGrabber.entindex()])
			{
				g_ArrayGrabPlayer[pGrabber.entindex()] = pHitEnt.entindex();
				
				g_SoundSystem.EmitSoundDyn( pGrabber.edict(), CHAN_STATIC, g_szPlayerGrabSound, 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );
			}

			Vector vDiff = vecTarget - pHitEnt.pev.origin;

			Vector vel = vDiff.Normalize() * c_PlayerGrab_Velocity * g_Engine.frametime;

			if(vel.z > 0.0)
				vel.z = 0.0;

			vel.z *= 0.1;

			pHitEnt.pev.velocity = pHitEnt.pev.velocity + vel;

			g_ArrayGrabPlayerHandPosition[pGrabber.entindex()] = vecSrc + dir * c_PlayerGrab_HandRange;
			g_ArrayGrabPlayerVelocity[pGrabber.entindex()] = vel;

			return true;
		}
	}

	return false;
}

HookReturnCode PlayerUse(CBasePlayer@ pPlayer, uint& out uiFlags)
{
	bool bGrabbing = false;

	if ((pPlayer.pev.button & IN_USE) == IN_USE && pPlayer.GetMaxSpeedOverride() != 0)
	{
		bGrabbing = PlayerGrab(pPlayer);
	}

	if(!bGrabbing)
	{
		if(g_ArrayGrabPlayer[pPlayer.entindex()] != 0)
		{
			g_ArrayGrabPlayer[pPlayer.entindex()] = 0;

			g_SoundSystem.EmitSoundDyn( pPlayer.edict(), CHAN_STATIC, g_szPlayerGrabReleaseSound, 1.0, 1.0, 0, 90 + Math.RandomLong(0, 20) );

			EmitPlayerHitEffect(pPlayer, HitEffect_GrabBreak, g_ArrayGrabPlayerHandPosition[pPlayer.entindex()], g_ArrayGrabPlayerVelocity[pPlayer.entindex()].Normalize() );
		}
	}
	else
	{
		uiFlags |= PlrHook_SkipUse;
	}

    return HOOK_CONTINUE;
}

bool IsPlayerAvailable(CBasePlayer @pPlayer)
{
	return (pPlayer !is null && /*pPlayer.IsConnected() &&*/ (pPlayer.pev.flags & FL_DORMANT) == 0 && g_ArraySpectatorPlayer[pPlayer.entindex()] == false) ? true : false;
}

int GetPlayerCount()
{
	int count = 0;
	for (int i = 1; i <= g_Engine.maxClients; i++)
	{
		CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
		if(IsPlayerAvailable(pPlayer))
		{
			count ++;
		}
	}

	return count;
}

int GetPlayerCountEx(int &out alivePlayers, int &out deadPlayers)
{
	alivePlayers = 0;
	deadPlayers = 0;

	int count = 0;
	for (int i = 1; i <= g_Engine.maxClients; i++)
	{
		CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
		if(IsPlayerAvailable(pPlayer))
		{
			count ++;

			if(pPlayer.IsAlive())
				alivePlayers ++;
			else
				deadPlayers ++;
		}
	}

	return count;
}

void MapInit()
{
	//Point entity
	g_CustomEntityFuncs.RegisterCustomEntity( "CEnvHexagonTile", "env_hexagontile" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CEnvPhysicModel", "env_physicmodel" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CEnvStudioModel", "env_studiomodel" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CEnvSkinButton", "env_skinbutton" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerHUDSprite", "trigger_hudsprite" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerHUDCountdown", "trigger_hudcountdown" );	
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerRespawnUnstuck", "trigger_respawn_unstuck" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerSpectator", "trigger_spectator" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerRotControl", "trigger_rot_control" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerSortScore", "trigger_sort_score" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerRandomCounter", "trigger_random_counter" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerRandomMultiple", "trigger_random_multiple" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerRandomPath", "trigger_random_path" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerEntityItor2", "trigger_entity_itor2" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerEntityItor3", "trigger_entity_itor3" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerRelay2", "trigger_relay2" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CGameRoundManager", "game_round_manager" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CGameTeamPlayManager", "game_teamplay_manager" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerSortPanel", "trigger_sort_panel" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerToggleBSP", "trigger_toggle_bsp" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerCreateEnts", "trigger_create_ents" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerPlayerHat", "trigger_player_hat" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerQualifier", "trigger_qualifier" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerReviver", "trigger_reviver" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerReviveFx", "trigger_revive_fx" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerFallBallGoal", "trigger_fallball_goal" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerCheckPointer", "trigger_checkpointer" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerPhysicCannon", "trigger_physiccannon" );
	
	//Solid entity
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncRotatingFg", "func_rotating_fg" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncTrackTrainFg", "func_tracktrain_fg" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncTrainFg", "func_train_fg" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncDoorFg", "func_door_fg" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncTurnstile", "func_turnstile" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncLever", "func_lever" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncBarrier", "func_barrier" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncBouncer", "func_bouncer" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncBounceDrum", "func_bouncedrum" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncPendulum2", "func_pendulum2" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncConveyor2", "func_conveyor2" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncBreakDoor", "func_breakdoor" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncMatchFloor", "func_matchfloor" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncTipTile", "func_tiptile" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerPhysicTrigger", "trigger_physictrigger" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerFreeze", "trigger_freeze" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerReviveZone", "trigger_revive_zone" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerCheckPointZone", "trigger_checkpoint_zone" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerFindBrush", "trigger_findbrush" );

	//Monster
	g_CustomEntityFuncs.RegisterCustomEntity( "CMonsterRhino", "monster_rhino" );

	g_iPlayerArrowSpriteModelIndex = g_Game.PrecacheModel( g_szPlayerArrowSprite );
	g_iPlayerArrowSprite2ModelIndex = g_Game.PrecacheModel( g_szPlayerArrowSprite2 );

	g_iBlueMarkSpriteModelIndex = g_Game.PrecacheModel( g_szBlueMarkSprite );
	g_iBlueMarkSprite2ModelIndex = g_Game.PrecacheModel( g_szBlueMarkSprite2 );

	g_iYellowMarkSpriteModelIndex = g_Game.PrecacheModel( g_szYellowMarkSprite );
	g_iYellowMarkSprite2ModelIndex = g_Game.PrecacheModel( g_szYellowMarkSprite2 );

	for(int i = 0;i < int(g_szPlayerJumpEffectSprite.length() ); ++i)
		g_iPlayerJumpEffectSprite[i] = g_Game.PrecacheModel( g_szPlayerJumpEffectSprite[i] );

	for(int i = 0;i < int(g_szPlayerHitEffectSprite.length() ); ++i)
		g_iPlayerHitEffectSprite[i] = g_Game.PrecacheModel( g_szPlayerHitEffectSprite[i] );

	for(int i = 0;i < int(g_szPlayerHitEffectModel.length() ); ++i)
		g_iPlayerHitEffectModel[i] = g_Game.PrecacheModel( g_szPlayerHitEffectModel[i] );

	g_SoundSystem.PrecacheSound( g_szPlayerGrabSound );
	g_SoundSystem.PrecacheSound( g_szPlayerGrabReleaseSound );

	for (int i = 0;i < int(g_szPlayerQualifiedSound.length()); ++i)
		g_SoundSystem.PrecacheSound( g_szPlayerQualifiedSound[i] );

	for (int i = 0;i < int(g_szPlayerJumpSound.length()); ++i)
		g_SoundSystem.PrecacheSound( g_szPlayerJumpSound[i] );

	for (int i = 0;i < int(g_szPlayerHitSound.length()); ++i)
		g_SoundSystem.PrecacheSound( g_szPlayerHitSound[i] );

	for (int i = 0;i < int(g_szFootStepPlasticSound.length()); ++i)
		g_SoundSystem.PrecacheSound( g_szFootStepPlasticSound[i] );

	for (int i = 0;i < int(g_szFootStepSlipperySound.length()); ++i)
		g_SoundSystem.PrecacheSound( g_szFootStepSlipperySound[i] );

	for (int i = 0;i < int(g_szJumpPlasticSound.length()); ++i)
		g_SoundSystem.PrecacheSound( g_szJumpPlasticSound[i] );

	for (int i = 0;i < int(g_szJumpSlipperySound.length()); ++i)
		g_SoundSystem.PrecacheSound( g_szJumpSlipperySound[i] );

	for (int i = 0;i < int(g_szImpactPlasticSound.length()); ++i)
		g_SoundSystem.PrecacheSound( g_szImpactPlasticSound[i] );

	for (int i = 0;i < int(g_szPlayerFallingSound.length()); ++i)
		g_SoundSystem.PrecacheSound( g_szPlayerFallingSound[i] );

	slRhinoDash.AddTask( ScriptTask(TASK_STOP_MOVING) );
	slRhinoDash.AddTask( ScriptTask(TASK_FACE_IDEAL) );
	slRhinoDash.AddTask( ScriptTask(TASK_RANGE_ATTACK1) );
	slRhinoDash.AddTask( ScriptTask(TASK_SET_ACTIVITY, float(ACT_IDLE))  );
	slRhinoDash.AddTask( ScriptTask(TASK_WAIT_RANDOM, float(5.0)) );
	
	array<ScriptSchedule@> scheds = { slRhinoDash };
	
	@monster_rhino_schedules = @scheds;

    g_Hooks.RegisterHook(Hooks::Player::PlayerMovePlaySoundFX, @PlayerMovePlaySoundFX);
    g_Hooks.RegisterHook(Hooks::Player::PlayerTouchPlayer, @PlayerTouchPlayer);
	g_Hooks.RegisterHook(Hooks::Player::ClientPutInServer, @ClientPutInServer);
	g_Hooks.RegisterHook(Hooks::Player::ClientDisconnect, @ClientDisconnect);
	g_Hooks.RegisterHook(Hooks::Player::PlayerSpawn, @PlayerSpawn);
    g_Hooks.RegisterHook(Hooks::Player::PlayerTakeDamage, @PlayerTakeDamage);
    g_Hooks.RegisterHook(Hooks::Player::PlayerPreThink, @PlayerPreThink);
    g_Hooks.RegisterHook(Hooks::Player::PlayerPostThink, @PlayerPostThink);
    g_Hooks.RegisterHook(Hooks::Player::PlayerPostThinkPost, @PlayerPostThinkPost);
    g_Hooks.RegisterHook(Hooks::Player::PlayerUse, @PlayerUse);

	g_EngineFuncs.EnableCustomStepSound(true);
}