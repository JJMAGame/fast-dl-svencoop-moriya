void ApplyEntityGlowShell(CBaseEntity@ ent)
{
	ent.pev.renderfx = 19; // Glow shell
	ent.pev.renderamt = 2;
	ent.pev.rendercolor.x = 190;
	ent.pev.rendercolor.y = 140;
	ent.pev.rendercolor.z = 10;
}

void MarkAmmo(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	const int flagNoRespawn = 1024; // Disable respawn spawnflag
	
	CBaseEntity@ ent = null;
	while ( ( @ent = g_EntityFuncs.FindEntityByClassname(@ent, "ammo_*") ) !is null )
	{
		if ((ent.pev.spawnflags & flagNoRespawn) != 0)
		{
			// Does not respawn.
			ApplyEntityGlowShell(ent);
		}
	}
	
	while ( ( @ent = g_EntityFuncs.FindEntityByClassname(@ent, "weapon_*") ) !is null )
	{
		if ((ent.pev.spawnflags & flagNoRespawn) != 0)
		{
			// Does not respawn.
			ApplyEntityGlowShell(ent);
		}
	}
	
	while ( ( @ent = g_EntityFuncs.FindEntityByClassname(@ent, "item_*") ) !is null )
	{
		if (ent.pev.classname != "item_inventory")
		{
			if ((ent.pev.spawnflags & flagNoRespawn) != 0)
			{
				// Does not respawn.
				ApplyEntityGlowShell(ent);
			}
		}
	}
}
