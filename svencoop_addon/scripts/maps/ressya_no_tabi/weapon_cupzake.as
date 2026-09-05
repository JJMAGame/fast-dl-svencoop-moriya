/* 
 * カップ酒
 */
#include "sns_effect"

namespace WEP_CUPZAKE {
    const int MAX_AMMO  = 100;
    const int HAND_AMMO = 20;
    const string WEP_NAME  = "weapon_cupzake";
    const string AMMO_NAME = "ammo_cupzake";
    
    enum motion_e {
        MOTION_IDLE = 0,
        MOTION_FIDGET1,
        MOTION_FIDGET2,
        MOTION_DOWN,
        MOTION_UP,
        MOTION_FUTAAKE,
        MOTION_FUTASHIME,
        MOTION_DRINK,
        MOTION_KANPAI,
        MOTION_TEWATASHI,
        MOTION_THUMB_UP
    };
    
}
class WeaponCupzake : ScriptBasePlayerWeaponEntity {
    private CBasePlayer@ m_pPlayer = null;
    
    private string vModel      = "models/ressya_no_tabi/v_cupzake.mdl";
    private string pModelClose = "models/ressya_no_tabi/p_cupzake_c.mdl";
    private string pModelOpen  = "models/ressya_no_tabi/p_cupzake_o.mdl";
    private string wModel      = "models/ressya_no_tabi/w_cupzake.mdl";
    
    private string actSoundFile   = "weapons/cbar_miss1.wav";
    private string yellSoundFile  = "tfc/ambience/goal_1.wav";
    private string drinkSoundFile = "player/pl_swim3.wav";
    private string openSoundFile  = "weapons/357_chamberout.wav";
    private string picSoundFile   = "items/gunpickup2.wav";
    private string yaySoundFile   = "tfc/ambience/goal_1.wav";
    
    private int futaStatus = 0;    // 蓋開けたか
    private bool semiFlag = false; // 右クリックのセミオート処理対応
    private int yoiLv = 0;         // 酔いレベル
    
    void Spawn() {
        self.Precache();
        g_EntityFuncs.SetModel( self, self.GetW_Model( this.wModel) );
        //self.m_iDefaultAmmo = 1;
        self.m_iClip = -1;

        self.FallInit();// get ready to fall down.
    }

    void Precache() {
        self.PrecacheCustomModels();

        g_Game.PrecacheModel( this.vModel );
        g_Game.PrecacheModel( this.wModel );
        g_Game.PrecacheModel( this.pModelOpen );
        g_Game.PrecacheModel( this.pModelClose );

        g_SoundSystem.PrecacheSound( this.actSoundFile );
        g_SoundSystem.PrecacheSound( this.yellSoundFile );
        g_SoundSystem.PrecacheSound( this.drinkSoundFile );
        g_SoundSystem.PrecacheSound( this.openSoundFile );
        g_SoundSystem.PrecacheSound( this.picSoundFile );
        g_SoundSystem.PrecacheSound( this.yaySoundFile );
        
        // 投擲用
        SnsEffect::Precache();
    }

    bool GetItemInfo( ItemInfo& out info ) {
        info.iMaxAmmo1      = WEP_CUPZAKE::MAX_AMMO;
        info.iMaxAmmo2      = -1;
        info.iMaxClip       = 0; //WEAPON_NOCLIP;
        info.iSlot          = 3;
        info.iPosition      = 7;
        info.iWeight        = 90;
        info.iFlags         = ITEM_FLAG_LIMITINWORLD | ITEM_FLAG_EXHAUSTIBLE;
        
        return true;
    }
    
    bool AddToPlayer( CBasePlayer@ pPlayer ) {
        if ( !BaseClass.AddToPlayer( pPlayer ) ) {
            return false;
        }
        @m_pPlayer = pPlayer;
        return true;
    }

    /** 武器取り出し時 */
    bool Deploy() {
        this.semiFlag = false;
        this.futaStatus = 0;
        this.yoiLv = 0;
        return self.DefaultDeploy( self.GetV_Model( this.vModel ), self.GetP_Model( this.pModelClose ), WEP_CUPZAKE::MOTION_UP, "trip" );
    }

