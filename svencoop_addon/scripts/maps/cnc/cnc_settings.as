/*
* Prototype Command & Conquer like game mode
* Settings
*/
#include "../../BrushTemplating"
#include "cnc_constants"
#include "cnc_teams"

namespace CNC
{
const float DEFAULT_OBJECT_HEALTH = 100;

/*
* The global settings for CNC game mode.
* If you want to change anything, change it on map spawn. Once activated, the settings are locked.
*/
final class Settings
{
	private bool m_bIsLocked = false;
	
	/*
	* Once locked, the settings cannot be changed anymore
	*/
	bool Locked
	{
		get const { return m_bIsLocked; }
	}
	
	void Lock()
	{
		m_bIsLocked = true;
	}
	
	private BrushTemplating::BrushTemplates m_BrushTemplates;
	
	/*
	* The global brush template container
	*/
	BrushTemplating::BrushTemplates@ BrushTemplates
	{
		get { return @m_BrushTemplates; }
	}

	private string m_szBuildingNameKV = "$s_buildingname";
	
	/*
	* The custom keyvalue that indicates the name of the building to spawn
	*/
	string BuildingNameKV
	{
		get const { return m_szBuildingNameKV; }
		
		set
		{
			if( Locked )
				return;
				
			value.Trim();
			
			if( value.IsEmpty() )
				return;
				
			m_szBuildingNameKV = value;
		}
	}
	
	private string m_szBuyerTeamId = "CNC_BUYER_TEAM";
	
	/*
	* The user data key that contains a player's team object
	*/
	string TeamId
	{
		get const { return m_szBuyerTeamId; }
		
		set
		{
			if( Locked )
				return;
				
			value.Trim();
			
			if( value.IsEmpty() )
				return;
				
			m_szBuyerTeamId = value;
		}
	}

	private string m_szBuildingId = "CNC_BUILDING";
	
	/*
	* The user data key that contains the building object
	*/
	string BuildingId
	{
		get const { return m_szBuildingId; }
		
		set
		{
			if( Locked )
				return;
				
			value.Trim();
			
			if( value.IsEmpty() )
				return;
				
			m_szBuildingId = value;
		}
	}
	
	private string m_szPlayerId = "CNC_PLAYER";
	
	/*
	* The user data key that contains the player
	*/
	string PlayerId
	{
		get const { return m_szPlayerId; }
		
		set
		{
			if( Locked )
				return;
				
			value.Trim();
			
			if( value.IsEmpty() )
				return;
				
			m_szPlayerId = value;
		}
	}

	private string m_szCrateTemplate = "crate_template";
	
	/*
	* The name of the template used for crates
	* TODO make per object version
	*/
	string CrateTemplate
	{
		get const { return m_szCrateTemplate; }
		
		set
		{
			if( Locked )
				return;
				
			value.Trim();
			
			if( value.IsEmpty() )
				return;
				
			m_szCrateTemplate = value;
		}
	}
	
	private EHandle m_hBuildingRotationEnt;
	
	/*
	* The entity whose rotation will be used as a basis for spawned buildings
	*/
	EHandle BuildingRotationEntity
	{
		get const { return m_hBuildingRotationEnt; }
		
		set
		{
			if( Locked )
				return;
				
			m_hBuildingRotationEnt = value;
		}
	}
	
	private float m_flHUDUpdateInterval = 1;
	
	/*
	* Delay between HUD updates
	*/
	float HUDUpdateInterval
	{
		get const { return m_flHUDUpdateInterval; }
		
		set
		{
			//Minimum 0.5 seconds to avoid network issues
			if( value < 0.5 )
				value = 0.5;
				
			m_flHUDUpdateInterval = value;
		}
	}
	
	private ResourceCarryRules@ m_pDefaultCarryRules = CNC::IncrementalResourceCarryRules( 2, 3 );
	
	ResourceCarryRules@ DefaultCarryRules
	{
		get const { return m_pDefaultCarryRules; }
		
		set
		{
			if( Locked )
				return;
				
			@m_pDefaultCarryRules = value;
		}
	}
	
	/*
	* These settings can be changed after activation.
	*/
	private Teams m_Teams;
	
	/*
	* This manages all of the teams in the game mode.
	*/
	Teams@ Teams
	{
		get { return @m_Teams; }
	}
	
