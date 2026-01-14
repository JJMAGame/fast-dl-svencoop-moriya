/*
* trigger_playercheck
* Checks how many players are in the volume, and toggles the target entity
* based on the set mode and threshold.
*
* Author: Tomas "GeckoN" Slavotinek
*/

namespace TriggerPlayerCheck
{

const string ENTITY_NAME = "trigger_playercheck";

const int SPAWNFLAGS_STARTOFF = 1;

enum COMPMODE
{
	COMPMODE_GREATER = 0,
	COMPMODE_LESS,
	COMPMODE_EQUALS,
	
	NUM_COMPMODES
};

const float DEFAULT_INTERVAL = 0.5;
const COMPMODE DEFAULT_COMPMODE = COMPMODE_GREATER;

class CTriggerPlayerCheck : ScriptBaseEntity
{
	COMPMODE	m_compMode = DEFAULT_COMPMODE;
	int			m_iThreshold = 0;
	float		m_flInterval = DEFAULT_INTERVAL;
	string		m_strMaster;
	bool		m_fState = false;
	bool		m_fEnabled = false;
	
	int ObjectCaps()
	{
		return ( BaseClass.ObjectCaps() | FCAP_MASTER );
	}
	
	void SetMode( int iMode )
	{
		if ( iMode < 0 || iMode >= NUM_COMPMODES )
		{
			g_Game.AlertMessage( at_error, "\"%1\": Invalid mode \"%2\"!\n", self.pev.targetname, iMode );
			m_compMode = COMPMODE_GREATER;
		}

		m_compMode = COMPMODE( iMode );
	}
	
	void Spawn()
	{
		self.pev.solid = SOLID_TRIGGER;
		self.pev.movetype = MOVETYPE_NONE;
		
		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		
		SetUse( UseFunction( this.Use ) );
		
		bool fEnabled = ( self.pev.spawnflags & SPAWNFLAGS_STARTOFF ) == 0;
		SetEnabled( fEnabled, false );
		
		self.pev.nextthink = g_Engine.time;
	}

	bool KeyValue( const string & in szKey, const string & in szValue )
	{
		if( szKey == "mode" )
		{
			SetMode( atoi( szValue ) );
			return true;
		}
		else if( szKey == "threshold" )
		{
			m_iThreshold = Math.max( atoi( szValue ), 0 );
			return true; 
		}
		else if ( szKey == "master" )
		{
			m_strMaster = szValue;
			return true;
		}
		else if ( szKey == "interval" )
		{
			m_flInterval = Math.max( atof( szValue ), 0.0f );
			return true;
		}
		else
		{
			return BaseClass.KeyValue( szKey, szValue );
		}
	}
	
	bool ShouldTouchToggle()
	{
		if ( m_fState )
		{
			if ( m_iThreshold == 0 && m_compMode == COMPMODE_EQUALS )
				return true;
		
			if ( m_iThreshold == 1 && m_compMode == COMPMODE_LESS )
				return true;
		}
		else
		{
			if ( m_iThreshold == 0 && m_compMode == COMPMODE_GREATER )
				return true;
		}
		
		return false;
	}
	
	void Touch( CBaseEntity@ pOther )
	{
		if ( pOther is null || !pOther.IsPlayer() )
			return;
		
		if ( !m_fEnabled )
			return;
		
		if ( ShouldTouchToggle() )
		{
			//g_Game.AlertMessage( at_console, "\"%1\": Touch toggling\n", self.pev.targetname );
			TestPlayersInVolume();
		}
	}
	
	void Think()
	{
		TestPlayersInVolume();
		
		self.pev.nextthink = g_Engine.time + m_flInterval;
	}
	
	void DieThink()
	{
		g_EntityFuncs.Remove( self );
	}
	
	bool ShouldUpdate()
	{
		if ( !m_fEnabled )
			return false;
		
		if ( m_strMaster == "" )
			return true;
		
		// GeckoN: TODO: Workaround
		CBaseEntity@ pEntity = g_EntityFuncs.FindEntityByTargetname( null, m_strMaster );
		if ( pEntity is null )
			return false;
			
		if ( pEntity.pev.classname == ENTITY_NAME )
		{
			CTriggerPlayerCheck@ pMaster = cast<CTriggerPlayerCheck@>( CastToScriptClass( pEntity ) );
			if ( pMaster is null )
				return false;
			
			if ( !pMaster.IsTriggered( self ) )
				return false;
		}
		else if ( !g_EntityFuncs.IsMasterTriggered( m_strMaster, self ) )
		{
			return false;
		}
		
		return true;
	}
	
	bool GetNewState( int iInside )
	{
		switch ( m_compMode )
		{
		case COMPMODE_GREATER: return iInside > m_iThreshold;
		case COMPMODE_LESS: return iInside < m_iThreshold;
		case COMPMODE_EQUALS: return iInside == m_iThreshold;
		}
		
		return false; // This should never happen
	}
	
	void TestPlayersInVolume()
	{
		if ( !ShouldUpdate() )
		{
			//g_Game.AlertMessage( at_console, "\"%1\": Master \"%2\" not active!\n", self.pev.targetname, m_strMaster );
			return;
		}
		
		int iInside = 0;
		int iOutside = 0;
		CBaseEntity@ pVolume = self;
		PlayerInVolumeListener@ pNullListener = null;
		int iTotal = g_Utility.CountPlayersInBrushVolume( true, self, iInside, iOutside, null );
		
		//g_Game.AlertMessage( at_console, "\"%1\": Total: %2 in: %3 out: %4\n", self.pev.targetname, iTotal, iInside, iOutside );
		
		bool fPrevState = m_fState;
		
		m_fState = GetNewState( iInside );
		
		if ( m_fState != fPrevState )
		{
			FireTarget();
		}
	}
	
	void FireTarget()
	{
		if (  self.pev.target == "" )
			return;
		
		USE_TYPE useType = m_fState ? USE_ON : USE_OFF;
		g_EntityFuncs.FireTargets( self.pev.target, self, self, useType, 0.0f, 0.0f );
		//g_Game.AlertMessage( at_console, "\"%1\": Triggering \"%2\" (%3)\n", self.pev.targetname, pev.target, m_fState ? "USE_ON" : "USE_OFF" );
	}
	
	bool IsTriggered( CBaseEntity@ pEntity )
	{
		return m_fState;
	}
	
	void SetEnabled( bool fEnabled, bool fFireOnDisable )
	{
		if ( m_fEnabled == fEnabled )
			return;
		
		m_fEnabled = fEnabled;
		
		if ( m_fEnabled )
		{
			SetThink( ThinkFunction( Think ) );
			SetTouch( TouchFunction( Touch ) );
		}
		else
		{
			SetThink( null );
			SetTouch( null );
			if ( fFireOnDisable )
			{
				m_fState = false;
				FireTarget();
			}
		}
	}
	
	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float value )
	{
		bool fEnabled = m_fEnabled;
		switch ( useType )
		{
		case USE_ON: fEnabled = true; break;
		case USE_OFF: fEnabled = false; break;
		case USE_TOGGLE: fEnabled = !m_fEnabled; break;
		case USE_KILL: fEnabled = false; break;
		default: return;
		}
		
		SetEnabled( fEnabled, true );
		
		if ( useType == USE_KILL )
		{
			SetUse( null );
			SetThink( ThinkFunction( DieThink ) );
		}
		
		pev.nextthink = g_Engine.time;
	}
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "TriggerPlayerCheck::CTriggerPlayerCheck", ENTITY_NAME );
}

} // end of namespace