    /** ホルスター時 */
    void Holster( int skiplocal /* = 0 */ ) {
        self.m_fInReload = false;// cancel any reload in progress.

        m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 0.5; 
        m_pPlayer.pev.viewmodel = "";
        
        // Ammoがなければ削除
        if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 ) {
            
            m_pPlayer.pev.weapons &= ~( 0 << g_ItemRegistry.GetIdForName(WEP_CUPZAKE::WEP_NAME) );
            SetThink( ThinkFunction( DestroyThink ) );
            self.pev.nextthink = g_Engine.time + 0.1;
        } else {
            SetThink( null );
        }
    }
    
    void DestroyThink() {
        self.DestroyItem();
    }
    
    
    /** リロード */
    void Reload() {
        // 蓋閉め状態＝親指UP
        if (this.futaStatus == 0) {
            self.SendWeaponAnim( WEP_CUPZAKE::MOTION_THUMB_UP, 0, this.futaStatus);
        // 蓋開け＝乾杯
        } else {
            self.SendWeaponAnim( WEP_CUPZAKE::MOTION_KANPAI, 0, this.futaStatus);
        }
        m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
        m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 3.0; 
        self.m_flTimeWeaponIdle = g_Engine.time + 3.0; 
        
        g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, this.yaySoundFile, 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );
        
        // ランダムでGOOD
        if (Math.RandomLong( 0, 9 ) == 0) { 
            SnsEffect::EffectGood(m_pPlayer);
        }
    }
    
    /** プライマリ攻撃 */
    void PrimaryAttack() {
        
        // 蓋閉め状態＝手渡し
        if (this.futaStatus == 0) {
            if (m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType ) > WEP_CUPZAKE::HAND_AMMO) {
                GiveOtherAction();
                SetThink(ThinkFunction(this.GiveOtherThink));
                
                m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
                self.pev.nextthink = g_Engine.time + 0.3;
                
                m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 1.0; 
                self.m_flTimeWeaponIdle = g_Engine.time + 1.0; 
            }
        
        // 蓋開け状態＝飲む
        } else {
            if (m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType ) > 0) {
                DrinkAction();
                SetThink(ThinkFunction(this.DrinkThink));
                                
                m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
                self.pev.nextthink = g_Engine.time + 0.2;
                
                m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 1.0; 
                self.m_flTimeWeaponIdle = g_Engine.time + 1.0; 
            }
        }
        
    }
    
    /** セカンダリ攻撃 */
    void SecondaryAttack() {
        // セミオートフラグセット
        if (this.semiFlag) {
            return;
        }
        this.semiFlag = true;
        
        // 蓋開ける
        if (this.futaStatus == 0) {
            this.futaStatus = 1;
            m_pPlayer.pev.weaponmodel = this.pModelOpen;            
            self.SendWeaponAnim(WEP_CUPZAKE::MOTION_FUTAAKE, 0, 0 );
            
            SetThink(ThinkFunction(this.FutaAkeThink));
            self.pev.nextthink = g_Engine.time + 2.0;
        
            m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 2.0; 
            self.m_flTimeWeaponIdle = g_Engine.time + 2.0; 
                
        // 蓋閉める
        } else {
            this.futaStatus = 0;
            m_pPlayer.pev.weaponmodel = this.pModelClose;            
            self.SendWeaponAnim(WEP_CUPZAKE::MOTION_FUTASHIME, 0, this.futaStatus );
             
        }
        m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
                
        g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, this.openSoundFile, 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );
        
        m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 2.0; 
        self.m_flTimeWeaponIdle = g_Engine.time + 2.0;        
    }
    
    // 蓋開けDelay動作
    private void FutaAkeThink() {
        self.SendWeaponAnim(WEP_CUPZAKE::MOTION_IDLE, 0, 1 );
    }
    
    
    // 飲む動作
    private void DrinkAction() {
        self.SendWeaponAnim(WEP_CUPZAKE::MOTION_DRINK, 0, this.futaStatus  );
        
        m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
        self.pev.nextthink = g_Engine.time + 0.3;
        
        g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, this.actSoundFile, 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );
        
        m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 1.0; 
        self.m_flTimeWeaponIdle = g_Engine.time + 1.0; 
    }
    
    // 飲む処理（ディレイ）
    private void DrinkThink() {
        
        g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, this.drinkSoundFile, 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );
        
        float amp = 10.0 + 10.0 * yoiLv;
        float frq = 10.0 + 10.0 * yoiLv;
        float tim = 10.0 + 10.0 * yoiLv;
        int   rad = 10 + 10 * yoiLv;
        
        // 揺れ （位置、振幅、周波数、長さ、範囲）        
        g_PlayerFuncs.ScreenShake(m_pPlayer.pev.origin, amp, frq, 10.0, 1.0);
                
        // 画面色
        NetworkMessage m( MSG_ONE, NetworkMessages::SVC_TEMPENTITY, m_pPlayer.edict() );
        m.WriteByte( TE_DLIGHT );
        m.WriteCoord( m_pPlayer.pev.origin.x );
        m.WriteCoord( m_pPlayer.pev.origin.y );
        m.WriteCoord( m_pPlayer.pev.origin.z );
        m.WriteByte( rad );
        m.WriteByte( 255 );
        m.WriteByte( 240 );
        m.WriteByte( 192 );
        m.WriteByte( 70 );
        m.WriteByte( 30 );
        m.End();
        
        ConsumeAmmo(1);
        
        // 酔い加算
        yoiLv++;
        yoiLv = (yoiLv > 10) ? 10 : yoiLv;
                
        // ランダムでGOOD
        if ((yoiLv == 10) && (Math.RandomLong( 0, 4 ) == 0)) { 
            SnsEffect::EffectGood(m_pPlayer);
        }
    }
    
    
    // 手渡し動作
    private void GiveOtherAction() {
        self.SendWeaponAnim(WEP_CUPZAKE::MOTION_TEWATASHI, 0, this.futaStatus  );
        
        m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
        self.pev.nextthink = g_Engine.time + 0.5;
        
        g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, this.actSoundFile, 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );
        
        m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 1.0; 
        self.m_flTimeWeaponIdle = g_Engine.time + 1.0; 
    }
    
    // 手渡し処理（ディレイ）
    private void GiveOtherThink() {
        
        // 攻撃判定
        TraceResult tr;
        Math.MakeVectors( m_pPlayer.pev.v_angle );
        Vector vecSrc = m_pPlayer.GetGunPosition();
        Vector vecEnd = vecSrc + g_Engine.v_forward * 48;
        g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr );

        if ( tr.flFraction >= 1.0 ) {
            g_Utility.TraceHull( vecSrc, vecEnd, dont_ignore_monsters, head_hull, m_pPlayer.edict(), tr );
            if ( tr.flFraction < 1.0 ) {
                // 交点の計算。FindHullIntersectionでより正確になるらしい。
                CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );
                if ((pHit is null) || (pHit.IsBSPModel()) ) {
                    g_Utility.FindHullIntersection( vecSrc, tr, tr, VEC_DUCK_HULL_MIN, VEC_DUCK_HULL_MAX, m_pPlayer.edict() );
                }
                vecEnd = tr.vecEndPos;
            }
        }
        
        // プレイヤーに対してヒットした場合        
        CBaseEntity@ pEntity = g_EntityFuncs.Instance( tr.pHit );
        if ( tr.flFraction < 1.0 ) {
            if (pEntity.Classify() == CLASS_PLAYER) {
                AddWeaponToPlayer(pEntity);
            }
        }
        
        g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_WEAPON, this.actSoundFile, 1, ATTN_NORM, 0, PITCH_NORM);
    }
    
    // 手渡し処理後取り出し
    private void GiveAfterThink() {
        m_pPlayer.pev.weaponmodel = this.pModelClose;
        m_pPlayer.SetAnimation( PLAYER_DEPLOY);
        self.SendWeaponAnim( WEP_CUPZAKE::MOTION_UP, 0, 0);
    }
    
    // プレイヤーへアイテム追加
    private void AddWeaponToPlayer(CBaseEntity@ pEnt ) {
        CBasePlayer@ pPlayer = cast<CBasePlayer>(pEnt);
        
        // Ammoがいっぱいなら乾杯動作でなにもしない
        if (pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType ) >= WEP_CUPZAKE::MAX_AMMO) {
            self.SendWeaponAnim( WEP_CUPZAKE::MOTION_THUMB_UP, 0, 0);
            return;
        }
        
        // 渡した人のモデル表示
        m_pPlayer.pev.weaponmodel = "";
        SetThink(ThinkFunction(this.GiveAfterThink));
        self.pev.nextthink = g_Engine.time + 0.3;
        
        // 武器持ってないなら追加
        pEnt.GiveAmmo(WEP_CUPZAKE::HAND_AMMO, WEP_CUPZAKE::AMMO_NAME, WEP_CUPZAKE::MAX_AMMO );
        if (pPlayer.HasNamedPlayerItem(WEP_CUPZAKE::WEP_NAME) is null) {
            pPlayer.GiveNamedItem(WEP_CUPZAKE::WEP_NAME, 0, 0);
        }
        
        ConsumeAmmo(WEP_CUPZAKE::HAND_AMMO);
        
        // 強制的に武器を優先
        CBasePlayerItem@ pItem = pPlayer.HasNamedPlayerItem(WEP_CUPZAKE::WEP_NAME);
        if (pItem !is null) {
            pPlayer.SwitchWeapon(pItem);
        }
        g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, this.picSoundFile, 1, ATTN_NORM );
    }
    
    
    
    // 弾消費
    private void ConsumeAmmo(const int num) {
        int ammoCnt = m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType );
        
        ammoCnt = (ammoCnt - num < 0) ? 0 : ammoCnt - num;
        m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, ammoCnt);
    }
    
    
    /** アイドル時 */
    void WeaponIdle() {
        self.ResetEmptySound();
       
        // セミオート処理。ボタンを離したら解除
        if ( !(( m_pPlayer.pev.button & IN_ATTACK2 ) != 0) ) {
            semiFlag = false;
        }
        
        // Ammoなければ削除
        if (m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType ) <= 0) {
            m_pPlayer.pev.weapons &= ~( 0 << g_ItemRegistry.GetIdForName(WEP_CUPZAKE::WEP_NAME) );
            SetThink( ThinkFunction( DestroyThink ) );
            self.pev.nextthink = g_Engine.time + 0.1;
            return;
        }

        if( self.m_flTimeWeaponIdle  > g_Engine.time) {
            return;
        }
        
        // 酔いクールダウン
        yoiLv--;
        yoiLv = (yoiLv < 0) ? 0 : yoiLv;
        
        // 次のを取り出すモーション
        //m_pPlayer.pev.weaponmodel = this.pModelClose;
        m_pPlayer.SetAnimation( PLAYER_DEPLOY);
        
        int anim = Math.RandomLong( WEP_CUPZAKE::MOTION_IDLE,  WEP_CUPZAKE::MOTION_FIDGET2 );
        self.SendWeaponAnim( anim , 0, this.futaStatus);

        self.m_flTimeWeaponIdle = g_Engine.time + Math.RandomFloat(10.0, 15.0);
    }
    
}

