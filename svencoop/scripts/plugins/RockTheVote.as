/*
Copyright (c) 2017 Drake "MrOats" Denston

This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/

/*
Current Status: Stable, report bugs on forums.
Documentation: https://github.com/MrOats/AngelScript_SC_Plugins/wiki/RockTheVote.as
*/

// gvazdas 2024-2025: fixed some bugs, added early end to voting, and partial string matching for nominate.

final class RTV_Data
{

  private string m_szVotedMap = "";
  private string m_szNominatedMap = "";
  private bool m_bHasRTV = false;
  private CBasePlayer@ m_pPlayer;
  private string m_szPlayerName;
  private string m_szSteamID = "";

  //RTV Data Properties

  string szVotedMap
  {
    get const { return m_szVotedMap; }
    set { m_szVotedMap = value; }
  }
  string szNominatedMap
  {
    get const { return m_szNominatedMap; }
    set { m_szNominatedMap = value; }
  }
  bool bHasRTV
  {
    get const { return m_bHasRTV; }
    set { m_bHasRTV = value; }
  }
  CBasePlayer@ pPlayer
  {
    get const { return m_pPlayer; }
    set { @m_pPlayer = value; }
  }
  string szSteamID
  {
    get const { return m_szSteamID; }
    set { m_szSteamID = value; }
  }
  string szPlayerName
  {
    get const { return m_szPlayerName; }
    set { m_szPlayerName = value; }
  }


  //RTV Data Functions


  //Constructor

  RTV_Data(CBasePlayer@ pPlr)
  {

    @pPlayer = pPlr;
    szSteamID = g_EngineFuncs.GetPlayerAuthId( pPlayer.edict() );
    szPlayerName = pPlayer.pev.netname;

  }

}

final class PCG
{

  private uint64 m_iseed;

  string seed
  {
    get const { return m_iseed; }
  }

  //PCG Functions

  uint nextInt(uint upper)
  {

    uint threshold = -upper % upper;

    while (true)
    {

      uint r =  nextInt();

      if (r >= threshold)
        return r % upper;

    }

    return upper;

  }


