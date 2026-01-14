/**
 * Sven Co-op: Hide and Seek
 * By Adam "Adambean" Reece
 *
 * Open the accompanying file "hideandseek.md" for instructions on using this in your map.
 */

const float MAP_LOOP_INTERVAL = 0.25f;

final class HideAndSeek
{
    /*
     * -------------------------------------------------------------------------
     * Variables
     * -------------------------------------------------------------------------
     */

    // State
    private bool            m_fMapSeemsLegit;
    private string          m_szStage;
    private float           m_flStageTimeLeft;
    private int             m_iHiders;
    private int             m_iHidersCaught;
    private float           m_flHiderReleaseTimeLeft;
    private int             m_iSeekers;

    // Entities
    private CBaseEntity@    m_pInfo;
    private CBaseEntity@    m_pHiderCaptureZone;
    private CBaseEntity@    m_pSeekerSpawnZone;
    private CBaseEntity@    m_pSeekerEquip;

    // Commands
    private CClientCommand@ m_pClientCmdStatus;

    // Map settings
    private CCVar@          m_pfTest;
    private CCVar@          m_piWarmupTime;
    private CCVar@          m_piHideTime;
    private CCVar@          m_piSeekTime;
    private CCVar@          m_piSeekIdleTime;
    private CCVar@          m_pszDefaultModel;
    private CCVar@          m_pszHiderModel;
    private CCVar@          m_pszSeekerModel;
    private CCVar@          m_piHiderSpeed;
    private CCVar@          m_piSeekerSpeed;
    private CCVar@          m_piHiderToSeekerRatio;
    private CCVar@          m_piHiderReleaseScore;
    private CCVar@          m_piHiderReleaseResetTime;
    private CCVar@          m_piHiderUncaughtScore;

    // Messages
    private HUDTextParams   m_sHudTextForHider;         // Personal message to hider
    private HUDTextParams   m_sHudTextForSeeker;        // Personal message to seeker
    private HUDTextParams   m_sHudTextForAll;           // Global message to all
    private HUDTextParams   m_sHudTextForHiders;        // Global message to hiders
    private HUDTextParams   m_sHudTextForSeekers;       // Global message to seekers
    private HUDTextParams   m_sHudTextTimeLeftNormal;   // More than 1 minute remaining
    private HUDTextParams   m_sHudTextTimeLeftShort;    // More than 10 seconds remaining
    private HUDTextParams   m_sHudTextTimeLeftImminent; // 10 seconds (or less) remaining
    private HUDTextParams   m_sHudTextNoSeekers;        // No seekers alert



    /*
     * -------------------------------------------------------------------------
     * Life cycle functions
     * -------------------------------------------------------------------------
     */

    /**
     * Constructor.
     */
    HideAndSeek()
    {
        // State
        m_szStage                   = "";
        m_flStageTimeLeft           = -255.0f;
        m_iHiders                   = 0;
        m_iHidersCaught             = 0;
        m_flHiderReleaseTimeLeft    = 0.0f;
        m_iSeekers                  = 0;

        // Entities
        @m_pInfo                    = null;
        @m_pHiderCaptureZone        = null;
        @m_pSeekerSpawnZone         = null;
        @m_pSeekerEquip             = null;

        // Commands
        @m_pClientCmdStatus         = CClientCommand("hns", "Show Hide & Seek information.", ClientCommandCallback( this.ClientCommandInfo ),   ConCommandFlag::None);

        // Map settings
        @m_pfTest                   = CCVar("hns_test",                     0,              "Test mode. (Run the map with no timers.)",                                         ConCommandFlag::None, CVarCallback( this.LoadSetting ));
        @m_piWarmupTime             = CCVar("hns_warmup_time",              35,             "Warm-up time in seconds. (Before hiders are released to hide.)",                   ConCommandFlag::None, CVarCallback( this.LoadSetting ));
        @m_piHideTime               = CCVar("hns_hide_time",                120,            "Hiding time in seconds.",                                                          ConCommandFlag::None, CVarCallback( this.LoadSetting ));
        @m_piSeekTime               = CCVar("hns_seek_time",                300,            "Seeking time in seconds.",                                                         ConCommandFlag::None, CVarCallback( this.LoadSetting ));
        @m_piSeekIdleTime           = CCVar("hns_seek_idle_time",           60,             "Seeker idle time before being booted to hider.",                                   ConCommandFlag::None, CVarCallback( this.LoadSetting ));
        @m_pszDefaultModel          = CCVar("hns_default_model",            "massn_normal", "Un-teamed player model.",                                                          ConCommandFlag::None, CVarCallback( this.LoadSetting ));
        @m_pszHiderModel            = CCVar("hns_hider_model",              "massn_blue",   "Hider player model.",                                                              ConCommandFlag::None, CVarCallback( this.LoadSetting ));
        @m_pszSeekerModel           = CCVar("hns_seeker_model",             "massn_red",    "Seeker player model.",                                                             ConCommandFlag::None, CVarCallback( this.LoadSetting ));
        @m_piHiderSpeed             = CCVar("hns_hider_speed",              270,            "Hider maximum run speed.",                                                         ConCommandFlag::None, CVarCallback( this.LoadSetting ));
        @m_piSeekerSpeed            = CCVar("hns_seeker_speed",             320,            "Seeker maximum run speed.",                                                        ConCommandFlag::None, CVarCallback( this.LoadSetting ));
        @m_piHiderToSeekerRatio     = CCVar("hns_hider_to_seeker_ratio",    8,              "The number of hiders required for each seeker.",                                   ConCommandFlag::None, CVarCallback( this.LoadSetting ));
        @m_piHiderReleaseScore      = CCVar("hns_hider_release_score",      1,              "How many points to award a hider for releasing captured hiders.",                  ConCommandFlag::None, CVarCallback( this.LoadSetting ));
        @m_piHiderReleaseResetTime  = CCVar("hns_hider_release_reset_time", 10,             "How many seconds hiders must wait to perform another release.",                    ConCommandFlag::None, CVarCallback( this.LoadSetting ));
        @m_piHiderUncaughtScore     = CCVar("hns_hider_uncaught_score",     1,              "How many points to award a hider for not being caught at the end of each round.",  ConCommandFlag::None, CVarCallback( this.LoadSetting ));

        // Messages
        m_sHudTextForHider.channel              = 2;
        m_sHudTextForHider.x                    = -1;
        m_sHudTextForHider.y                    = 0.67;
        m_sHudTextForHider.effect               = 2;
        m_sHudTextForHider.r1                   = 0;
        m_sHudTextForHider.g1                   = 50;
        m_sHudTextForHider.b1                   = 100;
        m_sHudTextForHider.r2                   = 0;
        m_sHudTextForHider.g2                   = 120;
        m_sHudTextForHider.b2                   = 240;
        m_sHudTextForHider.fadeinTime           = 0.025;
        m_sHudTextForHider.fadeoutTime          = 0.5;
        m_sHudTextForHider.holdTime             = 8.0;
        m_sHudTextForHider.fxTime               = 0.25;

        m_sHudTextForSeeker.channel             = 2;
        m_sHudTextForSeeker.x                   = -1;
        m_sHudTextForSeeker.y                   = 0.67;
        m_sHudTextForSeeker.effect              = 2;
        m_sHudTextForSeeker.r1                  = 100;
        m_sHudTextForSeeker.g1                  = 0;
        m_sHudTextForSeeker.b1                  = 0;
        m_sHudTextForSeeker.r2                  = 240;
        m_sHudTextForSeeker.g2                  = 0;
        m_sHudTextForSeeker.b2                  = 0;
        m_sHudTextForSeeker.fadeinTime          = 0.025;
        m_sHudTextForSeeker.fadeoutTime         = 0.5;
        m_sHudTextForSeeker.holdTime            = 8.0;
        m_sHudTextForSeeker.fxTime              = 0.25;

        m_sHudTextForAll.channel                = 1;
        m_sHudTextForAll.x                      = -1;
        m_sHudTextForAll.y                      = -1;
        m_sHudTextForAll.effect                 = 2;
        m_sHudTextForAll.r1                     = 100;
        m_sHudTextForAll.g1                     = 100;
        m_sHudTextForAll.b1                     = 100;
        m_sHudTextForAll.r2                     = 240;
        m_sHudTextForAll.g2                     = 240;
        m_sHudTextForAll.b2                     = 240;
        m_sHudTextForAll.fadeinTime             = 0.025;
        m_sHudTextForAll.fadeoutTime            = 0.5;
        m_sHudTextForAll.holdTime               = 4.0;
        m_sHudTextForAll.fxTime                 = 0.25;

        m_sHudTextForHiders.channel             = 1;
        m_sHudTextForHiders.x                   = -1;
        m_sHudTextForHiders.y                   = -1;
        m_sHudTextForHiders.effect              = 1;
        m_sHudTextForHiders.r1                  = 0;
        m_sHudTextForHiders.g1                  = 50;
        m_sHudTextForHiders.b1                  = 100;
        m_sHudTextForHiders.r2                  = 0;
        m_sHudTextForHiders.g2                  = 120;
        m_sHudTextForHiders.b2                  = 240;
        m_sHudTextForHiders.fadeinTime          = 0.5;
        m_sHudTextForHiders.fadeoutTime         = 0.5;
        m_sHudTextForHiders.holdTime            = 8.0;
        m_sHudTextForHiders.fxTime              = 0.25;

        m_sHudTextForSeekers.channel            = 1;
        m_sHudTextForSeekers.x                  = -1;
        m_sHudTextForSeekers.y                  = -1;
        m_sHudTextForSeekers.effect             = 1;
        m_sHudTextForSeekers.r1                 = 100;
        m_sHudTextForSeekers.g1                 = 0;
        m_sHudTextForSeekers.b1                 = 0;
        m_sHudTextForSeekers.r2                 = 240;
        m_sHudTextForSeekers.g2                 = 0;
        m_sHudTextForSeekers.b2                 = 0;
        m_sHudTextForSeekers.fadeinTime         = 0.5;
        m_sHudTextForSeekers.fadeoutTime        = 0.5;
        m_sHudTextForSeekers.holdTime           = 8.0;
        m_sHudTextForSeekers.fxTime             = 0.25;

        m_sHudTextTimeLeftNormal.channel        = 4;
        m_sHudTextTimeLeftNormal.x              = -1;
        m_sHudTextTimeLeftNormal.y              = 0.33;
        m_sHudTextTimeLeftNormal.effect         = 2;
        m_sHudTextTimeLeftNormal.r1             = 100;
        m_sHudTextTimeLeftNormal.g1             = 100;
        m_sHudTextTimeLeftNormal.b1             = 100;
        m_sHudTextTimeLeftNormal.r2             = 240;
        m_sHudTextTimeLeftNormal.g2             = 240;
        m_sHudTextTimeLeftNormal.b2             = 240;
        m_sHudTextTimeLeftNormal.fadeinTime     = 0.025;
        m_sHudTextTimeLeftNormal.fadeoutTime    = 0.5;
        m_sHudTextTimeLeftNormal.holdTime       = 4.0;
        m_sHudTextTimeLeftNormal.fxTime         = 0.25;

        m_sHudTextTimeLeftShort.channel         = 4;
        m_sHudTextTimeLeftShort.x               = -1;
        m_sHudTextTimeLeftShort.y               = 0.33;
        m_sHudTextTimeLeftShort.effect          = 2;
        m_sHudTextTimeLeftShort.r1              = 100;
        m_sHudTextTimeLeftShort.g1              = 100;
        m_sHudTextTimeLeftShort.b1              = 0;
        m_sHudTextTimeLeftShort.r2              = 240;
        m_sHudTextTimeLeftShort.g2              = 240;
        m_sHudTextTimeLeftShort.b2              = 0;
        m_sHudTextTimeLeftShort.fadeinTime      = 0.025;
        m_sHudTextTimeLeftShort.fadeoutTime     = 0.5;
        m_sHudTextTimeLeftShort.holdTime        = 4.0;
        m_sHudTextTimeLeftShort.fxTime          = 0.25;

        m_sHudTextTimeLeftImminent.channel      = 4;
        m_sHudTextTimeLeftImminent.x            = -1;
        m_sHudTextTimeLeftImminent.y            = 0.33;
        m_sHudTextTimeLeftImminent.effect       = 2;
        m_sHudTextTimeLeftImminent.r1           = 100;
        m_sHudTextTimeLeftImminent.g1           = 0;
        m_sHudTextTimeLeftImminent.b1           = 0;
        m_sHudTextTimeLeftImminent.r2           = 240;
        m_sHudTextTimeLeftImminent.g2           = 0;
        m_sHudTextTimeLeftImminent.b2           = 0;
        m_sHudTextTimeLeftImminent.fadeinTime   = 0.025;
        m_sHudTextTimeLeftImminent.fadeoutTime  = 0.5;
        m_sHudTextTimeLeftImminent.holdTime     = 4.0;
        m_sHudTextTimeLeftImminent.fxTime       = 0.25;

        m_sHudTextNoSeekers.channel             = 3;
        m_sHudTextNoSeekers.x                   = -1;
        m_sHudTextNoSeekers.y                   = 0.85;
        m_sHudTextNoSeekers.effect              = 1;
        m_sHudTextNoSeekers.r1                  = 100;
        m_sHudTextNoSeekers.g1                  = 0;
        m_sHudTextNoSeekers.b1                  = 0;
        m_sHudTextNoSeekers.r2                  = 240;
        m_sHudTextNoSeekers.g2                  = 0;
        m_sHudTextNoSeekers.b2                  = 0;
        m_sHudTextNoSeekers.fadeinTime          = 0;
        m_sHudTextNoSeekers.fadeoutTime         = 0;
        m_sHudTextNoSeekers.holdTime            = Math.clamp(0.25f, MAP_LOOP_INTERVAL + 1.5f, (MAP_LOOP_INTERVAL * 10.0f));
        m_sHudTextNoSeekers.fxTime              = 0.1;
    }

