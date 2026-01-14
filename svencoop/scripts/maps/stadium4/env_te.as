class env_te_teleport : ScriptBaseEntity
{
	void Use(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
	{
		//g_Game.AlertMessage(at_console, "TE_TELEPORT Created!\n");
		NetworkMessage message( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY ); // Begin "swirling cloud of particles" effect
		message.WriteByte( TE_TELEPORT );
		message.WriteCoord( self.pev.origin.x );
		message.WriteCoord( self.pev.origin.y );
		message.WriteCoord( self.pev.origin.z );
		message.End(); // End "swirling cloud of particles" effect
	}
}

void Spawn()
{
	g_CustomEntityFuncs.RegisterCustomEntity( "env_te_teleport", "env_te_teleport" );
}