// The simple Xen plantlight, modified. a lot. really.
// Author: Puchi
// thanks for help goes to: H2Whoa, GeckonCZ, Zode, Nero, KernCore, W00tguy


namespace plantlight_switch
{
	class xen_plantlight_switch : ScriptBaseAnimating
	{
		string 	DeploySound;
		string	RetractSound;
		string	PlantModel			= "models/light.mdl";
		string	PlantSprite			= "sprites/flare3.spr";

		float 	HideTime			= 3.0f;
		float	RetractVolume		= 1.0f;
		float	DeployVolume		= 1.0f;
		float	Attenuation			= 2.5f;
		float	Sprite_Scale		= 0.5f;

		int		Sprite_RenderMode 	= 3;
		int		Sprite_RenderAmount	= 128;
		int		Sprite_RenderFX 	= 0;
		int		SF_SHOWSPRITE		= 0x01;
		int		SF_ISANIMATED		= 0x02;
		int		SF_NOFIREONRETRACT	= 0x04;
		int		SF_NOFIREONDEPLOY	= 0x08;

		Vector	MinHullSize			= Vector(-80,-80,0);
		Vector 	MaxHullSize			= Vector(80,80,32);
		Vector	CustomOrigin		= Vector(0,0,0);
		Vector	Sprite_FXColor		= Vector(0,0,0);

		bool 	TriggerOnHide		= false;
		bool	UseTypeMode			= false;
		bool	Sprite_ToggleMode	= false;
		bool	NoFireOnRetract		= false;
		bool	NoFireOnDeploy		= false;

		CSprite@ PlantGlow;

		bool KeyValue( const string& in szKey, const string& in szValue )
		{
			if (szKey == "HullMin")
			{
				g_Utility.StringToVector(MinHullSize,szValue);
				return true;
			}

			else if(szKey == "HullMax")
			{
				g_Utility.StringToVector(MaxHullSize,szValue);
				return true;
			}

			else if(szKey == "htime")
			{
				HideTime = atof(szValue);
				return true;
			}

			else if (szKey == "triggermode")
			{
				if (atoi(szValue) == 1)
				{
					TriggerOnHide = true;
				}
				return true;
			}

			else if (szKey == "usetypemode")
			{
				if (atoi(szValue) == 1)
				{
					UseTypeMode = true;
				}
				return true;
			}

			else if (szKey == "deploysnd")
			{
				DeploySound = szValue;
				return true;
			}

			else if (szKey == "retractsnd")
			{
				RetractSound = szValue;
				return true;
			}

			else if (szKey == "originEnt")
			{

				if (szValue.IsEmpty()) CustomOrigin = self.pev.origin;
				if (!szValue.IsEmpty())//due to the nature of entities and the game, the origin entity has to be put into the level BEFORE the plant. Hence a fallback.
				{
					CBaseEntity@ entity = null;
					@entity = g_EntityFuncs.FindEntityByTargetname(null, szValue);
					if (entity !is null)
					{
						CustomOrigin = entity.pev.origin;
					}
					else
					{
						CustomOrigin = self.pev.origin;
					}
				}
				return true;
			}

			else if (szKey == "retractvol")
			{
				RetractVolume = Math.clamp(0.0f, 1.0f, atof(szValue));
				return true;
			}

			else if (szKey == "deployvol")
			{
				DeployVolume = Math.clamp(0.0f, 1.0f, atof(szValue));
				return true;
			}

			else if (szKey == "sndattn")
			{
				Attenuation = Math.clamp(0.0f,4.0f,atof(szValue));
				return true;
			}

			else if (szKey == "model")
			{
				PlantModel = szValue;
				return true;
			}

			else if (szKey == "sprite_model")
			{
				PlantSprite = szValue;
				return true;
			}

			else if (szKey == "sprite_renderfx")
			{
				Sprite_RenderFX = atoi(szValue);
				return true;
			}

			else if (szKey == "sprite_rendermode")
			{
				Sprite_RenderMode = atoi(szValue);
				return true;
			}

			else if (szKey == "sprite_renderamt")
			{
				Sprite_RenderAmount = atoi(szValue);
				return true;
			}

			else if (szKey == "sprite_rendercolor")
			{
				g_Utility.StringToVector(Sprite_FXColor,szValue);
				return true;
			}

			else if (szKey == "sprite_scale")
			{
				Sprite_Scale = atof(szValue);
				return true;
			}

			else if (szKey == "sprite_togglemode")
			{
				if (atoi(szValue) == 1)
				{
					Sprite_ToggleMode = true;
				}
				return true;
			}

			else
			{
				return BaseClass.KeyValue( szKey, szValue );
			}

		} // end KeyValue