    /**
     * Initialise.
     * @return bool
     */
    bool Initialise()
    {
        if (m_szStage != "") {
            g_Game.AlertMessage(at_error, "Hide and Seek attempt to initialise when already initialised, ignoring.\n");
            return false;
        }

        // Check if map is in good working order to begin
        if (!(m_fMapSeemsLegit = ValidateMap())) {
            g_Game.AlertMessage(at_error, "Hide and Seek not compatible with this map.\n");
            return false;
        }

        g_Hooks.RegisterHook(Hooks::Player::ClientSay,          @ClientSay);
        g_Hooks.RegisterHook(Hooks::Player::ClientPutInServer,  @ClientPutInServer);
        g_Hooks.RegisterHook(Hooks::Player::ClientDisconnect,   @ClientDisconnect);
        g_Hooks.RegisterHook(Hooks::Player::PlayerSpawn,        @PlayerSpawn);
        g_Hooks.RegisterHook(Hooks::Player::PlayerKilled,       @PlayerKilled);

        g_Scheduler.SetInterval("MapLoop", MAP_LOOP_INTERVAL, -1);

        g_Game.AlertMessage(at_console, "Hide and Seek initialised.\n");

        return m_fMapSeemsLegit;
    }



    /*
     * -------------------------------------------------------------------------
     * Helper functions
     * -------------------------------------------------------------------------
     */

