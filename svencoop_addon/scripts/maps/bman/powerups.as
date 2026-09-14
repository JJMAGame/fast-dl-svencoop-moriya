array<string> g_szHelpMsgs = {
	"PRESS RELOAD KEY TO PLACE NUKE",
	"PRESS ATTACK1 KEY TO DETONATE BOMBS",
};

enum e_bombs
{
	NUKE = 0,
	REMOTE
}

class CPowerupBomb : ScriptBaseAnimating
{
	private float m_flNextTouchTime;

	void Spawn()
	{
		g_EntityFuncs.SetModel( self, g_szPowerupModel );
		self.SetBodygroup( 0, 2 );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		g_EntityFuncs.SetSize( self.pev, Vector( -18, -18, 0 ), Vector( 18, 18, 50 ) );

		self.pev.solid = SOLID_BBOX;
		self.pev.movetype = MOVETYPE_PUSHSTEP;
		self.pev.takedamage = DAMAGE_YES;

		//when classic cam is enabled set the animation so that the powerup is visible from above
		if( blClassicCamEnabled )
		{
			self.pev.angles = Vector( 0, 90, 0 );
			self.pev.sequence = 1;
		}
		else
			self.pev.sequence = 0;
		self.pev.frame = 0;
		self.ResetSequenceInfo();

		self.pev.targetname = "powerup_bomb_powerup";

		if( self.pev.health == 0.0f )
			self.pev.health  = g_iExplodeDamage;

		self.pev.nextthink = g_Engine.time + 0.1f;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pOther );

		if( pPlayer.IsAlive() && !pPlayer.GetObserver().IsObserver() )
		{
			ClearPoison( pPlayer );
			CustomKeyvalues@ kvEntity = pPlayer.GetCustomKeyvalues();

			if( kvEntity is null || !kvEntity.HasKeyvalue( "$i_maxBombCount" ) )
				return;

			if ( kvEntity.GetKeyvalue( "$i_maxBombCount" ).GetInteger() < 6 )
			{
				string szMaxBombCount;
				szMaxBombCount = string( kvEntity.GetKeyvalue( "$i_maxBombCount" ).GetInteger() + 1 );
				g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_maxBombCount", szMaxBombCount );
				AttachBombSprite( pPlayer );
				self.Killed( null, 0 );
			}
			else
			{
				self.Killed( null, 0 );
			}
			g_SoundSystem.PlaySound( pPlayer.edict(), CHAN_VOICE, "bman/item_get.mp3", 10.0f, 10.0f, 0, PITCH_NORM, pPlayer.entindex(), true, pPlayer.GetOrigin() );
		}
	}
}

class CPowerupLife : ScriptBaseAnimating
{
	private float m_flNextTouchTime;

	void Spawn()
	{
		g_EntityFuncs.SetModel( self, g_szPowerupModel );
		self.SetBodygroup( 0, 7 );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		g_EntityFuncs.SetSize( self.pev, Vector( -18, -18, 0 ), Vector( 18, 18, 50 ) );

		self.pev.solid = SOLID_BBOX;
		self.pev.movetype = MOVETYPE_PUSHSTEP;
		self.pev.takedamage = DAMAGE_YES;

		//when classic cam is enabled set the animation so that the powerup is visible from above
		if( blClassicCamEnabled )
		{
			self.pev.angles = Vector( 0, 90, 0 );
			self.pev.sequence = 1;
		}
		else
			self.pev.sequence = 0;
		self.pev.frame = 0;
		self.ResetSequenceInfo();

		self.pev.targetname = "powerup_life_powerup";

		if( self.pev.health == 0.0f )
			self.pev.health  = g_iExplodeDamage;

		self.pev.nextthink = g_Engine.time + 0.1f;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pOther );
		if( pPlayer.IsAlive() && !pPlayer.GetObserver().IsObserver() )
		{
			ClearPoison( pPlayer );
			if( pPlayer.pev.health > ( pPlayer.pev.max_health - g_iExplodeDamage ) )
				pPlayer.pev.health = pPlayer.pev.health + ( pPlayer.pev.max_health - pPlayer.pev.health );
			else
				pPlayer.pev.health = pPlayer.pev.health + g_iExplodeDamage;

			AttachLifeSprite( pPlayer );
			self.Killed( null, 0 );
			g_SoundSystem.PlaySound( pPlayer.edict(), CHAN_VOICE, "bman/item_get.mp3", 10.0f, 10.0f, 0, PITCH_NORM, pPlayer.entindex(), true, pPlayer.GetOrigin() );
		}
	}
}

