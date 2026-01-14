#include "weapons/weapon_sawedoff"
#include "weapons/weapon_colt1911"
#include "weapons/weapon_tommygun"
#include "weapons/weapon_teslagun"
#include "weapons/weapon_spanner"


array<ItemMapping@> g_ItemMappings =
{ 
	ItemMapping( "weapon_9mmAR", THWeaponThompson::WEAPON_NAME ), 
	ItemMapping( "weapon_shotgun", THWeaponSawedoff::WEAPON_NAME ), 
	ItemMapping( "weapon_9mmhandgun", THWeaponM1911::WEAPON_NAME ), 
	ItemMapping( "weapon_eagle", "weapon_357" )
};

int workTimeAccumulated = 0;
CScheduledFunction@ workTimeInterval = null;
bool suddenDeath = false;

// stuff for viewing the guide
const int GUIDE_ACT_KEY = IN_ALT1;
const float MIN_GUIDE_DELAY = 0.5f;
const string GUIDE_ACT_TIME = "GUIDE_ACT_TIME";
const string GUIDE_STATE = "GUIDE_STATE";

int numberOfMixers = 6;
int numberOfGrinders = 6;
array<dictionary> grinder(numberOfGrinders + 1); //remember that the number needs to be one higher because of 0-indexing
array<dictionary> mixer(numberOfMixers + 1);
dictionary packing;

int grinderCounterTime = 180; //must be an even number!
int mixerCounterTime = 180; //must be an even number!
int packingCounterTime = 300; //must be an even number!
 // int grinderCounterTime = 10; //must be an even number!
 // int mixerCounterTime = 10; //must be an even number!
// int packingCounterTime = 30; //must be an even number!
int packingEffectsCounter =  packingCounterTime / 5;
int packingBarrelCounterB = 0; //not a timer, counter for grease barrel count or something
int packingBarrelCounterC = 0;

bool firstBatchProduced = false;
int mustardProduced = 0;
int mustardGoal = 16;

int totalMixesReady = 0;
//int totalMixesReady = 5;
int mixesBeingProcessed = 0;

int emptyGrinders = 6;
int preppedGrinders = 0;
int activeGrinders = 0;
int completedGrinders = 0;

int emptyMixers = 6;
int preppedMixers = 0;
int activeMixers = 0;
	
bool activeBoss = false;	

bool firstInputDone = false;
bool switchFlipped = false;

bool mapEndReached = false;

int startSecondBarrels;
int stopFirstBarrels;
int stopSecondBarrels;

bool packingLock1 = false;
bool packingLock2 = false;

array<int> grinderCounter(7, grinderCounterTime); //the time counter that gets decremented 
array<int> mixerCounter(7, mixerCounterTime); //the time counter that gets decremented 
int packingCounterTimeLeft = packingCounterTime;


int packingBarrelsAddedInt = 0;
//int packingBarrelsAddedInt = 4;


CScheduledFunction@ pFunctionGrinder1 = null;
CScheduledFunction@ pFunctionGrinder2 = null;
CScheduledFunction@ pFunctionGrinder3 = null;
CScheduledFunction@ pFunctionGrinder4 = null;
CScheduledFunction@ pFunctionGrinder5 = null;
CScheduledFunction@ pFunctionGrinder6 = null;
CScheduledFunction@ pFunctionMixer1 = null;
CScheduledFunction@ pFunctionMixer2 = null;
CScheduledFunction@ pFunctionMixer3 = null;
CScheduledFunction@ pFunctionMixer4 = null;
CScheduledFunction@ pFunctionMixer5 = null;
CScheduledFunction@ pFunctionMixer6 = null;
CScheduledFunction@ pFunctionPacking = null;
CScheduledFunction@ pFunctionPackingBarrels = null;

CScheduledFunction@ roboTimer = null;
int roboTimerCounter = 0;
CScheduledFunction@ hudUpdater = null;

bool ToggleGuide( CBasePlayer@ pPlayer )
{
	bool bActive = false;
	float fLastTime = 0.0f;
	
	dictionary@ userData = pPlayer.GetUserData();
	if ( userData is null )
		return false;
		
	if ( userData.exists( GUIDE_ACT_TIME ) )
		fLastTime = float( userData[ GUIDE_ACT_TIME ] );
	
	if ( userData.exists( GUIDE_STATE ) )
		bActive = bool( userData[ GUIDE_STATE ] );
	
	if ( ( g_Engine.time - fLastTime ) < MIN_GUIDE_DELAY )
		return false;
	
	//g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK,
	//	bActive ? "Hiding guide" : "Showing guide" );
		
	g_EntityFuncs.FireTargets( "manual_camera", pPlayer, pPlayer,
		bActive ? USE_OFF : USE_ON );

	pPlayer.GetUserData().set( GUIDE_ACT_TIME, g_Engine.time );
	pPlayer.GetUserData().set( GUIDE_STATE, !bActive );
	
	return true;
}

HookReturnCode PlayerPostThink( CBasePlayer@ pPlayer )
{
	// Camera shows guide if keys match
	if ( difficultyChosen && ( pPlayer.pev.button & GUIDE_ACT_KEY ) != 0 )
	{
		ToggleGuide( pPlayer );
	}
	
	return HOOK_CONTINUE;
}

string convertMachineID(string id) //hacky bullshit because i switched numbers of grinders
{
	int intID = atoi(id);
	switch( intID )
	{
	case 1:
		return "4";
	case 2:	
		return "5";
	case 3:
		return "6";
	case 4:
		return "1";
	case 5:	
		return "2";
	case 6:		
		return "3";
	}	
	
	g_Game.AlertMessage(at_console, "Something is bad in convertMachineID");	
	return 99;	
}
int convertMachineIDInteger(int id) //hacky bullshit because i switched numbers of grinders
{
	switch( id )
	{
	case 1:
		return 4;
	case 2:	
		return 5;
	case 3:
		return 6;
	case 4:
		return 1;
	case 5:	
		return 2;
	case 6:		
		return 3;
	}	
	

	g_Game.AlertMessage(at_console, "Something is bad in convertMachineIDInteger");	
	return 99;
	
}

void roboFunction()
{
	CBaseEntity@ foundRobots = g_EntityFuncs.FindEntityByTargetname(null, "live_robo");
	int countedRobots = 0;

	while (foundRobots !is null)
	{
		countedRobots++;
		@foundRobots = g_EntityFuncs.FindEntityByTargetname(@foundRobots, "live_robo");
	}
	//g_Game.AlertMessage(at_console, countedRobots);
	if (countedRobots < 5 ) {
		if (roboTimerCounter != 5) {
			roboTimerCounter += 1;
				
			if (roboTimerCounter == 1) 
				g_EntityFuncs.FireTargets( 'robolight1', null, null, USE_ON, 0.0f, 0.0f );
			else if (roboTimerCounter == 2) 
				g_EntityFuncs.FireTargets( 'robolight2', null, null, USE_ON, 0.0f, 0.0f );
			else if (roboTimerCounter == 3) 
				g_EntityFuncs.FireTargets( 'robolight3', null, null, USE_ON, 0.0f, 0.0f );
			else if (roboTimerCounter == 4) 
				g_EntityFuncs.FireTargets( 'robolight4', null, null, USE_ON, 0.0f, 0.0f );		
			else if (roboTimerCounter == 5) {
				g_EntityFuncs.FireTargets( 'robolight5', null, null, USE_ON, 0.0f, 0.0f );	
				g_EntityFuncs.FireTargets( 'robo_master_r', null, null, USE_TOGGLE, 0.0f, 0.0f );	
				g_EntityFuncs.FireTargets( 'robo_greenlight', null, null, USE_ON, 0.0f, 0.0f );	
			}			
		}
	}
}

void releaseRobo(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	roboTimerCounter = 0;
	g_EntityFuncs.FireTargets( 'robolight1', null, null, USE_OFF, 0.0f, 0.0f );	
	g_EntityFuncs.FireTargets( 'robolight2', null, null, USE_OFF, 0.0f, 0.0f );	
	g_EntityFuncs.FireTargets( 'robolight3', null, null, USE_OFF, 0.0f, 0.0f );	
	g_EntityFuncs.FireTargets( 'robolight4', null, null, USE_OFF, 0.0f, 0.0f );	
	g_EntityFuncs.FireTargets( 'robolight5', null, null, USE_OFF, 0.0f, 0.0f );		
	g_EntityFuncs.FireTargets( 'robo_greenlight', null, null, USE_OFF, 0.0f, 0.0f );	
	g_EntityFuncs.FireTargets( 'robo_master_r', null, null, USE_TOGGLE, 0.0f, 8.9f );
	g_EntityFuncs.FireTargets( 'robo_door', null, null, USE_ON, 0.0f, 9.0f );	
	g_EntityFuncs.FireTargets( 'random_robo', null, null, USE_ON, 0.0f, 9.0f );	
	
	g_EntityFuncs.FireTargets( 'roboconstructsound', null, null, USE_ON, 0.0f, 0.0f );	
	g_EntityFuncs.FireTargets( 'roboconveyor', null, null, USE_ON, 0.0f, 9.0f );	
	g_EntityFuncs.FireTargets( 'roboconveyor', null, null, USE_OFF, 0.0f, 12.0f );	
}

