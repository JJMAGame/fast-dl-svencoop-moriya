


int	trackOneCounterValue1;
int	trackOneCounterValue2;
uint trackOneCounter; //time until first event. sabotage
 

int	trackTwoCounterValue1;
int	trackTwoCounterValue2;
uint trackTwoCounter; //time until first event. rifts
 
 
bool firstSabotageOccurred = false;
bool firstRiftAppeared = false;

array<int> activeRifts(9, 0); //9 possible rifts, 0 means inactive
int activeBigRifts = 0; //there are small and big rifts. big rifts have more enemies.
int activeRiftsCounter = 0;

bool buddyLost = false;


int buddyDrainCounter = 0;

string difficultySetting;
bool difficultyChosen = false;

float buddyTimerRate = 1.7f;

float shutValvesCounter = 0;

int activeSabotageCounter = 0;
int semiActiveSabotageCounter = 0;

int brokenMachinesCount = 0;
int brokenGrinderCount = 0;
int brokenMixerCount = 0;
bool activeBuddyEvent = false;

bool sabotageSpeechGiven = false;

int heavyGoonsCountdown = Math.RandomLong(840,1020); // 14 to 17 minutes
bool heavyGoons = false;
bool kingpins = false;

uint buddyTimerCounter = Math.RandomLong(960,1200); //16 to 20 minutes until little buddies arrive, counting after first batch produced
//uint buddyTimerCounter = Math.RandomLong(12,12); //16 to 20 minutes until little buddies arrive, counting after first batch produced
//22 min. to 26
//1320 1560


int beginnerSabotageCount = 0;


array<int> activeSabotage(6, 0); //6 possible sabotage events, 0 means inactive, 1 active, 2 semiactive
int brokenPackingMachines = 0;	
	
bool generatorBroken = false;
	
CScheduledFunction@ pFunctionRifts = null;
CScheduledFunction@ pFunctionTrack1 = null;
CScheduledFunction@ pFunctionBuddyTimer = null;



CScheduledFunction@ pFunctionBuddyEventTimer = null;


CScheduledFunction@ pFunctionTrackOneFastMaker = null;
CScheduledFunction@ pFunctionTrackTwoFastMaker = null;
CScheduledFunction@ pFunctionTrackTwoFastMaker2 = null;

CScheduledFunction@ pFunctionGrinderSmoke1 = null;
CScheduledFunction@ pFunctionGrinderSmoke2 = null;
CScheduledFunction@ pFunctionGrinderSmoke3 = null;
CScheduledFunction@ pFunctionGrinderSmoke4 = null;
CScheduledFunction@ pFunctionGrinderSmoke5 = null;
CScheduledFunction@ pFunctionGrinderSmoke6 = null;

