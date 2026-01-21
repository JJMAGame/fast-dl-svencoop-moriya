//
// AMX Mod X, based on AMX Mod by Aleksander Naszko ("OLO").
//
// Admin Votes Plugin
//

const float vote_autopass_ratio = 0.75f; // % players voted to automatically end
const float autopass_grace = 3.0f; // seconds to wait for more votes before autopass
const uint max_options = 9; // max voting options in menu
const float vote_initial_delay = 1.0f; // wait before letting players vote
const float update_time = 0.5f; // time between voting logic checks

array<int> client_votes(g_Engine.maxClients,-1); //track what players voted for; -1 means no vote
uint num_options = 0;
string vote_question = "";
bool vote_happening = false;
float t_vote_begin = 0.0f;
float t_latest_vote = 0.0f;
array<string> g_pOptionName(max_options);
array<uint> g_pVoteCount(max_options,0);
CTextMenu@ g_VoteMenu;

CCVar@ g_pCCVar_VoteAnswers, g_pCCVar_VoteTime;

void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor( "Duko,gvazdas" );
	g_Module.ScriptInfo.SetContactInfo( "group.midu.cz,https://knockout.chat/user/3022");
	g_Module.ScriptInfo.SetMinimumAdminLevel( ADMIN_YES );

	@g_pCCVar_VoteAnswers = CCVar( "vote_answers", "1", "Display who votes for what option, set to 0 to disable, 1 to enable." );
	@g_pCCVar_VoteTime = CCVar( "vote_time", "30", "How long voting session goes on" );
	
	g_Hooks.RegisterHook( Hooks::Player::ClientConnected, @ClientConnected);
	g_Hooks.RegisterHook(Hooks::Player::ClientDisconnect, @ClientDisconnect);
	g_Hooks.RegisterHook(Hooks::Player::ClientPutInServer, @ClientPutInServer);
	g_Hooks.RegisterHook( Hooks::Game::MapChange, @MapChange);
	g_Hooks.RegisterHook(Hooks::Player::ClientSay, @ClientSay);
}

CClientCommand g_vote( "vote", "<question> <answer1> <answer2> ...", @cmdVote );

HookReturnCode ClientConnected( edict_t@ pEdict, const string& in szPlayerName, const string& in szIPAddress, bool& out bDisallowJoin, string& out szRejectReason )
{
	checkVotes();
	return HOOK_CONTINUE;
}

HookReturnCode ClientPutInServer(CBasePlayer@ pPlayer)
{
	checkVotes();
	return HOOK_CONTINUE;
}

HookReturnCode MapChange(const string& in szNewMap)
{
	if ( g_VoteMenu !is null )
		@g_VoteMenu = null;
    
	g_Scheduler.ClearTimerList();
	t_vote_begin=0.0f;
	vote_happening = false;
	
	return HOOK_CONTINUE;
}

void checkVotes()
{
    if (!vote_happening)
       return;
    
	uint votesNum = 0;
	uint votesMax = 0;
	for ( uint a = 0; a < num_options; a++ )
	{
	    votesNum += g_pVoteCount[a];
	    if (g_pVoteCount[a]>votesMax)
	       votesMax=g_pVoteCount[a];
    }
    
    uint numplayers = uint(g_PlayerFuncs.GetNumPlayers());
    
    float votes_thresh = float(numplayers)*vote_autopass_ratio;
    if (votes_thresh < 1.0f)
       votes_thresh = 1.0f;
    
    float t = g_EngineFuncs.Time();
    
    // Determine if vote should end
    bool vote_continue = true;
    if ( (votes_thresh<=float(votesNum) and ((t-t_latest_vote)>=autopass_grace)) or (votesMax>=numplayers) )
       vote_continue = false;
    else
    {
       if ((t-t_vote_begin)>g_pCCVar_VoteTime.GetFloat())
          vote_continue = false;
    }
    
	if (vote_continue)
	{
	   g_Scheduler.SetTimeout("checkVotes", update_time);
	   return;
    }
    
    vote_happening = false;
    g_PlayerFuncs.ClientPrintAll( HUD_PRINTTALK, "Vote result for " + vote_question + ":\n");
    g_EngineFuncs.ServerPrint("Vote result for " + vote_question + ":\n");
    
    if (votesNum<1)
    {
       g_PlayerFuncs.ClientPrintAll( HUD_PRINTTALK, "Vote failed.\n" );
       return;
    }
    
    array<uint> votes_sorted = g_pVoteCount;
    votes_sorted.sortDesc();
    int index_temp = -1; //allow index to be negative for find functionality
    string temp_answer = "";
    for (uint i_rank = 0; i_rank<3; i_rank++)
    {
       if ((i_rank+1)>votes_sorted.length())
          break;
       float percent_voted = float(votes_sorted[i_rank])/float(votesNum)*100.0f;
       int new_index = g_pVoteCount.find(votes_sorted[i_rank]);
       
       if (percent_voted<=0.0f or new_index==index_temp) //prevent repeats from printing
           break;
       else
       {
           index_temp = new_index;
           if (index_temp>=0)
           {
           temp_answer = g_pOptionName[index_temp];
           g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "#" + string(i_rank+1) + " (" + string(Math.Ceil(percent_voted)) + "%%" + ") " + temp_answer + "\n");
           g_EngineFuncs.ServerPrint("#" + string(i_rank+1) + " (" + string(Math.Ceil(percent_voted)) + "%%" +  ") " + temp_answer + "\n");
           }
       }
       
    }
}

