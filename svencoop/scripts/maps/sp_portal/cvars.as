CCVar spcp_hlsp( "spcp_hlsp", -1, "Controls whether Half-Life  Area is accessible or not", ConCommandFlag::None, @HLCallBack);
CCVar spcp_uplink( "spcp_uplink", -1, "Controls whether Uplink  Area is accessible or not", ConCommandFlag::None, @UplinkCallBack);
CCVar spcp_opfor( "spcp_opfor", -1, "Controls whether Opposing Force Area is accessible or not", ConCommandFlag::None, @OpForCallBack);
CCVar spcp_bshift( "spcp_bshift", -1, "Controls whether Blue Shift Area is accessible or not", ConCommandFlag::None, @BShiftCallBack);
CCVar spcp_theyhunger( "spcp_theyhunger", -1, "Controls whether They Hunger Area is accessible or not", ConCommandFlag::None, @TheyHungerCallBack);
bool spcp_hlsp_ch = false;
bool spcp_uplink_ch = false;
bool spcp_opfor_ch = false;
bool spcp_bshift_ch = false;
bool spcp_theyhunger_ch = false;

bool CheckCampaignSetting( CCVar@ pCVar, const string& in szOldValue, const bool bCurrentSetting )
{
	if (MapInitCheck)
	{
		//Clamp to valid value
		pCVar.SetInt( Math.clamp( 0, 1, pCVar.GetInt() ) );

		if ((pCVar.GetInt() == 0) || (pCVar.GetInt() == 1))
		{
			//g_Game.AlertMessage(at_console, "Someone changed \"%1\" to %2\n", pCVar.GetName(), pCVar.GetString());
			return true;
		}
		//else
		//{
		//	g_Game.AlertMessage(at_console, "\"%1\" invalid Value \"%2\". No Change (\"%3\")\n", pCVar.GetName(), pCVar.GetString(), szOldValue);
		//}
	}
	else
	{
		//Revert change
		pCVar.SetString( szOldValue );
		g_Game.AlertMessage(at_console, "Professor Oak: \"This isn't the time to use that.\"\nSet the CVars in your (listen)server.cfg.\n");

		return bCurrentSetting;
	}

	return false;
}

void HLCallBack(CCVar@ cvar, const string& in szOldValue, float flOldValue)
{
	spcp_hlsp_ch = CheckCampaignSetting( @cvar, szOldValue, spcp_hlsp_ch );

}

void UplinkCallBack(CCVar@ cvar, const string& in szOldValue, float flOldValue)
{
	spcp_uplink_ch = CheckCampaignSetting( @cvar, szOldValue, spcp_uplink_ch );
}

void OpForCallBack(CCVar@ cvar, const string& in szOldValue, float flOldValue)
{
	spcp_opfor_ch = CheckCampaignSetting( @cvar, szOldValue, spcp_opfor_ch );
}

void BShiftCallBack(CCVar@ cvar, const string& in szOldValue, float flOldValue)
{
	spcp_bshift_ch = CheckCampaignSetting( @cvar, szOldValue, spcp_bshift_ch );
}

void TheyHungerCallBack(CCVar@ cvar, const string& in szOldValue, float flOldValue)
{
	spcp_theyhunger_ch = CheckCampaignSetting( @cvar, szOldValue, spcp_bshift_ch );
}