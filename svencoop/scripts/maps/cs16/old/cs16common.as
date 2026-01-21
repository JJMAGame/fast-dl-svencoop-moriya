#include "BuyMenu"
#include "pistols/weapon_usp"
#include "pistols/weapon_p228"
#include "pistols/weapon_fiveseven"
#include "pistols/weapon_csdeagle"
#include "pistols/weapon_dualelites"
#include "pistols/weapon_csglock18"
#include "rifles/weapon_ak47"
#include "rifles/weapon_m4a1"
#include "rifles/weapon_galil"
#include "rifles/weapon_aug"
#include "rifles/weapon_sg552"
#include "rifles/weapon_awp"
#include "rifles/weapon_g3sg1"
#include "rifles/weapon_sg550"
#include "rifles/weapon_scout"
#include "rifles/weapon_famas"
#include "smgs/weapon_ump45"
#include "smgs/weapon_mp5navy"
#include "smgs/weapon_tmp"
#include "smgs/weapon_mac10"
#include "smgs/weapon_p90"
#include "shotguns/weapon_xm1014"
#include "shotguns/weapon_m3"
#include "misc/weapon_hegrenade"
#include "misc/weapon_csm249"
#include "misc/weapon_csknife"

/*#include "BulletEjection"
#include "weapon_c4"
#include "cs16ammo"*/

BuyMenu::BuyMenu g_BuyMenu;

void RegisterCS16()
{
	g_BuyMenu.RemoveItems();
	CS_USP::Register();
	CS_P228::Register();
	CS_FIVESEVEN::Register();
	CS_DEAGLE::Register();
	CS_ELITES::Register();
	CS_AK47::Register();
	CS_M4A1::Register();
	CS_GALIL::Register();
	CS_AUG::Register();
	CS_SG552::Register();
	CS_AWP::Register();
	CS_G3SG1::Register();
	CS_SG550::Register();
	CS_SCOUT::Register();
	CS_FAMAS::Register();
	CS_UMP45::Register();
	CS_MP5::Register();
	CS_TMP::Register();
	CS_MAC10::Register();
	CS_P90::Register();
	CS_XM1014::Register();
	CS_M3::Register();
	CS_HEGRENADE::Register();
	CS_M249::Register();
	CS_KNIFE::Register();
	CS_GLOCK::Register();
	
	/*RegisterC4();

	RegisterCSAmmo();
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<7> Ammo 5.56 Nato", "ammo_cs_556", 7, false ) );	// false = personally , true = globally
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<8> Ammo 7.62 Nato", "ammo_cs_762", 8, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<4> Ammo 9mm Para", "ammo_cs_9mm", 4, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<5> Ammo FN 57", "ammo_cs_fn57", 5, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<7> Ammo .50 Ae", "ammo_cs_50ae", 7, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<3> Ammo .45 Acp", "ammo_cs_45acp", 3, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<2> Ammo .357 Sig", "ammo_cs_357sig", 2, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<6> Ammo 12 Gauge", "ammo_cs_buckshot", 6, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<15> Ammo .338 Lapua", "ammo_cs_338lapua", 15, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<12> Ammo 5.56 Nato Heavy", "ammo_cs_556box", 12, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<5> CS Knife", "weapon_csknife", 5, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<4> Glock 18", "weapon_csglock18", 4, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<5> USP", "weapon_usp", 5, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<6> P-228", "weapon_p228", 6, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<7> Desert Eagle", "weapon_csdeagle", 7, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<8> Five Seven", "weapon_fiveseven", 8, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<8> Dual Elites", "weapon_dualelites", 8, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<17> Leone 12 Gauge M3", "weapon_m3", 17, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<30> XM-1014", "weapon_xm1014", 30, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<13> TMP", "weapon_tmp", 13, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<14> Mac-10", "weapon_mac10", 14, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<15> MP5 Navy", "weapon_mp5navy", 15, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<17> Ump-45", "weapon_ump45", 17, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<24> P-90", "weapon_p90", 24, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<20> Galil", "weapon_galil", 20, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<23> Famas", "weapon_famas", 23, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<31> M4a1", "weapon_m4a1", 31, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<25> AK-47", "weapon_ak47", 25, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<35> AUG", "weapon_aug", 35, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<35> SG-552", "weapon_sg552", 35, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<28> Scout", "weapon_scout", 28, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<48> AWP", "weapon_awp", 48, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<50> G3-SG1", "weapon_g3sg1", 50, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<42> SG-550", "weapon_sg550", 42, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<58> M249", "weapon_csm249", 58, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<10> HE Grenade", "weapon_hegrenade", 10, false ) );
	g_BuyMenu.AddItem( BuyMenu::BuyableItem( "<35> C4", "weapon_c4", 35, false ) );*/
	g_Hooks.RegisterHook( Hooks::Player::ClientSay, @CS16ClientSay );
}

HookReturnCode CS16ClientSay( SayParameters@ pParams )
{
	CBasePlayer@ pPlayer = pParams.GetPlayer();
	const CCommand@ args = pParams.GetArguments();
	
	if( args.ArgC() == 1 && args.Arg(0) == "buy" || args.Arg(0) == "/buy" )
	{
		pParams.ShouldHide = true;
		g_BuyMenu.Show( pPlayer );
	}
	else if( args.ArgC() == 2 && args.Arg(0) == "buy" || args.Arg(0) == "/buy" )
	{
		pParams.ShouldHide = true;
		bool bItemFound = false;
		string szItemName;
		uint uiCost;

		if( g_BuyMenu.m_Items.length() > 0 )
		{
			for( uint i = 0; i < g_BuyMenu.m_Items.length(); i++ )
			{
				if( "weapon_" + args.Arg(1) == g_BuyMenu.m_Items[i].EntityName || "ammo_" + args.Arg(1) == g_BuyMenu.m_Items[i].EntityName )
				{
					bItemFound = true;
					szItemName = g_BuyMenu.m_Items[i].EntityName;
					uiCost = g_BuyMenu.m_Items[i].Cost;
					break;
				}
				else
					bItemFound = false;
			}
			if( bItemFound )
			{
				if(  pPlayer.pev.frags <= 0 )
				{
				g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Not enough money(frags) - Cost: " + uiCost + "\n" );
				}
				else 
					if( uint(pPlayer.pev.frags) >= uiCost )
					{
						pPlayer.pev.frags -= uiCost;
						pPlayer.GiveNamedItem( szItemName );
					}
					else
					g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Not enough money(frags) - Cost: " + uiCost + "\n" );
			}
			else
			{
				g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "Invalid item: " + args.Arg(1) + "\n" );
			}
		}
	}
	return HOOK_CONTINUE;
}