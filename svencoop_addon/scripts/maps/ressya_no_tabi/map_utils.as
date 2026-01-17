/**
 * マップ管理クラス
 */
#include "weapon_baseball"
#include "weapon_dice"
#include "position"
#include "flag"

class MapUtils {
    // スクリプト用初回実行フラグ
    private bool isFiredForScript = false;
    
    // 武器リスト
    private array<string> MAP_WEAPONS = {
        "weapon_medkit",
        "weapon_smartphone",
        "weapon_bokutou",
        "weapon_baseball",
        "weapon_shuriken",
        "weapon_dice",
        "weapon_cupzake"
        //,"weapon_hornetgun" // debug
        
    };
    
    // 初期化処理時処理
    void MapInit() {
        
        if (!isFiredForScript) {            
            // スクリプトエラーでなければ、該当Entityを削除する
            //const array<string> DEL_ENTS = { "wl_errchk" };
            const array<string> DEL_ENTS = { "wl_errchk", "debug_ent" };
            
            CBaseEntity@ pTarget = null;  
            
            for (uint i = 0; i < DEL_ENTS.length(); i++) {
                while ((@pTarget =  g_EntityFuncs.FindEntityByTargetname(pTarget, DEL_ENTS[i])) !is null) {
                    g_EntityFuncs.Remove(pTarget);
                }
            }
            // 大仏イベント用フラグ初期化
            ResetFlags();
            
            // 初期化処理
            InitMoveEnts();
                        
            isFiredForScript = true;
        }
    }
    
    // 定期処理
    void Tick() {
        // プレイヤー毎チェック
        for (int i = 1; i <= g_Engine.maxClients; i++) {
            CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
            if ( (pPlayer !is null) && (pPlayer.IsConnected()) && (pPlayer.IsAlive()) ) {
                WeaponsCheck(pPlayer);
            }
        }
        // 野球ボール制限
        DeletePropEnts(WEP_BASEBALL::AMMO_NAME, WEP_BASEBALL::MAX_CNT);
        
        // さいころ制限
        DeletePropEnts(WEP_DICE::AMMO_NAME, WEP_DICE::MAX_CNT);
    }
    
    // 武器をチェック
    private void WeaponsCheck(CBasePlayer@ pPlayer) {
        
        // プレイヤーの所持武器を調べる
        for (uint i = 0; i < MAX_ITEM_TYPES; i++ ) {
            CBasePlayerItem@ pItem = pPlayer.m_rgpPlayerItems(i);
            if (pItem !is null) {                
                // 武器を所持しているならフラグを立てる
                if (IsInItems(MAP_WEAPONS, pItem.GetClassname())) {
                    pItem.pev.iuser4 = 1;
                    
                // 指定以外の武器を持ってるなら除去
                } else {
                    pPlayer.RemovePlayerItem(pItem);
                }
            }
        }
    }
    
    // 配列にあるか
    private bool IsInItems(array<string> items, string target) {
        for (uint i = 0; i < items.length(); i++) {
            if (items[i] == target) {
                return true;
            }
        }
        return false;
    }
    
    
    // アイテムの出しすぎを削除
    private void DeletePropEnts(string entName, int delCnt) {
        int cnt = 0;
        
        CBaseEntity@ pTarget = null;  
        while ((@pTarget = g_EntityFuncs.FindEntityByClassname(pTarget, entName)) !is null) {
            
            if ((pTarget.pev.iuser4 > 0)) {
                
                // 長時間放置なら消える
                if (g_Engine.time > pTarget.pev.fuser4 ) {
                    g_EntityFuncs.Remove(pTarget);
                    continue;
                }
                
                // 上限超えたら強制削除
                cnt++;
                if (cnt > delCnt) {
                    g_EntityFuncs.Remove(pTarget);
                }
            }
        }
    }
}

