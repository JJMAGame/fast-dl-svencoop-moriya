const float WAIT_TIME = 5.0f;
array<float> g_flWaitTime( g_Engine.maxClients + 1, 0.0 );

bool cvar_cache = false;

CCVar@ g_pVarGotoEnabled;
bool g_bGotoEnabled;
dictionary g_dNoGoto;
//array<string> g_pMovableEntList = { "func_door", "func_train", "func_tracktrain", "func_trackchange", "func_plat", "func_platrot", "func_rotating" };
GotoMenu g_GotoMenu;

// gvazdas 2025: added !bring command for admins
void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor( "Duko,gvazdas" );
	g_Module.ScriptInfo.SetContactInfo( "group.midu.cz,knockout.chat/user/3022" );

	g_Hooks.RegisterHook( Hooks::Player::ClientSay, @ClientSay );
	g_Hooks.RegisterHook( Hooks::Player::ClientDisconnect, @ClientDisconnect );
	g_Hooks.RegisterHook( Hooks::Game::MapChange, @MapChange );

	@g_pVarGotoEnabled = CCVar( "goto_enabled", "1", "Enable/Disable Goto", ConCommandFlag::AdminOnly, @GotoCallBack );
	g_bGotoEnabled = g_pVarGotoEnabled.GetBool();
	cvar_cache = g_bGotoEnabled;
}

void MapStart()
{
	if ( !g_dNoGoto.isEmpty() )
		g_dNoGoto.deleteAll();

	/*for ( int iPlayer = 1; iPlayer <= g_Engine.maxClients; iPlayer++ )
		g_flWaitTime[iPlayer] = g_Engine.time;*/
	g_flWaitTime = array<float>( g_Engine.maxClients + 1, g_Engine.time );
}

void GotoCallBack( CCVar@ cvar, const string& in szOldValue, float flOldValue )
{
	cvar.SetInt( Math.clamp( 0, 1, cvar.GetInt() ) );

	if ( int( flOldValue ) != cvar.GetInt() )
	{
		g_bGotoEnabled = cvar.GetBool();
		cvar_cache = g_bGotoEnabled;
		//g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "GotoCallBack: " + string(cvar_cache) + " " + string(g_bGotoEnabled) +  "\n");
		g_EngineFuncs.ServerPrint( "Goto is " + ( g_bGotoEnabled ? "Enabled" : "Disabled" ) + "\n" );
	}
}

HookReturnCode ClientSay( SayParameters@ pParams )
{
	const CCommand@ pArguments = pParams.GetArguments();

	if ( pArguments.ArgC() >= 1 )
	{
		CBasePlayer@ pPlayer = pParams.GetPlayer();
		if ( pPlayer is null || !pPlayer.IsConnected() )
           return HOOK_CONTINUE;

		string szArg = pArguments.Arg( 0 );
		szArg.Trim();
		if ( szArg.ICompare( "!goto" ) == 0 )
		{

			string szPartName = pArguments.Arg( 1 );
			szPartName.Trim();

			if ( szPartName.ICompare( "menu" ) == 0 or szPartName.IsEmpty() )
			{
				pParams.ShouldHide = true;
				g_GotoMenu.Show( pPlayer );
				
				return HOOK_HANDLED;
			}

			if ( DoGoto( pPlayer, szPartName ) )
			{
				pParams.ShouldHide = true;
				return HOOK_HANDLED;
			}

			return HOOK_CONTINUE;
		}
		else if ( IsPlayerAdmin(pPlayer) and szArg.ICompare("!bring")==0 )
		{
			string szPartName = pArguments.Arg( 1 );
			szPartName.Trim();
			DoBring(pPlayer,szPartName);
			return HOOK_CONTINUE;
		}
		else if ( szArg.ICompare( "!nogoto" ) == 0 )
		{

			string szSteamId = g_EngineFuncs.GetPlayerAuthId( pPlayer.edict() );
			
			if ( g_dNoGoto.exists( szSteamId ) )
			{
				g_dNoGoto.delete( szSteamId );
				g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] Players can teleport to you now.\n" );
			}
			else
			{
				g_dNoGoto.set( szSteamId, true );
				g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] Nobody can teleport to you now.\n" );
			}

			return HOOK_CONTINUE;
		}
	}
	return HOOK_CONTINUE;
}

