/* 
 * 手裏剣
 */
#include "sns_effect"

namespace WEP_SHURIKEN {
    const int MAX_AMMO = 100;
    const int SUP_AMMO = 50;
    const string WEP_NAME  = "weapon_shuriken";
    const string AMMO_NAME = "ammo_shuriken";
    const string PROJ_NAME = "projectile_shuriken";
    
    enum motion_e {
        MOTION_IDLE = 0,
        MOTION_FIDGET,
        MOTION_THROW1,
        MOTION_THROW2,
        MOTION_THROW3,
        MOTION_HOLSTER,
        MOTION_DRAW
    };
    
}
class WeaponShuriken : ScriptBasePlayerWeaponEntity {
    private CBasePlayer@ m_pPlayer = null;
    
    private string vModel = "models/ressya_no_tabi/v_shuriken.mdl";
    private string pModel = "models/ressya_no_tabi/p_shuriken.mdl";
    private string wModel = "models/ressya_no_tabi/w_shuriken.mdl";
    
    private string throwSoundFile = "weapons/cbar_miss1.wav";
    
    void Spawn() {
        self.Precache();
        g_EntityFuncs.SetModel( self, self.GetW_Model( this.wModel) );
        //self.m_iDefaultAmmo = WEP_SHURIKEN::SUP_AMMO;
        self.m_iClip = -1;

        self.FallInit();// get ready to fall down.
    }

    void Precache() {
        self.PrecacheCustomModels();

        g_Game.PrecacheModel( this.vModel );
        g_Game.PrecacheModel( this.wModel );
        g_Game.PrecacheModel( this.pModel );

        g_SoundSystem.PrecacheSound( this.throwSoundFile );

        // 投擲用
        g_Game.PrecacheModel( "models/ressya_no_tabi/shuriken.mdl" ); 
        g_Game.PrecacheModel("sprites/laserbeam.spr");
        g_SoundSystem.PrecacheSound("weapons/xbow_hit1.wav");
        g_SoundSystem.PrecacheSound( "weapons/knife_hit_flesh2.wav");
        
        SnsEffect::Precache();
    }

    bool GetItemInfo( ItemInfo& out info ) {
        info.iMaxAmmo1      = WEP_SHURIKEN::MAX_AMMO;
        info.iMaxAmmo2      = -1;
        info.iMaxClip       = WEAPON_NOCLIP;
        info.iSlot          = 2;
        info.iPosition      = 5;
        info.iWeight        = 0;
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
        return self.DefaultDeploy( self.GetV_Model( this.vModel ), self.GetP_Model( this.pModel ), WEP_SHURIKEN::MOTION_DRAW, "gren" );
    }

    /** ホルスター時 */
    void Holster( int skiplocal /* = 0 */ ) {
        self.m_fInReload = false;// cancel any reload in progress.

        m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 0.5; 
        m_pPlayer.pev.viewmodel = "";
        
        // Ammoがなければ削除
        if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 ) {
            
            m_pPlayer.pev.weapons &= ~( 0 << g_ItemRegistry.GetIdForName(WEP_SHURIKEN::WEP_NAME) );
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
        self.SendWeaponAnim( WEP_SHURIKEN::MOTION_DRAW );
        m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 0.5; 
    }
    
