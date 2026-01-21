/**
*	weapon_deployentity
*
*	A deployable entity weapon.
*
*	Original code by Solokiller
*	Heavily modified by Anggara_nothing 
*	3D visual models & code by Maestro Fenix ( kudos to him :D )
*/

#include "cnc_stock_misc"

const float WDE_DROP_NEXT_THINK = 0.1;
const int   WDE_MAX_CHECK_ENTS  = 128;

enum satchel_radio_e 
{
	SATCHEL_RADIO_IDLE1 = 0,
	SATCHEL_RADIO_FIDGET1,
	SATCHEL_RADIO_DRAW,
	SATCHEL_RADIO_FIRE,
	SATCHEL_RADIO_HOLSTER
};

enum satchel_radio_bodygroup
{
	SATCHEL_RADIO_BODYGROUP_CAMEO = 1
};

enum satchel_radio_cameo
{
	SATCHEL_RADIO_CAMEO_SAM = 0,
	SATCHEL_RADIO_CAMEO_SANDBAGS,
	SATCHEL_RADIO_CAMEO_PILLBOX,
	SATCHEL_RADIO_CAMEO_GUARD,
	SATCHEL_RADIO_CAMEO_GATE,
	SATCHEL_RADIO_CAMEO_WALL,
	SATCHEL_RADIO_CAMEO_WALLCORNER,
	SATCHEL_RADIO_CAMEO_ADVGUARD
};

namespace CNC
{
// Precondition : before dispatch spawn make sure "CNC_BUILDING" UserData is set!
class weapon_deployentity : ScriptBasePlayerWeaponEntity
{
	private	TraceResult					m_pTraceResult;
	private	bool						m_bRemoveMe				= false;
	private	int							m_iModelindex			= 0;
	private	CScheduledFunction@			m_pDrawNextThink		= null;
	private	BaseBuyableBuilding@ 		m_pObject				= null;
	private	CBasePlayer@				m_pPlayer				= null;
	private Vector						m_vecObjectSize			= g_vecZero;
	private	float						m_flYaw					= 0.0f;
	private	float						m_flCurrentRotate		= 0.0f;
	private int							m_iBodygroup			= 0;
	
	// Update for SC 5.11
	bool AddToPlayer(CBasePlayer@ pPlayer)
	{
		bool result = BaseClass.AddToPlayer( pPlayer );
		
		if( result )
			@m_pPlayer = cast<CBasePlayer@>( self.m_hPlayer.GetEntity() );
		
		return result;
	}
	
	float WeaponTimeBase()
	{
		return g_Engine.time;
	}
	
	void RetrieveUserDataObject()
	{
		if( m_pObject is null )
		{
			// get teh entity pointer
			dictionary@ userdata = self.GetUserData();
			BaseBuyableObject@ temp = null;
			if( !userdata.get( g_Settings.BuildingId, @temp ) )
			{
				g_Game.AlertMessage( at_console, "Failed to get building object out of weapon_deployentity (userdata failed !)\n" );
				return;
			}
			@m_pObject = cast<BaseBuyableBuilding@>( temp );
			
			if( m_pObject is null )
			{
				g_Game.AlertMessage( at_console, "Failed to get building object out of weapon_deployentity (pointer is null !)\n" );
				return;
			}
			
			//g_Game.AlertMessage( at_console, "RetrieveUserDataObject() m_pObject.Hudname = %1\n", m_pObject.Hudname );
		}
	}
	
	// Variables Init - anggaranothing
	// Since we can't create non-default constructor here :(
	void VarsInit()
	{
		// Exclusive Hold yay!
		self.m_bExclusiveHold = true;
	}
	