void _te_pointeffect(Vector pos, NetworkMessageDest msgType=MSG_BROADCAST, edict_t@ dest=null, int effect=TE_SPARKS)
{
	NetworkMessage m(msgType, NetworkMessages::SVC_TEMPENTITY, dest);
	m.WriteByte(effect);
	m.WriteCoord(pos.x);
	m.WriteCoord(pos.y);
	m.WriteCoord(pos.z);
	m.End();
}

// Quake particle effect. This one is pretty cool.
void te_teleport(Vector pos, NetworkMessageDest msgType=MSG_BROADCAST, edict_t@ dest=null)
{
	_te_pointeffect(pos, msgType, dest, TE_TELEPORT);
}

void teleport(CBasePlayer@ pDestPlayer,CBasePlayer@ pTeleportee)
{

    if ( pDestPlayer is null or !pDestPlayer.IsConnected() or pTeleportee is null or !pTeleportee.IsConnected() )
       return;
    
    te_teleport(pTeleportee.pev.origin);
    
    // EXPERIMENTAL
    auto_manage_solid(pTeleportee,0.5f,true);
    // EXPERIMENTAL
        
    if ( pDestPlayer.pev.flags & FL_DUCKING != 0 )
    {
        pTeleportee.pev.flags |= FL_DUCKING;
        pTeleportee.pev.view_ofs = Vector( 0.0, 0.0, 12.0 );
    }
    pTeleportee.SetOrigin( pDestPlayer.GetOrigin() );
    pTeleportee.pev.angles.x = pDestPlayer.pev.v_angle.x;
    pTeleportee.pev.angles.y = pDestPlayer.pev.angles.y;
    pTeleportee.pev.angles.z = 0; //Do a barrel roll, not
    pTeleportee.pev.fixangle = FAM_FORCEVIEWANGLES; // Applies the player angles
}

// Automatically manage pev.solid state of player after they are teleported, to prevent sticking
void auto_manage_solid(CBasePlayer@ pPlayer, float next=0.5f, bool begin = false)
{
    
    if (pPlayer is null or !pPlayer.IsConnected() or !pPlayer.IsPlayer() or pPlayer.GetObserver().IsObserver())
        return;
    
    
    if (begin)
    {
       //g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "auto_manage_solid begin\n");
       // If player just teleported: disable collisions
       if (pPlayer.pev.solid == SOLID_SLIDEBOX)
       {
          pPlayer.pev.solid = SOLID_NOT;
          //g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, string(pPlayer.pev.netname)+" collision OFF\n");
       }
    }
    else
    {
        
        //g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "auto_manage_solid\n");
        
        if (pPlayer.pev.solid == SOLID_SLIDEBOX)
           return;
        
        // Check if collisions can be enabled
        bool is_intersecting = false;
        for (int i = 1; i <= g_Engine.maxClients; i++)
        {
           if (i>g_PlayerFuncs.GetNumPlayers())
              break;
           CBasePlayer@ pPlayer2 = g_PlayerFuncs.FindPlayerByIndex(i);
           if (pPlayer2==pPlayer)
              continue;
           if (pPlayer2 !is null && pPlayer2.IsConnected() && pPlayer2.IsPlayer() && !pPlayer2.GetObserver().IsObserver())
           {
                 CBaseEntity@ pEntity = cast<CBaseEntity@>(pPlayer2);
                 if (pEntity.IsInWorld() and pPlayer.Intersects(pEntity))
                 {
                     is_intersecting=true;
                     //g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, string(pPlayer.pev.netname)+" touching " + string(pPlayer2.pev.netname) + "\n");
                     break;
                 }
           }
        }
        
        if (!is_intersecting)
        {
           pPlayer.pev.solid = SOLID_SLIDEBOX;
           //g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, string(pPlayer.pev.netname)+" collision ON\n");
           //return;
        }
    
    }
    
    // If collisions disabled, try again later
    if (pPlayer.pev.solid != SOLID_SLIDEBOX)
    {
       g_Scheduler.SetTimeout("auto_manage_solid",next,@pPlayer,next,false);
       //g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, string(pPlayer.pev.netname)+" "+string(pPlayer.pev.solid)+"\n");
    }

}


