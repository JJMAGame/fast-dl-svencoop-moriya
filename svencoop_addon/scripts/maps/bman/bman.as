#include "func_bomb"
#include "powerups"

/* Bomberman Battles map script
By Meryilla


*/

//Models
const string g_szBombModel1 = "models/bman/bomb_small_b.mdl"; //0.8
const string g_szBombModel2 = "models/bman/bomb_med_b.mdl";  //1.0
const string g_szBombModel3 = "models/bman/bomb_large_b.mdl";  //1.3
const string g_szAntiDelayBombModel = "models/bman/bomb_antidelay_a.mdl";
const string g_szBronzeBombModel = "models/bman/bomb_bronze_a.mdl";
const string g_szSilverBombModel = "models/bman/bomb_silver_a.mdl";
const string g_szGoldBombModel = "models/bman/bomb_gold_a.mdl";
const string g_szPowerupModel = "models/bman/bman_powerup_a.mdl";
const string g_szBombGibModel = "models/metalplategibs_dark.mdl";
const string g_szNukeBombModel = "models/bman/bomb_golem_a.mdl";
const string g_szPenBombModel1 = "models/bman/bomb_pen_small_a.mdl";
const string g_szPenBombModel2 = "models/bman/bomb_pen_med_a.mdl";
const string g_szPenBombModel3 = "models/bman/bomb_pen_large_a.mdl";
const string g_szRemoteBombModel1 = "models/bman/bomb_remote_small_a.mdl";
const string g_szRemoteBombModel2 = "models/bman/bomb_remote_med_a.mdl";
const string g_szRemoteBombModel3 = "models/bman/bomb_remote_large_a.mdl";
//Player Models
const string g_szWhitePlayerModel = "models/player/bman_white/bman_white.mdl";
const string g_szPinkPlayerModel = "models/player/bman_pink/bman_pink.mdl";
const string g_szBlackPlayerModel = "models/player/bman_black/bman_black.mdl";
//Sounds
const string g_szScreamSound = "bman/aaaa.wav";
//Sprites
const string g_szExplosionSprite = "sprites/rc/rc_explosion2HD.spr";

//Variables
const int g_iExplodeDamage = 50;
const bool blAntiCancerEnabled = true; //If enabled, players that are using annoying player models will be force changed to use helmet
bool blClassicCamEnabled = false;  //If enabled, sets camera to top-down view like in original bomberman. Very laggy with 150+ ping.
int g_iActivePlayerCount = 0;
array<float> g_flPlayerScores;
array<float> g_flSortedPlayerScores;
EHandle g_hThirdPlayer, g_hSecondPlayer, g_hFirstPlayer;

array<string> 	DeathSoundEvents = {
				"weapons/explode3.wav",
				"weapons/explode4.wav",
				"weapons/explode5.wav"
};

array<string> 	CrateDeathSoundEvents = {
				"debris/bustcrate1.wav",
				"debris/bustcrate2.wav",
				"debris/bustcrate3.wav"
};

array<string> AllSounds = {
	"weapons/explode3.wav"
	"weapons/explode4.wav",
	"weapons/explode5.wav",
	"bman/item_get.mp3",
	"bman/skull.mp3",
	"bman/kick.mp3",
	g_szScreamSound,
	"debris/bustcrate1.wav",
	"debris/bustcrate2.wav",
	"debris/bustcrate3.wav",
	"bman/timer.ogg",
	"bman/bounce.mp3"
};

//Add substrings to the array below for the anti-cancer system to prevent players using models containing said substring
array<string>	CancerModels = {

	"shit", "invisible", "meatwall", "garg", "snarkgarg", "fockewulftriebflugel", "mbt", "apachef"

};

//CVars
CCVar cvarAltBombSolidLogic( "altbombsolidlogic", 0, "Enable alternative bomb solid logic", ConCommandFlag::AdminOnly ); //Bombs become solid the moment the owner leaves the tile

void MapInit()
{
	g_Hooks.RegisterHook( Hooks::Player::PlayerUse, PlantBomb );
	g_Hooks.RegisterHook( Hooks::Player::ClientPutInServer, SetPlayerValues );
	g_Hooks.RegisterHook( Hooks::Player::PlayerSpawn, PlayerSpawn );
	g_Hooks.RegisterHook( Hooks::Player::PlayerTakeDamage, TakeDamage );
	g_Hooks.RegisterHook( Hooks::Player::PlayerPostThink, PlayerThink );
	g_Hooks.RegisterHook( Hooks::Player::PlayerKilled, PlayerKilled );
	g_Hooks.RegisterHook( Hooks::Player::ClientDisconnect, PlayerDisconnected );
	g_Hooks.RegisterHook( Hooks::Player::ClientSay, ChatCheck );

	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncBomb", "func_bomb" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CFuncCrate", "func_crate" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CPowerupBomb", "func_powerup_bomb" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CPowerupLife", "func_powerup_life" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CPowerupFire", "func_powerup_fire" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CPowerupSkate", "func_powerup_skate" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CPowerupSkull", "func_powerup_skull" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CPowerupKick", "func_powerup_kick" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CPowerupFullFire", "func_powerup_fullfire" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CPowerupPierce", "func_powerup_pierce" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CPowerupBounce", "func_powerup_bounce" );
	g_CustomEntityFuncs.RegisterCustomEntity( "CPowerupRemote", "func_powerup_remote" );

	g_flPlayerScores.resize( 0 );
	g_flPlayerScores.resize( 33 );

	g_flSortedPlayerScores.resize( 0 );
	g_flSortedPlayerScores.resize( 33 );

	Precache();

	if( blAntiCancerEnabled )
		g_Scheduler.SetInterval( "AntiCancerDetection", 1.0f, g_Scheduler.REPEAT_INFINITE_TIMES );
}

HookReturnCode ChatCheck( SayParameters@ pParams )
{
	CBasePlayer@ pPlayer = pParams.GetPlayer();
	const CCommand@ pArguments = pParams.GetArguments();
	CustomKeyvalues@ kvPlayer = pPlayer.GetCustomKeyvalues();

	if( pPlayer is null )
		return HOOK_CONTINUE;

	//if( pArguments[ 0 ] == ".debug" )
	//{
	//	pParams.ShouldHide = true;
	//	//debug code here
	//	CBaseEntity@ pMM = g_EntityFuncs.FindEntityByTargetname( null, "round_setup_mm" );
	//	pMM.KeyValue( "condition_active_players", "10#0" );
	//}
	return HOOK_CONTINUE;
}