class CPowerupFire : ScriptBaseAnimating
{
	private float m_flNextTouchTime;

	void Spawn()
	{
		g_EntityFuncs.SetModel( self, g_szPowerupModel );
		self.SetBodygroup( 0, 5 );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		g_EntityFuncs.SetSize( self.pev, Vector( -18, -18, 0 ), Vector( 18, 18, 50 ) );

		self.pev.solid = SOLID_BBOX;
		self.pev.movetype = MOVETYPE_PUSHSTEP;
		self.pev.takedamage = DAMAGE_YES;

		//when classic cam is enabled set the animation so that the powerup is visible from above
		if( blClassicCamEnabled )
		{
			self.pev.angles = Vector( 0, 90, 0 );
			self.pev.sequence = 1;
		}
		else
			self.pev.sequence = 0;
		self.pev.frame = 0;
		self.ResetSequenceInfo();

		self.pev.targetname = "powerup_fire_powerup";

		if( self.pev.health == 0.0f )
			self.pev.health  = g_iExplodeDamage;

		self.pev.nextthink = g_Engine.time + 0.1f;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pOther );
		if( pPlayer.IsAlive() && !pPlayer.GetObserver().IsObserver() )
		{
			ClearPoison( pPlayer );
			CustomKeyvalues@ kvEntity = pPlayer.GetCustomKeyvalues();

			if( kvEntity is null || !kvEntity.HasKeyvalue( "$i_ownBombStrength" ) )
				return;

			if ( kvEntity.GetKeyvalue( "$i_ownBombStrength" ).GetInteger() < 3 )
			{
				string szPlayerBombStrength = string( kvEntity.GetKeyvalue( "$i_ownBombStrength" ).GetInteger() + 1 );
				g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_ownBombStrength", szPlayerBombStrength );
				self.Killed( null, 0 );
			}
			else
			{
				self.Killed( null, 0 );
			}
			g_SoundSystem.PlaySound( pPlayer.edict(), CHAN_VOICE, "bman/item_get.mp3", 10.0f, 10.0f, 0, PITCH_NORM, pPlayer.entindex(), true, pPlayer.GetOrigin() );
		}
	}
}

class CPowerupSkate : ScriptBaseAnimating
{
	private float m_flNextTouchTime;

	void Spawn()
	{
		g_EntityFuncs.SetModel( self, g_szPowerupModel );
		self.SetBodygroup( 0, 15 );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		g_EntityFuncs.SetSize( self.pev, Vector( -18, -18, 0 ), Vector( 18, 18, 50 ) );

		self.pev.solid = SOLID_BBOX;
		self.pev.movetype = MOVETYPE_PUSHSTEP;
		self.pev.takedamage = DAMAGE_YES;

		//when classic cam is enabled set the animation so that the powerup is visible from above
		if( blClassicCamEnabled )
		{
			self.pev.angles = Vector( 0, 90, 0 );
			self.pev.sequence = 1;
		}
		else
			self.pev.sequence = 0;
		self.pev.frame = 0;
		self.ResetSequenceInfo();

		self.pev.targetname = "powerup_skate_powerup";

		if( self.pev.health == 0.0f )
			self.pev.health  = g_iExplodeDamage;

		self.pev.nextthink = g_Engine.time + 0.1f;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pOther );
		if( pPlayer.IsAlive() && !pPlayer.GetObserver().IsObserver() )
		{
			ClearPoison( pPlayer );
			int iNewSpeed = pPlayer.GetMaxSpeed() + 20;
			pPlayer.SetMaxSpeed( iNewSpeed );
			self.Killed( null, 0 );
			g_SoundSystem.PlaySound( pPlayer.edict(), CHAN_VOICE, "bman/item_get.mp3", 10.0f, 10.0f, 0, PITCH_NORM, pPlayer.entindex(), true, pPlayer.GetOrigin() );
		}
	}
}

class CPowerupSkull : ScriptBaseAnimating
{
	private float m_flNextTouchTime;
	private int m_iPoisonEffect;

