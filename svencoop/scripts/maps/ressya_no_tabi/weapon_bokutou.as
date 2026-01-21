/* 
 * 木刀
 */
#include "sns_effect"

namespace WEP_BOKUTOU {
    
    const string WEP_NAME = "weapon_bokutou";
    
    enum motion_e {
        MOTION_IDLE = 0,
        MOTION_DRAW,
        MOTION_HOLSTER,
        MOTION_ATTACK1HIT,
        MOTION_ATTACK1MISS,
        MOTION_ATTACK2MISS,
        MOTION_ATTACK2HIT,
        MOTION_ATTACK3MISS,
        MOTION_ATTACK3HIT,
        MOTION_IDLE2,
        MOTION_IDLE3,
        MOTION_KAMAE,
        MOTION_KAMAEKAIJO,
        MOTION_KAMAEIDLE,
        MOTION_KARATAKE
    };
}

class WeaponBokutou : ScriptBasePlayerWeaponEntity {
    private CBasePlayer@ m_pPlayer = null;
    
    private string vModel = "models/ressya_no_tabi/v_bokutou.mdl";
    private string pModel = "models/ressya_no_tabi/p_bokutou.mdl";
    private string wModel = "models/ressya_no_tabi/w_bokutou.mdl";
    
    private bool kamaeState    = false; // 構え状態
    private bool oldKamaeState = false; // 構え状態変更検出用
    
    private bool semiFlag = false;      // 右クリックのセミオート処理対応
    
    int m_iSwing;
    TraceResult m_trHit;
    
    /** スポーン */
    void Spawn() {
        self.Precache();
        g_EntityFuncs.SetModel( self, self.GetW_Model( this.wModel) );
        self.m_iClip = -1;

        self.FallInit();// get ready to fall down.
    }

    /** プリキャッシュ */
    void Precache() {
        self.PrecacheCustomModels();

        g_Game.PrecacheModel( this.vModel );
        g_Game.PrecacheModel( this.wModel );
        g_Game.PrecacheModel( this.pModel );

        g_SoundSystem.PrecacheSound( "weapons/bullet_hit1.wav" );
        g_SoundSystem.PrecacheSound( "weapons/bullet_hit2.wav" );
        g_SoundSystem.PrecacheSound( "weapons/cbar_hitbod1.wav" );
        g_SoundSystem.PrecacheSound( "weapons/cbar_hitbod2.wav" );
        g_SoundSystem.PrecacheSound( "weapons/cbar_hitbod3.wav" );
        g_SoundSystem.PrecacheSound( "weapons/knife3.wav" );
        
        SnsEffect::Precache();
    }

    bool GetItemInfo( ItemInfo& out info ) {
        info.iMaxAmmo1      = -1;
        info.iMaxAmmo2      = -1;
        info.iMaxClip       = 0; //WEAPON_NOCLIP;
        info.iSlot          = 1;
        info.iPosition      = 5;
        info.iWeight        = 0;
        return true;
    }
    
    /** プレイヤー追加 */
    bool AddToPlayer( CBasePlayer@ pPlayer ) {
        if ( !BaseClass.AddToPlayer( pPlayer ) ) {
            return false;
        }
        @m_pPlayer = pPlayer;
        return true;
    }

    /** 取り出し */
    bool Deploy() {
        this.semiFlag      = false;
        this.kamaeState    = false;
        this.oldKamaeState = false;
        return self.DefaultDeploy( self.GetV_Model( this.vModel ), self.GetP_Model( this.pModel ), WEP_BOKUTOU::MOTION_DRAW, "crowbar" );
    }

    /** ホルスター */
    void Holster( int skiplocal /* = 0 */ ) {
        self.m_fInReload = false;
        m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 0.5;
        m_pPlayer.pev.viewmodel = "";
        SetThink( null );
    }
    
    
    /** リロード */
    void Reload() {
        if (!this.kamaeState) {
            self.SendWeaponAnim( WEP_BOKUTOU::MOTION_IDLE3 );
        }
    }
    
    /** プライマリアタック */
    void PrimaryAttack() {
        // 構えているときは唐竹攻撃
        if (this.kamaeState) {
            DoSpecialAttack();
            
        // 通常はかなてこスタイル
        } else {
            if( !Swing( 1 ) ) {
                SetThink( ThinkFunction( this.SwingAgain ) );
                self.pev.nextthink = g_Engine.time + 0.1;
            }
        }
        self.m_flTimeWeaponIdle = g_Engine.time + 1.0; 
    }
    