	// This will handle the building projection ;) - anggaranothing
	void DrawBlueprint()
	{
		if( m_pPlayer !is null && m_pPlayer.IsAlive() )
		{
			RetrieveUserDataObject();
			UpdateModelindex();
			
			if( !isModelindexEmpty() )
			{
				TraceResult temp_tr;
				edict_t@ pEdict = m_pPlayer.edict();
				
				Math.MakeVectors( m_pPlayer.pev.v_angle );
				
				float flBuildingSizeZ = ( DEPLOY_BUILDINGSIZE_ADJUST_Z_POS == Math.FLOAT_MIN ) ? m_vecObjectSize.z : DEPLOY_BUILDINGSIZE_ADJUST_Z_POS;
				
				const Vector building_size = Vector( 0, 0, flBuildingSizeZ );
				const Vector vecStart = m_pPlayer.GetOrigin() + m_pPlayer.pev.view_ofs;
				
				//See where we should place the entity.
				g_Utility.TraceLine( vecStart, vecStart + g_Engine.v_forward * DEPLOY_DEFAULT_MAX_DISTANCE, ignore_monsters, pEdict, temp_tr );
				
				// Stick to floor
				g_Utility.TraceLine( temp_tr.vecEndPos, temp_tr.vecEndPos + -g_Engine.v_up * DEPLOY_DEFAULT_MAX_DISTANCE, dont_ignore_monsters, dont_ignore_glass, pEdict, temp_tr );
				
				// Adjust end origin with building size
				temp_tr.vecEndPos = temp_tr.vecEndPos.opAdd( building_size );
				
				// Then copy it into our global TraceResult
				m_pTraceResult = temp_tr;
				
				// Lag compesation
				// Divided by 100 because life is in 0.1's
				int ping, packet_loss;
				g_EngineFuncs.GetPlayerStats( pEdict, ping, packet_loss );
				
				// Draw the building blueprint projection
				m_flYaw = m_pPlayer.pev.angles.y + m_flCurrentRotate;
				CreateTempEnt_Model( m_pPlayer.pev, m_pTraceResult.vecEndPos, m_iModelindex, matNone, ( ping / 100 ) + DEPLOY_DEFAULT_TENTMODEL_LIFE, int( m_flYaw ) );
				
				if( m_pDrawNextThink !is null )
					g_Scheduler.RemoveTimer( m_pDrawNextThink );
				@m_pDrawNextThink = g_Scheduler.SetTimeout( @this, "DrawBlueprint", 0.1 );
			}
		}
	}
	
	// This is where the modelindex initiated xD - anggaranothing
	void UpdateModelindex()
	{
		if( m_pObject !is null && isModelindexEmpty() )
		{
			// create temporary entity
			CBaseEntity@ pEntity = m_pObject.CreateBreakableBuilding( g_vecZero );
			
			// succeed?
			if( pEntity !is null )
			{
				// grab its modelindex
				m_iModelindex = pEntity.pev.modelindex;
				// let me take your size, too
				m_vecObjectSize = pEntity.pev.size;
				// then fuck off (lol)
				g_EntityFuncs.Remove( pEntity );
			}
			
			//g_Game.AlertMessage( at_console, "UpdateModelindex() m_iModelindex = %1\n", m_iModelindex );
		}
	}
	bool isModelindexEmpty()
	{
		return m_iModelindex <= 0;
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		
		PrecacheSoundImproved( DEPLOY_SOUND_SUCCESS );
		PrecacheSoundImproved( DEPLOY_SOUND_FAIL );
		
		g_Game.PrecacheModel( self, DEPLOY_VIEW_MODEL );
		g_Game.PrecacheModel( self, DEPLOY_WORLD_MODEL );
		g_Game.PrecacheModel( self, DEPLOY_PLAYER_MODEL );
		
		//g_Game.PrecacheMonster( m_szEntityClassname, true );
	}
	
	void Spawn()
	{
		VarsInit();
		self.Precache();
		
		g_EntityFuncs.SetModel( self, DEPLOY_WORLD_MODEL );
		
		RetrieveUserDataObject();
		ChangeWeaponSubmodel();
		
		self.m_iClip			= -1;
		
		if( !self.pev.FlagBitSet( FL_MONSTER ) )
			self.pev.flags |= FL_MONSTER;

		self.FallInit();// get ready to fall down.
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1		= -1;
		info.iMaxAmmo2		= -1;
		info.iMaxClip		= WEAPON_NOCLIP;
		info.iSlot 			= 5;
		info.iPosition 		= 6;
		info.iWeight		= 0;
		info.iFlags 		= ITEM_FLAG_EXHAUSTIBLE;
		return true;
	}

