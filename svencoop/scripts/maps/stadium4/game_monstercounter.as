class game_monstercounter : ScriptBaseEntity
{
	string m_szMonsterClass = "";
	bool m_fWildcardClass = false;
	uint m_counted = 0;
	int m_is_player_ally = 0;
	int m_alive_or_dead = 0;
	float m_flRestartDelay = 1.0;
	int m_iWeaponFilter = 0;
	bool m_fWeaponFilterExcl = false;
	int m_iClassificationFilter = 0;
	
	bool KeyValue( const string& in szKey, const string& in szValue )
	{
		if(szKey == "monsterclass")
		{
			m_szMonsterClass = szValue;
			if ( m_szMonsterClass == "monster_*" )
				m_fWildcardClass = true;
			return true;
		}
		else if(szKey == "frags")
		{
			m_counted = atoi( szValue );
			return true;
		}
		else if(szKey == "is_player_ally")
		{
			m_is_player_ally = atoi( szValue );
			return true;
		}		
		else if(szKey == "classification")
		{
			m_iClassificationFilter = atoi( szValue );
			return true;
		}
		else if(szKey == "alive_or_dead")
		{
			m_alive_or_dead = atoi( szValue );
			return true;
		}
		else if( szKey == "restartdelay" )
		{
			m_flRestartDelay = atof( szValue );
			return true;
		}
		else if(szKey == "weaponfilter")
		{
			ParseWeaponFilter( szValue );
			return true;
		}
		else
			return BaseClass.KeyValue( szKey, szValue );
	}
	
	void ParseWeaponFilter( const string & in szFilter )
	{
		m_iWeaponFilter = 0;
		m_fWeaponFilterExcl = false;
		
		if ( szFilter.Length() == 0 )
			return;
		
		if ( szFilter[ 0 ] == "!" )
			m_fWeaponFilterExcl = true;
			
		if ( m_fWeaponFilterExcl )
			m_iWeaponFilter = atoi( szFilter.SubString( 1 ) );
		else
			m_iWeaponFilter = atoi( szFilter );
	}
	
	bool FilterWeapons( int iWeapons )
	{
		if ( m_iWeaponFilter == 0 )
			return false;
			
		if ( m_fWeaponFilterExcl && ( iWeapons & m_iWeaponFilter ) != 0 )
			return true;
			
		if ( !m_fWeaponFilterExcl && ( iWeapons & m_iWeaponFilter ) == 0 )
			return true;
			
		return false;
	}
	
	bool FilterClassification( int iClassification )
	{		
		if ( m_iClassificationFilter == 0 )
			return false;
			
		if( m_iClassificationFilter != iClassification )
			return true;
			
		return false;
	}
	
	bool ShouldSkipEntity( const string & in szEntityClass )
	{
		// Wildcard?
		if ( !m_fWildcardClass )
			return false;
			
		// Blacklisted entities
		if ( szEntityClass == "monster_tripmine" || 
			szEntityClass == "monster_cockroach" )
			return true;
			
		return false;
	}
	
	void OnCreate()
	{
		//g_Game.AlertMessage( at_console, "game_monstercounter created \n" );
		self.pev.nextthink = g_Engine.time;
	}
	
	void Think()
	{
		//g_Game.AlertMessage(at_console, "Thinking at " + g_Engine.time + "\n");
		
		uint m_counted = 0;
		
		CBaseEntity@ ent = null;
		
		while( ( @ent = g_EntityFuncs.FindEntityByClassname( ent, m_szMonsterClass ) ) !is null )
		{
			if ( FilterWeapons( ent.pev.weapons ) )
				continue;
				
			if ( ShouldSkipEntity( ent.GetClassname() ) )
				continue;
				
			if( FilterClassification( ent.m_iClassSelection ) )
				continue;			
			
			if( m_is_player_ally == 0 )
			{
				if( m_alive_or_dead == 1 )
				{
					//g_Game.AlertMessage( at_console, "m_alive_or_dead = 1 \n" );
					if( ent.IsAlive() )
					{
						m_counted++;
					}
				}
				else if( m_alive_or_dead == 2 )
				{
					//g_Game.AlertMessage( at_console, "m_alive_or_dead = 2 \n" );
					if( !ent.IsAlive() )
					{
						m_counted++;
					}
				}
				else
				{
					m_counted++;
				}				
			}
			else if( m_is_player_ally == 1 )
			{
				int relationship = ent.IRelationshipByClass( CLASS_PLAYER );
				if( relationship == R_AL || relationship == R_NO )
				{
					if( m_alive_or_dead == 1 )
					{
						//g_Game.AlertMessage( at_console, "Looking for allies. But only alive ones. \n" );
						if( ent.IsAlive() )
						{
							m_counted++;
						}
					}
					else if( m_alive_or_dead == 2 )
					{
						//g_Game.AlertMessage( at_console, "Looking for allies. But only dead ones. \n" );
						if( !ent.IsAlive() )
						{
							m_counted++;
						}
					}
					else
					{
						m_counted++;
					}
				}
			}
			else if( m_is_player_ally == 2 )
			{
				int relationship = ent.IRelationshipByClass( CLASS_PLAYER );
				if( relationship != R_AL and relationship != R_NO )
				{
					if( m_alive_or_dead == 1 )
					{
						//g_Game.AlertMessage( at_console, "Looking for enemies. But only alive ones. \n" );
						if( ent.IsAlive() )
						{
							m_counted++;
						}
					}
					else if( m_alive_or_dead == 2 )
					{
						//g_Game.AlertMessage( at_console, "Looking for enemies. But only dead ones. \n" );
						if( !ent.IsAlive() )
						{
							m_counted++;
						}
					}
					else
					{
						m_counted++;
					}
				}
			}
			else
			{
				g_Game.AlertMessage(at_console, "game_monstercounter is missing keyvalues necessary to function.\n" );
			}
		}
		
		if( m_counted > 0 )
		{
			//g_Game.AlertMessage(at_console, "Counted " + m_counted + " \"" + m_szMonsterClass + "\" entities.\n" );
			self.pev.frags = m_counted;
		}
		else
		{
			//g_Game.AlertMessage(at_console, "No \"" + m_szMonsterClass + "\" entities were found.\n" );
			self.pev.frags = 0;
		}
		
		//void SUB_UseTargets(CBaseEntity@ pActivator, USE_TYPE, float)
		
		self.pev.nextthink = g_Engine.time + m_flRestartDelay;
	}
}