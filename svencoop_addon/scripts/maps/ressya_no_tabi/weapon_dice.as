/* 
 * サイコロ
 */
#include "sns_effect"

namespace WEP_DICE {
    const int MAX_AMMO = 3;
    const int MAX_CNT = 50; // Ammoオブジェの存在上限数
    const string WEP_NAME  = "weapon_dice";
    const string AMMO_NAME = "ammo_dice";
    const string PROJ_NAME = "projectile_dice";
    
    enum motion_e {
        MOTION_IDLE = 0,
        MOTION_FIDGET,
        MOTION_HOLSTER,
        MOTION_DRAW,
        MOTION_THROW
    };
    
    const string V_MODEL = "models/ressya_no_tabi/v_dice.mdl";
    const string P_MODEL = "models/ressya_no_tabi/p_dice.mdl";
    const array<string> W_MODELS = {
        "models/ressya_no_tabi/w_dice1.mdl",
        "models/ressya_no_tabi/w_dice2.mdl",
        "models/ressya_no_tabi/w_dice3.mdl",
        "models/ressya_no_tabi/w_dice4.mdl",
        "models/ressya_no_tabi/w_dice5.mdl",
        "models/ressya_no_tabi/w_dice6.mdl"
    };
    const string PROJ_MODEL = "models/ressya_no_tabi/proj_dice.mdl";
}
class WeaponDice : ScriptBasePlayerWeaponEntity {
    private CBasePlayer@ m_pPlayer = null;
    
    private string throwSoundFile = "weapons/knife1.wav";
    
    void Spawn() {
        self.Precache();
        g_EntityFuncs.SetModel( self, self.GetW_Model( WEP_DICE::W_MODELS[0]) );
        self.m_iClip = -1;

        self.FallInit();// get ready to fall down.
    }

    void Precache() {
        self.PrecacheCustomModels();

        g_Game.PrecacheModel( WEP_DICE::V_MODEL );
        g_Game.PrecacheModel( WEP_DICE::P_MODEL );
        for (uint i = 0; i < WEP_DICE::W_MODELS.length(); i++) {
            g_Game.PrecacheModel( WEP_DICE::W_MODELS[i] );
        }
        g_Game.PrecacheModel( WEP_DICE::PROJ_MODEL );

        g_SoundSystem.PrecacheSound( this.throwSoundFile );

        // 投擲用
        g_Game.PrecacheModel("sprites/laserbeam.spr");
        g_SoundSystem.PrecacheSound("weapons/sshell3.wav");
        
        SnsEffect::Precache();
    }

    bool GetItemInfo( ItemInfo& out info ) {
        info.iMaxAmmo1      = WEP_DICE::MAX_AMMO;
        info.iMaxAmmo2      = -1;
        info.iMaxClip       = 0; //WEAPON_NOCLIP;
        info.iSlot          = 3;
        info.iPosition      = 6;
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
        bool ret = self.DefaultDeploy( self.GetV_Model( WEP_DICE::V_MODEL ),
                                       self.GetP_Model( WEP_DICE::P_MODEL ),
                                       WEP_DICE::MOTION_DRAW, "gren" );
        
        // ブンブンサウンド
        g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/knife1.wav", 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );
        UpdateAnimDiceNum(WEP_DICE::MOTION_DRAW);
        
        self.m_flTimeWeaponIdle = g_Engine.time + 5.0; 
        return ret;
    }

    /** ホルスター時 */
    void Holster( int skiplocal /* = 0 */ ) {
        self.m_fInReload = false;// cancel any reload in progress.

        m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 0.5; 
        m_pPlayer.pev.viewmodel = "";
        
        // Ammoがなければ削除
        if( m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 ) {
            
            m_pPlayer.pev.weapons &= ~( 0 << g_ItemRegistry.GetIdForName(WEP_DICE::WEP_NAME) );
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
        g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/knife1.wav", 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );
        UpdateAnimDiceNum(WEP_DICE::MOTION_DRAW);
        self.m_flTimeWeaponIdle = g_Engine.time + 5.0; 
        m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 0.5; 
    }
    
    /** プライマリ攻撃 */
    void PrimaryAttack() {
        if (m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType ) > 0) {
            m_pPlayer.pev.weaponmodel = WEP_DICE::P_MODEL;
            ThrowCommon();
            SetThink(ThinkFunction(this.ThrowProj1));
        }
    }
    