	void Spawn()
	{
		g_EntityFuncs.SetModel( self, g_szPowerupModel );
		self.SetBodygroup( 0, 13 );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		g_EntityFuncs.SetSize( self.pev, Vector( -18, -18, 0 ), Vector( 18, 18, 50 ) );

		self.pev.solid = SOLID_BBOX;
		self.pev.movetype = MOVETYPE_PUSHSTEP;
		self.pev.takedamage = DAMAGE_YES;

		//when classic cam is enabled set the animation so that the powerup is visible from above
		if( blClassicCamEnabled )
		{
			self.pev.angles = Vector( 0, 90, 0 );
			self.pev.sequence = 1;
		}
		else
			self.pev.sequence = 0;
		self.pev.frame = 0;
		self.ResetSequenceInfo();

		self.pev.targetname = "powerup_skull_powerup";

		if( self.pev.health == 0.0f )
			self.pev.health  = g_iExplodeDamage;

		self.pev.nextthink = g_Engine.time + 0.1f;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pOther );
		if( pPlayer.IsAlive() && !pPlayer.GetObserver().IsObserver() )
		{
			CustomKeyvalues@ kvPlayer = pPlayer.GetCustomKeyvalues();
			ClearPoison( pPlayer );
			m_iPoisonEffect = Math.RandomLong( 0, 4 );

			AttachPoisonSprite( pPlayer );

			switch( m_iPoisonEffect )
			{
				case 0:
					pPlayer.SetMaxSpeed( 80 );
					g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_poisoned", "1" );
					g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_poisonType", string( m_iPoisonEffect ) );
					g_EngineFuncs.ClientPrintf( pPlayer, print_center, "TOO SLOW!\n" );
					break;

				case 1:
					pPlayer.SetMaxSpeed( 800 );
					g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_poisoned", "1" );
					g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_poisonType", string( m_iPoisonEffect ) );
					g_EngineFuncs.ClientPrintf( pPlayer, print_center, "TOO FAST!\n" );
					break;

				case 2:
					g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_poisoned", "1" );
					g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_poisonType", string( m_iPoisonEffect ) );
					g_EngineFuncs.ClientPrintf( pPlayer, print_center, "CONSTIPATED!\n" );
					break;

				case 3:
					g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_poisoned", "1" );
					g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_poisonType", string( m_iPoisonEffect ) );
					g_EngineFuncs.ClientPrintf( pPlayer, print_center, "WEAK BOMBS!\n" );
					break;

				case 4:
					CreateScream( pPlayer );
					g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_poisoned", "1" );
					g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_poisonType", string( m_iPoisonEffect ) );
					g_EngineFuncs.ClientPrintf( pPlayer, print_center, "DIARRHEA!\n" );
					break;

				default:
					break;
			}
			self.Killed( null, 0 );
			g_SoundSystem.PlaySound( pPlayer.edict(), CHAN_VOICE, "bman/skull.mp3", 10.0f, 10.0f, 0, PITCH_NORM, pPlayer.entindex(), true, pPlayer.GetOrigin() );
		}
	}
}

class CPowerupKick : ScriptBaseAnimating
{
	private float m_flNextTouchTime;

	void Spawn()
	{
		g_EntityFuncs.SetModel( self, g_szPowerupModel );
		self.SetBodygroup( 0, 8 );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		g_EntityFuncs.SetSize( self.pev, Vector( -18, -18, 0 ), Vector( 18, 18, 50 ) );

		self.pev.solid = SOLID_BBOX;
		self.pev.movetype = MOVETYPE_PUSHSTEP;
		self.pev.takedamage = DAMAGE_YES;

		//when classic cam is enabled set the animation so that the powerup is visible from above
		if( blClassicCamEnabled )
		{
			self.pev.angles = Vector( 0, 90, 0 );
			self.pev.sequence = 1;
		}
		else
			self.pev.sequence = 0;
		self.pev.frame = 0;
		self.ResetSequenceInfo();

		self.pev.targetname = "powerup_kick_powerup";

		if( self.pev.health == 0.0f )
			self.pev.health = g_iExplodeDamage;

		self.pev.nextthink = g_Engine.time + 0.1f;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pOther );
		if( pPlayer.IsAlive() && !pPlayer.GetObserver().IsObserver() )
		{
			ClearPoison( pPlayer );
			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_canKick", "1" );
			self.Killed( null, 0 );
			g_SoundSystem.PlaySound( pPlayer.edict(), CHAN_VOICE, "bman/item_get.mp3", 10.0f, 10.0f, 0, PITCH_NORM, pPlayer.entindex(), true, pPlayer.GetOrigin() );
		}
	}
}

