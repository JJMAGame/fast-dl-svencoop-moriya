         /*
        *       Script by Solokiller 
        */
 
 
 // https://baso88.github.io/SC_AngelScript/docs/In_Buttons.htm
const float MIN_TELEPORT_DELAY = 1;
 
const string g_szTeleportTarget = "teleport";
 
const int g_iKeyCombination = IN_USE | IN_JUMP;
 
float g_flLastTeleportTime = 0;
 
HookReturnCode PlayerPostThink( CBasePlayer@ pPlayer )
{
        /*
        *       Teleport player if a combination of keys is pressed
        */
        if( g_Engine.time - g_flLastTeleportTime >= MIN_TELEPORT_DELAY )
        {
                /*
                *        Teleport if keys match
                */
                if( ( pPlayer.pev.button & g_iKeyCombination ) == g_iKeyCombination )
                {
                        CBaseEntity@ pDestination = g_EntityFuncs.FindEntityByTargetname( null, g_szTeleportTarget );
                       
                        if( pDestination !is null )
                        {
                                //Only set if we actually teleported
                                g_flLastTeleportTime = g_Engine.time;
                               
                                pPlayer.SetOrigin( pDestination.pev.origin );
								
								g_EntityFuncs.FireTargets( "globaltelesound", pPlayer, pPlayer, USE_TOGGLE );
                        }
                }
        }
       
        return HOOK_CONTINUE;
}
 
void MapInit()
{
        g_Hooks.RegisterHook( Hooks::Player::PlayerPostThink, @PlayerPostThink );
}