    /**
     * Client command to show H&S information.
     * @param  CCommand@ args Command arguments
     * @return void
     */
    private void ClientCommandInfo(const CCommand@ args)
    {
        CBasePlayer@ pPlayer = g_ConCommandSystem.GetCurrentPlayer();

        if (pPlayer is null or !pPlayer.IsConnected()) {
            return;
        }

        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Hide & Seek information\n-----------------------\n");

        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "\nGame settings...\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Test mode               : " + m_pfTest.GetBool()                 + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Warm-up time            : " + m_piWarmupTime.GetInt()            + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Hiding time             : " + m_piHideTime.GetInt()              + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Seeking time            : " + m_piSeekTime.GetInt()              + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Seeker idle kick time   : " + m_piSeekIdleTime.GetInt()          + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Default player model    : " + m_pszDefaultModel.GetString()      + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Hider player model      : " + m_pszHiderModel.GetString()        + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Seeker player model     : " + m_pszSeekerModel.GetString()       + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Hider maximum speed     : " + m_piHiderSpeed.GetInt()            + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Seeker maximum speed    : " + m_piSeekerSpeed.GetInt()           + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Hider to seeker radio   : " + m_piHiderToSeekerRatio.GetInt()    + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Hider release score     : " + m_piHiderReleaseScore.GetInt()     + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Hider release reset time: " + m_piHiderReleaseResetTime.GetInt() + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Hider uncaught score    : " + m_piHiderUncaughtScore.GetInt()    + "\n");

        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "\nGame current state...\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Stage                   : " + GetStage()                         + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Stage time left         : " + GetStageTimeLeft()                 + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Hider count             : " + GetHiderCount()                    + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Hider caught count      : " + GetHiderCaughtCount()              + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Hider release time left : " + GetHiderReleaseTimeLeft()          + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Seeker count            : " + GetSeekerCount()                   + "\n");
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, "Seeker limit            : " + GetSeekerLimit()                   + "\n");
    }

     /**
      * Load a map setting.
      * @param  CCVar@           cvar       CVAR
      * @param  const string& in szOldValue Old string value
      * @param  float            flOldValue Old numeric value
      * @return void
      */
    private void LoadSetting(CCVar@ cvar, const string& in szOldValue, float flOldValue)
    {
        g_Game.AlertMessage(at_console, "[H&S] Setting \"%1\" set at \"%2\".\n", cvar.GetName(), cvar.GetString());

        if (cvar.GetName() == "hns_test") {
            bool fOldValue = flOldValue != 0.0f ? true : false;
            cvar.SetBool(cvar.GetInt() != 0 ? true : false);

            if (cvar.GetBool() != fOldValue) {
                if (cvar.GetBool()) {
                    g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "Hide and Seek test mode ENABLED: Game play and timers HALTED.\n");
                } else {
                    g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "Hide and Seek test mode DISABLED: Game play and timers RESUMED.\n");
                }
            }
        }

        if (cvar.GetName() == "hns_warmup_time") {
            if (cvar.GetFloat() < 15.0f or cvar.GetFloat() > 120.0f) {
                g_Game.AlertMessage(at_warning, "CVAR \"%1\" must be within 15-120 seconds, but \"%2\" specified. (Value will be clamped.)\n", cvar.GetName(), cvar.GetFloat());
                cvar.SetFloat(Math.clamp(15.0f, 120.0f, cvar.GetFloat()));
            }
            return;
        }

        if (cvar.GetName() == "hns_hide_time" or cvar.GetName() == "hns_seek_time") {
            if (cvar.GetFloat() < 30.0f or cvar.GetFloat() > 3600.0f) {
                g_Game.AlertMessage(at_warning, "CVAR \"%1\" must be within 30-3600 seconds, but \"%2\" specified. (Value will be clamped.)\n", cvar.GetName(), cvar.GetFloat());
                cvar.SetFloat(Math.clamp(30.0f, 3600.0f, cvar.GetFloat()));
            }
            return;
        }

        if (cvar.GetName() == "hns_seek_idle_time") {
            if (cvar.GetFloat() < 15.0f or cvar.GetFloat() > 300.0f) {
                g_Game.AlertMessage(at_warning, "CVAR \"%1\" must be within 15-300 seconds, but \"%2\" specified. (Value will be clamped.)\n", cvar.GetName(), cvar.GetFloat());
                cvar.SetFloat(Math.clamp(15.0f, 300.0f, cvar.GetFloat()));
            }
            return;
        }

        if (cvar.GetName() == "hns_default_model" or cvar.GetName() == "hns_hider_model" or cvar.GetName() == "hns_seeker_model") {
            return;
        }

        if (cvar.GetName() == "hns_hider_speed" or cvar.GetName() == "hns_seeker_speed") {
            if (cvar.GetFloat() < 20.0f or cvar.GetFloat() > 400.0f) {
                g_Game.AlertMessage(at_warning, "CVAR \"%1\" must be within 20-400, but \"%2\" specified. (Value will be clamped.)\n", cvar.GetName(), cvar.GetFloat());
                cvar.SetFloat(Math.clamp(20.0f, 400.0f, cvar.GetFloat()));
            }
            return;
        }

        if (cvar.GetName() == "hns_hider_to_seeker_ratio") {
            if (cvar.GetInt() < 0 or cvar.GetInt() > 32) {
                cvar.SetInt(0);
            }
            return;
        }

        if (cvar.GetName() == "hns_hider_release_score" or cvar.GetName() == "hns_hider_uncaught_score") {
            if (cvar.GetInt() < 0 or cvar.GetInt() > 32767) {
                g_Game.AlertMessage(at_warning, "CVAR \"%1\" must be within 0-32767, but \"%2\" specified. (Value will be clamped.)\n", cvar.GetName(), cvar.GetInt());
                cvar.SetInt(Math.clamp(0, 32767, cvar.GetInt()));
            }
            return;
        }

        if (cvar.GetName() == "hns_hider_release_reset_time") {
            if (cvar.GetInt() < 3 or cvar.GetInt() > 30) {
                g_Game.AlertMessage(at_warning, "CVAR \"%1\" must be within 3-30, but \"%2\" specified. (Value will be clamped.)\n", cvar.GetName(), cvar.GetInt());
                cvar.SetInt(Math.clamp(3, 30, cvar.GetInt()));
            }
            return;
        }
    }

    /**
     * Validate the map is correctly built for this game mode.
     * @return bool
     */
    private bool ValidateMap()
    {
        bool            fMapSeemsLegit = true;
        CBaseEntity@    pEntity;

        // Game version
        if (g_Game.GetGameVersion() < 524) {
            g_Game.AlertMessage(at_error, "This game mode requires Sven Co-op version 5.24 or later.\n");
            fMapSeemsLegit = false;
        }

        // Seeker equipment
        if ((@m_pSeekerEquip = g_EntityFuncs.FindEntityByTargetname(null, "seeker_equip")) is null) {
            g_Game.AlertMessage(at_warning, "Entity named \"seeker_equip\" not found. Creating a crowbar.\n");
            @m_pSeekerEquip = g_EntityFuncs.Create("weapon_crowbar", Vector(0, 0, -131072), Vector(0, 0, 0), true);

            m_pSeekerEquip.pev.targetname   = "seeker_equip";
            m_pSeekerEquip.pev.effects      |= EF_NODRAW;
            m_pSeekerEquip.pev.spawnflags   = 384;
            m_pSeekerEquip.pev.movetype     = 8;
            m_pSeekerEquip.pev.dmg          = 1024;
            m_pSeekerEquip.KeyValue("m_flCustomRespawnTime",    0);
            m_pSeekerEquip.KeyValue("IsNotAmmoItem",            1);

            g_EntityFuncs.DispatchSpawn(m_pSeekerEquip.edict());
        }

        // Expose state to map
        if ((@m_pInfo = g_EntityFuncs.FindEntityByTargetname(null, "hns_info")) is null or m_pInfo.pev.classname != "info_target") {
            g_Game.AlertMessage(at_warning, "Entity \"info_target\" named \"hns_info\" not found. Game state information will not be available to the map.\n");
            @m_pInfo = null;
        }

        // Initial spawn point
        if (g_EntityFuncs.FindEntityByTargetname(pEntity, "spawn_init") is null) {
            g_Game.AlertMessage(at_warning, "Entity \"info_player_deathmatch\" named \"spawn_init\" not found. (The first player to join may not be able to spawn for a moment.)\n");
        } else {
            @pEntity = null;
            while ((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, "spawn_init")) !is null) {
                if (pEntity.pev.classname != "info_player_deathmatch") {
                    g_Game.AlertMessage(at_error, "Initial spawn point [X%1, Y%2, Z%3] class name \"%4\" invalid, expecting \"info_player_deathmatch\". (Removing entity.)\n", pEntity.pev.origin.x, pEntity.pev.origin.y, pEntity.pev.origin.z, pEntity.pev.classname);
                    g_EntityFuncs.Remove(pEntity);
                    continue;
                }

                pEntity.pev.message     = "";
                pEntity.pev.spawnflags  |= 40;
                pEntity.Use(null, null, USE_ON, 0);
            }
        }

        // Hider spawn point(s)
        if (g_EntityFuncs.FindEntityByTargetname(pEntity, "spawn_hider") is null) {
            g_Game.AlertMessage(at_error, "Hider spawn point(s) not found.\n");
            fMapSeemsLegit = false;
        } else {
            @pEntity = null;
            while ((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, "spawn_hider")) !is null) {
                if (pEntity.pev.classname != "info_player_deathmatch") {
                    g_Game.AlertMessage(at_error, "Hider spawn point [X%1, Y%2, Z%3] class name \"%4\" invalid, expecting \"info_player_deathmatch\".\n", pEntity.pev.origin.x, pEntity.pev.origin.y, pEntity.pev.origin.z, pEntity.pev.classname);
                    fMapSeemsLegit = false;
                    continue;
                }

                pEntity.pev.target      = "msg_hider_spawn";
                pEntity.pev.message     = "hider";
                pEntity.pev.spawnflags  |= 40;
                pEntity.Use(null, null, USE_ON, 0);
            }
        }

        // Hider captured spawn point(s)
        if (g_EntityFuncs.FindEntityByTargetname(pEntity, "spawn_hider_caught") is null) {
            g_Game.AlertMessage(at_warning, "Entity \"info_player_deathmatch\" named \"spawn_hider_caught\" not found. This is OK if you're going to reuse the original hider spawn positions.\n");
        } else {
            @pEntity = null;
            while ((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, "spawn_hider_caught")) !is null) {
                if (pEntity.pev.classname != "info_player_deathmatch") {
                    g_Game.AlertMessage(at_error, "Hider caught spawn point [X%1, Y%2, Z%3] class name \"%4\" invalid, expecting \"info_player_deathmatch\".\n", pEntity.pev.origin.x, pEntity.pev.origin.y, pEntity.pev.origin.z, pEntity.pev.classname);
                    fMapSeemsLegit = false;
                    continue;
                }

                pEntity.pev.target      = "msg_hider_spawn_caught";
                pEntity.pev.message     = "hider";
                pEntity.pev.spawnflags  |= 40;
                pEntity.Use(null, null, USE_OFF, 0);
            }
        }

        // Seeker spawn point(s)
        if (g_EntityFuncs.FindEntityByTargetname(pEntity, "spawn_seeker") is null) {
            g_Game.AlertMessage(at_error, "Seeker spawn point(s) not found.\n");
            fMapSeemsLegit = false;
        } else {
            @pEntity = null;
            while ((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, "spawn_seeker")) !is null) {

                if (pEntity.pev.classname != "info_player_deathmatch") {
                    g_Game.AlertMessage(at_error, "Seeker spawn point [X%1, Y%2, Z%3] class name \"%4\" invalid, expecting \"info_player_deathmatch\".\n", pEntity.pev.origin.x, pEntity.pev.origin.y, pEntity.pev.origin.z, pEntity.pev.classname);
                    fMapSeemsLegit = false;
                    continue;
                }

                pEntity.pev.target      = "msg_seeker_spawn";
                pEntity.pev.message     = "seeker";
                pEntity.pev.spawnflags  |= 40;
                pEntity.Use(null, null, USE_ON, 0);
            }
        }

        // Hider capture zone
        if ((@m_pHiderCaptureZone = g_EntityFuncs.FindEntityByTargetname(null, "hider_capture_zone")) is null or m_pHiderCaptureZone.pev.classname != "game_zone_player" or !(m_pHiderCaptureZone.IsBSPModel())) {
            g_Game.AlertMessage(at_error, "Hider capture zone not found.\n");
            @m_pHiderCaptureZone = null;
            fMapSeemsLegit = false;
        }

        // Seeker spawn zone
        if ((@m_pSeekerSpawnZone = g_EntityFuncs.FindEntityByTargetname(null, "spawn_seeker_zone")) is null or m_pSeekerSpawnZone.pev.classname != "game_zone_player" or !(m_pSeekerSpawnZone.IsBSPModel())) {
            g_Game.AlertMessage(at_warning, "Seeker spawn zone not found. We may not be able to kick idle seekers back to a hider.\n");
            @m_pSeekerSpawnZone = null;
        }

        return fMapSeemsLegit;
    }

    /**
     * Get a short debug string showing the status of the game mode.
     * @return string
     */
    private string GetDebugString()
    {
        string szDebug = "";
        snprintf(szDebug, "[H&S] Stage \"%1\" [%2], %3 hider(s) (%4 caught), %5 seeker(s).\n", m_szStage, m_flStageTimeLeft, m_iHiders, m_iHidersCaught, m_iSeekers);
        return szDebug;
    }



    /*
     * -------------------------------------------------------------------------
     * Data functions
     * -------------------------------------------------------------------------
     */

    /**
     * Get m_fMapSeemsLegit.
     * @return bool
     */
    bool GetMapSeemsLegit()
    {
        return m_fMapSeemsLegit;
    }

    /**
     * Get m_szStage.
     * @return string
     */
    string GetStage()
    {
        return m_szStage;
    }

    /**
     * Get m_flStageTimeLeft.
     * @return float
     */
    float GetStageTimeLeft()
    {
        return m_flStageTimeLeft;
    }

    /**
     * Get m_iHiders.
     * @return int
     */
    int GetHiderCount()
    {
        return m_iHiders;
    }

    /**
     * Get m_iHidersCaught.
     * @return int
     */
    int GetHiderCaughtCount()
    {
        return m_iHidersCaught;
    }

    /**
     * Get m_flHiderReleaseTimeLeft.
     * @return float
     */
    float GetHiderReleaseTimeLeft()
    {
        return m_flHiderReleaseTimeLeft;
    }

    /**
     * Get m_iSeekers.
     * @return int
     */
    int GetSeekerCount()
    {
        return m_iSeekers;
    }

    /**
     * Get m_piHiderToSeekerRatio.
     * @return int
     */
    int GetHiderToSeekerRatio()
    {
        return m_piHiderToSeekerRatio.GetInt();
    }

    /**
     * Get the maximum number of seekers permitted for the current player count.
     * @return int
     */
    int GetSeekerLimit()
    {
        if (m_piHiderToSeekerRatio.GetInt() <= 0) {
            return 1;
        }

        return Math.clamp(
            1,
            (g_Engine.maxClients - 1),
            int(ceil(float(m_iHiders) / m_piHiderToSeekerRatio.GetFloat()))
        );
    }

    /**
     * Get m_sHudTextForHider
     * @return HUDTextParams
     */
    HUDTextParams GetHudTextForHider()
    {
        return m_sHudTextForHider;
    }

    /**
     * Get m_sHudTextForSeeker
     * @return HUDTextParams
     */
    HUDTextParams GetHudTextForSeeker()
    {
        return m_sHudTextForSeeker;
    }

    /**
     * Get m_sHudTextForAll
     * @return HUDTextParams
     */
    HUDTextParams GetHudTextForAll()
    {
        return m_sHudTextForAll;
    }

    /**
     * Get m_sHudTextForHiders
     * @return HUDTextParams
     */
    HUDTextParams GetHudTextForHiders()
    {
        return m_sHudTextForHiders;
    }

    /**
     * Get m_sHudTextForSeekers
     * @return HUDTextParams
     */
    HUDTextParams GetHudTextForSeekers()
    {
        return m_sHudTextForSeekers;
    }

    /**
     * Get m_sHudTextTimeLeftNormal
     * @return HUDTextParams
     */
    HUDTextParams GetHudTextTimeLeftNormal()
    {
        return m_sHudTextTimeLeftNormal;
    }

    /**
     * Get m_sHudTextTimeLeftShort
     * @return HUDTextParams
     */
    HUDTextParams GetHudTextTimeLeftShort()
    {
        return m_sHudTextTimeLeftShort;
    }

    /**
     * Get m_sHudTextTimeLeftImminent
     * @return HUDTextParams
     */
    HUDTextParams GetHudTextTimeLeftImminent()
    {
        return m_sHudTextTimeLeftImminent;
    }

    /**
     * Get m_sHudTextNoSeekers
     * @return HUDTextParams
     */
    HUDTextParams GetHudTextNoSeekers()
    {
        return m_sHudTextNoSeekers;
    }



    /*
     * -------------------------------------------------------------------------
     * Input functions
     * -------------------------------------------------------------------------
     */

    /**
     * Set a player to be a hider.
     * @param  CBasePlayer@ pPlayer Player
     * @return void
     */
    void SetPlayerAsHider(CBasePlayer@ pPlayer)
    {
        if (pPlayer is null or !pPlayer.IsPlayer() or !pPlayer.IsConnected()) {
            return;
        }

        CustomKeyvalues@ pPlayerExtra = pPlayer.GetCustomKeyvalues();

        pPlayer.SetClassification(CLASS_TEAM1);

        if (m_pszHiderModel.GetString() != "") {
            pPlayer.SetOverriddenPlayerModel(m_pszHiderModel.GetString());
        }

        if (m_piHiderSpeed.GetInt() >= 1) {
            pPlayer.SetMaxSpeed(m_piHiderSpeed.GetInt());
        }

        if (!pPlayer.GetWeaponsBlocked()) {
            pPlayer.BlockWeapons(null);
        }

        if (pPlayer.pev.targetname != "hider") {
            pPlayer.pev.targetname = "hider";
            g_Game.AlertMessage(at_logged, "[H&S] \"%1\" has become a hider.\n", g_Utility.GetPlayerLog(pPlayer.edict()));

            pPlayerExtra.SetKeyvalue("seeker_idle", -1.0f);

            g_PlayerFuncs.RespawnPlayer(pPlayer, true, true);
            HandlePlayerSpawn(pPlayer);
            pPlayer.pev.health = pPlayer.pev.max_health = 100;

            g_PlayerFuncs.SayText(pPlayer, "You are now a hider.\n");
        }
    }

    /**
     * Set a player to be a seeker.
     * @param  CBasePlayer@ pPlayer Player
     * @return void
     */
    void SetPlayerAsSeeker(CBasePlayer@ pPlayer)
    {
        if (pPlayer is null or !pPlayer.IsPlayer() or !pPlayer.IsConnected()) {
            return;
        }

        CustomKeyvalues@ pPlayerExtra = pPlayer.GetCustomKeyvalues();

        pPlayer.SetClassification(CLASS_TEAM2);

        if (m_pszSeekerModel.GetString() != "") {
            pPlayer.SetOverriddenPlayerModel(m_pszSeekerModel.GetString());
        }

        if (m_piSeekerSpeed.GetInt() >= 1) {
            pPlayer.SetMaxSpeed(m_piSeekerSpeed.GetInt());
        }

        if (pPlayer.GetWeaponsBlocked()) {
            pPlayer.UnblockWeapons(null);
        }

        if (pPlayer.pev.targetname != "seeker") {
            pPlayer.pev.targetname = "seeker";
            g_Game.AlertMessage(at_logged, "[H&S] \"%1\" has become a seeker.\n", g_Utility.GetPlayerLog(pPlayer.edict()));

            pPlayerExtra.SetKeyvalue("seeker_idle", 0.0f);

            g_PlayerFuncs.RespawnPlayer(pPlayer, true, true);
            HandlePlayerSpawn(pPlayer);
            pPlayer.pev.health = pPlayer.pev.max_health = 1000;

            g_PlayerFuncs.SayText(pPlayer, "You are now a seeker.\n");
        }
    }

    /**
     * Handle player spawn.
     * @param  CBasePlayer@ pPlayer Player
     * @return void
     */
    void HandlePlayerSpawn(CBasePlayer@ pPlayer)
    {
        if (pPlayer is null or !pPlayer.IsPlayer()) {
            return;
        }

        pPlayer.RemoveAllItems(false, false);
        g_PlayerFuncs.ApplyMapCfgToPlayer(pPlayer, true);
        pPlayer.SendScoreInfo();

        if (pPlayer.pev.targetname == "hider") {
            if (g_HideAndSeek.GetStage() == "s") {
                if (g_EntityFuncs.FindEntityByTargetname(null, "msg_hider_spawn_caught") !is null) {
                    g_EntityFuncs.FireTargets("msg_hider_spawn_caught", pPlayer, pPlayer, USE_TOGGLE, 0);
                } else {
                    ClientMessage(pPlayer, "You are a HIDER\nYou've been caught :(\n\nWait for the next round, or until another hider sets you free.", m_sHudTextForHider);
                }
            } else {
                if (g_EntityFuncs.FindEntityByTargetname(null, "msg_hider_spawn") !is null) {
                    g_EntityFuncs.FireTargets("msg_hider_spawn", pPlayer, pPlayer, USE_TOGGLE, 0);
                } else {
                    ClientMessage(pPlayer, "You are a HIDER\nDon't get caught!", m_sHudTextForHider);
                }
            }

            return;
        }

        if (pPlayer.pev.targetname == "seeker") {
            if (g_EntityFuncs.FindEntityByTargetname(null, "msg_seeker_spawn") !is null) {
                g_EntityFuncs.FireTargets("msg_seeker_spawn", pPlayer, pPlayer, USE_TOGGLE, 0);
            } else {
                ClientMessage(pPlayer, "You are a SEEKER\nCapture those hiders!", m_sHudTextForSeeker);
            }

            g_EntityFuncs.FireTargets("seeker_equip", pPlayer, pPlayer, USE_ON, 0);

            return;
        }

        SetPlayerAsHider(pPlayer);
    }



    /*
     * -------------------------------------------------------------------------
     * Event functions
     * -------------------------------------------------------------------------
     */

    /**
     * Trigger: Show a brief message about the game rules. (If the activator is not a player show everyone.)
     * @param  CBaseEntity@ pActivator Activating entity
     * @param  CBaseEntity@ pCaller    Calling entity
     * @param  USE_TYPE     useType    Use type
     * @param  float        flValue    Use value
     * @return void
     */
    void ShowGameRules(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
    {
        string szMessage = "";
        snprintf(
            szMessage,
            "-- Hide and Seek --\n\n%1 seconds to hide, %2 seconds to seek.\n1 seeker per %3 hider(s) permitted. (There are currently %4.)\n\nUse console command \"hns\" to see more details.\n",
            m_piHideTime.GetInt(),
            m_piSeekTime.GetInt(),
            m_piHiderToSeekerRatio.GetInt(),
            m_iSeekers
        );

        HUDTextParams sShowGameRulesMsgParams;

        sShowGameRulesMsgParams.channel     = 1;
        sShowGameRulesMsgParams.x           = -1;
        sShowGameRulesMsgParams.y           = -1;
        sShowGameRulesMsgParams.effect      = 2;
        sShowGameRulesMsgParams.r1          = 100;
        sShowGameRulesMsgParams.g1          = 100;
        sShowGameRulesMsgParams.b1          = 100;
        sShowGameRulesMsgParams.r2          = 240;
        sShowGameRulesMsgParams.g2          = 240;
        sShowGameRulesMsgParams.b2          = 240;
        sShowGameRulesMsgParams.fadeinTime  = 0.01;
        sShowGameRulesMsgParams.fadeoutTime = 0.5;
        sShowGameRulesMsgParams.holdTime    = 10.0;
        sShowGameRulesMsgParams.fxTime      = 0.1;

        if (pActivator is null or !pActivator.IsPlayer() or !pActivator.IsAlive()) {
            g_PlayerFuncs.HudMessageAll(sShowGameRulesMsgParams, szMessage);
        } else {
            CBasePlayer@ pPlayer = cast<CBasePlayer@>(pActivator);
            g_PlayerFuncs.HudMessage(pPlayer, sShowGameRulesMsgParams, szMessage);
        }
    }

    /**
     * Game mode loop.
     * @return void
     */
    void Loop()
    {
        string szMessage = "";

        // Recount players and enforce properties
        int iHiders         = 0;
        int iHidersCaught   = 0;
        int iSeekers        = 0;

        for (int i = 1; i <= g_Engine.maxClients; i++) {
            CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
            if (pPlayer is null or !pPlayer.IsPlayer() or !pPlayer.IsConnected()) {
                continue;
            }

            CustomKeyvalues@ pPlayerExtra = pPlayer.GetCustomKeyvalues();

            // Block 3rd person view
            if (!m_pfTest.GetBool()) {
                pPlayer.SetViewMode(ViewMode_FirstPerson);
            }

            if (pPlayer.pev.targetname == "hider") {
                // Hiders...
                ++iHiders;
                SetPlayerAsHider(pPlayer);

                // Ensure equipment is stripped
                if (pPlayer.HasWeapons()) {
                    pPlayer.RemoveAllItems(false, false);
                }

                // Is the hider in the capture zone during seek time?
                if (m_szStage == "s" and (!pPlayer.IsAlive() or (m_pHiderCaptureZone !is null and g_Utility.IsPlayerInVolume(pPlayer, m_pHiderCaptureZone)))) {
                    ++iHidersCaught;
                }
            } else if (pPlayer.pev.targetname == "seeker") {
                // Seekers...
                ++iSeekers;
                SetPlayerAsSeeker(pPlayer);

                // Keep at full health
                if (pPlayer.IsAlive() && pPlayer.pev.health > 0.0 && pPlayer.pev.health < pPlayer.pev.max_health) {
                    pPlayer.pev.health = pPlayer.pev.max_health;
                }

                if (m_szStage == "s") {
                    // Is the seeker in the capture zone during seek time?
                    if (m_pHiderCaptureZone !is null and m_pHiderCaptureZone.IsBSPModel()) {
                        if (pPlayer.IsAlive() and g_Utility.IsPlayerInVolume(pPlayer, m_pHiderCaptureZone)) {
                            // Kill the seeker now
                            pPlayer.TakeDamage(null, null, (pPlayer.pev.max_health * 10), DMG_SLASH);
                            g_Game.AlertMessage(at_logged, "[H&S] Seeker \"%1\" slayed for entering the hider capture zone.\n", g_Utility.GetPlayerLog(pPlayer.edict()));

                            if (g_EntityFuncs.FindEntityByTargetname(null, "msg_seeker_in_hider_capture_zone") !is null) {
                                g_EntityFuncs.FireTargets("msg_seeker_in_hider_capture_zone", pPlayer, pPlayer, USE_TOGGLE, 0);
                            } else {
                                ClientMessage(pPlayer, "Seekers are not allowed to enter the hider capture zone.", m_sHudTextForSeeker, "vox/dadeda.wav");
                            }
                        }
                    }

                    // Is the seeker idle?
                    if (m_piSeekIdleTime.GetInt() >= 1 and m_pSeekerSpawnZone !is null and m_pSeekerSpawnZone.IsBSPModel()) {
                        if (g_Utility.IsPlayerInVolume(pPlayer, m_pSeekerSpawnZone)) {
                            pPlayerExtra.SetKeyvalue("seeker_idle", pPlayerExtra.HasKeyvalue("seeker_idle") ? pPlayerExtra.GetKeyvalue("seeker_idle").GetFloat() + MAP_LOOP_INTERVAL : MAP_LOOP_INTERVAL);

                            if (pPlayerExtra.HasKeyvalue("seeker_idle") and pPlayerExtra.GetKeyvalue("seeker_idle").GetFloat() >= m_piSeekIdleTime.GetFloat()) {
                                g_Game.AlertMessage(at_logged, "[H&S] Seeker \"%1\" changed to hider due to idling.\n", g_Utility.GetPlayerLog(pPlayer.edict()));

                                ClientMessage(pPlayer, "You are being moved to hiders due to idling as a seeker.", m_sHudTextForSeeker, "vox/dadeda.wav");

                                SetPlayerAsHider(pPlayer);
                            }
                        } else {
                            pPlayerExtra.SetKeyvalue("seeker_idle", 0.0f);
                        }
                    }
                }
            }
        }

        m_iHiders       = iHiders;
        m_iHidersCaught = iHidersCaught;
        m_iSeekers      = iSeekers;

        // No seekers message
        if (m_iSeekers < 1 and (m_flStageTimeLeft % 1) == 0) {
            g_PlayerFuncs.HudMessageAll(m_sHudTextNoSeekers, "NOBODY IS PLAYING AS A SEEKER\nIf you want to be a seeker say ''.seeker'' in text chat.");
        }

        // State
        string          szStateMessage  = "";
        string          szStateSound    = "";
        HUDTextParams   sStateMessage   = m_sHudTextTimeLeftNormal;

        if (m_flStageTimeLeft > -255.0f and !m_pfTest.GetBool()) {
            if (m_szStage == "w") {
                // Warm-up
                if (m_flStageTimeLeft <= 0.0f) {
                    PrepareHiderStart();
                } else if (m_flStageTimeLeft == 10.0f) {
                    szStateMessage = "Hiders will be set free in\n10 SECONDS";
                } else if (m_flStageTimeLeft == 30.0f) {
                    szStateMessage = "Hiders will be set free in\n30 SECONDS";
                } else if (m_flStageTimeLeft == 60.0f) {
                    szStateMessage = "Hiders will be set free in\n1 MINUTE";
                } else if (m_flStageTimeLeft == 120.0f) {
                    szStateMessage = "Hiders will be set free in\n2 MINUTES";
                } else if (m_flStageTimeLeft == 180.0f) {
                    szStateMessage = "Hiders will be set free in\n3 MINUTES";
                } else if (m_flStageTimeLeft == 240.0f) {
                    szStateMessage = "Hiders will be set free in\n4 MINUTES";
                } else if (m_flStageTimeLeft == 300.0f) {
                    szStateMessage = "Hiders will be set free in\n5 MINUTES";
                }

                if (szStateMessage != "" and szStateSound == "") {
                    szStateSound = "vox/doop.wav";
                }
            } else if (m_szStage == "h") {
                // Hiding
                if (m_flStageTimeLeft <= 0.0f) {
                    PrepareSeekerStart();
                } else if (m_flStageTimeLeft == 10.0f) {
                    szStateMessage = "Hiders, you have\n10 SECONDS\nleft to hide";
                } else if (m_flStageTimeLeft == 30.0f) {
                    szStateMessage = "Hiders, you have\n30 SECONDS\nleft to hide";
                } else if (m_flStageTimeLeft == 60.0f) {
                    szStateMessage = "Hiders, you have\n1 MINUTE\nleft to hide";
                } else if (m_flStageTimeLeft == 120.0f) {
                    szStateMessage = "Hiders, you have\n2 MINUTES\nleft to hide";
                } else if (m_flStageTimeLeft == 180.0f) {
                    szStateMessage = "Hiders, you have\n3 MINUTES\nleft to hide";
                } else if (m_flStageTimeLeft == 240.0f) {
                    szStateMessage = "Hiders, you have\n4 MINUTES\nleft to hide";
                } else if (m_flStageTimeLeft == 300.0f) {
                    szStateMessage = "Hiders, you have\n5 MINUTES\nleft to hide";
                }

                if (m_flStageTimeLeft == m_piHideTime.GetFloat()) {
                    snprintf(szStateMessage, "The HIDERS have been RELEASED!\n\n%1", szStateMessage);
                    szStateSound = "vox/buzwarn.wav";
                }

                if (m_flStageTimeLeft <= 10.0f) {
                    sStateMessage = m_sHudTextTimeLeftImminent;
                } else if (m_flStageTimeLeft <= 60.0f) {
                    sStateMessage = m_sHudTextTimeLeftShort;
                }

                if (szStateMessage != "" and szStateSound == "") {
                    szStateSound = "vox/doop.wav";
                }
            } else if (m_szStage == "s") {
                // Seeking
                if (m_flStageTimeLeft <= 0.0f) {
                    PrepareRoundEnd();
                } else if (m_flStageTimeLeft == 10.0f) {
                    szStateMessage = "Seekers, you have\n10 SECONDS\nleft to seek";
                } else if (m_flStageTimeLeft == 30.0f) {
                    szStateMessage = "Seekers, you have\n30 SECONDS\nleft to seek";
                } else if (m_flStageTimeLeft == 60.0f) {
                    szStateMessage = "Seekers, you have\n1 MINUTE\nleft to seek";
                } else if (m_flStageTimeLeft == 120.0f) {
                    szStateMessage = "Seekers, you have\n2 MINUTES\nleft to seek";
                } else if (m_flStageTimeLeft == 180.0f) {
                    szStateMessage = "Seekers, you have\n3 MINUTES\nleft to seek";
                } else if (m_flStageTimeLeft == 240.0f) {
                    szStateMessage = "Seekers, you have\n4 MINUTES\nleft to seek";
                } else if (m_flStageTimeLeft == 300.0f) {
                    szStateMessage = "Seekers, you have\n5 MINUTES\nleft to seek";
                }

                if (m_flStageTimeLeft == m_piSeekTime.GetFloat()) {
                    snprintf(szStateMessage, "The SEEKERS have been RELEASED!\n\n%1", szStateMessage);
                    szStateSound = "vox/buzwarn.wav";
                }

                if (m_flStageTimeLeft <= 10.0f) {
                    sStateMessage = m_sHudTextTimeLeftImminent;
                } else if (m_flStageTimeLeft <= 60.0f) {
                    sStateMessage = m_sHudTextTimeLeftShort;
                }

                if (szStateMessage != "" and szStateSound == "") {
                    szStateSound = "vox/doop.wav";
                }

                // Any hiders left uncaught?
                if (
                    m_iHiders >= 1 and
                    m_iHidersCaught >= 1 and
                    m_iHidersCaught >= m_iHiders and
                    m_flStageTimeLeft < (m_piSeekTime.GetFloat() - 3.0f)
                ) {
                    // All hiders have been caught, no chance of escape. Finish round now.
                    PrepareHiderAllCaught();
                }
            } else if (m_szStage == "sw") {
                if (m_flStageTimeLeft <= 0.0f) {
                    PrepareRoundEnd();
                }
            } else if (m_szStage == "e") {
                if (m_flStageTimeLeft <= 0.0f) {
                    PrepareRoundStart();
                }
            }
        }

        if (szStateMessage != "" and sStateMessage.channel != 0) {
            g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, szStateMessage + "\n");
            g_PlayerFuncs.HudMessageAll(sStateMessage, szStateMessage);
            g_Game.AlertMessage(at_logged, "[H&S] Stage \"%1\": %2 seconds remaining.\n", m_szStage, m_flStageTimeLeft);
        }

        if (szStateSound != "") {
            EmitSoundDynToAll(CHAN_AUTO, szStateSound, 1.0, 0.0);
        }

        // Update information entity for the map
        if (m_pInfo !is null and m_pInfo.pev.classname == "info_target") {
            m_pInfo.KeyValue("stage",                       m_szStage);
            m_pInfo.KeyValue("stage_timeleft",              m_flStageTimeLeft);
            m_pInfo.KeyValue("player_count",                g_PlayerFuncs.GetNumPlayers());
            m_pInfo.KeyValue("hider_count",                 m_iHiders);
            m_pInfo.KeyValue("hider_count_caught",          m_iHidersCaught);
            m_pInfo.KeyValue("hider_release_reset_time",    m_flHiderReleaseTimeLeft);
            m_pInfo.KeyValue("seeker_count",                m_iSeekers);
        }
        //g_Game.AlertMessage(at_console, GetDebugString());

        // Decrement time remaining for this stage
        if (m_flStageTimeLeft > -255.0f and !m_pfTest.GetBool()) {
            m_flStageTimeLeft -= MAP_LOOP_INTERVAL;
        }

        // Decrement time remaining for hider release reset
        if (m_flHiderReleaseTimeLeft > 0.0f and !m_pfTest.GetBool()) {
            m_flHiderReleaseTimeLeft -= MAP_LOOP_INTERVAL;
        }
    }

    /**
     * Event: Round start.
     * @return void
     */
    void PrepareRoundStart()
    {
        if (g_EntityFuncs.FindEntityByTargetname(null, "on_round_start") !is null) {
            g_EntityFuncs.FireTargets("on_round_start", null, null, USE_TOGGLE, 0);
        } else {
            HandleRoundStart(null, null, USE_TOGGLE, 0);
        }
    }

    /**
     * Event: Round start, map is ready to proceed.
     * @param  CBaseEntity@ pActivator Activating entity
     * @param  CBaseEntity@ pCaller    Calling entity
     * @param  USE_TYPE     useType    Use type
     * @param  float        flValue    Use value
     * @return void
     */
    void HandleRoundStart(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
    {
        m_szStage           = "w";
        m_flStageTimeLeft   = m_piWarmupTime.GetFloat();
        g_Game.AlertMessage(at_logged, "[H&S] Round reset.\n");

        g_EntityFuncs.FireTargets("spawn_hider", null, null, USE_ON, 0);
        g_EntityFuncs.FireTargets("spawn_hider_caught", null, null, USE_OFF, 0);

        for (int i = 1; i <= g_Engine.maxClients; i++) {
            CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
            if (pPlayer is null or !pPlayer.IsPlayer() or !pPlayer.IsConnected()) {
                continue;
            }

            CustomKeyvalues@ pPlayerExtra = pPlayer.GetCustomKeyvalues();

            if (!pPlayer.IsAlive()) {
                g_PlayerFuncs.RespawnPlayer(pPlayer, true, true);
            }

            if (pPlayerExtra.HasKeyvalue("hider_won")) {
                if (pPlayerExtra.GetKeyvalue("hider_won").GetFloat() >= 1.0f) {
                    pPlayer.pev.frags += m_piHiderUncaughtScore.GetInt();
                    // g_Game.AlertMessage(at_logged, "[H&S] Hider \"%1\" won.\n", g_Utility.GetPlayerLog(pPlayer.edict()));

                    if (g_EntityFuncs.FindEntityByTargetname(null, "msg_hider_winner") !is null) {
                        g_EntityFuncs.FireTargets("msg_hider_winner", pPlayer, pPlayer, USE_TOGGLE, 0);
                    } else {
                        ClientMessage(pPlayer, "You escaped that round. Well done!", m_sHudTextForHider, "vox/bloop.wav");
                    }
                } else if (pPlayerExtra.GetKeyvalue("hider_won").GetFloat() <= -1.0f) {
                    // g_Game.AlertMessage(at_logged, "[H&S] Hider \"%1\" lost.\n", g_Utility.GetPlayerLog(pPlayer.edict()));
                }

                pPlayerExtra.SetKeyvalue("hider_won", 0.0f);
            }
        }
    }

    /**
     * Event: Hider start.
     * @return void
     */
    void PrepareHiderStart()
    {
        m_flStageTimeLeft = -255.0f;

        if (g_EntityFuncs.FindEntityByTargetname(null, "on_hider_start") !is null) {
            g_EntityFuncs.FireTargets("on_hider_start", null, null, USE_TOGGLE, 0);
        } else {
            HandleHiderStart(null, null, USE_TOGGLE, 0);
        }
    }

    /**
     * Event: Hider start, map is ready to proceed.
     * @param  CBaseEntity@ pActivator Activating entity
     * @param  CBaseEntity@ pCaller    Calling entity
     * @param  USE_TYPE     useType    Use type
     * @param  float        flValue    Use value
     * @return void
     */
    void HandleHiderStart(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
    {
        m_szStage           = "h";
        m_flStageTimeLeft   = m_piHideTime.GetFloat();
        g_Game.AlertMessage(at_logged, "[H&S] Hiders released.\n");
    }

    /**
     * Event: Seeker start.
     * @return void
     */
    void PrepareSeekerStart()
    {
        m_flStageTimeLeft = -255.0f;

        if (g_EntityFuncs.FindEntityByTargetname(null, "on_seeker_start") !is null) {
            g_EntityFuncs.FireTargets("on_seeker_start", null, null, USE_TOGGLE, 0);
        } else {
            HandleSeekerStart(null, null, USE_TOGGLE, 0);
        }
    }

    /**
     * Event: Seeker start, map is ready to proceed.
     * @param  CBaseEntity@ pActivator Activating entity
     * @param  CBaseEntity@ pCaller    Calling entity
     * @param  USE_TYPE     useType    Use type
     * @param  float        flValue    Use value
     * @return void
     */
    void HandleSeekerStart(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
    {
        m_szStage           = "s";
        m_flStageTimeLeft   = m_piSeekTime.GetFloat();
        g_Game.AlertMessage(at_logged, "[H&S] Seekers released.\n");

        g_EntityFuncs.FireTargets("spawn_hider", null, null, USE_OFF, 0);
        g_EntityFuncs.FireTargets("spawn_hider_caught", null, null, USE_ON, 0);
    }

    /**
     * Event: Hider caught.
     * @param  CBasePlayer@ pHider  Hider
     * @param  CBasePlayer@ pSeeker Seeker
     * @return void
     */
    void PrepareHiderCaught(CBasePlayer@ pHider, CBasePlayer@ pSeeker)
    {
        if (g_EntityFuncs.FindEntityByTargetname(null, "on_hider_caught") !is null) {
            g_EntityFuncs.FireTargets("on_hider_caught", pHider, pSeeker, USE_TOGGLE, 0);
        } else {
            // See below...
        }

        // This must always run immediately regardless of the map due to the map's "trigger_script" being unable to pass parameters to `HandleHiderCaught()`.
        HandleHiderCaught(pHider, pSeeker);
    }

    /**
     * Event: Hider caught, map is ready to proceed.
     * @param  CBasePlayer@ pHider  Hider
     * @param  CBasePlayer@ pSeeker Seeker
     * @return void
     */
    void HandleHiderCaught(CBasePlayer@ pHider, CBasePlayer@ pSeeker)
    {
        g_Game.AlertMessage(at_logged, "[H&S] \"%1\" has been caught by \"%2\".\n", g_Utility.GetPlayerLog(pHider.edict()), g_Utility.GetPlayerLog(pSeeker.edict()));

        string szMessage = "";
        snprintf(szMessage, "Hider \"%1\" has been caught by seeker \"%2\".\n", pHider.pev.netname, pSeeker.pev.netname);
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, szMessage);
    }

    /**
     * Trigger: Hider has released captive hiders.
     * @param  CBaseEntity@ pActivator Activating entity
     * @param  CBaseEntity@ pCaller    Calling entity
     * @param  USE_TYPE     useType    Use type
     * @param  float        flValue    Use value
     * @return void
     */
    void DoHiderRelease(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
    {
        if (pActivator is null or !pActivator.IsPlayer() or !pActivator.IsAlive()) {
            return;
        }

        string szMessage = "";
        CBasePlayer@ pPlayer = cast<CBasePlayer@>(pActivator);

        if (pPlayer.pev.targetname != "hider") {
            ClientMessage(pPlayer, "Only hiders are permitted to release captured hiders.", m_sHudTextForSeeker, "vox/dadeda.wav");
            return;
        }

        if (m_flHiderReleaseTimeLeft > 0.0f) {
            ClientMessage(pPlayer, "You cannot release captured hiders again so soon.", m_sHudTextForHider, "vox/dadeda.wav");
            return;
        }

        if (m_szStage != "s") {
            ClientMessage(pPlayer, "You cannot release captured hiders before the round has begun.", m_sHudTextForHider, "vox/dadeda.wav");
            return;
        }

        PrepareHiderRelease(pPlayer);
    }

    /**
     * Event: Hider release.
     * @param  CBasePlayer@ pHider Hider
     * @return void
     */
    void PrepareHiderRelease(CBasePlayer@ pHider)
    {
        if (g_EntityFuncs.FindEntityByTargetname(null, "on_hider_release") !is null) {
            g_EntityFuncs.FireTargets("on_hider_release", pHider, pHider, USE_TOGGLE, 0);
        } else {
            HandleHiderRelease(pHider);
        }
    }

    /**
     * Event: Hider release, map is ready to proceed.
     * @param  CBasePlayer@ pHider Hider
     * @return void
     */
    void HandleHiderRelease(CBasePlayer@ pHider)
    {
        g_Game.AlertMessage(at_logged, "[H&S] Caught hiders released by \"%1\".\n", g_Utility.GetPlayerLog(pHider.edict()));
        pHider.pev.frags += m_piHiderReleaseScore.GetInt();
        m_flHiderReleaseTimeLeft = m_piHiderReleaseResetTime.GetInt();

        string szMessage = "CAPTURED HIDERS HAVE BEEN RELEASED!";
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, szMessage + "\n");

        if (g_EntityFuncs.FindEntityByTargetname(null, "msg_hider_release") !is null) {
            g_EntityFuncs.FireTargets("msg_hider_release", null, null, USE_TOGGLE, 0);
        } else {
            m_sHudTextForHiders.holdTime = Math.clamp(1, m_piHiderReleaseResetTime.GetInt(), m_piHiderReleaseResetTime.GetInt());
            g_PlayerFuncs.HudMessageAll(m_sHudTextForHiders, szMessage);
            EmitSoundDynToAll(CHAN_AUTO, "vox/buzwarn.wav", 1.0, 0.0);
        }
    }

    /**
     * Event: All hiders caught.
     * @return void
     */
    void PrepareHiderAllCaught()
    {
        m_flStageTimeLeft = -255.0f;

        if (g_EntityFuncs.FindEntityByTargetname(null, "on_hider_all_caught") !is null) {
            g_EntityFuncs.FireTargets("on_hider_all_caught", null, null, USE_TOGGLE, 0);
        } else {
            HandleHiderAllCaught(null, null, USE_TOGGLE, 0);
        }
    }

    /**
     * Event: All hiders caught, map is ready to proceed.
     * @param  CBaseEntity@ pActivator Activating entity
     * @param  CBaseEntity@ pCaller    Calling entity
     * @param  USE_TYPE     useType    Use type
     * @param  float        flValue    Use value
     * @return void
     */
    void HandleHiderAllCaught(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
    {
        m_szStage           = "sw";
        m_flStageTimeLeft   = 8.0f;
        g_Game.AlertMessage(at_logged, "[H&S] Caught all hiders, seekers win.\n");

        string szMessage = "ALL HIDERS HAVE BEEN CAUGHT -- SEEKERS WIN!";
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, szMessage + "\n");

        if (g_EntityFuncs.FindEntityByTargetname(null, "msg_seeker_winner") !is null) {
            g_EntityFuncs.FireTargets("msg_seeker_winner", null, null, USE_TOGGLE, 0);
        } else {
            g_PlayerFuncs.HudMessageAll(m_sHudTextForSeekers, szMessage);
            EmitSoundDynToAll(CHAN_AUTO, "vox/buzwarn.wav", 1.0, 0.0);
        }
    }

    /**
     * Event: Round end.
     * @return void
     */
    void PrepareRoundEnd()
    {
        m_flStageTimeLeft = -255.0f;

        if (g_EntityFuncs.FindEntityByTargetname(null, "on_round_end") !is null) {
            g_EntityFuncs.FireTargets("on_round_end", null, null, USE_TOGGLE, 0);
        } else {
            HandleRoundEnd(null, null, USE_TOGGLE, 0);
        }
    }

    /**
     * Event: Round end, map is ready to proceed.
     * @param  CBaseEntity@ pActivator Activating entity
     * @param  CBaseEntity@ pCaller    Calling entity
     * @param  USE_TYPE     useType    Use type
     * @param  float        flValue    Use value
     * @return void
     */
    void HandleRoundEnd(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
    {
        m_szStage           = "e";
        m_flStageTimeLeft   = 5.0f;
        g_Game.AlertMessage(at_logged, "[H&S] Round ended.\n");

        for (int i = 1; i <= g_Engine.maxClients; i++) {
            CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
            if (pPlayer is null or !pPlayer.IsPlayer() or !pPlayer.IsConnected()) {
                continue;
            }

            CustomKeyvalues@ pPlayerExtra = pPlayer.GetCustomKeyvalues();

            if (pPlayer.pev.targetname == "hider") {
                // Determine which hiders won this round
                if (!pPlayer.IsAlive() or m_pHiderCaptureZone is null or g_Utility.IsPlayerInVolume(pPlayer, m_pHiderCaptureZone)) {
                    pPlayerExtra.SetKeyvalue("hider_won", -1.0f);
                    g_Game.AlertMessage(at_logged, "[H&S] Hider \"%1\" lost.\n", g_Utility.GetPlayerLog(pPlayer.edict()));
                } else {
                    pPlayerExtra.SetKeyvalue("hider_won", 1.0f);
                    g_Game.AlertMessage(at_logged, "[H&S] Hider \"%1\" won.\n", g_Utility.GetPlayerLog(pPlayer.edict()));
                }
            } else if (pPlayer.pev.targetname == "seeker") {
                // Switch all seekers back to hiders
                pPlayer.pev.targetname = "hider";
                pPlayer.pev.health = pPlayer.pev.max_health = 100;
                pPlayer.RemoveAllItems(false, false);
                g_PlayerFuncs.ApplyMapCfgToPlayer(pPlayer, true);
                pPlayer.SendScoreInfo();

                g_Game.AlertMessage(at_logged, "[H&S] Seeker \"%1\" changed to hider at the end of round.", g_Utility.GetPlayerLog(pPlayer.edict()));
            }
        }

        g_EntityFuncs.FireTargets("spawn_hider", null, null, USE_ON, 0);
        g_EntityFuncs.FireTargets("spawn_hider_caught", null, null, USE_OFF, 0);

        g_PlayerFuncs.RespawnAllPlayers(true, true);

        string szMessage = "ROUND RESET";
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, szMessage + "\n");

        if (g_EntityFuncs.FindEntityByTargetname(null, "msg_round_reset") !is null) {
            g_EntityFuncs.FireTargets("msg_round_reset", null, null, USE_TOGGLE, 0);
        } else {
            g_PlayerFuncs.HudMessageAll(m_sHudTextForAll, szMessage);
            EmitSoundDynToAll(CHAN_AUTO, "vox/buzwarn.wav", 1.0, 0.0);
        }
    }
}

HideAndSeek@ g_HideAndSeek;

/**
 * Map loop.
 * @return void
 */
void MapLoop()
{
    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit() or g_HideAndSeek.GetStage() == "") {
        return;
    }

    g_HideAndSeek.Loop();
}