    /** セカンダリ攻撃 */
    void SecondaryAttack() {
        if (m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType ) > 0) {
            m_pPlayer.pev.weaponmodel = WEP_DICE::P_MODEL;
            ThrowCommon();
            SetThink(ThinkFunction(this.ThrowProj2));
        }
    }
    
    // 投げ処理共通
    private void ThrowCommon() {
        // ランダム投げモーション
        UpdateAnimDiceNum(WEP_DICE::MOTION_THROW);
        
        m_pPlayer.SetAnimation( PLAYER_ATTACK1 );
        self.pev.nextthink = g_WeaponFuncs.WeaponTimeBase() + 0.5;
        
        // ブンブンサウンド
        g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, "weapons/knife1.wav", 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );
        
        m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + 1.0; 
        self.m_flTimeWeaponIdle = g_Engine.time + 1.0; 
        
        // ランダムでGOOD
        if (Math.RandomLong( 0, 9 ) == 0) { 
            SnsEffect::EffectGood(m_pPlayer);
        }
    }
    
    
    // 弾数から、モーション更新
    private void UpdateAnimDiceNum(int animName) {
        int ammoCnt = m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType );
        self.SendWeaponAnim( animName,  0, ammoCnt - 1);
    }
    
    // 弾消費
    private void ConsumeAmmo() {
        int ammoCnt = m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType );
        
        ammoCnt = (ammoCnt -1 < 0) ? 0 : ammoCnt -1;
        m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, ammoCnt);
    }
    
    // 投げる
    private void ThrowProj1() {
        m_pPlayer.pev.weaponmodel = "";
        g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, this.throwSoundFile, 1, ATTN_NORM, 0, PITCH_NORM);
        Math.MakeVectors( m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle);
        ShootDice(m_pPlayer.pev,
                  m_pPlayer.GetGunPosition() + g_Engine.v_forward * 32 + g_Engine.v_up * 2 + g_Engine.v_right * -2,
                  g_Engine.v_forward * 50 + g_Engine.v_up * Math.RandomFloat(-20, 20) + g_Engine.v_right * Math.RandomFloat(-20, 20));        
        ConsumeAmmo();
    }
    
    // 全部投げる
    private void ThrowProj2() {
        m_pPlayer.pev.weaponmodel = "";
        g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, this.throwSoundFile, 1, ATTN_NORM, 0, PITCH_NORM);
        Math.MakeVectors( m_pPlayer.pev.v_angle + m_pPlayer.pev.punchangle);
        
        int ammoCnt = m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType );
        
        ShootDice(m_pPlayer.pev,
                  m_pPlayer.GetGunPosition() + g_Engine.v_forward * 32 + g_Engine.v_up * 2 + g_Engine.v_right * -2,
                  g_Engine.v_forward * 50 + g_Engine.v_up * Math.RandomFloat(-20, 20) + g_Engine.v_right * Math.RandomFloat(-20, 20));
        
        // ２投目
        if (ammoCnt >= 2) {
            ShootDice(m_pPlayer.pev,
                  m_pPlayer.GetGunPosition() + g_Engine.v_forward * 32 + g_Engine.v_up * 2 + g_Engine.v_right * (-2 -10),
                  g_Engine.v_forward * 50 + g_Engine.v_up * Math.RandomFloat(-20, 20) + g_Engine.v_right * Math.RandomFloat(-20, 20));
        }
        
        // ３投目
        if (ammoCnt >= 3) {
            ShootDice(m_pPlayer.pev,
                  m_pPlayer.GetGunPosition() + g_Engine.v_forward * 32 + g_Engine.v_up * 2 + g_Engine.v_right * (-2 + 10),
                  g_Engine.v_forward * 50 + g_Engine.v_up * Math.RandomFloat(-20, 20) + g_Engine.v_right * Math.RandomFloat(-20, 20));
        }
        
        // Ammo = 0 へ
        m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType, 0);
            
        SetThink(null);
    }    
    
    // 投擲処理
    private void ShootDice(entvars_t@ pevOwner, Vector vecStart, Vector vecVelocity) {
        
        CBaseEntity@ pEntity = g_EntityFuncs.CreateEntity( WEP_DICE::PROJ_NAME , null,  false);
        DiceProj@ pProj = cast<DiceProj@>(CastToScriptClass(pEntity));
        
        g_EntityFuncs.SetOrigin( pProj.self, vecStart );
        g_EntityFuncs.DispatchSpawn( pProj.self.edict() );
        
        pProj.pev.velocity = vecVelocity;
        @pProj.pev.owner = pevOwner.pContainingEntity;
        pProj.pev.angles = Math.VecToAngles( pProj.pev.velocity );
        pProj.SetThink( ThinkFunction( pProj.BulletThink ) );
        pProj.pev.nextthink = g_Engine.time + 0.1;
        pProj.SetTouch( TouchFunction( pProj.Touch ) );
        
        
        // プレイヤーのインデックスをセット
        pProj.pev.iuser4 = g_EngineFuncs.IndexOfEdict(m_pPlayer.edict()); 
        
    }
    
    /** アイドル時 */
    void WeaponIdle() {
        self.ResetEmptySound();
        
        // Ammoなければ削除
        if (m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType ) <= 0) {
            m_pPlayer.pev.weapons &= ~( 0 << g_ItemRegistry.GetIdForName(WEP_DICE::WEP_NAME) );
            SetThink( ThinkFunction( DestroyThink ) );
            self.pev.nextthink = g_Engine.time + 0.1;
            return;
        }

        if( self.m_flTimeWeaponIdle  > g_Engine.time) {
            return;
        }
        
        // 次のを取り出すモーション
        m_pPlayer.pev.weaponmodel = WEP_DICE::P_MODEL;
        m_pPlayer.SetAnimation( PLAYER_DEPLOY );
        
        int anim = (Math.RandomLong(0, 5) == 0) ? WEP_DICE::MOTION_FIDGET : WEP_DICE::MOTION_IDLE;
        UpdateAnimDiceNum( anim );
        

        self.m_flTimeWeaponIdle = g_Engine.time + Math.RandomFloat(10.0, 15.0);
    }
    
}

