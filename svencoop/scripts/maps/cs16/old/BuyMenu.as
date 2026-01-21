// Counter-Strike 1.6 BuyMenu
// Authors: Initial release - Solokiller; Improved Version - Zodemon; Edits to fit this Weapon pack - KernCore

namespace BuyMenu
{

final class BuyableItem
{
	private string m_szDescription;
	private string m_szEntityName;
	private string m_szCategory;
	private string m_szSubCategory;
	private uint m_uiCost = 0;
	
	string Description
	{
		get const { return m_szDescription; }
		set { m_szDescription = value; }
	}
	
	string EntityName
	{
		get const { return m_szEntityName; }
		set { m_szEntityName = value; }
	}
	
	string Category
	{
		get const { return m_szCategory; }
		set { m_szCategory = value; }
	}
	
	string SubCategory
	{
		get const { return m_szSubCategory; }
		set { m_szSubCategory = value; }
	}
	
	uint Cost
	{
		get const { return m_uiCost; }
		set { m_uiCost = value; }
	}
	
	BuyableItem( const string& in szDescription, const string& in szEntityName, const uint uiCost, string sCategory, string sSubCategory )
	{
		m_szDescription = "$"+string(uiCost)+" "+szDescription;
		m_szEntityName = szEntityName;
		m_uiCost = uiCost;
		m_szCategory = sCategory;
		m_szSubCategory = sSubCategory;
	}
	
	void Buy( CBasePlayer@ pPlayer = null )
	{
		GiveItem( pPlayer );
	}

	private void GiveItem( CBasePlayer@ pPlayer ) const
	{
		const uint uiMoney = uint( pPlayer.pev.frags );

		if( pPlayer.HasNamedPlayerItem( m_szEntityName ) !is null )
		{
			g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "You already have that item!\n" );
			return;
		}

		if( pPlayer.pev.frags <= 0 )
		{
			g_PlayerFuncs.ClientPrint(pPlayer,HUD_PRINTTALK,"Not enough money(frags) - Cost: " + m_uiCost + "\n");
			return;
		}
		else if( uiMoney >= m_uiCost )
		{
			string sCheck = "";
			//string sCat = m_szCategory == "secondary" ? "$s_secwep" : "$s_priwep";
			/**if(m_szCategory == "primary")
				sCheck = string(g_PrimaryWeapons[pPlayer.entindex()]);
			else if(m_szCategory == "secondary")
				sCheck = string(g_SecondaryWeapons[pPlayer.entindex()]);*/
			//else if(m_szCategory == "equipment")
			//	sCheck = string(g_EquipmentWeapons[pPlayer.entindex()]);
				//sCat = "$s_equwep";

			//CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
			string motherfucker = this.EntityName;
			//g_PlayerFuncs.ClientPrint(pPlayer,HUD_PRINTTALK,"Setting: " + motherfucker + "\n");
			//bool bFuck = pCustom.SetKeyvalue(sCat, motherfucker);
			//if(bFuck)
			//	g_PlayerFuncs.ClientPrint(pPlayer,HUD_PRINTTALK,"Was true\n");
			//else
			//	g_PlayerFuncs.ClientPrint(pPlayer,HUD_PRINTTALK,"Was false\n");
			/*if(m_szCategory == "primary")
				g_PrimaryWeapons[pPlayer.entindex()] = motherfucker;
			else if(m_szCategory == "secondary")
				g_SecondaryWeapons[pPlayer.entindex()] = motherfucker;
			else if(m_szCategory == "equipment")
				g_EquipmentWeapons[pPlayer.entindex()] = motherfucker;*/
		
			pPlayer.pev.frags -= m_uiCost;
			
			pPlayer.GiveNamedItem( m_szEntityName );
			pPlayer.SelectItem( m_szEntityName );
		}
		else
		{
			g_PlayerFuncs.ClientPrint(pPlayer,HUD_PRINTTALK,"Not enough money(frags) - Cost: " + m_uiCost + "\n");
			return;
		}
	}
}

final class BuyMenu
{
	array<BuyableItem@> m_Items;

	private CTextMenu@ m_pMenu = null;
	private CTextMenu@ m_pSecondaryMenu = null;
	private CTextMenu@ m_pPrimaryMenu = null;
	private CTextMenu@ m_pEquipmentMenu = null;
	private CTextMenu@ m_pAssaultMenu = null;
	private CTextMenu@ m_pMachineMenu = null;
	private CTextMenu@ m_pSpecialMenu = null;
	private CTextMenu@ m_pSniperMenu = null;
	private CTextMenu@ m_pSubmachineMenu = null;

	void RemoveItems()
	{
		if( m_Items !is null )
		{
			m_Items.removeRange( 0, m_Items.length() );
		}
	}

