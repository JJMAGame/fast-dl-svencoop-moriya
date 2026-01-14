// Script for random path_waypoints

int waypoint_Next;

void sci_waypoint(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if (pActivator !is null) // We have to use the ACTIVATOR here, because Monster Path entities are coded like this.
							 // The Monster is always the Caller, the path_waypoint the Activator.
	{
		waypoint_Next = Math.RandomLong(1,11); // Get a random number

		string waypoint_TName = pActivator.GetTargetname(); // Fetch targetname of the caller. Should be the current waypoint.
		pActivator.pev.target = "way_sci_p" + waypoint_Next; // give the current path_waypoint a new target

		// Output stuff, console, developer 1
		string wp_cTName = pCaller.GetTargetname();
		g_Game.AlertMessage(at_console, "Monster \"%1\": current Waypoint \"%2\", next Waypoint \"way_sci_p%3\"\n",wp_cTName, waypoint_TName, waypoint_Next);

		// output stuff end
	}
	else
	{
		g_Game.AlertMessage(at_console, "Activator IS \"null\"!\n");
	}
}





void sci_waypoint_test(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	waypoint_Next = 11;
	if (pActivator !is null)

	{
		string waypoint_TName = pActivator.GetTargetname();
		//waypoint_Next++;

		pActivator.pev.target = "way_sci_p" + waypoint_Next;

		string wp_cTName = pCaller.GetTargetname();
		g_Game.AlertMessage(at_console, "Monster \"%1\": current Waypoint \"%2\", next Waypoint \"way_sci_p%3\"\n",wp_cTName, waypoint_TName, waypoint_Next);


	}
	else
	{
		g_Game.AlertMessage(at_console, "Activator IS \"null\"!\n");
	}
}