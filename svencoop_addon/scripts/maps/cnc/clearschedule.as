void ClearAISchedule(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	
	CBaseEntity@ entity = pActivator;
	
	CBaseMonster@ pMonster = cast<CBaseMonster@>( entity );

	//Monsters only
	if( pMonster is null )
	{
		return;
	}
	
	pMonster.m_hGuardEnt = null;
	pMonster.m_iszGuardEntName = ""; 
	
	pMonster.KeyValue("guard_ent","");
	pMonster.StopPlayerFollowing(true,false);
	pMonster.ClearSchedule();
	
}