// !bring command for admins
void DoBring(CBasePlayer@ pPlayer, string& in szPartName)
{ 

	if ( szPartName.IsEmpty() )
	{
		g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] Usage: !bring <part of name> OR !bring all\n" );
		return;
    }

	if ( !pPlayer.IsAlive() )
		return;

	if ( pPlayer.m_afPhysicsFlags & PFLAG_ONBARNACLE != 0 )
	{
		g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] Cannot teleport while paralyzed!\n" );
		return;
	}
	
	CBasePlayer@ pDestPlayer = @pPlayer;
	string szPlayerName;
	int iCount = 0;
	
	bool do_all = false;
	if (szPartName == "all")
	   do_all = true;
	   
	CBasePlayer@ pTarget;
	CBasePlayer@ pFinal;

	for ( int iTarget = 1; iTarget <= g_Engine.maxClients; iTarget++ )
	{
		
		if (iTarget>g_PlayerFuncs.GetNumPlayers())
           break;
		
		@pTarget = g_PlayerFuncs.FindPlayerByIndex( iTarget );

		if ( pTarget is null or !pTarget.IsConnected() or pTarget is pDestPlayer or !pTarget.IsAlive() )
			continue;
        
        if (do_all)
           teleport(pDestPlayer,pTarget);
        else
        {
    		szPlayerName = pTarget.pev.netname;
    		if ( int( szPlayerName.Find( szPartName, 0, String::CaseInsensitive ) ) != -1 )
    		{
    			@pFinal = pTarget;
    			iCount++;
    		}
		}
	}
	
	if (do_all)
	   return;

	if ( iCount == 0 or pFinal is null )
	{
		g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] Could not find '" + szPartName + "' player\n" );
		return;
	}

	if ( iCount > 1 )
	{
		g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] More than one player matches the pattern\n" );
		return;
	}
	
	teleport(pDestPlayer,pFinal);
	
}

HookReturnCode ClientDisconnect( CBasePlayer@ pPlayer )
{
	if ( pPlayer is null )
		return HOOK_CONTINUE;

	string szSteamId = g_EngineFuncs.GetPlayerAuthId( pPlayer.edict() );
	if ( g_dNoGoto.exists( szSteamId ) )
		g_dNoGoto.delete( szSteamId );

	return HOOK_CONTINUE;
}

HookReturnCode MapChange(const string& in szNewMap)
{
	g_Scheduler.ClearTimerList();

	return HOOK_CONTINUE;
}

bool DoGoto( CBasePlayer@ pPlayer, string& in szPartName, bool bHiden = false )
{
	if ( !g_bGotoEnabled )
	{
		g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] Goto Disabled!\n" );
		return true;
	}

	if ( szPartName.IsEmpty() )
	{
		g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] Usage: !goto <part of name>\n" );
		return true;
	}

	if ( !pPlayer.IsAlive() )
		return true;

	if ( pPlayer.m_afPhysicsFlags & PFLAG_ONBARNACLE != 0 )
	{
		g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] Cannot teleport while paralyzed!\n" );
		return true;
	}
	
	CBasePlayer@ pDestPlayer = null;
	string szPlayerName;
	int iCount = 0;
	array<CBasePlayer@> pRandom;
	
	CBasePlayer@ pTarget;

	for ( int iTarget = 1; iTarget <= g_Engine.maxClients; iTarget++ )
	{
		@pTarget = g_PlayerFuncs.FindPlayerByIndex( iTarget );

		if ( pTarget is null || !pTarget.IsConnected() )
			continue;

		if ( pTarget is pPlayer )
			continue;
			
		if ( szPartName == "@random" )
		{
			if ( pTarget.IsAlive() )
				pRandom.insertLast( pTarget );

			continue;
		}

		szPlayerName = pTarget.pev.netname;

		if ( int( szPlayerName.Find( szPartName, 0, String::CaseInsensitive ) ) != -1 )
		{
			@pDestPlayer = pTarget;
			iCount++;
		}
	}
	
	int iLen = pRandom.length();
	if ( iLen > 0 )
	{
		int iRandom = Math.RandomLong( 0, iLen - 1 );
		@pDestPlayer = pRandom[iRandom];
		iCount = 1;
	}

	if ( iCount == 0 || pDestPlayer is null )
	{
		g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] Could not find '" + szPartName + "' player\n" );
		g_GotoMenu.Show(pPlayer);
		return true;
	}

	if ( iCount > 1 )
	{
		g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] More than one player matches the pattern\n" );
		return true;
	}
	
