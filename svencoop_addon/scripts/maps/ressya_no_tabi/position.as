/**
 * エンティティの位置、移動の管理
 */

namespace ENTPOS {
    // 移動対象エンティティ
    const string ENT_TAKE_NAME = "tnktake";
    const string ENT_ROKURO1_NAME = "rot_tougei1";
    const string ENT_ROKURO2_NAME = "rot_tougei2";
    const string ENT_ROKURO3_NAME = "rot_tougei3";
}

/** 竹鉄砲有効化  (マップトリガー用) */
void EntCallMoveTake(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
    ResetRender(ENTPOS::ENT_TAKE_NAME);
}
/** 陶芸有効化  (マップトリガー用) */
void EntCallEnableRokuro1(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
    ResetRender(ENTPOS::ENT_ROKURO1_NAME);
}
void EntCallEnableRokuro2(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
    ResetRender(ENTPOS::ENT_ROKURO2_NAME);
}
void EntCallEnableRokuro3(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
    ResetRender(ENTPOS::ENT_ROKURO3_NAME);
}

// 初期化時
void InitMoveEnts(){
    ChangeRender(ENTPOS::ENT_TAKE_NAME);
    ChangeRender(ENTPOS::ENT_ROKURO1_NAME);
    ChangeRender(ENTPOS::ENT_ROKURO2_NAME);
    ChangeRender(ENTPOS::ENT_ROKURO3_NAME);
}

// 透明→実体化
void ChangeRender(string entName) {
    CBaseEntity@ pTarget = null;
    @pTarget = g_EntityFuncs.FindEntityByTargetname(pTarget, entName);
    if (pTarget !is null) {
        pTarget.pev.rendermode  = kRenderTransAdd;
        pTarget.pev.renderfx    = kRenderFxNone;
        pTarget.pev.renderamt   = 0;
    }
}

// 実体→透明化
void ResetRender(string entName) {
    CBaseEntity@ pTarget = null;
    @pTarget = g_EntityFuncs.FindEntityByTargetname(pTarget, entName);
    if (pTarget !is null) {
        pTarget.pev.rendermode  = kRenderNormal;
        pTarget.pev.renderfx    = kRenderFxNone;
        pTarget.pev.renderamt   = 0;
    }
}

/** Trigger_multipleのフィルタ版（マップトリガー用） */
void EntCallFilterTriggerMlt(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
    
    // trigger_multiple で呼び出すことで、下記となるらしい
    //  pActivator = trigger_multipleエリアに入ったオブジェクト。箱やプレイヤーなど
    //  pCaller    = trigger_multipleエリアのエンティティ
    
    // objectの名前から、multipleの名前を含むか
    string objEntName = pCaller.pev.targetname;
    objEntName.Replace("mlt_", "psh_");
    
    // エリアに入ったオブジェクトがmultipleの名前にあった場合に発動
    // ex.) psh_***** が mlt_*****XX に入った場合
    string chk = pActivator.pev.targetname;
    if (objEntName.StartsWith(chk)) {
        // オブジェクトを削除
        g_EntityFuncs.Remove(pActivator);
        
        // 「mlt_*****XX」→「cnt_*****XX」に変換
        string tgEntName = pCaller.pev.targetname;
        tgEntName.Replace("mlt_", "cnt_");
        
        // コール先のカウントエンティティ「cnt_*****XX」をコールする。
        g_EntityFuncs.FireTargets(tgEntName, null, null, USE_ON);
    }
}