	bool Deploy()
	{
		DrawBlueprint();
		ChangeWeaponSubmodel();
		return self.DefaultDeploy( self.GetV_Model( DEPLOY_VIEW_MODEL ), self.GetP_Model( DEPLOY_PLAYER_MODEL ), SATCHEL_RADIO_DRAW, "hive" , 0 , self.pev.body );
	}

	void Holster( int skiplocal /* = 0 */ )
	{
		self.m_fInReload = false;// cancel any reload in progress.

		m_pPlayer.m_flNextAttack = WeaponTimeBase() + 0.5; 

		m_pPlayer.pev.viewmodel = 0;
		
		if( m_pDrawNextThink !is null )
		{
			g_Scheduler.RemoveTimer( m_pDrawNextThink );
			@m_pDrawNextThink = null;
		}
		
		BaseClass.Holster( skiplocal );
	}
	
	void PrimaryAttack()
	{
		self.SendWeaponAnim( SATCHEL_RADIO_FIRE, 0, self.pev.body );
		
		self.m_flNextPrimaryAttack = WeaponTimeBase() + DEPLOY_DEFAULT_PRIMARY_ATTACK_DELAY;
		
		if( m_pObject is null || m_bRemoveMe )
			return;
		
		//Couldn't find anywhere to put it.
		if( m_pTraceResult.flFraction == 1.0 )
		{
			SfxFailDeploy();
			return;
		}
		
		string m_szEntityClassname = m_pObject.Descriptor.TemplateName;
		
		if( m_pTraceResult.fAllSolid != 0 )
		{
			g_Game.AlertMessage( at_console, "Couldn't create deployable \"%1\": stuck in solid\n", m_szEntityClassname );
			SfxFailDeploy();
			return;
		}
		
		// Temporary entity to check space condition
		// Inherit player angles.
		Vector vecSpawnOrigin = m_pTraceResult.vecEndPos + Vector( 0, 0, DEPLOY_UNSTUCK_Z_POS );
		m_pObject.Rotation = Vector( 0, m_flYaw, 0 );
		CBaseEntity@ pEntity = m_pObject.CreateBreakableBuilding( vecSpawnOrigin );
		FixEntityBoundingBox( pEntity );
		
		if( pEntity is null )
		{
			g_Game.AlertMessage( at_console, "Couldn't create deployable \"%1\": entity could not be created\n", m_szEntityClassname );
			SfxFailDeploy();
			return;
		}
		
		if( g_EntityFuncs.DispatchSpawn( pEntity.edict() ) == -1 )
		{
			g_Game.AlertMessage( at_console, "Deployed entity was removed\n" );
			SfxFailDeploy();
			return;
		}
		
		if( g_EngineFuncs.DropToFloor( pEntity.edict() ) == -1 )
		{
			g_Game.AlertMessage( at_console, "Deployed entity is stuck in the world, removing\n" );
			g_EntityFuncs.Remove( pEntity );
			SfxFailDeploy();
			return;
		}
		
		// Check with Trace? --anggaranothing
		/*TraceResult temp_tr;
		edict_t@ pEdict = pEntity.edict();
		Vector origin = pEntity.pev.origin;
		g_Utility.TraceToss( pEntity.edict(), pEntity.edict(), temp_tr );
		//g_Utility.TraceModel( origin, origin, large_hull, pEdict, temp_tr );
		
		//bool result = g_Utility.TraceMonsterHull( pEdict, origin, origin, dont_ignore_monsters, pEdict, temp_tr );
		//g_Game.AlertMessage( at_console, "TraceMonsterHull result: %1\n", result );
		
		g_Game.AlertMessage( at_console, "pEntity.pev.origin: %4 , %5 , %6\nflFraction: %1\nfAllSolid: %2\nfStartSolid: %3\nfInOpen: %7\n", temp_tr.flFraction, temp_tr.fAllSolid, temp_tr.fStartSolid, origin.x, origin.y, origin.z, temp_tr.fInOpen );*/
		
		// Trace fails to amuse me >_<
		// check hull with UTIL_EntitiesInBox
		Vector mins = pEntity.pev.mins.opAdd( pEntity.pev.origin );
		Vector maxs = pEntity.pev.maxs.opAdd( pEntity.pev.origin );
		//g_Game.AlertMessage( at_console, "mins: %1 %2 %3\nmaxs: %4 %5 %6\n", mins.x, mins.y, mins.z, maxs.x, maxs.y, maxs.z );
		
		array<CBaseEntity@> pList ( WDE_MAX_CHECK_ENTS );
		int iFlags = ( FL_CLIENT | FL_MONSTER | FL_CUSTOMENTITY );
		int iCounts = g_EntityFuncs.EntitiesInBox( pList, mins, maxs, iFlags );
		if( iCounts > 0 )
		{
			//g_Game.AlertMessage( at_console, "EntitiesInBox iCounts: %1\n", iCounts );
			for( int i = 0; i < iCounts; i++ )
			{
				//g_Game.AlertMessage( at_console, "ClassName: %1\n", pList[i].pev.classname );
				
				// is this really blocking me?
				if( pList[i] != pEntity && ( pEntity.BlockedByEntity( pList[i],0.0f ) || pList[i].pev.classname == GetWeaponDeployEntityName() ) )
				{
					//g_Game.AlertMessage( at_console, "I'm blocked by %1\n", pList[i].pev.classname );
					g_EntityFuncs.Remove( pEntity );
					SfxFailDeploy();
					return;
				}
			}
		}
		
		// Now check with BrushEntsInBox
		iCounts = g_EntityFuncs.BrushEntsInBox( pList, mins, maxs );
		if( iCounts > 0 )
		{
			//g_Game.AlertMessage( at_console, "BrushEntsInBox iCounts: %1\n", iCounts );
			for( int i = 0; i < iCounts; i++ )
			{
				//g_Game.AlertMessage( at_console, "ClassName: %1\n", pList[i].pev.classname );
				
				// is this really blocking me?
				if( pList[i] != pEntity && pEntity.BlockedByEntity( pList[i],0.0f ) )
				{
					//g_Game.AlertMessage( at_console, "I'm blocked by %1\n", pList[i].pev.classname );
					g_EntityFuncs.Remove( pEntity );
					SfxFailDeploy();
					return;
				}
			}
		}
		
		// Okay, everything is alright! let's create the real object
		m_bRemoveMe = true;
		
		SfxSuccessDeploy();
		
		// remove temp ent
		g_EntityFuncs.Remove( pEntity );
		
		// revert z position or the building will "levitate"
		vecSpawnOrigin.z -= DEPLOY_UNSTUCK_Z_POS;
		// and finally spawn it!
		m_pObject.Spawn( vecSpawnOrigin );
		
		// Drop this weapon
		CBasePlayer@ pPlayer = m_pPlayer;
		pPlayer.DropItem( GetWeaponDeployEntityName() );
		// FIX : Let player pickup any items again
		pPlayer.SetItemPickupTimes( 0.0 );
	}
	
