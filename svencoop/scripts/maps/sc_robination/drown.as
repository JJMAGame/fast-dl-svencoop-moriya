#include "customkv"

void DrownMonsters(CBaseEntity@ pTriggerScript)
{
	float minX = GetCustomFloat(pTriggerScript, "$f_min_x");
	float maxX = GetCustomFloat(pTriggerScript, "$f_max_x");
	float minY = GetCustomFloat(pTriggerScript, "$f_min_y");
	float maxY = GetCustomFloat(pTriggerScript, "$f_max_y");
	
	edict_t@ worldspawn = g_EntityFuncs.IndexEnt(0);
	
	CBaseEntity@ ent = null;
	while ( ( @ent = g_EntityFuncs.FindEntityByClassname(ent, "monster_*") ) !is null )
	{
		if ( ent.pev.deadflag != 0)
			continue;
		
		Vector o = ent.pev.origin - pTriggerScript.pev.origin;
		if (o.z < 0.0f)
		{
			// Below water level
			if (o.x > minX && o.x < maxX && o.y > minY && o.y < maxY)
			{
				if (ent.pev.classname != "monster_ichthyosaur")
				{
					ent.TakeDamage(worldspawn.vars, worldspawn.vars, 30, 16384);
				}
			}
		}
	}
}