  uint nextInt()
  {
    uint64 oldstate = m_iseed;
    m_iseed = oldstate * uint64(6364136223846793005) + uint(0);
    uint xorshifted = ((oldstate >> uint(18)) ^ oldstate) >> uint(27);
    uint rot = oldstate >> uint(59);
    return (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
  }

  //PCG Constructors

  PCG(uint64 in_seed)
  {

    m_iseed = in_seed;

  }

  //Default Constructor
  PCG()
  {

    m_iseed = UnixTimestamp();

  }

}

//ClientCommands

CClientCommand rtv("rtv", "Rock the Vote!", @RtvPush);
CClientCommand nominate("nominate", "Nominate a Map!", @NomPush);
CClientCommand forcevote("forcevote", "Lets admin force a vote", @ForceVote, ConCommandFlag::AdminOnly);
CClientCommand addnominatemap("addnominatemap", "Lets admin add as many nominatable maps as possible", @AddNominateMap, ConCommandFlag::AdminOnly);
CClientCommand removenominatemap("removenominatemap", "Lets admin add as many nominatable maps as possible", @RemoveNominateMap, ConCommandFlag::AdminOnly);
CClientCommand cancelrtv("cancelrtv", "Lets admin cancel an ongoing RTV vote", @CancelVote, ConCommandFlag::AdminOnly);

//Global Vars

CTextMenu@ rtvmenu = null;
//CTextMenu@ nommenu = null;
array<CTextMenu@> nom_menus(g_Engine.maxClients,null);

array<RTV_Data@> rtv_plr_data;
array<string> forcenommaps;
array<string> prevmaps;
array<string> maplist;

PCG pcg_gen = PCG();

bool first_spawn = false;
bool isVoting = false;
bool canRTV = false;

int vote_cooldown = 0;
int secondsleftforvote = 0;
float t_latest_vote = 0.0f;

CCVar@ g_SecondsUntilVote;
CCVar@ g_MapList;
CCVar@ g_WhenToChange;
CCVar@ g_MaxMapsToVote;
CCVar@ g_VotingPeriodTime;
CCVar@ g_PercentageRequired;
CCVar@ g_ChooseEnding;
CCVar@ g_ExcludePrevMaps;
CCVar@ g_PlaySounds;
CCVar@ g_AutoThresh;
CCVar@ g_AutoGrace;

//Global Timers/Schedulers

CScheduledFunction@ g_TimeToVote = null;
CScheduledFunction@ g_TimeUntilVote = null;

//Hooks

void PluginInit()
{

  g_Module.ScriptInfo.SetAuthor("MrOats");
  g_Module.ScriptInfo.SetContactInfo("http://forums.svencoop.com/showthread.php/44609-Plugin-RockTheVote");
  g_Hooks.RegisterHook(Hooks::Player::ClientDisconnect, @DisconnectCleanUp);
  g_Hooks.RegisterHook(Hooks::Player::ClientPutInServer, @AddPlayer);
  g_Hooks.RegisterHook(Hooks::Game::MapChange, @MapChange);
  g_Hooks.RegisterHook(Hooks::Player::ClientSay, @Decider);

  @g_SecondsUntilVote = CCVar("secondsUntilVote", 20, "Delay before players can RTV after map has started", ConCommandFlag::AdminOnly);
  @g_MapList = CCVar("szMapListPath", "mapcycle.txt", "Path to list of maps to use. Defaulted to map cycle file", ConCommandFlag::AdminOnly);
  @g_WhenToChange = CCVar("iChangeWhen", 0, "When to change maps post-vote: <0 for end of map, 0 for immediate change, >0 for seconds until change", ConCommandFlag::AdminOnly);
  @g_MaxMapsToVote = CCVar("iMaxMaps", 8, "How many maps can players nominate and vote for later", ConCommandFlag::AdminOnly);
  @g_VotingPeriodTime = CCVar("secondsToVote", 20, "How long can players vote for a map before a map is chosen", ConCommandFlag::AdminOnly);
  @g_PercentageRequired = CCVar("iPercentReq", 60, "0-100, percent of players required to RTV before voting happens", ConCommandFlag::AdminOnly);
  @g_ChooseEnding = CCVar("iChooseEnding", 1, "Set to 1 to revote when a tie happens, 2 to choose randomly amongst the ties, 3 to await RTV again", ConCommandFlag::AdminOnly);
  @g_ExcludePrevMaps = CCVar("iExcludePrevMaps", 0, "How many maps to exclude from nomination or voting", ConCommandFlag::AdminOnly);
  @g_PlaySounds = CCVar("bPlaySounds", 1, "Set to 1 to play sounds, set to 0 to not play sounds", ConCommandFlag::AdminOnly);
  @g_AutoThresh = CCVar("fAutoThresh", 0.75f, "Percentage of players needed to prematurely end vote. Set to more than 1.0f to disable.", ConCommandFlag::AdminOnly);
  @g_AutoGrace = CCVar("fAutoGrace", 3, "Seconds of voting inactivity before AutoThresh kicks in", ConCommandFlag::AdminOnly);

}

void MapInit()
{

  //Precache Sounds
  //1
  g_Game.PrecacheGeneric("sound/fvox/one.wav");
  g_SoundSystem.PrecacheSound("fvox/one.wav");
  //2
  g_Game.PrecacheGeneric("sound/fvox/two.wav");
  g_SoundSystem.PrecacheSound("fvox/two.wav");
  //3
  g_Game.PrecacheGeneric("sound/fvox/three.wav");
  g_SoundSystem.PrecacheSound("fvox/three.wav");
  //4
  g_Game.PrecacheGeneric("sound/fvox/four.wav");
  g_SoundSystem.PrecacheSound("fvox/four.wav");
  //5
  g_Game.PrecacheGeneric("sound/fvox/five.wav");
  g_SoundSystem.PrecacheSound("fvox/five.wav");
  //10
  g_Game.PrecacheGeneric("sound/fvox/ten.wav");
  g_SoundSystem.PrecacheSound("fvox/ten.wav");
  //Time to choose
  g_Game.PrecacheGeneric("sound/gman/gman_choose1.wav");
  g_SoundSystem.PrecacheSound("gman/gman_choose1.wav");

}

void MapActivate()
{

  //Clean up Vars and Menus
  canRTV = false;
  isVoting = false;
  g_Scheduler.ClearTimerList();
  @g_TimeToVote = null;
  @g_TimeUntilVote = null;
  secondsleftforvote = g_VotingPeriodTime.GetInt();
  //first_spawn = false;
  //vote_cooldown = g_SecondsUntilVote.GetInt();

  rtv_plr_data.resize(g_Engine.maxClients);
  for (uint i = 0; i < rtv_plr_data.length(); i++)
    @rtv_plr_data[i] = null;

  for (uint i = 0; i < forcenommaps.length(); i++)
    forcenommaps[i] = "";

    forcenommaps.resize(0);

  for (uint i = 0; i < maplist.length(); i++)
    maplist[i] = "";

    maplist.resize(0);

  if(@rtvmenu !is null)
  {
    rtvmenu.Unregister();
    @rtvmenu = null;
  }
  //if(@nommenu !is null)
  //{
  //  nommenu.Unregister();
  //  @nommenu = null;
  //}

  maplist = GetMapList();
  /*
  for (size_t i = 0; i < prevmaps.length();)
  {

    if (maplist.find(prevmaps[i]) < 0)
      prevmaps.removeAt(i);
    else
      ++i;

  }
  */
  //int prevmaps_len = int(prevmaps.length());
  if (g_ExcludePrevMaps.GetInt() < 0)
    g_ExcludePrevMaps.SetInt(0);

}

HookReturnCode Decider(SayParameters@ pParams)
{

  CBasePlayer@ pPlayer = pParams.GetPlayer();
  const CCommand@ pArguments = pParams.GetArguments();

  if (pArguments[0] == "nominate")
  {

    NomPush(@pArguments, @pPlayer);
    return HOOK_HANDLED;

  }
  else if (pArguments[0] == "rtv")
  {

    RtvPush(@pArguments, @pPlayer);
    return HOOK_HANDLED;

  }
  else
     return HOOK_CONTINUE;

}

HookReturnCode MapChange(const string& in szNewMap)
{

  g_Scheduler.ClearTimerList();
  @g_TimeToVote = null;
  @g_TimeUntilVote = null;
  first_spawn = false;
  canRTV=false;

  prevmaps.insertLast(g_Engine.mapname);
  if ( (int(prevmaps.length()) > g_ExcludePrevMaps.GetInt()))
    prevmaps.removeAt(0);

  return HOOK_HANDLED;

}

HookReturnCode DisconnectCleanUp(CBasePlayer@ pPlayer)
{

  RTV_Data@ rtvdataobj = @rtv_plr_data[pPlayer.entindex() - 1];
  @rtvdataobj = null;

  return HOOK_HANDLED;

}

HookReturnCode AddPlayer(CBasePlayer@ pPlayer)
{

  RTV_Data@ rtvdataobj = RTV_Data(pPlayer);
  @rtv_plr_data[pPlayer.entindex() - 1] = @rtvdataobj;
  if (!first_spawn)
  {
     vote_cooldown = g_SecondsUntilVote.GetInt();
     @g_TimeUntilVote = g_Scheduler.SetInterval("DecrementSeconds", 1, g_SecondsUntilVote.GetInt() + 1);
     first_spawn = true;
     canRTV=false;
  }

  return HOOK_HANDLED;

}

//Main Functions
void DecrementSeconds()
{

  if ((vote_cooldown<=0 and first_spawn) or canRTV)
  {

    canRTV = true;
    g_Scheduler.RemoveTimer(g_TimeUntilVote);
    @g_TimeUntilVote = null;

  }
  else
    vote_cooldown-=1;

}

void DecrementVoteSeconds()
{
  
  // Check if vote should end prematurely
  float dt = g_EngineFuncs.Time() - t_latest_vote;
  if (dt>g_AutoGrace.GetFloat() and g_AutoThresh.GetFloat()<=1.0f)
  {
      
      int numVotes = int(GetVotedMaps().length());
      int numPlayers = int(g_PlayerFuncs.GetNumPlayers());
      
      if (numPlayers>0 and numVotes>0)
      {
          float voted_percentage = float(float(numVotes)/float(numPlayers));
          
          if (voted_percentage>=g_AutoThresh.GetFloat())
          {
              PostVote();
              g_Scheduler.RemoveTimer(g_TimeToVote);
              @g_TimeToVote = null;
              secondsleftforvote = g_VotingPeriodTime.GetInt();
              return;
          }
      }
  }
  
  string msg = "";
  
  if (secondsleftforvote == g_VotingPeriodTime.GetInt() && g_PlaySounds.GetBool())
  {

    CBasePlayer@ pPlayer = PickRandomPlayer();
    g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_AUTO, "gman/gman_choose1.wav", 1.0f, ATTN_NONE, 0, 100, 0, true, pPlayer.pev.origin);
    msg = string(secondsleftforvote) + " seconds left to vote.";

  }
  else if (secondsleftforvote == 10 && g_PlaySounds.GetBool())
  {

    CBasePlayer@ pPlayer = PickRandomPlayer();
    g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_AUTO, "fvox/ten.wav", 1.0f, ATTN_NONE, 0, 100, 0, true, pPlayer.pev.origin);
    msg = string(secondsleftforvote) + " seconds left to vote.";

  }
  else if (secondsleftforvote == 5 && g_PlaySounds.GetBool())
  {

    CBasePlayer@ pPlayer = PickRandomPlayer();
    g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_AUTO, "fvox/five.wav", 1.0f, ATTN_NONE, 0, 100, 0, true, pPlayer.pev.origin);
    msg = string(secondsleftforvote) + " seconds left to vote.";

  }
  else if (secondsleftforvote == 4 && g_PlaySounds.GetBool())
  {

    CBasePlayer@ pPlayer = PickRandomPlayer();
    g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_AUTO, "fvox/four.wav", 1.0f, ATTN_NONE, 0, 100, 0, true, pPlayer.pev.origin);
    msg = string(secondsleftforvote) + " seconds left to vote.";

  }
  else if (secondsleftforvote == 3 && g_PlaySounds.GetBool())
  {

    CBasePlayer@ pPlayer = PickRandomPlayer();
    g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_AUTO, "fvox/three.wav", 1.0f, ATTN_NONE, 0, 100, 0, true, pPlayer.pev.origin);
    msg = string(secondsleftforvote) + " seconds left to vote.";

  }
  else if (secondsleftforvote == 2 && g_PlaySounds.GetBool())
  {

    CBasePlayer@ pPlayer = PickRandomPlayer();
    g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_AUTO, "fvox/two.wav", 1.0f, ATTN_NONE, 0, 100, 0, true, pPlayer.pev.origin);
    msg = string(secondsleftforvote) + " seconds left to vote.";

  }
  else if (secondsleftforvote == 1 && g_PlaySounds.GetBool())
  {

    CBasePlayer@ pPlayer = PickRandomPlayer();
    g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_AUTO, "fvox/one.wav", 1.0f, ATTN_NONE, 0, 100, 0, true, pPlayer.pev.origin);
    msg = string(secondsleftforvote) + " seconds left to vote.";

  }
  else if (secondsleftforvote <= 0)
  {

    PostVote();
    g_Scheduler.RemoveTimer(g_TimeToVote);
    @g_TimeToVote = null;
    secondsleftforvote = g_VotingPeriodTime.GetInt();

  }
  
  secondsleftforvote--;
  if (!msg.IsEmpty())
     g_PlayerFuncs.ClientPrintAll(HUD_PRINTCENTER, msg);

}