void beginIntro(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {


	g_EntityFuncs.FireTargets( 'title_screen', null, null, USE_ON, 0.0f, 2.5f );
	g_EntityFuncs.FireTargets( 'introcam', null, null, USE_ON, 0.0f, 2.5f );
	g_EntityFuncs.FireTargets( 'quick_fadein', null, null, USE_ON, 0.0f, 10.0f );
	g_EntityFuncs.FireTargets( 'quick_fadeout', null, null, USE_ON, 0.0f, 11.0f );
	g_EntityFuncs.FireTargets( 'title_screen', null, null, USE_OFF, 0.0f, 11.0f );
	g_EntityFuncs.FireTargets( 'nih_screen', null, null, USE_ON, 0.0f, 11.0f );	
	g_EntityFuncs.FireTargets( 'normal_fadein', null, null, USE_ON, 0.0f, 15.0f );
	
	g_EntityFuncs.FireTargets( 'intromusic', null, null, USE_ON, 0.0f, 17.5f );
	g_EntityFuncs.FireTargets( 'intro_cutscene_cam1', null, null, USE_ON, 0.0f, 17.0f );
	g_EntityFuncs.FireTargets( 'introcam', null, null, USE_OFF, 0.0f, 17.0f );
	g_EntityFuncs.FireTargets( 'longer_fadeout', null, null, USE_TOGGLE, 0.0f, 17.5f );
		
	g_EntityFuncs.FireTargets( 'nih_screen', null, null, USE_OFF, 0.0f, 24.5f );
	g_EntityFuncs.FireTargets( 'quick_fadein', null, null, USE_ON, 0.0f, 23.5f );
	g_EntityFuncs.FireTargets( 'quick_fadeout', null, null, USE_ON, 0.0f, 24.5f );
	g_EntityFuncs.FireTargets( 'intro_cutscene_cam1', null, null, USE_OFF, 0.0f, 24.5f );
	g_EntityFuncs.FireTargets( 'intro_cutscene_cam2', null, null, USE_ON, 0.0f, 24.5f );
	
	g_EntityFuncs.FireTargets( 'quick_fadein', null, null, USE_ON, 0.0f, 30.0f );
	g_EntityFuncs.FireTargets( 'quick_fadeout', null, null, USE_ON, 0.0f, 31.0f );
	g_EntityFuncs.FireTargets( 'intro_cutscene_cam2', null, null, USE_OFF, 0.0f, 31.0f );
	g_EntityFuncs.FireTargets( 'intro_cutscene_cam3', null, null, USE_ON, 0.0f, 31.0f );

	g_EntityFuncs.FireTargets( 'quick_fadein', null, null, USE_ON, 0.0f, 36.5f );
	g_EntityFuncs.FireTargets( 'quick_fadeout', null, null, USE_ON, 0.0f, 37.5f );
	g_EntityFuncs.FireTargets( 'intro_cutscene_cam3', null, null, USE_OFF, 0.0f, 37.5f );
	g_EntityFuncs.FireTargets( 'intro_cutscene_cam4', null, null, USE_ON, 0.0f, 37.5f );

	g_EntityFuncs.FireTargets( 'quick_fadein', null, null, USE_ON, 0.0f, 43.0f );
	g_EntityFuncs.FireTargets( 'quick_fadeout', null, null, USE_ON, 0.0f, 44.0f );
	g_EntityFuncs.FireTargets( 'intro_cutscene_cam4', null, null, USE_OFF, 0.0f, 44.0f );
	g_EntityFuncs.FireTargets( 'intro_cutscene_cam5', null, null, USE_ON, 0.0f, 44.0f );	

	g_EntityFuncs.FireTargets( 'quick_fadein', null, null, USE_ON, 0.0f, 49.5f );
	g_EntityFuncs.FireTargets( 'longer_fadeout', null, null, USE_ON, 0.0f, 50.5f );
	g_EntityFuncs.FireTargets( 'intro_cutscene_cam5', null, null, USE_OFF, 0.0f, 50.5f );
	g_EntityFuncs.FireTargets( 'intro_cutscene_cam6', null, null, USE_ON, 0.0f, 50.5f );	
	
	g_EntityFuncs.FireTargets( 'littlebuddy_spawn_intro', null, null, USE_ON, 0.0f, 49.5f );	
	//g_EntityFuncs.FireTargets( 'moving_strike_camtarget', null, null, USE_ON, 0.0f, 35.0f );	
	
	g_EntityFuncs.FireTargets( 'evenlonger_fadein', null, null, USE_TOGGLE, 0.0f, 58.5f );
	//g_EntityFuncs.FireTargets( 'intromusic', null, null, USE_OFF, 0.0f, 47.0f );
	g_EntityFuncs.FireTargets( 'longer_fadeout', null, null, USE_TOGGLE, 0.0f, 62.5f );
	g_EntityFuncs.FireTargets( 'kill_introbuddy1', null, null, USE_TOGGLE, 0.0f, 62.5f );
	


	g_EntityFuncs.FireTargets( 'workdaystarts_txt', null, null, USE_ON, 0.0f, 65.5f );	
	g_EntityFuncs.FireTargets( 'workwhistle', null, null, USE_ON, 0.0f, 68.0f );	
		
	dictionary voiceLine = cast<dictionary>( voiceList['2_briefing'] );
	g_Scheduler.SetTimeout( "addDictionaryToQueue", 71, voiceLine);	
	g_EntityFuncs.FireTargets( 'briefing_gate', null, null, USE_ON, 0.0f, 150.0f );	
	
	if (difficultySetting == 'easy' or difficultySetting == 'beginner' ) {
		g_EntityFuncs.FireTargets( 'manual_signs_small', null, null, USE_ON, 0.0f, 65.0f );	
		g_EntityFuncs.FireTargets( 'guide_8_gate', null, null, USE_ON, 0.0f, 150.0f );
	}
	else {
		g_EntityFuncs.FireTargets( 'manual_signs_big', null, null, USE_ON, 0.0f, 65.0f );	
		g_EntityFuncs.FireTargets( 'guide_16_gate', null, null, USE_ON, 0.0f, 150.0f );
	}	
	g_EntityFuncs.FireTargets( 'workstart_sprite', null, null, USE_ON, 0.0f, 56.5f );
	g_EntityFuncs.FireTargets('spawningpool_start', null, null, USE_TOGGLE, 0.0f, 180.0f ); //make players spawn in pool	
	g_Scheduler.SetTimeout( "setDifficultyChosen", 64);		
}

void skipIntro(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
	


	g_EntityFuncs.FireTargets( 'introskipped_txt', null, null, USE_ON, 0.0f, 0.0f );	


	g_EntityFuncs.FireTargets( 'workdaystarts_txt', null, null, USE_ON, 0.0f, 7.0f );	
	g_EntityFuncs.FireTargets( 'workwhistle', null, null, USE_ON, 0.0f, 9.5f );	
	
	if (difficultySetting == 'easy' or difficultySetting == 'beginner' ) {
		g_EntityFuncs.FireTargets( 'manual_signs_small', null, null, USE_ON, 0.0f, 4.0f );	
		g_EntityFuncs.FireTargets( 'guide_8_gate', null, null, USE_ON, 0.0f, 0.0f );
	}
	else {
		g_EntityFuncs.FireTargets( 'manual_signs_big', null, null, USE_ON, 0.0f, 4.0f );	
		g_EntityFuncs.FireTargets( 'guide_16_gate', null, null, USE_ON, 0.0f, 0.0f );
	}	
	g_EntityFuncs.FireTargets( 'briefing_gate', null, null, USE_ON, 0.0f, 0.0f );		
	g_EntityFuncs.FireTargets( 'workstart_sprite', null, null, USE_ON, 0.0f, 0.0f );
	
	g_EntityFuncs.FireTargets('spawningpool_start', null, null, USE_TOGGLE, 0.0f, 30.0f ); //make players spawn in pool
	
	g_Scheduler.SetTimeout( "setDifficultyChosen", 6);	
	//	g_Scheduler.SetTimeout( "beginBuddyTimer", 1 );//remove on release! just for test
}

void difficultySelected(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
	CustomKeyvalues@ customKeyvalues = pCaller.GetCustomKeyvalues();
    string idKeyValue = customKeyvalues.GetKeyvalue("$s_difficulty").GetString();


	//debugging!
		// CBaseEntity@ packing_control_panel = g_EntityFuncs.FindEntityByTargetname(null, 'packing_control_panel');
		// while (packing_control_panel !is null)
		// {
			// g_EntityFuncs.DispatchKeyValue( packing_control_panel.edict(), "target", "packing_check" );	 //only need 1 player to begin		
			// @packing_control_panel = g_EntityFuncs.FindEntityByTargetname(@packing_control_panel, 'packing_control_panel');
		// }	

	if (idKeyValue == 'beginner') {


		difficultySetting = 'beginner';

		dsplmsg("Beginner mode selected.", 2.0f, "yellow"); //text message and hold time	
		trackOneCounterValue1 = 480; //not used
		trackOneCounterValue2 = 600; //not used
		trackTwoCounterValue1 = 210; 
		trackTwoCounterValue2 = 270;
		
		
		reduceGrindMixSectorSize();
		g_EntityFuncs.FireTargets( 'kill_guide_16_gate', null, null, USE_ON, 0.0f, 0.0f );	

		//only need 1 player to begin		
		CBaseEntity@ packing_control_panel = g_EntityFuncs.FindEntityByTargetname(null, 'packing_control_panel');
		while (packing_control_panel !is null)
		{
			g_EntityFuncs.DispatchKeyValue( packing_control_panel.edict(), "target", "packing_check" );	 
			@packing_control_panel = g_EntityFuncs.FindEntityByTargetname(@packing_control_panel, 'packing_control_panel');
		}			

		g_EntityFuncs.FireTargets( 'signs_4barrels', null, null, USE_OFF, 0.0f, 0.0f );		
		g_EntityFuncs.FireTargets( 'signs_2barrels', null, null, USE_ON, 0.0f, 0.0f );	//signs that say "2 barrels" or "one barrel"	
		

		g_EntityFuncs.FireTargets( 'storage_spawn_random_easy', null, null, USE_ON, 0.0f, 10.0f );
		g_EntityFuncs.FireTargets( 'prodguidesign_20', null, null, USE_OFF, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'prodguidesign_10', null, null, USE_ON, 0.0f, 0.0f );
		
		CBaseEntity@ squadmaker = g_EntityFuncs.FindEntityByClassname(squadmaker, 'squadmaker');
		while (squadmaker !is null)
		{
		    
			if (squadmaker.GetCustomKeyvalues().HasKeyvalue( "$s_npctype" ) and squadmaker.GetCustomKeyvalues().GetKeyvalue("$s_npctype").GetString() == 'automaton') {
				
				@squadmaker = g_EntityFuncs.FindEntityByClassname(squadmaker, 'squadmaker');
				continue;
			}
			else if ( squadmaker.pev.health > 1 ) {
				squadmaker.pev.health = squadmaker.pev.health * 0.6; 
				@squadmaker = g_EntityFuncs.FindEntityByClassname(squadmaker, 'squadmaker');
			}
			else {
				@squadmaker = g_EntityFuncs.FindEntityByClassname(squadmaker, 'squadmaker');
			}
		}			
		
		CBaseEntity@ pillars = g_EntityFuncs.FindEntityByTargetname(null, 'pillars');
		while (pillars !is null)
		{
			pillars.pev.health = pillars.pev.health + 10000; 
			@pillars = g_EntityFuncs.FindEntityByTargetname(@pillars, 'pillars');
		}			
		
	}		
	else if (idKeyValue == 'easy') {	
	
		difficultySetting = 'easy';

		dsplmsg("Medium difficulty selected.", 2.0f, "yellow"); //text message and hold time	
		trackOneCounterValue1 = 480;
		trackOneCounterValue2 = 600;
		trackTwoCounterValue1 = 180;
		trackTwoCounterValue2 = 240;
		
		CBaseEntity@ buddy_hp1 = g_EntityFuncs.FindEntityByTargetname(null, 'buddy_hp1'); //null means find the first entity with the targetname
		g_EntityFuncs.Remove( buddy_hp1);	
		CBaseEntity@ buddy_hp2 = g_EntityFuncs.FindEntityByTargetname(null, 'buddy_hp2'); //null means find the first entity with the targetname
		g_EntityFuncs.Remove( buddy_hp2);		
		CBaseEntity@ buddy_hp3 = g_EntityFuncs.FindEntityByTargetname(null, 'buddy_hp3'); //null means find the first entity with the targetname
		g_EntityFuncs.Remove( buddy_hp3);	
		CBaseEntity@ buddy_hp4 = g_EntityFuncs.FindEntityByTargetname(null, 'buddy_hp4'); //null means find the first entity with the targetname
		g_EntityFuncs.Remove( buddy_hp4);	
		CBaseEntity@ buddy_hp5 = g_EntityFuncs.FindEntityByTargetname(null, 'buddy_hp5'); //null means find the first entity with the targetname
		g_EntityFuncs.Remove( buddy_hp5);	
		CBaseEntity@ buddy_hp6 = g_EntityFuncs.FindEntityByTargetname(null, 'buddy_hp6'); //null means find the first entity with the targetname
		g_EntityFuncs.Remove( buddy_hp6);			

		CBaseEntity@ buddy_hp1_easy = g_EntityFuncs.FindEntityByTargetname(null, 'buddy_hp1_easy' );
		buddy_hp1_easy.pev.targetname = 'buddy_hp1';			
		CBaseEntity@ buddy_hp2_easy = g_EntityFuncs.FindEntityByTargetname(null, 'buddy_hp2_easy' );
		buddy_hp2_easy.pev.targetname = 'buddy_hp2';			
		CBaseEntity@ buddy_hp3_easy = g_EntityFuncs.FindEntityByTargetname(null, 'buddy_hp3_easy' );
		buddy_hp3_easy.pev.targetname = 'buddy_hp3';			
		CBaseEntity@ buddy_hp4_easy = g_EntityFuncs.FindEntityByTargetname(null, 'buddy_hp4_easy' );
		buddy_hp4_easy.pev.targetname = 'buddy_hp4';			
		CBaseEntity@ buddy_hp5_easy = g_EntityFuncs.FindEntityByTargetname(null, 'buddy_hp5_easy' );
		buddy_hp5_easy.pev.targetname = 'buddy_hp5';			
		CBaseEntity@ buddy_hp6_easy = g_EntityFuncs.FindEntityByTargetname(null, 'buddy_hp6_easy' );
		buddy_hp6_easy.pev.targetname = 'buddy_hp6';					

		
		reduceGrindMixSectorSize();
		g_EntityFuncs.FireTargets( 'kill_guide_16_gate', null, null, USE_ON, 0.0f, 0.0f );	


		g_EntityFuncs.FireTargets( 'signs_4barrels', null, null, USE_OFF, 0.0f, 0.0f );		
		g_EntityFuncs.FireTargets( 'signs_2barrels', null, null, USE_ON, 0.0f, 0.0f );	//signs that say "2 barrels" or "one barrel"	
		
		g_EntityFuncs.FireTargets( 'storage_spawn_random_easy', null, null, USE_ON, 0.0f, 10.0f );	
		g_EntityFuncs.FireTargets( 'prodguidesign_20', null, null, USE_OFF, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'prodguidesign_10', null, null, USE_ON, 0.0f, 0.0f );		
		
		buddyTimerRate = 2.2f;
		//4 valves = 4m 55s, 1 valve = 13m 5s
		
		CBaseEntity@ squadmaker = g_EntityFuncs.FindEntityByClassname(squadmaker, 'squadmaker');
		while (squadmaker !is null)
		{
		    
			if (squadmaker.GetCustomKeyvalues().HasKeyvalue( "$s_npctype" ) and squadmaker.GetCustomKeyvalues().GetKeyvalue("$s_npctype").GetString() == 'automaton') {
				
				@squadmaker = g_EntityFuncs.FindEntityByClassname(squadmaker, 'squadmaker');
				continue;
			}
			else if ( squadmaker.pev.health > 1 ) {
				squadmaker.pev.health = squadmaker.pev.health * 0.6; 
				@squadmaker = g_EntityFuncs.FindEntityByClassname(squadmaker, 'squadmaker');
			}
			else {
				@squadmaker = g_EntityFuncs.FindEntityByClassname(squadmaker, 'squadmaker');
			}

		}			
		
		CBaseEntity@ pillars = g_EntityFuncs.FindEntityByTargetname(null, 'pillars');
		while (pillars !is null)
		{
			pillars.pev.health = pillars.pev.health + 10000; 
			@pillars = g_EntityFuncs.FindEntityByTargetname(@pillars, 'pillars');
		}		
		
		
	}	
	else if (idKeyValue == 'normal') {
		difficultySetting = 'normal';
		
		dsplmsg("Hard difficulty selected.", 2.0f, "yellow"); //text message and hold time

		g_EntityFuncs.FireTargets( 'kill_guide_8_gate', null, null, USE_ON, 0.0f, 0.0f );	

		trackOneCounterValue1 = 360;
		trackOneCounterValue2 = 420;
		// trackTwoCounterValue1 = 150; must be old values DONT USE
		// trackTwoCounterValue2 = 210; must be old values DONT USE
		trackTwoCounterValue1 = 130;
		trackTwoCounterValue2 = 190;	
	
		
		g_EntityFuncs.FireTargets( 'storage_spawn_random', null, null, USE_ON, 0.0f, 10.0f );		
	}
	else if (idKeyValue == 'hard' or idKeyValue == 'kneedeep') {
		
		difficultySetting = 'hard';
		
		g_EntityFuncs.FireTargets( 'kill_guide_8_gate', null, null, USE_ON, 0.0f, 0.0f );	
		
		if (idKeyValue == 'hard') {
			dsplmsg("Very hard difficulty selected.", 2.0f, "yellow"); //text message and hold time
		
		}		
		else if (idKeyValue == 'kneedeep') { // the only difference is player speed
			dsplmsg("Knee-deep difficulty selected.", 2.0f, "yellow"); //text message and hold time
			g_EntityFuncs.FireTargets( 'kneedeep_speed', null, null, USE_ON, 0.0f, 0.0f );		
		}			

		trackOneCounterValue1 = 180;
		trackOneCounterValue2 = 240;

		 // trackTwoCounterValue1 = 120; must be old values DONT USE
		 // trackTwoCounterValue2 = 180; must be old values DONT USE
		 trackTwoCounterValue1 = 100;
		 trackTwoCounterValue2 = 160;
		 
		g_EntityFuncs.FireTargets( 'storage_spawn_random', null, null, USE_ON, 0.0f, 10.0f );			 
		
		buddyTimerRate = 1.0f;
		// 4 valves, 2,2 minutes.
		
		CBaseEntity@ squadmaker = g_EntityFuncs.FindEntityByClassname(squadmaker, 'squadmaker');
		while (squadmaker !is null)
		{
		
			string npctype = 'na';
			if (squadmaker.GetCustomKeyvalues().HasKeyvalue( "$s_npctype" ) == true) {
				npctype = squadmaker.GetCustomKeyvalues().GetKeyvalue("$s_npctype").GetString();
			}
	
		
			if (squadmaker.pev.health > 1 and npctype != 'mustardgolem' and npctype != 'monstrosity' and npctype != 'automaton' ) {
				squadmaker.pev.health = squadmaker.pev.health * 1.4; 
			}
			else if (squadmaker.pev.health > 1 and (npctype == 'mustardgolem' or npctype == 'monstrosity') ) {
				squadmaker.pev.health = squadmaker.pev.health * 2.5; 
			}			
			@squadmaker = g_EntityFuncs.FindEntityByClassname(squadmaker, 'squadmaker');
		}			

	}


	g_EntityFuncs.FireTargets( 'skipintro_vote', null, null, USE_TOGGLE, 0.0f, 0.0f );	


	g_EntityFuncs.FireTargets( 'longer_fadein', null, null, USE_TOGGLE, 0.0f, 6.0f );
	g_EntityFuncs.FireTargets( 'longer_fadeout', null, null, USE_TOGGLE, 0.0f, 10.0f );
	g_EntityFuncs.FireTargets( 'intro_spawn', null, null, USE_OFF, 0.0f, 9.9f );
	g_EntityFuncs.FireTargets( 'buddyspawn', null, null, USE_ON, 0.0f, 9.9f );
	g_EntityFuncs.FireTargets( 'respawnem', null, null, USE_ON, 0.0f, 10.0f );		

	g_EntityFuncs.FireTargets( 'pillar_change_class_neutral', null, null, USE_ON, 0.0f, 5.0f );	
		


}

void setDifficultyChosen() {
	difficultyChosen = true;
	@hudUpdater = g_Scheduler.SetInterval( "hudUpdate", 0.2, g_Scheduler.REPEAT_INFINITE_TIMES);	
}


void setSabotageSpeechGivenBoolean() {
	sabotageSpeechGiven = true; //set when sabotage speech has been given, plus a buffer time to delay mixing instructions
}

void beginTrackCountdown() {

	dictionary voiceLine = cast<dictionary>( voiceList['6_sabotageintro'] );
	//addDictionaryToQueue(voiceLine);
	g_Scheduler.SetTimeout( "addDictionaryToQueue", 20, voiceLine ); 
	//non-grinder input first: 20 + 62 seconds until done talking
	//grinder input first: 0 to 32 seconds + 7 (generator talk) + 20 + 62 = 121 secs from input until done talking.

	g_Scheduler.SetTimeout( "checkReminder", checkReminderInterval );
	
	
	trackTwoCounter = Math.RandomLong(300,330);  
	trackOneCounter = Math.RandomLong(130,135); 


	g_Scheduler.SetTimeout( "setSabotageSpeechGivenBoolean", 63 + 90); //to ensure mixing instructions do not play until sabotage intro is spoken. 63 is sound file length.

	if (difficultySetting != 'beginner' ) {
		beginTrackOne();
	}

	beginTrackTwo();
	@roboTimer = g_Scheduler.SetInterval( "roboFunction", 36, g_Scheduler.REPEAT_INFINITE_TIMES);
}




// void beginBuddyTimer(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
void beginBuddyTimer() {
	@pFunctionBuddyTimer = g_Scheduler.SetInterval( "buddyCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES);
}

// void beginTrackOne(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
void beginTrackOne() {
	@pFunctionTrack1 = g_Scheduler.SetInterval( "trackOneCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES);
	
	@pFunctionTrackOneFastMaker = g_Scheduler.SetInterval( "trackOneFastMaker", 120, 20); // every 2 minutes 20 times
}

void reduceGrindMixSectorSize() {

		activeSabotage[0] = 1; //disable sabotage events in disabled sectors. but be careful. i might need to distinguish it from active in the future
		activeSabotage[3] = 1;
		activeSabotageCounter += 2;		
		
		grinder[1].set('brokenState','broken');
		grinder[2].set('brokenState','broken');
		grinder[3].set('brokenState','broken');
		mixer[4].set('brokenState','broken');	
		mixer[5].set('brokenState','broken');
		mixer[6].set('brokenState','broken');
		
		activeRifts[1] = 2; //set to 2 to disable rift in disabled sector
		activeRifts[3] = 2; //set to 2 to disable
		
		emptyGrinders = 3; //for the hud
		emptyMixers = 3;		
		
		mustardGoal = 8; //smaller goal due to fewer machines	
			
		g_EntityFuncs.FireTargets( 'small_map_gates', null, null, USE_ON, 0.0f, 0.0f );			
		g_EntityFuncs.FireTargets( 'grindguide3', null, null, USE_ON, 0.0f, 0.0f );	
		g_EntityFuncs.FireTargets( 'grindguide6', null, null, USE_OFF, 0.0f, 0.0f );	
		g_EntityFuncs.FireTargets( 'mixguide3', null, null, USE_ON, 0.0f, 0.0f );	
		g_EntityFuncs.FireTargets( 'mixguide6', null, null, USE_OFF, 0.0f, 0.0f );		
}

void activateGlowShells() {

	
	array<string> items = {"grinder_part1", "grinder_part2", "mixer_part1", "mixer_part2", "packing_part1", "packing_part2", "generator_part"};	
			
	for( int n = 0; n <7; n++ ) 
	{
		CBaseEntity@ ent = null;
		@ent = g_EntityFuncs.FindEntityByTargetname(null, items[n] );
		ent.pev.renderfx = 19;	
		ent.pev.renderamt = 2;	
		if (items[n] == "generator_part" ) { //two generator parts with same name, get the other one
			@ent = g_EntityFuncs.FindEntityByTargetname(@ent, items[n] );
			ent.pev.renderfx = 19;	
			ent.pev.renderamt = 2;				
		}
	}					
}

void trackOneFastMaker() {

	if (difficultySetting == 'easy') {
		
		trackOneCounterValue1 -= 12;
		trackOneCounterValue2 -= 12;
	}
	else if (difficultySetting == 'normal') {
		trackOneCounterValue1 -= 8;	//7
		trackOneCounterValue2 -= 8;	//7
	}
	else if (difficultySetting == 'hard') {
		trackOneCounterValue1 -= 4;	//3
		trackOneCounterValue2 -= 4;	//3
	}

}

void buddyCountDown() {

	buddyTimerCounter -= 1;
		//g_Game.AlertMessage(at_console, "buddyTimerCounter. buddyTimerCounter is %1",buddyTimerCounter);

	if (buddyTimerCounter == 0)
	{
		if (trackTwoCounter < 80)
		{
			trackTwoCounter += 80; //we dont want a rift to appear right when we are activating buddy event
		}
		if (trackOneCounter < 80)
		{
			trackOneCounter += 80; //we dont want a sabotage to appear right when we are activating buddy event
		}		
		g_EntityFuncs.FireTargets( 'buddy_fadein', null, null, USE_TOGGLE, 0.0f, 8.0f );	
		g_EntityFuncs.FireTargets( 'normal_fadeout', null, null, USE_TOGGLE, 0.0f, 12.5f );		
		g_EntityFuncs.FireTargets( 'buddy_facecam', null, null, USE_ON, 0.0f, 12.5f );	
		
		
		
		dictionary voiceLine = cast<dictionary>( voiceList['18_weelads'] );
		addDictionaryToQueue(voiceLine);		
		g_Scheduler.SetTimeout( "buddyScene", 30);	

		
		// CScheduledFunction@ pFunctionBuddyTimer = g_Scheduler.GetCurrentFunction();
		g_Scheduler.RemoveTimer( pFunctionBuddyTimer );
		// 18/01/2023 @pFunctionBuddyTimer = null;	

		buddyTimerCounter = 999; //so its not 0
	}	
		
}



void buddyScene() {
	g_EntityFuncs.FireTargets( 'quick_fadein', null, null, USE_TOGGLE, 0.0f, 5.5f );

	g_EntityFuncs.FireTargets( 'buddy_facecam', null, null, USE_OFF, 0.0f, 6.5f );	

	g_EntityFuncs.FireTargets( 'buddy_event_mm', null, null, USE_TOGGLE, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'corevalvecam_1', null, null, USE_ON, 0.0f, 6.5f );
	g_EntityFuncs.FireTargets( 'buddy_fadeout', null, null, USE_TOGGLE, 0.0f, 6.5f );
	//g_EntityFuncs.FireTargets( 'buddy_event_t', null, null, USE_TOGGLE, 0.0f, 30.5f );
	
	g_Scheduler.SetTimeout( "dsplmsg", 29, "Player max HP will drop until the situation is dealt with. This is your top priority!", 6.0f, "red" );	
	
	g_EntityFuncs.FireTargets( 'corevalvecam_2', null, null, USE_ON, 0.0f, 11.5f );	
	g_EntityFuncs.FireTargets( 'corevalvecam_1', null, null, USE_OFF, 0.0f, 11.5f );			
	g_EntityFuncs.FireTargets( 'corevalvecam_3', null, null, USE_ON, 0.0f, 15.5f );		
	g_EntityFuncs.FireTargets( 'corevalvecam_2', null, null, USE_OFF, 0.0f, 15.5f );		
	g_EntityFuncs.FireTargets( 'corevalvecam_4', null, null, USE_ON, 0.0f, 19.5f );								
	g_EntityFuncs.FireTargets( 'corevalvecam_3', null, null, USE_OFF, 0.0f, 19.5f );				
	g_EntityFuncs.FireTargets( 'normal_fadein', null, null, USE_TOGGLE, 0.0f, 23.5f );	
	g_EntityFuncs.FireTargets( 'corevalvecam_4', null, null, USE_OFF, 0.0f, 25.5f );	
	g_EntityFuncs.FireTargets( 'normal_fadeout', null, null, USE_TOGGLE, 0.0f, 26.0f );

	
		g_EntityFuncs.FireTargets( 'corevalve_sprite_green1', null, null, USE_OFF, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'corevalve_sprite_red1', null, null, USE_ON, 0.0f, 0.0f );			
		g_EntityFuncs.FireTargets( 'corevalve_sprite_green2', null, null, USE_OFF, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'corevalve_sprite_red2', null, null, USE_ON, 0.0f, 0.0f );	
		g_EntityFuncs.FireTargets( 'corevalve_sprite_green3', null, null, USE_OFF, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'corevalve_sprite_red3', null, null, USE_ON, 0.0f, 0.0f );	
		g_EntityFuncs.FireTargets( 'corevalve_sprite_green4', null, null, USE_OFF, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'corevalve_sprite_red4', null, null, USE_ON, 0.0f, 0.0f );				
		
		@pFunctionBuddyEventTimer = g_Scheduler.SetInterval( "buddyEventActiveTimer", buddyTimerRate, g_Scheduler.REPEAT_INFINITE_TIMES);
		
		activeBuddyEvent = true;
}

void buddyEventActiveTimer() {
	
	
	
		//g_EntityFuncs.FireTargets( 'buddy_lose', null, null, USE_ON, 0.0f, 24.0f );
	
	CBaseEntity@ shutValvesEnt = g_EntityFuncs.FindEntityByTargetname(null, 'shut_valves');

	float shutValves = shutValvesEnt.pev.frags;
	float activeValves = 4 - shutValves;
	int triggerCounter = 0;
	
	if (activeValves == 0) {
			
		// CScheduledFunction@ pFunctionBuddyEventTimer = g_Scheduler.GetCurrentFunction();
		g_Scheduler.RemoveTimer( pFunctionBuddyEventTimer );
		// 18/01/2023 @pFunctionBuddyEventTimer = null;			
		g_EntityFuncs.FireTargets( 'buddy_playersuccess', null, null, USE_ON, 0.0f, 0.0f );
	}
	else if (buddyLost == true) {
		triggerCounter = 8;
	}
	else if (activeValves == 1) {
		triggerCounter = 3;
	}
	else if (activeValves == 2) {
		triggerCounter = 4;
	}	
	else if (activeValves == 3) {
		triggerCounter = 6;
	}
	else if (activeValves == 4) {
		triggerCounter = 8;
	}	
	
	float triggerDelay = 0.0f;
	float triggerIncrement;
	if (triggerCounter > 0) { //divide by zero bad
		triggerIncrement = buddyTimerRate / triggerCounter;
	}
	else {
		triggerIncrement = buddyTimerRate;
	}
	
	for( ; triggerCounter > 0; triggerCounter-- )
	{
		g_EntityFuncs.FireTargets( 'lower_corepool', null, null, USE_ON, 0.0f, triggerDelay );
		g_EntityFuncs.FireTargets( 'buddy_drain_counter', null, null, USE_ON, 0.0f, triggerDelay );	
		triggerDelay = triggerDelay + triggerIncrement; // for smooth reduction of pool height
		
		CBaseEntity@ drainCounter = g_EntityFuncs.FindEntityByTargetname(null, 'buddy_drain_counter');
		float drainCounterFrags = drainCounter.pev.frags;
		if (firstDrainWarning == false && drainCounterFrags > 535 	)	 {
			dictionary voiceLine = cast<dictionary>( voiceList['23_halfdrained'] );
			addDictionaryToQueue(voiceLine);	
			firstDrainWarning = true;			
		}
		else if (secondDrainWarning == false && drainCounterFrags > 910 	)	 { //85% drained
			dictionary voiceLine = cast<dictionary>( voiceList['24_90drained'] );
			addDictionaryToQueue(voiceLine);	
			secondDrainWarning = true;			
		}		

	}
	// 1,7 / 8 = 0,2125
	// (1072 / 8 ) * 1,7 = 227 = 3,8 minutter
	// (1072 / 8) * 1,3 = 174 = 2,9 minutter
	// (1072 / 8) * 1,1 = 147 = 2,45 minutter
	
	
	// 4 valves = 227 = 4 m 7 s
	// 1 valve = 606 = 10m 6s

	
	// limit of counter is 1072
	// 1072 + 90 extra to completely remove liquid = 1162
}

void valveShut(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {

    shutValvesCounter++;
	if (shutValvesCounter == 1) {
		dsplmsg("A core drainage valve has been turned. Three more to go.", 3.0f, "yellow"); //text message and hold time
		dictionary voiceLine = cast<dictionary>( voiceList['19_valveturned1'] );
		addDictionaryToQueue(voiceLine);		
	}
	else if (shutValvesCounter == 2) {
		dsplmsg("A core drainage valve has been turned. Two more to go.", 3.0f, "yellow"); //text message and hold time
		dictionary voiceLine = cast<dictionary>( voiceList['20_valveturned2'] );
		addDictionaryToQueue(voiceLine);		
	}
	else if (shutValvesCounter == 3) {
		dsplmsg("A core drainage valve has been turned. One more to go.", 3.0f, "yellow"); //text message and hold time
		dictionary voiceLine = cast<dictionary>( voiceList['21_valveturned3'] );
		addDictionaryToQueue(voiceLine);		
	}
						
}


void buddySuccess(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {

	activeBuddyEvent = false;
	dictionary voiceLine = cast<dictionary>( voiceList['22_valveturned4'] );
	addDictionaryToQueue(voiceLine);	
}



void trackOneCountDown() {


	if (trackOneCounter == trackTwoCounter) {
		trackTwoCounter += 20; //we want to avoid a rift occurring at the same time as a sabotage
	}


	if ((activeSabotageCounter != 6 or semiActiveSabotageCounter > 0 ) and buddyTimerCounter > 30) //track is paused when buddy event is close, to give priority to buddytimer
	{
		trackOneCounter -= 1;
			//g_Game.AlertMessage(at_console, "trackOneCountDown. trackOneCounter is %1",trackOneCounter);

		if (heavyGoons == false && heavyGoonsCountdown > 0 ) {
			heavyGoonsCountdown -= 1;
		}		
		else {
			heavyGoons = true;
			g_EntityFuncs.FireTargets( 'hw_spriterename', null, null, USE_ON, 0.0f, 0.0f );	//rename all hwgrunt sprites to normal sprite names so the yare also triggered
		}
		
			
		if (trackOneCounter == 0)
		{
		
			if (firstSabotageOccurred == false && voiceQueue.length() > 0 ) { //wait until queue is empty before playing first sabotage event and sound
				trackOneCounter += 1;
				return;
			}		
			if (trackTwoCounter < 20)
			{
				trackTwoCounter += 20; //we dont want a rift to appear right when we are activating a sabotage event
			}
			resetTrackOneCounter();
			
			
			if (activeSabotageCounter != 6) {
				activateTrackOneEvent();			
			}
			else if (semiActiveSabotageCounter > 0 )  {
				renewSemiActiveSabotage();
			}
		}	
	}
	
}



void resetTrackOneCounter() {
	 trackOneCounter = Math.RandomLong(trackOneCounterValue1,trackOneCounterValue2);
	//trackOneCounter = Math.RandomLong(25,60);

}

void activateTrackOneEvent() {

	if (firstSabotageOccurred == false) {
			
		dictionary voiceLine = cast<dictionary>( voiceList['8_goonsarrive'] );
		addDictionaryToQueue(voiceLine);		
		
		g_EntityFuncs.FireTargets( 'normal_fadein', null, null, USE_ON, 0.0f, 0.0f );	
		g_EntityFuncs.FireTargets( 'instruction_cam', null, null, USE_ON, 0.0f, 2.5f );	
		g_EntityFuncs.FireTargets( 'normal_fadeout', null, null, USE_ON, 0.0f, 2.5f );	
		g_EntityFuncs.FireTargets( 'normal_fadein', null, null, USE_ON, 0.0f, 13.5f );	
		g_EntityFuncs.FireTargets( 'normal_fadeout', null, null, USE_ON, 0.0f, 16.0f );	
				
		g_EntityFuncs.FireTargets( 'repair_signs', null, null, USE_ON, 0.0f, 2.5f );	
		g_EntityFuncs.FireTargets( 'repairsigndoor', null, null, USE_ON, 0.0f, 3.5f );	
	}



	array<int> nonActiveSabotage; 
	for( int n = 0; n < 6; n++ )  //add non active sabotage events to an array
	{
		if (activeSabotage[n] == 0){
			nonActiveSabotage.insertLast(n);
		}
	}

	uint randomSabotageSlot = Math.RandomLong(0 , nonActiveSabotage.length() - 1 ); //pick a random slot among the non active sabotages
	
	int randomSabotage = nonActiveSabotage[randomSabotageSlot]; //we have chosen a non active sabotage at random, i hope
	
	activeSabotage[randomSabotage] = 1;
	activeSabotageCounter += 1;
	
	//an event is active until all goons are killed and at least 1 machine is repaired. It becomes semi-active.
	//semi-active events can be called if all other events are used. 
	//if triggering a semi-active event, spawn all monsters but only break non-broken machines
	
	switch( randomSabotage )
	{
	case 0:
		activateGrindSabotage(randomSabotage);
		if (firstSabotageOccurred == false){
			dictionary voiceLine = cast<dictionary>( voiceList['9_gotogrind'] );
			addDictionaryToQueue(voiceLine);			
		}
		else if (voiceQueue.length() == 0) {
			dictionary voiceLine = cast<dictionary>( voiceList['32_grindsabotage'] );
			addDictionaryToQueue(voiceLine);		
		}		
		break;
	case 1:	
		activateGrindSabotage(randomSabotage);
		if (firstSabotageOccurred == false){
			dictionary voiceLine = cast<dictionary>( voiceList['9_gotogrind'] );
			addDictionaryToQueue(voiceLine);			
		}		
		else if (voiceQueue.length() == 0) {
			dictionary voiceLine = cast<dictionary>( voiceList['32_grindsabotage'] );
			addDictionaryToQueue(voiceLine);		
		}		
		break;	
	case 2:
		activateMixSabotage(randomSabotage);
		if (firstSabotageOccurred == false){
			dictionary voiceLine = cast<dictionary>( voiceList['10_gotomixing'] );
			addDictionaryToQueue(voiceLine);			
		}	
		else if (voiceQueue.length() == 0) {
			dictionary voiceLine = cast<dictionary>( voiceList['33_mixsabotage'] );
			addDictionaryToQueue(voiceLine);		
		}		
		break;	
	case 3:
		activateMixSabotage(randomSabotage);
		if (firstSabotageOccurred == false){
			dictionary voiceLine = cast<dictionary>( voiceList['10_gotomixing'] );
			addDictionaryToQueue(voiceLine);			
		}	
		else if (voiceQueue.length() == 0) {
			dictionary voiceLine = cast<dictionary>( voiceList['33_mixsabotage'] );
			addDictionaryToQueue(voiceLine);		
		}		
		break;	
	case 4:
		activatePackSabotage(randomSabotage);
		if (firstSabotageOccurred == false){
			dictionary voiceLine = cast<dictionary>( voiceList['11_gotopacking'] );
			addDictionaryToQueue(voiceLine);			
		}	
		else if (voiceQueue.length() == 0) {
			dictionary voiceLine = cast<dictionary>( voiceList['34_packsabotage'] );
			addDictionaryToQueue(voiceLine);		
		}		
		break;	
	case 5:
		activateGeneratorSabotage(randomSabotage);
		if (firstSabotageOccurred == false){
			dictionary voiceLine = cast<dictionary>( voiceList['12_gotogenerator'] );
			addDictionaryToQueue(voiceLine);			
		}	
		else if (voiceQueue.length() == 0) {
			dictionary voiceLine = cast<dictionary>( voiceList['35_generatorsabotage'] );
			addDictionaryToQueue(voiceLine);		
		}
		break;			
	}	
	
	if (firstSabotageOccurred == false) {
		firstSabotageOccurred = true;
	}		
}

void renewSemiActiveSabotage() {
	array<int> semiActiveSabotage; 
	for( int n = 0; n < 4; n++ )  //add semi sabotage events to an array
	{
		if (activeSabotage[n] == 2){
			semiActiveSabotage.insertLast(n);
		}
	}
	
	uint randomSabotageSlot = Math.RandomLong(0 , semiActiveSabotage.length() - 1 ); //pick a random slot among the semi active sabotages
	
	int randomSabotage = semiActiveSabotage[randomSabotageSlot]; //we have chosen a semi active sabotage at random, i hope
	activeSabotage[randomSabotage] = 1; //changes from 2 to 1
	semiActiveSabotageCounter -= 1;	
	
	
	switch( randomSabotage )
	{
	case 0:
		activateGrindSabotage(randomSabotage);
		if (voiceQueue.length() == 0) {
			dictionary voiceLine = cast<dictionary>( voiceList['32_grindsabotage'] );
			addDictionaryToQueue(voiceLine);		
		}			
		break;
	case 1:	
		activateGrindSabotage(randomSabotage);
		if (voiceQueue.length() == 0) {
			dictionary voiceLine = cast<dictionary>( voiceList['32_grindsabotage'] );
			addDictionaryToQueue(voiceLine);		
		}		
		break;	
	case 2:
		activateMixSabotage(randomSabotage);
		if (voiceQueue.length() == 0) {
			dictionary voiceLine = cast<dictionary>( voiceList['33_mixsabotage'] );
			addDictionaryToQueue(voiceLine);		
		}		
		break;	
	case 3:
		activateMixSabotage(randomSabotage);
		if (voiceQueue.length() == 0) {
			dictionary voiceLine = cast<dictionary>( voiceList['33_mixsabotage'] );
			addDictionaryToQueue(voiceLine);		
		}		
		break;		
	}		
}

void activateGrindSabotage(int randomSabotage) {

	string randomSabotagePlusOne = randomSabotage +1;
	int grinderFirst;
	int grinderLast;	
	
	if (randomSabotage == 0) {
		g_EntityFuncs.FireTargets( 'grind_sector2_sprite', null, null, USE_ON, 0.0f, 0.0f );	
		grinderFirst = 1;
		grinderLast = 3;
		//@pFunctionGrinderSmoke1 = g_Scheduler.SetInterval( "grinderSmoke", 1, g_Scheduler.REPEAT_INFINITE_TIMES, 1);
		//@pFunctionGrinderSmoke2 = g_Scheduler.SetInterval( "grinderSmoke", 1, g_Scheduler.REPEAT_INFINITE_TIMES, 2);
		//@pFunctionGrinderSmoke3 = g_Scheduler.SetInterval( "grinderSmoke", 1, g_Scheduler.REPEAT_INFINITE_TIMES, 3);		
	}	
	else {
		g_EntityFuncs.FireTargets( 'grind_sector1_sprite', null, null, USE_ON, 0.0f, 0.0f );
		grinderFirst = 4;
		grinderLast = 6;	
		//@pFunctionGrinderSmoke4 = g_Scheduler.SetInterval( "grinderSmoke", 1, g_Scheduler.REPEAT_INFINITE_TIMES, 4);
		//@pFunctionGrinderSmoke5 = g_Scheduler.SetInterval( "grinderSmoke", 1, g_Scheduler.REPEAT_INFINITE_TIMES, 5);
		//@pFunctionGrinderSmoke6 = g_Scheduler.SetInterval( "grinderSmoke", 1, g_Scheduler.REPEAT_INFINITE_TIMES, 6);			
	}
	
	for( int n = grinderFirst; n <= grinderLast; n++ ) 
	{
		string brokenState;
		grinder[n].get('brokenState',brokenState);

		string n_s = n;
		
		if (brokenState != 'broken') { //in case event is semiactive we must check if individual machines are broken or not
			string currentState;
			grinder[n].get('state',currentState);

			
			if (currentState == 'active') {
				g_EntityFuncs.FireTargets( 'grinder' + n_s, null, null, USE_OFF, 0.0f, 3.0f );	
			}
		
			brokenGrinderCount++;
			brokenMachinesCount++;
			grinder[n].set('brokenState','broken');
					
			//g_EntityFuncs.FireTargets( 'grinder_light_yellow' + n_s, null, null, USE_OFF, 0.0f, 3.0f );
			g_EntityFuncs.FireTargets( 'grinder_light_red' + n_s, null, null, USE_ON, 0.0f, 3.0f );
			g_EntityFuncs.FireTargets( 'sabotage_explosion_' + n_s, null, null, USE_TOGGLE, 0.0f, 3.0f );
			//g_EntityFuncs.FireTargets( 'sabotage_repair_illu_ron_' + n_s, null, null, USE_TOGGLE, 0.0f, 3.0f ); //needs to be added
			g_EntityFuncs.FireTargets( 'grinder_broken_light_' + n_s, null, null, USE_TOGGLE, 0.0f, 3.0f ); //needs to be added
			g_EntityFuncs.FireTargets( 'grind_alarm' + n_s, null, null, USE_TOGGLE, 0.0f, 3.0f );
			g_EntityFuncs.FireTargets( 'sabotage_smoke_' + n_s, null, null, USE_ON, 0.0f, 3.0f );
			
			CBaseEntity@ ent = null;
			@ent = g_EntityFuncs.FindEntityByTargetname(null, 'sabotage_repair_illu_' + n_s );
			ent.pev.renderamt = 200;				
			
		}
		else {
			
			g_EntityFuncs.FireTargets( 'grinder_repair_lock_' + n_s + '_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
			// repair fields now appear at sabotage start
			// CBaseEntity@ ent = null;
			// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'sabotage_repair_illu_' + n_s );
			// ent.pev.renderamt = 0;		
		}
	}



	
	//g_EntityFuncs.FireTargets( 'grinder_item_sprite', null, null, USE_ON, 0.0f, 0.0f ); // needs to be added
	g_EntityFuncs.FireTargets( 'sabotage_arrival_sound', null, null, USE_ON, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.5f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.5f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.5f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'goons_squadmakers_'  + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 3.0f );		
	//the bomb sprite....	

	if (heavyGoons == true) {
		g_EntityFuncs.FireTargets( 'goon_sprite_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.5f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.0f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.5f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.0f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.5f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 3.0f );	
		g_EntityFuncs.FireTargets( 'goons_squadmakers_hw'  + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 3.0f );	
	}
	else { //due to lack of hwgrunts, trigger dead goon counter to compensate

		g_EntityFuncs.FireTargets( 'dead_goon_counter'  + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 3.0f );	
		
	}
	
	g_EntityFuncs.FireTargets( 'goon_sprite_' + randomSabotagePlusOne, null, null, USE_OFF, 0.0f, 4.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_hw' + randomSabotagePlusOne, null, null, USE_OFF, 0.0f, 4.0f );	
	g_EntityFuncs.FireTargets( 'goon_sprite_amtreset_' + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 4.0f );	
	g_EntityFuncs.FireTargets( 'goon_sprite_amtreset_hw' + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 4.0f );

	//g_Game.AlertMessage(at_console, "activateGrindSabotage. randomSabotage is %1",randomSabotage);
	//g_EntityFuncs.FireTargets( 'rift_teleport_' + randomRift, null, null, USE_ON, 0.0f, 3.0f );	

	//string pathCorner = "grinder" + id + "_a";
	//string pathCornerTarget = "grinder" + id + "_b";
	//CBaseEntity@ grinderPathCorner = g_EntityFuncs.FindEntityByTargetname(null, pathCorner); //null means find the first entity with the targetname
	//g_EntityFuncs.DispatchKeyValue( grinderPathCorner.edict(), "target", pathCornerTarget );
	
	g_EntityFuncs.FireTargets( 'grindsabotage_txt', null, null, USE_ON, 0.0f, 0.0f );	
	
}

void repairGrinder(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {

	CustomKeyvalues@ customKeyvalues = pCaller.GetCustomKeyvalues();
    string id = customKeyvalues.GetKeyvalue("$s_grinder_id").GetString();
	int idInt = atoi(id);
	
	
	
	g_EntityFuncs.FireTargets( 'grinder_repair_lock_' + id + '_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	grinder[idInt].set('brokenState','working'); //this also stops the smoke
	CBaseEntity@ ent = g_EntityFuncs.FindEntityByTargetname(null, 'sabotage_repair_illu_' + id);
	ent.pev.renderamt = 0;
	//g_EntityFuncs.FireTargets( 'sabotage_repair_illu_roff_' + id, null, null, USE_TOGGLE, 0.0f, 0.0f ); //needs to be added
	g_EntityFuncs.FireTargets( 'grinder_broken_light_' + id, null, null, USE_TOGGLE, 0.0f, 0.0f ); //needs to be added
	g_EntityFuncs.FireTargets( 'grind_alarm' + id, null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grind_repairsound' + id, null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'grinder_light_red' + id, null, null, USE_OFF, 0.0f, 0.0f );	
	//check if there are grinders left to be repaired, if yes then trigger grinder_item_sprite
	g_EntityFuncs.FireTargets( 'sabotage_smoke_' + id, null, null, USE_OFF, 0.0f, 0.0f );

	string currentState ;
	grinder[idInt].get('state',currentState);	
	if (currentState == 'active') {
		g_EntityFuncs.FireTargets( 'grinder' + id, null, null, USE_ON, 0.0f, 1.0f );	
		g_EntityFuncs.FireTargets( 'grinder_light_yellow' + id, null, null, USE_ON, 0.0f, 0.0f );

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
	

	string brokenState1;
	grinder[1].get('brokenState',brokenState1);	
	string brokenState2;
	grinder[2].get('brokenState',brokenState2);		
	string brokenState3;
	grinder[3].get('brokenState',brokenState3);		
	string brokenState4;
	grinder[4].get('brokenState',brokenState4);	
	string brokenState5;
	grinder[5].get('brokenState',brokenState5);		
	string brokenState6;
	grinder[6].get('brokenState',brokenState6);		
	
	
	if (activeSabotage[0] == 1 and (brokenState1 == 'working' or brokenState2 == 'working' or brokenState3 == 'working') ) { 
		activeSabotage[0] = 2;
		semiActiveSabotageCounter += 1;		
	}	
	else if (activeSabotage[1] == 1 and (brokenState4 == 'working' or brokenState5 == 'working' or brokenState6 == 'working') ) { 
		activeSabotage[1] = 2;
		semiActiveSabotageCounter += 1;	
	}	
	
	if (activeSabotage[0] == 2 and brokenState1 == 'working' and brokenState2 == 'working' and brokenState3 == 'working' ) { 
		activeSabotage[0] = 0;
		activeSabotageCounter -= 1;		
		semiActiveSabotageCounter -= 1;	
	}
	else if (activeSabotage[1] == 2 and brokenState4 == 'working' and brokenState5 == 'working' and brokenState6 == 'working' ) { 
		activeSabotage[1] = 0;
		activeSabotageCounter -= 1;		
		semiActiveSabotageCounter -= 1;	
	}	
	
	g_EntityFuncs.FireTargets( 'grinderrepair_txt', null, null, USE_ON, 0.0f, 0.0f );	
	brokenGrinderCount--;
	brokenMachinesCount--;
	
	if (brokenGrinderCount== 0 && voiceQueue.length() == 0) {
		dictionary voiceLine = cast<dictionary>( voiceList['39_repairedgrinding'] );
		addDictionaryToQueue(voiceLine);	
	}
	
}

void grinderSmoke(int id) //currently unused function
{
	string brokenState;
	grinder[id].get('brokenState',brokenState);
	if (brokenState == 'working') {
		CScheduledFunction@ pFunctionGrinderSmoke = g_Scheduler.GetCurrentFunction();
		g_Scheduler.RemoveTimer( pFunctionGrinderSmoke );	
		switch( id )
		{
			case 1:
				@pFunctionGrinderSmoke1 = null;
				break;
			case 2:	
				@pFunctionGrinderSmoke2 = null;
				break;	
			case 3:
				@pFunctionGrinderSmoke3 = null;
				break;	
			case 4:
				@pFunctionGrinderSmoke4 = null;
				break;	
			case 5:
				@pFunctionGrinderSmoke5 = null;
				break;	
			case 6:
				@pFunctionGrinderSmoke6 = null;
				break;			
		}		
	}
	else {
		g_EntityFuncs.FireTargets( 'sabotage_smoke_' + id, null, null, USE_TOGGLE, 0.0f, 0.0f );
	}
}


void activateMixSabotage(int randomSabotage) {
	//g_Game.AlertMessage(at_console, "activateMixSabotage. randomSabotage is %1",randomSabotage);
	
	
	string randomSabotagePlusOne = randomSabotage + 1;
	int mixerFirst;
	int mixerLast;	
	if (randomSabotage == 2) {
		mixerFirst = 1;
		mixerLast = 3;
		g_EntityFuncs.FireTargets( 'mix_sector1_sprite', null, null, USE_ON, 0.0f, 0.0f );
	}	
	else {
		mixerFirst = 4;
		mixerLast = 6;	
		g_EntityFuncs.FireTargets( 'mix_sector2_sprite', null, null, USE_ON, 0.0f, 0.0f );
	}
	
	for( int n = mixerFirst; n <= mixerLast; n++ ) 
	{
		string brokenState;
		mixer[n].get('brokenState',brokenState);

		string n_s = n;
			
		if (brokenState != 'broken') {	//if event is semiactive we must check if individual machines are broken or not
	
			string currentState;
			mixer[n].get('state',currentState);

			if (currentState == 'active') {
				g_EntityFuncs.FireTargets( 'mixer' + n_s, null, null, USE_OFF, 0.0f, 3.0f );
				g_EntityFuncs.FireTargets( 'mixer' + n_s, null, null, USE_OFF, 0.0f, 8.1f ); //stop the mixer again to be safe (mixer can start 8 seconds after sabotage event if unlucky)				
			}
			
			//g_Game.AlertMessage(at_console, "Sabotage. what is n_s? it is %1 \n",n_s);
			
			mixer[n].set('brokenState','broken');
			brokenMixerCount++;		
			brokenMachinesCount++;
					
			//g_EntityFuncs.FireTargets( 'mixer_light_yellow' + n_s, null, null, USE_OFF, 0.0f, 3.0f );
			g_EntityFuncs.FireTargets( 'mixer_light_red' + n_s, null, null, USE_ON, 0.0f, 3.0f );
			g_EntityFuncs.FireTargets( 'mixer_explosion_' + n_s, null, null, USE_TOGGLE, 0.0f, 3.0f );
			//g_EntityFuncs.FireTargets( 'mixer_broken_light_' + n_s, null, null, USE_TOGGLE, 0.0f, 3.0f ); //needs to be added
			g_EntityFuncs.FireTargets( 'mix_alarm' + n_s, null, null, USE_TOGGLE, 0.0f, 3.0f );
			g_EntityFuncs.FireTargets( 'mixer_sparks_' + n_s, null, null, USE_ON, 0.0f, 3.0f );
			CBaseEntity@ ent = null;
			@ent = g_EntityFuncs.FindEntityByTargetname(null, 'mix_sabotage_repair_illu_' + n_s );
			ent.pev.renderamt = 200;				
		}
		else {
			g_EntityFuncs.FireTargets( 'mixer_repair_lock_' + n_s + '_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
			// CBaseEntity@ ent = null;
			// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'mix_sabotage_repair_illu_' + n_s );
			// ent.pev.renderamt = 0;	
		}		
	}	
	
	//g_EntityFuncs.FireTargets( 'mixer_item_sprite', null, null, USE_ON, 0.0f, 0.0f ); // needs to be added
	g_EntityFuncs.FireTargets( 'sabotage_arrival_sound', null, null, USE_ON, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.5f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.5f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.5f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'goons_squadmakers_'  + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 3.0f );		
	
	if (heavyGoons == true) {
		g_EntityFuncs.FireTargets( 'goon_sprite_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.5f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.0f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.5f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.0f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.5f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 3.0f );	
		g_EntityFuncs.FireTargets( 'goons_squadmakers_hw'  + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 3.0f );	
	}
	else { //due to lack of hwgrunts, trigger dead goon counter to compensate

		g_EntityFuncs.FireTargets( 'dead_goon_counter'  + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 3.0f );	
		
	}
	
	g_EntityFuncs.FireTargets( 'goon_sprite_' + randomSabotagePlusOne, null, null, USE_OFF, 0.0f, 4.0f );	
	g_EntityFuncs.FireTargets( 'goon_sprite_hw' + randomSabotagePlusOne, null, null, USE_OFF, 0.0f, 4.0f );	
	g_EntityFuncs.FireTargets( 'goon_sprite_amtreset_' + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 4.0f );	
	g_EntityFuncs.FireTargets( 'goon_sprite_amtreset_hw' + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 4.0f );
	
	g_EntityFuncs.FireTargets( 'mixsabotage_txt', null, null, USE_ON, 0.0f, 0.0f );	

}

void repairMixer(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {

	CustomKeyvalues@ customKeyvalues = pCaller.GetCustomKeyvalues();
    string id = customKeyvalues.GetKeyvalue("$s_mixer_id").GetString();
	int idInt = atoi(id);
	
		

	
	g_EntityFuncs.FireTargets( 'mixer_repair_lock_' + id + '_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	mixer[idInt].set('brokenState','working'); 
		
	CBaseEntity@ ent = g_EntityFuncs.FindEntityByTargetname(null, 'mix_sabotage_repair_illu_' + id);
	ent.pev.renderamt = 0;
	//g_EntityFuncs.FireTargets( 'sabotage_repair_illu_roff_' + id, null, null, USE_TOGGLE, 0.0f, 0.0f ); //needs to be added
	//g_EntityFuncs.FireTargets( 'mixer_broken_light_' + id, null, null, USE_TOGGLE, 0.0f, 0.0f ); //needs to be added
	g_EntityFuncs.FireTargets( 'mix_alarm' + id, null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mix_repairsound' + id, null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'mixer_light_red' + id, null, null, USE_OFF, 0.0f, 0.0f );	
	//check if there are mixers left to be repaired, if yes then trigger mixer_item_sprite
	g_EntityFuncs.FireTargets( 'mixer_sparks_' + id, null, null, USE_OFF, 0.0f, 0.0f );

	string currentState;
	mixer[idInt].get('state',currentState);	
	if (currentState == 'active') {
		g_EntityFuncs.FireTargets( 'mixer' + id, null, null, USE_ON, 0.0f, 1.0f );	
		g_EntityFuncs.FireTargets( 'mixer_light_yellow' + id, null, null, USE_ON, 0.0f, 0.0f );

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
	
	string brokenState1;
	mixer[1].get('brokenState',brokenState1);	
	string brokenState2;
	mixer[2].get('brokenState',brokenState2);		
	string brokenState3;
	mixer[3].get('brokenState',brokenState3);		
	string brokenState4;
	mixer[4].get('brokenState',brokenState4);	
	string brokenState5;
	mixer[5].get('brokenState',brokenState5);		
	string brokenState6;
	mixer[6].get('brokenState',brokenState6);		
	
	

	
	
	if (activeSabotage[2] == 1 and (brokenState1 == 'working' or brokenState2 == 'working' or brokenState3 == 'working' )) { 
		activeSabotage[2] = 2;	//2 means semiactive
		semiActiveSabotageCounter += 1;	
	}
	else if (activeSabotage[3] == 1 and (brokenState4 == 'working' or brokenState5 == 'working' or brokenState6 == 'working' )) { 
		activeSabotage[3] = 2;
		semiActiveSabotageCounter += 1;	
	}	
	
	
	
	if (activeSabotage[2] == 2 and brokenState1 == 'working' and brokenState2 == 'working' and brokenState3 == 'working' ) { 
		activeSabotage[2] = 0;
		activeSabotageCounter -= 1;		
		semiActiveSabotageCounter -= 1;	
	}
	else if (activeSabotage[3] == 2 and brokenState4 == 'working' and brokenState5 == 'working' and brokenState6 == 'working' ) { 
		activeSabotage[3] = 0;
		activeSabotageCounter -= 1;		
		semiActiveSabotageCounter -= 1;	
	}
	
	g_EntityFuncs.FireTargets( 'mixerrepair_txt', null, null, USE_ON, 0.0f, 0.0f );	
	brokenMixerCount--;
	brokenMachinesCount--;
	if (brokenMixerCount== 0 && voiceQueue.length() == 0) {
		dictionary voiceLine = cast<dictionary>( voiceList['40_repairedmixing'] );
		addDictionaryToQueue(voiceLine);	
	}	
}


void activatePackSabotage(int randomSabotage) {
	//g_Game.AlertMessage(at_console, "activatePackSabotage.");
	
	string randomSabotagePlusOne = randomSabotage + 1;

	string currentState;
	packing.get('state',currentState);
	
	brokenPackingMachines = 2;
	
	if (currentState == 'active') {
		g_EntityFuncs.FireTargets( 'conveyor_counter', null, null, USE_TOGGLE, 0.0f, 3.0f );	
		g_EntityFuncs.FireTargets( 'conveyor_push', null, null, USE_OFF, 0.0f, 3.0f ); 
		g_EntityFuncs.FireTargets( 'mustardstreams_off', null, null, USE_ON, 0.0f, 3.0f ); //they dont get reset, but its ok
		g_EntityFuncs.FireTargets( 'conveyorsounds', null, null, USE_OFF, 0.0f, 3.0f ); 
		g_EntityFuncs.FireTargets( 'conveyorsounds2', null, null, USE_OFF, 0.0f, 3.0f ); 
		g_EntityFuncs.FireTargets( 'conveyorsounds3', null, null, USE_OFF, 0.0f, 3.0f ); 
	}
	
	packing.set('brokenState','broken');
			

	g_EntityFuncs.FireTargets( 'pack_machine1_sprite', null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'pack_machine2_sprite', null, null, USE_ON, 0.0f, 0.0f );
	//g_EntityFuncs.FireTargets( 'packing_light_yellow', null, null, USE_OFF, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'packing_light_red', null, null, USE_ON, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'packing_explosion', null, null, USE_TOGGLE, 0.0f, 3.0f );
	//g_EntityFuncs.FireTargets( 'packing_broken_light_', null, null, USE_TOGGLE, 0.0f, 3.0f ); //needs to be added
	g_EntityFuncs.FireTargets( 'packing_alarm1', null, null, USE_TOGGLE, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'packing_alarm2', null, null, USE_TOGGLE, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'packing_sparks1', null, null, USE_ON, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'packing_sparks2', null, null, USE_ON, 0.0f, 3.0f );
	
	CBaseEntity@ ent = null;
	@ent = g_EntityFuncs.FindEntityByTargetname(null, 'pack_sabotage_repair_illu_2');
	ent.pev.renderamt = 200;	
	@ent = g_EntityFuncs.FindEntityByTargetname(null, 'pack_sabotage_repair_illu_1');
	ent.pev.renderamt = 200;	

	
	//g_EntityFuncs.FireTargets( 'packing_item_sprite', null, null, USE_ON, 0.0f, 0.0f ); // needs to be added
	g_EntityFuncs.FireTargets( 'sabotage_arrival_sound', null, null, USE_ON, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.5f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.5f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.5f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'goons_squadmakers_'  + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 3.0f );		
	
	if (heavyGoons == true) {
		g_EntityFuncs.FireTargets( 'goon_sprite_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.5f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.0f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.5f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.0f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.5f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 3.0f );	
		g_EntityFuncs.FireTargets( 'goons_squadmakers_hw'  + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 3.0f );	
	}
	else { //due to lack of hwgrunts, trigger dead goon counter to compensate

		g_EntityFuncs.FireTargets( 'dead_goon_counter5a', null, null, USE_TOGGLE, 0.0f, 3.0f );	
		g_EntityFuncs.FireTargets( 'dead_goon_counter5b', null, null, USE_TOGGLE, 0.0f, 3.0f );	
		
	}
	
	g_EntityFuncs.FireTargets( 'goon_sprite_' + randomSabotagePlusOne, null, null, USE_OFF, 0.0f, 4.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_hw' + randomSabotagePlusOne, null, null, USE_OFF, 0.0f, 4.0f );		
	g_EntityFuncs.FireTargets( 'goon_sprite_amtreset_' + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 4.0f );	
	g_EntityFuncs.FireTargets( 'goon_sprite_amtreset_hw' + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 4.0f );
	
	g_EntityFuncs.FireTargets( 'packingsabotage_txt', null, null, USE_ON, 0.0f, 0.0f );	
	brokenMachinesCount += 3;
}

void repairPacking(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {

	CustomKeyvalues@ customKeyvalues = pCaller.GetCustomKeyvalues();
    string id = customKeyvalues.GetKeyvalue("$s_packing_id").GetString();

	int idInt = atoi(id);
	g_EntityFuncs.FireTargets( 'packing_repair_lock_' + id + '_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	
	//g_EntityFuncs.FireTargets( 'packing_broken_light_' + id, null, null, USE_TOGGLE, 0.0f, 0.0f ); //needs to be added	
	g_EntityFuncs.FireTargets( 'packing_alarm' + id, null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'packing_repairsound' + id, null, null, USE_TOGGLE, 0.0f, 0.0f );	
	g_EntityFuncs.FireTargets( 'packing_sparks' + id, null, null, USE_OFF, 0.0f, 0.0f );
	CBaseEntity@ ent = g_EntityFuncs.FindEntityByTargetname(null, 'pack_sabotage_repair_illu_' + id);
	ent.pev.renderamt = 0;	
	
	brokenPackingMachines -= 1;	

	if (brokenPackingMachines == 0)	{
	
		activeSabotage[4] = 0;
		activeSabotageCounter -= 1;	
	
		packing.set('brokenState','working'); 

		g_EntityFuncs.FireTargets( 'packing_light_red', null, null, USE_OFF, 0.0f, 0.0f );	
		//check if there are packing left to be repaired, if yes then trigger packing_item_sprite
		
		string currentState ;
		packing.get('state',currentState);	
		if (currentState == 'active') {
			g_EntityFuncs.FireTargets( 'conveyor_counter', null, null, USE_TOGGLE, 0.0f, 0.0f );	
			g_EntityFuncs.FireTargets( 'conveyor_push', null, null, USE_ON, 0.0f, 0.0f ); 
			g_EntityFuncs.FireTargets( 'packing_light_yellow', null, null, USE_ON, 0.0f, 0.0f );
			g_EntityFuncs.FireTargets( 'conveyorsounds', null, null, USE_ON, 0.0f, 0.0f ); 
			g_EntityFuncs.FireTargets( 'conveyorsounds2', null, null, USE_ON, 0.0f, 0.0f ); 
			g_EntityFuncs.FireTargets( 'conveyorsounds3', null, null, USE_ON, 0.0f, 0.0f ); 			

			// wtf mate @pFunctionMixer1 = g_Scheduler.SetInterval( "packingCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES, id);
			@pFunctionPacking = g_Scheduler.SetInterval( "packingCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES);
		}		
		
		g_EntityFuncs.FireTargets( 'packingrepair_txt', null, null, USE_ON, 0.0f, 0.0f );	
		brokenMachinesCount -= 3;
		if (voiceQueue.length() == 0) {
			dictionary voiceLine = cast<dictionary>( voiceList['41_repairedpacking'] );
			addDictionaryToQueue(voiceLine);		
		}			
	}
	
	
}

void activateGeneratorSabotage(int randomSabotage) {
	//g_Game.AlertMessage(at_console, "activateGeneratorSabotage.");
	
	string randomSabotagePlusOne = randomSabotage + 1;
	
	generatorBroken = true;

	grinderCounterTime *= 2;
    mixerCounterTime *= 2;
    packingCounterTime *= 2;

	packingCounterTimeLeft *= 2;		
	
	for( int n = 0; n < 7; n++ ) 
	{
		grinderCounter[n] *= 2;	
		mixerCounter[n] *= 2;	
	}	

	for( int n = 1; n <= 6; n++ ) 
	{
		CBaseEntity@ ent = null;
		@ent = g_EntityFuncs.FindEntityByTargetname(null, 'mixer' + n);
		ent.pev.speed = 25;
		
		@ent = g_EntityFuncs.FindEntityByTargetname(null, 'grinder' + n + '_a');
		ent.pev.speed /= 2;
		@ent = g_EntityFuncs.FindEntityByTargetname(null, 'grinder' + n + '_b');
		ent.pev.speed /= 2;		
	}	
	
	g_EntityFuncs.FireTargets( 'generator_sprite', null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'generator_explosion', null, null, USE_TOGGLE, 0.0f, 3.0f );
	//g_EntityFuncs.FireTargets( 'generator_broken_light_', null, null, USE_TOGGLE, 0.0f, 3.0f ); //needs to be added
	g_EntityFuncs.FireTargets( 'generator_alarm1', null, null, USE_TOGGLE, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'generator_sparks1', null, null, USE_ON, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'generator_beams', null, null, USE_OFF, 0.0f, 3.0f );
	
	CBaseEntity@ ent = null;
	@ent = g_EntityFuncs.FindEntityByTargetname(null, 'gen_sabotage_repair_illu_1');
	ent.pev.renderamt = 200;		
	
	CBaseEntity@ generatorSound = g_EntityFuncs.FindEntityByTargetname(null, 'generator_sound'); //null means find the first entity with the targetname
	g_EntityFuncs.DispatchKeyValue( generatorSound.edict(), "health", 2 );		

	//g_EntityFuncs.FireTargets( 'generator_item_sprite', null, null, USE_ON, 0.0f, 0.0f ); // needs to be added
	g_EntityFuncs.FireTargets( 'sabotage_arrival_sound', null, null, USE_ON, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.5f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.5f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.5f );
	g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'goons_squadmakers_'  + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 3.0f );		
	
	if (heavyGoons == true) {
		g_EntityFuncs.FireTargets( 'goon_sprite_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 0.5f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.0f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 1.5f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.0f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 2.5f );
		g_EntityFuncs.FireTargets( 'goon_sprite_amtincrease_hw' + randomSabotagePlusOne, null, null, USE_ON, 0.0f, 3.0f );	
		g_EntityFuncs.FireTargets( 'goons_squadmakers_hw'  + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 3.0f );	
	}
	else { //due to lack of hwgrunts, trigger dead goon counter to compensate

		g_EntityFuncs.FireTargets( 'dead_goon_counter'  + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 3.0f );	
		
	}
	
	g_EntityFuncs.FireTargets( 'goon_sprite_' + randomSabotagePlusOne, null, null, USE_OFF, 0.0f, 4.0f );
	g_EntityFuncs.FireTargets( 'goon_sprite_hw' + randomSabotagePlusOne, null, null, USE_OFF, 0.0f, 4.0f );		
	g_EntityFuncs.FireTargets( 'goon_sprite_amtreset_' + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 4.0f );	
	g_EntityFuncs.FireTargets( 'goon_sprite_amtreset_hw' + randomSabotagePlusOne, null, null, USE_TOGGLE, 0.0f, 4.0f );	

	g_EntityFuncs.FireTargets( 'generatorsabotage_txt', null, null, USE_ON, 0.0f, 0.0f );

	
	brokenMachinesCount += 3;
}

void repairGenerator(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {

	activeSabotage[5] = 0;
	activeSabotageCounter -= 1;			
		
	generatorBroken = false;	

	g_EntityFuncs.FireTargets( 'generator_repair_lock_1_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
	//g_EntityFuncs.FireTargets( 'generator_broken_light_' + id, null, null, USE_TOGGLE, 0.0f, 0.0f ); //needs to be added	
	g_EntityFuncs.FireTargets( 'generator_alarm1', null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'generator_repairsound1', null, null, USE_TOGGLE, 0.0f, 0.0f );	
	g_EntityFuncs.FireTargets( 'generator_sparks1', null, null, USE_OFF, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'generator_beams', null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'generatorrepair_txt', null, null, USE_ON, 0.0f, 0.0f );
	
	CBaseEntity@ generatorSound = g_EntityFuncs.FindEntityByTargetname(null, 'generator_sound'); //null means find the first entity with the targetname
	g_EntityFuncs.DispatchKeyValue( generatorSound.edict(), "health", 10 );		
	
	CBaseEntity@ ent = g_EntityFuncs.FindEntityByTargetname(null, 'gen_sabotage_repair_illu_1');
	ent.pev.renderamt = 0;	
	//check if there are packing left to be repaired, if yes then trigger generator_item_sprite
		
	grinderCounterTime /= 2;
    mixerCounterTime /= 2;
    packingCounterTime /= 2;

	if (packingCounterTimeLeft % 2 != 0) { //just to be safe. what happens if you divide an integer of 3 with 2?
		packingCounterTimeLeft -= 1;
	}
	packingCounterTimeLeft /= 2;		
	
	for( int n = 0; n < 7; n++ ) 
	{
		if (grinderCounter[n] % 2 != 0) {
			grinderCounter[n] -= 1;
		}	
		if (mixerCounter[n] % 2 != 0) {
			mixerCounter[n] -= 1;
		}			
		grinderCounter[n] /= 2;	
		mixerCounter[n] /= 2;	
	}	

	for( int n = 1; n <= 6; n++ ) 
	{
		@ent = g_EntityFuncs.FindEntityByTargetname(null, 'mixer' + n);
		ent.pev.speed = 50;
		
		@ent = g_EntityFuncs.FindEntityByTargetname(null, 'grinder' + n + '_a');
		ent.pev.speed *= 2;
		@ent = g_EntityFuncs.FindEntityByTargetname(null, 'grinder' + n + '_b');
		ent.pev.speed *= 2;		
	}	
	
	
	brokenMachinesCount -= 3;
	if (voiceQueue.length() == 0) {
		dictionary voiceLine = cast<dictionary>( voiceList['42_generatorrepaired'] );
		addDictionaryToQueue(voiceLine);		
	}	
}


void unlockRepair(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
	CustomKeyvalues@ customKeyvalues = pCaller.GetCustomKeyvalues();
    string id = customKeyvalues.GetKeyvalue("$s_sabotage_id").GetString();

	CBaseEntity@ ent = null;
	
	
	//this can be shortened by 50-75%
	if (id == '1') {
		g_EntityFuncs.FireTargets( 'grind_sector2_sprite', null, null, USE_OFF, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'grinder_repair_lock_1_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'grinder_repair_lock_2_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'grinder_repair_lock_3_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'sabotage_repair_illu_1');
		// ent.pev.renderamt = 200;
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'sabotage_repair_illu_2');
		// ent.pev.renderamt = 200;
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'sabotage_repair_illu_3');
		// ent.pev.renderamt = 200;
	}
	else if (id == '2') {	
		g_EntityFuncs.FireTargets( 'grind_sector1_sprite', null, null, USE_OFF, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'grinder_repair_lock_4_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'grinder_repair_lock_5_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'grinder_repair_lock_6_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'sabotage_repair_illu_4');
		// ent.pev.renderamt = 200;
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'sabotage_repair_illu_5');
		// ent.pev.renderamt = 200;
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'sabotage_repair_illu_6');
		// ent.pev.renderamt = 200;	
	}
	else if (id == '3') {	
		g_EntityFuncs.FireTargets( 'mix_sector1_sprite', null, null, USE_OFF, 0.0f, 0.0f );	
		g_EntityFuncs.FireTargets( 'mixer_repair_lock_1_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'mixer_repair_lock_2_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'mixer_repair_lock_3_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'mix_sabotage_repair_illu_1');
		// ent.pev.renderamt = 200;
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'mix_sabotage_repair_illu_2');
		// ent.pev.renderamt = 200;
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'mix_sabotage_repair_illu_3');
		// ent.pev.renderamt = 200;	
	}
	else if (id == '4') {	
		g_EntityFuncs.FireTargets( 'mix_sector2_sprite', null, null, USE_OFF, 0.0f, 0.0f );		
		g_EntityFuncs.FireTargets( 'mixer_repair_lock_4_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'mixer_repair_lock_5_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'mixer_repair_lock_6_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'mix_sabotage_repair_illu_4');
		// ent.pev.renderamt = 200;
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'mix_sabotage_repair_illu_5');
		// ent.pev.renderamt = 200;
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'mix_sabotage_repair_illu_6');
		// ent.pev.renderamt = 200;	
	}
	else if (id == '5a') {	
		g_EntityFuncs.FireTargets( 'pack_machine1_sprite', null, null, USE_OFF, 0.0f, 0.0f );	
		g_EntityFuncs.FireTargets( 'packing_repair_lock_1_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'pack_sabotage_repair_illu_1');
		// ent.pev.renderamt = 200;
	}
	else if (id == '5b') {	
		g_EntityFuncs.FireTargets( 'pack_machine2_sprite', null, null, USE_OFF, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'packing_repair_lock_2_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'pack_sabotage_repair_illu_2');
		// ent.pev.renderamt = 200;	
	}	
	else if (id == '6') {	
		g_EntityFuncs.FireTargets( 'generator_sprite', null, null, USE_OFF, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'generator_repair_lock_1_r', null, null, USE_TOGGLE, 0.0f, 0.0f );
		// @ent = g_EntityFuncs.FindEntityByTargetname(null, 'gen_sabotage_repair_illu_1');
		// ent.pev.renderamt = 200;	
	}	
}


// void beginTrackTwo(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
void beginTrackTwo() {
	@pFunctionRifts = g_Scheduler.SetInterval( "trackTwoCountDown", 1, g_Scheduler.REPEAT_INFINITE_TIMES);
	
	@pFunctionTrackTwoFastMaker = g_Scheduler.SetInterval( "trackTwoFastMaker", 60, g_Scheduler.REPEAT_INFINITE_TIMES);
	
}

void trackTwoFastMaker() {


	//move to mapEndReachedFunction()?
	if (activeRiftsCounter >= 7  ) {
		//CScheduledFunction@ pFunctionTrackTwoFastMaker = g_Scheduler.GetCurrentFunction();
		g_Scheduler.RemoveTimer( pFunctionTrackTwoFastMaker );
		// 18/01/2023 @pFunctionTrackTwoFastMaker = null;		
	}

	// if (trackTwoCounterValue1 <= 15 and trackTwoCounterValue2 <= 20 ) {
		// CScheduledFunction@ pFunctionTrackTwoFastMaker = g_Scheduler.GetCurrentFunction();
		// g_Scheduler.RemoveTimer( pFunctionTrackTwoFastMaker );
		// @pFunctionTrackTwoFastMaker = null;		
	// }
	

	// minimum reached in 55 minutes on easy, <45 minutes on normal, <35 minutes on hard

	//since it takes 3 seconds to open the teleport, you have 12-17 available seconds to close a rift.
	if (trackTwoCounterValue1 > 15  ) {
		trackTwoCounterValue1 -= 3;	
	}
	if (trackTwoCounterValue2 > 20  ) {
		trackTwoCounterValue2 -= 3;	
	}	
	
	if (trackTwoCounterValue1 <= 15 and trackTwoCounterValue2 <= 20  ) {

		// timed by 1,3 means 6892 health after 10 minutes.
		CBaseEntity@ crystal = g_EntityFuncs.FindEntityByTargetname(null, 'crystaltemplate'); //null means find the first entity with the targetname
		crystal.pev.health = crystal.pev.health * 1.5; 
		CBaseEntity@ crystal2 = g_EntityFuncs.FindEntityByTargetname(null, 'crystaltemplate2'); //null means find the first entity with the targetname
		crystal2.pev.health = crystal2.pev.health * 1.5; 		
	}		



}

void trackTwoCountDown() {

//remove, debugging
	// if (activeRiftsCounter >= 2  ){
		// mapEndReachedFunction();
	// }

	if (buddyTimerCounter > 30) { //track is paused when buddy event is close, to give priority to buddytimer 
		trackTwoCounter -= 1;
			//g_Game.AlertMessage(at_console, "trackTwoCountDown. trackTwoCounter is %1",trackTwoCounter);


		if (trackTwoCounter == 0){

			if (firstRiftAppeared == false && voiceQueue.length() > 0 ) { //wait until queue is empty before playing first rift event and sound
				trackTwoCounter += 1;
				return;
			}			
			//CScheduledFunction@ pFunctionRifts = g_Scheduler.GetCurrentFunction();
			//g_Scheduler.RemoveTimer( pFunctionRifts );
			//@pFunctionRifts = null;
			

			if (trackOneCounter <= 11) //was originally <20, but lowered to allow sabotages when rift rate is frequent
			{
				trackOneCounter += 11; //we dont want a sabotage to appear right when we are activating a rift event
			}
			
			resetTrackTwoCounter();
		
			activateTrackTwoEvent();
		}	
	}
}

void resetTrackTwoCounter() {
	trackTwoCounter = Math.RandomLong(trackTwoCounterValue1,trackTwoCounterValue2);
	
	//trackTwoCounter = Math.RandomLong(25,60);
}


void activateTrackTwoEvent() {

	if (firstRiftAppeared == false) {
		firstRiftAppeared = true;
		dictionary voiceLine = cast<dictionary>( voiceList['17_firstrift'] );
		addDictionaryToQueue(voiceLine);			
		g_EntityFuncs.FireTargets( 'normal_fadein', null, null, USE_ON, 0.0f, 0.0f );	
		g_EntityFuncs.FireTargets( 'instruction_cam', null, null, USE_ON, 0.0f, 2.5f );	
		g_EntityFuncs.FireTargets( 'normal_fadeout', null, null, USE_ON, 0.0f, 2.5f );	
		g_EntityFuncs.FireTargets( 'normal_fadein', null, null, USE_ON, 0.0f, 13.5f );	
		g_EntityFuncs.FireTargets( 'normal_fadeout', null, null, USE_ON, 0.0f, 16.0f );	
		
		g_EntityFuncs.FireTargets( 'rift_signs', null, null, USE_ON, 0.0f, 2.5f );	
		g_EntityFuncs.FireTargets( 'riftsigndoor', null, null, USE_ON, 0.0f, 3.5f );	
		
	}


	if (kingpins == false && activeRiftsCounter >= 5) {
		kingpins = true;
		g_EntityFuncs.FireTargets( 'kingpin_spriterename', null, null, USE_ON, 0.0f, 0.0f );		
	}
	
	array<int> nonActiveRifts; 
	for( int n = 0; n < 9; n++ )  //add non active rifts to an array
	{
		if (activeRifts[n] == 0){
			nonActiveRifts.insertLast(n);
		}
	}

	uint randomRiftSlot = Math.RandomLong(0 , nonActiveRifts.length() - 1 ); //pick a random slot among the non active rifts
	int randomRift = nonActiveRifts[randomRiftSlot]; //we have chosen a non active rift at random, i hope
	
	activeRifts[randomRift] = 1;
	activeRiftsCounter += 1;
	randomRift += 1; //because we dont have a 0 rift in reality
	
	//g_Game.AlertMessage(at_console, "randomRift is %1",randomRift);

	
	g_EntityFuncs.FireTargets( 'rift_globalriftsound', null, null, USE_ON, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'rift_teleport_' + randomRift, null, null, USE_ON, 0.0f, 3.0f );	
	g_EntityFuncs.FireTargets( 'rift_sprite_s_' + randomRift, null, null, USE_ON, 0.0f, 0.0f );
	
	// g_Scheduler.SetInterval( "riftSpriteIncrease", 0.5, 6 );
	// CBaseEntity@ ent = null;
	// while ( ( @ent = g_EntityFuncs.FindEntityByTargetname(@ent, 'rift_sprite_s_' + randomRift) ) !is null )
	// {
		// ent.pev.renderamt += 40;
	// }	
	
	g_EntityFuncs.FireTargets( 'rift_sprite_amtincrease_s_' + randomRift, null, null, USE_ON, 0.0f, 0.5f );
	g_EntityFuncs.FireTargets( 'rift_sprite_amtincrease_s_' + randomRift, null, null, USE_ON, 0.0f, 1.0f );
	g_EntityFuncs.FireTargets( 'rift_sprite_amtincrease_s_' + randomRift, null, null, USE_ON, 0.0f, 1.5f );
	g_EntityFuncs.FireTargets( 'rift_sprite_amtincrease_s_' + randomRift, null, null, USE_ON, 0.0f, 2.0f );
	g_EntityFuncs.FireTargets( 'rift_sprite_amtincrease_s_' + randomRift, null, null, USE_ON, 0.0f, 2.5f );
	g_EntityFuncs.FireTargets( 'rift_sprite_amtincrease_s_' + randomRift, null, null, USE_ON, 0.0f, 3.0f );
	g_EntityFuncs.FireTargets( 'rift_squadmakers_s_'  + randomRift, null, null, USE_ON, 0.0f, 3.0f );
	
	string riftSize;
	
	if (difficultySetting != 'hard' && activeBigRifts > 2) {
		riftSize = "s_"; //small rift
	}
	else {
		riftSize = "b_"; //big rift
		activeBigRifts += 1;
		g_EntityFuncs.FireTargets( 'rift_sprite_b_' + randomRift, null, null, USE_ON, 0.0f, 0.0f );
		g_EntityFuncs.FireTargets( 'rift_sprite_amtincrease_b_' + randomRift, null, null, USE_ON, 0.0f, 0.5f );
		g_EntityFuncs.FireTargets( 'rift_sprite_amtincrease_b_' + randomRift, null, null, USE_ON, 0.0f, 1.0f );
		g_EntityFuncs.FireTargets( 'rift_sprite_amtincrease_b_' + randomRift, null, null, USE_ON, 0.0f, 1.5f );
		g_EntityFuncs.FireTargets( 'rift_sprite_amtincrease_b_' + randomRift, null, null, USE_ON, 0.0f, 2.0f );
		g_EntityFuncs.FireTargets( 'rift_sprite_amtincrease_b_' + randomRift, null, null, USE_ON, 0.0f, 2.5f );
		g_EntityFuncs.FireTargets( 'rift_sprite_amtincrease_b_' + randomRift, null, null, USE_ON, 0.0f, 3.0f );
		g_EntityFuncs.FireTargets( 'rift_squadmakers_b_'  + randomRift, null, null, USE_ON, 0.0f, 3.0f );	

		if (kingpins == true) {
			g_EntityFuncs.FireTargets( 'rift_squadmakers_k_'  + randomRift, null, null, USE_TOGGLE, 0.0f, 3.0f );	
			
		}	
			
		
	}
	g_EntityFuncs.FireTargets( 'rift_crystal_' + riftSize + randomRift, null, null, USE_ON, 0.0f, 0.0f ); //there are two crystal types, one for small rifts and one for big rifts
	
	if (activeRiftsCounter == 7) {
		RiftLoseCondition(); //lose game because 7 rifts
		return;
	}	
	
	if (firstRiftAppeared == true && voiceQueue.length() == 0 && activeRiftsCounter < 5) {
		dictionary voiceLine = cast<dictionary>( voiceList['58_riftopened'] );
		addDictionaryToQueue(voiceLine);	
	}
	else if (activeRiftsCounter == 5) {
		dictionary voiceLine = cast<dictionary>( voiceList['59_5rifts'] );
		addDictionaryToQueue(voiceLine);	
	}
	else if (activeRiftsCounter == 6) {
		dictionary voiceLine = cast<dictionary>( voiceList['60_6rifts'] );
		addDictionaryToQueue(voiceLine);	
	}
	
	g_EntityFuncs.FireTargets( 'riftopened_txt', null, null, USE_ON, 0.0f, 0.0f );
}



void crystalBroken(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	//g_Game.AlertMessage(at_console, "crystalBroken triggered");
	
	g_EntityFuncs.DispatchKeyValue( pActivator.edict(), "health", 110 );//set player health boost to prevent fall dying and to boost nice players
			
	
	CustomKeyvalues@ customKeyvalues = pCaller.GetCustomKeyvalues();
    string idKeyValue = customKeyvalues.GetKeyvalue("$s_crystal_id").GetString();	
	string riftSize = customKeyvalues.GetKeyvalue("$s_crystal_riftsize").GetString();
	
	int idInt = atoi(idKeyValue);

	if (riftSize == 'b') {
		activeBigRifts -= 1;
		g_EntityFuncs.FireTargets( 'rift_sprite_' + riftSize + '_' + idKeyValue, null, null, USE_OFF, 0.0f, 4.0f );
		g_EntityFuncs.FireTargets( 'rift_sprite_amtreset_' + riftSize + '_' + idKeyValue, null, null, USE_TOGGLE, 0.0f, 4.0f );
		g_EntityFuncs.FireTargets( 'rift_squadmakers_' + riftSize + '_' + idKeyValue, null, null, USE_OFF, 0.0f, 1.0f );
		if (kingpins == true) {
			g_EntityFuncs.FireTargets( 'rift_squadmakers_k_' + idKeyValue, null, null, USE_OFF, 0.0f, 1.0f );		
		}			
	}
	
	g_EntityFuncs.FireTargets( 'rift_push_' + idKeyValue, null, null, USE_TOGGLE, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'rift_heal_' + idKeyValue, null, null, USE_ON, 0.0f, 0.5f );
	g_EntityFuncs.FireTargets( 'rift_hurt_' + idKeyValue, null, null, USE_ON, 0.0f, 4.0f );
	g_EntityFuncs.FireTargets( 'rift_sprite_s_' + idKeyValue, null, null, USE_OFF, 0.0f, 4.0f );
	g_EntityFuncs.FireTargets( 'rift_sprite_amtreset_s_' + idKeyValue, null, null, USE_TOGGLE, 0.0f, 4.0f );
	g_EntityFuncs.FireTargets( 'rift_squadmakers_s_' + idKeyValue, null, null, USE_OFF, 0.0f, 1.0f );
	//g_EntityFuncs.FireTargets( 'rift_back_tele_' + idKeyValue, null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'rift_globalriftclosesound', null, null, USE_ON, 0.0f, 4.0f );
	g_EntityFuncs.FireTargets( 'rift_teleport_' + idKeyValue, null, null, USE_OFF, 0.0f, 0.0f );
	//g_EntityFuncs.FireTargets( 'rift_back_tele_' + idKeyValue, null, null, USE_OFF, 0.0f, 3.0f );
	//houndeye shockwave effect https://github.com/baso88/SC_AngelScript/wiki/TE_BEAMCYLINDER
	g_EntityFuncs.FireTargets( 'rift_heal_' + idKeyValue, null, null, USE_OFF, 0.0f, 4.0f );
	g_EntityFuncs.FireTargets( 'rift_hurt_' + idKeyValue, null, null, USE_OFF, 0.0f, 4.5f );
	g_EntityFuncs.FireTargets( 'rift_push_' + idKeyValue, null, null, USE_TOGGLE, 0.0f, 4.5f );
	
	//g_EntityFuncs.FireTargets( 'riftclosed_txt', null, null, USE_ON, 0.0f, 4.0f );	
	
	g_Scheduler.SetTimeout( "closeRift", 4,  idInt);
	g_Scheduler.SetTimeout( "closeRiftVoice", 8);

}	

void closeRift(int idInt) {
	activeRifts[idInt -1] = 0; //no longer count rift as active
	activeRiftsCounter -= 1;
}

void closeRiftVoice() {
	if (voiceQueue.length() == 0) {
		dictionary voiceLine;
		int randomPick = Math.RandomLong(1,2); 
		switch( randomPick )
		{
		case 1:
			voiceLine = cast<dictionary>( voiceList['61_riftclosed'] );
			break;
		case 2:	
			voiceLine = cast<dictionary>( voiceList['62_riftclosed'] );
			break;			
		}		
		addDictionaryToQueue(voiceLine);		
	}		
}



void debugSevenRifts(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	RiftLoseCondition();
	g_Game.AlertMessage(at_console, "debugSevenRifts triggered");
}

void RiftLoseCondition() {

	if (mapEndReached == true) {
		return;
	}
	
	mapEndReachedFunction();

	//ensure nothing else happens when this is triggered
	dictionary voiceLine = cast<dictionary>( voiceList['29_sevenrifts'] );
	g_Scheduler.SetTimeout( "addDictionaryToQueue", 2, voiceLine);	

	g_EntityFuncs.FireTargets( 'evenlonger_fadein', null, null, USE_ON, 0.0f, 0.0f );
	g_EntityFuncs.FireTargets( 'longer_fadeout', null, null, USE_ON, 0.0f, 6.0f );
	g_EntityFuncs.FireTargets( 'claw_growl', null, null, USE_ON, 0.0f, 5.0f );	
	
	g_EntityFuncs.FireTargets( 'clawcamera', null, null, USE_ON, 0.0f, 6.0f );
	g_EntityFuncs.FireTargets( 'clawsprite', null, null, USE_ON, 0.0f, 5.5f );
	g_EntityFuncs.FireTargets( 'clawsprite2', null, null, USE_ON, 0.0f, 6.0f );
	g_EntityFuncs.FireTargets( 'claw_train', null, null, USE_ON, 0.0f, 6.0f );
	
	g_EntityFuncs.FireTargets( 'claw_setorigin', null, null, USE_ON, 0.0f, 6.0f );
	
	g_EntityFuncs.FireTargets( 'poolspawn', null, null, USE_OFF, 0.0f, 6.0f );
	g_EntityFuncs.FireTargets( 'end_spawn', null, null, USE_ON, 0.0f, 6.0f );
	g_EntityFuncs.FireTargets( 'respawnem', null, null, USE_ON, 0.0f, 6.1f );	
	
	
	
	
	g_EntityFuncs.FireTargets( 'evenlonger_fadein', null, null, USE_ON, 0.0f, 16.5f );
	g_EntityFuncs.FireTargets( 'clawcamera', null, null, USE_OFF, 0.0f, 22.0f );
	
	float clawPortalTimer = 6.0f;

	for( int n = 0; n < 45; n++ ) 
	{
		g_EntityFuncs.FireTargets( 'clawportalbigger', null, null, USE_ON, 0.0f, clawPortalTimer );
		clawPortalTimer += 0.28f;
		//g_Game.AlertMessage(at_console, "clawportalbigger triggered");
	}			
	
	g_EntityFuncs.FireTargets( 'riftlose_txt', null, null, USE_ON, 0.0f, 18.5f );
	g_EntityFuncs.FireTargets( 'gameendentity', null, null, USE_ON, 0.0f, 26.5f );
	
	
}
	