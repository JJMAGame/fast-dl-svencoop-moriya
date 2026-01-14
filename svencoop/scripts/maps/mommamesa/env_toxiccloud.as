class env_toxiccloud : ScriptBaseEntity
{
	void Use(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
	{
		NetworkMessage message( MSG_PVS, NetworkMessages::ToxicCloud );
		message.WriteCoord( self.pev.origin.x );
		message.WriteCoord( self.pev.origin.y );
		message.WriteCoord( self.pev.origin.z );
		message.End();
	}
}

void Spawn()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "env_toxiccloud", "env_toxiccloud" );
}