    /** プライマリ攻撃 */
    void PrimaryAttack() {
        if (m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType ) > 0) {
            m_pPlayer.pev.weaponmodel = this.pModel;
            ThrowCommon();
            SetThink(ThinkFunction(this.ThrowProj1));
        }
    }
    
    /** セカンダリ攻撃 */
    void SecondaryAttack() {
        if (m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType ) > 0) {
            m_pPlayer.pev.weaponmodel = this.pModel;
            ThrowCommon();
            SetThink(ThinkFunction(this.ThrowProj2));
        }
    }
    
    // 投げ処理共通
    private void ThrowCommon() {
        // ランダム投げモーション
        int anim = Math.RandomLong(WEP_SHURIKEN::MOTION_THROW1, WEP_SHURIKEN::MOTION_THROW3);
        self.SendWeaponAnim(anim );
        
        m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
        self.pev.nextthink = g_WeaponFuncs.WeaponTimeBase() + 0.4;
        
        // ブンブンサウンド
        g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/cbar_miss1.wav", 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );
        
        m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 0.7; 
        self.m_flTimeWeaponIdle = g_Engine.time + 0.7; 
    }
    
    // 弾消費
    private void ConsumeAmmo() {
        int ammoCnt = m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType );
        
        ammoCnt = (ammoCnt -1 < 0) ? 0 : ammoCnt -1;
        m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, ammoCnt);
    }
    
    // 投擲
    private void ThrowProj1() {
        m_pPlayer.pev.weaponmodel = "";
        
        g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, this.throwSoundFile, 1, ATTN_NORM, 0, PITCH_NORM);
        Math.MakeVectors( m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle);
        ShootBall(m_pPlayer.pev,
                  m_pPlayer.GetGunPosition() + g_Engine.v_forward * 32 + g_Engine.v_up * 2 + g_Engine.v_right * -2,
                  g_Engine.v_forward * 1200 + g_Engine.v_up * Math.RandomFloat(-20, 20) + g_Engine.v_right * Math.RandomFloat(-20, 20));        
        ConsumeAmmo();        
    }
    
    // 遅く投げる
    private void ThrowProj2() {
        m_pPlayer.pev.weaponmodel = "";
        
        g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, this.throwSoundFile, 1, ATTN_NORM, 0, PITCH_NORM);
        Math.MakeVectors( m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle);
        ShootBall(m_pPlayer.pev,
                  m_pPlayer.GetGunPosition() + g_Engine.v_forward * 32 + g_Engine.v_up * 2 + g_Engine.v_right * -2,
                  g_Engine.v_forward * 600 + g_Engine.v_up * Math.RandomFloat(-5, 5) + g_Engine.v_right * Math.RandomFloat(-5, 5));
        SetThink(null);
        
        ConsumeAmmo();
    }    
    
    // 投擲処理
    private void ShootBall(entvars_t@ pevOwner, Vector vecStart, Vector vecVelocity) {
        
        CBaseEntity@ pEntity = g_EntityFuncs.CreateEntity( WEP_SHURIKEN::PROJ_NAME , null,  false);
        ShurikenProj@ pProj = cast<ShurikenProj@>(CastToScriptClass(pEntity));
        
        g_EntityFuncs.SetOrigin( pProj.self, vecStart );
        g_EntityFuncs.DispatchSpawn( pProj.self.edict() );
        
        pProj.pev.velocity = vecVelocity;
        @pProj.pev.owner = pevOwner.pContainingEntity;
        pProj.pev.angles = Math.VecToAngles( pProj.pev.velocity );
        pProj.SetThink( ThinkFunction( pProj.BulletThink ) );
        pProj.pev.nextthink = g_Engine.time + 0.1;
        pProj.SetTouch( TouchFunction( pProj.Touch ) );
        
        pProj.pev.angles.z = pProj.pev.angles.z + Math.RandomFloat(-30.0, 30.0);
        
        
        // プレイヤーのインデックスをセット
        pProj.pev.iuser4 = g_EngineFuncs.IndexOfEdict(m_pPlayer.edict()); 
        
    }
    
    /** アイドル時 */
    void WeaponIdle() {
        self.ResetEmptySound();
        
        // Ammoなければ削除
        if (m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType ) <= 0) {
            m_pPlayer.pev.weapons &= ~( 0 << g_ItemRegistry.GetIdForName(WEP_SHURIKEN::WEP_NAME) );
            SetThink( ThinkFunction( DestroyThink ) );
            self.pev.nextthink = g_Engine.time + 0.1;
            return;
        }

        if( self.m_flTimeWeaponIdle  > g_Engine.time) {
            return;
        }
        
        // 次のを取り出すモーション
        m_pPlayer.pev.weaponmodel = this.pModel;
        m_pPlayer.SetAnimation( PLAYER_DEPLOY );
        
        int anim = Math.RandomLong( WEP_SHURIKEN::MOTION_IDLE,  WEP_SHURIKEN::MOTION_FIDGET );
        self.SendWeaponAnim( anim );

        self.m_flTimeWeaponIdle = g_Engine.time + Math.RandomFloat(10.0, 15.0);
    }
    
}