// 登録
void RegisterCupzake() {
    g_CustomEntityFuncs.RegisterCustomEntity( "WeaponCupzake", WEP_CUPZAKE::WEP_NAME ); // クラス名, 定義名
    g_ItemRegistry.RegisterWeapon( WEP_CUPZAKE::WEP_NAME, "ressya_no_tabi", WEP_CUPZAKE::AMMO_NAME );
    
    // Ammo登録
    g_CustomEntityFuncs.RegisterCustomEntity( "CupzakeAmmo", WEP_CUPZAKE::AMMO_NAME );
}

////////////////////////////////////////////////////////////////////////////////////////////

/** Ammo */
class CupzakeAmmo : ScriptBasePlayerAmmoEntity {
    private string modelFile = "models/ressya_no_tabi/w_cupzake.mdl";
    private string soundFile = "items/9mmclip1.wav";
    
    void Spawn() {
        g_Game.PrecacheModel( this.modelFile );
        g_SoundSystem.PrecacheSound( this.soundFile );
        
        g_EntityFuncs.SetModel( self, this.modelFile );
        BaseClass.Spawn();
    }

    bool AddAmmo( CBaseEntity@ pEnt ) {
        CBasePlayer@ pPlayer = cast<CBasePlayer>(pEnt);
        
        if ( pEnt.GiveAmmo( WEP_CUPZAKE::MAX_AMMO , WEP_CUPZAKE::AMMO_NAME, WEP_CUPZAKE::MAX_AMMO ) != -1 ) {
            g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, this.soundFile, 1, ATTN_NORM );
            
            // 武器持ってないなら追加
            if (pPlayer.HasNamedPlayerItem(WEP_CUPZAKE::WEP_NAME) is null) {
                pPlayer.GiveNamedItem(WEP_CUPZAKE::WEP_NAME, 0, 0);
            }

            // 強制持ち替え
            CBasePlayerItem@ pItem = pPlayer.HasNamedPlayerItem(WEP_CUPZAKE::WEP_NAME);
            if (pItem !is null) {
                pPlayer.SwitchWeapon(pItem);
            }
            
            // フラグを見て、セットされてれば削除する
            if (pev.iuser4 == 1) {
                g_EntityFuncs.Remove( self );
            }
            return true;
        }
        
        return false;
    }
}

