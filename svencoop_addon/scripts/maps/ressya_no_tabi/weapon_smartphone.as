/** 
 * スマートフォン
 */
 
#include "sns_effect"

// 定数
namespace WEP_SMAPHO {
    const string WEP_NAME = "weapon_smartphone";

    enum smartphone_e {
        MOTION_DRAW = 0,
        MOTION_ACTIVE,
        MOTION_DEACTIVE,
        MOTION_TAP1,
        MOTION_TAP2,
        MOTION_CAMDRAW,
        MOTION_CAMTAP,
        MOTION_HOLSTER
    };
    
    // アイコンファイル
    const string SNS_SPRITE     = "sprites/ressya_no_tabi/fukidashi.spr";
    const string SNS_SPRITE_INF = "sprites/ressya_no_tabi/fukidashi_inf.spr";
    const string CAM_SPRITE     = "sprites/ressya_no_tabi/camera.spr";
    
    // サウンドファイル
    const string CAM_SOUND = "weapons/sniper_zoom.wav";
    
    // エンティティ名
    const string ENT_SNS     = "ent_sns";
    const string ENT_SNS_INF = "ent_sns_inf";
    const string ENT_CAM     = "ent_cam";
    
    // 構え方の状態フラグ
    const int STS_HOME   = 0;  // ホーム画面
    const int STS_SNS    = 1;  // SNS画面
    const int STS_CAMERA = 2;  // カメラモード画面
    
    // 範囲内の状態フラグ
    const int RANGESTS_OUT = 0; // 範囲外
    const int RANGESTS_IN  = 1; // 範囲内
    
    // モデル番号
    const int BODY_HOME   = 0; // ホーム画面
    const int BODY_SNS    = 1; // SNS画面
    const int BODY_CAMERA = 2; // カメラモード画面
    
    // 有効範囲
    const float USE_RANGE   = 150.0;
    const float SEACH_RANGE = 1000.0;
}

// スマートフォンメインクラス
class WeaponSmartphone : ScriptBasePlayerWeaponEntity {
    private CBasePlayer@ m_pPlayer = null;
    
    // 状態 0=通常 1=SNS構え 2=カメラモード
    private int status      = WEP_SMAPHO::STS_HOME; 
    private int rangeStatus = WEP_SMAPHO::RANGESTS_OUT;
    
    // 武器モデル
    private string vModel =  "models/ressya_no_tabi/v_smartphone.mdl";
    private string pModel =  "models/ressya_no_tabi/p_smartphone.mdl";
    private string wModel =  "models/ressya_no_tabi/w_smartphone.mdl";
    
    // エンティティアイコン
    private int snsSpriteIdx    = 0;
    private int snsSpriteInfIdx = 0;
    private int camSpriteIdx    = 0;
    
    /** 初期スポーン */
    void Spawn() {
        Precache();
        
        // 初期化情報
        g_EntityFuncs.SetModel(self, self.GetW_Model( this.wModel) );
        self.m_iClip = -1;
        self.FallInit();
    }
    /** プリキャッシュ */
    void Precache() {
        g_Game.PrecacheModel( this.vModel );
        g_Game.PrecacheModel( this.wModel );
        g_Game.PrecacheModel( this.pModel );
        
        this.snsSpriteIdx    = g_Game.PrecacheModel(WEP_SMAPHO::SNS_SPRITE);
        this.snsSpriteInfIdx = g_Game.PrecacheModel(WEP_SMAPHO::SNS_SPRITE_INF);
        this.camSpriteIdx    = g_Game.PrecacheModel(WEP_SMAPHO::CAM_SPRITE);
        
        g_SoundSystem.PrecacheSound(WEP_SMAPHO::CAM_SOUND);
        
        SnsEffect::Precache();
    }