void voteCount( CTextMenu@ menu, CBasePlayer@ pPlayer, int iSlot, const CTextMenuItem@ pItem )
{
    
    if (menu is null or !menu.IsRegistered() or pPlayer is null or !vote_happening)
       return;
    
    // Is player quick on the draw with voting?
    float t_hold = g_EngineFuncs.Time() - t_vote_begin;
    if (t_hold<0.0f)
    {
       g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTNOTIFY, "Wait " + string(-1.0f*t_hold) + " seconds.\n");
       g_VoteMenu.Open( int(g_pCCVar_VoteTime.GetFloat()-t_hold),0,pPlayer);
       return;
    }
    
	if (pItem !is null)
	{
		if ( g_pCCVar_VoteAnswers.GetBool() )
		    g_PlayerFuncs.ClientPrintAll( HUD_PRINTTALK, string(pPlayer.pev.netname) + " voted: " + g_pOptionName[uint(iSlot-1)] + "\n" );
        
        t_latest_vote = g_EngineFuncs.Time();
        
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTNOTIFY, "Type .vote to recast your vote.\n");
		g_pVoteCount[iSlot-1]++;
		client_votes[pPlayer.entindex()-1] = iSlot-1;
		checkVotes();
		
	}

	if ( @menu !is null && menu.IsRegistered() )
	{
		@menu = null;
	}
}

void cmdVote( const CCommand@ args )
{
	CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();

	if ( pPlayer is null || !pPlayer.IsConnected() )
		return;
	if ( !IsPlayerAdmin( pPlayer ) )
	{
		g_EngineFuncs.ClientPrintf( pPlayer, print_console, "Access denied.\n" );
		return;
	}
	
	if (vote_happening)
	{
		g_EngineFuncs.ClientPrintf( pPlayer, print_console, "Vote in progress.\n" );
		return;
	}

	int count = args.ArgC();

	if ( count < 4 )
	{
		g_EngineFuncs.ClientPrintf( pPlayer, print_console, "Usage: ." + g_vote.GetName() + " " + g_vote.GetHelpInfo() + "\n" );
		return;
	}

	vote_question = args.Arg( 1 );
	vote_question.Trim();
	
	g_pOptionName.resize(0);
	string szOption;
	for ( int i = 0; i < max_options && ( i + 2 ) < count; i++ )
	{
	    if (i>=int(max_options))
	       break;
		szOption = args.Arg( i + 2 );
		szOption.Trim();
		g_pOptionName.insertLast(szOption);
	}
	
	num_options = g_pOptionName.length();
	if (num_options<2 or num_options>max_options)
	{
	   g_EngineFuncs.ClientPrintf( pPlayer, print_console, "Usage: ." + g_vote.GetName() + " " + g_vote.GetHelpInfo() + "\n" );
	   return;
    }

	@g_VoteMenu = CTextMenu( @voteCount );
	g_VoteMenu.SetTitle( "Vote: " + vote_question + "\n" );
	
	for (uint i = 0; i < num_options; i++ )
	{
		g_VoteMenu.AddItem( g_pOptionName[i] );
    }
	
	vote_happening = true;
	g_pVoteCount = array<uint>(num_options,0);
	client_votes = array<int>(g_Engine.maxClients,-1);
	
	float vote_time = g_pCCVar_VoteTime.GetFloat() + vote_initial_delay;
	
	t_vote_begin = g_EngineFuncs.Time() + vote_initial_delay;
	
	g_VoteMenu.Register();
	g_VoteMenu.Open(int(vote_time), 0);
	g_Scheduler.SetTimeout( "checkVotes", vote_initial_delay+update_time);
}

bool IsPlayerAdmin( CBasePlayer@ pPlayer )
{
	return g_PlayerFuncs.AdminLevel( pPlayer ) >= ADMIN_YES;
}

// Allow player to revote
HookReturnCode ClientSay(SayParameters@ pParams)
{

if (vote_happening and g_VoteMenu !is null)
{
    CBasePlayer@ pPlayer = pParams.GetPlayer();
    const CCommand@ pArguments = pParams.GetArguments();
    const string firstArg = pArguments.Arg(0).ToLowercase();
    if (firstArg==".vote")
    {
       // Check if vote is about to end
       float t_elapsed =  g_EngineFuncs.Time()-t_vote_begin;
       if ( t_elapsed>=(g_pCCVar_VoteTime.GetFloat()-1.0f) )
          return HOOK_CONTINUE;
       
       g_VoteMenu.Open(int(t_elapsed),0,pPlayer);
       
       int i_vote = client_votes[pPlayer.entindex()-1];
       if (i_vote>=0)
       {
          client_votes[pPlayer.entindex()-1] = -1;
          if (g_pVoteCount[i_vote]>0)
             g_pVoteCount[i_vote] -= 1;
       }
    }
}

return HOOK_CONTINUE;

}

HookReturnCode ClientDisconnect(CBasePlayer@ pPlayer)
{

if (vote_happening and g_VoteMenu !is null)
{
    int i_vote = client_votes[pPlayer.entindex()-1];
    if (i_vote>=0)
    {
       client_votes[pPlayer.entindex()-1] = -1;
       if (g_pVoteCount[i_vote]>0)
          g_pVoteCount[i_vote]--;
    }
}

return HOOK_CONTINUE;
}