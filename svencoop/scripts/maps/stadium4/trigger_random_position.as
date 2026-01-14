class trigger_random_position : ScriptBaseEntity
{
	float fX_Tolerance = 0;
	float fY_Tolerance = 0;
	float fZ_Tolerance = 0;
	int iUse_Random_Angles = 0;
	string szTargetEntity = "";
	string szTriggerAfterMove = "";
	
	bool KeyValue( const string& in szKey, const string& in szValue )
	{
		if(szKey == "xtolerance") // Units plus or minus this entity's origin where the target entity will be sent on the X axis
		{
			fX_Tolerance = atof( szValue );
			return true;
		}
		else if(szKey == "ytolerance") // Units plus or minus this entity's origin where the target entity will be sent on the Y axis
		{
			fY_Tolerance = atof( szValue );
			return true;
		}
		else if(szKey == "ztolerance") // Units plus or minus this entity's origin where the target entity will be sent on the Z axis
		{
			fZ_Tolerance = atof( szValue );
			return true;
		}
		else if(szKey == "random_angles")
		{
			iUse_Random_Angles = atoi( szValue );
			return true;
		}
		else if(szKey == "targetent") // The entity to be sent to a random position
		{
			szTargetEntity = szValue;
			return true;
		}
		else if(szKey == "trigger_after_move") // Target to be triggered after the position has been set
		{
			szTriggerAfterMove = szValue;
			return true;
		}
		else
			return BaseClass.KeyValue( szKey, szValue );
	}
	
	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue = 0.0f )
	{
		Vector vecEntOrigin = self.pev.origin;
		CBaseEntity@ ent = null;
		
		while( ( @ent = g_EntityFuncs.FindEntityByTargetname( ent, szTargetEntity ) ) !is null )
		{
			Vector vecRandOrigin = vecEntOrigin + Vector( Math.RandomFloat(-fX_Tolerance, fX_Tolerance), Math.RandomFloat(-fY_Tolerance, fY_Tolerance), Math.RandomFloat(-fZ_Tolerance, fZ_Tolerance) ); // Using the original entity as the center origin, generates random X Y Z coordinates limited by the given tolerances
			
			g_EntityFuncs.SetOrigin( @ent, vecRandOrigin ); // Sets the origin of the target entity
			
			if( iUse_Random_Angles >= 1 )
			{
				ent.pev.angles = Vector(0, Math.RandomFloat( 0, 359 ), 0); // Sets a random angle on the target entity
			}
		}
		
		g_EntityFuncs.FireTargets( szTriggerAfterMove, @self, @self, USE_SET, flValue ); // Triggers a target entity once the position has been set
		
	}
}