class CPowerupFullFire : ScriptBaseAnimating
{
	private float m_flNextTouchTime;

	void Spawn()
	{
		g_EntityFuncs.SetModel( self, g_szPowerupModel );
		self.SetBodygroup( 0, 6 );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		g_EntityFuncs.SetSize( self.pev, Vector( -18, -18, 0 ), Vector( 18, 18, 50 ) );

		self.pev.solid = SOLID_BBOX;
		self.pev.movetype = MOVETYPE_PUSHSTEP;
		self.pev.takedamage = DAMAGE_YES;

		//when classic cam is enabled set the animation so that the powerup is visible from above
		if( blClassicCamEnabled )
		{
			self.pev.angles = Vector( 0, 90, 0 );
			self.pev.sequence = 1;
		}
		else
			self.pev.sequence = 0;
		self.pev.frame = 0;
		self.ResetSequenceInfo();

		self.pev.targetname = "powerup_fullfire_powerup";

		if( self.pev.health == 0.0f )
			self.pev.health = g_iExplodeDamage;

		self.pev.nextthink = g_Engine.time + 0.1f;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pOther );
		if( pPlayer.IsAlive() && !pPlayer.GetObserver().IsObserver() )
		{
			ClearPoison( pPlayer );
			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_fullfire", "1" );
			HudHelp( pPlayer, g_szHelpMsgs[NUKE] );
			self.Killed( null, 0 );
			g_SoundSystem.PlaySound( pPlayer.edict(), CHAN_VOICE, "bman/item_get.mp3", 10.0f, 10.0f, 0, PITCH_NORM, pPlayer.entindex(), true, pPlayer.GetOrigin() );
		}
	}
}

class CPowerupPierce : ScriptBaseAnimating
{
	private float m_flNextTouchTime;

	void Spawn()
	{
		g_EntityFuncs.SetModel( self, g_szPowerupModel );
		self.SetBodygroup( 0, 9 );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		g_EntityFuncs.SetSize( self.pev, Vector( -18, -18, 0 ), Vector( 18, 18, 50 ) );

		self.pev.solid = SOLID_BBOX;
		self.pev.movetype = MOVETYPE_PUSHSTEP;
		self.pev.takedamage = DAMAGE_YES;

		//when classic cam is enabled set the animation so that the powerup is visible from above
		if( blClassicCamEnabled )
		{
			self.pev.angles = Vector( 0, 90, 0 );
			self.pev.sequence = 1;
		}
		else
			self.pev.sequence = 0;
		self.pev.frame = 0;
		self.ResetSequenceInfo();

		self.pev.targetname = "powerup_pierce_powerup";

		if( self.pev.health == 0.0f )
			self.pev.health = g_iExplodeDamage;

		self.pev.nextthink = g_Engine.time + 0.1f;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pOther );
		if( pPlayer.IsAlive() && !pPlayer.GetObserver().IsObserver() )
		{
			ClearPoison( pPlayer );
			CustomKeyvalues@ kvPlayer = pPlayer.GetCustomKeyvalues();
			if( atobool( kvPlayer.GetKeyvalue( "$s_remote" ).GetString() ) )
				g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_remote", "false" );

			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_pierce", "true" );
			self.Killed( null, 0 );
		}
		g_SoundSystem.PlaySound( pPlayer.edict(), CHAN_VOICE, "bman/item_get.mp3", 10.0f, 10.0f, 0, PITCH_NORM, pPlayer.entindex(), true, pPlayer.GetOrigin() );
		self.pev.nextthink = g_Engine.time + 0.1f;
	}
}

class CPowerupBounce : ScriptBaseAnimating
{
	private float m_flNextTouchTime;