// 登録
void RegisterDice() {
    g_CustomEntityFuncs.RegisterCustomEntity( "WeaponDice", WEP_DICE::WEP_NAME ); // クラス名, 定義名
    g_ItemRegistry.RegisterWeapon( WEP_DICE::WEP_NAME, "ressya_no_tabi", WEP_DICE::AMMO_NAME );
    
    // Ammo登録
    g_CustomEntityFuncs.RegisterCustomEntity( "DiceAmmo", WEP_DICE::AMMO_NAME );
    
    // Projectile登録
    g_CustomEntityFuncs.RegisterCustomEntity( "DiceProj", WEP_DICE::PROJ_NAME );
}

////////////////////////////////////////////////////////////////////////////////////////////

/** Ammo */
class DiceAmmo : ScriptBasePlayerAmmoEntity {
    private string soundFile = "items/9mmclip1.wav";
    
    void Spawn() {
        for (uint i = 0; i < WEP_DICE::W_MODELS.length(); i++) {
            g_Game.PrecacheModel( WEP_DICE::W_MODELS[i] );
        }        
        g_SoundSystem.PrecacheSound( this.soundFile );
        
        int modelIndex = Math.RandomLong(0, 5);
        g_EntityFuncs.SetModel( self, WEP_DICE::W_MODELS[modelIndex] );
        
        BaseClass.Spawn();
    }