void RtvPush(const CCommand@ pArguments, CBasePlayer@ pPlayer)
{

  if (isVoting)
  {

    rtvmenu.Open(0, 0, pPlayer);
    t_latest_vote = g_EngineFuncs.Time();

  }
  else
  {
    if (canRTV)
    {

      RockTheVote(pPlayer);

    }
    else
    {

      MessageWarnAllPlayers("RTV will enable in " + vote_cooldown + " seconds." );

    }

  }

}

void RtvPush(const CCommand@ pArguments)
{

  CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();

  if (isVoting)
  {

    rtvmenu.Open(0, 0, pPlayer);
    t_latest_vote = g_EngineFuncs.Time();

  }
  else
  {
    if (canRTV)
    {

      RockTheVote(pPlayer);

    }
    else
    {

      MessageWarnAllPlayers("RTV will enable in " + vote_cooldown + " seconds." );

    }

  }

}

void NomPush(const CCommand@ pArguments, CBasePlayer@ pPlayer)
{

  if (pArguments.ArgC() == 2)
  {

    NominateMap(pPlayer,pArguments.Arg(1));

  }
  else if (pArguments.ArgC() == 1)
  {

    NominateMenu(pPlayer);

  }

}


void NomPush(const CCommand@ pArguments)
{

  CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();

  if (pArguments.ArgC() == 2)
  {

    NominateMap(pPlayer,pArguments.Arg(1));

  }
  else if (pArguments.ArgC() == 1)
  {

    NominateMenu(pPlayer);

  }

}

