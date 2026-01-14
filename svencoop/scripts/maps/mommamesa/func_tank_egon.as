/* 
FUNC_TANK_EGON -- Created by Josh "JPolito" Polito using the Half-Life SDK code for WEAPON_EGON, with much assistance from Sam "Solokiller" VanHeer and Dave "Sniper" McDermott.
 */

int EGON_PRIMARY_VOLUME	= 450;
string EGON_BEAM_SPRITE = "sprites/xbeam1.spr";
string EGON_FLARE_SPRITE = "sprites/XSpark1.spr";
string EGON_SOUND_OFF = "weapons/egon_off1.wav";
string EGON_SOUND_RUN = "weapons/egon_run3.wav";
string EGON_SOUND_STARTUP = "weapons/egon_windup2.wav";
enum EGON_FIRESTATE { FIRE_OFF, FIRE_CHARGE };
enum EGON_FIREMODE { FIRE_NARROW, FIRE_WIDE};

class func_tank_egon : ScriptBaseTankEntity
{
	float	m_shootTime;
	float	m_soundTime;
	CBeam@ m_pBeam;
	CBeam@	m_pNoise;
	CSprite@ m_pSprite;
	EGON_FIRESTATE	m_fireState;
	EGON_FIREMODE m_fireMode;
	float	m_shakeTime;
	bool m_deployed;

	void Spawn()
	{
		BaseClass.Spawn();
		  
		SetThink( ThinkFunction( this.Think ) );
	}
	 
	 void Think()
	{
		BaseClass.Think();
		
		self.pev.nextthink = self.pev.ltime + 0.01f;
		  
		if( m_shootTime + 0.1 >= g_Engine.time )
		return;
		
		if ( m_fireState != FIRE_OFF )
		{
			DestroyEffect();
		}
	}
	
	void Fire( const Vector& in vecBarrelEnd, const Vector& in vecForward, entvars_t@ pevAttacker )
	{
		Vector vecDest = vecBarrelEnd + vecForward * 2048;
		TraceResult tr;

		Vector tmpSrc = vecBarrelEnd + g_Engine.v_up * -8 + g_Engine.v_right * 3;

		// ALERT( at_console, "." );
	
		g_Utility.TraceLine( vecBarrelEnd, vecDest, dont_ignore_monsters, self.edict(), tr );

		if (tr.fAllSolid != 0 || tr.fStartSolid != 0 )
			return;

		CBaseEntity@ pEntity = g_EntityFuncs.Instance( tr.pHit );

		if ( pEntity is  null )
			return;
   
		const float flDist = ( vecDest - vecBarrelEnd ).Length();
		  
		const float flFiringDist = ( flDist * tr.flFraction );
		  
		if( flFiringDist <= 100 )
			return;
			



		if( m_pSprite !is null )
		{
			if( pEntity.pev.takedamage != 0 )
			{
				  m_pSprite.pev.effects &= ~EF_NODRAW;
			}
			else m_pSprite.pev.effects |= EF_NODRAW;
		}
		
		float timedist = 0;



		//case FIRE_NARROW:
			if ( self.pev.dmgtime < g_Engine.time )
			{
				// Narrow mode only does damage to the entity it hits
				g_WeaponFuncs.ClearMultiDamage();
				if ( pEntity.pev.takedamage != 0 )
				{
					pEntity.TraceAttack( self.pev, 5, vecForward, tr, DMG_ENERGYBEAM );
				}
				g_WeaponFuncs.ApplyMultiDamage( self.pev, self.pev );

				self.pev.dmgtime = g_Engine.time + 0.1f;
			}
			timedist = ( self.pev.dmgtime - g_Engine.time ) / 0.1f;
			
		if ( timedist < 0 )
			timedist = 0;
		else if ( timedist > 1 )
			timedist = 1;
		timedist = 1-timedist;

		UpdateEffect( tmpSrc, tr.vecEndPos, timedist );
	}


