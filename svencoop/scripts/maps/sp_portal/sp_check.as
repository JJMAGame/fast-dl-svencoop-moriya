	//Check if Half-Life, Opposing Force and/or Blue Shift is installed.

	//an Array with all HLSP (OpFor, Blue Shift, Uplink) maps. Scan through them, perform IsMapValid check.
	//If "false", map not found. Save "fail", abort scan.
	//If all maps return "true" (found), just continue sinc the save is already TRUE

void InitCheck(){


	if ((MapInitCheck) && (!spcp_hlsp_ch) && (!spcp_uplink_ch)  && (!spcp_opfor_ch) && (!spcp_bshift_ch) && !spcp_theyhunger_ch)
	{
		g_Game.AlertMessage(at_console, "No CVar override.\nStarting SP Install Check\n");
		SP_Install_Check();
		MapInitCheck = false;
	}
	else
	{
		g_Game.AlertMessage(at_console, "CVar override. Checking CVars.\n");

		CheckCVarSetting( @spcp_hlsp, "Half-Life", spcp_hlsp_ch, @UnLock_HL );
		CheckCVarSetting( @spcp_uplink, "Uplink", spcp_uplink_ch, @UnLock_Uplink );
		CheckCVarSetting( @spcp_opfor, "Opposing Force", spcp_opfor_ch, @UnLock_OpFor );
		CheckCVarSetting( @spcp_bshift, "Blue Shift", spcp_bshift_ch, @UnLock_BShift );
		CheckCVarSetting( @spcp_theyhunger, "Blue Shift", spcp_theyhunger_ch, @UnLock_TheyHunger );

		if ( ((spcp_hlsp.GetInt() == 0) || (spcp_hlsp.GetInt() == -1)) && ((spcp_uplink.GetInt() == 0) || (spcp_uplink.GetInt() == -1)) &&
			 ((spcp_opfor.GetInt() == 0) || (spcp_opfor.GetInt() == -1)) && ((spcp_bshift.GetInt() == 0) || (spcp_bshift.GetInt() == -1)) &&
			 ((spcp_theyhunger.GetInt() == 0) || (spcp_theyhunger.GetInt() == -1)))
		{
			g_Game.AlertMessage(at_console,"Warning: All areas locked. This map is useless like this.\nSet at least one SP Campaign to \"1\", or remove all CVars in your config.\n");
			float test = 10.0f;
			g_Scheduler.SetInterval("dsplmsg", 30.0f, g_Scheduler.REPEAT_INFINITE_TIMES, "Warning: All SP areas are locked.\n\nContact the Server Admin to check the CVars", test);
			g_EntityFuncs.FireTargets("bs_sealed_relay", null, null, USE_ON, 0.0f, 1.0f);
			g_EntityFuncs.FireTargets("hl_sealed_relay", null, null, USE_ON, 0.0f, 1.0f);
			g_EntityFuncs.FireTargets("of_sealed_relay", null, null, USE_ON, 0.0f, 1.0f);
			g_EntityFuncs.FireTargets("ul_sealed_relay", null, null, USE_ON, 0.0f, 1.0f);
			g_EntityFuncs.FireTargets("th_sealed_relay", null, null, USE_ON, 0.0f, 1.0f);
		}

		MapInitCheck = false;
	}
}

funcdef void UnlockCampaign(USE_TYPE useOnOff );

void CheckCVarSetting( CCVar@ pCVar, const string& in szName, const bool bSetting, UnlockCampaign@ pUnlocker )
{
	if( pUnlocker is null )
		return;

	if( pCVar.GetInt() == 1 )
	{
		g_Game.AlertMessage( at_console, "%1: CVar override\n", szName );
		pUnlocker( USE_ON );
	}
	else if( ( pCVar.GetInt() == 0 ) && bSetting )
	{
		g_Game.AlertMessage( at_console, "%1: CVar Override\n", szName );
		pUnlocker( USE_OFF );
	}
	else if( !bSetting )
	{
		g_Game.AlertMessage( at_console, "%1: No CVar Override, CVar not set.\n", szName );
		pUnlocker( USE_OFF );
	}
}

bool CheckIfMapsExist( const array<string>@ pszNames, int& out iMissingIndex )
{
	iMissingIndex = -1;

	for( uint i = 0; i < pszNames.length(); ++i )
	{
		if( g_EngineFuncs.IsMapValid( pszNames[ i ] ) == false )
		{
			iMissingIndex = int( i );
			return false;
		}
	}

	return true;
}