    /** セカンダリアタック */
    void SecondaryAttack() {
        
        // セミオートフラグセット
        if (this.semiFlag) {
            return;
        }
        this.semiFlag = true;
        
        // 状態でモーション切り替え
        if (this.kamaeState) {
            self.SendWeaponAnim( WEP_BOKUTOU::MOTION_KAMAEKAIJO );
        } else {
            self.SendWeaponAnim( WEP_BOKUTOU::MOTION_KAMAE );
        }
        this.kamaeState = !this.kamaeState;
        self.m_flTimeWeaponIdle = g_Engine.time + 1.0; 
    }
    
    private void Smack() {
        g_WeaponFuncs.DecalGunshot( m_trHit, BULLET_PLAYER_CROWBAR );
    }

    private void SwingAgain()  { 
        Swing( 0 );
    }
    
    // ヘビーアタック
    void DoSpecialAttack() {
        self.SendWeaponAnim( WEP_BOKUTOU::MOTION_KARATAKE );
        g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/knife3.wav", 1, ATTN_NORM, 0, 74 + Math.RandomLong( 0,0xF ) );
        SetThink(ThinkFunction(this.SpAttackDelay));
        self.pev.nextthink = g_Engine.time + 0.08;
        self.m_flNextPrimaryAttack   = g_Engine.time + 1.0;
        self.m_flNextSecondaryAttack = g_Engine.time + 1.0;
         
        this.kamaeState = false;
         
        self.m_flTimeWeaponIdle = g_Engine.time + 1.0; 
    }
    
    private void SpAttackDelay() {
        SpAttack();
    }

    // 攻撃＆空振り処理
    private bool Swing( int fFirst ) {
        bool fDidHit = false;

        TraceResult tr;

        Math.MakeVectors( m_pPlayer.pev.v_angle );
        Vector vecSrc = m_pPlayer.GetGunPosition();
        Vector vecEnd = vecSrc + g_Engine.v_forward * 64;

        g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr );

        if ( tr.flFraction >= 1.0 ) {
            g_Utility.TraceHull( vecSrc, vecEnd, dont_ignore_monsters, head_hull, m_pPlayer.edict(), tr );
            if ( tr.flFraction < 1.0 ) {
                CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );
                if ( pHit is null || pHit.IsBSPModel() ) {
                    g_Utility.FindHullIntersection( vecSrc, tr, tr, VEC_DUCK_HULL_MIN, VEC_DUCK_HULL_MAX, m_pPlayer.edict() );
                }
                vecEnd = tr.vecEndPos;
            }
        }

        if ( tr.flFraction >= 1.0 ) {
            if( fFirst != 0 ) {
                // miss
                switch( ( m_iSwing++ ) % 3 ) {
                    case 0: self.SendWeaponAnim( WEP_BOKUTOU::MOTION_ATTACK1MISS ); break;
                    case 1: self.SendWeaponAnim( WEP_BOKUTOU::MOTION_ATTACK2MISS ); break;
                    case 2: self.SendWeaponAnim( WEP_BOKUTOU::MOTION_ATTACK3MISS ); break;
                }
                self.m_flNextPrimaryAttack   = g_Engine.time + 0.5;
                self.m_flNextSecondaryAttack = g_Engine.time + 1.0;
                g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/knife3.wav", 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );
                m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 
            }
        
        } else {
            fDidHit = true;
            
            CBaseEntity@ pEntity = g_EntityFuncs.Instance( tr.pHit );
            switch( ( m_iSwing++ ) % 3 ) {
                case 0: self.SendWeaponAnim( WEP_BOKUTOU::MOTION_ATTACK1HIT ); break;
                case 1: self.SendWeaponAnim( WEP_BOKUTOU::MOTION_ATTACK2HIT ); break;
                case 2: self.SendWeaponAnim( WEP_BOKUTOU::MOTION_ATTACK3HIT ); break;
            }
            m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 

            float flDamage = 60.0 + Math.RandomFloat(-20.0, 20.0);

            g_WeaponFuncs.ClearMultiDamage();
            pEntity.TraceAttack( m_pPlayer.pev, flDamage, g_Engine.v_forward, tr, DMG_CLUB );
            g_WeaponFuncs.ApplyMultiDamage( m_pPlayer.pev, m_pPlayer.pev );

            float flVol = 1.0;
            bool fHitWorld = true;

            if( pEntity !is null ) {
                self.m_flNextPrimaryAttack   = g_Engine.time + 0.25;
                self.m_flNextSecondaryAttack = g_Engine.time + 1.0;

                int cl = pEntity.Classify();
                if( cl != CLASS_NONE && cl != CLASS_MACHINE && pEntity.BloodColor() != DONT_BLEED ) {

                    // 味方攻撃の場合はマイナス評価
                    if (( cl == CLASS_PLAYER) || ( cl == CLASS_PLAYER_ALLY) || ( cl == CLASS_HUMAN_PASSIVE)) {
                        SnsEffect::EffectBad(m_pPlayer);
                    }
                    // プレイヤーは手前に移動
                    if( pEntity.IsPlayer() ) {
                        pEntity.pev.velocity = pEntity.pev.velocity + ( self.pev.origin - pEntity.pev.origin ).Normalize() * 120;
                    }

                    // play thwack or smack sound
                    switch( Math.RandomLong( 0, 2 ) ) {
                        case 0: g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cbar_hitbod1.wav", 1, ATTN_NORM ); break;
                        case 1: g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cbar_hitbod2.wav", 1, ATTN_NORM ); break;
                        case 2: g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cbar_hitbod3.wav", 1, ATTN_NORM ); break;
                    }
                    m_pPlayer.m_iWeaponVolume = 128; 
                    if( !pEntity.IsAlive() ) {
                        return true;
                    } else {
                        flVol = 0.1;
                    }

                    fHitWorld = false;
                }
            }

            if( fHitWorld == true ) {
                float fvolbar = g_SoundSystem.PlayHitSound( tr, vecSrc, vecSrc + ( vecEnd - vecSrc ) * 2, BULLET_PLAYER_CROWBAR );
                
                self.m_flNextPrimaryAttack = g_Engine.time + 0.25;
                fvolbar = 1;

                switch( Math.RandomLong( 0, 1 ) ) {
                    case 0:
                        g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/bullet_hit1.wav", fvolbar, ATTN_NORM, 0, 98 + Math.RandomLong( 0, 3 ) ); 
                        break;
                    case 1:
                        g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/bullet_hit2.wav", fvolbar, ATTN_NORM, 0, 98 + Math.RandomLong( 0, 3 ) ); 
                        break;
                }
            }

            // delay the decal a bit
            m_trHit = tr;
            SetThink( ThinkFunction( this.Smack ) );
            self.pev.nextthink = g_Engine.time + 0.2;

            m_pPlayer.m_iWeaponVolume = int( flVol * 512 ); 
        }
        return fDidHit;
    }
    
    // 特殊攻撃
    private bool SpAttack() {
        bool fDidHit = false;

        TraceResult tr;

        Math.MakeVectors( m_pPlayer.pev.v_angle );
        Vector vecSrc = m_pPlayer.GetGunPosition();
        Vector vecEnd = vecSrc + g_Engine.v_forward * 64;

        g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr );

        if ( tr.flFraction >= 1.0 ) {
            g_Utility.TraceHull( vecSrc, vecEnd, dont_ignore_monsters, head_hull, m_pPlayer.edict(), tr );
            if ( tr.flFraction < 1.0 ) {
                CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );
                if ( pHit is null || pHit.IsBSPModel() ) {
                    g_Utility.FindHullIntersection( vecSrc, tr, tr, VEC_DUCK_HULL_MIN, VEC_DUCK_HULL_MAX, m_pPlayer.edict() );
                }
                vecEnd = tr.vecEndPos;
            }
        }
        m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 
        
        // ヒット
        if ( tr.flFraction < 1.0 ) {
            fDidHit = true;
            
            CBaseEntity@ pEntity = g_EntityFuncs.Instance( tr.pHit );
            m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 

            float flDamage = 200.0 + Math.RandomFloat(-50.0, 50.0);

            g_WeaponFuncs.ClearMultiDamage();
            pEntity.TraceAttack( m_pPlayer.pev, flDamage, g_Engine.v_forward, tr, DMG_CLUB );
            g_WeaponFuncs.ApplyMultiDamage( m_pPlayer.pev, m_pPlayer.pev );

            float flVol = 1.0;
            bool fHitWorld = true;

            self.m_flNextPrimaryAttack = g_Engine.time + 1.0;
            self.m_flNextSecondaryAttack = g_Engine.time + 1.0;
            
            if( pEntity !is null ) {
                int cl = pEntity.Classify();
                if( cl != CLASS_NONE && cl != CLASS_MACHINE && pEntity.BloodColor() != DONT_BLEED ) {

                    // 味方攻撃の場合はマイナス評価
                    if (( cl == CLASS_PLAYER) || ( cl == CLASS_PLAYER_ALLY) || ( cl == CLASS_HUMAN_PASSIVE)) {
                        SnsEffect::EffectBad(m_pPlayer);
                    }
                    // プレイヤーは突き飛ばす
                    if( pEntity.IsPlayer() ) {
                        pEntity.pev.velocity = pEntity.pev.velocity - ( self.pev.origin - pEntity.pev.origin ).Normalize() * 200;
                    }

                    // play thwack or smack sound
                    switch( Math.RandomLong( 0, 2 ) ) {
                        case 0: g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cbar_hitbod1.wav", 1, ATTN_NORM ); break;
                        case 1: g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cbar_hitbod2.wav", 1, ATTN_NORM ); break;
                        case 2: g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cbar_hitbod3.wav", 1, ATTN_NORM ); break;
                    }
                    m_pPlayer.m_iWeaponVolume = 128; 
                    if( !pEntity.IsAlive() ) {
                        return true;
                    } else {
                        flVol = 0.1;
                    }
                    fHitWorld = false;
                }
            }

            if( fHitWorld == true ) {
                float fvolbar = g_SoundSystem.PlayHitSound( tr, vecSrc, vecSrc + ( vecEnd - vecSrc ) * 2, BULLET_PLAYER_CROWBAR );
                
                fvolbar = 1;

                switch( Math.RandomLong( 0, 1 ) ) {
                    case 0:
                        g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/bullet_hit1.wav", fvolbar, ATTN_NORM, 0, 98 + Math.RandomLong( 0, 3 ) ); 
                        break;
                    case 1:
                        g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/bullet_hit2.wav", fvolbar, ATTN_NORM, 0, 98 + Math.RandomLong( 0, 3 ) ); 
                        break;
                }
            }

            // delay the decal a bit
            m_trHit = tr;
            SetThink( ThinkFunction( this.Smack ) );
            self.pev.nextthink = g_Engine.time + 0.2;

            m_pPlayer.m_iWeaponVolume = int( flVol * 512 ); 
        }
        return fDidHit;
    }
    
    /** アイドル時 */
    void WeaponIdle() {
        self.ResetEmptySound();
        
        // セミオート処理。ボタンを離したら解除
        if ( !(( m_pPlayer.pev.button & IN_ATTACK2 ) != 0) ) {
            semiFlag = false;
        }
        
        // 前回と構えの状態が変更されて、少し間（モーションが終わる程度の時間）をおいた状態
        if ((this.kamaeState != this.oldKamaeState) && (self.m_flTimeWeaponIdle + 1.0 < g_Engine.time)) {
            DoIdleMotion();
        }
        this.oldKamaeState = this.kamaeState;
        
        // 一定時間後にアイドルモーション
        if (self.m_flTimeWeaponIdle  > g_Engine.time) {
            return;
        }
                
        DoIdleMotion();
    }
    
    // アイドルモーション切り替え
    private void DoIdleMotion() {
        int anim;
        if (this.kamaeState) {
            self.SendWeaponAnim( WEP_BOKUTOU::MOTION_KAMAEIDLE );
            
        } else {
            switch (Math.RandomLong(0, 1)) {
                case 0: self.SendWeaponAnim( WEP_BOKUTOU::MOTION_IDLE );  break;
                case 1: self.SendWeaponAnim( WEP_BOKUTOU::MOTION_IDLE2 ); break;
            }
        }
        self.m_flTimeWeaponIdle = g_Engine.time + Math.RandomFloat(10.0, 15.0);
    }
}

// 登録
void RegisterBokutou() {
    g_CustomEntityFuncs.RegisterCustomEntity( "WeaponBokutou", WEP_BOKUTOU::WEP_NAME ); // クラス名, 定義名
    g_ItemRegistry.RegisterWeapon( WEP_BOKUTOU::WEP_NAME, "ressya_no_tabi" );
}
