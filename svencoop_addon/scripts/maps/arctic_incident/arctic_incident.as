
#include "../point_checkpoint_fixed"

#include "beast/replace_weapon_sprites"

#include "w00tguy/env_weather"

#include "ins2/brifl/weapon_ins2fnfal"
#include "ins2/handg/weapon_ins2beretta"

const string strSnowSprite = "sprites/arctic_incident/ws_snow_fx.spr";
const bool blEnableSnowfall = true;
const float flSurvivalVoteAllow = g_EngineFuncs.CVarGetFloat( "mp_survival_voteallow" );

EHandle hSnowFall;

array<ItemMapping@> AI_WEAPONS = 
{ 
    ItemMapping( "weapon_9mmAR", INS2_FNFAL::GetName() ),
    ItemMapping( "weapon_9mmhandgun", INS2_M9BERETTA::GetName() ),
    ItemMapping( "ammo_9mmAR", INS2_FNFAL::GetAmmoName() ),
    ItemMapping( "ammo_9mmclip", INS2_M9BERETTA::GetAmmoName() )
};

void MapInit()
{
	RegisterPointCheckPointEntity();
	WeatherMapInit();
    AIWeaponsEnable();

    g_Game.PrecacheModel( strSnowSprite );
    g_Game.PrecacheGeneric( strSnowSprite );

    g_Hooks.RegisterHook( Hooks::Player::PlayerTakeDamage, ControllerAttack );
    g_Hooks.RegisterHook( Hooks::Player::PlayerTakeDamage, GargAttack );

    if( g_Engine.mapname == "arctic_incident_1" )
	{
		g_SurvivalMode.SetStartOn( false );

		if( flSurvivalVoteAllow > 0 )
			g_EngineFuncs.CVarSetFloat( "mp_survival_voteallow", 0 );
	}
}

void MapStart()
{
    if( blEnableSnowfall )
        hSnowFall = CreateSnowWeather();
}

void AIWeaponsEnable()
{
    REPLACE_WEAPON_SPRITES::SetReplacements( "arctic_incident", "640hud_ai01;640hud_ai02", "weapon_crowbar" );
	
    INS2_M9BERETTA::V_MODEL = "models/arctic_incident/white_hevarms/v_m92fs_ai.mdl";
    INS2_M9BERETTA::P_MODEL = "models/arctic_incident/p_m92fs_ai.mdl";
    INS2_M9BERETTA::W_MODEL = "models/arctic_incident/w_m92fs_ai.mdl";
    INS2_M9BERETTA::DAMAGE = 9;
    INS2_M9BERETTA::Register();

    INS2_FNFAL::V_MODEL = "models/arctic_incident/white_hevarms/v_fnfal_ai.mdl";
    INS2_FNFAL::P_MODEL = "models/arctic_incident/p_fnfal_ai.mdl";
    INS2_FNFAL::W_MODEL = "models/arctic_incident/w_fnfal_ai.mdl";
    INS2_FNFAL::SLOT = 2;
    INS2_FNFAL::RPM_AIR = INS2_FNFAL::RPM_WTR = 450;
    INS2_FNFAL::MAX_CARRY = 120;
    INS2_FNFAL::DAMAGE = 30;
    INS2_FNFAL::Register();

    g_ClassicMode.SetItemMappings( @AI_WEAPONS );
    g_ClassicMode.ForceItemRemap( true );
}

EHandle CreateSnowWeather()
{
    dictionary snow =
    {
        { "angles", "90 0 0" },
        { "intensity", "16" },
        { "particle_spr", "" + strSnowSprite },
        { "radius", "1280" },
        { "speed_mult", "1.3" },
        { "weather_type", "2" },
        { "spawnflags", "" + Math.RandomLong( 0, 1 ) },
        { "targetname", "snow" }
    };

    EHandle hEnvWeather = EHandle( g_EntityFuncs.CreateEntity( "env_weather1", snow, true ) );

    if( hEnvWeather )
    {
        g_Scheduler.SetTimeout( "SnowThink", Math.RandomFloat( 60.0f, 120.0f ) );
        return hEnvWeather;
    }
    else
        return EHandle( null );
}

void SnowThink()
{
    if( !hSnowFall )
        return;

    hSnowFall.GetEntity().Use( hSnowFall.GetEntity(), hSnowFall.GetEntity(), USE_TOGGLE, 0.0f );
    g_Scheduler.SetTimeout( "SnowThink", Math.RandomFloat( 180.0f, 300.0f ) );
}

HookReturnCode ControllerAttack(DamageInfo@ pDamageInfo)
{
    if( pDamageInfo is null || pDamageInfo.pVictim is null || pDamageInfo.pAttacker is null || pDamageInfo.pInflictor is null )
        return HOOK_CONTINUE;

    if( pDamageInfo.pAttacker.GetClassname() == "monster_alien_controller" || pDamageInfo.pInflictor.GetClassname() == "monster_alien_controller" )
    {
        pDamageInfo.bitsDamageType = DMG_FREEZE;
        // Simulate "freezing" by slowing the player down, make it harder to escape
        pDamageInfo.pVictim.pev.velocity.x = 0.0f;
        pDamageInfo.pVictim.pev.velocity.y = 0.0f;
    }

    return HOOK_CONTINUE;
}

HookReturnCode GargAttack(DamageInfo@ pDamageInfo)
{
    if( pDamageInfo is null || pDamageInfo.pVictim is null || pDamageInfo.pAttacker is null || pDamageInfo.pInflictor is null )
        return HOOK_CONTINUE;

    if( pDamageInfo.pAttacker.GetClassname() == "monster_gargantua" || pDamageInfo.pInflictor.GetClassname() == "monster_gargantua" )
    {
        if( pDamageInfo.bitsDamageType != DMG_SONIC )
        {
            pDamageInfo.bitsDamageType = DMG_FREEZE;
            // Simulate "freezing" by slowing the player down, make it harder to escape
            pDamageInfo.pVictim.pev.velocity.x = 10.0f;
            pDamageInfo.pVictim.pev.velocity.y = 10.0f;
        }
    }

    return HOOK_CONTINUE;
}
// Force Alien Grunts to shoot their targets
void AgruntShoot(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
    CBaseMonster@ pAgrunt1 = cast<CBaseMonster@>( g_EntityFuncs.FindEntityByTargetname( pAgrunt1, "agrunt1" ) );
    CBaseMonster@ pAgrunt2 = cast<CBaseMonster@>( g_EntityFuncs.FindEntityByTargetname( pAgrunt2, "agrunt2" ) );

    if( pAgrunt1 !is null && pAgrunt1.IsAlive() )
        pAgrunt1.m_hEnemy = EHandle( g_EntityFuncs.FindEntityByTargetname( null, "hev1" ) );

    if( pAgrunt2 !is null && pAgrunt2.IsAlive() )
        pAgrunt2.m_hEnemy = EHandle( g_EntityFuncs.FindEntityByTargetname( null, "hev1" ) );
}
// Trigger Script for Survival Mode
void TurnOnSurvival(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	g_EngineFuncs.CVarSetFloat( "mp_survival_voteallow", flSurvivalVoteAllow ); // Revert to the original cvar setting as per server

	if( g_EngineFuncs.CVarGetFloat( "mp_survival_voteallow" ) > 0 && g_SurvivalMode.MapSupportEnabled() && !g_SurvivalMode.IsActive() )
		g_SurvivalMode.Activate( true );
}
// Script conflicts means I have to copypaste this instead of loading directly from survival_generic.as -_-
void DisableSurvival(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
    g_SurvivalMode.Disable();
}