/*	if ( !FNullEnt( pDestPlayer.pev ) )
		return true;*/

	szPlayerName = pDestPlayer.pev.netname;
	string szSteamId = g_EngineFuncs.GetPlayerAuthId( pDestPlayer.edict() );
			
	if ( g_dNoGoto.exists( szSteamId ) && !IsPlayerServerOwner( pPlayer ) )
	{
		g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] " + szPlayerName + " disabled goto\n" );
		//g_PlayerFuncs.ClientPrint( pDestPlayer, HUD_PRINTNOTIFY, "[AS] " + pPlayer.pev.netname + " trying goto you\n" );
		return true;
	}

	if ( pDestPlayer.pev.movetype == MOVETYPE_NOCLIP )
		return false;

	if ( pDestPlayer.Classify() != pPlayer.Classify() )
	{
		g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] " + szPlayerName + " is not in same team\n" );
		return true;
	}

	if ( !pDestPlayer.IsAlive() )
	{
		g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] " + szPlayerName + " is dead\n" );
		return true;
	}

	if ( pDestPlayer.m_flFallVelocity > 230 )
	{
		g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] " + szPlayerName + " is falling down\n" );
		return false;
	}

	if ( g_EntityFuncs.IsValidEntity( pDestPlayer.pev.groundentity ) )
	{
		CBaseEntity@ pEntity = g_EntityFuncs.Instance( pDestPlayer.pev.groundentity );
		if ( pEntity !is null )
		{
		//	if ( g_pMovableEntList.find( pEntity.GetClassname() ) >= 0 && pEntity.IsMoving() && pEntity.pev.speed != 0 )
			if ( pEntity.IsMoving() && pEntity.pev.speed != 0 )
			{
				g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] " + szPlayerName + " is on a moving object\n" );
				return false;
			}
		}
	}
	
	
	int iPlayer = pPlayer.entindex();
	float d_time = g_Engine.time - g_flWaitTime[iPlayer];
 	if ( d_time < WAIT_TIME )
 	{
 	    g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTNOTIFY, "[AS] " + "Wait " + string( WAIT_TIME-d_time ) + " seconds\n");
 		return false;
    }
 	g_flWaitTime[iPlayer] = g_Engine.time;
     
     teleport(pDestPlayer,pPlayer);
	
	return false;
}

final class GotoMenu
{
	private CTextMenu@ m_pMenu = null;
	
	void Show( CBasePlayer@ pPlayer = null )
	{
		if ( m_pMenu !is null && m_pMenu.IsRegistered() )
		{
			m_pMenu.Unregister();
			@m_pMenu = null;
		}

		if ( m_pMenu is null || !m_pMenu.IsRegistered() )
			CreateMenu( pPlayer );
			
		if ( pPlayer !is null )
			m_pMenu.Open( 0, 0, pPlayer );
	}

	private void RefeshMenu( CBasePlayer@ pPlayer = null )
	{
		if ( m_pMenu is null )
			return;

		if ( !m_pMenu.IsRegistered() )
			return;

		m_pMenu.Unregister();
		@m_pMenu = null;
		
		Show( pPlayer );
	}
	
	private void CreateMenu( CBasePlayer@ pPlayer = null )
	{
		@m_pMenu = CTextMenu( TextMenuPlayerSlotCallback( this.Callback ) );

		m_pMenu.SetTitle( "Goto Menu:\n" );
		
		array<string> pStoredNames;
		
		CBasePlayer@ pTarget;

		for ( int i = 1; i <= g_Engine.maxClients; i++ )
		{
			@pTarget = g_PlayerFuncs.FindPlayerByIndex( i );

			if ( pTarget is null || !pTarget.IsConnected() || !pTarget.IsAlive() )
				continue;
			
			if ( pPlayer is pTarget )
				continue;
				
/*			if ( g_dNoGoto.exists( g_EngineFuncs.GetPlayerAuthId( pTarget.edict() ) ) )
				continue;*/
				
			pStoredNames.insertLast( pTarget.pev.netname );
		}
		
		if ( IsPlayerAdmin( pPlayer ) )
		{
			if ( pStoredNames.length() > 1 )
				m_pMenu.AddItem( "[Random Player]", any( 1 ) );

			if ( !g_dNoGoto.isEmpty() )
				m_pMenu.AddItem( "[Remove Nogoto]", any( 2 ) );
		}
		
		for ( uint i = 0; i < pStoredNames.length(); i++ )
			m_pMenu.AddItem( pStoredNames[i] );
		
		if ( m_pMenu.GetItemCount() == 0 )
		{
			m_pMenu.AddItem( "No alive players", any( 3 ) );
			m_pMenu.AddItem( "[Refresh]", any( 3 ) );
		}

		m_pMenu.Register();
	}
	