void CheckIfMapsExistAndReportFailure( const array<string>@ pszNames, const string& in szName, bool& out bResult, const bool bReportFree = false )
{
	int iMissingIndex;

	bResult = CheckIfMapsExist( @pszNames, iMissingIndex );

	if( !bResult )
	{
		g_Game.AlertMessage( at_console, pszNames[ iMissingIndex ] + ": does not exist. %1 not (completely) available. Abort.\n", szName );

		if( bReportFree )
			g_Game.AlertMessage(at_console,"Seriously, this is for free, why delete it? :O\n");
	}
}



void SP_Install_Check()
{
	bool HL_OK = false;
	bool OF_OK = false;
	bool UL_OK = false;
	bool BS_OK = false;
	bool TH_OK = false;

	array<string> CheckHL = {"hl_c00", "hl_c01_a1", "hl_c01_a2", "hl_c02_a1", "hl_c02_a2", "hl_c03", "hl_c04",
							"hl_c05_a1", "hl_c05_a2", "hl_c05_a3", "hl_c06", "hl_c07_a1", "hl_c07_a2",
							"hl_c08_a1", "hl_c08_a2", "hl_c09", "hl_c10",
							"hl_c11_a1", "hl_c11_a2", "hl_c11_a3", "hl_c11_a4", "hl_c11_a5",
							"hl_c12", "hl_c13_a1", "hl_c13_a2", "hl_c13_a3", "hl_c13_a4",
							"hl_c14", "hl_c15", "hl_c16_a1", "hl_c16_a2", "hl_c16_a3", "hl_c16_a4",
							"hl_c17", "hl_c18" };

	CheckIfMapsExistAndReportFailure( @CheckHL, "Half-Life", HL_OK, true );

	array<string> CheckUL = {"uplink"};

	CheckIfMapsExistAndReportFailure( @CheckUL, "uplink", UL_OK );

	array<string> CheckOF = {"of0a0", "of1a1", "of1a2", "of1a3", "of1a4", "of1a4b", "of1a5", "of1a5b",
							"of1a6", "of2a1", "of2a1b", "of2a2", "of2a4", "of2a5", "of2a6",
							"of3a1", "of3a2", "of3a4", "of3a5", "of3a6",
							"of4a1", "of4a2", "of4a3", "of4a4", "of4a5", "of5a1", "of5a2", "of5a3", "of5a4",
							"of6a1", "of6a2", "of6a3", "of6a4", "of6a4b", "of6a5"};

	CheckIfMapsExistAndReportFailure( @CheckOF, "Opposing Force", OF_OK );

	array<string> CheckBS = {"ba_tram1", "ba_canal1", "ba_canal1b", "ba_canal2", "ba_canal3",
							"ba_elevator", "ba_maint", "ba_outro", "ba_power1", "ba_power2",
							"ba_security1", "ba_security2", "ba_teleport1", "ba_teleport2", "ba_tram2", "ba_tram3",
							"ba_xen1", "ba_xen2", "ba_xen3", "ba_xen4", "ba_xen5", "ba_xen6",
							"ba_yard1", "ba_yard2", "ba_yard3", "ba_yard3a", "ba_yard3b", "ba_yard4", "ba_yard4a", "ba_yard5", "ba_yard5a"};

	CheckIfMapsExistAndReportFailure( @CheckBS, "Blue Shift", BS_OK );

	array<string> CheckTH = {"th_ep1_00","th_ep1_01","th_ep1_02","th_ep1_03","th_ep1_04","th_ep1_05",
							"th_ep2_00","th_ep2_01","th_ep2_02","th_ep2_03","th_ep2_04",
							"th_ep3_00","th_ep3_01","th_ep3_02","th_ep3_03","th_ep3_04","th_ep3_05","th_ep3_06","th_ep3_07"};

	CheckIfMapsExistAndReportFailure(@CheckTH, "They Hunger", TH_OK);


	//un/lock the areas
	if (HL_OK) { UnLock_HL(USE_ON); }
	if (UL_OK) { UnLock_Uplink(USE_ON); }
	if (OF_OK) { UnLock_OpFor(USE_ON); }
	if (BS_OK) { UnLock_BShift(USE_ON); }
	if (TH_OK) { UnLock_TheyHunger(USE_ON); }

	if (!HL_OK) { StatHL = 1; UnLock_HL(USE_OFF); };
	if (!UL_OK) { StatUL = 1; UnLock_Uplink(USE_OFF); };
	if (!OF_OK) { StatOF = 1; UnLock_OpFor(USE_OFF); };
	if (!BS_OK) { StatBS = 1; UnLock_BShift(USE_OFF); };
	if (!TH_OK) { StatTH = 1; UnLock_TheyHunger(USE_OFF); }
}