	private TeamDataAccessor@ m_pTeamDataAccessor = null;
	
	TeamDataAccessor@ TeamDataAccessor
	{
		get const { return m_pTeamDataAccessor; }
		
		set
		{
			@m_pTeamDataAccessor = value;
		}
	}
	
	private Vector m_vecRotation = Vector();
	
	/*
	* How many degrees to add to a building's spawn rotation, on top of the building rotation entity's rotation, if it exists.
	* Value is in degrees.
	*/
	Vector Rotation
	{
		get const { return m_vecRotation; }
		
		set
		{
			m_vecRotation = value;
		}
	}
	
	private Vector m_vecRotationIncrement = Vector( 0, 90, 0 );
	
	/*
	* By how many degrees to increment m_vecRotation each time the AddBuildingRotation function is called.
	*/
	Vector RotationIncrement
	{
		get const { return m_vecRotationIncrement; }
		
		set
		{
			m_vecRotationIncrement = value;
		}
	}
	
	private Vector m_vecCrateSpawnPoint = Vector();
	
	/*
	* The default location to spawn new crates
	*/
	Vector CrateSpawnPoint
	{
		get const { return m_vecCrateSpawnPoint; }
		
		set
		{
			m_vecCrateSpawnPoint = value;
		}
	}
	
	private array<float> m_flDefaultHealths;
	
	/*
	* Gets the default health for the given buyable type
	*/
	float get_DefaultHealth( uint uiIndex )
	{
		if( uiIndex < m_flDefaultHealths.size() )
			return m_flDefaultHealths[ uiIndex ];
			
		return DEFAULT_OBJECT_HEALTH;
	}
	
	/*
	* Sets the default health for the given buyable type
	*/
	void set_DefaultHealth( uint uiIndex, float value )
	{
		if( uiIndex < m_flDefaultHealths.size() )
			m_flDefaultHealths[ uiIndex ] = value;
	}
	
	private void InitializeDefaultHealths()
	{
		m_flDefaultHealths.resize( Buyable_Count );
		
		for( uint uiIndex = 0; uiIndex < Buyable_Count; ++uiIndex )
		{
			m_flDefaultHealths[ uiIndex ] = DEFAULT_OBJECT_HEALTH;
		}
	}
	
	/*
	* Tune this to change money given for each resource
	*/
	private array<float> m_MoneyForResourceType = { 1, 2 }; //100 200
	
	/*
	* Gets the money for the given resource type
	*/
	float get_MoneyForResourceType( uint uiIndex )
	{
		if( uiIndex < m_MoneyForResourceType.size() )
			return m_MoneyForResourceType[ uiIndex ];
			
		return 0;
	}
	
	/*
	* Sets the money for the given resource type
	*/
	void set_MoneyForResourceType( uint uiIndex, float value )
	{
		if( uiIndex < m_MoneyForResourceType.size() )
			m_MoneyForResourceType[ uiIndex ] = value;
	}
	
	private void InitializeMoneyForResourceType()
	{
		m_MoneyForResourceType.insertLast( 1 ); //Regular 100
		m_MoneyForResourceType.insertLast( 2 ); //Big 200
	}
	
	private array<float> m_MoneyForCrystalType = { 15, 30, 45, 50 }; //{ 5, 10, 15, 20 };
	
	float get_MoneyForCrystalType( uint uiIndex )
	{
		if( uiIndex < m_MoneyForCrystalType.size() )
			return m_MoneyForCrystalType[ uiIndex ];
			
		return 0;
	}
	
	/*
	* Sets the money for the given resource type
	*/
	void set_MoneyForCrystalType( uint uiIndex, float value )
	{
		if( uiIndex < m_MoneyForCrystalType.size() )
			m_MoneyForCrystalType[ uiIndex ] = value;
	}
	
	private void InitializeMoneyForCrystalType()
	{
		m_MoneyForCrystalType.insertLast( 15 ); 
		m_MoneyForCrystalType.insertLast( 30 );
		m_MoneyForCrystalType.insertLast( 45 );
		m_MoneyForCrystalType.insertLast( 50 );		
	}
	
	
	Settings()
	{
		InitializeDefaultHealths();
		InitializeMoneyForResourceType();
		InitializeMoneyForCrystalType();
	}
}

Settings g_Settings;
}