/**
 * Map end.
 * @return void
 */
void MapEnd()
{
    CBaseEntity@ pEnd = g_EntityFuncs.CreateEntity("game_end", null, true);
    pEnd.Use(null, null, USE_ON, 0);
}

/**
 * Map incompatible message.
 * @param  CBasePlayer@ pPlayer Player to send message to, or null for all
 * @return void
 */
void MapIncompatibleMessage(CBasePlayer@ pPlayer = null)
{
    HUDTextParams sMapIncompatibleMsgParams;

    sMapIncompatibleMsgParams.channel       = 1;
    sMapIncompatibleMsgParams.x             = -1;
    sMapIncompatibleMsgParams.y             = -1;
    sMapIncompatibleMsgParams.effect        = 1;
    sMapIncompatibleMsgParams.r1            = 100;
    sMapIncompatibleMsgParams.g1            = 0;
    sMapIncompatibleMsgParams.b1            = 0;
    sMapIncompatibleMsgParams.r2            = 240;
    sMapIncompatibleMsgParams.g2            = 0;
    sMapIncompatibleMsgParams.b2            = 0;
    sMapIncompatibleMsgParams.fadeinTime    = 0;
    sMapIncompatibleMsgParams.fadeoutTime   = 0;
    sMapIncompatibleMsgParams.holdTime      = 20.0;
    sMapIncompatibleMsgParams.fxTime        = 0.1;

    string szMapIncompatible = "Hide and Seek is not compatible with this map.\n\nEnding immediately...";

    if (pPlayer is null) {
        g_PlayerFuncs.ClientPrintAll(HUD_PRINTCONSOLE, szMapIncompatible);
        g_PlayerFuncs.HudMessageAll(sMapIncompatibleMsgParams, szMapIncompatible);
    } else {
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, szMapIncompatible);
        g_PlayerFuncs.HudMessage(pPlayer, sMapIncompatibleMsgParams, szMapIncompatible);
    }
}

