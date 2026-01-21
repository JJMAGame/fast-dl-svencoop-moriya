/**
 * SNSエフェクト管理共通
 */

    
/** GOOD(マップトリガー用) */
void EntCallGood(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
    CBasePlayer@ pPlayer = cast<CBasePlayer>(pActivator);
    SnsEffect::EffectGood(pPlayer);
}

/** BAD(マップトリガー用) */
void EntCallBad(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue) {
    CBasePlayer@ pPlayer = cast<CBasePlayer>(pActivator);
    SnsEffect::EffectBad(pPlayer);
}

/** GOOD、BADエフェクト */
namespace SnsEffect {
    
    // リソースファイル
    const string SPRITE_SNS_GOOD = "sprites/ressya_no_tabi/goodplus1.spr";
    const string SPRITE_SNS_BAD  = "sprites/ressya_no_tabi/badplus1.spr";
    const string SOUND_SNS_GOOD  = "buttons/blip1.wav";
    const string SOUND_SNS_BAD   = "ressya_no_tabi/puu3.wav";    
    
    // カウンタ用エンティティ
    const string ENT_CNT_GOOD = "cnt_sns_good";
    const string ENT_CNT_BAD  = "cnt_sns_bad";
    
    // プリキャッシュ
    void Precache() {
        g_Game.PrecacheGeneric("sound/" + SOUND_SNS_GOOD);
        g_SoundSystem.PrecacheSound(SOUND_SNS_GOOD);
        g_Game.PrecacheGeneric("sound/" + SOUND_SNS_BAD);
        g_SoundSystem.PrecacheSound(SOUND_SNS_BAD);
        
        g_Game.PrecacheModel(SPRITE_SNS_GOOD);
        g_Game.PrecacheModel(SPRITE_SNS_BAD);
    }
    
    // GOOD評価エフェクト
    void EffectGood (CBasePlayer@ pPlayer) {
        PlaySnsEffect(SPRITE_SNS_GOOD, SOUND_SNS_GOOD, pPlayer);
        FireTrigger(ENT_CNT_GOOD); 
    }
    
    // BAD評価エフェクト
    void EffectBad (CBasePlayer@ pPlayer) {
        PlaySnsEffect(SPRITE_SNS_BAD, SOUND_SNS_BAD, pPlayer);
        FireTrigger(ENT_CNT_BAD); 
    }
    
    // エンティティカウンター
    void FireTrigger(string cntEnt) {
        CBaseEntity@ pTarget = null;
        while ((@pTarget = g_EntityFuncs.FindEntityByTargetname(pTarget, cntEnt)) !is null) {
            pTarget.Use(null, null, USE_ON);
            return;
        }
    }

    // アイコンの表示＆再生
    void PlaySnsEffect(string sprPath, string sndPath, CBasePlayer@ pPlayer) {
        if ((pPlayer is null) || (!pPlayer.IsConnected())) {
            return;
        }
        
        const int OFFSET = 45;
        const int SPEED  = 35;
        
        // 頭上へ画像表示        
        NetworkMessage m(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY);
        m.WriteByte(TE_PROJECTILE);
        m.WriteCoord(pPlayer.pev.origin.x);
        m.WriteCoord(pPlayer.pev.origin.y);
        m.WriteCoord(pPlayer.pev.origin.z + OFFSET);
        m.WriteCoord(0);
        m.WriteCoord(0);
        m.WriteCoord(SPEED);
        m.WriteShort(g_EngineFuncs.ModelIndex(sprPath));
        m.WriteByte(2); // 有効時間 x秒
        m.WriteByte(0); // 所持者ID
        m.End();
        
        // １文字再生
        g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_AUTO, sndPath, 1.0f, ATTN_NONE, 0, 100);
    }

    
}