void ForceVote(const CCommand@ pArguments, CBasePlayer@ pPlayer)
{

  if (pArguments.ArgC() >= 2)
  {

    array<string> rtvList;

    for (int i = 1; i < pArguments.ArgC(); i++)
    {

      if (g_EngineFuncs.IsMapValid(pArguments.Arg(i)))
        rtvList.insertLast(pArguments.Arg(i));
      else
        MessageWarnPlayer(pPlayer, pArguments.Arg(i) + " is not a valid map. Skipping...");

    }

    VoteMenu(rtvList);
    @g_TimeToVote = g_Scheduler.SetInterval("DecrementVoteSeconds", 1, g_VotingPeriodTime.GetInt() + 1);

  }
  else if (pArguments.ArgC() == 1)
  {

    BeginVote();
    @g_TimeToVote = g_Scheduler.SetInterval("DecrementVoteSeconds", 1, g_VotingPeriodTime.GetInt() + 1);

  }

}

void ForceVote(const CCommand@ pArguments)
{

  CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();

  if (pArguments.ArgC() >= 2)
  {

    array<string> rtvList;

    for (int i = 1; i < pArguments.ArgC(); i++)
    {

      if (g_EngineFuncs.IsMapValid(pArguments.Arg(i)))
        rtvList.insertLast(pArguments.Arg(i));
      else
        MessageWarnPlayer(pPlayer, pArguments.Arg(i) + " is not a valid map. Skipping...");

    }

    VoteMenu(rtvList);
    @g_TimeToVote = g_Scheduler.SetInterval("DecrementVoteSeconds", 1, g_VotingPeriodTime.GetInt() + 1);

  }
  else if (pArguments.ArgC() == 1)
  {

    BeginVote();
    @g_TimeToVote = g_Scheduler.SetInterval("DecrementVoteSeconds", 1,g_VotingPeriodTime.GetInt() + 1);

  }

}

void AddNominateMap(const CCommand@ pArguments)
{

  CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();
  array<string> plrnom = GetNominatedMaps();


  if (pArguments.ArgC() == 1)
  {

    MessageWarnPlayer(pPlayer, "You did not specify a map to nominate. Try again.");
    return;

  }

  if (g_EngineFuncs.IsMapValid(pArguments.Arg(1)))
  {

    if ( (plrnom.find(pArguments.Arg(1)) < 0) && (forcenommaps.find(pArguments.Arg(1)) < 0) )
    {

      forcenommaps.insertLast(pArguments.Arg(1));
      MessageWarnPlayer(pPlayer, "Map was added to force nominated maps list");

    }
    else
      MessageWarnPlayer(pPlayer, "Map was already nominated by someone else. Skipping...");

  }
  else
    MessageWarnPlayer(pPlayer, "Map does not exist. Skipping...");


}

