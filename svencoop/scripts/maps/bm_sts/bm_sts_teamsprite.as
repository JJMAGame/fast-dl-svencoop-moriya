/*
*	Adds a team sprite to the given monster
*/
#include "../../Utils"
#include "../env_healthbar"

const string g_szTeamSpritePointer = "TEAMSPRITE";

const string g_szTeamSprite 	= "sprites/sprite_a_1.spr";

const array<string> G_SZ_TECHLEVELSPRS =
{
	"tlv0_health.spr",
	"tlv1_health.spr",
	"tlv2_health.spr",
	"tlv3_health.spr",
	"tlv4_health.spr",
	"tlv5_health.spr"
};

CBaseEntity@ GetTeamSprite( CBaseEntity@ pMonster )
{
	dictionary@ userdata = pMonster.GetUserData();
	
	CBaseEntity@ pSprite;
	
	if( userdata.get( g_szTeamSpritePointer, @pSprite ) )
		return pSprite;
	else
		return null;
}

void SetTeamSprite( CBaseEntity@ pMonster, CBaseEntity@ pEntity )
{
	dictionary@ userdata = pMonster.GetUserData();
	
	userdata.set( g_szTeamSpritePointer, @pEntity );
}

void AddTeamSprite( CBaseMonster@ pSquadMaker, CBaseEntity@ pEntity )
{
	CBaseMonster@ pMonster = cast<CBaseMonster@>( pEntity );
	CustomKeyvalues@ kvSquadMaker = pSquadMaker.GetCustomKeyvalues();
	uint iTechLevel = kvSquadMaker.HasKeyvalue( "$i_techlevel" ) ? kvSquadMaker.GetKeyvalue( "$i_techlevel" ).GetInteger() - 1 : 0;
	iTechLevel = Math.clamp( 0, 5, iTechLevel );
	// Monsters only
	if( pMonster is null || !HEALTHBAR::blHealthBarEntityRegistered )
		return;
	
	//CSprite@ pSprite = g_EntityFuncs.CreateSprite( GetSpriteForColor( pMonster.pev.rendercolor ), pMonster.pev.origin, true );
	EHandle hHealthBar = HEALTHBAR::SpawnEnvHealthBar( EHandle( pMonster ), "sprites/bm_sts/" + G_SZ_TECHLEVELSPRS[iTechLevel], Vector( 0, 0, 32 ), pSquadMaker.pev.rendercolor, 0.1f, 12078, 1, 1 );

	//const int iAttachmentCount = pMonster.GetAttachmentCount();
	
	//pSprite.SetAttachment( pMonster.edict(), iAttachmentCount );
	
	if( hHealthBar )
		return;

	SetTeamSprite( pMonster, hHealthBar.GetEntity() );
	
	//Set sprite properties here
	//pSprite.pev.scale = 0.15;
	//pSprite.pev.rendermode = 5;
	//pSprite.pev.renderamt = 255;
	//pSprite.pev.rendercolor = pMonster.pev.rendercolor;
	
	//pSprite.TurnOn();
}

void RemoveTeamSprite( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	if( pActivator is null )
		return;
	
	CBaseEntity@ pSprite = GetTeamSprite( pActivator );
	
	if( pSprite !is null )
		g_EntityFuncs.Remove( pSprite );
}

void PrecacheTeamSprite()
{
	HEALTHBAR::RegisterHealthBarEntity();
	g_Game.PrecacheModel( g_szTeamSprite );
	
/* 	g_Game.PrecacheModel( g_szBlueSprite );
	g_Game.PrecacheModel( g_szRedSprite );
	g_Game.PrecacheModel( g_szGreenSprite );
	g_Game.PrecacheModel( g_szYellowSprite ); */

	for( uint i = 0; i < G_SZ_TECHLEVELSPRS.length(); i++ )
	{
		g_Game.PrecacheModel( "sprites/bm_sts/" + G_SZ_TECHLEVELSPRS[i] );
		g_Game.PrecacheGeneric( "sprites/bm_sts/" + G_SZ_TECHLEVELSPRS[i] );
	}
}