	void Spawn()
	{
		g_EntityFuncs.SetModel( self, g_szPowerupModel );
		self.SetBodygroup( 0, 3 );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		g_EntityFuncs.SetSize( self.pev, Vector( -18, -18, 0 ), Vector( 18, 18, 50 ) );

		self.pev.solid = SOLID_BBOX;
		self.pev.movetype = MOVETYPE_PUSHSTEP;
		self.pev.takedamage = DAMAGE_YES;

		//when classic cam is enabled set the animation so that the powerup is visible from above
		if( blClassicCamEnabled )
		{
			self.pev.angles = Vector( 0, 90, 0 );
			self.pev.sequence = 1;
		}
		else
			self.pev.sequence = 0;
		self.pev.frame = 0;
		self.ResetSequenceInfo();

		self.pev.targetname = "powerup_bounce_powerup";

		if( self.pev.health == 0.0f )
			self.pev.health = g_iExplodeDamage;

		self.pev.nextthink = g_Engine.time + 0.1f;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pOther );
		if( pPlayer.IsAlive() && !pPlayer.GetObserver().IsObserver() )
		{
			ClearPoison( pPlayer );
			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_bounce", "true" );
			self.Killed( null, 0 );
		}
		g_SoundSystem.PlaySound( pPlayer.edict(), CHAN_VOICE, "bman/item_get.mp3", 10.0f, 10.0f, 0, PITCH_NORM, pPlayer.entindex(), true, pPlayer.GetOrigin() );
		self.pev.nextthink = g_Engine.time + 0.1f;
	}
}

class CPowerupRemote : ScriptBaseAnimating
{
	private float m_flNextTouchTime;

	void Spawn()
	{
		g_EntityFuncs.SetModel( self, g_szPowerupModel );
		self.SetBodygroup( 0, 12 );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		g_EntityFuncs.SetSize( self.pev, Vector( -18, -18, 0 ), Vector( 18, 18, 50 ) );

		self.pev.solid = SOLID_BBOX;
		self.pev.movetype = MOVETYPE_PUSHSTEP;
		self.pev.takedamage = DAMAGE_YES;

		//when classic cam is enabled set the animation so that the powerup is visible from above
		if( blClassicCamEnabled )
		{
			self.pev.angles = Vector( 0, 90, 0 );
			self.pev.sequence = 1;
		}
		else
			self.pev.sequence = 0;
		self.pev.frame = 0;
		self.ResetSequenceInfo();

		self.pev.targetname = "powerup_remote_powerup";

		if( self.pev.health == 0.0f )
			self.pev.health = g_iExplodeDamage;

		self.pev.nextthink = g_Engine.time + 0.1f;
	}

	void Touch( CBaseEntity@ pOther )
	{
		if( pOther is null || !pOther.IsPlayer() )
			return;

		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pOther );
		if( pPlayer.IsAlive() && !pPlayer.GetObserver().IsObserver() )
		{
			ClearPoison( pPlayer );
			HudHelp( pPlayer, g_szHelpMsgs[REMOTE] );
			CustomKeyvalues@ kvPlayer = pPlayer.GetCustomKeyvalues();
			if( atobool( kvPlayer.GetKeyvalue( "$s_pierce" ).GetString() ) )
				g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_pierce", "false" );

			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_remote", "true" );
			self.Killed( null, 0 );
		}
		g_SoundSystem.PlaySound( pPlayer.edict(), CHAN_VOICE, "bman/item_get.mp3", 10.0f, 10.0f, 0, PITCH_NORM, pPlayer.entindex(), true, pPlayer.GetOrigin() );
		self.pev.nextthink = g_Engine.time + 0.1f;
	}
}

void HudHelp( EHandle hPlayer, string szMessage )
{
	if( !hPlayer )
		return;

	CBasePlayer@ pPlayer = cast<CBasePlayer@>( hPlayer.GetEntity() );

	HUDTextParams PowerupHudText;
	PowerupHudText.x = -1;
	PowerupHudText.y = 0.7;
	PowerupHudText.effect = 0;
	PowerupHudText.r1 = 255;
	PowerupHudText.g1 = 100;
	PowerupHudText.b1 = 100;
	PowerupHudText.a1 = 0;
	PowerupHudText.r2 = 255;
	PowerupHudText.g2 = 100;
	PowerupHudText.b2 = 100;
	PowerupHudText.a2 = 0;
	PowerupHudText.fadeinTime = 0;
	PowerupHudText.fadeoutTime = 1;
	PowerupHudText.holdTime = 10;
	PowerupHudText.fxTime = 0;
	PowerupHudText.channel = 2;

	g_PlayerFuncs.HudMessage( pPlayer, PowerupHudText, szMessage );

}