/**
 * Map initialisation handler.
 * @return void
 */
void MapInit()
{
    g_Module.ScriptInfo.SetAuthor("Adam \"Adambean\" Reece");
    g_Module.ScriptInfo.SetContactInfo("www.svencoop.com");

    g_SoundSystem.PrecacheSound("vox/bloop.wav");
    g_SoundSystem.PrecacheSound("vox/buzwarn.wav");
    g_SoundSystem.PrecacheSound("vox/dadeda.wav");
    g_SoundSystem.PrecacheSound("vox/doop.wav");

    if (g_HideAndSeek is null) {
        @g_HideAndSeek = HideAndSeek();
    }
}

/**
 * Map activation handler.
 * @return void
 */
void MapActivate()
{
    if (g_HideAndSeek is null) {
        @g_HideAndSeek = HideAndSeek();
    }

    if (!g_HideAndSeek.Initialise()) {
        g_Game.AlertMessage(at_error, "Hide and Seek failed to initialise. Ending map...\n");
        g_Scheduler.SetTimeout("MapIncompatibleMessage", 5.0, null);
        g_Scheduler.SetTimeout("MapEnd", 15.0);
        @g_HideAndSeek = null;
        return;
    }

    g_Game.AlertMessage(at_console, "Hide and Seek ready.\n");
}