	private void Callback( CTextMenu@ menu, CBasePlayer@ pPlayer, int iSlot, const CTextMenuItem@ pItem )
	{
		if ( pItem is null || pPlayer is null )
			return;
		
		int iUserData = 0;
		if ( pItem.m_pUserData !is null )
			pItem.m_pUserData.retrieve( iUserData );

		if ( iUserData == 2 && !g_dNoGoto.isEmpty() )
			g_dNoGoto.deleteAll();
		
		if ( iUserData <= 1 )
			DoGoto( pPlayer, iUserData == 1 ? "@random" : pItem.m_szName, true );

		g_Scheduler.SetTimeout( @this, "RefeshMenu", 0.01, @pPlayer );
	}
}

void CmdRemoveNoGoto( const CCommand@ args )
{
	CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();

	if ( pPlayer is null || !pPlayer.IsConnected() )
		return;

	if ( !IsPlayerAdmin( pPlayer ) )
	{
		g_EngineFuncs.ClientPrintf( pPlayer, print_console, "[AS] You have no access to that command\n" );
		return;
	}

	if ( g_dNoGoto.isEmpty() )
	{
		g_EngineFuncs.ClientPrintf( pPlayer, print_console, "[AS] Nogoto nothing stored.\n" );
		return;
	}

	g_dNoGoto.deleteAll();
	g_EngineFuncs.ClientPrintf( pPlayer, print_console, "[AS] Nogoto deleted all.\n" );
}

CClientCommand nogoto( "removenogoto", "remove nogoto", @CmdRemoveNoGoto );

void CmdToggleGoto( const CCommand@ args )
{
	CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();

	if ( pPlayer is null || !pPlayer.IsConnected() )
		return;

	if ( !IsPlayerAdmin( pPlayer ) )
	{
		g_EngineFuncs.ClientPrintf( pPlayer, print_console, "[AS] You have no access to that command\n" );
		return;
	}

	if ( !g_bGotoEnabled )
	{
		g_pVarGotoEnabled.SetInt(1);
		g_bGotoEnabled=true;
		g_EngineFuncs.ClientPrintf( pPlayer, print_console, "[AS] Goto Enabled.\n" );
	}
	else
	{
		g_pVarGotoEnabled.SetInt(0);
		g_bGotoEnabled=false;
		g_EngineFuncs.ClientPrintf( pPlayer, print_console, "[AS] Goto Disabled.\n" );
		//g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "!goto disabled\n");
	}
	
	cvar_cache = g_bGotoEnabled;
	//g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "new cvar_cache: " + string(cvar_cache) + "\n");
}

CClientCommand togglegoto( "togglegoto", "togglegoto", @CmdToggleGoto);

void CmdRaceStart( const CCommand@ args )
{
    //g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "CmdRaceStart: " + string(cvar_cache) + " " + string(g_bGotoEnabled) +  "\n");
	if (g_bGotoEnabled)
    {
	   //g_pVarGotoEnabled.SetInt(0);
	   g_bGotoEnabled=false;
	   //g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "!goto disabled\n");
    }
    //g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "CmdRaceStart: " + string(cvar_cache) + " " + string(g_bGotoEnabled) +  "\n");
}

CConCommand goto_startrace( "goto_startrace", "goto_startrace", @CmdRaceStart, ConCommandFlag::AdminOnly);

void CmdRaceEnd( const CCommand@ args )
{
    //g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "CmdRaceEnd: " + string(cvar_cache) + " " + string(g_bGotoEnabled) +  "\n");
	if (cvar_cache!=g_bGotoEnabled)
	{
	   if (cvar_cache)
	   {
	      g_pVarGotoEnabled.SetInt(1);
	      g_bGotoEnabled=true;
	      //g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "!goto enabled\n");
	   }
	   else
	   {
	      g_pVarGotoEnabled.SetInt(0);
	      g_bGotoEnabled=false;
	      //g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "!goto disabled\n");
	   }
	}
	//g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "CmdRaceEnd: " + string(cvar_cache) + " " + string(g_bGotoEnabled) +  "\n");
}

CConCommand goto_endrace( "goto_endrace", "goto_endrace", @CmdRaceEnd, ConCommandFlag::AdminOnly);

bool IsPlayerAdmin( CBasePlayer@ pPlayer )
{
	return g_PlayerFuncs.AdminLevel( pPlayer ) >= ADMIN_YES;
}

bool IsPlayerServerOwner( CBasePlayer@ pPlayer )
{
	return g_PlayerFuncs.AdminLevel( pPlayer ) == ADMIN_OWNER;
}