	void AddItem( BuyableItem@ pItem )
	{
		if( pItem is null )
			return;
			
		if( m_Items.findByRef( @pItem ) != -1 )
			return;
			
		m_Items.insertLast( pItem );
		
		//if( m_pMenu !is null )
		//	@m_pMenu = null;
	}
	
	void Show( CBasePlayer@ pPlayer = null )
	{
		if( m_pMenu is null )
			CreateMenu();
			
		if( pPlayer !is null )
			m_pMenu.Open( 0, 0, pPlayer );
	}
	
	private void CreateMenu()
	{
		@m_pMenu = CTextMenu(TextMenuPlayerSlotCallback(this.MainCallback));
		m_pMenu.SetTitle("Choose action:");
		m_pMenu.AddItem("Choose primary weapon", null);
		m_pMenu.AddItem("Choose secondary weapon", null);
		m_pMenu.AddItem("Choose equipment", null);
		//m_pMenu.AddItem("Rebuy previous", null);
		m_pMenu.Register();
		
		@m_pPrimaryMenu = CTextMenu(TextMenuPlayerSlotCallback(this.PrimaryCallback));
		m_pPrimaryMenu.SetTitle("Choose primary weapon category:");
		m_pPrimaryMenu.AddItem("Assault Rifles", null);
		m_pPrimaryMenu.AddItem("Heavy (Shotguns & Light Machine Guns)", null);
		m_pPrimaryMenu.AddItem("Special Purpose", null);
		m_pPrimaryMenu.AddItem("Sniper Rifles", null);
		m_pPrimaryMenu.AddItem("SubMachine guns & Personal Defense Weapons", null);
		m_pPrimaryMenu.Register();
		
		@m_pSecondaryMenu = CTextMenu(TextMenuPlayerSlotCallback(this.WeaponCallback));
		m_pSecondaryMenu.SetTitle("Choose secondary weapon:");
		@m_pEquipmentMenu = CTextMenu(TextMenuPlayerSlotCallback(this.WeaponCallback));
		m_pEquipmentMenu.SetTitle("Choose equipment:");

		@m_pAssaultMenu = CTextMenu(TextMenuPlayerSlotCallback(this.WeaponCallback));
		m_pAssaultMenu.SetTitle("Choose Assault Rifle:");
		@m_pMachineMenu = CTextMenu(TextMenuPlayerSlotCallback(this.WeaponCallback));
		m_pMachineMenu.SetTitle("Choose LMG or Shotgun:");
		@m_pSpecialMenu = CTextMenu(TextMenuPlayerSlotCallback(this.WeaponCallback));
		m_pSpecialMenu.SetTitle("Choose Special or Explosive weapon:");
		@m_pSniperMenu = CTextMenu(TextMenuPlayerSlotCallback(this.WeaponCallback));
		m_pSniperMenu.SetTitle("Choose Sniper Rifle:");
		@m_pSubmachineMenu = CTextMenu(TextMenuPlayerSlotCallback(this.WeaponCallback));
		m_pSubmachineMenu.SetTitle("Choose SMG or PDW:");
		for(uint i = 0; i < m_Items.length(); i++)
		{
			BuyableItem@ pItem = m_Items[i];
			if(pItem.Category == "secondary")
				m_pSecondaryMenu.AddItem(pItem.Description, any(@pItem));
			else if(pItem.Category == "equipment")
				m_pEquipmentMenu.AddItem(pItem.Description, any(@pItem));
			else if(pItem.Category == "primary")
			{
				if( pItem.SubCategory == "assault" )
					m_pAssaultMenu.AddItem( pItem.Description, any( @pItem ) );
				else if( pItem.SubCategory == "heavy" )
					m_pMachineMenu.AddItem( pItem.Description, any( @pItem ) );
				else if(pItem.SubCategory == "special")
					m_pSpecialMenu.AddItem( pItem.Description, any( @pItem ) );
				else if(pItem.SubCategory == "sniper")
					m_pSniperMenu.AddItem( pItem.Description, any( @pItem ) );
				else if(pItem.SubCategory == "smg")
					m_pSubmachineMenu.AddItem( pItem.Description, any( @pItem ) );
			}
		}
		m_pSecondaryMenu.Register();
		m_pEquipmentMenu.Register();
		m_pAssaultMenu.Register();
		m_pMachineMenu.Register();
		m_pSpecialMenu.Register();
		m_pSniperMenu.Register();
		m_pSubmachineMenu.Register();
	}
	