/**
 * Text chat handler.
 * @param  SayParameters@ pParams Parameters
 * @return HookReturnCode
 */
HookReturnCode ClientSay(SayParameters@ pParams)
{
    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit()) {
        return HOOK_CONTINUE;
    }

    CBasePlayer@ pPlayer    = pParams.GetPlayer();
    const CCommand@ args    = pParams.GetArguments();
    string szResponse       = "";

    if (pPlayer is null) {
        return HOOK_CONTINUE;
    }

    if (!pPlayer.IsPlayer() or !pPlayer.IsConnected()) {
        return HOOK_CONTINUE;
    }

    if (args.ArgC() < 1 or args[0][0] != ".") {
        return HOOK_CONTINUE;
    }

    // Become a hider
    if (args[0] == ".hider") {
        if (pPlayer.pev.targetname == "hider") {
            g_PlayerFuncs.SayText(pPlayer, "You are already a hider.\n");

            return HOOK_HANDLED;
        }

        g_HideAndSeek.SetPlayerAsHider(pPlayer);

        return HOOK_HANDLED;
    }

    // Become a seeker
    if (args[0] == ".seeker") {
        if (pPlayer.pev.targetname == "seeker") {
            g_PlayerFuncs.SayText(pPlayer, "You are already a seeker.\n");

            return HOOK_HANDLED;
        }

        int iSeekers            = g_HideAndSeek.GetSeekerCount();
        int iSeekerLimit        = g_HideAndSeek.GetSeekerLimit();
        int iHiderToSeekerRatio = g_HideAndSeek.GetHiderToSeekerRatio();

        if (iSeekers >= iSeekerLimit) {
            snprintf(szResponse, "There are already the maximum number of seekers permitted (%1) for the current player count.\n1 seeker is allowed for every %2 total players.\n", iSeekerLimit, iHiderToSeekerRatio);
            g_PlayerFuncs.SayText(pPlayer, szResponse);

            return HOOK_HANDLED;
        }

        g_HideAndSeek.SetPlayerAsSeeker(pPlayer);

        return HOOK_HANDLED;
    }

    return HOOK_CONTINUE;
}