void hudUpdate()
{
	int packingPrepped;
	int packingUnprepped;
	
	if (packingBarrelsAddedInt == 4 || ((difficultySetting == 'beginner' || difficultySetting == 'easy') && packingBarrelsAddedInt == 2 )) {
		packingPrepped = 1;
		packingUnprepped = 0;
	}
	else {
		packingPrepped = 0;
		packingUnprepped = 1;	
	}
	
	//string pText1 = "Mustard produced: " + mustardProduced + "\n\n" ;
	string pText2 = "Empty|Prepped|Active|Done\n" ;
	string pText3 = "Grinding: " + emptyGrinders + "|" + preppedGrinders + "|" + activeGrinders + "|" + completedGrinders + "\n" ;
	string pText4 = "Mixing: " + emptyMixers + "|" + preppedMixers + "|" + activeMixers + "|" + totalMixesReady + "\n" ;
	string pText5 = "Packing: " + packingUnprepped + "|" + packingPrepped + "|" + mixesBeingProcessed + "|" + mustardProduced ;

	
	//string productionText = pText1 + pText2 + pText3 + pText4 + pText5;
	string productionText = pText2 + pText3 + pText4 + pText5;
	
	HUDTextParams txtPrms;

	txtPrms.x = 0.0;	// Position X
	txtPrms.y = 0.35; // Position Y
	txtPrms.effect = 0; // Effect

	//Text colour
	txtPrms.r1 = 245; // Amount of red
	txtPrms.g1 = 196; // Amount of green
	txtPrms.b1 = 46; // Amount of blue
	txtPrms.a1 = 0; // Alpha Amount

	//fade-in colour
	txtPrms.r2 = 245;
	txtPrms.g2 = 196;
	txtPrms.b2 = 46;
	txtPrms.a2 = 0;

	txtPrms.fadeinTime = 0.0f;
	txtPrms.fadeoutTime = 0.0f;
	txtPrms.holdTime = 2;
	txtPrms.fxTime = 0.25f;
	txtPrms.channel = 1;

	g_PlayerFuncs.HudMessageAll(txtPrms, productionText); // send the message!
	
	//todo: the active number for packing should show the amount of mixes being processed!

	
	string riftText = "Active rifts: " + activeRiftsCounter;
	
	txtPrms.x = 0.9;	// Position X
	txtPrms.y = 0.35; // Position Y	
	txtPrms.effect = 0; // Effect

	//Text colour
	txtPrms.r1 = 245; // Amount of red
	txtPrms.g1 = 0; // Amount of green
	txtPrms.b1 = 0; // Amount of blue
	txtPrms.a1 = 0; // Alpha Amount

	//fade-in colour
	txtPrms.r2 = 245;
	txtPrms.g2 = 0;
	txtPrms.b2 = 0;
	txtPrms.a2 = 0;	
	txtPrms.channel = 3;

	if (firstRiftAppeared == true) 
	    g_PlayerFuncs.HudMessageAll(txtPrms, riftText); // send the message!
	
	txtPrms.x = -1;	// Position X
	txtPrms.y = 0.05; // Position Y	
	txtPrms.channel = 4;
	
	string sabotageText;
	
	if (suddenDeath == true) 
		sabotageText += "Rapid rift expansion - failure imminent\n" ;  	
	if (brokenGrinderCount > 0) 
		sabotageText += "Grinders broken: " + brokenGrinderCount + "\n";
	if (brokenMixerCount > 0)
		sabotageText += "Mixers broken: " + brokenMixerCount + "\n" ; 
	if (brokenPackingMachines > 0) 
		sabotageText += "Packing is broken\n" ;  
	if (generatorBroken == true) 
		sabotageText += "Generator is broken\n" ;  
	if (activeBuddyEvent == true) 
		sabotageText += "Core pool is being drained\n" ;  
	if (activeBoss == true) 
		sabotageText += "Extreme danger in Core" ;  	
			
//the text should show how many valvesh ave been turned
	
	g_PlayerFuncs.HudMessageAll(txtPrms, sabotageText); // send the message!
}


// sends a message all players
// Technically, this is a game_text
void dsplmsg(string&in msg,float htime,string color)
{
	HUDTextParams txtPrms;

	txtPrms.x = -1;	// Position X
	txtPrms.y = 0.40; // Position Y
	txtPrms.effect = 0; // Effect


	if (color == 'yellow')
	{
		//Text colour
		txtPrms.r1 = 245; // Amount of red
		txtPrms.g1 = 196; // Amount of green
		txtPrms.b1 = 46; // Amount of blue
		txtPrms.a1 = 0; // Alpha Amount

		//fade-in colour
		txtPrms.r2 = 245;
		txtPrms.g2 = 196;
		txtPrms.b2 = 46;
		txtPrms.a2 = 0;
	}
	else if (color == 'red')
	{
		//Text colour
		txtPrms.r1 = 255; // Amount of red
		txtPrms.g1 = 0; // Amount of green
		txtPrms.b1 = 0; // Amount of blue
		txtPrms.a1 = 0; // Alpha Amount

		//fade-in colour
		txtPrms.r2 = 255;
		txtPrms.g2 = 0;
		txtPrms.b2 = 0;
		txtPrms.a2 = 0;
	}
	
	txtPrms.fadeinTime = 0.01f;
	txtPrms.fadeoutTime = 1.5f;
	txtPrms.holdTime = htime;
	txtPrms.fxTime = 0.25f;
	txtPrms.channel = 2;

	g_PlayerFuncs.HudMessageAll(txtPrms, msg); // send the message!
}


void MapInit() //cannot trigger map entities in mapinit
{

	precacheSounds();

	g_Hooks.RegisterHook( Hooks::Player::PlayerPostThink, @PlayerPostThink );

	// Register custom weapons
	THWeaponSawedoff::Register();
	THWeaponM1911::Register();
	THWeaponThompson::Register();
	THWeaponTeslagun::Register();
	THWeaponSpanner::Register();

	//just for testing mixing
	//activeSabotageCounter = 4;
	//activeSabotage[0] = 1;
	//activeSabotage[1] = 1;
	//activeSabotage[4] = 1;
	//activeSabotage[5] = 1;

	//g_Game.AlertMessage(at_console, "MapInit done gone donned");

	grinder[1].set('state','default');
	grinder[1].set('locked',false);
	grinder[2].set('state','default');
	grinder[2].set('locked',false);
	grinder[3].set('state','default');
	grinder[3].set('locked',false);
	grinder[4].set('state','default');
	grinder[4].set('locked',false);
	grinder[5].set('state','default');
	grinder[5].set('locked',false);
	grinder[6].set('state','default');
	grinder[6].set('locked',false);	
	grinder[1].set('brokenState','working');
	grinder[2].set('brokenState','working');
	grinder[5].set('brokenState','working');
	grinder[6].set('brokenState','working');
	grinder[3].set('brokenState','working');
	grinder[4].set('brokenState','working');

	mixer[1].set('state','default');
	mixer[1].set('locked',false);
	mixer[2].set('state','default');
	mixer[2].set('locked',false);	
	mixer[3].set('state','default');
	mixer[3].set('locked',false);
	mixer[4].set('state','default');
	mixer[4].set('locked',false);
	mixer[5].set('state','default');
	mixer[5].set('locked',false);
	mixer[6].set('state','default');
	mixer[6].set('locked',false);	
	mixer[1].set('brokenState','working');
	mixer[2].set('brokenState','working');
	mixer[5].set('brokenState','working');
	mixer[6].set('brokenState','working');
	mixer[3].set('brokenState','working');
	mixer[4].set('brokenState','working');	

	ResetBarrelEffectCounters();
	
	packing.set('state','default');
	packing.set('brokenState','working'); 
	//packing[1].set('locked',false);
}