void CreateCamera( EHandle hPlayer )
{
	if( !hPlayer )
		return;

	CBasePlayer@ pPlayer = cast<CBasePlayer@>( hPlayer.GetEntity() );

	int iEntityIndex = pPlayer.entindex();

	dictionary cameraValues =
	{
		{ "origin", "" + ( pPlayer.pev.origin + Vector( 0, 0, 400 ) ).ToString() },
		{ "wait", "5" },
		{ "angles", Vector( 90, -90, 0 ).ToString() },
		{ "spawnflags", string( 512 ) },
		{ "targetname", "camera_PID_" + iEntityIndex }
	};

	CBaseEntity@ pCamera = g_EntityFuncs.CreateEntity( "trigger_camera", cameraValues );
	pCamera.Use( pPlayer, pPlayer, USE_ON, 0 );

}

void EnableClassicCam( CBaseEntity@, CBaseEntity@, USE_TYPE, float flValue )
{
	blClassicCamEnabled = true;
}

void Precache()
{
	//Models
	g_Game.PrecacheModel( g_szBombModel1 );
	g_Game.PrecacheModel( g_szBombModel2 );
	g_Game.PrecacheModel( g_szBombModel3 );
	g_Game.PrecacheModel( g_szBronzeBombModel );
	g_Game.PrecacheModel( g_szSilverBombModel );
	g_Game.PrecacheModel( g_szGoldBombModel );
	g_Game.PrecacheModel( g_szAntiDelayBombModel );
	g_Game.PrecacheModel( g_szPowerupModel );
	g_Game.PrecacheModel( g_szBombGibModel );
	g_Game.PrecacheModel( g_szNukeBombModel );
	g_Game.PrecacheModel( g_szPenBombModel1 );
	g_Game.PrecacheModel( g_szPenBombModel2 );
	g_Game.PrecacheModel( g_szPenBombModel3 );
	g_Game.PrecacheModel( g_szRemoteBombModel1 );
	g_Game.PrecacheModel( g_szRemoteBombModel2 );
	g_Game.PrecacheModel( g_szRemoteBombModel3 );
	g_Game.PrecacheModel( "models/woodgibs.mdl" );
	//Player models
	g_Game.PrecacheModel( g_szWhitePlayerModel );
	g_Game.PrecacheModel( g_szPinkPlayerModel );
	g_Game.PrecacheModel( g_szBlackPlayerModel );
	//Sprites
	g_Game.PrecacheModel( g_szExplosionSprite );
	g_Game.PrecacheModel( "sprites/poison.spr" );
	g_Game.PrecacheModel( "sprites/bman/bonus_life.spr" );
	g_Game.PrecacheModel( "sprites/bman/bonus_bomb2.spr" );
	g_Game.PrecacheModel( "sprites/bman/bonus_bomb3.spr" );
	g_Game.PrecacheModel( "sprites/bman/bonus_bomb4.spr" );
	g_Game.PrecacheModel( "sprites/bman/bonus_bomb5.spr" );
	g_Game.PrecacheModel( "sprites/bman/bonus_bomb6.spr" );
	g_Game.PrecacheModel( "sprites/bman/timer.spr" );
	//Sounds
	for( uint i = 0; i < AllSounds.length(); i++ )
	{
		g_SoundSystem.PrecacheSound( AllSounds[i] );
		g_Game.PrecacheGeneric( "sound/" + AllSounds[i] );
	}
}

HookReturnCode PlayerKilled( CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib )
{
	CustomKeyvalues@ kvPlayer = pPlayer.GetCustomKeyvalues();
	if( kvPlayer !is null )
	{
		if( kvPlayer.GetKeyvalue( "$i_activePlayer" ).GetInteger() == 1 )
		{
			//Figure out if the player was one of the last 3 survivors at death
			if( g_iActivePlayerCount == 3 )
				g_hThirdPlayer = EHandle( pPlayer );
			else if( g_iActivePlayerCount == 2 )
				g_hSecondPlayer = EHandle( pPlayer );
			else if( g_iActivePlayerCount == 1 )
				g_hFirstPlayer = EHandle ( pPlayer );

			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_activePlayer", "0" );
			g_iActivePlayerCount--;
		}
		if( kvPlayer.GetKeyvalue( "$i_poisoned" ).GetInteger() == 1 )
			ClearPoison( pPlayer );
	}


	CBaseEntity@ pEntity = g_EntityFuncs.FindEntityByTargetname( pEntity, "camera_PID_" + pPlayer.entindex() );
	if( pEntity !is null )
	{
		g_EntityFuncs.Remove( pEntity );
	}

	return HOOK_CONTINUE;
}