void RemoveNominateMap(const CCommand@ pArguments)
{

  CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();
  array<string> plrnom = GetNominatedMaps();


  if (pArguments.ArgC() == 1)
  {

    MessageWarnPlayer(pPlayer, "You did not specify a map to remove from nominations. Try again.");
    return;

  }


    if (plrnom.find(pArguments.Arg(1)) >= 0)
    {

      //Let's figure out who nominated that map and remove it...
      for (uint i = 0; i < rtv_plr_data.length(); i++)
      {

          if (@rtv_plr_data[i] !is null)
          {

            if (rtv_plr_data[i].szNominatedMap == pArguments.Arg(1))
              {

                MessageWarnAllPlayers(string(rtv_plr_data[i].szPlayerName + " removed " + rtv_plr_data[i].szPlayerName + " nomination of " + rtv_plr_data[i].szNominatedMap));
                rtv_plr_data[i].szNominatedMap = "";

              }

          }
      }

    }
    else if (forcenommaps.find(pArguments.Arg(1)) >= 0)
    {

      forcenommaps.removeAt(forcenommaps.find(pArguments.Arg(1)));
      MessageWarnPlayer(pPlayer, pArguments.Arg(1) +  " was removed from admin's nominations");

    }
    else MessageWarnPlayer(pPlayer, pArguments.Arg(1) + " was not nominated. Skipping...");

}

void CancelVote(const CCommand@ pArguments)
{
  
  // For testing
  //CBasePlayer@ pBot = g_PlayerFuncs.CreateBot("Dipshit");
  //NominateMenu(pBot);

  CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();
  RTV_Data@ rtvdataobj = @rtv_plr_data[pPlayer.entindex() - 1];

  g_Scheduler.RemoveTimer(@g_TimeToVote);
  CScheduledFunction@ g_TimeToVote = null;

  ClearRTV();

  MessageWarnAllPlayers("RTV cancelled by " + string(rtvdataobj.szPlayerName) );

}

CBasePlayer@ PickRandomPlayer()
{

  CBasePlayer@ pPlayer;
  for (int i = 1; i <= g_Engine.maxClients; i++)
  {

    @pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
    if ( (pPlayer !is null) && (pPlayer.IsConnected()) )
      break;

  }

  return @pPlayer;

}

void MessageWarnPlayer(CBasePlayer@ pPlayer, string msg)
{

  g_PlayerFuncs.SayText( pPlayer, "[RTV] " + msg + "\n");

}

void MessageWarnAllPlayers(string msg)
{

  g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK,"[RTV] " + msg + "\n");

}


void NominateMap( CBasePlayer@ pPlayer, string szMapName )
{

  RTV_Data@ rtvdataobj = @rtv_plr_data[pPlayer.entindex() - 1];
  array<string> mapsNominated = GetNominatedMaps();
  array<string> mapList = maplist;


  if ( mapList.find( szMapName ) < 0 )
  {
    NominateMenu(pPlayer,szMapName);
    //MessageWarnPlayer( pPlayer, "Map does not exist." );
    return;

  }

  if (prevmaps.find( szMapName ) >= 0)
  {

    MessageWarnPlayer( pPlayer, "Map has already been played and will be excluded until later.");
    return;

  }

  if ( forcenommaps.find( szMapName ) >= 0 )
  {

    MessageWarnPlayer( pPlayer, "\"" + szMapName + "\" was found in the admin's list of nominated maps.");
    return;

  }

  if ( mapsNominated.find( szMapName ) >= 0 )
  {

    MessageWarnPlayer( pPlayer, "Someone nominated \"" + szMapName + "\" already.");
    return;

  }

  if ( int(mapsNominated.length()) > g_MaxMapsToVote.GetInt() )
  {

    MessageWarnPlayer( pPlayer, "Players have reached max number of nominations!" );
    return;

  }

  if ( rtvdataobj.szNominatedMap.IsEmpty() )
  {

    MessageWarnAllPlayers(rtvdataobj.szPlayerName + " nominated \"" + szMapName + "\"." );
    rtvdataobj.szNominatedMap = szMapName;
    return;

  }
  else
  {

    MessageWarnAllPlayers(rtvdataobj.szPlayerName + " changed their nomination to \"" + szMapName + "\". " );
    rtvdataobj.szNominatedMap = szMapName;
    return;

  }

}

void nominate_MenuCallback( CTextMenu@ menu, CBasePlayer@ pPlayer, int page, const CTextMenuItem@ item)
{
   
  if ( item !is null && pPlayer !is null )
    NominateMap(pPlayer,item.m_szName);

  if ( menu !is null && menu.IsRegistered() )
    menu.Unregister();

}