/**
 * Player join handler.
 * @param  CBasePlayer@   pPlayer Player
 * @return HookReturnCode
 */
HookReturnCode ClientPutInServer(CBasePlayer@ pPlayer)
{
    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit()) {
        MapIncompatibleMessage(pPlayer);
        return HOOK_CONTINUE;
    }

    g_HideAndSeek.SetPlayerAsHider(pPlayer);

    if (g_HideAndSeek.GetStage() == "") {
        g_HideAndSeek.PrepareRoundStart();
    }

    return HOOK_CONTINUE;
}

/**
 * Player spawn handler.
 * @param  CBasePlayer@   pPlayer Player
 * @return HookReturnCode
 */
HookReturnCode PlayerSpawn(CBasePlayer@ pPlayer)
{
    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit()) {
        MapIncompatibleMessage(pPlayer);
        return HOOK_CONTINUE;
    }

    g_HideAndSeek.HandlePlayerSpawn(pPlayer);

    return HOOK_CONTINUE;
}

/**
 * Player disconnect handler.
 * @param  CBasePlayer@   pPlayer Player
 * @return HookReturnCode
 */
HookReturnCode ClientDisconnect(CBasePlayer@ pPlayer)
{
    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit()) {
        return HOOK_CONTINUE;
    }

    pPlayer.pev.targetname = "";

    return HOOK_CONTINUE;
}

