Vector VecCheckThrow( edict_t@& in pEdict, const Vector& in vecSpot1, Vector vecSpot2, const float flSpeed, const float flGravityAdj = 1.0 )
{
        //float flGravity = g_EngineFuncs.CVarGetFloat( "sv_gravity" ) * flGravityAdj; // Use this, but not the other two
		float flGravity = 800.0f * flGravityAdj;  // This one works. Temporary fix for game thinking sv_gravity is void.
		/*	Or use this but not the other two
		
		float flGravity = 0.0f;
		flGravity = g_EngineFuncs.CVarGetFloat( "sv_gravity" );
		flGravity *= flGravityAdj; */
 
        Vector vecGrenadeVel = (vecSpot2 - vecSpot1);
 
        // throw at a constant time
        float time = vecGrenadeVel.Length( ) / flSpeed;
        vecGrenadeVel = vecGrenadeVel * (1.0 / time);
 
        // adjust upward toss to compensate for gravity loss
        vecGrenadeVel.z += flGravity * time * 0.5;
 
        Vector vecApex = vecSpot1 + (vecSpot2 - vecSpot1) * 0.5;
        vecApex.z += 0.5 * flGravity * (time * 0.5) * (time * 0.5);
       
        TraceResult tr;
        g_Utility.TraceLine(vecSpot1, vecApex, dont_ignore_monsters, pEdict, tr);
        if (tr.flFraction != 1.0)
                return g_vecZero; // fail!
 
        g_Utility.TraceLine(vecSpot2, vecApex, ignore_monsters, pEdict, tr);
        if (tr.flFraction != 1.0)
                return g_vecZero; // fail!
 
        return vecGrenadeVel;
}


class func_tankgrenade : ScriptBaseTankEntity
{
	int m_iBurstCounter = 3; // Shots fired before cooldown delay
	
	void Fire( const Vector& in vecBarrelEnd, const Vector& in vecForward, entvars_t@ pevAttacker )
	{
		if( m_iBurstCounter <= 0 )
		{
				m_iBurstCounter = 3;
				self.m_flNextAttack = g_Engine.time + 8; // Cooldown delay after burst counter limit is reached
		}
		else
		{
			if( self.m_flNextAttack <= g_Engine.time )
			{
				CBaseEntity@ pTargetEnt = self.FindTarget();
				if (pTargetEnt !is null)
				{
				   Vector vecToss = VecCheckThrow( self.edict(), vecBarrelEnd, pTargetEnt.Center(), 800.0f, 0.7f );
				   g_SoundSystem.PlaySound( self.edict(), CHAN_WEAPON, "weapons/glauncher.wav", 1.0f, 1.0f, 0, 100 );
				   g_EntityFuncs.ShootContact( self.pev, vecBarrelEnd, vecToss );
				   m_iBurstCounter--; // Subtract 1 from the burst counter every time a grenade is launched
				   self.m_flNextAttack = g_Engine.time + 0.1f;
				}
			}
		}
	}
}