    bool AddAmmo( CBaseEntity@ pEnt ) {
        CBasePlayer@ pPlayer = cast<CBasePlayer>(pEnt);
        
        if ( pEnt.GiveAmmo( 1, WEP_DICE::AMMO_NAME, WEP_DICE::MAX_AMMO ) != -1 ) {
            g_SoundSystem.EmitSound( self.edict(), CHAN_ITEM, this.soundFile, 1, ATTN_NORM );
            
            // 武器持ってないなら追加
            if (pPlayer.HasNamedPlayerItem(WEP_DICE::WEP_NAME) is null) {
                pPlayer.GiveNamedItem(WEP_DICE::WEP_NAME, 0, 0);
            }

            // 強制持ち替え
            CBasePlayerItem@ pItem = pPlayer.HasNamedPlayerItem(WEP_DICE::WEP_NAME);
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

////////////////////////////////////////////////////////////////////////////////////////////

/** Projectile */
class DiceProj : ScriptBaseMonsterEntity {
    private float lifeTime;    // 寿命
    
    private string hitSoundFile = "weapons/sshell3.wav";
    private string picSoundFile = "items/9mmclip1.wav";
    
    void Spawn() {
        Precache();
        pev.solid = SOLID_SLIDEBOX;
        pev.movetype = MOVETYPE_FLY;
        pev.takedamage = DAMAGE_NO;
        pev.scale = 1;
        
        self.ResetSequenceInfo();
        
        g_EntityFuncs.SetModel( self, WEP_DICE::PROJ_MODEL);
        
        this.lifeTime = 0;
        
        SetThink( ThinkFunction( this.BulletThink ) );
    }

    private void Precache() {
        g_Game.PrecacheModel( WEP_DICE::PROJ_MODEL ); 
        g_SoundSystem.PrecacheSound( this.hitSoundFile );
        g_SoundSystem.PrecacheSound( this.picSoundFile );
    }
    
    void Touch ( CBaseEntity@ pOther ) {
        const float HITDAMAGE = 20.0 + Math.RandomFloat(-10.0, 10.0);
        
        // 速度が弱まったら、とまって消える
        if (pev.velocity.Length() < 30.0) {
            pev.solid = SOLID_NOT;
            pev.movetype = MOVETYPE_FLY;
            //self.StopAnimation();
            
            this.lifeTime = g_Engine.time + 1.0;
        }
        
        if (this.lifeTime == 0) {
            g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, this.hitSoundFile, 1, ATTN_NORM, 0, PITCH_NORM);
        }
        
        // ヒットしたので、削除時間セット
        this.lifeTime = (this.lifeTime == 0) ? g_Engine.time + 2.0 : this.lifeTime;
        
        // 壁以外
        if ( ( pOther.TakeDamage ( pev, pev, 0, DMG_CLUB ) ) == 1 ) {            
            pev.angles = Math.VecToAngles( Vector(200.0 * Math.RandomFloat(-1.0, 1.0)
                                                 ,200.0 * Math.RandomFloat(-1.0, 1.0)
                                                 ,200.0 * Math.RandomFloat(-1.0, 1.0)) );
        }
    }
    
    void BulletThink() {
        pev.nextthink = g_Engine.time + 0.1;
        pev.velocity = pev.velocity + g_Engine.v_up * -20;
        // 時間で消える
        if ((this.lifeTime > 0) && (g_Engine.time  >= this.lifeTime)) {
            BallCreate();
            g_EntityFuncs.Remove( self );
        }
    }
    
    // スポーン
    private void BallCreate() {
        CBaseEntity@ pEntity = g_EntityFuncs.Create( WEP_DICE::AMMO_NAME,  pev.origin, pev.angles, true);
        pEntity.pev.iuser4 = 1; // フラグを立てる。resapawnしない
        pEntity.pev.fuser4 = g_Engine.time + 180.0;
        pEntity.pev.angles = Vector(0, Math.RandomFloat(-180, 180), 0);
        g_EntityFuncs.DispatchSpawn(pEntity.edict());
    }

}
