//==============================================================//
// Author: Created by Angry/Snarkeh, Sam "Solokiller" VanHeer. and
//		   
//		   	
// Purpose: Implements a Command & Conquer game mode, plus
//			init of all the subsystems.
//
//==============================================================//

#include "cnc"
#include "trigger_purchase"
#include "trigger_purchase_monster"
#include "trigger_money"

#include "clearschedule"
#include "cnc_stock_misc"
#include "weapon_deployentity"
//#include "func_vehicle_harvester"
//#include "monster_turret_rocket"
#include "0DEBUG_DEBUG_DEBUG"


/**
* Default health bar sprite model.
*/
const string DEFAULT_HEALTHBAR_MODEL = "sprites/cnc/cnc_health.spr";

// weapon_deployentity configs --anggaranothing
/**
*	BluePrint Projection Duration
*	Lag compesation applied automatically ( player's latency + this value )
*/
const int	DEPLOY_DEFAULT_TENTMODEL_LIFE					= 1;

/**
*	Default maximum deployment distance.
*/
const float DEPLOY_DEFAULT_MAX_DISTANCE						= 512;

/**
*	Primary Attack -> Deploy the object
*	Default delay between primary attacks.
*/
const float DEPLOY_DEFAULT_PRIMARY_ATTACK_DELAY				= 2.0f;

/**
*	Secondary Attack -> Rotate the object
*	Default delay between primary attacks.
*/
const float DEPLOY_DEFAULT_SECONDARY_ATTACK_DELAY			= 0.5f;

/**
*	Default y-axis rotation increment.
*/
const float	DEPLOY_DEFAULT_ROTATE_INCREMENT					= 25.0f;

/**
*	View model, Player model, and World model
*/
const string DEPLOY_VIEW_MODEL								= "models/cnc/v_pda_fullbright.mdl";
const string DEPLOY_PLAYER_MODEL							= "models/cnc/p_pda.mdl";
const string DEPLOY_WORLD_MODEL								= "models/cnc/w_pda_fullbright.mdl";

/**
*	If building z-axis is too low, adjust it right here
*	Set to Math.FLOAT_MIN caused value set to brush size z-axis
*	Default: 8
*/
const float		DEPLOY_BUILDINGSIZE_ADJUST_Z_POS			= 8;

/**
*	Fair z-axis stuck check
*	Default: 24
*/
const float		DEPLOY_UNSTUCK_Z_POS						= 24;

/**
*	Play sound when deploy is succeed
*/
const string 	DEPLOY_SOUND_SUCCESS						= "commandandconquer/build.wav";

/**
*	Play sound when deploy is failed
*/
const string 	DEPLOY_SOUND_FAIL							= "commandandconquer/nobuild.wav";

/**
*	Play sound when purchase failed ( insufficient funds )
*/
const string 	PURCHASE_SOUND_INSUFFICIENT					= "commandandconquer/ins.wav";

/**
*	Play sound when pick up/drop off tiberium
*/
const string 	TIBERIUM_SOUND_PICKUP						= "commandandconquer/tib_pickup.wav";
const string 	TIBERIUM_SOUND_DROPOFF						= "commandandconquer/tib_dropoff.wav";


//Constants for the turret monsters
const int TURRET_SHOTS = 2;
const Vector TURRET_SPREAD = Vector( 0, 0, 0 );
const int TURRET_TURNRATE = 30; //angles per 0.1 second
const int TURRET_MAXWAIT = 15;	// seconds turret will stay active w/o a target
const float TURRET_MACHINE_VOLUME = 0.5;

const string TURRET_GLOW_SPRITE = "sprites/flare3.spr";
const string TURRET_SMOKE = "sprites/steam1.spr";
const string SHELL_SMOKE = "sprites/smoke.spr";

enum TURRET_ANIM
	{
		TURRET_ANIM_NONE = 0,
		TURRET_ANIM_FIRE,
		TURRET_ANIM_SPIN,
		TURRET_ANIM_DEPLOY,
		TURRET_ANIM_RETIRE,
		TURRET_ANIM_DIE,
	};

