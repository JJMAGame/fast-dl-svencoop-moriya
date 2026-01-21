/*
* Prototype Command & Conquer like game mode
* Constants
*/

namespace CNC
{
/*
* Which type of buyable object it is
*/
enum BuyableType
{
	Buyable_Invalid 	= -1,	//Invalid buy type
	Buyable_Building 	= 0,	//Buildings
	Buyable_Unit,				//Infantry TODO no support for this has been implemented yet
	Buyable_Count				//Must be last
}

enum BuyResult
{
	Buy_Success 			= 0,
	Buy_Error 				= 1,
	Buy_ObjectInvalid,
	Buy_NotEnoughMoney,
}

/*
* This defines the resource carry rules
*/
interface ResourceCarryRules
{
	/*
	* How many resource items can a player carry at any time?
	*/
	uint MaxCarry { get const; }
	
	/*
	* Upgrade the max carry rules
	*/
	void UpgradeMaxCarry();
	
	/*
	* Create a clone of these rules
	*/
	ResourceCarryRules@ Clone();
}

/*
* The incremental rules for resource carrying
* Start max carry at a given amount, increment by a given amount each time, limit to a maximum
*/
class IncrementalResourceCarryRules : ResourceCarryRules
{
	private uint m_uiMaxCarry;
	
	private uint m_uiIncrement;
	
	private uint m_uiMaxCarryLimit;
	
	uint MaxCarry
	{
		get const { return m_uiMaxCarry; }
	}
	
	/*
	* By how many resources should max carry be incremented?
	*/
	uint Increment
	{
		get const { return m_uiIncrement; }
		
		set
		{
			m_uiIncrement = value;
		}
	}
	
	/*
	* The limit for max carry increment
	*/
	uint MaxCarryLimit
	{
		get const { return m_uiMaxCarryLimit; }
		
		set
		{
			m_uiMaxCarryLimit = value;
			
			m_uiMaxCarry = GetLimitedCarry( m_uiMaxCarry, 0 );
		}
	}
	
	IncrementalResourceCarryRules( const uint uiInitialMaxCarry, const uint uiIncrement, const uint uiMaxCarrylimit = Math.UINT32_MAX )
	{
		m_uiMaxCarry = uiInitialMaxCarry;
		
		m_uiIncrement = uiIncrement;
		
		m_uiMaxCarryLimit = uiMaxCarrylimit;
	}
	
	/*
	* Gets a max carry amount uiMaxCarry, incremented by uiIncrement, limited by m_uiMaxCarryLimit
	*/
	uint GetLimitedCarry( const uint uiMaxCarry, const uint uiIncrement ) const
	{
		return Math.min( uiMaxCarry + uiIncrement, m_uiMaxCarryLimit );
	}
	
	void UpgradeMaxCarry()
	{
		m_uiMaxCarry = GetLimitedCarry( m_uiMaxCarry, m_uiIncrement );
	}
	
	ResourceCarryRules@ Clone()
	{
		return IncrementalResourceCarryRules( m_uiMaxCarry, m_uiIncrement, m_uiMaxCarryLimit );
	}
}
}