// 登録
void RegisterShuriken() {
    g_CustomEntityFuncs.RegisterCustomEntity( "WeaponShuriken", WEP_SHURIKEN::WEP_NAME ); // クラス名, 定義名
    g_ItemRegistry.RegisterWeapon( WEP_SHURIKEN::WEP_NAME, "ressya_no_tabi", WEP_SHURIKEN::AMMO_NAME );
    
    // Ammo登録
    g_CustomEntityFuncs.RegisterCustomEntity( "ShurikenAmmo", WEP_SHURIKEN::AMMO_NAME );
    
    // Projectile登録
    g_CustomEntityFuncs.RegisterCustomEntity( "ShurikenProj", WEP_SHURIKEN::PROJ_NAME );
}

////////////////////////////////////////////////////////////////////////////////////////////

/** Ammo */
class ShurikenAmmo : ScriptBasePlayerAmmoEntity {
    private string modelFile = "models/ressya_no_tabi/w_shuriken.mdl";
    private string soundFile = "items/9mmclip1.wav";
    
    void Spawn() {
        g_Game.PrecacheModel( this.modelFile );
        g_SoundSystem.PrecacheSound( this.soundFile );
        
        g_EntityFuncs.SetModel( self, this.modelFile );
        BaseClass.Spawn();
    }

    bool AddAmmo( CBaseEntity@ pEnt ) {
        CBasePlayer@ pPlayer = cast<CBasePlayer>(pEnt);
        
        if ( pEnt.GiveAmmo( WEP_SHURIKEN::SUP_AMMO, WEP_SHURIKEN::AMMO_NAME, WEP_SHURIKEN::MAX_AMMO ) != -1 ) {
            // 武器持ってないなら追加
            if (pPlayer.HasNamedPlayerItem(WEP_SHURIKEN::WEP_NAME) is null) {
                pPlayer.GiveNamedItem(WEP_SHURIKEN::WEP_NAME, 0, 0);
            }
            
            g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, this.soundFile, 1, ATTN_NORM );
            
            // フラグを見て、セットされてれば削除する
            if (pev.iuser4 == 1) {
                g_EntityFuncs.Remove( self );
            }
            return true;
        }
        
        return false;
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////

/** Projectile */
class ShurikenProj : ScriptBaseMonsterEntity {
    private float lifeTime;    // 寿命
    
    private string modelFile    = "models/ressya_no_tabi/shuriken.mdl";
    private string trailFile    = "sprites/laserbeam.spr";
    private string hitSoundFile = "weapons/xbow_hit1.wav";
    private string dmgSoundFile = "weapons/knife_hit_flesh2.wav";
    private string picSoundFile = "items/9mmclip1.wav";
    
    void Spawn() {
        Precache();
        pev.solid = SOLID_SLIDEBOX;
        pev.movetype = MOVETYPE_FLY;
        pev.takedamage = DAMAGE_YES;
        pev.scale = 1;
        self.ResetSequenceInfo();
        
        pev.movetype = MOVETYPE_FLY;
        g_EntityFuncs.SetModel( self, this.modelFile);
        
        this.lifeTime = 0;
        
        SetThink( ThinkFunction( this.BulletThink ) );
    }

    private void Precache() {
        g_Game.PrecacheModel( this.modelFile ); 
        g_Game.PrecacheModel( this.trailFile );
        g_SoundSystem.PrecacheSound( this.hitSoundFile );
        g_SoundSystem.PrecacheSound( this.picSoundFile );
    }
    