/*
* The construction yard itself
*/
/*class ConstructionYard : CNC::BaseBuyableObject
{
	ConstructionYard( CNC::BuyableDescriptor@ pDescriptor )
	{
		super( pDescriptor );
	}
}

CNC::BaseBuyableObject@ CreateConYard( CNC::BuyableDescriptor@ pDescriptor )
{
	return ConstructionYard( pDescriptor );
}*/

/*
* A wall segment
*/
class Wall : CNC::BaseBuyableBuilding
{	
	Wall( CNC::BuyableDescriptor@ pDescriptor )
	{
		super( pDescriptor );
		
		StartHealth = 200;
		
		Material = matCinderBlock;
		
		Hudname = "GDI Wall";
	}
	
	void Spawn( const Vector& in vecOrigin )
	{
		CBaseEntity@ pBreakable = CreateBreakableBuilding( vecOrigin );
		
		AttachToEntity( pBreakable );
		
		CNC::FixEntityBoundingBox( pBreakable );
		
		m_healthBar = CNC::CreateBuildingHealthBar( pBreakable );
	}
}

CNC::BaseBuyableObject@ CreateWall( CNC::BuyableDescriptor@ pDescriptor )
{
	return Wall( pDescriptor );
}

/*
* A wall corner segment
*/
class WallCorner : CNC::BaseBuyableBuilding
{
	WallCorner( CNC::BuyableDescriptor@ pDescriptor )
	{
		super( pDescriptor );
		
		StartHealth = 200;
		
		Material = matCinderBlock;
		
		Hudname = "GDI Wall corner";
	}
	
	void Spawn( const Vector& in vecOrigin )
	{
		CBaseEntity@ pBreakable = CreateBreakableBuilding( vecOrigin );
		
		AttachToEntity( pBreakable );
		
		CNC::FixEntityBoundingBox( pBreakable );
		
		m_healthBar = CNC::CreateBuildingHealthBar( pBreakable );
	}
}

CNC::BaseBuyableObject@ CreateWallCorner( CNC::BuyableDescriptor@ pDescriptor )
{
	return WallCorner( pDescriptor );
}

/*
* A guard tower
*/
class GuardTower : CNC::BaseBuyableBuilding
{
	GuardTower( CNC::BuyableDescriptor@ pDescriptor )
	{
		super( pDescriptor );
		
		StartHealth = 200;
		
		Material = matMetal;
		
		Hudname = "GDI Guard tower";
	}
	
	void Spawn( const Vector& in vecOrigin )
	{
		CBaseEntity@ pBreakable = CreateBreakableBuilding( vecOrigin );
		
		AttachToEntity( pBreakable );
		
		CNC::FixEntityBoundingBox( pBreakable );
		
		m_healthBar = CNC::CreateBuildingHealthBar( pBreakable , -(pBreakable.pev.size.z * 0.75f) );
	}
}

CNC::BaseBuyableObject@ CreateGuardTower( CNC::BuyableDescriptor@ pDescriptor )
{
	return GuardTower( pDescriptor );
}

/*
* A SAM emplacement
*/
class Sam : CNC::BaseBuyableBuilding
{	
	private string					TankRocketTemplateTargetname =	"sam1";
	private	CNC::EntityDuplicator	m_tankRocketDuplicator;
	private CBaseTank@				m_pTankRocket;
	private float					m_flTankRocketZAdjust		= 10.0;
	
	Sam( CNC::BuyableDescriptor@ pDescriptor )
	{
		super( pDescriptor );
		
		StartHealth = 100;
		
		Material = matMetal;

		Hudname = "GDI SAM placement";
	}
	