	// Rotate function --anggaranothing
	void SecondaryAttack()
	{
		self.SendWeaponAnim( SATCHEL_RADIO_FIRE, 0, self.pev.body );
		
		self.m_flNextSecondaryAttack = WeaponTimeBase() + DEPLOY_DEFAULT_SECONDARY_ATTACK_DELAY;
		m_flCurrentRotate = Math.clamp( 0.0f, 360.0f, m_flCurrentRotate + DEPLOY_DEFAULT_ROTATE_INCREMENT );
		if( m_flCurrentRotate >= 360.0 )
			m_flCurrentRotate = 0.0f;
	}
	
	void ChangeWeaponSubmodel()
	{
		// not null? change weapon skin
		if( m_pObject !is null )
		{
			if( m_pObject.Hudname == "GDI SAM placement" )
			{
				m_iBodygroup = SATCHEL_RADIO_CAMEO_SAM;
			}
			
			else if( m_pObject.Hudname == "GDI Sandbag" )
			{
				m_iBodygroup = SATCHEL_RADIO_CAMEO_SANDBAGS;
			}
			
			else if( m_pObject.Hudname == "GDI Pillbox" )
			{
				m_iBodygroup = SATCHEL_RADIO_CAMEO_PILLBOX;
			}
				
			else if( m_pObject.Hudname == "GDI Guard tower" )
			{
				m_iBodygroup = SATCHEL_RADIO_CAMEO_GUARD;
			}
			
			else if( m_pObject.Hudname == "GDI Wall gate" )
			{
				m_iBodygroup = SATCHEL_RADIO_CAMEO_GATE;
			}
			
			else if( m_pObject.Hudname == "GDI Wall" )
			{
				m_iBodygroup = SATCHEL_RADIO_CAMEO_WALL;
			}
			
			else if( m_pObject.Hudname == "GDI Wall corner" )
			{
				m_iBodygroup = SATCHEL_RADIO_CAMEO_WALLCORNER;
			}
			
			else if( m_pObject.Hudname == "GDI Advanced Guard Tower" )
			{
				m_iBodygroup = SATCHEL_RADIO_CAMEO_ADVGUARD;
			}
			
			//g_Game.AlertMessage( at_console, "Body is = %1\n", m_iBodygroup );
			//self.pev.body = m_iBodygroup;
			self.SetBodygroup( SATCHEL_RADIO_BODYGROUP_CAMEO , m_iBodygroup );
			//g_Game.AlertMessage( at_console, "Current body is = %1\n", self.GetBodygroup( SATCHEL_RADIO_BODYGROUP_CAMEO ) );
		}
	}
	