    /** 武器情報 */
    bool GetItemInfo( ItemInfo& out info ) {
        info.iMaxAmmo1        = -1;
        info.iMaxAmmo2        = -1;
        info.iMaxClip         = WEAPON_NOCLIP;
        info.iSlot            = 0;
        info.iPosition        = 5;
        info.iWeight          = 0;
        return true;
    }
    
    /** プレイヤーへ武器追加 */
    bool AddToPlayer( CBasePlayer@ pPlayer ) {
        if ( !BaseClass.AddToPlayer( pPlayer ) ) {
            return false;
        }
        @m_pPlayer = pPlayer;
        return true;
    }

    /** 武器取り出し */
    bool Deploy() {
        this.status      = WEP_SMAPHO::STS_HOME;
        this.rangeStatus = WEP_SMAPHO::RANGESTS_OUT;
        self.m_flTimeWeaponIdle = g_WeaponFuncs.WeaponTimeBase() + 1.0;
        
        return self.DefaultDeploy( self.GetV_Model( this.vModel ),
                                   self.GetP_Model( this.pModel ),
                                   WEP_SMAPHO::MOTION_DRAW, "trip" );
    }

    /** ホルスター */
    void Holster(int skiplocal) {
        this.status      = WEP_SMAPHO::STS_HOME;
        this.rangeStatus = WEP_SMAPHO::RANGESTS_OUT;
        
        self.m_fInReload = false;
        m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 0.5;
        m_pPlayer.pev.viewmodel = "";
        SetThink( null );
    }
    
