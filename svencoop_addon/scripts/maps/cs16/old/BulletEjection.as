void CS16GetDefaultShellInfo( CBasePlayer@ pPlayer, Vector& out ShellVelocity, Vector& out ShellOrigin, float forwardScale, float rightScale, float upScale, bool leftShell, bool downShell )
{
	Vector vecForward, vecRight, vecUp;

	float fR;
	float fU;
	
	g_EngineFuncs.AngleVectors( pPlayer.pev.v_angle, vecForward, vecRight, vecUp );
	
	( leftShell == true ) ? fR = Math.RandomFloat( -70, -50 ) : fR = Math.RandomFloat( 50, 70 );
	( downShell == true ) ? fU = Math.RandomFloat( -150, -100 ) : fU = Math.RandomFloat( 100, 150 );
 
	for( int i = 0; i < 3; ++i )
	{
		ShellVelocity[i] = pPlayer.pev.velocity[i] + vecRight[i] * fR + vecUp[i] * fU + vecForward[i] * 25;
		ShellOrigin[i]   = pPlayer.pev.origin[i] + pPlayer.pev.view_ofs[i] + vecUp[i] * upScale + vecForward[i] * forwardScale + vecRight[i] * rightScale;
	}
}

const int CS_9mm_MAX_CARRY  	= 120; //For Glock, Mp5, Tmp and Dual Berettas
const int CS_556_MAX_CARRY  	= 90;  //For AUG, M4A1, FAMAS, Galil, SG552, SG550
const int CS_762_MAX_CARRY  	= 90;  //For Ak47, G3Sg1, Scout
const int CS_45acp_MAX_CARRY	= 100; //For USP, UMP-45, MAC-10
const int CS_57_MAX_CARRY   	= 100; //For Five-Seven, P90
const int CS_buckshot_MAX_CARRY	= 32;  //For M3, Xm1014

enum CS16SilencedMode_e
{
	CS16_MODE_NOSILENCER = 0,
	CS16_MODE_SILENCER
};

enum CS16ScopeMode_e
{
	CS16_MODE_UNSCOPE = 0,
	CS16_MODE_SCOPE
};

enum CS16DualScopeMode_e
{
	CS16_MODE_NOSCOPE = 0,
	CS16_MODE_SCOPED,
	CS16_MODE_MORESCOPE
};

enum CS16BurstFire_e
{
	CS16_MODE_NOBURST = 0,
	CS16_MODE_BURST
};