void NominateMenu(CBasePlayer@ pPlayer, string filter="")
{
      
      if (pPlayer is null or !pPlayer.IsConnected())
         return;
         
      uint i_menu = pPlayer.entindex() - 1;
      CTextMenu@ nommenu = nom_menus[i_menu];
      if (nommenu !is null && nommenu.IsRegistered())
         nommenu.Unregister();
      
      array<string> mapList;
      mapList.resize(0);
      string curr_map = "";
      
      string filter_trim = filter;
      filter_trim.Trim();
      bool check_filter = !filter_trim.IsEmpty();

      for (uint i = 0; i < maplist.length(); i++)
      {
      
        curr_map = maplist[i];
        if (check_filter)
        {
           if (curr_map.Find(filter_trim)==String::INVALID_INDEX)
              continue;
        }
        
        if ( not ((prevmaps.find(curr_map) >= 0) or (forcenommaps.find(curr_map) >= 0)) )
           mapList.insertLast(curr_map);

      }

      
      if (mapList.length()>1)
      {
          mapList.sortAsc();
          //@nommenu = CTextMenu(@nominate_MenuCallback);
          //CTextMenu@ nommenu;
          //@nommenu = CTextMenu(@nominate_MenuCallback);
          @nommenu = CTextMenu(nominate_MenuCallback);
          nommenu.SetTitle("Nominate...");
    
          for (uint i = 0; i < mapList.length(); i++)
            nommenu.AddItem( mapList[i], any(mapList[i]));
    
          if (nommenu !is null && !nommenu.IsRegistered())
             nommenu.Register();
          nommenu.Open(0,0,pPlayer);
          @nom_menus[i_menu] = nommenu;
          //g_PlayerFuncs.ClientPrintAll( HUD_PRINTTALK, "menu opened\n");
      }
      else if (mapList.length()==1)
      {
          NominateMap(pPlayer,mapList[0]);
      }
      else
      {
          MessageWarnPlayer( pPlayer, "Map does not exist or was already played." );
      }

}

void RockTheVote(CBasePlayer@ pPlayer)
{

  RTV_Data@ rtvdataobj = @rtv_plr_data[pPlayer.entindex() - 1];
  int rtvRequired = CalculateRequired();

  if (rtvdataobj.bHasRTV)
  {

    MessageWarnPlayer(pPlayer,"You have already Rocked the Vote!");
    MessageWarnAllPlayers("" + GetRTVd() + " of " + rtvRequired + " players until vote initiates!");

  }
  else
  {

    rtvdataobj.bHasRTV = true;
    MessageWarnPlayer(pPlayer,"You have Rocked the Vote!");
    MessageWarnAllPlayers("" + GetRTVd() + " of " + rtvRequired + " players until vote initiates!");

  }

  if (GetRTVd() >= rtvRequired)
  {

    if (!isVoting)
    {

      isVoting = true;
      BeginVote();

    }

    @g_TimeToVote = g_Scheduler.SetInterval("DecrementVoteSeconds", 1,g_VotingPeriodTime.GetInt() + 1);

  }

}

void rtv_MenuCallback(CTextMenu@ rtvmenu, CBasePlayer@ pPlayer, int page, const CTextMenuItem@ item)
{

  if (item !is null && pPlayer !is null)
  {
    vote(item.m_szName,pPlayer);
    t_latest_vote = g_EngineFuncs.Time();
  }

}

void VoteMenu(array<string> rtvList)
{

  canRTV = true;
  MessageWarnAllPlayers("You have " + g_VotingPeriodTime.GetInt() + " seconds to vote!");

  @rtvmenu = CTextMenu(@rtv_MenuCallback);
  rtvmenu.SetTitle("RTV Vote");
  for (uint i = 0; i < rtvList.length(); i++)
  {

    rtvmenu.AddItem(rtvList[i], any(rtvList[i]));

  }

  if (!(rtvmenu.IsRegistered()))
  {

    rtvmenu.Register();

  }

  for (int i = 1; i <= g_Engine.maxClients; i++)
  {

    CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);

    if(pPlayer !is null)
    {

      rtvmenu.Open(0, 0, pPlayer);

    }

  }

}

void vote(string votedMap,CBasePlayer@ pPlayer)
{

  RTV_Data@ rtvdataobj = @rtv_plr_data[pPlayer.entindex() - 1];

  if (rtvdataobj.szVotedMap.IsEmpty())
  {

    rtvdataobj.szVotedMap = votedMap;
    MessageWarnPlayer(pPlayer,"You voted for " + votedMap);

  }
  else
  {

    rtvdataobj.szVotedMap = votedMap;
    MessageWarnPlayer(pPlayer,"You changed your vote to "+ votedMap);

  }


}

void BeginVote()
{

  canRTV = true;
  t_latest_vote = g_EngineFuncs.Time();

  array<string> rtvList;
  array<string> mapsNominated = GetNominatedMaps();

  for (uint i = 0; i < forcenommaps.length(); i++)
    rtvList.insertLast(forcenommaps[i]);

  for (uint i = 0; i < mapsNominated.length(); i++)
    rtvList.insertLast(mapsNominated[i]);

  //Determine how many more maps need to be added to menu
  int remaining = 0;
  if(int(maplist.length()) < g_MaxMapsToVote.GetInt() )
  {

    //maplist is smaller, use it
    remaining = int(maplist.length() - rtvList.length());

  }
  else if (int(maplist.length()) > g_MaxMapsToVote.GetInt() )
  {

    //MaxMaps is smaller, use it
    remaining = g_MaxMapsToVote.GetInt() - int(rtvList.length());

  }
  else if (int(maplist.length()) == g_MaxMapsToVote.GetInt() )
  {

    //They are same length, use maplist
    remaining = int(maplist.length() - rtvList.length());

  }

  while (remaining > 0)
  {

    //Fill rest of menu with random maps
    string rMap = RandomMap();

    if ( ((rtvList.find(rMap)) < 0) && (prevmaps.find(rMap) < 0))
    {

      rtvList.insertLast(rMap);
      remaining--;

    }

  }


  //Give Menus to Vote!
  VoteMenu(rtvList);

}