HookReturnCode PlayerDisconnected( CBasePlayer@ pPlayer )
{
	pPlayer.pev.frags = 0;
	int iPlayerIndex = pPlayer.entindex();
	g_flPlayerScores[iPlayerIndex] = 0;

	CustomKeyvalues@ kvPlayer = pPlayer.GetCustomKeyvalues();
	if( kvPlayer !is null || kvPlayer.HasKeyvalue( "$i_activePlayer" ) )
	{
		if( kvPlayer.GetKeyvalue( "$i_activePlayer" ).GetInteger() == 1 )
		{
			g_iActivePlayerCount--;
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode PlayerThink( CBasePlayer@ pPlayer )
{
	if( pPlayer is null )
		return HOOK_CONTINUE;

	CustomKeyvalues@ kvPlayer = pPlayer.GetCustomKeyvalues();

	if( kvPlayer !is null and kvPlayer.GetKeyvalue( "$i_poisonType" ).GetInteger() == 4 )
	{
		CreateBomb( pPlayer, false );
		CBaseEntity@ pSound = g_EntityFuncs.FindEntityByTargetname( pSound, "" + pPlayer.pev.targetname + "_scream" );
		if( pSound !is null )
			pSound.SetOrigin( pPlayer.GetOrigin() );
	}

	if( kvPlayer.GetKeyvalue( "$i_poisoned" ).GetInteger() == 1 )
	{
		CBaseEntity@ pOther;
		//Transfer poison to players in touch radius
		while( ( @pOther = g_EntityFuncs.FindEntityInSphere( pOther, pPlayer.pev.origin, 40 , "player", "classname" ) ) !is null )
		{
			if( pOther !is null && pOther.IsPlayer() && pOther !is pPlayer)
			{
				CBasePlayer@ pOtherPlayer = cast<CBasePlayer@>( pOther );
				CustomKeyvalues@ kvOtherPlayer = pOtherPlayer.GetCustomKeyvalues();
				if( kvOtherPlayer !is null && ( g_Engine.time > kvOtherPlayer.GetKeyvalue( "$f_recentlyPoisoned" ).GetFloat() ) && kvOtherPlayer.GetKeyvalue( "$i_poisoned" ).GetInteger() == 0 )
				{
					g_EntityFuncs.DispatchKeyValue( pOtherPlayer.edict(), "$i_poisoned", "1" );
					int iPoisonType = kvPlayer.GetKeyvalue( "$i_poisonType" ).GetInteger();
					switch( iPoisonType )
					{
						case 0:
							pOtherPlayer.SetMaxSpeed( 80 );
							g_EntityFuncs.DispatchKeyValue( pOtherPlayer.edict(), "$i_poisonType", string( iPoisonType ) );
							g_EngineFuncs.ClientPrintf( pOtherPlayer, print_center, "TOO SLOW!\n" );
							break;

						case 1:
							pOtherPlayer.SetMaxSpeed( 800 );
							g_EntityFuncs.DispatchKeyValue( pOtherPlayer.edict(), "$i_poisonType", string( iPoisonType ) );
							g_EngineFuncs.ClientPrintf( pOtherPlayer, print_center, "TOO FAST!\n" );
							break;

						case 2:
							g_EntityFuncs.DispatchKeyValue( pOtherPlayer.edict(), "$i_poisonType", string( iPoisonType ) );
							g_EngineFuncs.ClientPrintf( pOtherPlayer, print_center, "CONSTIPATED!\n" );
							break;

						case 3:
							g_EntityFuncs.DispatchKeyValue( pOtherPlayer.edict(), "$i_poisonType", string( iPoisonType ) );
							g_EngineFuncs.ClientPrintf( pOtherPlayer, print_center, "WEAK BOMBS!\n" );
							break;

						case 4:
							CreateScream( pOtherPlayer );
							g_EntityFuncs.DispatchKeyValue( pOtherPlayer.edict(), "$i_poisonType", string( iPoisonType ) );
							g_EngineFuncs.ClientPrintf( pOtherPlayer, print_center, "DIARRHEA!\n" );
							break;
					}
					AttachPoisonSprite( pOtherPlayer );
					ClearPoison( pPlayer );
					g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$f_recentlyPoisoned", string( g_Engine.time + 3.0f ) );
				}
			}
		}
	}
	if( blClassicCamEnabled )
	{
		CBaseEntity@ pCamera = g_EntityFuncs.FindEntityByTargetname( pCamera, "camera_PID_" + pPlayer.entindex() );
		if( pCamera !is null )
			pCamera.pev.origin = pPlayer.pev.origin + Vector( 0, 0, 400 );

		if( kvPlayer.GetKeyvalue( "$i_activePlayer" ).GetInteger() == 1 )
		{
			pPlayer.pev.angles = Vector( 0, -90, 0 );
			//pPlayer.pev.angles.z = 0;
			pPlayer.pev.fixangle = FAM_FORCEVIEWANGLES;
		}
		else
			pPlayer.pev.fixangle = FAM_NOTHING;
	}

	//Place special bombs
	if( ( pPlayer.m_afButtonPressed & IN_RELOAD ) > 0 && kvPlayer.GetKeyvalue( "$i_fullfire" ).GetInteger() > 0 )
	{
		CreateBomb( pPlayer, true );
	}
	else if( ( pPlayer.m_afButtonPressed & IN_RELOAD ) > 0 && kvPlayer.GetKeyvalue( "$i_fullfire" ).GetInteger() == 0 )
	{
		g_EngineFuncs.ClientPrintf( pPlayer, print_center, "You have no special bombs to plant\n" );
	}

	//Detonate remote bombs
	if( ( pPlayer.m_afButtonPressed & IN_ATTACK ) > 0 && atobool( kvPlayer.GetKeyvalue( "$s_remote" ).GetString() ) )
	{
		CBaseEntity@ pBombEntity;
		array<EHandle> hOwnedBombs;
		while( ( @pBombEntity = g_EntityFuncs.FindEntityByClassname( pBombEntity, "func_bomb" ) ) !is null )
		{
			if( pBombEntity is null )
				continue;

			CFuncBomb@ pBomb = cast<CFuncBomb@>( g_EntityFuncs.CastToScriptClass( pBombEntity ) );
			CustomKeyvalues@ kvBomb = pBombEntity.GetCustomKeyvalues();
			if( IsOwner( pBombEntity, pPlayer ) && pBomb.IsRemote() )
				hOwnedBombs.insertLast( pBombEntity );
		}
		for( uint i = 0; i < hOwnedBombs.length(); i++ )
		{
			g_EntityFuncs.DispatchKeyValue( hOwnedBombs[i].GetEntity().edict(), "$i_exploding", "1" );
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode PlayerSpawn( CBasePlayer@ pPlayer )
{
	if( pPlayer is null )
		return HOOK_CONTINUE;

	pPlayer.SetMaxSpeed( 200 );
	pPlayer.pev.fuser4 = 1;

	CBaseEntity@ pEntity = g_EntityFuncs.FindEntityByTargetname( pEntity, "camera_PID_" + pPlayer.entindex() );
	if( pEntity !is null )
	{
		g_EntityFuncs.Remove( pEntity );
	}

	return HOOK_CONTINUE;
}

void RoundSpawn( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CBasePlayer@ pPlayer;
	for( int i = 1; i <= g_Engine.maxClients; i++ )
	{
		@pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
		if( pPlayer is null || !pPlayer.IsConnected() )
			continue;

		g_PlayerFuncs.RespawnPlayer( pPlayer, true, true );
		pPlayer.SetMaxSpeed( 200 );
	}
}

HookReturnCode TakeDamage( DamageInfo@ pDamageInfo )
{
	if( pDamageInfo is null || pDamageInfo.pVictim is null )
		return HOOK_CONTINUE;

	CustomKeyvalues@ kvPlayer = pDamageInfo.pVictim.GetCustomKeyvalues();
	edict_t@ pEdict;
	CBaseEntity@ pEntity;

	if( kvPlayer !is null || kvPlayer.HasKeyvalue( "$s_hasLifeSprite" ) )
	{
		if( kvPlayer.GetKeyvalue( "$s_hasLifeSprite" ).GetString() == "1" )
		{
			for( int pIndex = 0; pIndex < g_Engine.maxEntities; ++pIndex )
			{
				@pEdict = @g_EntityFuncs.IndexEnt( pIndex );
				@pEntity = g_EntityFuncs.Instance( pEdict );

				if( pEntity !is null )
					if( pEntity.pev.targetname == "" + pDamageInfo.pVictim.pev.targetname + "_attachSprite" || pEntity.pev.targetname == "" + pDamageInfo.pVictim.pev.targetname + "_bonusLifeSprite" )
						g_EntityFuncs.Remove( pEntity );
			}
			g_EntityFuncs.DispatchKeyValue( pDamageInfo.pVictim.edict(), "$s_hasLifeSprite", "0" );
			return HOOK_CONTINUE;
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode SetPlayerValues( CBasePlayer@ pPlayer )
{
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_maxBombCount", "1" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_bombCount", "0" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_hasLifeSprite", "0" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_hasBombSprite", "0" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_ownBombStrength", "1" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_poisoned", "0" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_poisonType", "0" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$f_recentlyPoisoned", "0" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_hasPoisonSprite", "0" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_activePlayer", "0" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_canKick", "0" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_fullfire", "1" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_pierce", "false" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_bounce", "false" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_remote", "false" );

	pPlayer.pev.frags = 0;
	int iPlayerIndex = pPlayer.entindex();
	g_flPlayerScores[iPlayerIndex] = 0;
	return HOOK_CONTINUE;
}

void FreezeUnfreeze( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	if( pActivator is null || !pActivator.IsPlayer() )
		return;

	if( ( pActivator.pev.flags & FL_FROZEN ) > 0 )
	{
		pActivator.pev.flags &= ~FL_FROZEN;
	}
	else
	{
		pActivator.pev.flags |= FL_FROZEN;
	}
}

void ClearPlayerKeyValues( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CBaseEntity@ pEntity;
	while( ( @pEntity = g_EntityFuncs.FindEntityByClassname( pEntity, "player" ) ) !is null )
	{
		if( pEntity !is null && pEntity.IsPlayer() )
		{
			CBasePlayer@ pPlayer = cast<CBasePlayer@>( pEntity );
			g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "$i_maxBombCount", "1" );
			g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "$i_bombCount", "0" );
			g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "$s_hasLifeSprite", "0" );
			g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "$s_hasBombSprite", "0" );
			g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "$i_ownBombStrength", "1" );
			g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "$i_poisoned", "0" );
			g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "$i_poisonType", "0" );
			g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "$s_hasPoisonSprite", "0" );
			g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "$i_activePlayer", "0" );
			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_canKick", "0" );
			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_fullfire", "0" );
			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_pierce", "false" );
			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_bounce", "false" );
			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_remote", "false" );
			pPlayer.pev.targetname = "";
			pPlayer.pev.health = 50;
			pPlayer.SetMaxSpeed( 200 );
		}
	}
	g_iActivePlayerCount = 0;
}

