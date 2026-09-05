/*
* Prototype Command & Conquer like game mode
* Objects
*/
#include "../../BrushTemplating"
#include "cnc_constants"
#include "cnc_settings"

namespace CNC
{
/*
* All buyable objects must extend from this
*/
abstract class BaseBuyableObject
{
	private BuyableDescriptor@ m_pDescriptor;
	
	private bool m_fIsBuilt = false;
	
	BuyableDescriptor@ Descriptor
	{
		get const { return m_pDescriptor; }
	}
	
	BaseBuyableObject( BuyableDescriptor@ pDescriptor )
	{
		@m_pDescriptor = @pDescriptor;
	}
	
	/*
	* Implemented by the subclass
	*/
	void Spawn( const Vector& in vecOrigin )
	{
	}
}

abstract class BaseBuyableBuilding : BaseBuyableObject
{
	private float m_flStartHealth = g_Settings.DefaultHealth[ Buyable_Building ];
	private Materials m_Material = matMetal;
	
	private Vector m_vecRotation;
	
	//Fenix: For showing HUD info, the name, team and add magnitude 
	private int spawnflags = 40; //8-repairable + 32-show in HUD
	private string displayname = "Placeholder name";
	private int classify = 11;
	private int explodemagnitude = 100;
	
	//HealthBar
	HealthBar			m_healthBar;
	
	float StartHealth
	{
		get const { return m_flStartHealth; }
		
		set
		{
			if( value <= 0 )
				value = g_Settings.DefaultHealth[ Buyable_Building ];
				
			m_flStartHealth = value;
		}
	}
	
	Materials Material
	{
		get const { return m_Material; }
		set { m_Material = value; }
	}
	
	Vector Rotation
	{
		get const { return m_vecRotation; }
		set { m_vecRotation = value; }
	}
	
	//Fenix: Get the name of the building to display
	string Hudname
	{
		get const { return displayname; }
		set { displayname = value; }
	}
	
	BaseBuyableBuilding( BuyableDescriptor@ pDescriptor )
	{
		super( pDescriptor );
	}
	
	protected void AttachToEntity( CBaseEntity@ pEntity )
	{
		if( pEntity is null )
		{
			g_Game.AlertMessage( at_console, "BaseBuyableBuilding::AttachToEntity: Null entity!\n" );
			return;
		}
		
		dictionary@ pUserData = pEntity.GetUserData();
		
		//Maintain reference to this object for cleanup
		pUserData.set( g_Settings.BuildingId, @this );
		
		//Set function to call on destroy so we can clean up
		g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "ondestroyfn", "CNC::BuildingDestroyed" );
	}
	
	CBaseEntity@ CreateBreakableBuilding( const Vector& in vecOrigin, const bool fSpawn = true ) const
	{			
		CBaseEntity@ pBreakable = BrushTemplating::CreateBrushEntityFromTemplate( @g_Settings.BrushTemplates, Descriptor.TemplateName, "func_breakable" );
	
		if( pBreakable is null )
		{
			g_Game.AlertMessage( at_console, "Unexpected null pointer while creating breakable!\n" );
			return null;
		}
		
		edict_t@ pEdict = pBreakable.edict();
		
		pBreakable.SetOrigin( vecOrigin );
		
		g_EntityFuncs.DispatchKeyValue( pEdict, "health", StartHealth );
		g_EntityFuncs.DispatchKeyValue( pEdict, "material", Material );
		
		//Fenix: For showing HUD info, the name, team and add magnitude 
		g_EntityFuncs.DispatchKeyValue( pEdict, "spawnflags", spawnflags );
		g_EntityFuncs.DispatchKeyValue( pEdict, "displayname", Hudname );
		g_EntityFuncs.DispatchKeyValue( pEdict, "classify", classify );
		g_EntityFuncs.DispatchKeyValue( pEdict, "explodemagnitude", explodemagnitude );
		
		if( fSpawn )
		{
			g_EntityFuncs.DispatchSpawn( pEdict );
			
			//In case the entity got removed
			@pBreakable = g_EntityFuncs.Instance( pEdict );
		}
		
		if( pBreakable !is null )
			pBreakable.pev.angles = Rotation;
		
		return pBreakable;
	}
	
	//Implemented by the subclass for cleanup
	void Destroyed( CBaseEntity@ pBuildingEnt )
	{
		g_Game.AlertMessage( at_console, "Building destroyed!\n" );
	}
}

void BuildingDestroyed( CBaseEntity@ pBuildingEnt )
{
	dictionary@ pUserData = pBuildingEnt.GetUserData();
	
	BaseBuyableBuilding@ pBuilding = null;
		
	if( pUserData.get( g_Settings.BuildingId, @pBuilding ) )
	{
		pBuilding.Destroyed( pBuildingEnt );
	}
}

funcdef BaseBuyableObject@ BuyableObjectCreateFn( BuyableDescriptor@ pDescriptor );

/*
* Internal representation of a a buyable object's data
*/
final class BuyableDescriptor
{
	private string m_szName;
	
	private float m_flCost;
	
	private BuyableType m_Type;
	
	private BuyableObjectCreateFn@ m_CreateFn;
	
	private string m_szTemplateName;
	
	//The name of this buyable object
	string Name
	{
		get const { return m_szName; }
	}
	
	//How much this buyable object costs
	float Cost
	{
		get const { return m_flCost; }
	}
	
	//The type of this object
	BuyableType Type
	{
		get const { return m_Type; }
	}
	
	//Name of the template
	string TemplateName
	{
		get const { return m_szTemplateName; }
	}
	
	BuyableDescriptor( const string& in szName, const float flCost, const BuyableType type, BuyableObjectCreateFn@ createFn, const string& in szTemplateName )
	{
		m_szName = szName;
		m_szName.Trim();
		m_flCost = flCost;
		m_Type = type;
		@ m_CreateFn = @createFn;
		m_szTemplateName = szTemplateName;
	}
	
	/*
	* This could perhaps be implemented using the Reflection API, but that's more complex to understand
	*/
	BaseBuyableObject@ Create()
	{
		return m_CreateFn( @this );
	}
}
}