/**
 * Player killed handler.
 * @param  CBasePlayer@   pPlayer    Killed player
 * @param  CBaseEntity@   pKiller    Killer entity
 * @param  int            iInflictor Inflictor
 * @return HookReturnCode
 */
HookReturnCode PlayerKilled(CBasePlayer@ pKilledPlayer, CBaseEntity@ pKiller, int iInflictor)
{
    if (pKiller.pev.targetname != "seeker" or !pKiller.IsPlayer()) {
        return HOOK_CONTINUE; // Killer is not a seeker
    }

    if (pKilledPlayer.pev.targetname != "hider") {
        return HOOK_CONTINUE; // Killed is not a hider
    }

    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit()) {
        return HOOK_CONTINUE;
    }

    g_HideAndSeek.PrepareHiderCaught(pKilledPlayer, cast<CBasePlayer@>(pKiller));
    return HOOK_HANDLED;
}

/**
 * Same as `CSoundEngine::EmitSoundDyn()` but to all players in one go.
 * @return void
 */
void EmitSoundDynToAll(SOUND_CHANNEL channel, const string& in szSample, float flVolume, float flAttenuation, int iFlags = 0, int iPitch = PITCH_NORM)
{
    for (int i = 1; i <= g_Engine.maxClients; i++) {
        CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex(i);
        if (pPlayer is null or !pPlayer.IsPlayer() or !pPlayer.IsConnected()) {
            continue;
        }

        g_SoundSystem.EmitSoundDyn(pPlayer.edict(), channel, szSample, flVolume, flAttenuation, iFlags, iPitch, pPlayer.entindex());
    }
}

void ClientMessage(CBasePlayer@ pPlayer, const string& in szMessage, HUDTextParams sHudTextParams, const string& in szSound = "")
{
    if (szMessage != "") {
        g_PlayerFuncs.ClientPrint(pPlayer, HUD_PRINTCONSOLE, szMessage + "\n");
        g_PlayerFuncs.HudMessage(pPlayer, sHudTextParams, szMessage);
    }

    if (szSound != "") {
        g_SoundSystem.EmitSoundDyn(pPlayer.edict(), CHAN_AUTO, szSound, 1.0, 0.0, 0, PITCH_NORM, pPlayer.entindex());
    }
}

void ShowGameRules(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit()) {
        return;
    }

    g_HideAndSeek.ShowGameRules(pActivator, pCaller, useType, flValue);
}

/*
bool GetPlayersForZone(CBaseEntity@ pZone, const bool fIgnoreDeadPlayers, array<CBasePlayer@>& out aIn, array<CBasePlayer@>& out aOut, int& out iIn, int& out iOut)
{
    if (pZone is null or !pZone.IsBSPModel()) {
        return false;
    }

    int iCount = g_Utility.CountPlayersInBrushVolume(fIgnoreDeadPlayers, pZone, iIn, iOut, pListener);
}
 */

void HandleRoundStart(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit()) {
        return;
    }

    g_HideAndSeek.HandleRoundStart(pActivator, pCaller, useType, flValue);
}

void HandleHiderStart(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit()) {
        return;
    }

    g_HideAndSeek.HandleHiderStart(pActivator, pCaller, useType, flValue);
}

void HandleSeekerStart(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit()) {
        return;
    }

    g_HideAndSeek.HandleSeekerStart(pActivator, pCaller, useType, flValue);
}

void HandleHiderCaught(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
    return; // This won't ever work. See `PrepareHiderCaught()` for reasons.

    /*
    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit()) {
        return;
    }

    if (pActivator is null or !pActivator.IsPlayer() or !pActivator.IsAlive() or pActivator.pev.targetname != "hider") {
        return;
    }

    if (pCaller is null or !pCaller.IsPlayer() or !pCaller.IsAlive() or pCaller.pev.targetname != "seeker") {
        return;
    }

    g_HideAndSeek.HandleHiderCaught(cast<CBasePlayer@>(pActivator), cast<CBasePlayer@>(pCaller));
     */
}

void DoHiderRelease(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit()) {
        return;
    }

    g_HideAndSeek.DoHiderRelease(pActivator, pCaller, useType, flValue);
}

void HandleHiderRelease(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit()) {
        return;
    }

    if (pActivator is null or !pActivator.IsPlayer() or !pActivator.IsAlive() or pActivator.pev.targetname != "hider") {
        return;
    }

    g_HideAndSeek.HandleHiderRelease(cast<CBasePlayer@>(pActivator));
}

void HandleHiderAllCaught(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit()) {
        return;
    }

    g_HideAndSeek.HandleHiderAllCaught(pActivator, pCaller, useType, flValue);
}

void HandleRoundEnd(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
    if (g_HideAndSeek is null or !g_HideAndSeek.GetMapSeemsLegit()) {
        return;
    }

    g_HideAndSeek.HandleRoundEnd(pActivator, pCaller, useType, flValue);
}
