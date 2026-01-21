////////////////////////////////
// ressya_no_tabi メインスクリプト
////////////////////////////////

#include "map_utils"
#include "sns_effect"
#include "timecounter"

#include "weapon_smartphone"
#include "weapon_bokutou"
#include "weapon_baseball"
#include "weapon_shuriken"
#include "weapon_dice"
#include "weapon_cupzake"

// ユーティリティクラス
MapUtils g_utils;

/** マップ初期化時 */
void MapInit() {
    // 共通処理初期化
    SnsEffect::Precache();
    
    // Hook
    g_Hooks.RegisterHook(Hooks::Player::ClientPutInServer, @PlayerJoin);
    g_Hooks.RegisterHook(Hooks::Player::PlayerKilled, @PlayerKilled);
    
    // 武器登録
    RegisterSmartPhone();
    RegisterBokutou();
    RegisterBaseball();
    RegisterShuriken();
    RegisterDice();
    RegisterCupzake();
    
    // 定期タイマー
    g_Scheduler.SetInterval("CheckTimer", 10.0);
    
    g_EngineFuncs.ServerPrint("[ressya_no_tabi] map scripts are working! ....(^^;)b\n");
}

/** 死亡時 */
HookReturnCode PlayerKilled (CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib) {
    SnsEffect::EffectBad(pPlayer);
    return HOOK_CONTINUE;
}

/** プレイヤー参加時 */
HookReturnCode PlayerJoin( CBasePlayer@ pPlayer ) {
    g_utils.MapInit();          // 初期化処理
    TimeCounter::Init(pPlayer); // タイマー表示処理
    
    return HOOK_CONTINUE;
}

// タイマー
void CheckTimer() {
    g_utils.Tick();
}