void PostVote()
{

  array<string> rtvList = GetVotedMaps(); //each item is a map voted by a player
  dictionary rtvVotes;
  int highestVotes = 0;

  //Initialize Dictionary of votes
  for (uint i = 0; i < rtvList.length(); i++)
  {
    rtvVotes.set( rtvList[i], 0);
  }

  for (uint i = 0; i < rtvList.length(); i++)
  {

    int val = int(rtvVotes[rtvList[i]]);
    rtvVotes[rtvList[i]] = val + 1;

  }

  //Find highest amount of votes
  for (uint i = 0; i < rtvList.length(); i++)
  {

    if ( int( rtvVotes[rtvList[i]] ) >= highestVotes)
    {

      highestVotes = int(rtvVotes[rtvList[i]]);

    }
  }
   
  g_PlayerFuncs.ClientPrintAll( HUD_PRINTTALK, "[RTV] Vote results:\n");
  g_EngineFuncs.ServerPrint("[RTV] Vote results:\n");
   
  //Nobody voted?
  if (highestVotes == 0)
  {

    string chosenMap = RandomMap();
    MessageWarnAllPlayers("\"" + chosenMap +"\" was picked randomly due to no votes.");
    ChooseMap(chosenMap, false);
    return;

  }

  //Print voting statistics
  array<string> maps_unsorted = rtvVotes.getKeys();
  uint votesNum = uint(rtvList.length()); //total number of players that voted
  array<uint> votes_unsorted(maps_unsorted.length(),0);
  for (uint i = 0; i < maps_unsorted.length(); i++)
  {
      votes_unsorted[i] = uint(rtvVotes[maps_unsorted[i]]);
  }
  array<uint> votes_sorted = votes_unsorted;
  votes_sorted.sortDesc();
  int index_temp = -1; //allow index to be negative for find functionality
  for (uint i_rank = 0; i_rank<3; i_rank++)
  {
     if ((i_rank+1)>votes_sorted.length())
        break;
     float percent_voted = float(votes_sorted[i_rank])/float(votesNum)*100.0f;
     int new_index = votes_unsorted.find(votes_sorted[i_rank]);
     if (percent_voted<=0.0f or new_index==index_temp) //prevent repeats from printing
         break;
     else
     {
         index_temp = new_index;
         if (index_temp>=0)
         {
         g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "#" + string(i_rank+1) + " (" + string(Math.Ceil(percent_voted)) + "%%" + ") " + maps_unsorted[index_temp] + "\n");
         g_EngineFuncs.ServerPrint("#" + string(i_rank+1) + " (" + string(Math.Ceil(percent_voted)) + "%%" + ") " + maps_unsorted[index_temp] + "\n");
         }
     }  
  }

  //Find how many maps were voted at the highest
  array<string> candidates;
  array<string> singlecount = rtvVotes.getKeys();
  for (uint i = 0; i < singlecount.length(); i++)
  {

    if ( int(rtvVotes[singlecount[i]]) == highestVotes)
    {

      candidates.insertLast( singlecount[i] );

    }
  }
  singlecount.resize(0);
  
  
  

  //Revote or random choose if more than one map is at highest vote count
  if (candidates.length() > 1)
  {

    if (g_ChooseEnding.GetInt() == 1)
    {

      ClearVotedMaps();
      MessageWarnAllPlayers("There was a tie! Revoting...");
      @g_TimeToVote = g_Scheduler.SetInterval("DecrementVoteSeconds", 1, g_VotingPeriodTime.GetInt() + 1);
      VoteMenu(candidates);
      return;

    }
    else if (g_ChooseEnding.GetInt() == 2)
    {

      string chosenMap = RandomMap(candidates);
      MessageWarnAllPlayers("\"" + chosenMap +"\" has been randomly chosen amongst the tied");
      ChooseMap(chosenMap, false);
      return;

    }
    else if (g_ChooseEnding.GetInt() == 3)
    {

      ClearVotedMaps();
      ClearRTV();

      MessageWarnAllPlayers("There was a tie! Please RTV again...");

    }
    else
      g_Log.PrintF("[RTV] Fix your ChooseEnding CVar!\n");
  }
  else
  {

    //MessageWarnAllPlayers("\"" + candidates[0] +"\" won the vote!");
    ChooseMap(candidates[0], false);
    return;

  }

}

void server_change_map(string chosenMap)
{
g_EngineFuncs.ServerCommand("changelevel " + chosenMap + "\n");
}

