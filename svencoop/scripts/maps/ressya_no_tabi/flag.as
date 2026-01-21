/**
 * フラグ管理
 */

namespace MAPFLAGS {
    bool flag1 = false;
    bool flag2 = false;
    bool flag3 = false;
    int status = 0;
}

// フラグ初期化
void ResetFlags() {
    MAPFLAGS::flag1 = false;
    MAPFLAGS::flag2 = false;
    MAPFLAGS::flag3 = false;
    MAPFLAGS::status = 0;
}

/** フラグオン (マップトリガー用) */
void EntCallFlag1Toggle(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
    MAPFLAGS::flag1 = !MAPFLAGS::flag1; 
}
void EntCallFlag2Toggle(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
    MAPFLAGS::flag2 = !MAPFLAGS::flag2;
}
void EntCallFlag3Toggle(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
    MAPFLAGS::flag3 = !MAPFLAGS::flag3;
}

// お寺エリアのイベント
void EntCallDaibutsu(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
    const string ENT_CTG_FWD = "ctg_daibutsu_fwd";
    const string ENT_CTG_BAK = "ctg_daibutsu_bak";
    const string ENT_TR      = "tr_daibutsu";
    const string ENT_FIRST   = "br_daibutsu1st";
    const string ENT_FIN     = "mm_daibutsuend";
    
    const string ENT_LV1     = "spr_daibutsu1";
    const string ENT_LV2     = "spr_daibutsu2";
    const string ENT_LV3     = "spr_daibutsu3";
    const string ENT_LV4     = "spr_daibutsu4";
    const string ENT_LV5     = "spr_daibutsu5";
    const string ENT_LV6     = "spr_daibutsu6";
    const string ENT_LV7     = "spr_daibutsu7";
    
    
    // 最後まで移動したなら何もしない
    if (MAPFLAGS::status >= 7) {
        return;
    }
    
    bool isCorrect = false;
    switch (MAPFLAGS::status) {
        // ○○○
        case 0: isCorrect = (( MAPFLAGS::flag1) && ( MAPFLAGS::flag2) && ( MAPFLAGS::flag3)); break;
        // ○○×
        case 1: isCorrect = (( MAPFLAGS::flag1) && ( MAPFLAGS::flag2) && (!MAPFLAGS::flag3)); break;
        // ×○○
        case 2: isCorrect = ((!MAPFLAGS::flag1) && ( MAPFLAGS::flag2) && ( MAPFLAGS::flag3)); break;
        // ○××
        case 3: isCorrect = (( MAPFLAGS::flag1) && (!MAPFLAGS::flag2) && (!MAPFLAGS::flag3)); break;
        // ×○×
        case 4: isCorrect = ((!MAPFLAGS::flag1) && ( MAPFLAGS::flag2) && (!MAPFLAGS::flag3)); break;
        // ××○
        case 5: isCorrect = ((!MAPFLAGS::flag1) && (!MAPFLAGS::flag2) && ( MAPFLAGS::flag3)); break;
        // ○×○
        case 6: isCorrect = (( MAPFLAGS::flag1) && (!MAPFLAGS::flag2) && ( MAPFLAGS::flag3)); break;
    }

    // 正解なら状態を進める
    if (isCorrect) {
        // 看板に光をつける
        switch (MAPFLAGS::status) {
            case 0: g_EntityFuncs.FireTargets(ENT_LV1, null, null, USE_ON ); break;
            case 1: g_EntityFuncs.FireTargets(ENT_LV2, null, null, USE_ON ); break;
            case 2: g_EntityFuncs.FireTargets(ENT_LV3, null, null, USE_ON ); break;
            case 3: g_EntityFuncs.FireTargets(ENT_LV4, null, null, USE_ON ); break;
            case 4: g_EntityFuncs.FireTargets(ENT_LV5, null, null, USE_ON ); break;
            case 5: g_EntityFuncs.FireTargets(ENT_LV6, null, null, USE_ON ); break;
            case 6: g_EntityFuncs.FireTargets(ENT_LV7, null, null, USE_ON ); break;
        }
        
        MAPFLAGS::status++;
        
        if (MAPFLAGS::status == 1) {
            g_EntityFuncs.FireTargets(ENT_FIRST , null, null, USE_ON );
        }
        
        // 進む方向へPathConerを設置し、進む
        g_EntityFuncs.FireTargets(ENT_CTG_FWD, null, null, USE_ON );
        g_EntityFuncs.FireTargets(ENT_TR , null, null, USE_ON );
        
        // 最後まで移動したら、End処理
        if (MAPFLAGS::status == 7) {
            g_EntityFuncs.FireTargets(ENT_FIN , null, null, USE_ON );
        }
    
    // １段階以上進んでいて不正解
    } else if (MAPFLAGS::status > 0) {
        // 看板の光を消す
        g_EntityFuncs.FireTargets(ENT_LV1, null, null, USE_OFF );
        g_EntityFuncs.FireTargets(ENT_LV2, null, null, USE_OFF );
        g_EntityFuncs.FireTargets(ENT_LV3, null, null, USE_OFF );
        g_EntityFuncs.FireTargets(ENT_LV4, null, null, USE_OFF );
        g_EntityFuncs.FireTargets(ENT_LV5, null, null, USE_OFF );
        g_EntityFuncs.FireTargets(ENT_LV6, null, null, USE_OFF );
        g_EntityFuncs.FireTargets(ENT_LV7, null, null, USE_OFF );
        
        MAPFLAGS::status = 0;

        // 最初へ戻るようにPathConerを設置し(大仏のFirstStepTargetも)、戻る
        g_EntityFuncs.FireTargets(ENT_CTG_BAK , null, null, USE_ON );
        g_EntityFuncs.FireTargets(ENT_TR , null, null, USE_ON );
    }
}

