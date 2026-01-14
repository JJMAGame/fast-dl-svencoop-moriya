void HLRand_Startup(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	// Just triggering here. Start-up sequence
	g_EntityFuncs.FireTargets("lock_hldoor", null, null, USE_TOGGLE, 0.0f, 0.1f);
	g_EntityFuncs.FireTargets("tele_hl_lockthekey", null, null, USE_TOGGLE, 0.0f, 0.1f);
	g_EntityFuncs.FireTargets("normalspawn", null, null, USE_TOGGLE, 0.0f, 0.1f);
	g_EntityFuncs.FireTargets("hlspawn", null, null, USE_TOGGLE, 0.0f, 0.1f);
	g_EntityFuncs.FireTargets("tele_vox_start", null, null, USE_TOGGLE, 0.0f, 0.0f);
	g_EntityFuncs.FireTargets("respawnme", null, null, USE_TOGGLE, 0.0f, 0.3f);
	g_EntityFuncs.FireTargets("bolts_hlranddoor", null, null, USE_TOGGLE, 0.0f, 0.03f);

	g_EntityFuncs.FireTargets("hl_tele_light_white", null, null, USE_TOGGLE, 0.0f, 8.0f);
	g_EntityFuncs.FireTargets("light_outside", null, null, USE_TOGGLE, 0.0f, 8.0f);

	g_EntityFuncs.FireTargets("hl_tele_light_red", null, null, USE_TOGGLE, 0.0f, 9.0f);
	g_EntityFuncs.FireTargets("tele_alarm", null, null, USE_TOGGLE, 0.0f, 9.0f);

	g_EntityFuncs.FireTargets("tele_hl_sign", null, null, USE_TOGGLE, 0.0f, 10.0f);
	g_EntityFuncs.FireTargets("tele_hl_sign_rand", null, null, USE_TOGGLE, 0.0f, 10.0f);

	g_EntityFuncs.FireTargets("ringbeam1", null, null, USE_TOGGLE, 0.0f, 14.0f);
	g_EntityFuncs.FireTargets("ringbeam2", null, null, USE_TOGGLE, 0.0f, 14.0f);
	g_EntityFuncs.FireTargets("tele_zap_ring", null, null, USE_TOGGLE, 0.0f, 14.0f);
	g_EntityFuncs.FireTargets("hl_tele_hurt", null, null, USE_TOGGLE, 0.0f, 14.0f);

	g_EntityFuncs.FireTargets("leftbeam", null, null, USE_TOGGLE, 0.0f, 16.0f);
	g_EntityFuncs.FireTargets("rightbeam", null, null, USE_TOGGLE, 0.0f, 16.0f);
	g_EntityFuncs.FireTargets("tele_zap_leftright", null, null, USE_TOGGLE, 0.0f, 16.0f);

	g_EntityFuncs.FireTargets("midbeam", null, null, USE_TOGGLE, 0.0f, 17.0f);
	g_EntityFuncs.FireTargets("rearbeam", null, null, USE_TOGGLE, 0.0f, 17.0f);
	g_EntityFuncs.FireTargets("tele_zap_rear", null, null, USE_TOGGLE, 0.0f, 17.0f);

	g_EntityFuncs.FireTargets("beam_r12", null, null, USE_TOGGLE, 0.0f, 18.0f);
	g_EntityFuncs.FireTargets("beam_r23", null, null, USE_TOGGLE, 0.0f, 18.0f);
	g_EntityFuncs.FireTargets("beam_r31", null, null, USE_TOGGLE, 0.0f, 18.0f);
	g_EntityFuncs.FireTargets("tele_zap_rotators", null, null, USE_TOGGLE, 0.0f, 18.0f);

	g_EntityFuncs.FireTargets("rotato1", null, null, USE_TOGGLE, 0.0f, 20.0f);
	g_EntityFuncs.FireTargets("rotato2", null, null, USE_TOGGLE, 0.0f, 20.0f);
	g_EntityFuncs.FireTargets("rotato3", null, null, USE_TOGGLE, 0.0f, 20.0f);
	g_EntityFuncs.FireTargets("tele_humm_rotators", null, null, USE_TOGGLE, 0.0f, 20.0f);

	g_EntityFuncs.FireTargets("beam_comp_rotator", null, null, USE_TOGGLE,0.0f, 21.0f);
	g_EntityFuncs.FireTargets("tele_zap_break", null, null, USE_TOGGLE, 0.0f, 21.0f);
	g_EntityFuncs.FireTargets("beam_comp_expl_mid", null, null, USE_TOGGLE,0.0f, 23.5f);
	g_EntityFuncs.FireTargets("beam_comp", null, null, USE_TOGGLE,0.0f, 24.0f);
	g_EntityFuncs.FireTargets("tele_zap_leftright", null, null, USE_TOGGLE, 0.0f, 24.0f);
	g_EntityFuncs.FireTargets("beam_comp_expl_right", null, null, USE_TOGGLE,0.0f, 24.5f);
	g_EntityFuncs.FireTargets("beam_comp_expl_left", null, null, USE_TOGGLE,0.0f, 25.0f);

	g_EntityFuncs.FireTargets("beam_comp", null, null, USE_TOGGLE,0.0f, 26.0f);
	g_EntityFuncs.FireTargets("beam_comp_rotator", null, null, USE_TOGGLE,0.0f, 26.0f);

	// switch off

	g_EntityFuncs.FireTargets("hl_console_shake", null, null, USE_TOGGLE, 0.0f, 23.0f);
	g_EntityFuncs.FireTargets("hl_console_shake_sound", null, null, USE_TOGGLE, 0.0f, 23.0f);

	g_EntityFuncs.FireTargets("hl_console_smoke2", null, null, USE_TOGGLE, 0.0f, 24.0f);

	g_EntityFuncs.FireTargets("tele_down", null, null, USE_TOGGLE, 0.0f, 25.0f);
	g_EntityFuncs.FireTargets("tele_hl_sign_rand", null, null, USE_TOGGLE, 0.0f, 26.0f);
	g_EntityFuncs.FireTargets("tele_humm_rotators", null, null, USE_TOGGLE, 0.0f, 26.0f);
	g_EntityFuncs.FireTargets("rotato1", null, null, USE_TOGGLE, 0.0f, 26.0f);
	g_EntityFuncs.FireTargets("rotato2", null, null, USE_TOGGLE, 0.0f, 26.0f);
	g_EntityFuncs.FireTargets("rotato3", null, null, USE_TOGGLE, 0.0f, 26.0f);
	g_EntityFuncs.FireTargets("tele_alarm", null, null, USE_TOGGLE, 0.0f, 26.0f);
	g_EntityFuncs.FireTargets("switchbeams", null, null, USE_TOGGLE, 0.0f, 26.0f);
	g_EntityFuncs.FireTargets("hl_tele_light_red", null, null, USE_TOGGLE, 0.0f, 26.0f);

	// swtich on

	g_EntityFuncs.FireTargets("hl_console_smoke1", null, null, USE_TOGGLE, 0.0f, 28.0f);

	g_EntityFuncs.FireTargets("hl_tele_light_red", null, null, USE_TOGGLE, 0.0f, 30.0f);

	g_EntityFuncs.FireTargets("tele_alarm", null, null, USE_TOGGLE, 0.0f, 32.0f);

	g_EntityFuncs.FireTargets("hl_console_explosion", null, null, USE_TOGGLE, 0.0f, 33.0f);
	g_EntityFuncs.FireTargets("hl_console_glow", null, null, USE_TOGGLE, 0.0f, 33.0f);
	g_EntityFuncs.FireTargets("hl_console_keyboard", null, null, USE_TOGGLE, 0.0f, 33.0f);

	g_EntityFuncs.FireTargets("tele_hl_sign", null, null, USE_TOGGLE, 0.0f, 34.0f);

	g_EntityFuncs.FireTargets("tele_hl_sign", null, null, USE_TOGGLE, 0.0f, 38.0f);
	g_EntityFuncs.FireTargets("tele_hl_sign_rand", null, null, USE_TOGGLE, 0.0f, 38.0f);

	g_EntityFuncs.FireTargets("switchbeams", null, null, USE_TOGGLE, 0.0f, 39.0f);
	g_EntityFuncs.FireTargets("tele_zap_leftright", null, null, USE_TOGGLE, 0.0f, 39.0f);
	g_EntityFuncs.FireTargets("tele_zap_rotators", null, null, USE_TOGGLE, 0.0f, 39.0f);
	g_EntityFuncs.FireTargets("tele_zap_ring", null, null, USE_TOGGLE, 0.0f, 39.0f);

	g_EntityFuncs.FireTargets("tele_humm_rotators", null, null, USE_TOGGLE, 0.0f, 41.0f);
	g_EntityFuncs.FireTargets("rotato1", null, null, USE_TOGGLE, 0.0f, 41.0f);
	g_EntityFuncs.FireTargets("rotato2", null, null, USE_TOGGLE, 0.0f, 41.0f);
	g_EntityFuncs.FireTargets("rotato3", null, null, USE_TOGGLE, 0.0f, 41.0f);

	g_EntityFuncs.FireTargets("beam_t11", null, null, USE_TOGGLE, 0.0f, 45.0f);
	g_EntityFuncs.FireTargets("beam_t12", null, null, USE_TOGGLE, 0.0f, 46.0f);
	g_EntityFuncs.FireTargets("beam_t21", null, null, USE_TOGGLE, 0.0f, 46.0f);
	g_EntityFuncs.FireTargets("beam_t22", null, null, USE_TOGGLE, 0.0f, 46.0f);

	g_EntityFuncs.FireTargets("tele_zap_main", null, null, USE_TOGGLE, 0.0f, 48.0f);
	g_EntityFuncs.FireTargets("mainbeam", null, null, USE_TOGGLE, 0.0f, 48.0f);

	g_EntityFuncs.FireTargets("tele_zap_main", null, null, USE_TOGGLE, 0.0f, 50.0f);
	g_EntityFuncs.FireTargets("beam_r1s", null, null, USE_TOGGLE, 0.0f, 50.0f);
	g_EntityFuncs.FireTargets("beam_r2s", null, null, USE_TOGGLE, 0.0f, 50.0f);
	g_EntityFuncs.FireTargets("beam_r3s", null, null, USE_TOGGLE, 0.0f, 50.0f);

	g_EntityFuncs.FireTargets("tele_sprite", null, null, USE_TOGGLE, 0.0f, 54.0f);
	g_EntityFuncs.FireTargets("tele_light", null, null, USE_TOGGLE, 0.0f, 54.0f);
	g_EntityFuncs.FireTargets("tele_humm_open", null, null, USE_TOGGLE, 0.0f, 54.0f);
	g_EntityFuncs.FireTargets("tele_zap_open", null, null, USE_TOGGLE, 0.0f, 54.0f);


	g_EntityFuncs.FireTargets("hl_tele_hurt", null, null, USE_TOGGLE, 0.0f, 57.8f);
	g_Scheduler.SetTimeout("HL_ChooseRand", 58);


}