    void Touch ( CBaseEntity@ pOther ) {
        const float HITDAMAGE = 70.0 + Math.RandomFloat(-20.0, 20.0);
        
        int cl = pOther.Classify();
        
        // 速度が弱まったら、とまって消える
        if (pev.velocity.Length() < 30.0) {
            pev.solid = SOLID_NOT;
            pev.movetype = MOVETYPE_FLY;
            self.StopAnimation();
            
            this.lifeTime = g_Engine.time + 1.0;
        }
        
         // 壁以外ならダメージ
        if ( ( pOther.TakeDamage ( pev, pev, 0, DMG_CLUB ) ) == 1 ) {
            g_WeaponFuncs.SpawnBlood(pev.origin, pOther.BloodColor(), HITDAMAGE);
            pOther.TakeDamage ( pev, pev.owner.vars, HITDAMAGE, DMG_CLUB );
            
            pev.angles = Math.VecToAngles( Vector(200.0 * Math.RandomFloat(-1.0, 1.0)
                                                 ,200.0 * Math.RandomFloat(-1.0, 1.0)
                                                 ,200.0 * Math.RandomFloat(-1.0, 1.0)) );
            
            g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, this.dmgSoundFile, 1, ATTN_NORM, 0, PITCH_NORM);
            
        // 壁
        } else {
            g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, this.hitSoundFile, 1, ATTN_NORM, 0, PITCH_NORM);
            g_Utility.Sparks( pev.origin );
        }
        
        if (this.lifeTime == 0) {
            // 味方ヒットの場合はマイナス評価
            if ((cl == CLASS_PLAYER) || ( cl == CLASS_PLAYER_ALLY) || ( cl == CLASS_HUMAN_PASSIVE)) {
                
                CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(pev.iuser4);
                if ((pPlayer !is null) && (pPlayer.IsConnected()) ) {
                    SnsEffect::EffectBad(pPlayer);
                }
            }
        }
        
        // ヒットしたので、削除時間セット
        this.lifeTime = (this.lifeTime == 0) ? g_Engine.time + 1.0 : this.lifeTime;
        
       
    }
    
    // プレイヤーへアイテム追加
    private void AddWeaponToPlayer(CBaseEntity@ pEnt ) {
        CBasePlayer@ pPlayer = cast<CBasePlayer>(pEnt);
        
        // 武器持ってないなら追加
        pEnt.GiveAmmo( 1, WEP_SHURIKEN::AMMO_NAME, WEP_SHURIKEN::MAX_AMMO );
        if (pPlayer.HasNamedPlayerItem(WEP_SHURIKEN::WEP_NAME) is null) {
            pPlayer.GiveNamedItem(WEP_SHURIKEN::WEP_NAME, 0, 0);
        }
        
        // 強制的に武器を優先
        CBasePlayerItem@ pItem = pPlayer.HasNamedPlayerItem(WEP_SHURIKEN::WEP_NAME);
        if (pItem !is null) {
            pPlayer.SwitchWeapon(pItem);
        }
        g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, this.picSoundFile, 1, ATTN_NORM );
    }
    
    void BulletThink() {
        pev.nextthink = g_Engine.time + 0.1;
        pev.velocity = pev.velocity + g_Engine.v_up * -10;
        
        int tailId = g_EntityFuncs.EntIndex(self.edict());
        int sprId  = g_EngineFuncs.ModelIndex(this.trailFile);
        NetworkMessage nm(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
        nm.WriteByte(TE_BEAMFOLLOW);
        nm.WriteShort(tailId);
        nm.WriteShort(sprId);
        nm.WriteByte(2);    // 描画時間
        nm.WriteByte(2);    // サイズ
        nm.WriteByte(128);  // R
        nm.WriteByte(128);  // G
        nm.WriteByte(128);  // B
        nm.WriteByte(64);   // A
        nm.End();
        
        // 時間で消える
        if ((this.lifeTime > 0) && (g_Engine.time  >= this.lifeTime)) {
            g_EntityFuncs.Remove( self );
        }
    }

}
