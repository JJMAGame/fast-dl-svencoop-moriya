/*
* Prototype Command & Conquer like game mode
* Market and wallet
*/
#include "cnc_objects"

namespace CNC
{
/*
* A market where you can buy objects
*/
final class Market
{
	private dictionary m_Buyables;
	
	const dictionary@ Buyables
	{
		get const { return m_Buyables; }
	}
	
	Market()
	{
	}
	
	BuyableDescriptor@ FindBuyableObjectDescriptor( const string& in szObject ) const
	{
		BuyableDescriptor@ pDescriptor = null;
		
		m_Buyables.get( szObject, @pDescriptor );
		
		return pDescriptor;
	}
	
	/*
	* Adds a buyable object descriptor
	* Must have a valid name
	* Must not already be in the map of objects
	*/
	BuyableDescriptor@ AddBuyableObjectDescriptor( string szName, const float flCost, const BuyableType type, BuyableObjectCreateFn@ createFn, string szTemplateName )
	{
		szName.Trim();
		
		if( szName.IsEmpty() )
		{
			g_Game.AlertMessage( at_console, "Failed to add object type to the market: empty name!\n" );
			return null;
		}
			
		if( flCost < 0 )
		{
			g_Game.AlertMessage( at_console, "Failed to add object type %1 to the market: negative cost!\n", szName );
			return null;
		}
			
		if( type == Buyable_Invalid )
		{
			g_Game.AlertMessage( at_console, "Failed to add object type %1 to the market: invalid type!\n", szName );
			return null;
		}
			
		if( createFn is null )
		{
			g_Game.AlertMessage( at_console, "Failed to add object type %1 to the market: no create function!\n", szName );
			return null;
		}
			
		szTemplateName.Trim();
		
		if( szTemplateName.IsEmpty() )
		{
			g_Game.AlertMessage( at_console, "Failed to add object type %1 to the market: empty template name!\n", szName );
			return null;
		}
			
		if( FindBuyableObjectDescriptor( szName ) !is null )
		{
			g_Game.AlertMessage( at_console, "Failed to add object type %1 to the market: duplicate entry!\n", szName );
			return null;
		}
			
		if( !g_Settings.BrushTemplates.AddTemplate( szTemplateName, true ) )
		{
			g_Game.AlertMessage( at_console, "Failed to add object type %1 to the market: no template found!\n", szName );
			return null;
		}
			
		BuyableDescriptor@ pDescriptor = BuyableDescriptor( szName, flCost, type, @createFn, szTemplateName );
			
		m_Buyables.set( szName, @pDescriptor );
		
		return @pDescriptor;
	}
	
	/*
	* Buy an object
	* If successful, sets pBoughtObject to the new object, and returns Buy_Success
	* Otherwise, sets pBoughtObject to null, and returns an error code
	*/
	BuyResult Buy( const string& in szObject, Wallet@ pWallet, BaseBuyableObject@& out pBoughtObject )
	{
		@pBoughtObject = null;
		
		if( szObject.IsEmpty() || pWallet is null )
			return Buy_Error;
			
		BuyableDescriptor@ pDescriptor = FindBuyableObjectDescriptor( szObject );
		
		if( pDescriptor is null )
			return Buy_ObjectInvalid;
			
		const float flCost = pDescriptor.Cost;
		
		if( !pWallet.CanSpendMoney( flCost ) )
			return Buy_NotEnoughMoney;
			
		if( !pWallet.SpendMoney( flCost ) )
			return Buy_Error;
			
		@pBoughtObject = pDescriptor.Create();
		
		return Buy_Success;
	}
	
	//Fenix: special edit for trigger_purchase
	BuyResult BuyUp( Wallet@ pWallet, int m_cost)
	{		
		if( pWallet is null )
			return Buy_Error;
		
		if( !pWallet.CanSpendMoney( m_cost ) )
			return Buy_NotEnoughMoney;
			
		if( !pWallet.SpendMoney( m_cost ) )
			return Buy_Error;
		
		return Buy_Success;
	}
}

/*
* A wallet that can be used to buy objects
*/
final class Wallet
{
	private float m_flMoney = 0;
	
	private float m_flTotalMoneyEarned = 0;
	
	private float m_flTotalMoneySpent = 0;
	
	//The amount of money that there currently is
	float Money
	{
		get const { return m_flMoney; }
	}
	
	//The total amount of money that has been earned
	float TotalMoneyEarned
	{
		get const { return m_flTotalMoneyEarned; }
	}
	
	//The total amount of money that has been spent
	float TotalMoneySpent
	{
		get const { return m_flTotalMoneySpent; }
	}
	
	Wallet( const float flStartingMoney )
	{
		if( flStartingMoney > 0 )
			AddMoney( flStartingMoney );
	}
	
	void AddMoney( const float flMoney )
	{
		if( flMoney <= 0 )
		{
			g_Game.AlertMessage( at_console, "Negative or 0 money added!\n" );
			return;
		}
		
		m_flMoney += flMoney;
		m_flTotalMoneyEarned += flMoney;
	}
	
	bool CanSpendMoney( const float flAmount ) const
	{
		return flAmount > 0 && flAmount <= m_flMoney;
	}
	
	//Returns true if the money was spent, false otherwise
	bool SpendMoney( const float flAmount )
	{
		if( flAmount < 0 )
		{
			g_Game.AlertMessage( at_console, "Negative money spent!\n" );
			return false;
		}
		
		//Avoid rounding errors caused by unnecessary subtractions and additions
		if( flAmount <= 0 )
			return true;
		
		if( flAmount > m_flMoney )
			return false;
			
		m_flMoney -= flAmount;
		m_flTotalMoneySpent += flAmount;
		
		return true;
	}
}
}