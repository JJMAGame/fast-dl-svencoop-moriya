/*
* trigger_look
* Originally meant for jpolito's theyhunger map, now recycled in serious sven!
*
* Author: Zode
* Modified by: Tomas "GeckoN" Slavotinek
*/

namespace TriggerLook
{

const string ENTITY_NAME = "trigger_look";

class CTriggerLook : ScriptBaseEntity
{
	float fDifference = 16.0f;
	int iTriggerMode = 0;
	int iInverse = 0;
	float fCheckDelay = 1.0f;
	array<int> toucherList;
	
	void Spawn()
	{
		self.pev.solid = SOLID_TRIGGER;
		self.pev.movetype = MOVETYPE_NONE;
		g_EntityFuncs.SetModel(self, self.pev.model);
		g_EntityFuncs.SetSize(self.pev, self.pev.mins, self.pev.maxs);
		g_EntityFuncs.SetOrigin(self, self.pev.origin);
		SetTouch(TouchFunction(this.LookTouch));
		self.pev.nextthink = g_Engine.time;
	}
	
	bool KeyValue(const string &in szKey, const string &in szValue)
	{
		if(szKey == "difference") // angle threshold
		{
			fDifference = atof(szValue);
			return true;
		}
		else if(szKey == "trigger") // 0 -- not looking at, 1 -- looking at
		{
			iTriggerMode = atoi(szValue);
			return true; 
		}
		else if(szKey == "delaychecks") // delay between checks
		{
			fCheckDelay = atof(szValue);
			return true;
		}
		else if(szKey == "inverse")
		{
			iInverse = atoi(szValue);
			return true;
		}
		else
			return BaseClass.KeyValue(szKey, szValue);
	}
	
	void LookTouch(CBaseEntity@ pOther)
	{
		if(!pOther.IsPlayer()) // dont even attempt other entities
			return;
		//check if the user is already touching
		if(toucherList.length() > 0)
			for(uint i = 0; i < toucherList.length(); i++)
			{
				CBaseEntity@ pCheck = g_EntityFuncs.Instance(toucherList[i]);
				if(pCheck is null)
					continue;
				if(g_EntityFuncs.EntIndex(pCheck.edict()) == g_EntityFuncs.EntIndex(pOther.edict()))
					return;
			}
		else
			self.pev.nextthink = g_Engine.time;
			
		toucherList.insertLast(g_EntityFuncs.EntIndex(pOther.edict()));
		SetThink(ThinkFunction(this.LookThink)); // start checking for angles	
		
	}

	void LookThink()
	{
		if(toucherList.length() <= 0)
		{
			USE_TYPE useType = (iInverse == 0) ? USE_OFF : USE_ON;
			g_EntityFuncs.FireTargets(self.pev.target, cast<CBaseEntity@>(this), cast<CBaseEntity@>(this), useType, 0.0f, 0.0f);
			
			self.pev.nextthink = g_Engine.time+0.05f;
			SetThink(null);
			return;
		}

		array<int> toRemove;
		bool bCanUse = false;
		bool bUseLock = false;
		for(uint i = 0; i < toucherList.length(); i++)
		{
			CBaseEntity@ pCheck = g_EntityFuncs.Instance(toucherList[i]);
			if(pCheck is null)
			{
				toRemove.insertLast(i);
				continue;
			}
			
			if(!self.Intersects(pCheck))
			{
				// not touching anymore
				toRemove.insertLast(i);
				continue;
			}
			else
			{
				if(angledifference(pCheck.pev.angles, fDifference))
				{
					if(iTriggerMode == 0)
						bCanUse = true;
					else
					{
						bCanUse = false;
						bUseLock = true;
					}
				}
				else
				{
					if(iTriggerMode == 1)
						bCanUse = true;
					else
					{
						bCanUse = false;
						bUseLock = true;
					}
				}
			}
		}
		
		USE_TYPE useType;
		if(bCanUse && !bUseLock)
			useType = (iInverse == 0) ? USE_ON : USE_OFF;
		else
			useType = (iInverse == 0) ? USE_OFF : USE_ON;
			
		g_EntityFuncs.FireTargets(self.pev.target, cast<CBaseEntity@>(this), cast<CBaseEntity@>(this), useType, 0.0f, 0.0f);
		
		if(toRemove.length() > 0)
		{
			for(uint i = 0; i < toRemove.length(); i++)
				toucherList.removeAt(toRemove[i]);
		}
		
		self.pev.nextthink = g_Engine.time+fCheckDelay;
	}
	
	bool angledifference(Vector vVec, float fComp)
	{ 
		//g_Game.AlertMessage(at_logged, "trigger_look checking difference\n");
		//g_Game.AlertMessage(at_logged, "fMaxDifference "+string(fComp)+"\n");
		float fVec = Math.AngleMod(vVec.y); // -180 to 180
		//g_Game.AlertMessage(at_logged, "player angles "+string(fVec)+"\n");
		float fVec2 = Math.AngleMod(self.pev.angles.y);
		//g_Game.AlertMessage(at_logged, "self angles "+string(fVec2)+"\n");
		
		float fDiff = Math.AngleDiff(fVec2, fVec);
		//g_Game.AlertMessage(at_logged, "angle difference "+string(fDiff)+"\n");
		float fAbs = abs(fDiff);
		//g_Game.AlertMessage(at_logged, "absolute "+string(fAbs)+"\n");
		if(fAbs < fComp)
		{
			//g_Game.AlertMessage(at_logged, "fAbs < fComp return false\n");
			return false;
		}
		
		//g_Game.AlertMessage(at_logged, "fAbs > fComp return true\n");
		return true;
	}
}

void Register()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "TriggerLook::CTriggerLook", ENTITY_NAME );
}

} // end of namespace