	void Spawn( const Vector& in vecOrigin )
	{
		CBaseEntity@ pBreakable = CreateBreakableBuilding( vecOrigin );
		
		AttachToEntity( pBreakable );
		
		CNC::FixEntityBoundingBox( pBreakable );
		
		Vector ChildOrigin = Vector( pBreakable.pev.origin.x, pBreakable.pev.origin.y, pBreakable.pev.origin.z + pBreakable.pev.size.z + m_flTankRocketZAdjust );

		m_tankRocketDuplicator = CNC::EntityDuplicator( TankRocketTemplateTargetname );
		
		CNC::KeyValueMap mycustomkv;
		// Assign our custom keyvalues
		mycustomkv = m_tankRocketDuplicator.Keyvalues;
		mycustomkv.Add( "-relation_player",					"0" );
		mycustomkv.Add( "-relation_none",					"0" );
		mycustomkv.Add( "-relation_machine",				"3" );
		mycustomkv.Add( "-relation_human_passive",			"0" );
		mycustomkv.Add( "-relation_human_militar",			"0" );
		mycustomkv.Add( "-relation_alien_militar",			"0" );
		mycustomkv.Add( "-relation_alien_passive",			"0" );
		mycustomkv.Add( "-relation_alien_monster",			"0" );
		mycustomkv.Add( "-relation_alien_prey",				"0" );
		mycustomkv.Add( "-relation_alien_predator",			"0" );
		mycustomkv.Add( "-relation_insect",					"0" );
		mycustomkv.Add( "-relation_player_ally",			"0" );
		mycustomkv.Add( "-relation_player_bioweapon",		"0" );
		mycustomkv.Add( "-relation_monster_bioweapon",		"0" );
		m_tankRocketDuplicator.Keyvalues = mycustomkv;
		// Spawn now!
		@m_pTankRocket = cast<CBaseTank@>( m_tankRocketDuplicator.Spawn( ChildOrigin , pBreakable.pev.angles ) );
		
		if( m_pTankRocket !is null)
		{
			CNC::FixEntityBoundingBox( m_pTankRocket );
			m_healthBar = CNC::CreateBuildingHealthBar( pBreakable , m_pTankRocket.pev.size.z + m_flTankRocketZAdjust );
		}
		
		//g_Game.AlertMessage( at_console, "EntityDuplicator() Result Targetname : %1\n", m_pTankRocket.pev.targetname );
	}
	
	void Destroyed( CBaseEntity@ pBuildingEnt )
	{
		if( m_pTankRocket !is null )
			g_EntityFuncs.Remove( m_pTankRocket );
			
		CNC::BaseBuyableBuilding::Destroyed( pBuildingEnt );
	}
}

CNC::BaseBuyableObject@ CreateSam( CNC::BuyableDescriptor@ pDescriptor )
{
	return Sam( pDescriptor );
}

/*
* A Wall gate
*/
class WallGate : CNC::BaseBuyableBuilding
{
	private string					DoorTemplateTargetname		=	"gatedoor_template";
	private	CNC::EntityDuplicator	m_doorDuplicator;
	private CBaseToggle@			m_pDoor;
	private float					m_flDoorZAdjust;
	
	private string					ButtonTemplateTargetname	=	"gatebutton_template";
	private	CNC::EntityDuplicator	m_buttonDuplicator;
	private CBaseToggle@			m_pButton;
	private float					m_flButtonZAdjust			=	0;
	
	WallGate( CNC::BuyableDescriptor@ pDescriptor )
	{
		super( pDescriptor );
		
		StartHealth = 200;
		
		Material = matMetal;

		Hudname = "GDI Wall gate";
	}
	
