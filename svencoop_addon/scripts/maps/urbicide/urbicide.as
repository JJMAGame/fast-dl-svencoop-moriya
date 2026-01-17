#include "weapon_hlpython"
#include "weapon_hlmp5"
#include "weapon_hlshotgun"
#include "point_checkpoint"




namespace CLASSICWEAPONS2{

array<ItemMapping@> CLASSIC_WEAPONS_LIST = 
{
    ItemMapping( "weapon_m16", "weapon_hlmp5" ),
    ItemMapping( "weapon_9mmAR", "weapon_hlmp5" ),
    ItemMapping( "weapon_uzi", "weapon_hlmp5" ),
    ItemMapping( "weapon_uziakimbo", "weapon_hlmp5" ),
    ItemMapping( "weapon_shotgun", "weapon_hlshotgun" ),
	ItemMapping( "weapon_357", "weapon_hlpython" ),
	ItemMapping( "weapon_sniperrifle", "weapon_crossbow" ),
    ItemMapping( "ammo_556clip", "ammo_9mmAR" ),
    ItemMapping( "ammo_762", "ammo_crossbow" ),
    ItemMapping( "ammo_9mmuziclip", "ammo_9mmAR" )
};

void Enable()
{
    RegisterHLMP5();
	RegisterHLShotgun();
    HL_PYTHON2::Register();

    g_ClassicMode.SetItemMappings( @CLASSIC_WEAPONS_LIST );
    g_ClassicMode.ForceItemRemap( true );
    
    g_Hooks.RegisterHook( Hooks::PickupObject::Materialize, ItemSpawned2 );
}    
// World weapon swapper routine (credit to KernCore)
HookReturnCode ItemSpawned2(CBaseEntity@ pOldItem) 
{
    if( pOldItem is null ) 
        return HOOK_CONTINUE;

    for( uint w = 0; w < CLASSIC_WEAPONS_LIST.length(); ++w )
    {
        if( pOldItem.GetClassname() != CLASSIC_WEAPONS_LIST[w].get_From() )
            continue;

        CBaseEntity@ pNewItem = g_EntityFuncs.Create( CLASSIC_WEAPONS_LIST[w].get_To(), pOldItem.GetOrigin(), pOldItem.pev.angles, false );

        if( pNewItem is null ) 
            continue;

        pNewItem.pev.movetype = pOldItem.pev.movetype;

        if( pOldItem.pev.netname != "" )
            pNewItem.pev.netname = pOldItem.pev.netname;

        g_EntityFuncs.Remove( pOldItem );
        
    }
    
    return HOOK_CONTINUE;
}

}
void MapInit()
{


        RegisterPointCheckPointEntity();
	g_SurvivalMode.EnableMapSupport();

	CLASSICWEAPONS2::Enable();
}