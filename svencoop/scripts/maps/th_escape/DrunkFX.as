float fTimer = 0.0f;
void drunkvision()
{
    CBasePlayer@ pSearch = null;
    for(int i = 1; i <= g_Engine.maxClients; i++)
    {
        @pSearch = g_PlayerFuncs.FindPlayerByIndex(i);
        if(pSearch !is null)
        {
            CustomKeyvalues@ pCustom = pSearch.GetCustomKeyvalues();
            if(!pCustom.HasKeyvalue("$i_drunkvision"))
                continue;
                
            int iDrunkVision = pCustom.GetKeyvalue("$i_drunkvision").GetInteger();
            if(iDrunkVision != 1)
                continue;
                
            Vector vecOriginal = pSearch.pev.v_angle;
            vecOriginal.z = sin(fTimer)*5.0f;
            vecOriginal.x += sin(fTimer)*0.5f;
            vecOriginal.y += sin(fTimer)*1.4f;
            pSearch.pev.fixangle = FAM_FORCEVIEWANGLES;
            pSearch.pev.v_angle = vecOriginal;
            pSearch.pev.angles = vecOriginal;
            //pSearch.SetViewMode(ViewMode_FirstPerson);
        }
    }
    
    fTimer += 0.1f;
    if(fTimer > 360.0f)
        fTimer = 0.0f;
}	