const int g_MaxPlayerMapTransitionItemID = 10;

// Clears player inventories after saving them, to prevent map transition inventory bug.
const bool g_ClearInventoriesAfterSaving = false;

// Use item.Touch() instead of item.Use()
const bool g_TransferItemToPlayerByTouch = true;

int g_SimulatedItemStorageSession = 0;

// Get a new "save slot" for player inventories.
void IncrementSimulatedItemStorageSession(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	g_SimulatedItemStorageSession++;
}

void SaveCrossMapInventories(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	//g_Game.AlertMessage(at_console, "Saving cross map inventory items...\n");
	CBaseEntity@ ent = null;
	int playersWithItemCount = 0;
	int itemsSaved = 0;
	
	while ( ( @ent = g_EntityFuncs.FindEntityByClassname(ent, "player") ) !is null )
	{
		CBasePlayer@ p = cast<CBasePlayer>(ent);

		bool storedAtLeastOneItem = false;
		
		InventoryList@ inv = p.get_m_pInventory();
		while (inv !is null)
		{
			CItemInventory@ item = cast<CItemInventory>( inv.hItem.GetEntity() );
			if (item !is null)
			{
				CustomKeyvalues@ cks = item.GetCustomKeyvalues();
				CustomKeyvalue ck = cks.GetKeyvalue("$i_cross_map_id");
				if (ck.Exists())
				{
					int id = ck.GetInteger();
					if (id <= 0) continue;
					if (id > g_MaxPlayerMapTransitionItemID) continue;
					string dataString = "_iti" + g_SimulatedItemStorageSession + "_" + id + "_" + p.pev.netname;
					//g_Game.AlertMessage(at_console, "Setting global state " + dataString + " to GLOBAL_ON.\n");
					if (g_GlobalState.EntityInTable(dataString))
					{
						g_GlobalState.EntitySetState(dataString, GLOBAL_ON);
						g_GlobalState.EntityUpdate(dataString, g_Engine.mapname);
					}
					else
					{
						g_GlobalState.EntityAdd(dataString, g_Engine.mapname, GLOBAL_ON);
					}
					itemsSaved++;
					storedAtLeastOneItem = true;
				}
			}
			@inv = inv.pNext;
		}
		if (storedAtLeastOneItem)
		{
			playersWithItemCount++;
		}
		if (g_ClearInventoriesAfterSaving)
		{
			ClearPlayerInventory( p );
		}
	}
	
	g_Game.AlertMessage(at_console, "Saved " + itemsSaved + " cross map inventory item(s) for " + playersWithItemCount + " player(s).\n");
}

void ClearPlayerInventory(CBasePlayer@ p)
{
	bool destroyedAnItem = false;
	do
	{
		destroyedAnItem = false;
		InventoryList@ inv = p.get_m_pInventory();
		if (inv !is null)
		{
			CItemInventory@ item = cast<CItemInventory>( inv.hItem.GetEntity() );
			if (item !is null)
			{
				// This call updates m_pInventory. We just remove the first item in the list till it is empty.
				item.Destroy();
				
				destroyedAnItem = true;
			}
		}
	}
	while (destroyedAnItem);
}

void LoadCrossMapInventory(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	//g_Game.AlertMessage(at_console, "LoadCrossMapInventory()\n");

	if ( pActivator is null || !pActivator.IsPlayer() )
	{
		g_Game.AlertMessage(at_console, "WARNING: Got invalid activator when trying to load cross map inventory items.\n");
		return;
	}
		
	CBasePlayer@ p = cast<CBasePlayer>(pActivator);
	if (p.pev.deadflag != 0)
	{
		g_Game.AlertMessage(at_console, "WARNING: Cannot load cross map inventory items for dead player " + p.pev.netname + ".\n");
		return;
	}
	
	int itemsLoaded = 0;
	
	for (int id = 1; id <= g_MaxPlayerMapTransitionItemID; id++)
	{
		string dataString = "_iti" + g_SimulatedItemStorageSession + "_" + id + "_" + p.pev.netname;
		if ( !g_GlobalState.EntityInTable(dataString) ) 
			continue;
			
		if ( g_GlobalState.EntityGetState(dataString) == GLOBAL_ON )
		{
			CBaseEntity@ ent = null;
			while ( ( @ent = g_EntityFuncs.FindEntityByClassname(ent, "item_inventory") ) != null )
			{
				CItemInventory@ item = cast<CItemInventory>(ent);
				if (item is null)
					continue;
					
				CustomKeyvalues@ cks = item.GetCustomKeyvalues();
				CustomKeyvalue ck = cks.GetKeyvalue("$i_cross_map_id");
				if (ck.Exists())
				{
					int other_id = ck.GetInteger();
					if ( id == other_id )
					{
						//g_Game.AlertMessage(at_console, "Giving item " + id + " to player.\n");
						if ( g_TransferItemToPlayerByTouch )
							item.Touch( p );
						else
							item.Use( p, p, USE_TOGGLE, 0.0f );
							
						itemsLoaded++;
					}
				}
			}
		}
		//g_Game.AlertMessage(at_console, "Setting global state " + dataString + " to GLOBAL_DEAD.\n");
		g_GlobalState.EntitySetState(dataString, GLOBAL_DEAD);
	}
	
	if ( itemsLoaded > 0 )
	{
		g_Game.AlertMessage(at_console, "Loaded " + itemsLoaded + " cross map inventory item(s) for player " + p.pev.netname + ".\n");
	}
}