	void Spawn( const Vector& in vecOrigin )
	{
		CBaseEntity@ pBreakable = CreateBreakableBuilding( vecOrigin );

		AttachToEntity( pBreakable );

		CNC::FixEntityBoundingBox( pBreakable );

		Vector ChildOrigin = pBreakable.pev.origin;

		ChildOrigin.z = pBreakable.pev.origin.z + m_flDoorZAdjust;
		m_doorDuplicator = CNC::EntityDuplicator( DoorTemplateTargetname );

		CNC::KeyValueMap mycustomkv;
		// Assign our custom keyvalues
		mycustomkv = m_doorDuplicator.Keyvalues;
		mycustomkv.Add( "-m_iOpenFlags",					"0" );
		mycustomkv.Add( "-m_fIgnoreTargetname",				"0" );
		mycustomkv.Add( "-m_iObeyTriggerMode",				"2" );
		mycustomkv.Add( "-breakable",						"0" );
		mycustomkv.Add( "-material",						"0" );
		mycustomkv.Add( "-instantbreak",					"0" );
		mycustomkv.Add( "-weapon",							"1" );
		mycustomkv.Add( "-explosion",						"1" );
		mycustomkv.Add( "-explodemagnitude",				"0" );
		mycustomkv.Add( "-onlytrigger",						"1" );
		mycustomkv.Add( "-breakontrigger",					"0" );
		mycustomkv.Add( "-repairable",						"0" );
		mycustomkv.Add( "-showhudinfo",						"0" );
		mycustomkv.Add( "-immunetoclients",					"1" );
		mycustomkv.Add( "-explosivesonly",					"0" );
		mycustomkv.Add( "-locked_sound",					"0" );
		mycustomkv.Add( "-unlocked_sound",					"0" );
		mycustomkv.Add( "-locked_sentence",					"0" );
		mycustomkv.Add( "-unlocked_sentence",				"0" );
		mycustomkv.Add( "-movesnd",							"2" );
		mycustomkv.Add( "-stopsnd",							"3" );
		m_doorDuplicator.Keyvalues = mycustomkv;

		// Spawn now!
		@m_pDoor = cast<CBaseToggle@>( m_doorDuplicator.Spawn( ChildOrigin , Vector( 90 , 0 , 0 ) ) );
		
		if( m_pDoor !is null )
		{
			m_pDoor.pev.angles.y		= pBreakable.pev.angles.y;
			CNC::FixEntityBoundingBox( m_pDoor );
		}

		ChildOrigin.z = pBreakable.pev.origin.z + m_flButtonZAdjust;
		m_buttonDuplicator = CNC::EntityDuplicator( ButtonTemplateTargetname );
		// Assign our custom keyvalues
		mycustomkv = m_buttonDuplicator.Keyvalues;
		mycustomkv.Add( "-locked_sound",					"0" );
		mycustomkv.Add( "-unlocked_sound",					"0" );
		mycustomkv.Add( "-locked_sentence",					"0" );
		mycustomkv.Add( "-unlocked_sentence",				"0" );
		mycustomkv.Add( "-sounds",							"3" );
		/*mycustomkv.Add( "-model_center",					"0 0 46" );
		mycustomkv.Add( "-light_origin",					"targetlight" );*/
		m_buttonDuplicator.Keyvalues = mycustomkv;

		// Spawn now!
		@m_pButton = cast<CBaseToggle@>( m_buttonDuplicator.Spawn( ChildOrigin , g_vecZero ) );
		
		if( m_pButton !is null )
		{
			m_pButton.pev.target = m_pDoor.pev.targetname;
			m_pButton.pev.angles.y = pBreakable.pev.angles.y;
			m_pButton.pev.solid = SOLID_NOT;
			m_pButton.pev.movetype = MOVETYPE_NONE;
			CNC::FixEntityBoundingBox( m_pButton );
		}

		m_healthBar = CNC::CreateBuildingHealthBar( pBreakable );
	}
	
	void Destroyed( CBaseEntity@ pBuildingEnt )
	{
		if( m_pDoor !is null )
			g_EntityFuncs.Remove( m_pDoor );
		
		if( m_pButton !is null )
			g_EntityFuncs.Remove( m_pButton );
		
		CNC::BaseBuyableBuilding::Destroyed( pBuildingEnt );
	}
}

CNC::BaseBuyableObject@ CreateWallgate( CNC::BuyableDescriptor@ pDescriptor )
{
	return WallGate( pDescriptor );
}

/*
* A sandbag emplacement
*/
class Sandbag : CNC::BaseBuyableBuilding
{	
	Sandbag( CNC::BuyableDescriptor@ pDescriptor )
	{
		super( pDescriptor );
		
		StartHealth = 200;
		
		Material = matRocks;

		Hudname = "GDI Sandbag";
	}
	
	void Spawn( const Vector& in vecOrigin )
	{
		CBaseEntity@ pBreakable = CreateBreakableBuilding( vecOrigin );
		
		AttachToEntity( pBreakable );
		
		CNC::FixEntityBoundingBox( pBreakable );
		
		m_healthBar = CNC::CreateBuildingHealthBar( pBreakable );
	}
}

