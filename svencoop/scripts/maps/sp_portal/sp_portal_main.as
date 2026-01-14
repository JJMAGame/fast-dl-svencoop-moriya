bool MapInitCheck = true;
int StatHL = 0;
int StatUL = 0;
int StatOF = 0;
int StatBS = 0;
int StatTH = 0;

#include "sp_check"
#include "cvars"

#include "../HLSPClassicMode"
#include "entities/xen_plantlight_switch"


void MapInit()
{
	ClassicModeMapInit();
	plantlight_switch::Register();

	//Precaching Sounds and Models (and Sprites) not in the .bsp. Would cause a crash otherwise!
	g_SoundSystem.PrecacheSound("sp_portal/NA0.wav");
	g_SoundSystem.PrecacheSound("sp_portal/NA2.wav");
	g_SoundSystem.PrecacheSound("sp_portal/NA3.wav");
	g_SoundSystem.PrecacheSound("ambience/zapmachine.wav");

	g_Game.PrecacheModel("sprites/tele1.spr");

	g_SoundSystem.PrecacheSound("buttons/blip1.wav");
	g_SoundSystem.PrecacheSound("buttons/latchunlocked2.wav");
	g_SoundSystem.PrecacheSound("buttons/latchunlocked1.wav");
	g_SoundSystem.PrecacheSound("scientist/weartie.wav");
	g_SoundSystem.PrecacheSound("scientist/c1a2_sci_darkroom.wav");
}

void MapStart()
{
	//Perform SP Campaign Install check. see sp_check.as
	InitCheck();
}


