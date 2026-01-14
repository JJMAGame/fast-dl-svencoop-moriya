// This is a stripped down copy of trigger_teleport

// Entity spawnflags
const int SF_TELEPORT_RANDOM_DESTINATION = 64;
const int SF_TELEPORT_KEEP_ANGLES = 256;
const int SF_TELEPORT_KEEP_VELOCITY = 512;

class CTriggerTeleport : ScriptBaseEntity
{
	float m_flCooldownTime;
	bool m_bIgnoreDelay;
	bool m_bDisabled;
	
	float m_flNextTouchTime;
	
	bool KeyValue( const string& in szKey, const string& in szValue )
	{
		// Keyvalues and spawnflags are identical to vanilla trigger_teleport for easier usage
		if ( szKey == "teleport_cooldown" )
		{
			m_flCooldownTime = atof( szValue );
			return true;
		}
		else if ( szKey == "teleport_ignore_delay" )
		{
			if ( atoi( szValue ) >= 1 )
				m_bIgnoreDelay = true;
			
			return true;
		}
		else if ( szKey == "teleport_start_inactive" )
		{
			if ( atoi( szValue ) >= 1 )
				m_bDisabled = true;
			
			return true;
		}
		else
			return BaseClass.KeyValue( szKey, szValue );
	}
	
	void Spawn()
	{
		// Initialize
		self.pev.solid = SOLID_TRIGGER;
		self.pev.movetype = MOVETYPE_NONE;
		self.pev.effects = EF_NODRAW;
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetModel( self, self.pev.model );
	}
	
	void Touch( CBaseEntity@ pOther )
	{
		// Teleport is turned off
		if ( m_bDisabled )
			return;
		
		// Delays are ignored, or cooldown has finished
		if ( m_bIgnoreDelay || g_Engine.time > m_flNextTouchTime )
		{
			// Whatever is trying to get into the teleport must be alive
			if ( pOther.IsAlive() )
			{
				string szTarget = self.pev.target;
				CBaseEntity@ pTarget = null;
				
				// Random destination?
				if ( self.pev.SpawnFlagBitSet( SF_TELEPORT_RANDOM_DESTINATION ) )
					@pTarget = g_EntityFuncs.RandomTargetname( szTarget );
				else // Take the first match we get
					@pTarget = g_EntityFuncs.FindEntityByTargetname( null, szTarget );
				
				// Valid teleport destination
				if ( pTarget !is null )
				{
					Vector vecDestination = pTarget.pev.origin;
					
					// Destination must be clear
					TraceResult tr;
					HULL_NUMBER hullCheck;
					string szClassname = pOther.pev.classname;
					
					// Adapt hull check based on monsters size
					// P.S: A better way to check this? I do not like checking string by string. -Giegue
					
					// Large monsters
					if ( szClassname == "monster_babygarg" || szClassname == "monster_bigmomma" || szClassname == "monster_alien_voltigore" )
						hullCheck = large_hull;
					else
						hullCheck = human_hull; // Human-sized or small monster, should be enough
					
					g_Utility.TraceHull( vecDestination, vecDestination, dont_ignore_monsters, hullCheck, pTarget.edict(), tr );
					
					if ( tr.fAllSolid == 1 || tr.fStartSolid == 1 || tr.fInOpen == 0 )
					{
						// Destination is obstructed! Try again later
						m_flNextTouchTime = g_Engine.time + m_flCooldownTime;
					}
					else
					{
						// All clear! Teleport here
						if ( pOther.IsPlayer() )
						{
							// make origin adjustments in case the teleportee is a player. (origin in center, not at feet)
							// from HLSDK
							vecDestination.z -= pOther.pev.mins.z;
						}
						
						g_EntityFuncs.SetOrigin( pOther, vecDestination );
						
						// Keep velocity/angles?
						if ( !self.pev.SpawnFlagBitSet( SF_TELEPORT_KEEP_VELOCITY ) )
							pOther.pev.velocity = g_vecZero;
						if ( !self.pev.SpawnFlagBitSet( SF_TELEPORT_KEEP_ANGLES ) )
						{
							pOther.pev.angles = pTarget.pev.angles;
							if ( pOther.IsPlayer() )
								pOther.pev.fixangle = FAM_FORCEVIEWANGLES;
						}
						
						// Trigger on arrival?
						if ( pTarget.pev.SpawnFlagBitSet( 32 ) ) // info_teleport_destination spawnflag 32 = trigger on arrival
						{
							// Trigger entity
							g_EntityFuncs.FireTargets( pTarget.pev.target, pOther, pTarget, USE_TOGGLE ); 
						}
						
						m_flNextTouchTime = g_Engine.time + m_flCooldownTime;
					}
				}
			}
		}
	}
	
	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
	{
		// does USE_TYPE support switch? -Giegue
		
		if ( useType == USE_TOGGLE )
			m_bDisabled = ( m_bDisabled ? false : true );
		else if ( useType == USE_ON )
			m_bDisabled = false;
		else if ( useType == USE_OFF )
			m_bDisabled = true;
	}
}

void RegisterTeleport()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CTriggerTeleport", "trigger_nostuck_teleport" );
}