CNC::BaseBuyableObject@ CreateSandbag( CNC::BuyableDescriptor@ pDescriptor )
{
	return Sandbag( pDescriptor );
}

/*
* A Pillbox
*/
class Pillbox : CNC::BaseBuyableBuilding
{	
	Pillbox( CNC::BuyableDescriptor@ pDescriptor )
	{
		super( pDescriptor );
		
		StartHealth = 200;
		
		Material = matCinderBlock;

		Hudname = "GDI Pillbox";
	}
	
	void Spawn( const Vector& in vecOrigin )
	{
		CBaseEntity@ pBreakable = CreateBreakableBuilding( vecOrigin );
		
		AttachToEntity( pBreakable );
		
		CNC::FixEntityBoundingBox( pBreakable );
		
		m_healthBar = CNC::CreateBuildingHealthBar( pBreakable );
	}
}

CNC::BaseBuyableObject@ CreatePillbox( CNC::BuyableDescriptor@ pDescriptor )
{
	return Pillbox( pDescriptor );
}

/*
* An Helipad
*/
/*class Helipad : CNC::BaseBuyableBuilding
{
	Helipad( CNC::BuyableDescriptor@ pDescriptor )
	{
		super( pDescriptor );
		
		StartHealth = 300;
		
		Material = matMetal;

		Hudname = "GDI Helipad";
	}
	
	void Spawn( const Vector& in vecOrigin )
	{
		CBaseEntity@ pBreakable = CreateBreakableBuilding( vecOrigin );
		
		AttachToEntity( pBreakable );
		
		CNC::FixEntityBoundingBox( pBreakable );
		
		m_healthBar = CNC::CreateBuildingHealthBar( pBreakable );
	}
}

CNC::BaseBuyableObject@ CreateHelipad( CNC::BuyableDescriptor@ pDescriptor )
{
	return Helipad( pDescriptor );
}*/

/*
* A SAM emplacement
*/
class GuardTowerAdv : CNC::BaseBuyableBuilding
{	
	private string					TankRocketTemplateTargetname =	"agt_ml_template";
	private	CNC::EntityDuplicator	m_tankRocketDuplicator;
	private CBaseTank@				m_pTankRocket;
	private float					m_flTankRocketZAdjust		=	580.0;
	
	GuardTowerAdv( CNC::BuyableDescriptor@ pDescriptor )
	{
		super( pDescriptor );
		
		StartHealth = 400;
		
		Material = matCinderBlock;

		Hudname = "GDI Advanced Guard Tower";
	}
	
	void Spawn( const Vector& in vecOrigin )
	{
		CBaseEntity@ pBreakable = CreateBreakableBuilding( vecOrigin );
		
		AttachToEntity( pBreakable );
		
		CNC::FixEntityBoundingBox( pBreakable );
		
		Vector ChildOrigin = Vector( pBreakable.pev.origin.x, pBreakable.pev.origin.y, pBreakable.pev.origin.z + pBreakable.pev.size.z + m_flTankRocketZAdjust );

		m_tankRocketDuplicator = CNC::EntityDuplicator( TankRocketTemplateTargetname );
		
		CNC::KeyValueMap mycustomkv;
		// Assign our custom keyvalues
		mycustomkv = m_tankRocketDuplicator.Keyvalues;
		mycustomkv.Add( "-relation_player",					"-2" );
		mycustomkv.Add( "-relation_none",					"0" );
		mycustomkv.Add( "-relation_machine",				"0" );
		mycustomkv.Add( "-relation_human_passive",			"0" );
		mycustomkv.Add( "-relation_human_militar",			"3" );
		mycustomkv.Add( "-relation_alien_militar",			"3" );
		mycustomkv.Add( "-relation_alien_passive",			"0" );
		mycustomkv.Add( "-relation_alien_monster",			"3" );
		mycustomkv.Add( "-relation_alien_prey",				"0" );
		mycustomkv.Add( "-relation_alien_predator",			"3" );
		mycustomkv.Add( "-relation_insect",					"0" );
		mycustomkv.Add( "-relation_player_ally",			"-2" );
		mycustomkv.Add( "-relation_player_bioweapon",		"0" );
		mycustomkv.Add( "-relation_monster_bioweapon",		"0" );
		m_tankRocketDuplicator.Keyvalues = mycustomkv;
		// Spawn now!
		@m_pTankRocket = cast<CBaseTank@>( m_tankRocketDuplicator.Spawn( ChildOrigin , pBreakable.pev.angles ) );
		
		if( m_pTankRocket !is null)
		{
			CNC::FixEntityBoundingBox( m_pTankRocket );
		}
		
		m_healthBar = CNC::CreateBuildingHealthBar( pBreakable );
		
		//g_Game.AlertMessage( at_console, "EntityDuplicator() Result Targetname : %1\n", m_pTankRocket.pev.targetname );
	}
	