void ReadGameZone(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{

	Vector originof = Vector(0,0,0);// initiate the origin variable.
	string gzp_TName = pCaller.GetTargetname(); // Fetch targetname of the caller.
	string gzp_Start = gzp_TName.SubString(0, gzp_TName.Length() - 3);//cut the last three characters. Required for later Entity triggering


	// check if the last three characters are gzp and if the caller is a game_zone_player.
	//Important for further processing. Should always the case as the game_zone triggers all this and the script requires the player count.
	if ((gzp_TName.SubString(gzp_TName.Length()-3, gzp_TName.Length()) == "gzp") && (pCaller.GetClassname() == "game_zone_player"))
	{

		// Then get the origin of the env_xenmaker. Used for sprite and sounds.
		string gzp_EntName = gzp_Start + "pb";
		CBaseEntity@ EdictForSounds = null;
		CBaseEntity@ entity = null;
		@entity = g_EntityFuncs.FindEntityByTargetname(null, gzp_EntName);
		if (entity !is null)
		{
			@EdictForSounds = @entity;
			originof = entity.pev.origin;
		}

		// If the player count from the game_zone_player is 2, do the following stuff
		if (flValue == 2)
		{
			//Trigger fancy effect using env_xenmaker and create teleporter sprite and a sound, at the origin of the xenmaker
			g_EntityFuncs.FireTargets(gzp_EntName,pActivator,pCaller,USE_ON,0.0f, 0.0f);
			g_EntityFuncs.FireTargets(gzp_EntName,pActivator,pCaller,USE_ON,0.0f, 10.0f);

			//make the sprite and set timer to switch it off. The entity goes into an EHandle, that way dangling pointers (crash!) are prevented.
			CSprite@ telebeam = g_EntityFuncs.CreateSprite("sprites/tele1.spr", originof, true);
			telebeam.SetTransparency(5,0,0,0,255,0);

			if (gzp_Start.SubString(0,5) == "th_ep") telebeam.SetScale(1.0f);
			else telebeam.SetScale(0.25f);

			g_Scheduler.SetTimeout("Sprite_Off", 10, EHandle(telebeam));

			//play the sound and set timer to switch it off.
			g_SoundSystem.PlaySound(entity.edict(), CHAN_STATIC, "ambience/zapmachine.wav",0.6f, 1.0f, 1,100,1, true, originof);
			g_Scheduler.SetTimeout("snd_Stop", 10, EHandle(entity), "ambience/zapmachine.wav");


			// Lock and unlock Buttons using a multisource and trigger_relay
			gzp_EntName = gzp_Start + "butt_onrel";
			@entity = null;
			@entity = g_EntityFuncs.FindEntityByTargetname(null, gzp_EntName);
			if (entity !is null)
			{
				g_EntityFuncs.FireTargets(gzp_EntName,pActivator,pCaller,USE_TOGGLE,0.0f, 0.0f);
				g_EntityFuncs.FireTargets(gzp_EntName,pActivator,pCaller,USE_TOGGLE,0.0f, 10.0f);
			}

			//enable trigger_once for level change (like lock/unlock buttons)
			gzp_EntName = gzp_Start + "ptr";
			@entity = null;
			@entity = g_EntityFuncs.FindEntityByTargetname(null, gzp_EntName);
			if (entity !is null)
			{
				g_EntityFuncs.FireTargets(gzp_EntName,pActivator,pCaller,USE_TOGGLE,0.0f, 0.0f);
				g_EntityFuncs.FireTargets(gzp_EntName,pActivator,pCaller,USE_TOGGLE,0.0f, 10.0f);
			}
		}
		else
		// if the player count is anything but 2, do this. Play a random access denied sound
		{
			if (EdictForSounds !is null)
			{
				switch (Math.RandomLong(1,3))
				{
					case 1:
							g_SoundSystem.PlaySound(EdictForSounds.edict(), CHAN_STATIC, "sp_portal/NA0.wav",0.5f, 1.0f, 1,100,1, true, originof);
					break;

					case 2:
							g_SoundSystem.PlaySound(EdictForSounds.edict(), CHAN_STATIC, "sp_portal/NA2.wav",0.5f, 1.0f, 1,100,1, true, originof);
					break;

					case 3:
							g_SoundSystem.PlaySound(EdictForSounds.edict(), CHAN_STATIC, "sp_portal/NA3.wav",0.5f, 1.0f, 1,100,1, true, originof);
					break;

					default:
							g_Game.AlertMessage(at_console, "Random 'Access Denied' Message: SWITCH CASE-- DEFAULT.\n This message should never happen.\n");
				}
			}
		}
	}
	else
	{
		g_Game.AlertMessage(at_console, "ReadGameZone: last three characters NOT gzp\n This message should never happen.\n");
		dsplmsg("game_zone_player (" + gzp_TName + "): Not properly named or not a game_zone_player.\nIf this happens frequently,\nask the Server Admin if this Version is modified.", 5.0f);
	}
}

void snd_Stop(EHandle&in myEntityHandle, string&in myFilename)
{
	CBaseEntity@ myEntity = null;
	@myEntity = myEntityHandle.GetEntity();
	if (myEntity !is null)
	{
		g_SoundSystem.StopSound(myEntity.edict(), CHAN_STATIC, myFilename);
	}
	//else
	//{
	//	g_Game.AlertMessage(at_console,"myEntity is null O_o'\n");
	//}
}

void Sprite_Off(EHandle&in mySpriteHandle)
{
	CBaseEntity@ mySprite = null;
	@mySprite = mySpriteHandle.GetEntity();
	if (mySprite !is null)
	{
		g_EntityFuncs.Remove(mySprite);
	}
	//else
	//{
	//	g_Game.AlertMessage(at_console,"mySprite is null O_o'\n");
	//}
}


// sends a message all players
// Technically, this is a game_text
void dsplmsg(string&in msg,float htime)
{
	HUDTextParams txtPrms;

	txtPrms.x = -1;	// Position X
	txtPrms.y = -1; // Position Y
	txtPrms.effect = 0; // Effect

	//Text colour
	txtPrms.r1 = 100; // Amount of red
	txtPrms.g1 = 100; // Amount of green
	txtPrms.b1 = 100; // Amount of blue
	txtPrms.a1 = 100; // Alpha Amount

	//fade-in colour
	txtPrms.r2 = 240;
	txtPrms.g2 = 110;
	txtPrms.b2 = 0;
	txtPrms.a2 = 0;

	//Do I really have to explain "FadeInTime" or "HoltTime"?!
	txtPrms.fadeinTime = 0.01f;
	txtPrms.fadeoutTime = 1.5f;
	txtPrms.holdTime = htime;
	txtPrms.fxTime = 0.25f;
	txtPrms.channel = 1;

	g_PlayerFuncs.HudMessageAll(txtPrms, msg); // send the message!

}

void ClassicModeCheckLoop()
{
	if (g_ClassicMode.IsEnabled())
	{
		g_EntityFuncs.FireTargets("fw_clscmd_off", null, null, USE_OFF, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("fw_clscmd_on", null, null, USE_ON, 0.0f, 1.0f);
		//g_Game.AlertMessage(at_console, "Classic Mode Loop: ON\n");
	}
	else if (!g_ClassicMode.IsEnabled())
	{
		g_EntityFuncs.FireTargets("fw_clscmd_off", null, null, USE_ON, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("fw_clscmd_on", null, null, USE_OFF, 0.0f, 1.0f);
		//g_Game.AlertMessage(at_console, "Classic Mode Loop: OFF\n");
	}
	g_Scheduler.SetTimeout("ClassicModeCheckLoop", 5.0f);
}

void bs_locked(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if ((StatBS == 1) && (spcp_bshift.GetInt() == -1))
	{
		dsplmsg("Sorry, Blue Shift Campaign is not installed on this Server.", 5.0f);
	}
	else if ((spcp_bshift.GetInt() == 0) || (spcp_bshift.GetInt() == -1))
	{
		dsplmsg("Sorry, Blue Shift Campaign is deactivated by the Server Admin via CVar.", 5.0f);
	}
}

void hl_locked(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if ((StatHL == 1) && (spcp_hlsp.GetInt() == -1))
	{
		dsplmsg("Sorry, Half-Life Campaign is not installed on this Server.", 5.0f);
	}
	else if ((spcp_hlsp.GetInt() == 0) || (spcp_hlsp.GetInt() == -1))
	{
		dsplmsg("Sorry, Half-Life Campaign is deactivated by the Server Admin via CVar.", 5.0f);
	}
}

void of_locked(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if ((StatOF == 1) && (spcp_opfor.GetInt() == -1))
	{
		dsplmsg("Sorry, Opposing Force Campaign is not installed on this Server.", 5.0f);
	}
	else if ((spcp_opfor.GetInt() == 0) || (spcp_opfor.GetInt() == -1))
	{
		dsplmsg("Sorry, Opposing Force Campaign is deactivated by the Server Admin via CVar.", 5.0f);
	}
}

void ul_locked(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if ((StatUL == 1) && (spcp_uplink.GetInt() == -1))
	{
		dsplmsg("Sorry, Uplink Campaign is not installed on this Server.", 5.0f);
	}
	else if ((spcp_uplink.GetInt() == 0) || (spcp_uplink.GetInt() == -1))
	{
		dsplmsg("Sorry, Uplink Campaign is deactivated by the Server Admin via CVar.", 5.0f);
	}
}

void theyhunger_locked(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if ((StatTH == 1) && (spcp_theyhunger.GetInt() == -1))
	{
		dsplmsg("Sorry, They Hunger Campaign is not installed on this Server.", 5.0f);
	}
	else if ((spcp_theyhunger.GetInt() == 0) || (spcp_theyhunger.GetInt() == -1))
	{
		dsplmsg("Sorry, They Hunger Campaign is deactivated by the Server Admin via CVar.", 5.0f);
	}
}