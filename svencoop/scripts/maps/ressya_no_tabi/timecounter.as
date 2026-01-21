/**
 * タイマー処理
 */

/** タイマー開始(マップトリガー用) */
void EntCallTimeStart3min(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
    TimeCounter::StartTimer(180);
}

/** タイマー開始(マップトリガー用) */
void EntCallTimeStart1min(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
    TimeCounter::StartTimer(60);
}

/** タイマー管理 */
namespace TimeCounter {
    const float INTERVAL = 0.1;
    const int TXTCHANNEL = 3;
    
    float countValue  = 0;
    float startTime = 0;
    
    CScheduledFunction@ schTimer = null;
    
        
    // 時刻計算
    float CalcLeftTime() {
        float ret = countValue - (g_Engine.time - startTime);
        return (ret < 0) ? 0 : ret;
    }
    
    // タイマー開始
    void StartTimer(float val) {
        countValue = val;
        startTime = g_Engine.time;
        Init(null);
        
        CloseTimer();
        @schTimer = g_Scheduler.SetInterval( "Update", INTERVAL, g_Scheduler.REPEAT_INFINITE_TIMES );
    }
    
    // タイマー削除
    void CloseTimer() {
        if (schTimer !is null) {
            g_Scheduler.RemoveTimer(schTimer);
        }
    }
    
    // 初期化処理
    void Init( CBasePlayer@ pPlayer ) {
        if (CalcLeftTime() > 0) {
            HUDNumDisplayParams params;
            params.channel = TXTCHANNEL;
            params.flags = HUD_TIME_MINUTES | HUD_TIME_SECONDS | HUD_TIME_COUNT_DOWN | HUD_ELEM_DEFAULT_ALPHA;
            params.value = CalcLeftTime();
            params.x = 0.42;
            params.y = 0.90;
            params.color1 = RGBA_SVENCOOP;
            params.spritename = "stopwatch";
            g_PlayerFuncs.HudTimeDisplay( pPlayer, params );
        }
    }
    
    // 定期実行用処理
    void Update() {
        // タイマー終了時
        if (CalcLeftTime() <= 0) {
            g_PlayerFuncs.HudToggleElement( null, TXTCHANNEL, false );
            CloseTimer();
            
            // エンティティの発動
            //g_EntityFuncs.FireTargets("mm_timeup" , null, null, USE_ON );
        }
    }

    
}