	private void MainCallback(CTextMenu@ menu, CBasePlayer@ pPlayer, int iSlot, const CTextMenuItem@ pItem)
	{
		if( pItem !is null )
		{
			string sChoice = pItem.m_szName;
			if(sChoice == "Choose primary weapon")
				m_pPrimaryMenu.Open(0, 0, pPlayer);
			else if(sChoice == "Choose secondary weapon")
				m_pSecondaryMenu.Open(0, 0, pPlayer);
			else if(sChoice == "Choose equipment")
				m_pEquipmentMenu.Open(0, 0, pPlayer);
			/*else if(sChoice == "Rebuy previous")
			{
				BuyableItem@ pBuyItem = null;
				BuyableItem@ pBuyItem2 = null;
				BuyableItem@ pBuyItem3 = null;
				//CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
				string sPrimary = "";
				string sSecondary = "";
				string sEquipment = "";
				//if(pCustom.GetKeyvalue("$s_priwep").Exists())
					//sPrimary = pCustom.GetKeyvalue("$s_priwep").GetString();
				//if(pCustom.GetKeyvalue("$s_secwep").Exists())
					//sSecondary = pCustom.GetKeyvalue("$s_secwep").GetString();
				//if(pCustom.GetKeyvalue("$s_equwep").Exists())
					//sEquipment = pCustom.GetKeyvalue("$s_equwep").GetString();
				string sCheck = "";//string(g_PrimaryWeapons[pPlayer.entindex()]);
				if(sCheck != "")
					sPrimary = sCheck;
				//sCheck = string(g_SecondaryWeapons[pPlayer.entindex()]);
				if(sCheck != "")
					sSecondary = sCheck;
				//sCheck = string(g_EquipmentWeapons[pPlayer.entindex()]);
				if(sCheck != "")
					sEquipment = sCheck;
				
				for(uint i = 0; i < m_Items.length(); i++)
				{
					BuyableItem@ pItem2 = m_Items[i];
					if(pItem2.EntityName == sPrimary)
						@pBuyItem = pItem2;
					else if(pItem2.EntityName == sSecondary)
						@pBuyItem2 = pItem2;
					else if(pItem2.EntityName == sEquipment)
						@pBuyItem3 = pItem2;
				}
				
				if(pBuyItem !is null)
					pBuyItem.Buy(pPlayer);
				if(pBuyItem2 !is null)
					pBuyItem2.Buy(pPlayer);
				if(pBuyItem3 !is null)
					pBuyItem3.Buy(pPlayer);
			}*/
		}
	}
	private void PrimaryCallback(CTextMenu@ menu, CBasePlayer@ pPlayer, int iSlot, const CTextMenuItem@ pItem)
	{
		if( pItem !is null )
		{
			string sChoice = pItem.m_szName;
			if(sChoice == "Assault Rifles")
				m_pAssaultMenu.Open( 0, 0, pPlayer );
			else if(sChoice == "Heavy (Shotguns & Light Machine Guns)")
				m_pMachineMenu.Open( 0, 0, pPlayer );
			else if(sChoice == "Special Purpose")
				m_pSpecialMenu.Open( 0, 0, pPlayer );
			else if(sChoice == "Sniper Rifles")
				m_pSniperMenu.Open( 0, 0, pPlayer );
			else if(sChoice == "SubMachine guns & Personal Defense Weapons")
				m_pSubmachineMenu.Open( 0, 0, pPlayer );
		}
	}
	
	private void WeaponCallback( CTextMenu@ menu, CBasePlayer@ pPlayer, int iSlot, const CTextMenuItem@ pItem )
	{
		if( pItem !is null )
		{
			BuyableItem@ pBuyItem = null;
			
			pItem.m_pUserData.retrieve( @pBuyItem );
			
			if( pBuyItem !is null )
			{
				pBuyItem.Buy( pPlayer );
				m_pMenu.Open( 0, 0, pPlayer);
			}
		}
	}

	/*private void CreateMenu()
	{
		@m_pMenu = CTextMenu( TextMenuPlayerSlotCallback( this.Callback ) );
		
		m_pMenu.SetTitle( "Buy an item:" );
		
		for( uint uiIndex = 0; uiIndex < m_Items.length(); ++uiIndex )
		{
			BuyableItem@ pItem = m_Items[ uiIndex ];
			
			m_pMenu.AddItem( pItem.Description, any( @pItem ) );
		}
		
		m_pMenu.Register();
	}
	
	private void Callback( CTextMenu@ menu, CBasePlayer@ pPlayer, int iSlot, const CTextMenuItem@ pItem )
	{
		if( pItem !is null )
		{
			BuyableItem@ pBuyItem = null;
			
			pItem.m_pUserData.retrieve( @pBuyItem );
			
			if( pBuyItem !is null )
			{
				pBuyItem.Buy( pPlayer );
			}
		}
	}*/

}
}