void ChooseMap(string chosenMap, bool forcechange)
{

  //After X seconds passed or if CVar WhenToChange is 0
  if (forcechange || (g_WhenToChange.GetInt() == 0) )
  {

    g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "[RTV] Changing map to " + chosenMap + "...\n");
    g_PlayerFuncs.CenterPrintAll("Changing map to " + chosenMap + "...\n");
    g_EngineFuncs.ServerPrint("[RTV] Changing map to " + chosenMap + "...\n");
    //g_EngineFuncs.ServerCommand("changelevel " + chosenMap + "\n");
    g_Scheduler.SetTimeout("server_change_map", 0.1f, chosenMap);

  }
  //Change after X Seconds
  if (g_WhenToChange.GetInt() > 0)
  {

    g_Scheduler.SetTimeout("ChooseMap", g_WhenToChange.GetInt(), chosenMap, true);

  }
  //Change after map end
  if (g_WhenToChange.GetInt() < 0)
  {

    //Handle "infinite time left" maps by setting time left to X minutes
    if (g_EngineFuncs.CVarGetFloat("mp_timelimit") == 0)
    {

      //Can't set mp_timeleft...
      //g_EngineFuncs.CVarSetFloat("mp_timeleft", 600);
      g_Scheduler.SetTimeout("ChooseMap", abs(g_WhenToChange.GetInt()), chosenMap, true);

    }

    /*
    NetworkMessage@ netmsg(CLIENT_ALL, NetworkMessages::NetworkMessageType type, const Vector& in vecOrigin, edict_t@ pEdict = null);
    netmsg.WriteString(chosenMap);
    netmsg.End();
    */
    g_EngineFuncs.ServerCommand("mp_nextmap "+ chosenMap + "\n");
    g_EngineFuncs.ServerCommand("mp_nextmap_cycle "+ chosenMap + "\n");
    MessageWarnAllPlayers("Next map has been set to \"" + chosenMap + "\".");

  }

}

// Utility Functions

int CalculateRequired()
{

  return int(ceil( g_PlayerFuncs.GetNumPlayers() * (g_PercentageRequired.GetInt() / 100.0f) ));

}

string RandomMap()
{

  return maplist[pcg_gen.nextInt(maplist.length())];

}

string RandomMap(array<string> mapList)
{

  return mapList[pcg_gen.nextInt(mapList.length())];

}

string RandomMap(array<string> mapList, uint length)
{

  return mapList[pcg_gen.nextInt(length)];

}

array<string> GetNominatedMaps()
{

  array<string> nommaps;

  for (uint i = 0; i < rtv_plr_data.length(); i++)
  {

    RTV_Data@ pPlayer = @rtv_plr_data[i];

    if (pPlayer !is null)
      if ( !(pPlayer.szNominatedMap.IsEmpty()) )
        nommaps.insertLast(pPlayer.szNominatedMap);

  }


  return nommaps;

}

array<string> GetMapList()
{

  array<string> mapList;

  if ( !(g_MapList.GetString() == "mapcycle.txt" ) )
  {

    File@ file = g_FileSystem.OpenFile(g_MapList.GetString(), OpenFile::READ);

    if(file !is null && file.IsOpen())
    {

      g_Game.AlertMessage(at_console, "[RTV] Opening file!!!\n");
      while(!file.EOFReached())
      {

        string sLine;
        file.ReadLine(sLine);

        if(sLine.SubString(0,1) == "#" || sLine.IsEmpty())
          continue;

        sLine.Trim();

        mapList.insertLast(sLine);

      }

      file.Close();

      //Probably wanna make sure all maps are valid...
      for (uint i = 0; i < mapList.length();)
      {

        if ( !(g_EngineFuncs.IsMapValid(mapList[i])) )
        {

          mapList.removeAt(i);

        }
        else
          ++i;

      }

    }

    return mapList;

  }

  g_Game.AlertMessage(at_console, "[RTV] Using MapCycle.txt\n");
  return g_MapCycle.GetMapCycle();

}


array<string> GetVotedMaps()
{

  array<string> votedmaps;

  for (uint i = 0; i < rtv_plr_data.length(); i++)
  {

    if (@rtv_plr_data[i] !is null)
      if ( !(rtv_plr_data[i].szVotedMap.IsEmpty()) )
        votedmaps.insertLast(rtv_plr_data[i].szVotedMap);

  }

  return votedmaps;

}

int GetRTVd()
{

  int counter = 0;
  for (uint i = 0; i < rtv_plr_data.length(); i++)
  {

    if (@rtv_plr_data[i] !is null)
      if (rtv_plr_data[i].bHasRTV)
        counter += 1;

  }

  return counter;

}

void ClearVotedMaps()
{

  for (uint i = 0; i < rtv_plr_data.length(); i++)
  {

    if (@rtv_plr_data[i] !is null)
    {

      rtv_plr_data[i].szVotedMap = "";

    }

  }

}

void ClearRTV()
{

  for (uint i = 0; i < rtv_plr_data.length(); i++)
  {

    if (@rtv_plr_data[i] !is null)
    {

      rtv_plr_data[i].bHasRTV = false;

    }

  }

}