		void Spawn( void )
		{
			Precache();

			pev.solid = SOLID_TRIGGER;
			pev.movetype = MOVETYPE_NONE;

			if(string(self.pev.model).IsEmpty()) g_EntityFuncs.SetModel(self, PlantModel);
			else g_EntityFuncs.SetModel(self, self.pev.model);

			g_EntityFuncs.SetOrigin(self, self.pev.origin);
			g_EntityFuncs.SetSize(self.pev, MinHullSize, MaxHullSize);

			pev.framerate = 1.0;

			pev.frame = 0;
			pev.sequence = 0; // set sequence "idle"
			self.ResetSequenceInfo();

			self.pev.nextthink = g_Engine.time + 0.1;
			self.pev.frame = Math.RandomLong(0,255);

			bool SpriteIsAnimated = false;
			if ((pev.spawnflags & SF_ISANIMATED) != 0) SpriteIsAnimated = true;

			if ((pev.spawnflags & SF_SHOWSPRITE) == 0)
			{
				@PlantGlow = g_EntityFuncs.CreateSprite(PlantSprite, self.pev.origin + Vector(0,0,(MinHullSize.z + MaxHullSize.z)*0.5), SpriteIsAnimated);
				PlantGlow.SetTransparency(Sprite_RenderMode, int(Sprite_FXColor.x), int(Sprite_FXColor.y), int(Sprite_FXColor.z), int(Sprite_RenderAmount), int(Sprite_RenderFX));
				PlantGlow.SetScale(Sprite_Scale);
				PlantGlow.SetAttachment(self.edict(), self.GetAttachmentCount());

				if (Sprite_ToggleMode) PlantGlow.TurnOff();
				else  PlantGlow.TurnOn();
			}

			if ((pev.spawnflags & SF_NOFIREONRETRACT) != 0) NoFireOnRetract = true;
			if ((pev.spawnflags & SF_NOFIREONDEPLOY) != 0) NoFireOnDeploy = true;




		}// end spawn


		void Precache( void )
		{
			BaseClass.Precache();
			if( string(self.pev.model).IsEmpty() )
			{
				g_Game.PrecacheModel(PlantModel);
			}
			g_Game.PrecacheModel(PlantSprite);
			if (!DeploySound.IsEmpty()) g_SoundSystem.PrecacheSound(DeploySound);
			if (!RetractSound.IsEmpty()) g_SoundSystem.PrecacheSound(RetractSound);
		}// end precache


		void Touch(CBaseEntity@ pOther)
		{
			if (pOther.IsPlayer())
			{
				self.pev.dmgtime = g_Engine.time + HideTime;
				if ((pev.sequence == 0) || (pev.sequence == 2))
				{
					pev.frame = 0;
					pev.sequence = 1; // set sequence "retract"
					self.ResetSequenceInfo();

					if (TriggerOnHide)
					{
						if (!RetractSound.IsEmpty()) g_SoundSystem.PlaySound(self.edict(), CHAN_STATIC, RetractSound, RetractVolume, Attenuation, 1,100,1, true, CustomOrigin);

						if (!NoFireOnRetract) {
							if (UseTypeMode) self.SUB_UseTargets( @self, USE_ON, 0);
							else self.SUB_UseTargets(@self, USE_OFF,0);
						}

						if (((pev.spawnflags & SF_SHOWSPRITE) == 0) && (Sprite_ToggleMode)) PlantGlow.TurnOn();
						else if (((pev.spawnflags & SF_SHOWSPRITE) == 0) && (!Sprite_ToggleMode)) PlantGlow.TurnOff();
					}
				}
			}
		}// ent touch


		void Think()
		{
			self.pev.nextthink = g_Engine.time + 0.1;

			self.StudioFrameAdvance();
			switch (pev.sequence)
			{
				case 1: // Plant retracts ("ACT_CROUCH")
					if (self.m_fSequenceFinished)
					{
						pev.frame = 0;
						pev.sequence = 3; // set sequence "hide"
						self.ResetSequenceInfo();

						if (!TriggerOnHide)
						{
							if (!RetractSound.IsEmpty()) g_SoundSystem.PlaySound(self.edict(), CHAN_STATIC, RetractSound,RetractVolume, Attenuation, 1,100,1, true, CustomOrigin);

							if (!NoFireOnRetract)
							{
								if (UseTypeMode) self.SUB_UseTargets( @self, USE_ON, 0);
								else self.SUB_UseTargets(@self, USE_OFF,0);
						  	}

							if (((pev.spawnflags & SF_SHOWSPRITE) == 0) && (Sprite_ToggleMode)) PlantGlow.TurnOn();
							else if (((pev.spawnflags & SF_SHOWSPRITE) == 0) && (!Sprite_ToggleMode)) PlantGlow.TurnOff();
						}
					}
				break;

				case 2: //popping up when noone is near! ("ACT_STAND")
					if (self.m_fSequenceFinished)
					{
						pev.frame = 0;
						pev.sequence = 0; // set sequence "idle"
						self.ResetSequenceInfo();
					}
				break;

				case 3: // when the plant is hidden (and noone near) ("ACT_CROUCHIDLE")
					if (g_Engine.time > self.pev.dmgtime)
					{
						pev.frame = 0;
						pev.sequence = 2; // set sequence "deploy"
						self.ResetSequenceInfo();

						if (!DeploySound.IsEmpty()) g_SoundSystem.PlaySound(self.edict(), CHAN_STATIC, DeploySound,DeployVolume, Attenuation, 1,100,1, true, CustomOrigin);

						if (!NoFireOnDeploy)
						{
							if (UseTypeMode) self.SUB_UseTargets( @self, USE_OFF, 0);
							else self.SUB_UseTargets(@self, USE_ON,0);
						}

						if (((pev.spawnflags & SF_SHOWSPRITE) == 0) && (Sprite_ToggleMode)) PlantGlow.TurnOff();
						else if (((pev.spawnflags & SF_SHOWSPRITE) == 0) && (!Sprite_ToggleMode)) PlantGlow.TurnOn();
					}
				break;

				case 0:
				default:
				break;
			}// end switch
		}// end think
	} // End class

	void Register()
	{
		g_CustomEntityFuncs.RegisterCustomEntity( "plantlight_switch::xen_plantlight_switch", "xen_plantlight_switch" );
	}
}// end namespace