	void UpdateEffect( const Vector & in startPoint, const Vector &in endPoint, float timeBlend )
	{
		if ( m_pBeam is null )
		{
			CreateEffect();
		}

		//m_pBeam.SetStartPos( endPoint );
		m_pBeam.SetStartPos( startPoint );
		m_pBeam.SetEndPos( endPoint );
		m_pBeam.SetBrightness( 255 - int(timeBlend*180) );
		m_pBeam.SetWidth( 40 - int(timeBlend*20) );

		if ( m_fireMode == FIRE_WIDE )
			m_pBeam.SetColor( 30 + int(25*timeBlend), 30 + int(30*timeBlend), 64 + int(80*abs(sin(g_Engine.time*10)) ) );
		else
			m_pBeam.SetColor( 60 + int(25*timeBlend), 120 + int(30*timeBlend), 64 + int(80*(abs(sin(g_Engine.time*10)) ) ) );


		g_EntityFuncs.SetOrigin( m_pSprite, endPoint );
		m_pSprite.pev.frame += 8 * g_Engine.frametime;
		if ( m_pSprite.pev.frame > m_pSprite.Frames() )
			m_pSprite.pev.frame = 0;

		m_pNoise.SetStartPos( startPoint );
		m_pNoise.SetEndPos( endPoint );
		
		m_shootTime = g_Engine.time;
		
		if ( (m_soundTime + 2.0f) > g_Engine.time )
			return;
			
		if ( (m_soundTime + 2.0f) < g_Engine.time )
		{
			g_SoundSystem.PlaySound( self.edict(), CHAN_STATIC, EGON_SOUND_RUN, 0.9, ATTN_NORM, 0, 100 );
			m_soundTime = g_Engine.time;
		}
	}

	void CreateEffect( void )
	{
		DestroyEffect();
		m_fireState = FIRE_CHARGE;
		
		@m_pBeam = g_EntityFuncs.CreateBeam( EGON_BEAM_SPRITE, 40 );
		m_pBeam.PointsInit( self.pev.origin, self.pev.origin );
		m_pBeam.SetFlags( BEAM_FSINE );
		m_pBeam.SetEndAttachment( 1 );

		@m_pNoise = g_EntityFuncs.CreateBeam( EGON_BEAM_SPRITE, 55 );
		m_pNoise.PointsInit( self.pev.origin, self.pev.origin );
		m_pNoise.SetScrollRate( 25 );
		m_pNoise.SetBrightness( 100 );
		m_pNoise.SetEndAttachment( 1 );

		@m_pSprite = g_EntityFuncs.CreateSprite( EGON_FLARE_SPRITE, self.pev.origin, false );
		m_pSprite.pev.scale = 1.0;
		m_pSprite.SetTransparency( kRenderGlow, 255, 255, 255, 255, kRenderFxNoDissipation );

		if ( m_fireMode == FIRE_WIDE )
		{
			g_SoundSystem.PlaySound( self.edict(), CHAN_WEAPON, EGON_SOUND_STARTUP, 0.98, ATTN_NORM, 0, 125 );
			m_soundTime = g_Engine.time;
			
			m_pBeam.SetScrollRate( 50 );
			m_pBeam.SetNoise( 20 );
			m_pNoise.SetColor( 50, 50, 255 );
			m_pNoise.SetNoise( 8 );
		}
		else
		{
			g_SoundSystem.PlaySound( self.edict(), CHAN_WEAPON, EGON_SOUND_STARTUP, 0.9, ATTN_NORM, 0, 100 );
			m_soundTime = g_Engine.time;

			m_pBeam.SetScrollRate( 110 );
			m_pBeam.SetNoise( 5 );
			m_pNoise.SetColor( 80, 120, 255 );
			m_pNoise.SetNoise( 2 );
		}
	}


	void DestroyEffect( void )
	{
		g_SoundSystem.StopSound( self.edict(), CHAN_STATIC, EGON_SOUND_RUN );
		g_SoundSystem.PlaySound( self.edict(), CHAN_WEAPON, EGON_SOUND_OFF, 1.0f, 1.0f, 0, 100 );
		m_fireState = FIRE_OFF;
	
		if ( m_pBeam !is null )
		{
			g_EntityFuncs.Remove( m_pBeam );
			@m_pBeam = null;
		}
		if ( m_pNoise !is null )
		{
			g_EntityFuncs.Remove( m_pNoise );
			@m_pNoise = null;
		}
		if ( m_pSprite !is null )
		{
			if ( m_fireMode == FIRE_WIDE )
				m_pSprite.Expand( 10, 500 );
			else
				g_EntityFuncs.Remove( m_pSprite );
			@m_pSprite = null;
		}
	}
}