HookReturnCode PlantBomb( CBasePlayer@ pPlayer, uint& out uiFlags )
{
	if( ( pPlayer.m_afButtonReleased & IN_USE ) != 0 )
	{
		CustomKeyvalues@ kvPlayer = pPlayer.GetCustomKeyvalues();
		if( !pPlayer.pev.FlagBitSet( FL_ONGROUND ) || pPlayer.pev.FlagBitSet( FL_INWATER ) )
			return HOOK_CONTINUE;

		if( kvPlayer !is null && kvPlayer.GetKeyvalue( "$i_poisonType" ).GetInteger() == 2 )
		{
			g_EngineFuncs.ClientPrintf( pPlayer, print_center, "Cannot place bombs whilst constipated!\n" );
			return HOOK_CONTINUE;
		}
		CreateBomb( pPlayer, false );
	}
	return HOOK_CONTINUE;
}

void AssignPlayerSpawns( CBaseEntity@, CBaseEntity@, USE_TYPE, float flValue )
{
	int iPlayerCount = 1;
	CBasePlayer@ pPlayer;
	bool blCancerModel = false;

	array<int> playerIndices;
	playerIndices.resize(0);
	int iArrayIndex = 0;


	//Construct playerIndices array
	while( ( @pPlayer = cast<CBasePlayer@>( g_EntityFuncs.FindEntityByClassname( pPlayer, "player" ) ) ) !is null )
	{
		if( pPlayer is null || !pPlayer.IsConnected() )
			continue;

		playerIndices.insertAt( iArrayIndex, pPlayer.entindex() );
		iArrayIndex++;
	}

	playerIndices = ShuffleArray( playerIndices );

	//Find 16 players at most to spawn and assign them a spawnpoint each
	for( uint i = 0; i < playerIndices.length(); i++ )
	{
		@pPlayer = g_PlayerFuncs.FindPlayerByIndex( playerIndices[i] );

		if( pPlayer is null || !pPlayer.IsConnected() )
			continue;

		KeyValueBuffer@ pInfo = g_EngineFuncs.GetInfoKeyBuffer( pPlayer.edict() );

		//If Anti-Cancer is enabled, ban players with shitty player models from playing
		if( blAntiCancerEnabled )
		{
			for( uint j = 0; j < CancerModels.length(); j++ )
			{
				if( pInfo.GetValue( "model" ).Find( CancerModels[j], 0 ) != String::INVALID_INDEX )
					blCancerModel = true;
			}

			if( blCancerModel )
			{
				g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "[AntiCancer] " + pPlayer.pev.netname + " was barred from playing for using a cancerous model!\n");
				blCancerModel = false;
			}
			else
			{
				pPlayer.pev.targetname = string( iPlayerCount );
				iPlayerCount++;
				if( iPlayerCount > 16 )
				{
					g_PlayerFuncs.SayText( pPlayer, "[Map] " + "There are >16 players and you were not picked to play, sorry!\n" );
				}
				else
				{
					g_iActivePlayerCount = iPlayerCount - 1;
					g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_activePlayer", "1" );
					if( blClassicCamEnabled )
					{
						CreateCamera( pPlayer );
						pPlayer.pev.angles = Vector( 0, -90, 0 );
						pPlayer.pev.fixangle = FAM_FORCEVIEWANGLES;
					}
				}
			}
		}
		else
		{
			pPlayer.pev.targetname = string( iPlayerCount );
			iPlayerCount++;
			if( iPlayerCount > 16 )
			{
				g_PlayerFuncs.SayText( pPlayer, "[Map] " + "There are >16 players and you were not picked to play, sorry!\n" );
			}
			else
			{
				g_iActivePlayerCount = iPlayerCount - 1;
				g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_activePlayer", "1" );
				if( blClassicCamEnabled )
				{
					CreateCamera( pPlayer );
					pPlayer.pev.angles = Vector( 0, -90, 0 );
					pPlayer.pev.fixangle = FAM_FORCEVIEWANGLES;
				}
			}
		}
	}

	return;
}

array<int> ShuffleArray( array<int> inputArray )
{
	int iRandomIndex, iTemp;
	int iCurrentIndex = inputArray.length() - 1;

	for( iCurrentIndex; iCurrentIndex > 0; iCurrentIndex-- )
	{
		iRandomIndex = Math.RandomLong( 0, iCurrentIndex );
		iTemp = inputArray[iCurrentIndex];
		inputArray[iCurrentIndex] = inputArray[iRandomIndex];
		inputArray[iRandomIndex] = iTemp;
	}

	return inputArray;
}