	private void SfxFailDeploy()
	{
		CBasePlayer@ pPlayer = m_pPlayer;
		g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTCENTER, "Cannot deploy here." );
		g_SoundSystem.EmitSound( pPlayer.edict(), CHAN_STATIC /*CHAN_WEAPON*/, DEPLOY_SOUND_FAIL, 1.0f, ATTN_NORM ); 
	}
	
	private void SfxSuccessDeploy()
	{
		CBasePlayer@ pPlayer = m_pPlayer;
		g_SoundSystem.EmitSound( pPlayer.edict(), CHAN_STATIC /*CHAN_WEAPON*/, DEPLOY_SOUND_SUCCESS, 1.0f, ATTN_NORM ); 
	}

	// This is used for handling dropped weapon (weaponbox) - anggaranothing
	CBasePlayerItem@ DropItem()
	{
		CBasePlayerItem@ pWeaponbox = BaseClass.DropItem();
		
		if( pWeaponbox is null )
			return null;
		
		@m_pPlayer = cast<CBasePlayer@>( self.m_hPlayer.GetEntity() );
		
		// kill me
		if( m_bRemoveMe )
		{
			g_EntityFuncs.Remove( pWeaponbox );
			self.DestroyItem();
			return null;
		}
		// fix my bodygroup
		else
		{
			pWeaponbox.pev.body = m_iBodygroup;
			if( !pWeaponbox.pev.FlagBitSet( FL_MONSTER ) )
				pWeaponbox.pev.flags |= FL_MONSTER;
		}

		return pWeaponbox;
	}
	
	void WeaponIdle( void )
	{
		if ( self.m_flTimeWeaponIdle > WeaponTimeBase()  )
			return;

		switch ( g_PlayerFuncs.SharedRandomLong( m_pPlayer.random_seed, 0, 5 ) )
		{
			case 0: 
				self.SendWeaponAnim( SATCHEL_RADIO_IDLE1, 0, self.pev.body ); 
			break;
			case 5: 
				self.SendWeaponAnim( SATCHEL_RADIO_FIDGET1, 0, self.pev.body ); 
			break;
			default:
				self.SendWeaponAnim( SATCHEL_RADIO_IDLE1, 0, self.pev.body ); 
			break;
		}
		
		self.m_flTimeWeaponIdle = WeaponTimeBase()  + g_PlayerFuncs.SharedRandomLong( m_pPlayer.random_seed, 5, 10 );// how long till we do this again.
	}
}

}


/**
*	Entity classname for this entity.
*/
string GetWeaponDeployEntityName()
{
	return "weapon_deployentity";
}

/**
*	Registers the deploy entity weapon.
*/
void RegisterWeaponDeployEntity()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "CNC::weapon_deployentity", GetWeaponDeployEntityName() );
	g_ItemRegistry.RegisterWeapon( GetWeaponDeployEntityName(), "deployentity" );
}
