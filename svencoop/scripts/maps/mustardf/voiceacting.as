
// generally put sounds in a queue... but maybe some sounds are so important they must interrupt all other sounds and stop them.

// when interrupting sounds. have a one second break. imagine if he let go of the play button of his speaker.


// certain reminders should prevent other reminders from being played. like, only play one reminder within 5 minutes.

// play all gameplay events EVERY TIME?

		// g_Game.PrecacheGeneric( "../media/valve.mp3" );
		// g_Game.PrecacheGeneric( "debris/beamstart7.wav" );

// g_SoundSystem.EmitSound( self.edict(), CHAN_STATIC, "../media/valve.mp3", 1.0f, ATTN_NONE );
// g_SoundSystem.PlaySound( self.edict(), CHAN_STATIC, "../media/valve.mp3", 1.0f, ATTN_NONE ); 

// g_SoundSystem.StopSound( self.edict(), CHAN_STATIC, "../media/valve.mp3" ); 


dictionary voiceList = { 
	{'0_intro1', dictionary = {{'voiceFile', 'mustardf/maxwell/0_intro1.ogg'}, {'lengthSeconds', 6.8}, {'priority', 99}, {'triggerTarget', 'none'}}},
	{'1_intro2', dictionary = {{'voiceFile', 'mustardf/maxwell/1_intro2.ogg'}, {'lengthSeconds', 10.8}, {'priority', 99}, {'triggerTarget', 'none'}}},
	{'2_briefing', dictionary = {{'voiceFile', 'mustardf/maxwell/2_briefing.ogg'}, {'lengthSeconds', 85}, {'priority', 99}, {'triggerTarget', 'none'}}},
	{'3_lobby', dictionary = {{'voiceFile', 'mustardf/maxwell/3_lobby.ogg'}, {'lengthSeconds', 10.1}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'4_switchflipped', dictionary = {{'voiceFile', 'mustardf/maxwell/4_switchflipped.ogg'}, {'lengthSeconds', 22.2}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'5_grindinginstructions', dictionary = {{'voiceFile', 'mustardf/maxwell/5_grindinginstructions.ogg'}, {'lengthSeconds', 31.8}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'6_sabotageintro', dictionary = {{'voiceFile', 'mustardf/maxwell/6_sabotageintro.ogg'}, {'lengthSeconds', 62.2}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'7_storagereached', dictionary = {{'voiceFile', 'mustardf/maxwell/7_storagereached.ogg'}, {'lengthSeconds', 23.2}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'8_goonsarrive', dictionary = {{'voiceFile', 'mustardf/maxwell/8_goonsarrive.ogg'}, {'lengthSeconds', 4.3}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'9_gotogrind', dictionary = {{'voiceFile', 'mustardf/maxwell/9_gotogrind.ogg'}, {'lengthSeconds', 3.1}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'10_gotomixing', dictionary = {{'voiceFile', 'mustardf/maxwell/10_gotomixing.ogg'}, {'lengthSeconds', 3}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'11_gotopacking', dictionary = {{'voiceFile', 'mustardf/maxwell/11_gotopacking.ogg'}, {'lengthSeconds', 3.1}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'12_gotogenerator', dictionary = {{'voiceFile', 'mustardf/maxwell/12_gotogenerator.ogg'}, {'lengthSeconds', 2.9}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'13_mixingreached', dictionary = {{'voiceFile', 'mustardf/maxwell/13_mixingreached.ogg'}, {'lengthSeconds', 24.6}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'14_greasefound2', dictionary = {{'voiceFile', 'mustardf/maxwell/14_greasefound2.ogg'}, {'lengthSeconds', 42.9}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'14_greasefound4', dictionary = {{'voiceFile', 'mustardf/maxwell/14_greasefound4.ogg'}, {'lengthSeconds', 43.0}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'15_packingstarted', dictionary = {{'voiceFile', 'mustardf/maxwell/15_packingstarted.ogg'}, {'lengthSeconds', 8.6}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'16_automatons', dictionary = {{'voiceFile', 'mustardf/maxwell/16_automatons.ogg'}, {'lengthSeconds', 15.1}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'17_firstrift', dictionary = {{'voiceFile', 'mustardf/maxwell/17_firstrift.ogg'}, {'lengthSeconds', 60}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'18_weelads', dictionary = {{'voiceFile', 'mustardf/maxwell/18_weelads.ogg'}, {'lengthSeconds', 53}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'19_valveturned1', dictionary = {{'voiceFile', 'mustardf/maxwell/19_valveturned1.ogg'}, {'lengthSeconds', 4.2}, {'priority', 3}, {'triggerTarget', 'none'}}},
	{'20_valveturned2', dictionary = {{'voiceFile', 'mustardf/maxwell/20_valveturned2.ogg'}, {'lengthSeconds', 4.9}, {'priority', 3}, {'triggerTarget', 'none'}}},
	{'21_valveturned3', dictionary = {{'voiceFile', 'mustardf/maxwell/21_valveturned3.ogg'}, {'lengthSeconds', 2.8}, {'priority', 3}, {'triggerTarget', 'none'}}},
	{'22_valveturned4', dictionary = {{'voiceFile', 'mustardf/maxwell/22_valveturned4.ogg'}, {'lengthSeconds', 22}, {'priority', 3}, {'triggerTarget', 'none'}}},
	{'23_halfdrained', dictionary = {{'voiceFile', 'mustardf/maxwell/23_halfdrained.ogg'}, {'lengthSeconds', 11.1}, {'priority', 2}, {'triggerTarget', 'none'}}},
	{'24_90drained', dictionary = {{'voiceFile', 'mustardf/maxwell/24_90drained.ogg'}, {'lengthSeconds', 14.7}, {'priority', 4}, {'triggerTarget', 'none'}}},
	{'25_fullydrained', dictionary = {{'voiceFile', 'mustardf/maxwell/25_fullydrained.ogg'}, {'lengthSeconds', 26.2}, {'priority', 999}, {'triggerTarget', 'none'}}},
	{'26_bossarrives1', dictionary = {{'voiceFile', 'mustardf/maxwell/26_bossarrives1.ogg'}, {'lengthSeconds', 20.2}, {'priority', 100}, {'triggerTarget', 'none'}}},
	{'27_bossarrives2', dictionary = {{'voiceFile', 'mustardf/maxwell/27_bossarrives2.ogg'}, {'lengthSeconds', 20.7}, {'priority', 99}, {'triggerTarget', 'none'}}},
	{'28_pillarbreak', dictionary = {{'voiceFile', 'mustardf/maxwell/28_pillarbreak.ogg'}, {'lengthSeconds', 1.1}, {'priority', 999}, {'triggerTarget', 'none'}}},
	{'29_sevenrifts', dictionary = {{'voiceFile', 'mustardf/maxwell/29_sevenrifts.ogg'}, {'lengthSeconds', 2.3}, {'priority', 999}, {'triggerTarget', 'none'}}},
	{'30_dailygoalreached', dictionary = {{'voiceFile', 'mustardf/maxwell/30_dailygoalreached.ogg'}, {'lengthSeconds', 6.1}, {'priority', 999}, {'triggerTarget', 'none'}}},
	{'31_dailygoalreached2', dictionary = {{'voiceFile', 'mustardf/maxwell/31_dailygoalreached2.ogg'}, {'lengthSeconds', 12.7}, {'priority', 999}, {'triggerTarget', 'none'}}},
	{'32_grindsabotage', dictionary = {{'voiceFile', 'mustardf/maxwell/32_grindsabotage.ogg'}, {'lengthSeconds', 5.3}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'33_mixsabotage', dictionary = {{'voiceFile', 'mustardf/maxwell/33_mixsabotage.ogg'}, {'lengthSeconds', 3.8}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'34_packsabotage', dictionary = {{'voiceFile', 'mustardf/maxwell/34_packsabotage.ogg'}, {'lengthSeconds', 8}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'35_generatorsabotage', dictionary = {{'voiceFile', 'mustardf/maxwell/35_generatorsabotage.ogg'}, {'lengthSeconds', 8.1}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'36_repairreminder_angry', dictionary = {{'voiceFile', 'mustardf/maxwell/36_repairreminder_angry.ogg'}, {'lengthSeconds', 8.9}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'37_repairreminder_lessangry', dictionary = {{'voiceFile', 'mustardf/maxwell/37_repairreminder_lessangry.ogg'}, {'lengthSeconds', 4.9}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'38_repairreminder_urgent', dictionary = {{'voiceFile', 'mustardf/maxwell/38_repairreminder_urgent.ogg'}, {'lengthSeconds', 10.7}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'39_repairedgrinding', dictionary = {{'voiceFile', 'mustardf/maxwell/39_repairedgrinding.ogg'}, {'lengthSeconds', 4.2}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'40_repairedmixing', dictionary = {{'voiceFile', 'mustardf/maxwell/40_repairedmixing.ogg'}, {'lengthSeconds', 4.1}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'41_repairedpacking', dictionary = {{'voiceFile', 'mustardf/maxwell/41_repairedpacking.ogg'}, {'lengthSeconds', 4.4}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'42_generatorrepaired', dictionary = {{'voiceFile', 'mustardf/maxwell/42_generatorrepaired.ogg'}, {'lengthSeconds', 3.5}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'43_reminderhandbook', dictionary = {{'voiceFile', 'mustardf/maxwell/43_reminderhandbook.ogg'}, {'lengthSeconds', 11.9}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'44_reminderhandbook2', dictionary = {{'voiceFile', 'mustardf/maxwell/44_reminderhandbook2.ogg'}, {'lengthSeconds', 15.1}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'45_mustardproduced', dictionary = {{'voiceFile', 'mustardf/maxwell/45_mustardproduced.ogg'}, {'lengthSeconds', 2.9}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'46_keepthemcoming', dictionary = {{'voiceFile', 'mustardf/maxwell/46_keepthemcoming.ogg'}, {'lengthSeconds', 1.8}, {'priority', 1}, {'triggerTarget', 'none'}}},		
	{'47_quitedecent', dictionary = {{'voiceFile', 'mustardf/maxwell/47_quitedecent.ogg'}, {'lengthSeconds', 1.7}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'48_goodwork', dictionary = {{'voiceFile', 'mustardf/maxwell/48_goodwork.ogg'}, {'lengthSeconds', 1.1}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'49_largebatch', dictionary = {{'voiceFile', 'mustardf/maxwell/49_largebatch.ogg'}, {'lengthSeconds', 4.4}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'50_soclose', dictionary = {{'voiceFile', 'mustardf/maxwell/50_soclose.ogg'}, {'lengthSeconds', 5}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'51_faster', dictionary = {{'voiceFile', 'mustardf/maxwell/51_faster.ogg'}, {'lengthSeconds', 7}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'52_faster', dictionary = {{'voiceFile', 'mustardf/maxwell/52_faster.ogg'}, {'lengthSeconds', 4.7}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'53_faster', dictionary = {{'voiceFile', 'mustardf/maxwell/53_faster.ogg'}, {'lengthSeconds', 8.2}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	// {'54_faster', dictionary = {{'voiceFile', 'mustardf/maxwell/54_faster.ogg'}, {'lengthSeconds', 999}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'55_faster', dictionary = {{'voiceFile', 'mustardf/maxwell/55_faster.ogg'}, {'lengthSeconds', 6.2}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'56_faster', dictionary = {{'voiceFile', 'mustardf/maxwell/56_faster.ogg'}, {'lengthSeconds', 5.6}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'57_fastermustardmustardmustard', dictionary = {{'voiceFile', 'mustardf/maxwell/57_fastermustardmustardmustard.ogg'}, {'lengthSeconds', 16.9}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'58_riftopened', dictionary = {{'voiceFile', 'mustardf/maxwell/58_riftopened.ogg'}, {'lengthSeconds', 4.2}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'59_5rifts', dictionary = {{'voiceFile', 'mustardf/maxwell/59_5rifts.ogg'}, {'lengthSeconds', 6.4}, {'priority', 2}, {'triggerTarget', 'none'}}},	
	{'60_6rifts', dictionary = {{'voiceFile', 'mustardf/maxwell/60_6rifts.ogg'}, {'lengthSeconds', 7.7}, {'priority', 3}, {'triggerTarget', 'none'}}},	
	{'61_riftclosed', dictionary = {{'voiceFile', 'mustardf/maxwell/61_riftclosed.ogg'}, {'lengthSeconds', 3.2}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'62_riftclosed', dictionary = {{'voiceFile', 'mustardf/maxwell/62_riftclosed.ogg'}, {'lengthSeconds', 3.3}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'63_reminderrifts', dictionary = {{'voiceFile', 'mustardf/maxwell/63_reminderrifts.ogg'}, {'lengthSeconds', 7.6}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'64_reminder5rifts', dictionary = {{'voiceFile', 'mustardf/maxwell/64_reminder5rifts.ogg'}, {'lengthSeconds', 12.8}, {'priority', 3}, {'triggerTarget', 'none'}}},	
	{'65_bossurge', dictionary = {{'voiceFile', 'mustardf/maxwell/65_bossurge.ogg'}, {'lengthSeconds', 8}, {'priority', 2}, {'triggerTarget', 'none'}}},	
	{'66_bossurge2', dictionary = {{'voiceFile', 'mustardf/maxwell/66_bossurge2.ogg'}, {'lengthSeconds', 8.6}, {'priority', 2}, {'triggerTarget', 'none'}}},	
	{'67_manyproblems', dictionary = {{'voiceFile', 'mustardf/maxwell/67_manyproblems.ogg'}, {'lengthSeconds', 28.7}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'68_manyproblems', dictionary = {{'voiceFile', 'mustardf/maxwell/68_manyproblems.ogg'}, {'lengthSeconds', 13.4}, {'priority', 1}, {'triggerTarget', 'none'}}},	
	{'69_manyproblems', dictionary = {{'voiceFile', 'mustardf/maxwell/69_manyproblems.ogg'}, {'lengthSeconds', 14.1}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'70_singlebatch', dictionary = {{'voiceFile', 'mustardf/maxwell/70_singlebatch.ogg'}, {'lengthSeconds', 8}, {'priority', 1}, {'triggerTarget', 'none'}}},
	{'badabing', dictionary = {{'voiceFile', 'mustardf/badabing.wav'}, {'lengthSeconds', 1.2}, {'priority', 999}, {'triggerTarget', 'none'}}}
};

bool grindingInstructionsGiven = false;
bool mixingInstructionsGiven = false;
bool firstPackingStarted = false;
bool firstDrainWarning = false;
bool secondDrainWarning = false;
bool firstPackWarning = false;
bool secondPackWarning = false;

bool priorityXOccurred = false;

void mixingInstructionsGivenBoolean() {
	mixingInstructionsGiven = true;
}

// function called from trigger_script, ie location based triggers
void playVoice(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {

	string targetname = pCaller.pev.targetname;
	//targetname.SubString(0, 5);



	if (switchFlipped == false && targetname == 'voice_3_lobby') {
		dictionary voiceLine = cast<dictionary>( voiceList['3_lobby'] );
		g_Scheduler.SetTimeout( "addDictionaryToQueue", 2, voiceLine );
		// addDictionaryToQueue(voiceLine);
	}
	
	if (switchFlipped == true && targetname == 'voice_5_grindinginstructions') {
		dictionary voiceLine = cast<dictionary>( voiceList['5_grindinginstructions'] );
		g_Scheduler.SetTimeout( "addDictionaryToQueue", 3, voiceLine );
		// addDictionaryToQueue(voiceLine);
		g_EntityFuncs.FireTargets( 'voice_5_m_r', null, null, USE_TOGGLE, 0.0f, 0.0f ); //disable trigger for grinding instructions
		grindingInstructionsGiven = true;
	}	
	
	if (firstSabotageOccurred == true && targetname == 'voice_7_storagereached') {
		dictionary voiceLine = cast<dictionary>( voiceList['7_storagereached'] );
		g_Scheduler.SetTimeout( "addDictionaryToQueue", 1, voiceLine );
		// addDictionaryToQueue(voiceLine);
		CBaseEntity@ voice_7_storagereached = g_EntityFuncs.FindEntityByTargetname(null, 'voice_7_storagereached'); //null means find the first entity with the targetname
		g_EntityFuncs.Remove( voice_7_storagereached );
	}	

	if (grindingInstructionsGiven == true && sabotageSpeechGiven == true && targetname == 'voice_13_mixingreached') {
		dictionary voiceLine = cast<dictionary>( voiceList['13_mixingreached'] );
		g_Scheduler.SetTimeout( "addDictionaryToQueue", 3, voiceLine );
		// addDictionaryToQueue(voiceLine);
		g_EntityFuncs.FireTargets( 'voice_13_m_r', null, null, USE_TOGGLE, 0.0f, 0.0f ); //disable trigger for mixing instructions
		//mixingInstructionsGiven = true;
		g_Scheduler.SetTimeout( "mixingInstructionsGivenBoolean", 25 + 90); //to ensure packing instructions do not play until mixing intro is spoken. 25 is sound file length.
	}	

	if (mixingInstructionsGiven == true && targetname == 'voice_14_greasefound') {	
		if (mustardGoal == 8) {
			dictionary voiceLine = cast<dictionary>( voiceList['14_greasefound2'] );
			// addDictionaryToQueue(voiceLine);		
			g_Scheduler.SetTimeout( "addDictionaryToQueue", 3, voiceLine );
		}
		else if (mustardGoal == 16) {
			dictionary voiceLine = cast<dictionary>( voiceList['14_greasefound4'] );	
			g_Scheduler.SetTimeout( "addDictionaryToQueue", 3, voiceLine );
		}
		
		
		CBaseEntity@ voice_14_greasefound = g_EntityFuncs.FindEntityByTargetname(null, 'voice_14_greasefound'); //null means find the first entity with the targetname
		g_EntityFuncs.Remove( voice_14_greasefound );
	}					
			
			
				

}

array<dictionary> voiceQueue;

bool queueInterrupted = false;

void addDictionaryToQueue(dictionary voiceLine) {
	// dictionary voiceLineDict = cast<dictionary>( voiceList['0_intro1'] );
	// string voiceFile = cast<string>( voiceLineDict['voiceFile'] );
	// float lengthSeconds = cast<float>( voiceLineDict['lengthSeconds'] );
	// int priority = cast<int>( voiceLineDict['priority'] );
	// string triggerTarget = cast<string>( voiceLineDict['triggerTarget'] );
	
	string voiceFile;
	float lengthSeconds;
	int priority;
	string triggerTarget;

	voiceLine.get('voiceFile', voiceFile );
	voiceLine.get('lengthSeconds', lengthSeconds );
	voiceLine.get('priority', priority );
	voiceLine.get('triggerTarget', triggerTarget );
	
	addVoiceToQueue(voiceFile, lengthSeconds, priority, triggerTarget);
}

void addVoiceToQueue(string voiceFile, float lengthSeconds, int priority, string triggerTarget)
{	
	
	if (priorityXOccurred == true && priority < 999 ) { //once a line with priority 999 has been added, adding lines with lower priority is disabled.
		return;
	}
	if (priorityXOccurred == false && priority == 999) {
		priorityXOccurred = true;
	}

	dictionary voiceLine = {{'voiceFile', voiceFile}, {'lengthSeconds', lengthSeconds}, {'priority', priority}, {'triggerTarget', triggerTarget}};

	

	if (voiceQueue.length() == 0) {	//check if somethin
		voiceQueue.insertAt(0, voiceLine);
		// CBaseEntity@ pWorld = g_EntityFuncs.Instance( 0 );
		CBaseEntity@ speechOrigin = g_EntityFuncs.FindEntityByTargetname(null, 'maxwell_speech_origin');
		g_SoundSystem.PlaySound( speechOrigin.edict(), CHAN_STATIC, voiceFile, 1.0f, ATTN_NONE );
		g_Scheduler.SetTimeout( "voiceLineHasEnded", lengthSeconds );
		// if (triggerTarget == 'beginBossBattle') {
			// beginBossBattle();
		// }			
	}
	else if (priority == 999) {
		string currentVoiceFile;
		voiceQueue[0].get('voiceFile', currentVoiceFile );
		// CBaseEntity@ pWorld = g_EntityFuncs.Instance( 0 );			
		CBaseEntity@ speechOrigin = g_EntityFuncs.FindEntityByTargetname(null, 'maxwell_speech_origin');		
		g_SoundSystem.StopSound( speechOrigin.edict(), CHAN_STATIC, currentVoiceFile );
		voiceQueue.resize(0);
		voiceQueue.insertAt(0, voiceLine);
		g_SoundSystem.PlaySound( speechOrigin.edict(), CHAN_STATIC, voiceFile, 1.0f, ATTN_NONE );
		queueInterrupted = true;
		g_Scheduler.SetTimeout( "voiceLineHasEnded", lengthSeconds );
	}	
	else if (voiceQueue.length() > 0) {
		
		for( uint n = 1; n < voiceQueue.length(); n++ ){ //voice at index 0 is safe
			int currentArrayPriority;
			voiceQueue[n].get('priority', currentArrayPriority );

			if (priority >  currentArrayPriority) {
				voiceQueue.insertAt(n, voiceLine);
				return;
			}
		}
		voiceQueue.insertLast(voiceLine); //if the priority is lower than everything in the array, add the line to the end of the array
    }
}

void playVoiceLine(string voiceFile) { //useful when adding 1 second delay
		// CBaseEntity@ pWorld = g_EntityFuncs.Instance( 0 );
		CBaseEntity@ speechOrigin = g_EntityFuncs.FindEntityByTargetname(null, 'maxwell_speech_origin');	
		g_SoundSystem.PlaySound( speechOrigin.edict(), CHAN_STATIC, voiceFile, 1.0f, ATTN_NONE );
}

void voiceLineHasEnded() {

	if (queueInterrupted == true) { //if interrupted, that means a voiceline was playing and was interrupted. this function is going to be called, so i disable the function
		queueInterrupted = false;
		return;
	}


	string triggerTarget;


		
	if (voiceQueue.length() > 1) { 


		// special case where sabotage instructions play after grinding instructions //
		float potentialBufferLength = 0;		
		string currentLine;
		voiceQueue[0].get('voiceFile', currentLine );
		string nextLine;
		voiceQueue[1].get('voiceFile', nextLine );
		if (currentLine == 'mustardf/maxwell/5_grindinginstructions.ogg' && nextLine == 'mustardf/maxwell/6_sabotageintro.ogg') { 
			potentialBufferLength = 20; //if i increase this in the future, increase trackTwoCounter and trackOneCounter correspondingly. also consider increasing g_Scheduler.SetTimeout( "addDictionaryToQueue", 20, voiceLine ); 
		}	
		// end special case where sabotage instructions play after grinding instructions //
	
	
		voiceQueue[1].get('triggerTarget', triggerTarget );	//we check the triggerTarget of the following voiceline in the queue, because for now we only trigger things at the beginning, not the end of a line)
		//if (triggerTarget != 'none') {
			// call function
			// i dont think its possible to pass function name as a parameter. hgardcode a list of functions to call?
			
		//}	
	
	
		for( uint n = 0; n < voiceQueue.length() -1; n++ ){ //dont look at last index
			voiceQueue[n] = voiceQueue[n+1];
		}		
		string voiceFile;
		voiceQueue[0].get('voiceFile', voiceFile );
		float lengthSeconds;
		voiceQueue[0].get('lengthSeconds', lengthSeconds );
		g_Scheduler.SetTimeout( "playVoiceLine", 1 + potentialBufferLength, voiceFile );	
		g_Scheduler.SetTimeout( "voiceLineHasEnded", lengthSeconds + 1 + potentialBufferLength );	
		// if (triggerTarget == 'beginBossBattle' && activeBoss == false) {
			// beginBossBattle();
		// }					
	}
	voiceQueue.removeLast();
	
}


int checkReminderInterval = Math.RandomLong(360,480);

array<string> hurryArray =
{
	"51_faster",
	"52_faster",
	"53_faster",
	"55_faster",
	"56_faster",	
	"57_fastermustardmustardmustard"
};

array<string> shamblesArray =
{
	"68_manyproblems",
	"67_manyproblems",
	"69_manyproblems"
};

void checkReminder() {

	array<dictionary> possibleReminders(0);

	bool behindWorkQuota = false;
	bool machinesInShambles = false;
	
	dictionary voiceLine;
	
	if ((mustardGoal == 8 && brokenMachinesCount > 7 )or (mustardGoal == 16 && brokenMachinesCount > 11)) {

		voiceLine = cast<dictionary>( voiceList['38_repairreminder_urgent'] );
		possibleReminders.insertLast( voiceLine );		
		machinesInShambles = true;
	}
	else if (brokenMachinesCount > 3) {
		
		int randomPick = Math.RandomLong(1,2); 
		switch( randomPick )
		{
		case 1:
			voiceLine = cast<dictionary>( voiceList['36_repairreminder_angry'] );
			break;
		case 2:	
			voiceLine = cast<dictionary>( voiceList['37_repairreminder_lessangry'] );
			break;			
		}		
		possibleReminders.insertLast(voiceLine );					
	}
	
	
	if (mustardGoal == 8) {
		if ( mustardProduced + mixesBeingProcessed < 3 && workTimeAccumulated > 900) {
			behindWorkQuota = true;
		}
		else if ( mustardProduced + mixesBeingProcessed < 6 && workTimeAccumulated > 1500) {		
			behindWorkQuota = true;
		}
		else if ( mustardProduced + mixesBeingProcessed < 8 && workTimeAccumulated > 2100) {
			behindWorkQuota = true;
		}		
	}	
	else if (mustardGoal == 16) {
		if ( mustardProduced + mixesBeingProcessed < 6 && workTimeAccumulated > 900) {
			behindWorkQuota = true;
		}
		else if ( mustardProduced + mixesBeingProcessed < 11 && workTimeAccumulated > 1500) {
			behindWorkQuota = true;
		}
		else if ( mustardProduced + mixesBeingProcessed < 16 && workTimeAccumulated > 2100) {
			behindWorkQuota = true;		
		}	
	}
	if (behindWorkQuota == true) {
		if (hurryArray.length() == 0)
			hurryArray = {	"51_faster",	"52_faster",	"53_faster",	"55_faster",	"56_faster",		"57_fastermustardmustardmustard"};
			
		int randomPick = Math.RandomLong(0,hurryArray.length()-1); 
		string voiceFileHurry = hurryArray[randomPick];
		voiceLine = cast<dictionary>( voiceList[voiceFileHurry] );
		hurryArray.removeAt(randomPick);
		
		// switch( randomPick )
		// {
		// case 1:
			// dictionary voiceLine = cast<dictionary>( voiceList['51_faster'] );
			// break;
		// case 2:	
			// dictionary voiceLine = cast<dictionary>( voiceList['52_faster'] );
			// break;	
		// case 3:
			// dictionary voiceLine = cast<dictionary>( voiceList['53_faster'] );
			// break;
		// case 4:	
			// dictionary voiceLine = cast<dictionary>( voiceList['55_faster'] );
			// break;	
		// case 5:
			// dictionary voiceLine = cast<dictionary>( voiceList['56_faster'] );
			// break;
		// case 6:	
			// dictionary voiceLine = cast<dictionary>( voiceList['57_fastermustardmustardmustard'] );
			// break;				
		// }		
		possibleReminders.insertLast(voiceLine );	
	}
	
	if (activeRiftsCounter > 1 && activeRiftsCounter < 5) {
		voiceLine = cast<dictionary>( voiceList['63_reminderrifts'] );
		possibleReminders.insertLast( voiceLine );		
	}
	else if (activeRiftsCounter > 4 ) {
		voiceLine = cast<dictionary>( voiceList['64_reminder5rifts'] );
		possibleReminders.insertLast( voiceLine );		
		addDictionaryToQueue(voiceLine);
		loopCheckReminder();
		return;
	}	

	if  (activeRiftsCounter > 3 && behindWorkQuota && machinesInShambles && shamblesArray.length() > 0 ) { //does it make sense he gets less intense when he has complained 3 times?
	//isn't it a shame they are only played when there are exactly 4 rifts? on the other hand, they will always be played.
		voiceLine = cast<dictionary>( voiceList[shamblesArray[0]] );
		shamblesArray.removeAt(0);
		
		//possibleReminders.insertLast(voiceLine );
		
		addDictionaryToQueue(voiceLine);
		loopCheckReminder();
		return;		
	}
	
	if (possibleReminders.length() > 0) {
		uint randomReminder = Math.RandomLong(0 , possibleReminders.length() - 1 ); 
		string voiceFile;
		float lengthSeconds;
		int priority;
		string triggerTarget;
		possibleReminders[randomReminder].get('voiceFile', voiceFile );
		possibleReminders[randomReminder].get('lengthSeconds', lengthSeconds );
		possibleReminders[randomReminder].get('priority', priority );
		possibleReminders[randomReminder].get('triggerTarget', triggerTarget );
		
		addVoiceToQueue(voiceFile, lengthSeconds, priority, triggerTarget);
	}
	
	loopCheckReminder();
}

void loopCheckReminder() {
	checkReminderInterval = Math.RandomLong(360,480);
	g_Scheduler.SetTimeout( "checkReminder", checkReminderInterval );
}

void precacheSounds() {
	//g_Game.PrecacheGeneric( "sound/mustardf/maxwell/0_intro1.ogg" );

	g_SoundSystem.PrecacheSound( "mustardf/maxwell/0_intro1.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/1_intro2.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/2_briefing.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/3_lobby.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/4_switchflipped.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/5_grindinginstructions.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/6_sabotageintro.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/7_storagereached.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/8_goonsarrive.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/9_gotogrind.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/10_gotomixing.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/11_gotopacking.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/12_gotogenerator.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/13_mixingreached.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/14_greasefound2.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/14_greasefound4.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/15_packingstarted.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/16_automatons.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/17_firstrift.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/18_weelads.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/19_valveturned1.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/20_valveturned2.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/21_valveturned3.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/22_valveturned4.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/23_halfdrained.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/24_90drained.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/25_fullydrained.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/26_bossarrives1.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/27_bossarrives2.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/28_pillarbreak.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/29_sevenrifts.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/30_dailygoalreached.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/31_dailygoalreached2.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/32_grindsabotage.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/33_mixsabotage.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/34_packsabotage.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/35_generatorsabotage.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/36_repairreminder_angry.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/37_repairreminder_lessangry.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/38_repairreminder_urgent.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/39_repairedgrinding.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/40_repairedmixing.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/41_repairedpacking.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/42_generatorrepaired.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/43_reminderhandbook.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/44_reminderhandbook2.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/45_mustardproduced.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/46_keepthemcoming.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/47_quitedecent.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/48_goodwork.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/49_largebatch.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/50_soclose.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/51_faster.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/52_faster.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/53_faster.ogg" );
	//g_SoundSystem.PrecacheSound( "mustardf/maxwell/54_faster.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/55_faster.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/56_faster.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/57_fastermustardmustardmustard.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/58_riftopened.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/59_5rifts.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/60_6rifts.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/61_riftclosed.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/62_riftclosed.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/63_reminderrifts.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/64_reminder5rifts.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/65_bossurge.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/66_bossurge2.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/67_manyproblems.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/68_manyproblems.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/69_manyproblems.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/maxwell/70_singlebatch.ogg" );
	g_SoundSystem.PrecacheSound( "mustardf/badabing.wav" );
}