void MapStart()
{
	g_EntityFuncs.FireTargets('grinder1_chute_lock_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets('grinder2_chute_lock_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets('grinder3_chute_lock_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets('grinder4_chute_lock_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets('grinder5_chute_lock_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets('grinder6_chute_lock_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets('mixer1_chute_lock_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets('mixer2_chute_lock_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets('mixer3_chute_lock_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets('mixer4_chute_lock_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets('mixer5_chute_lock_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets('mixer6_chute_lock_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets('packing1_chute_lock_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets('packing2_chute_lock_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'bossmonsterclip', null, null, USE_OFF, 0.0f, 0.0f );
	
	g_EntityFuncs.FireTargets( 'voice_5_m_r', null, null, USE_TOGGLE, 0.0f, 0.0f ); //enable trigger for grinding instructions
	g_EntityFuncs.FireTargets( 'voice_13_m_r', null, null, USE_TOGGLE, 0.0f, 0.0f ); //enable trigger for mixing instructions
	
	
	g_EntityFuncs.FireTargets( 'difficulty_vote_r', null, null, USE_TOGGLE, 0.0f, 15.0f );
	
	//g_Scheduler.SetTimeout( "activateTrackOneEvent", 10 );
	

	resetTrackOneCounter();
	resetTrackTwoCounter();
	
	//g_EntityFuncs.FireTargets('spawningpool_start', null, null, USE_TOGGLE, 0.0f, 300.0f );

	activateGlowShells(); //glow shells on items in storage
			
}

void setGrinderChuteLock(string id, bool stateToSet)
{
	int idInt = atoi(id);
	
	bool currentState;
	grinder[idInt].get('locked', currentState );
	// if (currentState != stateToSet)
	// {
		// string entityName = 'grinder' + id + '_chute_lock_r';
		// g_EntityFuncs.FireTargets(entityName, null, null, USE_TOGGLE, 0.0f, 0.0f );
	// }

	grinder[idInt].set('locked',stateToSet);

	CBaseEntity@ grinderChute = g_EntityFuncs.FindEntityByTargetname(null, 'grinder' + id + '_input_trigger'); 
	
	
	// if (stateToSet == true)
	// {
		// g_EntityFuncs.DispatchKeyValue( grinderChute.edict(), "targetname", "x" );			
	// }
	// else
	// {
		// g_EntityFuncs.DispatchKeyValue( grinderChute.edict(), "targetname", "grinder_fill_input" );	
	// }
	
	
	if (stateToSet == true)
	{
		g_EntityFuncs.DispatchKeyValue( grinderChute.edict(), "target", "x" );
		g_EntityFuncs.DispatchKeyValue( grinderChute.edict(), "pass_return_item_name", "x" );			
	}
	else
	{
		g_EntityFuncs.DispatchKeyValue( grinderChute.edict(), "target", "grinder_fill_input" );	
		g_EntityFuncs.DispatchKeyValue( grinderChute.edict(), "pass_return_item_name", "mustard_seeds" );
	}


}


void workBegins(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	//function called when switch is flipped
	
	
	CBaseEntity@ voice_3_lobby = g_EntityFuncs.FindEntityByTargetname(null, 'voice_3_lobby'); //null means find the first entity with the targetname
	g_EntityFuncs.Remove( voice_3_lobby );
	
	dictionary voiceLine = cast<dictionary>( voiceList['4_switchflipped'] );
	// addDictionaryToQueue(voiceLine);
	g_Scheduler.SetTimeout( "addDictionaryToQueue", 1, voiceLine );
	switchFlipped = true;
	
	dsplmsg("Generator has been turned to full power.", 3.0f, "yellow"); //text message and hold time	


	g_EntityFuncs.FireTargets( 'supply_gates', null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'supply_gates_incore', null, null, USE_ON, 0.0f, 0.0f );
	
	g_EntityFuncs.FireTargets( 'generator_beams', null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'generator_sound', null, null, USE_OFF, 0.0f, 0.0f );
	CBaseEntity@ generatorSound = g_EntityFuncs.FindEntityByTargetname(null, 'generator_sound'); //null means find the first entity with the targetname
	g_EntityFuncs.DispatchKeyValue( generatorSound.edict(), "health", 8 );		
	g_EntityFuncs.FireTargets( 'generator_sound', null, null, USE_ON, 0.0f, 0.1f );
	
	@workTimeInterval = g_Scheduler.SetInterval( "workTimer", 1, g_Scheduler.REPEAT_INFINITE_TIMES);
	
}

void workTimer()
{
	workTimeAccumulated++;
	if (suddenDeath == false and workTimeAccumulated >= 2400 and ((mustardProduced < 9 and mustardGoal == 16) or  (mustardProduced < 5 and mustardGoal == 8))      ) {
		@pFunctionTrackTwoFastMaker2 = g_Scheduler.SetInterval( "trackTwoFastMaker", 60, g_Scheduler.REPEAT_INFINITE_TIMES); //rifts go bad twice as fast)
		suddenDeath = true;
	}
	
	if ( firstPackWarning == false && mustardProduced + mixesBeingProcessed == 0 && workTimeAccumulated > 900) { //15 minutes warning
		dictionary voiceLine = cast<dictionary>( voiceList['43_reminderhandbook'] );
		addDictionaryToQueue(voiceLine);
		firstPackWarning = true;
	}	
	else if (secondPackWarning == false && mustardProduced + mixesBeingProcessed == 0 && workTimeAccumulated > 1500) { //25 minutes warning
		dictionary voiceLine = cast<dictionary>( voiceList['44_reminderhandbook2'] );
		addDictionaryToQueue(voiceLine);	
		secondPackWarning = true;	
	}
}



void grinderFillInput(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	//g_Game.AlertMessage(at_console, "grinderFillInput triggered");
	// string gzp_TName = pCaller.GetTargetname(); //"i use that in the portal map script and it returns the targetname of the game_zone_player"

	if (firstInputDone == false) {
		firstInputDone = true;
		beginTrackCountdown();
	}


	CustomKeyvalues@ customKeyvalues = pCaller.GetCustomKeyvalues();
    string idKeyValue = customKeyvalues.GetKeyvalue("$s_grinder_id").GetString();
		
	//g_Game.AlertMessage(at_console,"STUFF TO CONSOLE HERE: %1",idKeyValue);
	g_EntityFuncs.FireTargets( 'grinder_fillsound' + idKeyValue, null, null, USE_TOGGLE, 0.0f, 0.0f ); //the first 0.0f just needs to be there, the second is the delay
	g_EntityFuncs.FireTargets( 'grinder_light_green_a' + idKeyValue, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grinder_light_green_b' + idKeyValue, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grinder_light_yellow' + idKeyValue, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grinder_seeds' + idKeyValue, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grinder_seedshurt' + idKeyValue, null, null, USE_ON, 0.0f, 0.0f );

	int idInt = atoi(idKeyValue);
	grinder[idInt].set('state','inputAdded');	
	emptyGrinders--;
	preppedGrinders++;
	//grinder[idKeyValue]('state') = 'inputAdded';
	setGrinderChuteLock(idKeyValue,true);
}

void grinderCheckSeeds(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{	
	CustomKeyvalues@ customKeyvalues = pCaller.GetCustomKeyvalues();
    string idKeyValue = customKeyvalues.GetKeyvalue("$s_grinder_id").GetString();
	
		//g_Game.AlertMessage(at_console,"grinderCheckSeeds: %1",idKeyValue);
	
	int idInt = atoi(idKeyValue);
	string state;
	grinder[idInt].get('state',state); //grabs the state and shoves it in the variable apparently
	string brokenState;
	grinder[idInt].get('brokenState',brokenState); //grabs the state and shoves it in the variable apparently	
		//g_Game.AlertMessage(at_console, "grinderCheckSeeds: %1",state);
	if (state == 'inputAdded' && brokenState == 'working')
	{
		grinderBeginGrind(idKeyValue);
	}
	else
	{
	g_EntityFuncs.FireTargets( 'grinder_lockedbtnsound' + idKeyValue, null, null, USE_TOGGLE, 0.0f, 0.0f );
	}
}

void grinderBeginGrind(string id)
{
	int idInt = atoi(id);
		//g_Game.AlertMessage(at_console, "grinderBeginGrind triggered %1",id);
		
		
	//readd the target to the path_corner
	string pathCorner = "grinder" + id + "_a";
	string pathCornerTarget = "grinder" + id + "_b";
	CBaseEntity@ grinderPathCorner = g_EntityFuncs.FindEntityByTargetname(null, pathCorner); //null means find the first entity with the targetname
	g_EntityFuncs.DispatchKeyValue( grinderPathCorner.edict(), "target", pathCornerTarget );
			
		
	grinder[idInt].set('state','active');
	preppedGrinders--;
	activeGrinders++;
	//grinder[id]('state') = 'active';
	g_EntityFuncs.FireTargets( 'grinder' + id, null, null, USE_TOGGLE, 0.0f, 0.5f );
	g_EntityFuncs.FireTargets( 'grinder_light_green_a' + id, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grinder_light_green_b' + id, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grinder_light_yellow' + id, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grinder_light_red' + id, null, null, USE_OFF, 0.0f, 0.0f );
	
	switch( idInt )
	{
	case 1:
		@pFunctionGrinder1 = g_Scheduler.SetInterval( "grinderCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES, id);
		break;
	case 2:	
		@pFunctionGrinder2 = g_Scheduler.SetInterval( "grinderCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES, id);
		break;	
	case 3:
		@pFunctionGrinder3 = g_Scheduler.SetInterval( "grinderCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES, id);
		break;	
	case 4:
		@pFunctionGrinder4 = g_Scheduler.SetInterval( "grinderCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES, id);
		break;
	case 5:	
		@pFunctionGrinder5 = g_Scheduler.SetInterval( "grinderCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES, id);
		break;	
	case 6:
		@pFunctionGrinder6 = g_Scheduler.SetInterval( "grinderCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES, id);
		break;			
	}

}

void grinderCountDown(string id)
{
	int idInt = atoi(id);
	
	string brokenState;
	grinder[idInt].get('brokenState',brokenState); //grabs the state and shoves it in the variable apparently
	if (brokenState == 'broken') {
		CScheduledFunction@ pFunctionGrinder = g_Scheduler.GetCurrentFunction(); //gets the one out of 6 grinder schedules that is being used here
		g_Scheduler.RemoveTimer( pFunctionGrinder );
		@pFunctionGrinder = null;
	}
	else {
		grinderCounter[idInt] -= 1;	
	}
	
		//g_Game.AlertMessage(at_console, "grinderCountDown. id is %1",idInt);
		//g_Game.AlertMessage(at_console, "grinderCountDown. Counter is %1",grinderCounter[idInt]);

	if (grinderCounter[idInt] == 0)
	{
		CScheduledFunction@ pFunctionGrinder = g_Scheduler.GetCurrentFunction();
		g_Scheduler.RemoveTimer( pFunctionGrinder );
		@pFunctionGrinder = null;
	
		grinderCounter[idInt] = grinderCounterTime;
	
		completeGrind(id);
	}
}

void completeGrind(string id)
{
	//g_Game.AlertMessage(at_console, "completeGrind triggered %1",id);
	
	int idInt = atoi(id);	
	grinder[idInt].set('state','completed');
	activeGrinders--;
	completedGrinders++;
	
	string pathCorner = "grinder" + id + "_a";
	
	CBaseEntity@ grinderPathCorner = g_EntityFuncs.FindEntityByTargetname(null, pathCorner); //null means find the first entity with the targetname
	g_EntityFuncs.DispatchKeyValue( grinderPathCorner.edict(), "target", "not_an_entity" );
	
	g_EntityFuncs.FireTargets( 'grinder_light_green_a' + id, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grinder_light_green_b' + id, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grinder_light_yellow' + id, null, null, USE_OFF, 0.0f, 0.0f );	
	
	g_EntityFuncs.FireTargets( 'mixer_light_green_c' + convertMachineID(idInt), null, null, USE_ON, 0.0f, 0.0f );

	
	g_EntityFuncs.FireTargets( 'machinedonesound', null, null, USE_ON, 0.0f, 0.0f );
	//g_EntityFuncs.FireTargets( 'grinderdone_txt', null, null, USE_ON, 0.0f, 0.0f );
}

void emptyGrinder(string id)
{
	//g_Game.AlertMessage(at_console, "emptyGrinder triggered %1",id);
	
	string pathCornerToChange = "grinder" + id + "_a";
	string pathCornerToChangeTo = "grinder" + id + "_b";
	CBaseEntity@ grinderPathCorner = g_EntityFuncs.FindEntityByTargetname(null, pathCornerToChange); //null means find the first entity with the targetname
	g_EntityFuncs.DispatchKeyValue( grinderPathCorner.edict(), "target", pathCornerToChangeTo );	
	
	int idInt = atoi(id);	
	grinder[idInt].set('state','default');	
	emptyGrinders++;
	completedGrinders--;
	setGrinderChuteLock(id,false);
	g_EntityFuncs.FireTargets( 'grinder_light_green_a' + id, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grinder_light_green_b' + id, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grinder_seeds' + id, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grinder_seedshurt' + id, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grinder' + id, null, null, USE_TOGGLE, 0.0f, 0.0f ); //it must be stopped before starting it again
	//g_EntityFuncs.FireTargets( 'grinder_seeds_removesound' + id, null, null, USE_ON, 0.0f, 0.0f );	
}

void setMixerChuteLock(string id, bool stateToSet)
{
	int idInt = atoi(id);
	
	
	
	bool currentState;
	mixer[idInt].get('locked', currentState );
	// if (currentState != stateToSet)
	// {
		// string entityName = 'mixer' + id + '_chute_lock_r';
		// g_EntityFuncs.FireTargets(entityName, null, null, USE_TOGGLE, 0.0f, 0.0f );
	// }
	
	mixer[idInt].set('locked',stateToSet);
	
	CBaseEntity@ mixerChute = g_EntityFuncs.FindEntityByTargetname(null, 'mixer' + id + '_input_trigger'); 
		
	
	if (stateToSet == true)
	{
		g_EntityFuncs.DispatchKeyValue( mixerChute.edict(), "target", "x" );
		g_EntityFuncs.DispatchKeyValue( mixerChute.edict(), "pass_return_item_name", "x" );			
	}
	else
	{
		g_EntityFuncs.DispatchKeyValue( mixerChute.edict(), "target", "mixer_fill_input" );		
		g_EntityFuncs.DispatchKeyValue( mixerChute.edict(), "pass_return_item_name", "ingredients" );	
	}	
}

void mixerFillInput(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	//g_Game.AlertMessage(at_console, "mixerFillInput triggered");

	if (firstInputDone == false) {
		firstInputDone = true;
		beginTrackCountdown();
	}

	CustomKeyvalues@ customKeyvalues = pCaller.GetCustomKeyvalues();
    string idKeyValue = customKeyvalues.GetKeyvalue("$s_mixer_id").GetString();
		
	//g_Game.AlertMessage(at_console,"STUFF TO CONSOLE HERE: %1",idKeyValue);
	g_EntityFuncs.FireTargets( 'mixer_fillsound' + idKeyValue, null, null, USE_TOGGLE, 0.0f, 0.0f ); //0.0f just needs to be there, 0.1f is the delay
	g_EntityFuncs.FireTargets( 'mixer_light_green_a' + idKeyValue, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_light_green_b' + idKeyValue, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_light_yellow' + idKeyValue, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_ingredients' + idKeyValue, null, null, USE_ON, 0.0f, 0.0f );
	
	
	int idInt = atoi(idKeyValue);
	mixer[idInt].set('state','inputAdded');	
	emptyMixers--;
	preppedMixers++;
	

	
	setMixerChuteLock(idKeyValue,true);
}

void mixerCheck(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	//g_Game.AlertMessage(at_console, "mixerCheck triggered");
	CustomKeyvalues@ customKeyvalues = pCaller.GetCustomKeyvalues();
    string idKeyValue = customKeyvalues.GetKeyvalue("$s_mixer_id").GetString();

	//g_Game.AlertMessage(at_console,"mixerCheck: %1",idKeyValue);
	
	int idInt = atoi(idKeyValue);
	string stateMixer;
	string stateGrinder;
	string brokenStateMixer;
	
	mixer[idInt].get('state',stateMixer); //grabs the state and shoves it in the variable apparently
	grinder[convertMachineIDInteger(idInt)].get('state',stateGrinder); //grabs the state and shoves it in the variable apparently
	
	
	
	mixer[idInt].get('brokenState',brokenStateMixer); //grabs the state and shoves it in the variable apparently

	//g_Game.AlertMessage(at_console,"stateMixer: %1",stateMixer);
	//g_Game.AlertMessage(at_console,"stateGrinder: %1",stateGrinder);
	
	//g_Game.AlertMessage(at_console,"mixerCheck: %1",idKeyValue);
	
	if (stateMixer == 'inputAdded' && stateGrinder == 'completed' && brokenStateMixer == 'working' )
	{
		mixerBeginMix(idKeyValue);
	}
	else
	{
		g_EntityFuncs.FireTargets( 'mixer_lockedbtnsound' + idKeyValue, null, null, USE_TOGGLE, 0.0f, 0.0f );
	}
}

void mixerBeginMix(string id)
{
	int idInt = atoi(id);
	//g_Game.AlertMessage(at_console, "mixerBeginMix triggered %1",id);
				
	mixer[idInt].set('state','active');
	preppedMixers--;
	activeMixers++;
	g_EntityFuncs.FireTargets( 'mixer' + id, null, null, USE_ON, 0.0f, 8.0f );  //the first 0.0f just needs to be there, the second is the delay
	g_EntityFuncs.FireTargets( 'mixer_liquid' + id, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_fill_all' + id, null, null, USE_ON, 0.0f, 0.0f ); //the sound for inserting water and seeds
		
	string mixerStreamsName = "mixer_streams" + id;	
	CBaseEntity@ mixerStreams = g_EntityFuncs.FindEntityByTargetname(null, mixerStreamsName); //null means find the first entity with the targetname
	mixerStreams.pev.renderamt = 255;
	mixerStreams.pev.skin = -7;
	mixerStreamsName = "mixer_streams_w" + id;	
	CBaseEntity@ mixerStreams2 = g_EntityFuncs.FindEntityByTargetname(null, mixerStreamsName); //null means find the first entity with the targetname
	mixerStreams2.pev.renderamt = 120;
	mixerStreams2.pev.skin = -7;	
		
	g_EntityFuncs.FireTargets( 'mixer_ingredients' + id, null, null, USE_OFF, 0.0f, 0.0f );
	
	g_EntityFuncs.FireTargets( 'waterfall' + id, null, null, USE_ON, 0.0f, 0.0f );
	
	//g_Scheduler.SetTimeout( "removeStream", 10.0f, id );
	g_EntityFuncs.FireTargets( 'mixer_light_green_a' + id, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_light_green_b' + id, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_light_yellow' + id, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_light_red' + id, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_light_green_c' + id, null, null, USE_OFF, 0.0f, 0.0f ); //turn off pipelight, because it might be added again after it is completed
	
	
	
	emptyGrinder(convertMachineID(id));

	switch( idInt )
	{
	case 1:
		@pFunctionMixer1 = g_Scheduler.SetInterval( "mixerCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES, id);
		break;
	case 2:	
		@pFunctionMixer2 = g_Scheduler.SetInterval( "mixerCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES, id);
		break;	
	case 3:
		@pFunctionMixer3 = g_Scheduler.SetInterval( "mixerCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES, id);
		break;	
	case 4:
		@pFunctionMixer4 = g_Scheduler.SetInterval( "mixerCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES, id);
		break;	
	case 5:
		@pFunctionMixer5 = g_Scheduler.SetInterval( "mixerCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES, id);
		break;	
	case 6:
		@pFunctionMixer6 = g_Scheduler.SetInterval( "mixerCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES, id);
		break;			
	}
}


void removeStream(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
	//g_Game.AlertMessage(at_console, "removeStream triggered");
	CustomKeyvalues@ customKeyvalues = pCaller.GetCustomKeyvalues();
    string idKeyValue = customKeyvalues.GetKeyvalue("$s_mixer_id").GetString();

	string mixerStreamsName = "mixer_streams" + idKeyValue;	
	CBaseEntity@ mixerStreams = g_EntityFuncs.FindEntityByTargetname(null, mixerStreamsName); //null means find the first entity with the targetname
	mixerStreams.pev.renderamt = 0;
	mixerStreams.pev.skin = -1;	
	mixerStreamsName = "mixer_streams_w" + idKeyValue;	
	CBaseEntity@ mixerStreams2 = g_EntityFuncs.FindEntityByTargetname(null, mixerStreamsName); //null means find the first entity with the targetname
	mixerStreams2.pev.renderamt = 0;
	mixerStreams2.pev.skin = -1;		
	
	g_EntityFuncs.FireTargets( 'waterfall' + idKeyValue, null, null, USE_OFF, 0.0f, 0.0f );
}

void mixerCountDown(string id)
{
	int idInt = atoi(id);
	
	
	
	string brokenState;
	mixer[idInt].get('brokenState',brokenState); //grabs the state and shoves it in the variable apparently
	if (brokenState == 'broken') {
		CScheduledFunction@ pFunctionMixer = g_Scheduler.GetCurrentFunction();
		g_Scheduler.RemoveTimer( pFunctionMixer );
		@pFunctionMixer = null;
	}
	else {
		mixerCounter[idInt] -= 1;
	}

	//g_Game.AlertMessage(at_console, "mixerCountDown. id is %1",idInt);
	//g_Game.AlertMessage(at_console, "mixerCountDown. Counter is %1",mixerCounter[idInt]);

	if (mixerCounter[idInt] == 0)
	{
		CScheduledFunction@ pFunctionMixer = g_Scheduler.GetCurrentFunction();
		g_Scheduler.RemoveTimer( pFunctionMixer );
		@pFunctionMixer = null;

		mixerCounter[idInt] = mixerCounterTime;
	
		completeMix(id);
	}
}

void completeMix(string id)
{
	//g_Game.AlertMessage(at_console, "completeMix triggered %1",id);
	
	int idInt = atoi(id);	
	mixer[idInt].set('state','completed');
	activeMixers--;
	
	totalMixesReady += 1;
	
	g_EntityFuncs.FireTargets( 'mixer' + id, null, null, USE_OFF, 0.0f, 8.0f );  //the first 0.0f just needs to be there, the second is the delay
	g_EntityFuncs.FireTargets( 'mixer_light_green_a' + id, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_light_green_b' + id, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_light_yellow' + id, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_light_red' + id, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'packing_light_green_a' + id, null, null, USE_ON, 0.0f, 0.0f );
	
	g_EntityFuncs.FireTargets( 'machinedonesound', null, null, USE_ON, 0.0f, 0.0f );
	// g_EntityFuncs.FireTargets( 'mixerdone_txt', null, null, USE_ON, 0.0f, 0.0f );
}


void setPackingChuteLock(string id, bool stateToSet)
{
	int idInt = atoi(id);
	bool state;
	
	if (id == "1")
	{
		state = packingLock1;
	}
	else
	{
		state = packingLock2;
	}

	if (state != stateToSet)
	{
		string entityName = 'packing' + id + '_chute_lock_r';
		g_EntityFuncs.FireTargets(entityName, null, null, USE_TOGGLE, 0.0f, 0.0f );
	}
	
	if (id == "1")
	{
		packingLock1 = stateToSet;
	}
	else
	{
		packingLock2 = stateToSet;
	}	
}


void packingFillInput(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	//g_Game.AlertMessage(at_console, "packingFillInput triggered");

	if (firstInputDone == false) {
		firstInputDone = true;
		beginTrackCountdown();
	}

	CustomKeyvalues@ customKeyvalues = pCaller.GetCustomKeyvalues();
    string idKeyValue = customKeyvalues.GetKeyvalue("$s_packing_id").GetString();
	
	g_EntityFuncs.FireTargets( 'packing_fillsound' + idKeyValue, null, null, USE_TOGGLE, 0.0f, 0.0f );

	string idLetter;
	if (idKeyValue == "1")
	{
		idLetter = "b";		
		string packingBarrelCounterBString = packingBarrelCounterB + 1; 
		g_EntityFuncs.FireTargets( 'packing_light_green_' + idLetter + packingBarrelCounterBString, null, null, USE_ON, 0.0f, 0.0f );
		packingBarrelCounterB += 1;		
	}	
	else
	{
		idLetter = "c";
		string packingBarrelCounterCString = packingBarrelCounterC + 1; 
		g_EntityFuncs.FireTargets( 'packing_light_green_' + idLetter + packingBarrelCounterCString, null, null, USE_ON, 0.0f, 0.0f );
		packingBarrelCounterC += 1;		
	}

	//packingBarrelsAdded[idInt] = true; //not used
	packingBarrelsAddedInt += 1;
	
	if (packingBarrelsAddedInt == 4 || ((difficultySetting == 'beginner' || difficultySetting == 'easy') && packingBarrelsAddedInt == 2 ) )	
	{
		g_EntityFuncs.FireTargets( 'packing_light_green_input', null, null, USE_ON, 0.0f, 0.0f ); //turn on input light in control room
	}
	
	if (packingBarrelCounterB > 1 || ((difficultySetting == 'beginner' || difficultySetting == 'easy') && packingBarrelCounterB > 0 )  ) //lock if there are two inserted, or 1 inserted on lower difficulty
	{	
		setPackingChuteLock("1",true);
	}
	if (packingBarrelCounterC > 1 || ((difficultySetting == 'beginner' || difficultySetting == 'easy') && packingBarrelCounterC > 0 ) )
	{	
		setPackingChuteLock("2",true);
	}	
}

void packingCheck(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	//g_Game.AlertMessage(at_console, "packingCheck triggered");
	
	string statePacking;
	packing.get('state',statePacking); //grabs the state and shoves it in the variable 
	
	string brokenState;
	packing.get('brokenState',brokenState); //grabs the state and shoves it in the variable 

	
	if (packingBarrelsAddedInt == 4 and totalMixesReady > 0 and statePacking == 'default' and brokenState == 'working')
	{
		beginPacking();
	}
	else if ((difficultySetting == 'beginner' || difficultySetting == 'easy') and packingBarrelsAddedInt == 2 and totalMixesReady > 0 and statePacking == 'default' and brokenState == 'working') {
		beginPacking();
	}
	else
	{
		g_EntityFuncs.FireTargets( 'packing_lockedbtnsound', null, null, USE_TOGGLE, 0.0f, 0.0f );
	}
}


void beginPacking()
{
	//g_Game.AlertMessage(at_console, "beginPacking triggered");
	dsplmsg("Packing process has been started.", 3.0f, "yellow"); //text message and hold time	
	

	if (firstPackingStarted == false) 	{
		dictionary voiceLine = cast<dictionary>( voiceList['15_packingstarted'] );
		addDictionaryToQueue(voiceLine);		
		firstPackingStarted = true;
		dictionary voiceLine2 = cast<dictionary>( voiceList['16_automatons'] );			
		g_Scheduler.SetTimeout( "addDictionaryToQueue", Math.RandomLong(180,240), voiceLine2 );
	}
				
	packing.set('state','active');

	ResetBarrelEffectCounters();

	mixesBeingProcessed = totalMixesReady;
	
	if (buddyTimerCounter > 120 and buddyTimerCounter != 999 and mixesBeingProcessed + mustardProduced > 9 and mustardGoal == 16 ) { //9 is chosen so that buddy event occurs when beginning what POTENTIALLY could be the second last batch
		buddyTimerCounter = Math.RandomLong(60,120); // 1 minute to 2 minutes
	}	
	else if (buddyTimerCounter > 120 and buddyTimerCounter != 999 and mixesBeingProcessed + mustardProduced > 4 and mustardGoal == 8 ) { 
		buddyTimerCounter = Math.RandomLong(60,120); // 1 minute to 2 minutes
	}			
			
	
	if (mixesBeingProcessed + mustardProduced >= mustardGoal) {
		
		if (trackOneCounter < 51) //48 = length of boss intro sequence
		{
			trackOneCounter = Math.RandomLong(52,60); //we stop sabotages until the entire boss intro is over
		}				
		dictionary voiceLine = cast<dictionary>( voiceList['26_bossarrives1'] );
		g_Scheduler.SetTimeout( "addDictionaryToQueue", 10, voiceLine );
		g_EntityFuncs.FireTargets( 'bossshake', null, null, USE_ON, 0.0f, 13.0f ); 	
		g_EntityFuncs.FireTargets( 'bossshake2', null, null, USE_ON, 0.0f, 27.0f ); 			
		g_Scheduler.SetTimeout( "beginBossBattle", 31 );		
			
	}
	

	for( int n = 1; n < numberOfMixers + 1; n++ ) 
	{

		string stateMixer;
		mixer[n].get('state',stateMixer); //grabs the state and shoves it in the variable 
		//g_Game.AlertMessage(at_console, "Checking mixers. Id of mixer: %1",n);	
		if (stateMixer == 'completed') 
		{
			string emptyMixerStringId = n;
			emptyMixer(emptyMixerStringId);	
		}
	}		
	
	//unnecessary
	//setPackingChuteLock("1",true);
	//setPackingChuteLock("2",true);
	
	totalMixesReady = 0;
		
	// packing effects g_EntityFuncs.FireTargets( 'mixer' + id, null, null, USE_ON, 0.0f, 8.0f );  

	@pFunctionPacking = g_Scheduler.SetInterval( "packingCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES);
	//@pFunctionPackingBarrels = g_Scheduler.SetInterval( "packingActiveEffects", 5, packingCounterTime / 5);
	@pFunctionPackingBarrels = g_Scheduler.SetInterval( "packingActiveEffects", 5, g_Scheduler.REPEAT_INFINITE_TIMES);
	
	g_EntityFuncs.FireTargets( 'packing_conveyor_doors', null, null, USE_ON, 0.0f, 0.0f ); 
	g_EntityFuncs.FireTargets( 'packing_light_yellow', null, null, USE_ON, 0.0f, 0.0f ); 
	g_EntityFuncs.FireTargets( 'conveyor_counter', null, null, USE_TOGGLE, 0.0f, 0.0f ); 
	g_EntityFuncs.FireTargets( 'conveyor_push', null, null, USE_ON, 0.0f, 0.0f ); 
	g_EntityFuncs.FireTargets( 'mustardstreams_on', null, null, USE_ON, 0.0f, 0.0f ); 
	g_EntityFuncs.FireTargets( 'conveyorsounds', null, null, USE_ON, 0.0f, 0.0f ); 
	g_EntityFuncs.FireTargets( 'conveyorsounds2', null, null, USE_ON, 0.0f, 2.0f ); 
	g_EntityFuncs.FireTargets( 'conveyorsounds3', null, null, USE_ON, 0.0f, 4.0f ); 
	
	if (difficultySetting == 'beginner' ) { 
		
		if (beginnerSabotageCount == 0 ) {
			beginnerSabotageCount = 1;
			g_Scheduler.SetTimeout( "activateTrackOneEvent", 60 );			
		
		}
		else if (beginnerSabotageCount == 1 and mustardProduced >= 3  ) {
			beginnerSabotageCount = 2;
			g_Scheduler.SetTimeout( "activateTrackOneEvent", 60 );		
		}
	}		
	
}

void packingActiveEffects()
{
	string brokenState;
	packing.get('brokenState',brokenState); //grabs the state and shoves it in the variable apparently
	
	if (generatorBroken == false or packingEffectsCounter % 2 == 0 ) { //if it is broken, then nothing will happen 50% of the time

		if (packingEffectsCounter != 0 and brokenState == 'working')
		{
			packingEffectsCounter -= 1;
		
			//g_Game.AlertMessage(at_console, "startSecondBarrels is %1",startSecondBarrels);
			//g_Game.AlertMessage(at_console, "stopSecondBarrels is %1",stopSecondBarrels);
			if (stopFirstBarrels != 0)
			{
				g_EntityFuncs.FireTargets( 'barrelspawner1', null, null, USE_TOGGLE, 0.0f, 0.0f ); 	
				stopFirstBarrels -= 5;
				//g_Game.AlertMessage(at_console, "stopFirstBarrels is %1",stopFirstBarrels);
			}	
			if (startSecondBarrels == 0 && stopSecondBarrels != 0 )
			{
				g_EntityFuncs.FireTargets( 'barrelspawner2', null, null, USE_TOGGLE, 0.0f, 0.0f ); 	
			}
			if (stopSecondBarrels == 0 ) //consider shutting off streams even if machine is broken
			{
				g_EntityFuncs.FireTargets( 'mustardstreams_off', null, null, USE_OFF, 0.0f, 0.0f ); 
			}
			
			if (startSecondBarrels != 0)
			{
				startSecondBarrels -= 5;
			}
			if (stopSecondBarrels != 0)
			{
				stopSecondBarrels -= 5;
			}	
			
			CBaseEntity@ spawnedBarrel = null;
			while ( ( @spawnedBarrel = g_EntityFuncs.FindEntityByClassname( spawnedBarrel, "item_generic" ) ) !is null )
			{
				if ( spawnedBarrel.pev.targetname == "barrel_prop" )
						spawnedBarrel.pev.movetype = MOVETYPE_FLY;
			}			
		}	
	}
	
	if (packingEffectsCounter == 0)
	{
		CScheduledFunction@ pFunctionPackingBarrels = g_Scheduler.GetCurrentFunction();//unnecessary)
		g_Scheduler.RemoveTimer( pFunctionPackingBarrels );
		@pFunctionPackingBarrels = null;

	}	
}

void packingCountDown()
{

	string brokenState;
	packing.get('brokenState',brokenState); //grabs the state and shoves it in the variable apparently
	if (brokenState == 'broken') {
		CScheduledFunction@ pFunctionPacking = g_Scheduler.GetCurrentFunction();//unnecessary
		g_Scheduler.RemoveTimer( pFunctionPacking );
		@pFunctionPacking = null;
	}
	else {
		packingCounterTimeLeft -= 1;
	}


	//g_Game.AlertMessage(at_console, "packingCountDown.");
	//g_Game.AlertMessage(at_console, "packingCountDown. Counter is %1",packingCounterTimeLeft);

	if (packingCounterTimeLeft == 0)
	{
		CScheduledFunction@ pFunctionPacking = g_Scheduler.GetCurrentFunction();//unnecessary
		g_Scheduler.RemoveTimer( pFunctionPacking );
		@pFunctionPacking = null;

		packingCounterTimeLeft = packingCounterTime;
	
		completePacking();
	}
}

void completePacking()
{
	
	if (firstBatchProduced == false && difficultySetting != 'beginner') {
		beginBuddyTimer();
		firstBatchProduced = true;
	}


	//g_Game.AlertMessage(at_console, "completePacking triggered \n");
	
	packing.set('state','default');
	
	setPackingChuteLock("1",false);
	setPackingChuteLock("2",false);	
	packingBarrelsAddedInt = 0;
	packingBarrelCounterB = 0;
	packingBarrelCounterC = 0;
	g_EntityFuncs.FireTargets( 'packing_light_green_b1', null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'packing_light_green_b2', null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'packing_light_green_c1', null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'packing_light_green_c2', null, null, USE_OFF, 0.0f, 0.0f );
	
	g_EntityFuncs.FireTargets( 'packing_light_yellow', null, null, USE_OFF, 0.0f, 0.0f ); 
	g_EntityFuncs.FireTargets( 'packing_light_green_input', null, null, USE_OFF, 0.0f, 0.0f ); //turn off input light in control room
	g_EntityFuncs.FireTargets( 'conveyor_counter', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'packing_conveyor_doors', null, null, USE_OFF, 0.0f, 0.0f ); 
	g_EntityFuncs.FireTargets( 'conveyor_push', null, null, USE_OFF, 0.0f, 0.0f ); 
	
	g_EntityFuncs.FireTargets( 'conveyorsounds', null, null, USE_OFF, 0.0f, 0.0f ); 
	g_EntityFuncs.FireTargets( 'conveyorsounds2', null, null, USE_OFF, 0.0f, 0.0f ); 
	g_EntityFuncs.FireTargets( 'conveyorsounds3', null, null, USE_OFF, 0.0f, 0.0f ); 


	//shut off production effects
	//turn on completion visual effects
	
	string batchesProduced_s = "Packing done. Batches produced: " + mixesBeingProcessed;
	
	

	mustardProduced = mustardProduced + mixesBeingProcessed;	
	
	//g_Game.AlertMessage(at_console, "mustardProduced: %1 \n",mustardProduced);
	
	if (mustardProduced >= (mustardGoal / 2) && heavyGoonsCountdown > 110 ) {
		heavyGoonsCountdown = Math.RandomLong(50,100);
	}		
	
	if (difficultySetting == 'beginner' ) { 
		if (beginnerSabotageCount == 2 and mustardProduced >= 5 ) {
			beginnerSabotageCount = 3;
			g_Scheduler.SetTimeout( "activateTrackOneEvent", 60 );		
		}		
	}	

	g_EntityFuncs.FireTargets( 'machinedonesound', null, null, USE_ON, 0.0f, 0.0f );
	CBaseEntity@ packingdone_txt = g_EntityFuncs.FindEntityByTargetname(null, 'packingdone_txt'); //null means find the first entity with the targetname
	
	g_EntityFuncs.DispatchKeyValue( packingdone_txt.edict(), "message", batchesProduced_s );		
	g_EntityFuncs.FireTargets( 'packingdone_txt', null, null, USE_ON, 0.0f, 0.0f );

	//g_EntityFuncs.FireTargets( 'packingdone2_txt', null, null, USE_ON, 0.0f, 0.0f );	
	
	
		//totalMixesReady = 5; //nonsense only for testing
		//int packingBarrelsAddedInt = 4; //nonsense only for testing
	
	dictionary voiceLine;
	
	if (mustardProduced >= mustardGoal)
	{
		levelWon();
	
	}	
	else if (voiceQueue.length() == 0) {
		if (mixesBeingProcessed == 1) {
			voiceLine = cast<dictionary>( voiceList['70_singlebatch'] );
			addDictionaryToQueue(voiceLine);		
		}
		else {
			voiceLine = cast<dictionary>( voiceList['45_mustardproduced'] );
			addDictionaryToQueue(voiceLine);		
			if (mixesBeingProcessed > 4)	 {
				voiceLine = cast<dictionary>( voiceList['49_largebatch'] );
				addDictionaryToQueue(voiceLine);				
			}	
			else 	 {
				int randomPick = Math.RandomLong(1,3); 
				switch( randomPick )
				{
				case 1:
					voiceLine = cast<dictionary>( voiceList['46_keepthemcoming'] );
					break;
				case 2:	
					voiceLine = cast<dictionary>( voiceList['47_quitedecent'] );
					break;	
				case 3:
					voiceLine = cast<dictionary>( voiceList['48_goodwork'] );
					break;			
				}				
				addDictionaryToQueue(voiceLine);
			}				
		}

	}
	dictionary soClose = cast<dictionary>( voiceList['50_soclose'] );
	if ( mustardGoal == 8 && mustardProduced > 6) {
		g_Scheduler.SetTimeout( "addDictionaryToQueue", 20, soClose );
	}
	else if (mustardGoal == 16 && mustardProduced > 12) {
		g_Scheduler.SetTimeout( "addDictionaryToQueue", 20, soClose );
	}	
	mixesBeingProcessed = 0;
}

void ResetBarrelEffectCounters()
{
	packingEffectsCounter =  packingCounterTime / 5;
	startSecondBarrels = 40; 
	stopFirstBarrels = packingCounterTime - 60;
	stopSecondBarrels = packingCounterTime - 20;
}

void emptyMixer(string id)
{
	//g_Game.AlertMessage(at_console, "emptyMixer triggered %1",id);
	int idInt = atoi(id);	
	mixer[idInt].set('state','default');	
	emptyMixers++;
	setMixerChuteLock(id,false);
	
	
	g_EntityFuncs.FireTargets( 'packing_light_green_a' + id, null, null, USE_OFF, 0.0f, 0.0f );	
	
	g_EntityFuncs.FireTargets( 'mixer' + id, null, null, USE_OFF, 0.0f, 0.0f );  //the first 0.0f just needs to be there, the second is the delay
	g_EntityFuncs.FireTargets( 'mixer_liquid' + id, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_empty_sound' + id, null, null, USE_ON, 0.0f, 0.0f ); //the sound for removing mustard. slurp slurp
	g_EntityFuncs.FireTargets( 'mixer_light_green_a' + id, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_light_green_b' + id, null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_light_yellow' + id, null, null, USE_OFF, 0.0f, 0.0f );
}



// void checkPillarHealth()
// {
	// CBaseEntity@ pillars = g_EntityFuncs.FindEntityByTargetname(null, 'pillars');
	// while (pillars !is null)
	// {
		// if (pillars.pev.health < 150) {
			// pillarBroken();
			
			// CScheduledFunction@ pillarHealthTimer = g_Scheduler.GetCurrentFunction();//necessary because it's not a global variable
			// g_Scheduler.RemoveTimer( pillarHealthTimer );
			// @pillarHealthTimer = null;		
			// break; //added 08/01/2023
		// }
		
		// @pillars = g_EntityFuncs.FindEntityByTargetname(@pillars, 'pillars');
	// }	
// }


//void beginBossBattle(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
void beginBossBattle()
{

	if (mapEndReached == true) {
		return;
	}

	if (trackTwoCounter < 20) //17 = length until players gain control again
	{
		trackTwoCounter += 20; //we dont want a rift to appear during boss scene
	}


	dictionary voiceLine = cast<dictionary>( voiceList['27_bossarrives2'] );
	g_Scheduler.SetTimeout( "addDictionaryToQueue", 15, voiceLine );

	if (kingpins == false) {
		kingpins = true;
		g_EntityFuncs.FireTargets( 'kingpin_spriterename', null, null, USE_ON, 0.0f, 0.0f );		
	}

	//g_Game.AlertMessage(at_console, "beginBossBattle triggered");
	g_EntityFuncs.FireTargets( 'boss_fadein', null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'boss_fadeout', null, null, USE_ON, 0.0f, 6.0f );
	g_EntityFuncs.FireTargets( 'bosspipe_break_sound', null, null, USE_ON, 0.0f, 0.0f );

	
	g_EntityFuncs.FireTargets( 'enemydetectionmode', null, null, USE_ON, 0.0f, 0.0f ); //change enemy detection mode so the boss always attacks pillars
	
	g_EntityFuncs.FireTargets( 'pillar_change_class', null, null, USE_ON, 0.0f, 2.0f );
	g_EntityFuncs.FireTargets( 'bosspipe', null, null, USE_ON, 0.0f, 2.0f );
	g_EntityFuncs.FireTargets( 'bosspipe_floor', null, null, USE_OFF, 0.0f, 2.0f );
	g_EntityFuncs.FireTargets( 'killpipeblockers', null, null, USE_ON, 0.0f, 2.0f );
	
	g_EntityFuncs.FireTargets( 'bosscamera', null, null, USE_ON, 0.0f, 2.0f );
	
	g_EntityFuncs.FireTargets( 'bosspush', null, null, USE_ON, 0.0f, 9.0f );
	g_EntityFuncs.FireTargets( 'boss_spawn_swarm', null, null, USE_ON, 0.0f, 9.0f );

	g_EntityFuncs.FireTargets( 'bossmonsterclip', null, null, USE_ON, 0.0f, 0.0f );

	
	
	g_EntityFuncs.FireTargets( 'killpipeblockers', null, null, USE_OFF, 0.0f, 4.0f );
	g_EntityFuncs.FireTargets( 'bosspush', null, null, USE_OFF, 0.0f, 10.5f );	
	g_EntityFuncs.FireTargets( 'bosspush2', null, null, USE_ON, 0.0f, 11.0f );	
	g_EntityFuncs.FireTargets( 'bosspush2', null, null, USE_OFF, 0.0f, 12.0f );		

	g_EntityFuncs.FireTargets( 'boss_fadein_endscene', null, null, USE_ON, 0.0f, 13.0f );
	g_EntityFuncs.FireTargets( 'bosscamera', null, null, USE_OFF, 0.0f, 15.0f );
	g_EntityFuncs.FireTargets( 'boss_fadeout_endscene', null, null, USE_ON, 0.0f, 15.0f );
	
	g_EntityFuncs.FireTargets( 'bossmustardpoolrender', null, null, USE_ON, 0.0f, 6.0f ); //pools of mustard
	
	if (difficultySetting == 'hard')
	{
		g_EntityFuncs.FireTargets( 'boss_spawn_swarm_hard', null, null, USE_ON, 0.0f, 50.0f );
		g_EntityFuncs.FireTargets( 'bosspush', null, null, USE_ON, 0.0f, 50.0f );
	}
	else
	{
		g_EntityFuncs.FireTargets( 'boss_spawn_swarm2', null, null, USE_ON, 0.0f, 81.0f );
		g_EntityFuncs.FireTargets( 'bosspush', null, null, USE_ON, 0.0f, 81.0f );
	}
	
	voiceLine = cast<dictionary>( voiceList['65_bossurge'] );
	g_Scheduler.SetTimeout( "addDictionaryToQueue", Math.RandomLong(160,180), voiceLine);		
	dictionary voiceLine2 = cast<dictionary>( voiceList['66_bossurge2'] );
	g_Scheduler.SetTimeout( "addDictionaryToQueue", Math.RandomLong(360,420), voiceLine2);	
	
	//CScheduledFunction@ pillarHealthTimer = null;
	//@pillarHealthTimer = g_Scheduler.SetInterval( "checkPillarHealth", 0.1, g_Scheduler.REPEAT_INFINITE_TIMES);

	activeBoss = true;
}


void mapEndReachedFunction() {
	//g_Game.AlertMessage(at_console, "mapEndReachedFunction triggered");
	mapEndReached = true;
	//CScheduledFunction@ hudUpdater = g_Scheduler.GetCurrentFunction();
	g_Scheduler.RemoveTimer( hudUpdater );
	// 18/01/2023 @hudUpdater = null;	

	//CScheduledFunction@ pFunctionRifts = g_Scheduler.GetCurrentFunction();
	g_Scheduler.RemoveTimer( pFunctionRifts );
	// 18/01/2023 @pFunctionRifts = null;	
	
	//CScheduledFunction@ pFunctionTrack1 = g_Scheduler.GetCurrentFunction();
	g_Scheduler.RemoveTimer( pFunctionTrack1 );
	// 18/01/2023	@pFunctionTrack1 = null;	
	g_EntityFuncs.FireTargets( 'machinedonesound_stop', null, null, USE_ON, 0.0f, 0.0f ); //rename bell sound so its not triggered


	// CBaseEntity@ pillars = g_EntityFuncs.FindEntityByTargetname(null, 'pillars');
	// while (pillars !is null)
	// {
		// pillars.pev.health = pillars.pev.health + 10000; 
		// @pillars = g_EntityFuncs.FindEntityByTargetname(@pillars, 'pillars');
	// }		

}


//void pillarBroken() 
void pillarBroken(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) 
{
	if (mapEndReached == true) {
		return;
	}
	
	mapEndReachedFunction();

	//g_Game.AlertMessage(at_console, "pillarBroken triggered");
	g_EntityFuncs.FireTargets( 'instafade', null, null, USE_ON, 0.0f, 1.0f );	
	g_EntityFuncs.FireTargets( 'rift_globalriftsound', null, null, USE_ON, 0.0f, 2.0f );
	
	g_EntityFuncs.FireTargets( 'pillarlose_txt', null, null, USE_ON, 0.0f, 3.0f );
	
	g_EntityFuncs.FireTargets( 'poolspawn', null, null, USE_OFF, 0.0f, 2.0f );
	g_EntityFuncs.FireTargets( 'end_spawn', null, null, USE_ON, 0.0f, 2.0f );
	g_EntityFuncs.FireTargets( 'respawnem', null, null, USE_ON, 0.0f, 2.1f );	
	g_EntityFuncs.FireTargets( 'blackcam', null, null, USE_ON, 0.0f, 2.2f );	
		
	
	g_EntityFuncs.FireTargets( 'gameendentity', null, null, USE_ON, 0.0f, 12.5f );	
	
	dictionary voiceLine = cast<dictionary>( voiceList['28_pillarbreak'] );
	addDictionaryToQueue(voiceLine);	
}

void buddyLose(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) 
{
	buddyLost = true;
	
	if (mapEndReached == true) {
		return;
	}
	
	mapEndReachedFunction();
	
	dictionary voiceLine = cast<dictionary>( voiceList['25_fullydrained'] );
	g_Scheduler.SetTimeout( "addDictionaryToQueue", 2, voiceLine);	
	

	g_EntityFuncs.FireTargets( 'normal_fadein', null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'normal_fadeout', null, null, USE_ON, 0.0f, 2.5f );
	g_EntityFuncs.FireTargets( 'slurpcamera', null, null, USE_ON, 0.0f, 2.0f );
	//dsplmsg("You let the pool drain. You have lost.", 5.0f, "red"); //text message and hold time
	g_EntityFuncs.FireTargets( 'slurpsound', null, null, USE_ON, 0.0f, 1.5f );
	//g_EntityFuncs.FireTargets( 'rapid_slurp', null, null, USE_ON, 0.0f, 3.0f );
	
	g_EntityFuncs.FireTargets( 'normal_fadein', null, null, USE_ON, 0.0f, 24.0f );
	g_EntityFuncs.FireTargets( 'longer_fadeout', null, null, USE_ON, 0.0f, 26.5f );	
	g_EntityFuncs.FireTargets( 'claw_growl', null, null, USE_ON, 0.0f, 25.5f );
	
	
	g_EntityFuncs.FireTargets( 'slurpcamera', null, null, USE_OFF, 0.0f, 26.5f );
	g_EntityFuncs.FireTargets( 'clawcamera', null, null, USE_ON, 0.0f, 26.5f );
	g_EntityFuncs.FireTargets( 'clawsprite', null, null, USE_ON, 0.0f, 24.5f );
	g_EntityFuncs.FireTargets( 'clawsprite2', null, null, USE_ON, 0.0f, 26.5f );
	g_EntityFuncs.FireTargets( 'claw_train', null, null, USE_ON, 0.0f, 26.5f );
	
	g_EntityFuncs.FireTargets( 'claw_setorigin', null, null, USE_ON, 0.0f, 26.5f );
	
	g_EntityFuncs.FireTargets( 'poolspawn', null, null, USE_OFF, 0.0f, 26.5f );
	g_EntityFuncs.FireTargets( 'end_spawn', null, null, USE_ON, 0.0f, 26.5f );
	g_EntityFuncs.FireTargets( 'respawnem', null, null, USE_ON, 0.0f, 26.6f );	
	
	
	
	
	g_EntityFuncs.FireTargets( 'evenlonger_fadein_hold', null, null, USE_ON, 0.0f, 37.0f );
	g_EntityFuncs.FireTargets( 'buddylose_txt', null, null, USE_ON, 0.0f, 39.0f );
	g_EntityFuncs.FireTargets( 'clawcamera', null, null, USE_OFF, 0.0f, 40.0f );	
	
	//g_EntityFuncs.FireTargets( 'clawcamera', null, null, USE_OFF, 0.0f, 32.5f );
	
	float clawPortalTimer = 26.5f;

	for( int n = 0; n < 45; n++ ) 
	{
		g_EntityFuncs.FireTargets( 'clawportalbigger', null, null, USE_ON, 0.0f, clawPortalTimer );
		clawPortalTimer += 0.28f;
		//g_Game.AlertMessage(at_console, "clawportalbigger triggered");
	}			
		
	g_EntityFuncs.FireTargets( 'gameendentity', null, null, USE_ON, 0.0f, 47.0f );
}




void levelWon()
{
	//g_Game.AlertMessage(at_console, "You have won");

	if (mapEndReached == true) {

		return;
	}
		
	mapEndReachedFunction();
	//deactivate loss possibilities
	//close all rifts.
	// kill all enemies

	dictionary voiceLine = cast<dictionary>( voiceList['30_dailygoalreached'] );
	addDictionaryToQueue(voiceLine);
	
	dictionary voiceLine2 = cast<dictionary>( voiceList['31_dailygoalreached2'] );
	g_Scheduler.SetTimeout( "addDictionaryToQueue", 12, voiceLine2);		
	

	g_EntityFuncs.FireTargets( 'evenlonger_fadein_hold', null, null, USE_ON, 0.0f, 6.0f );	
	//g_EntityFuncs.FireTargets( 'fadehold', null, null, USE_ON, 0.0f, 23.0f );	
	 	
	g_EntityFuncs.FireTargets( 'rift_globalriftclosesound', null, null, USE_ON, 0.0f, 8.0f );
	g_EntityFuncs.FireTargets( 'poolspawn', null, null, USE_OFF, 0.0f, 8.0f );
	g_EntityFuncs.FireTargets( 'end_spawn', null, null, USE_ON, 0.0f, 8.0f );
	g_EntityFuncs.FireTargets( 'respawnem', null, null, USE_ON, 0.0f, 8.1f );	
	//g_EntityFuncs.FireTargets( 'blackcam', null, null, USE_ON, 0.0f, 8.2f );
	g_EntityFuncs.FireTargets( 'introcam', null, null, USE_ON, 0.0f, 8.2f );	
	g_EntityFuncs.FireTargets( 'killtheguide', null, null, USE_ON, 0.0f, 8.0f );	//remove guide signs	
	 //show for 15 seconds, then fade.		
	g_EntityFuncs.FireTargets( 'playerswin_txt', null, null, USE_ON, 0.0f, 26.0f );		//lasts 8 seconds
	g_EntityFuncs.FireTargets( 'quick_fadein', null, null, USE_ON, 0.0f, 35.0f );
	g_EntityFuncs.FireTargets( 'quick_fadeout', null, null, USE_ON, 0.0f, 36.0f );	
	g_EntityFuncs.FireTargets( 'nih_endingcredits', null, null, USE_ON, 0.0f, 36.0f );
	
	g_EntityFuncs.FireTargets( 'normal_fadein', null, null, USE_ON, 0.0f, 48.0f );	
	g_EntityFuncs.FireTargets( 'nih_endingcredits', null, null, USE_OFF, 0.0f, 50.0f );
	//g_EntityFuncs.FireTargets( 'badabing', null, null, USE_ON, 0.0f, 54.0f );		


	dictionary voiceLine3 = cast<dictionary>( voiceList['badabing'] );
	g_Scheduler.SetTimeout( "addDictionaryToQueue", 50, voiceLine3);		

	//CBaseEntity@ speechOrigin = g_EntityFuncs.FindEntityByTargetname(null, 'maxwell_speech_origin');	
	//g_SoundSystem.PlaySound( speechOrigin.edict(), CHAN_STATIC, 'mustardf/badabing.wav', 54.0f, ATTN_NONE );	
	g_EntityFuncs.FireTargets( 'gameendentity', null, null, USE_ON, 0.0f, 51.0f );	
}

// add missing effects from last functions