    /** プライマリアタック */
    void PrimaryAttack() {
        // 通常
        if (this.status == WEP_SMAPHO::STS_HOME) {
            self.SendWeaponAnim( WEP_SMAPHO::MOTION_ACTIVE, 0, WEP_SMAPHO::BODY_SNS );
            m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 0.5; 
            m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 
        
            this.status = WEP_SMAPHO::STS_SNS;
        
        // SNS構え
        } else if (this.status == WEP_SMAPHO::STS_SNS) {
            
            m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 0.5; 
            m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
            
            // 範囲内なら「GOOD!」表示
            if (this.rangeStatus > 0) {
                // 有効なSNSポイントがあるなら、エフェクト
                if (FireTargetNear()) {
                    self.SendWeaponAnim( WEP_SMAPHO::MOTION_TAP1, 0, WEP_SMAPHO::BODY_SNS  );
                    SnsEffect::EffectGood(m_pPlayer);
                }
                
            // 範囲外なので元に戻す
            } else {
                self.SendWeaponAnim( WEP_SMAPHO::MOTION_DEACTIVE, 0, WEP_SMAPHO::BODY_HOME  );
                this.status = WEP_SMAPHO::STS_HOME;
            }
            
        // カメラモード
        } else if (this.status == WEP_SMAPHO::STS_CAMERA) {
            m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 1.0; 
            m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
            self.SendWeaponAnim( WEP_SMAPHO::MOTION_CAMTAP, 0, WEP_SMAPHO::BODY_CAMERA);
            g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, WEP_SMAPHO::CAM_SOUND, 1, ATTN_NORM ); 
            
            DrawIcons();
        }
        
    }
    
    
    /** セカンダリアタック */
    void SecondaryAttack() {
        
        // 通常
        if (this.status == WEP_SMAPHO::STS_HOME) {
            self.SendWeaponAnim( WEP_SMAPHO::MOTION_CAMDRAW, 0, WEP_SMAPHO::BODY_CAMERA );
            m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 0.5; 
            m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 
        
            this.status = WEP_SMAPHO::STS_CAMERA;
            
            
        // SNS構え
        } else if (this.status == WEP_SMAPHO::STS_SNS) {
            
            m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 
            m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 0.5; 
            
            // 範囲内なら「SHIT!」表示
            if (this.rangeStatus > 0) {
                // 有効なSNSポイントがあるなら、エフェクト
                if (FireTargetNear()) {
                    self.SendWeaponAnim( WEP_SMAPHO::MOTION_TAP2, 0, WEP_SMAPHO::BODY_SNS  );
                    SnsEffect::EffectBad(m_pPlayer);
                }
                
            // 範囲なので元に戻す
            } else {
                self.SendWeaponAnim( WEP_SMAPHO::MOTION_DEACTIVE, 0, WEP_SMAPHO::BODY_HOME  );
                this.status = WEP_SMAPHO::STS_HOME;
            }
            
        // カメラモード
        } else if (this.status == WEP_SMAPHO::STS_CAMERA) {
            
            self.SendWeaponAnim( WEP_SMAPHO::MOTION_HOLSTER, 0, WEP_SMAPHO::BODY_HOME );
            m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 0.5; 
            m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 
        
            this.status = WEP_SMAPHO::STS_HOME;
            
        }
        
    }
    
    /** サードアタック */
    void TertiaryAttack() {
        
    }
    
    /** アイドル */
    void WeaponIdle() {
        
        // 構えてて範囲外なら自動的に解除
        if ((this.status == WEP_SMAPHO::STS_SNS) && (this.rangeStatus == WEP_SMAPHO::RANGESTS_OUT)) {
            self.SendWeaponAnim( WEP_SMAPHO::MOTION_DEACTIVE, 0, WEP_SMAPHO::BODY_HOME  );
            this.status = WEP_SMAPHO::STS_HOME;
            m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 0.5; 
            m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
            return;
        }
        
        this.rangeStatus = WEP_SMAPHO::RANGESTS_OUT;
        
        // SNS投稿ポイントを探して更新
        ChackTargetNear();
        
        if (g_WeaponFuncs.WeaponTimeBase() < self.m_flTimeWeaponIdle) {
            return;
        }
        self.m_flTimeWeaponIdle = g_WeaponFuncs.WeaponTimeBase() + 2.0;
    }
    
    // アイコンの描画
    private void DrawIcons() {
        CBaseEntity@ pTarget = null;  
        // 回数制限ありSNS
        while ((@pTarget = g_EntityFuncs.FindEntityByTargetname(pTarget, WEP_SMAPHO::ENT_SNS)) !is null) {
            if ((m_pPlayer.pev.origin - pTarget.pev.origin).Length() <= WEP_SMAPHO::SEACH_RANGE) {
                DrawSnsIcon(pTarget, this.snsSpriteIdx);
            }
        }
        
        // 無限版SNS
        while ((@pTarget = g_EntityFuncs.FindEntityByTargetname(pTarget, WEP_SMAPHO::ENT_SNS_INF)) !is null) {
            if ((m_pPlayer.pev.origin - pTarget.pev.origin).Length() <= WEP_SMAPHO::SEACH_RANGE) {
                DrawSnsIcon(pTarget, this.snsSpriteInfIdx);
            }
        }
        
        // カメラ
        while ((@pTarget = g_EntityFuncs.FindEntityByTargetname(pTarget, WEP_SMAPHO::ENT_CAM)) !is null) {
            if ((m_pPlayer.pev.origin - pTarget.pev.origin).Length() <= WEP_SMAPHO::SEACH_RANGE) {
                DrawSnsIcon(pTarget, this.camSpriteIdx);
            }
            // 範囲内にいるなら、「いいね!」
            if ((m_pPlayer.pev.origin - pTarget.pev.origin).Length() <= WEP_SMAPHO::USE_RANGE) {
                pTarget.Use(m_pPlayer, m_pPlayer, USE_ON);
                SnsEffect::EffectGood(m_pPlayer);
            }
        }
        
        // ついでにプレイヤーの位置を発光
        NetworkMessage ml(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
        ml.WriteByte(TE_DLIGHT);
        ml.WriteCoord(m_pPlayer.pev.origin.x);
        ml.WriteCoord(m_pPlayer.pev.origin.y);
        ml.WriteCoord(m_pPlayer.pev.origin.z);
        ml.WriteByte(16);   // 範囲
        ml.WriteByte(255);  // R
        ml.WriteByte(255);  // G
        ml.WriteByte(255);  // B
        ml.WriteByte(100);  // 消滅時間 x0.1秒
        ml.WriteByte(100);   // 減衰速度
        ml.End();
        
    }
    
    // カメラ位置にアイコン描画
    private void DrawSnsIcon(CBaseEntity@ pEnt, int imgIndex) {
        const uint OFFSET = 20;
        
        /*
        NetworkMessage m(MSG_ONE_UNRELIABLE, NetworkMessages::SVC_TEMPENTITY, m_pPlayer.edict());
        m.WriteByte(TE_PROJECTILE);
        m.WriteCoord(pEnt.pev.origin.x);
        m.WriteCoord(pEnt.pev.origin.y);
        m.WriteCoord(pEnt.pev.origin.z + OFFSET);
        m.WriteCoord(0);                    // X方向速度
        m.WriteCoord(0);                    // Y方向速度
        m.WriteCoord(0);                    // Z方向速度(＋で上)
        m.WriteShort(this.snsSpriteIdx);    // 画像Index
        m.WriteByte(2);                     // 有効時間 x秒
        m.WriteByte(0);                     // 所持者ID
        m.End();
        */
        
        // アイコンの表示
        NetworkMessage m(MSG_ONE_UNRELIABLE, NetworkMessages::SVC_TEMPENTITY, m_pPlayer.edict());
        m.WriteByte(TE_GLOWSPRITE);
        m.WriteCoord(pEnt.pev.origin.x);
        m.WriteCoord(pEnt.pev.origin.y);
        m.WriteCoord(pEnt.pev.origin.z + OFFSET);
        m.WriteShort(imgIndex);
        m.WriteByte(20);                // 有効時間 x0.1秒
        m.WriteByte(15);                // 大きさ   x0.1
        m.WriteByte(255);               // アルファ値
        m.End();
        
    }
    
    // 近くのSNSエンティティをがあれば、ステータス更新
    private void ChackTargetNear() {
        const array<string> itemName = { WEP_SMAPHO::ENT_SNS, WEP_SMAPHO::ENT_SNS_INF };
        
        CBaseEntity@ pTarget = null;
        for (uint i = 0; i < itemName.length(); i++) {
            while ((@pTarget = g_EntityFuncs.FindEntityByTargetname(pTarget, itemName[i])) !is null) {
                // 範囲内なので状態を変更
                if ((m_pPlayer.pev.origin - pTarget.pev.origin).Length() <= WEP_SMAPHO::USE_RANGE) {
                    this.rangeStatus = WEP_SMAPHO::RANGESTS_IN;
                    return;
                }
            }
        }
    }
    
    // 近くのSNSエンティティをUSEする (戻り値:存在したか)
    private bool FireTargetNear() {
        const array<string> itemName = { WEP_SMAPHO::ENT_SNS, WEP_SMAPHO::ENT_SNS_INF };
        
        CBaseEntity@ pTarget = null;
        
        for (uint i = 0; i < itemName.length(); i++) {
            while ((@pTarget = g_EntityFuncs.FindEntityByTargetname(pTarget, itemName[i])) !is null) {
                // 範囲内なので状態を変更
                if ((m_pPlayer.pev.origin - pTarget.pev.origin).Length() <= WEP_SMAPHO::USE_RANGE) {
                    pTarget.Use(m_pPlayer, m_pPlayer, USE_ON);
                    return true;
                }
            }
        }
        return false;
    }
    
}

// 登録用関数
void RegisterSmartPhone() {
    g_CustomEntityFuncs.RegisterCustomEntity( "WeaponSmartphone", WEP_SMAPHO::WEP_NAME); // クラス名, 定義名
    g_ItemRegistry.RegisterWeapon( WEP_SMAPHO::WEP_NAME, "ressya_no_tabi" );
}