void UpdateScoresDraw( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CBasePlayer@ pFirstPlayer, pSecondPlayer, pThirdPlayer;

	@pFirstPlayer = cast<CBasePlayer@>( g_hFirstPlayer.GetEntity() );
	@pSecondPlayer = cast<CBasePlayer@>( g_hSecondPlayer.GetEntity() );
	@pThirdPlayer = cast<CBasePlayer@>( g_hThirdPlayer.GetEntity() );

	//We only give 25 points in a draw, to discourage players from playing for a draw instead of going for the win
	if( pFirstPlayer !is null )
		pFirstPlayer.pev.frags += 25;

	if( pSecondPlayer !is null )
		pSecondPlayer.pev.frags += 25;

	if( pThirdPlayer !is null )
		pThirdPlayer.pev.frags += 25;

	SortScores();
}

void UpdateScoresWin( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CBasePlayer@ pSecondPlayer, pThirdPlayer;

	@pSecondPlayer = cast<CBasePlayer@>( g_hSecondPlayer.GetEntity() );
	@pThirdPlayer = cast<CBasePlayer@>( g_hThirdPlayer.GetEntity() );

	if( pSecondPlayer !is null )
		pSecondPlayer.pev.frags += 50;

	if( pThirdPlayer !is null )
		pThirdPlayer.pev.frags += 25;

	SortScores();
}

void SortScores()
{
	int iPlayerIndex;
	CBasePlayer@ pPlayer;
	while( ( @pPlayer = cast<CBasePlayer@>( g_EntityFuncs.FindEntityByClassname( pPlayer, "player" ) ) ) !is null )
	{
		if( pPlayer is null || !pPlayer.IsConnected() )
			continue;

		iPlayerIndex = pPlayer.entindex();
		g_flPlayerScores[iPlayerIndex] = pPlayer.pev.frags;
	}

	g_flSortedPlayerScores = g_flPlayerScores;
	g_flSortedPlayerScores.sortDesc();
}

void SelectWinners( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	CBasePlayer@ pGoldPlayer, pSilverPlayer, pBronzePlayer;
	float flGoldScore, flSilverScore, flBronzeScore;
	bool blGoldFound, blSilverFound, blBronzeFound;
	blGoldFound = blSilverFound = blBronzeFound = false;


	g_flSortedPlayerScores = g_flPlayerScores;
	g_flSortedPlayerScores.sortDesc();

	flGoldScore = g_flSortedPlayerScores[0];
	flSilverScore = g_flSortedPlayerScores[1];
	flBronzeScore = g_flSortedPlayerScores[2];

	for( uint i = 1; i < g_flPlayerScores.length(); i++ )
	{
		if( ( g_flPlayerScores[i] == flGoldScore ) and !blGoldFound )
		{
			@pGoldPlayer = g_PlayerFuncs.FindPlayerByIndex( i );
			blGoldFound = true;
		}
		else if( ( g_flPlayerScores[i] == flSilverScore ) and !blSilverFound )
		{
			@pSilverPlayer = g_PlayerFuncs.FindPlayerByIndex( i );
			blSilverFound = true;
		}
		else if( ( g_flPlayerScores[i] == flBronzeScore ) and !blBronzeFound )
		{
			@pBronzePlayer = g_PlayerFuncs.FindPlayerByIndex( i );
			blBronzeFound = true;
		}
	}

	if( pGoldPlayer !is null )
		pGoldPlayer.pev.targetname = "first";
	if( pSilverPlayer !is null )
		pSilverPlayer.pev.targetname = "second";
	if( pBronzePlayer !is null )
		pBronzePlayer.pev.targetname = "third";
}

void AntiCancerDetection()
{
	int iPlayerCount = 1;
	CBasePlayer@ pPlayer;

	for( int i = 1; i <= g_Engine.maxClients; i++ )
	{
		@pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
		if( pPlayer is null || !pPlayer.IsConnected() )
			continue;

		pPlayer.RemoveAllItems( false );
		KeyValueBuffer@ pInfo = g_EngineFuncs.GetInfoKeyBuffer( pPlayer.edict() );
		for( uint j = 0; j < CancerModels.length(); j++ )
		{
			if( pInfo.GetValue( "model" ).Find( CancerModels[j], 0 ) != String::INVALID_INDEX )
			{
				g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTTALK, "[AntiCancer] This player model is forbidden.\n");
				pPlayer.SetOverriddenPlayerModel( "helmet" );
				break;
			}
		}
	}
}

void CreateBomb( EHandle hPlayer, bool blIsNuke )
{
	CBaseEntity@ pBomb;
	CBaseEntity@ pOtherBomb;
	CBaseEntity@ pTile;
	CBasePlayer@ pPlayer = cast<CBasePlayer@>( hPlayer.GetEntity() );
	CustomKeyvalues@ kvPlayer = pPlayer.GetCustomKeyvalues();

	if( pPlayer is null || !pPlayer.pev.FlagBitSet( FL_ONGROUND ) || pPlayer.pev.FlagBitSet( FL_INWATER ) || pPlayer.pev.FlagBitSet( FL_DUCKING ) || pPlayer.pev.FlagBitSet( FL_FROZEN ) )
		return;

	if( !( kvPlayer is null ) and kvPlayer.HasKeyvalue( "$i_bombCount" ) and kvPlayer.HasKeyvalue( "$i_poisonType" ) )
	{
		if( ( kvPlayer.GetKeyvalue( "$i_bombCount" ).GetInteger() >= kvPlayer.GetKeyvalue( "$i_maxBombCount" ).GetInteger() ) and kvPlayer.GetKeyvalue( "$i_poisonType" ).GetInteger() != 4 )
		{
			g_EngineFuncs.ClientPrintf( pPlayer, print_center, "You can't have more than " + kvPlayer.GetKeyvalue( "$i_maxBombCount" ).GetString() + " bomb(s)\n" );
			return;
		}
	}

	@pOtherBomb = g_EntityFuncs.FindEntityInSphere( null, pPlayer.pev.origin - Vector( 0, 0, 32 ), 28 , "func_bomb", "classname" );
	if( pOtherBomb !is null )
	{
		if( kvPlayer.GetKeyvalue( "$i_poisonType" ).GetInteger() != 4 )
			g_EngineFuncs.ClientPrintf( pPlayer, print_center, "There is already a bomb on this tile\n" );
		return;
	}

	@pTile = g_EntityFuncs.FindEntityInSphere( null, pPlayer.pev.origin - Vector( 0, 0, 32 ), 28 , "info_tile" );
	if( pTile !is null )
	{
		dictionary bombValues =
		{
			{ "origin", "" + ( pTile.pev.origin ).ToString() },
			{ "angles", "" + ( Vector( 0, pPlayer.pev.angles.y, 0 ) ).ToString() },
			{ "$i_ownerIndex", "" + pPlayer.entindex() },
			{ "canPierce", "" + kvPlayer.GetKeyvalue( "$s_pierce" ).GetString() },
			{ "canBounce", "" + kvPlayer.GetKeyvalue( "$s_bounce" ).GetString() },
			{ "$s_isRemote", "" + kvPlayer.GetKeyvalue( "$s_remote" ).GetString() }
		};

		if( kvPlayer.GetKeyvalue( "$i_poisonType" ).GetInteger() == 3 && !blIsNuke )
			bombValues.set( "$i_bombStrength", "1" );
		else if( blIsNuke )
			bombValues.set( "$i_bombStrength", "999" );
		else
			bombValues.set( "$i_bombStrength", "" + kvPlayer.GetKeyvalue( "$i_ownBombStrength" ).GetString() );

		@pBomb = g_EntityFuncs.CreateEntity( "func_bomb", bombValues, true);
		if( blIsNuke )
		{
			g_EntityFuncs.SetModel( pBomb, g_szNukeBombModel );
			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_fullfire", "0" );
		}

		g_EntityFuncs.SetSize( pBomb.pev, Vector( -18, -18, 0 ), Vector( 18, 18, 50 ) );

		pBomb.pev.targetname = "player_bomb_PID" + pPlayer.entindex() + "_EID" + pBomb.entindex();

		if( !( kvPlayer is null ) and kvPlayer.HasKeyvalue( "$i_bombCount" ) )
		{
			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_bombCount", string( kvPlayer.GetKeyvalue( "$i_bombCount" ).GetInteger() + 1 ) );
		}


	}
}