	void Destroyed( CBaseEntity@ pBuildingEnt )
	{
		if( m_pTankRocket !is null )
			g_EntityFuncs.Remove( m_pTankRocket );
			
		CNC::BaseBuyableBuilding::Destroyed( pBuildingEnt );
	}
}

CNC::BaseBuyableObject@ CreateGuardTowerAdv( CNC::BuyableDescriptor@ pDescriptor )
{
	return GuardTowerAdv( pDescriptor );
}

/*
* Global instances of the market and wallet are in this team.
*/
CNC::Team@ g_pGlobalTeam = null;

void CreateCNCGameMode()
{
	CNC::Activate();
	
	//Fenix: seek info_target to spawn the crate
	CBaseEntity@ ent = null;
		
	@ent = g_EntityFuncs.FindEntityByTargetname( ent, "crate_spawnzone" );  
	
	if (ent !is null )
	{
		Vector vecNewOrigin = ent.pev.origin;

		CNC::g_Settings.CrateSpawnPoint = vecNewOrigin;
	}
	
	//Fenix: Disabled, now seeks for a info_target, more useful
	//Make spawn the crate at the center of the test map
	//CNC::g_Settings.CrateSpawnPoint = Vector( 512, 512, 0 );
	
	/*
	* Create resource carry rules that have incremental behavior
	* Create a new market, and a global wallet with 0 money
	*/
	CNC::Market market;
	
	@g_pGlobalTeam = CNC::SetupGlobalTeam( @CNC::IncrementalResourceCarryRules( 2, 3 ), @market, @CNC::Wallet( 0 ) );
	
	/*
	* Add the conyard as a buyable type
	*/
	//market.AddBuyableObjectDescriptor( "conyard", 100, CNC::Buyable_Building, @CreateConYard, "conyard_template" );
	market.AddBuyableObjectDescriptor( "wall", 50, CNC::Buyable_Building, @CreateWall, "wall_template" );
	market.AddBuyableObjectDescriptor( "wall_corner", 50, CNC::Buyable_Building, @CreateWallCorner, "wallcorner_template" );
	market.AddBuyableObjectDescriptor( "guard_tower", 100, CNC::Buyable_Building, @CreateGuardTower, "guardtower_template" );
	market.AddBuyableObjectDescriptor( "sam", 300, CNC::Buyable_Building, @CreateSam, "sam_template" );
	market.AddBuyableObjectDescriptor( "gate", 400, CNC::Buyable_Building, @CreateWallgate, "gate_template" );
	market.AddBuyableObjectDescriptor( "sandbag", 50, CNC::Buyable_Building, @CreateSandbag, "sandbag_template" );
	market.AddBuyableObjectDescriptor( "pillbox", 150, CNC::Buyable_Building, @CreatePillbox, "pillbox_template" );
	//market.AddBuyableObjectDescriptor( "helipad", 200, CNC::Buyable_Building, @CreateHelipad, "helipad_template" );
	market.AddBuyableObjectDescriptor( "adv_guard_tower", 300, CNC::Buyable_Building, @CreateGuardTowerAdv, "agt_template" );
}