void HL_ChooseRand()
{
	// fetching two entities: trigger_once for level change, and the trigger_changelevel of chapter 1
	CBaseEntity@ entity = null;
	@entity = g_EntityFuncs.FindEntityByTargetname(null, "hl_trigger_chlvl");

	CBaseEntity@ entity2 = null;
	@entity2 = g_EntityFuncs.FindEntityByTargetname(null, "hl_ch1change");

	if (entity !is null)
	{

		g_EntityFuncs.FireTargets("tele_hl_sign_rand", null, null, USE_TOGGLE, 0.0f, 0.1f);
		g_EntityFuncs.FireTargets("activate_rand_hl_rel", null, null, USE_TOGGLE, 0.0f, 1.0f);

		switch (Math.RandomLong(1,17)) // choose a chapter randomly
		{
			case 1:
				if (entity2 !is null)
				{
					switch (Math.RandomLong(1,2)) // Choose randomly where to start with Chapter 1: Trainride or not
					{
					case 1:
						entity2.KeyValue("map", "hl_c00");// change the Keyvalue "map" of "entity2"; the trigger_changelevel (see above)
					break;
					case 2:
						entity2.KeyValue("map", "hl_c01_a1");
					break;
					}
				}
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch1change"; // change the Keyvalue "target" of "entity"; the trigger_once (see above)
				g_EntityFuncs.FireTargets("tele_sign_hl1", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 2:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch2change";
				g_EntityFuncs.FireTargets("tele_sign_hl2", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 3:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch3change";
				g_EntityFuncs.FireTargets("tele_sign_hl3", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 4:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch4change";
				g_EntityFuncs.FireTargets("tele_sign_hl4", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 5:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch5change";
				g_EntityFuncs.FireTargets("tele_sign_hl5", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 6:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch6change";
				g_EntityFuncs.FireTargets("tele_sign_hl6", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 7:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch7change";
				g_EntityFuncs.FireTargets("tele_sign_hl7", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 8:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch8change";
				g_EntityFuncs.FireTargets("tele_sign_hl8", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 9:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch9change";
				g_EntityFuncs.FireTargets("tele_sign_hl9", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 10:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch10change";
				g_EntityFuncs.FireTargets("tele_sign_hl10", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 11:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch11change";
				g_EntityFuncs.FireTargets("tele_sign_hl11", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 12:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch12change";
				g_EntityFuncs.FireTargets("tele_sign_hl12", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 13:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch13change";
				g_EntityFuncs.FireTargets("tele_sign_hl13", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 14:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch14change";
				g_EntityFuncs.FireTargets("tele_sign_hl14", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 15:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch15change";
				g_EntityFuncs.FireTargets("tele_sign_hl15", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 16:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch16change";
				g_EntityFuncs.FireTargets("tele_sign_hl16", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			case 17:
				g_EntityFuncs.FireTargets("tele_vox_choosed", null, null, USE_TOGGLE, 0.0f, 0.1f);
				entity.pev.target = "hl_ch17change";
				g_EntityFuncs.FireTargets("tele_sign_hl17", null, null, USE_TOGGLE, 0.0f, 0.1f);
			break;

			default: // If case is none of the above, do this.
				g_Game.AlertMessage(at_console, "HL Random teleporter: SWITCH CASE-- DEFAULT.\n This message should never happen.\n");
				dsplmsg("HL Random Teleporter: \"switch case\" is \"default\".\nIf this happens frequently,\nask the Server Admin if this Version is modified.", 8.0f);
				HLRand_Emergency_off();
			break;
		}
	}
	else
	{
		// if "entity" is NULL, do this.
		g_Game.AlertMessage(at_console, "HL Random teleporter: Entity not found.\n This message should never happen.\n");
		dsplmsg("HL Random Teleporter: \"entity\" is NULL\nIf this happens frequently,\nask the Server Admin if this Version is modified.", 8.0f);
		HLRand_Emergency_off();
	}
}

void HLRand_Emergency_off()
{
	// "Emergency Shut-down sequence": For when the random selection fails for whatever reason. Switch everything off, unlock the door.
	// Random teleporter stays unusable, but the player can walk around again.
	g_EntityFuncs.FireTargets("tele_down", null, null, USE_TOGGLE, 0.0f, 0.1f);
	g_EntityFuncs.FireTargets("tele_zap_main", null, null, USE_TOGGLE, 0.0f, 1.1f);
	g_EntityFuncs.FireTargets("switchbeams", null, null, USE_TOGGLE, 0.0f, 1.1f);
	g_EntityFuncs.FireTargets("tele_sprite", null, null, USE_TOGGLE, 0.0f, 1.1f);
	g_EntityFuncs.FireTargets("tele_light", null, null, USE_TOGGLE, 0.0f, 1.1f);
	g_EntityFuncs.FireTargets("tele_humm_open", null, null, USE_TOGGLE, 0.0f, 1.1f);
	g_EntityFuncs.FireTargets("mainbeam", null, null, USE_TOGGLE, 0.0f, 1.1f);
	g_EntityFuncs.FireTargets("beam_r1s", null, null, USE_TOGGLE, 0.0f, 1.1f);
	g_EntityFuncs.FireTargets("beam_r2s", null, null, USE_TOGGLE, 0.0f, 1.1f);
	g_EntityFuncs.FireTargets("beam_r3s", null, null, USE_TOGGLE, 0.0f, 1.1f);
	g_EntityFuncs.FireTargets("beam_t11", null, null, USE_TOGGLE, 0.0f, 1.1f);
	g_EntityFuncs.FireTargets("beam_t12", null, null, USE_TOGGLE, 0.0f, 1.1f);
	g_EntityFuncs.FireTargets("beam_t21", null, null, USE_TOGGLE, 0.0f, 1.1f);
	g_EntityFuncs.FireTargets("beam_t22", null, null, USE_TOGGLE, 0.0f, 1.1f);
	g_EntityFuncs.FireTargets("hl_tele_hurt", null, null, USE_TOGGLE, 0.0f, 1.1f);

	g_EntityFuncs.FireTargets("tele_hl_sign_rand", null, null, USE_OFF, 0.0f, 3.1f);
	g_EntityFuncs.FireTargets("tele_hl_sign", null, null, USE_ON, 0.0f, 3.1f);
	g_EntityFuncs.FireTargets("tele_humm_rotators", null, null, USE_TOGGLE, 0.0f, 3.1f);
	g_EntityFuncs.FireTargets("rotato1", null, null, USE_TOGGLE, 0.0f, 3.1f);
	g_EntityFuncs.FireTargets("rotato2", null, null, USE_TOGGLE, 0.0f, 3.1f);
	g_EntityFuncs.FireTargets("rotato3", null, null, USE_TOGGLE, 0.0f, 3.1f);

	g_EntityFuncs.FireTargets("tele_alarm", null, null, USE_TOGGLE, 0.0f, 4.1f);

	//g_EntityFuncs.FireTargets("lock_hldoor", null, null, USE_TOGGLE, 0.0f, 5.1f);

	//g_EntityFuncs.FireTargets("normalspawn", null, null, USE_TOGGLE, 0.0f, 5.1f);
	//g_EntityFuncs.FireTargets("hlspawn", null, null, USE_TOGGLE, 0.0f, 5.1f);
	g_EntityFuncs.FireTargets("hl_tele_light_white", null, null, USE_TOGGLE, 0.0f, 5.1f);
	g_EntityFuncs.FireTargets("light_outside", null, null, USE_TOGGLE, 0.0f, 5.1f);
	g_EntityFuncs.FireTargets("hl_tele_light_red", null, null, USE_TOGGLE, 0.0f, 5.1f);

	g_EntityFuncs.FireTargets("hl_lock1_bolt_door", null, null, USE_OFF, 0.0f, 5.0f);
	g_EntityFuncs.FireTargets("hl_lock1_setorigin2", null, null, USE_OFF, 0.0f, 7.0f);
	g_EntityFuncs.FireTargets("hl_lock2_setorigin2", null, null, USE_OFF, 0.0f, 7.0f);

	g_EntityFuncs.FireTargets("hl_lock1_setorigin", null, null, USE_ON, 0.0f, 7.1f);
	g_EntityFuncs.FireTargets("hl_lock2_setorigin", null, null, USE_ON, 0.0f, 7.1f);

	g_EntityFuncs.FireTargets("hl_lock1_lock", null, null, USE_OFF, 0.0f, 7.5f);
	g_EntityFuncs.FireTargets("hl_lock2_lock", null, null, USE_OFF, 0.0f, 7.5f);


	g_EntityFuncs.FireTargets("tele_hl_sign", null, null, USE_OFF, 0.0f, 8.0f);
	g_EntityFuncs.FireTargets("lock_hldoor", null, null, USE_TOGGLE, 0.0f, 8.0f);
	g_EntityFuncs.FireTargets("normalspawn", null, null, USE_ON, 0.0f, 8.0f);
	g_EntityFuncs.FireTargets("hlspawn", null, null, USE_OFF, 0.0f, 8.0f);



}