void UnattachBomb( EHandle hPlayer )
{
	if( !hPlayer )
		return;

	CBasePlayer@ pPlayer = cast<CBasePlayer@>( hPlayer.GetEntity() );
	CustomKeyvalues@ kvPlayer = pPlayer.GetCustomKeyvalues();

	if( kvPlayer is null || !kvPlayer.HasKeyvalue( "$i_bombCount" ) )
		return;

	if( kvPlayer.GetKeyvalue( "$i_bombCount" ).GetInteger() == 0 )
		return;
	else
		g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_bombCount", string( kvPlayer.GetKeyvalue( "$i_bombCount" ).GetInteger() - 1 ) );
}

void AttachLifeSprite( EHandle hEntity )
{
	if ( !hEntity )
		return;

	CBasePlayer@ pPlayer = cast<CBasePlayer@>( hEntity.GetEntity() );

	CBaseEntity@ pSprite, pAttach;

	dictionary attachValues =
	{
		{ "origin", "" + pPlayer.pev.origin.ToString() },
		{ "targetname", "" + pPlayer.pev.targetname + "bonusLife_attachSprite" },
		{ "target", "" + pPlayer.pev.targetname + "_bonusLifeSprite" },
		{ "offset", "0 0 64" },
		{ "copypointer", "" + pPlayer.pev.targetname },
		{ "spawnflags", "1011" }
	};

	@pAttach = g_EntityFuncs.CreateEntity( "trigger_setorigin", attachValues, true );

	if( pAttach !is null )
	{
		dictionary sprValues =
		{
			{ "origin", "" + pPlayer.pev.origin.ToString() },
			{ "targetname", "" + pPlayer.pev.targetname + "_bonusLifeSprite" },
			{ "model", "sprites/bman/bonus_life.spr" },
			{ "scale", "0.05" },
			{ "spawnflags", "1" }
		};

		@pSprite = g_EntityFuncs.CreateEntity( "env_sprite", sprValues, true );
		g_EntityFuncs.FireTargets( "" + pPlayer.pev.targetname + "bonusLife_attachSprite", null, null, USE_ON, 0, 0 );

		if( blClassicCamEnabled )
		{
			g_EntityFuncs.DispatchKeyValue( pSprite.edict(), "vp_type", "5" );
			g_EntityFuncs.DispatchKeyValue( pAttach.edict(), "offset", Vector( 0, 20, 64 ).ToString() );
		}

		CustomKeyvalues@ kvPlayer = pPlayer.GetCustomKeyvalues();

		if( kvPlayer !is null )
			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_hasLifeSprite", "1" );
	}
}

void AttachBombSprite( EHandle hEntity )
{
	if ( !hEntity )
		return;

	CBasePlayer@ pPlayer = cast<CBasePlayer@>( hEntity.GetEntity() );
	CustomKeyvalues@ kvPlayer = pPlayer.GetCustomKeyvalues();
	CBaseEntity@ pSprite, pAttach;

	if( kvPlayer !is null )
	{
		if( kvPlayer.HasKeyvalue( "$s_hasBombSprite" ) and kvPlayer.GetKeyvalue( "$s_hasBombSprite" ).GetString() == "1" )
		{
			@pSprite = g_EntityFuncs.FindEntityByTargetname( pSprite, "" + pPlayer.pev.targetname + "_bonusBombSprite" );
			if( pSprite !is null )
			{
				g_EntityFuncs.FireTargets( "" + pPlayer.pev.targetname + "bonusBomb_attachSprite", null, null, USE_OFF, 0, 0 );
				g_EntityFuncs.FireTargets( "" + pPlayer.pev.targetname + "_bonusBombSprite", null, null, USE_OFF, 0, 0 );

				g_EntityFuncs.SetModel( pSprite, "sprites/bman/bonus_bomb" + kvPlayer.GetKeyvalue( "$i_maxBombCount" ).GetString()  + ".spr" );
				g_EntityFuncs.FireTargets( "" + pPlayer.pev.targetname + "_bonusBombSprite", null, null, USE_ON, 0, 0 );
				g_EntityFuncs.FireTargets( "" + pPlayer.pev.targetname + "bonusBomb_attachSprite", null, null, USE_ON, 0, 0 );
			}

			if( blClassicCamEnabled )
			{
				g_EntityFuncs.DispatchKeyValue( pSprite.edict(), "vp_type", "5" );
			}
			return;
		}
	}

	dictionary attachValues =
	{
		{ "origin", "" + pPlayer.pev.origin.ToString() },
		{ "targetname", "" + pPlayer.pev.targetname + "bonusBomb_attachSprite" },
		{ "target", "" + pPlayer.pev.targetname + "_bonusBombSprite" },
		{ "offset", "0 0 48" },
		{ "copypointer", "" + pPlayer.pev.targetname },
		{ "spawnflags", "1011" }
	};

	@pAttach = g_EntityFuncs.CreateEntity( "trigger_setorigin", attachValues, true );

	if( pAttach !is null )
	{
		dictionary sprValues =
		{
			{ "origin", "" + pPlayer.pev.origin.ToString() },
			{ "targetname", "" + pPlayer.pev.targetname + "_bonusBombSprite" },
			{ "model", "sprites/bman/bonus_bomb2.spr" },
			{ "scale", "0.05" },
			{ "spawnflags", "1" }
		};

		@pSprite = g_EntityFuncs.CreateEntity( "env_sprite", sprValues, true );
		g_EntityFuncs.FireTargets( "" + pPlayer.pev.targetname + "bonusBomb_attachSprite", null, null, USE_ON, 0, 0 );

		if( blClassicCamEnabled )
		{
			g_EntityFuncs.DispatchKeyValue( pSprite.edict(), "vp_type", "5" );
			g_EntityFuncs.DispatchKeyValue( pAttach.edict(), "offset", Vector( 20, 0, 64 ).ToString() );
		}

		g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_hasBombSprite", "1" );
	}
}