void MapInit()
{
	CNC::Initialize();
	
	g_CustomEntityFuncs.RegisterCustomEntity( "trigger_purchase", "trigger_purchase" );
	
	g_CustomEntityFuncs.RegisterCustomEntity( "trigger_purchase_monster", "trigger_purchase_monster" );
	
	g_CustomEntityFuncs.RegisterCustomEntity( "trigger_money", "trigger_money" );
	
	//RegisterTurretRocket();

	// register goes here --anggaranothing
	RegisterWeaponDeployEntity();
	//VehicleMapInit( true, false );
	//CNC::VehicleHarvesterMapInit();
	
	//We need to precache the entity so we can dynamically spawn it
	g_Game.PrecacheOther("monster_turret_rocket");
	
	g_Game.PrecacheOther("monster_gargantua");
	g_Game.PrecacheOther("monster_pitdrone");
	g_Game.PrecacheOther("monster_gonome");
	g_Game.PrecacheOther("monster_alien_voltigore");
	g_Game.PrecacheOther("monster_alien_slave");
	
	g_Game.PrecacheModel( DEFAULT_HEALTHBAR_MODEL );
	
	CNC::PrecacheSoundImproved( PURCHASE_SOUND_INSUFFICIENT );
	CNC::PrecacheSoundImproved( TIBERIUM_SOUND_PICKUP );
	CNC::PrecacheSoundImproved( TIBERIUM_SOUND_DROPOFF );
	
	PrecacheAllMaterials();
	
	CNC::DEBUG_MapInit();
}

void MapActivate()
{
	//Create it now that the templates exist
	CreateCNCGameMode();
	
	g_Hooks.RegisterHook( Hooks::Player::ClientPutInServer, @ClientPutInServer );
	
}

HookReturnCode ClientPutInServer( CBasePlayer@ pPlayer )
{
	CNC::PlayerJoined( pPlayer );
	CNC::SetPlayerTeam( pPlayer, g_pGlobalTeam );
	//pPlayer.pev.groupinfo = int( 0xFFFFFFFF ); //CNC::Bit_GroupInfo_Mask( pPlayer.entindex() );
	
	return HOOK_CONTINUE;
}

//This shit needs to be here, otherwise it will not work. Why? Who the fuck knows
void spawnmonster( CBaseEntity@ ent )
{	
	//Spawns selected monster at trigger_purchase_monster. WARNING: If you didn't precached the entity at Map Init() and is not at the map, is going to crash the server!!
	CBaseEntity@ pMonster = g_EntityFuncs.Create( ent.pev.target, Vector(ent.pev.origin.x,ent.pev.origin.y,(ent.pev.origin.z)-10), ent.pev.angles, false, null );
	
	pMonster.pev.spawnflags = 32; //Autostart
	
	edict_t@ pEdict = pMonster.edict();
	
	g_EntityFuncs.DispatchSpawn( pEdict );
}

void PrecacheAllMaterials()
{
	for (uint i = 0; i < matNone; i++)
		g_EntityFuncs.PrecacheMaterialSounds(Materials(i));

	g_Game.PrecacheModel( "models/woodgibs.mdl" );
	g_Game.PrecacheModel( "models/fleshgibs.mdl" );
	g_Game.PrecacheModel( "models/computergibs.mdl" );
	g_Game.PrecacheModel( "models/glassgibs.mdl" );
	g_Game.PrecacheModel( "models/metalplategibs.mdl" );
	g_Game.PrecacheModel( "models/cindergibs.mdl" );
	g_Game.PrecacheModel( "models/rockgibs.mdl" );
	g_Game.PrecacheModel( "models/ceilinggibs.mdl" );

	g_SoundSystem.PrecacheSound("plats/vehicle1.wav");
	g_SoundSystem.PrecacheSound("plats/vehicle2.wav");
	g_SoundSystem.PrecacheSound("plats/vehicle3.wav");
	g_SoundSystem.PrecacheSound("plats/vehicle4.wav");
	g_SoundSystem.PrecacheSound("plats/vehicle6.wav");
	g_SoundSystem.PrecacheSound("plats/vehicle7.wav");

	g_SoundSystem.PrecacheSound("plats/vehicle_brake1.wav");
	g_SoundSystem.PrecacheSound("plats/vehicle_start1.wav");
	g_SoundSystem.PrecacheSound( "plats/vehicle_ignition.wav" );
}