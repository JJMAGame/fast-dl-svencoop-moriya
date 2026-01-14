void BoltLocks_HLDoor(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	//searches for the custom KeyValue "$s_door" in all func_door.
	//if found and content is "HLDOOR", pass to BoltLocks_HLLoop.
	CBaseEntity@ FoundADoor = @g_EntityFuncs.FindEntityByClassname(FoundADoor, "func_door");

	while (FoundADoor !is null) // run this until "FoundDoor" returns null (no more entities)
	{
		CustomKeyvalues@ pCustom = FoundADoor.GetCustomKeyvalues();
		CustomKeyvalue KVal_Door(pCustom.GetKeyvalue("$s_door"));

		if (KVal_Door.GetString() == "HLDOOR")
		{
			g_Game.AlertMessage(at_console, "Found a door with KeyValue %1!\n", KVal_Door.GetString());
			g_EntityFuncs.FireTargets("hl_lock1_setorigin", null, null, USE_ON, 0.0f, 0.0f);
			g_EntityFuncs.FireTargets("hl_lock2_setorigin", null, null, USE_ON, 0.0f, 0.0f);
			BoltLocks_HLLoop(EHandle(FoundADoor));
			break;
		}

		@FoundADoor = @g_EntityFuncs.FindEntityByClassname(FoundADoor, "func_door"); // pick the next func_door and check
	}
}

void BoltLocks_HLLoop(EHandle&in SavedDoor)
{
	CBaseToggle@ HLRandDoor = cast<CBaseToggle@>(SavedDoor.GetEntity()); //cast to CBaseToggle@ so we can use the Toggle Entity references
	if (HLRandDoor !is null)
	{
		g_Game.AlertMessage(at_console,"Locked by Master: %1, Toggle State: %2\n",HLRandDoor.IsToggleLockedByMaster(), HLRandDoor.m_toggle_state);

		if ((HLRandDoor.IsToggleLockedByMaster()) && (HLRandDoor.m_toggle_state == TS_AT_BOTTOM)) // if door is locked by the master AND "at bottom", continue. else start to check again.
		{
			g_EntityFuncs.FireTargets("hl_lock1_lock", null, null, USE_TOGGLE, 0.0f, 0.0f);
			g_EntityFuncs.FireTargets("hl_lock2_lock", null, null, USE_TOGGLE, 0.0f, 0.5f);
		}
		else
		{
			g_Scheduler.SetTimeout("BoltLocks_HLLoop", 0.5f, EHandle(HLRandDoor));
		}
	}
}

void BoltLocks_OFDoor(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{

	CBaseEntity@ FoundADoor = @g_EntityFuncs.FindEntityByClassname(FoundADoor, "func_door");

	while (FoundADoor !is null)
	{
		CustomKeyvalues@ pCustom = FoundADoor.GetCustomKeyvalues();
		CustomKeyvalue KVal_Door(pCustom.GetKeyvalue("$s_door"));

		if (KVal_Door.GetString() == "OFDOOR")
		{
			g_Game.AlertMessage(at_console, "Found a door with KeyValue %1!\n", KVal_Door.GetString());
			g_EntityFuncs.FireTargets("of_lock1_setorigin", null, null, USE_ON, 0.0f, 0.0f);
			g_EntityFuncs.FireTargets("of_lock2_setorigin", null, null, USE_ON, 0.0f, 0.0f);
			BoltLocks_OFLoop(EHandle(FoundADoor));
			break;
		}

		@FoundADoor = @g_EntityFuncs.FindEntityByClassname(FoundADoor, "func_door");
	}
}

void BoltLocks_OFLoop(EHandle&in SavedDoor)
{
	CBaseToggle@ OFRandDoor = cast<CBaseToggle@>(SavedDoor.GetEntity());
	if (OFRandDoor !is null)
	{
		g_Game.AlertMessage(at_console,"Locked by Master: %1, Toggle State: %2\n",OFRandDoor.IsToggleLockedByMaster(), OFRandDoor.m_toggle_state);

		if ((OFRandDoor.IsToggleLockedByMaster()) && (OFRandDoor.m_toggle_state == TS_AT_BOTTOM))
		{
			g_EntityFuncs.FireTargets("of_lock1_lock", null, null, USE_TOGGLE, 0.0f, 0.0f);
			g_EntityFuncs.FireTargets("of_lock2_lock", null, null, USE_TOGGLE, 0.0f, 0.5f);
		}
		else
		{
			g_Scheduler.SetTimeout("BoltLocks_OFLoop", 0.5f, EHandle(OFRandDoor));
		}
	}
}