void AttachPoisonSprite( EHandle hEntity )
{
	if ( !hEntity )
		return;

	CBasePlayer@ pPlayer = cast<CBasePlayer@>( hEntity.GetEntity() );

	CBaseEntity@ pSprite, pAttach;

	dictionary attachValues =
	{
		{ "origin", "" + pPlayer.pev.origin.ToString() },
		{ "targetname", "" + pPlayer.pev.targetname + "poison_attachSprite" },
		{ "target", "" + pPlayer.pev.targetname + "_poisonSprite" },
		{ "offset", "0 0 -16" },
		{ "copypointer", "" + pPlayer.pev.targetname },
		{ "spawnflags", "1011" }
	};

	@pAttach = g_EntityFuncs.CreateEntity( "trigger_setorigin", attachValues, true );

	if( pAttach !is null )
	{
		dictionary sprValues =
		{
			{ "origin", "" + pPlayer.pev.origin.ToString() },
			{ "targetname", "" + pPlayer.pev.targetname + "_poisonSprite" },
			{ "model", "sprites/poison.spr" },
			{ "scale", "1.5" },
			{ "rendermode", "5" },
			{ "vp_type", "1" },
			{ "renderamt", "255" },
			{ "framerate", "5" },
			{ "spawnflags", "1" }
		};

		@pSprite = g_EntityFuncs.CreateEntity( "env_sprite", sprValues, true );
		g_EntityFuncs.FireTargets( "" + pPlayer.pev.targetname + "poison_attachSprite", null, null, USE_ON, 0, 0 );

		if( blClassicCamEnabled )
			g_EntityFuncs.DispatchKeyValue( pSprite.edict(), "vp_type", "5" );

		CustomKeyvalues@ kvPlayer = pPlayer.GetCustomKeyvalues();

		if( kvPlayer !is null )
			g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_hasPoisonSprite", "1" );
	}
}

void ClearSprites( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	edict_t@ pEdict;
	CBaseEntity@ pEntity;

	for( int pIndex = 0; pIndex < g_Engine.maxEntities; ++pIndex )
	{
		@pEdict = @g_EntityFuncs.IndexEnt( pIndex );
		@pEntity = g_EntityFuncs.Instance( pEdict );

		if( pEntity !is null )
		{
			string szTargetname = string( pEntity.pev.targetname );
			if( szTargetname.EndsWith( "_attachSprite" ) || szTargetname.EndsWith( "_bonusLifeSprite" ) || szTargetname.EndsWith( "_bonusBombSprite" ) || szTargetname.EndsWith( "_poisonSprite" ) )
				g_EntityFuncs.Remove( pEntity );
		}
	}

	if( blClassicCamEnabled )
	{
		CBaseEntity@ pCamera;

		while( ( @pCamera = g_EntityFuncs.FindEntityByClassname( pCamera, "trigger_camera" ) ) !is null )
		{
			if( pCamera is null || pCamera.pev.targetname == "podium_cam" )
				continue;

			pCamera.Use( null, null, USE_OFF );
			g_EntityFuncs.Remove( pCamera );
		}
	}

}

void ClearPoison( EHandle hEntity )
{
	if ( !hEntity )
		return;

	CBasePlayer@ pPlayer = cast<CBasePlayer@>( hEntity.GetEntity() );
	StopScream( pPlayer );

	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_poisonType", "0" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$i_poisoned", "0" );
	g_EntityFuncs.DispatchKeyValue( pPlayer.edict(), "$s_hasPoisonSprite", "0" );

	//TODO: Have players return to their previous speed after clearing slow or speed disease, instead of assuming they were at 200 base
	if( pPlayer.GetMaxSpeed() == 80 || pPlayer.GetMaxSpeed() == 800 )
		pPlayer.SetMaxSpeed( 200 );

	CBaseEntity@ pPoisonSprite = g_EntityFuncs.FindEntityByTargetname( pPoisonSprite, "" + pPlayer.pev.targetname + "_poisonSprite" );
	CBaseEntity@ pAttachEntity = g_EntityFuncs.FindEntityByTargetname( pAttachEntity, "" + pPlayer.pev.targetname + "poison_attachSprite" );

	if( pPoisonSprite !is null )
		g_EntityFuncs.Remove( pPoisonSprite );

	if ( pAttachEntity !is null )
		g_EntityFuncs.Remove( pAttachEntity );
}

void CreateScream( EHandle hEntity )
{
	CBasePlayer@ pPlayer = cast<CBasePlayer@>( hEntity.GetEntity() );
	dictionary dummyValues =
	{
		{ "origin", "" + pPlayer.pev.origin.ToString() },
		{ "targetname", "" + pPlayer.pev.targetname + "_scream" }
	};

	CBaseEntity@ pSound = g_EntityFuncs.CreateEntity( "info_target", dummyValues, true );
	//le funny serious sam reference
	g_SoundSystem.EmitSoundDyn( pSound.edict(), CHAN_STATIC, g_szScreamSound, VOL_NORM, ATTN_NORM, 0, PITCH_NORM );
}

void StopScream( EHandle hEntity )
{
	if ( !hEntity )
		return;

	CBasePlayer@ pPlayer = cast<CBasePlayer@>( hEntity.GetEntity() );
	CustomKeyvalues@ kvPlayer = pPlayer.GetCustomKeyvalues();

	if( kvPlayer !is null )
	{
		CBaseEntity@ pSound = g_EntityFuncs.FindEntityByTargetname( pSound, "" + pPlayer.pev.targetname + "_scream" );
		if( pSound !is null )
		{
			g_SoundSystem.StopSound( pSound.edict(), CHAN_STATIC, g_szScreamSound );
			g_EntityFuncs.Remove( pSound );
		}
	}
}

bool IsOwner( EHandle hEntity, EHandle hPlayer )
{
	if ( !hEntity or !hPlayer)
		return false;

	CBaseEntity@ pBomb = cast<CBaseEntity@>( hEntity.GetEntity() );
	CBasePlayer@ pPlayer = cast<CBasePlayer@>( hPlayer.GetEntity() );
	CustomKeyvalues@ kvBomb = pBomb.GetCustomKeyvalues();

	if( kvBomb !is null and kvBomb.GetKeyvalue( "$i_ownerIndex" ).GetInteger() == pPlayer.entindex() )
	{
		return true;
	}
	else
		return false;
}