void UnLock_HL(USE_TYPE useOnOff)
{
	if (useOnOff == USE_ON)
	{
		g_Game.AlertMessage(at_console, "Half-Life: enabled\n");
		g_EntityFuncs.FireTargets("fw_clscmd_cab_open", null, null, USE_ON, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("fw_clscmd_cab_close", null, null, USE_OFF, 0.0f, 1.0f);

		if (g_ClassicMode.IsEnabled())
		{
			g_EntityFuncs.FireTargets("fw_clscmd_off", null, null, USE_OFF, 0.0f, 1.0f);
			g_EntityFuncs.FireTargets("fw_clscmd_on", null, null, USE_ON, 0.0f, 1.0f);
			g_EntityFuncs.FireTargets("clscmd_button", null, null, USE_ON, 0.0f, 1.0f);
			//g_Game.AlertMessage(at_console, "UnLock HL: Classic Mode Enabled\n");
		}
		else if (!g_ClassicMode.IsEnabled())
		{
			g_EntityFuncs.FireTargets("fw_clscmd_off", null, null, USE_ON, 0.0f, 1.0f);
			g_EntityFuncs.FireTargets("fw_clscmd_on", null, null, USE_OFF, 0.0f, 1.0f);
			//g_Game.AlertMessage(at_console, "Classic Mode : OFF\n");
		}
		ClassicModeCheckLoop();

		g_EntityFuncs.FireTargets("check_hlok", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("lock_hldoor", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("tele_hl_lockthekey", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch1butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch2butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch3butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch4butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch5butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch6butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch7butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch8butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch9butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch10butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch11butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch12butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch13butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch14butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch15butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch16butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("hl_ch17butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
	}

	if (useOnOff == USE_OFF) {
		g_Game.AlertMessage(at_console, "Half-Life: disabled\n");
		g_EntityFuncs.FireTargets("hl_sealed_relay", null, null, USE_OFF, 0.0f, 1.0f);
	}


}

void UnLock_Uplink(USE_TYPE useOnOff)
{
	if (useOnOff == USE_ON)
	{
		g_Game.AlertMessage(at_console, "Uplink: enabled\n");
		g_EntityFuncs.FireTargets("check_ulok", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("uplink_butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
	}

	if (useOnOff == USE_OFF)
	{
		g_Game.AlertMessage(at_console, "Uplink: disabled\n");
		g_EntityFuncs.FireTargets("ul_sealed_relay", null, null, USE_OFF, 0.0f, 1.0f);
	}
}

void UnLock_OpFor(USE_TYPE useOnOff)
{
	if (useOnOff == USE_ON)
	{
		g_Game.AlertMessage(at_console, "OpFor: enabled\n");
		g_EntityFuncs.FireTargets("check_ofok", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("lock_opfordoor", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("opfor_rand_lockthekeys", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("of_ch01butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("of_ch02butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("of_ch03butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("of_ch04butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("of_ch05butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("of_ch07butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("of_ch08butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("of_ch09butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("of_ch10butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("of_ch11butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
	}


	if (useOnOff == USE_OFF)
	{
		g_Game.AlertMessage(at_console, "OpFor: disabled\n");
		g_EntityFuncs.FireTargets("of_sealed_relay", null, null, USE_OFF, 0.0f, 1.0f);
	}

}

void UnLock_BShift(USE_TYPE useOnOff)
{
	if (useOnOff == USE_ON)
	{
		g_Game.AlertMessage(at_console, "Blue Shift: enabled\n");
		g_EntityFuncs.FireTargets("check_bsok", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("bs_ch01butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("bs_ch02butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("bs_ch03butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("bs_ch04butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("bs_ch05butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("bs_ch06butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("bs_to_th_redoffgreenon", null, null, useOnOff, 0.0f, 1.0f);

	}

	if (useOnOff == USE_OFF)
	{
		g_Game.AlertMessage(at_console, "Blue Shift: disabled\n");
		g_EntityFuncs.FireTargets("bs_sealed_relay", null, null, USE_ON, 0.0f, 1.0f);
	}
}

void UnLock_TheyHunger(USE_TYPE useOnOff)
{
	if (useOnOff == USE_ON)
	{
		g_Game.AlertMessage(at_console, "They Hunger: enabled\n");
		g_EntityFuncs.FireTargets("check_thok", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("th_ep01butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("th_ep02butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("th_ep03butt_onrel", null, null, useOnOff, 0.0f, 1.0f);
		g_EntityFuncs.FireTargets("th_to_bs_redoffgreenon", null, null, useOnOff, 0.0f, 1.0f);
	}
	if (useOnOff == USE_OFF)
	{
		g_Game.AlertMessage(at_console, "They  Hunger: disabled\n");
		g_EntityFuncs.FireTargets("th_sealed_relay", null, null, USE_ON, 0.0f, 1.0f);
	}
}
