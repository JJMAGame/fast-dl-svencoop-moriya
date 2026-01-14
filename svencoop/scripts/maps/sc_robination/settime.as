// If the map is started, this script sets mp_timelimit just high enough so the
// map won't end prematurely. Please do not change or delete this script.

void SetLevelTimelimit(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
    int iNeededTimeM = 30;
    float fEngineTimeS = g_Engine.time; // Time in seconds since the map has started
    int iEngineTimeM = int(Math.Ceil(Math.Ceil(fEngineTimeS) / 60.0f));
    float fNewTimeM = iEngineTimeM + iNeededTimeM;
    float fTimelimitM = g_EngineFuncs.CVarGetFloat("mp_timelimit");
    if (fTimelimitM < fNewTimeM)
	{
        g_EngineFuncs.ServerPrint("Map " + g_Engine.mapname + " needs more time than is left. " +
			iEngineTimeM + " minute(s) have already passed. mp_timelimit is " +
			fTimelimitM + ". The map needs " + iNeededTimeM + " minute(s) starting now. Setting mp_timelimit to " + fNewTimeM + ".\n");
        g_EngineFuncs.CVarSetFloat("mp_timelimit", fNewTimeM);
    }
}