class CFuncCrate : ScriptBaseEntity
{
	void Spawn()
	{
		g_EntityFuncs.SetModel( self, self.pev.model );

		self.pev.solid = SOLID_BSP;
		//Although crates don't move, they need pushstep move type so they are crushable
		self.pev.movetype = MOVETYPE_PUSHSTEP;
		self.pev.takedamage = DAMAGE_YES;
		self.pev.nextthink = g_Engine.time + 1;

		if( self.pev.health == 0.0f )
			self.pev.health  = g_iExplodeDamage;
	}

	void Killed( entvars_t@ pevAtttacker, int iGibbed )
	{
		g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_STREAM, CrateDeathSoundEvents[Math.RandomLong( 0, 2 )], VOL_NORM, ATTN_NORM, 0, PITCH_NORM );
		te_breakmodel( self.pev.origin + Vector( 0, 0, 64 ), self.pev.maxs - self.pev.mins, Vector( 0, 0, 50 ) );
		SetThink( null );

		ChoosePowerup( self );
		g_EntityFuncs.Remove( self );
	}

	void Think()
	{
		self.pev.nextthink = g_Engine.time + 1;

		CBasePlayer@ pPlayerOverCrate;

		@pPlayerOverCrate = cast<CBasePlayer@>( g_EntityFuncs.FindEntityInSphere( null, self.pev.origin + Vector( 0, 0, 72 ), 18 , "player", "classname" ) );
		if( pPlayerOverCrate !is null and pPlayerOverCrate.IsAlive() )
		{
			g_EntityFuncs.FireTargets( "cheater_mm", pPlayerOverCrate, null, USE_ON, 0, 0 );
		}
	}

	void te_breakmodel(Vector pos, Vector size, Vector velocity,
		uint8 speedNoise=16, string model="models/woodgibs.mdl",
		uint8 count=4, uint8 life=8, uint8 flags=8,
		NetworkMessageDest msgType=MSG_BROADCAST, edict_t@ dest=null)
	{
		NetworkMessage m(msgType, NetworkMessages::SVC_TEMPENTITY, dest);
		m.WriteByte(TE_BREAKMODEL);
		m.WriteCoord(pos.x);
		m.WriteCoord(pos.y);
		m.WriteCoord(pos.z);
		m.WriteCoord(size.x);
		m.WriteCoord(size.y);
		m.WriteCoord(size.z);
		m.WriteCoord(velocity.x);
		m.WriteCoord(velocity.y);
		m.WriteCoord(velocity.z);
		m.WriteByte(speedNoise);
		m.WriteShort(g_EngineFuncs.ModelIndex(model));
		m.WriteByte(count);
		m.WriteByte(life);
		m.WriteByte(flags);
		m.End();
	}
}

void ChoosePowerup( EHandle hCrate )
{
	if( !hCrate )
		return;

	CBaseEntity@ pCrate = cast<CBaseEntity@>( hCrate.GetEntity() );
	string szPowerup;

	if( Math.RandomLong( 1, 4 ) != 4 )
		return;

	dictionary powerupValues =
	{
		{ "origin", "" + ( pCrate.pev.origin ).ToString() }
	};

	int iPowerupChance = Math.RandomLong( 1, 100 );

	//There's got to be a better way than this...
	if( iPowerupChance <= 30 )
		szPowerup = "func_powerup_bomb";
	else if( iPowerupChance <= 50 )
		szPowerup = "func_powerup_fire";
	else if( iPowerupChance <= 60 )
		szPowerup = "func_powerup_skate";
	else if( iPowerupChance <= 67 )
		szPowerup = "func_powerup_life";
	else if( iPowerupChance <= 75 )
		szPowerup = "func_powerup_kick";
	else if( iPowerupChance <= 79 )
		szPowerup = "func_powerup_fullfire";
	else if( iPowerupChance <= 84 )
		szPowerup = "func_powerup_pierce";
	else if( iPowerupChance <= 88 )
		szPowerup = "func_powerup_bounce";
	else if( iPowerupChance <= 92 )
		szPowerup = "func_powerup_remote";
	else
		szPowerup = "func_powerup_skull";

	CBaseEntity@ pPowerup = g_EntityFuncs.CreateEntity( szPowerup, powerupValues, true );
	g_EntityFuncs.SetSize( pPowerup.pev, Vector( -18, -18, 0 ), Vector( 18, 18, 50 ) );
}

//Very important function saar, do not remove
void Timer( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	bool blValid = false;
	CBasePlayer@ pPlayer;
	for( int i = 1; i <= g_Engine.maxClients; i++ )
	{
		@pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
		if( pPlayer is null || !pPlayer.IsConnected() )
			continue;

		if( pPlayer.pev.health > 100 || pPlayer.pev.armorvalue > 100 )
		{
			blValid = true;
			break;
		}
	}

	if( !blValid )
		return;

	CBaseEntity@ pEntity;
	while( ( @pEntity = g_EntityFuncs.FindEntityByClassname( pEntity, "ambient_generic" ) ) !is null )
	{
		if( pEntity !is null )
		{
			pEntity.Use( null, null, USE_OFF );
		}
	}

	CBaseEntity@ pWorld = g_EntityFuncs.Instance(0);
	g_SoundSystem.PlaySound( pWorld.edict(), CHAN_MUSIC, "bman/timer.ogg", 1.0f, ATTN_NONE, 0, 100 );

	RGBA RGBA_STICKER = RGBA( 255, 255, 255, 255 );

	HUDSpriteParams StickerDisplayParams;
	StickerDisplayParams.channel = 0;
	StickerDisplayParams.flags = HUD_ELEM_SCR_CENTER_X | HUD_ELEM_SCR_CENTER_Y | HUD_ELEM_NO_BORDER | HUD_SPR_OPAQUE;
	StickerDisplayParams.x = 0; //X axis position of the sprite on the HUD
	StickerDisplayParams.y = 0; //Y axis position of the sprite on the HUD
	StickerDisplayParams.spritename = "bman/timer.spr";
	StickerDisplayParams.color1 = RGBA_STICKER;
	StickerDisplayParams.color2 = RGBA_STICKER;
	StickerDisplayParams.frame = 0;
	StickerDisplayParams.numframes = 7;
	StickerDisplayParams.framerate = 20;
	StickerDisplayParams.fxTime = 8;
	StickerDisplayParams.holdTime = 127; //How long the sprite is displayed for

	g_PlayerFuncs.HudCustomSprite( null, StickerDisplayParams );
}
