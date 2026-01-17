/*
*	CNC Misc. Stocks
*	AnggaraNothing
*/

namespace CNC
{

	void PrecacheSoundImproved( const string &in soundfile )
	{
		if( !soundfile.IsEmpty() )
		{
			g_SoundSystem.PrecacheSound( soundfile );
			g_Game.PrecacheGeneric( "sound/" + soundfile );
		}
	}
	
	void CreateTempEnt_Model( entvars_t@ pEnt, const Vector origin, const int model_id, const int bouncetype, const int life, const int yaw ) 
	{
		NetworkMessage message( MSG_ONE_UNRELIABLE, NetworkMessages::SVC_TEMPENTITY, pEnt.get_pContainingEntity() );
		message.WriteByte( TE_MODEL );
		// origin
		message.WriteCoord( origin.x );
		message.WriteCoord( origin.y );
		message.WriteCoord( origin.z );
		// velocity
		message.WriteCoord( 0.0 );
		message.WriteCoord( 0.0 );
		message.WriteCoord( 0.0 );
		// initial yaw
		message.WriteAngle( yaw );
		// modelindex
		message.WriteShort( model_id );
		// bounce sound type 
		message.WriteByte( bouncetype );
		// life in 0.1's
		message.WriteByte( life );
		message.End();
	}
	
	void CreateTempEnt_BreakModel(Vector pos, Vector size, Vector velocity, 
	uint8 randomization=10, int modelindex=1, 
	uint8 count=0, uint8 duration=25, uint8 flags=20,
	NetworkMessageDest msgType=MSG_PVS, edict_t@ dest=null)
	{
		NetworkMessage m(msgType, NetworkMessages::SVC_TEMPENTITY, dest);
		m.WriteByte(TE_BREAKMODEL);
			// position
			m.WriteCoord(pos.x);
			m.WriteCoord(pos.y);
			m.WriteCoord(pos.z);
			
			// size
			m.WriteCoord(size.x);
			m.WriteCoord(size.y);
			m.WriteCoord(size.z);
			
			// velocity
			m.WriteCoord(velocity.x);
			m.WriteCoord(velocity.y);
			m.WriteCoord(velocity.z);
			
			// randomization
			m.WriteByte(randomization);
			
			// ModelIndex
			m.WriteShort( modelindex );
			
			// # of shards
			// 0 = let client decide
			m.WriteByte(count);
			
			// duration
			m.WriteByte(duration);
			
			// flags
			m.WriteByte(flags);
		m.End();
	}
	
	HealthBar CreateBuildingHealthBar( CBaseEntity@ pParentEnt , const float addPosZ = 60.0f )
	{
		HealthBar m_healthBar;
		Vector origin	= pParentEnt.pev.origin;
		origin.z		= pParentEnt.pev.absmax.z + addPosZ;
		
		m_healthBar = CNC::HealthBar( @pParentEnt , origin );
		m_healthBar.CreateSprite();
		//m_healthBar.AttachToOwner(); // doesnt obey height ( z-axis position )
		m_healthBar.StartThink();
		m_healthBar.Sprite.SetScale( 0.4 );
		
		return m_healthBar;
	}
	
	class HealthBar
	{
		private CSprite@				m_pSprite;
		private string					m_szModel;
		private Vector					m_vecOrigin;
		private float					m_flMaxFrames;
		private EHandle					m_pOwner;
		private	CScheduledFunction@		m_pNextThink	= null;
		private float					m_flThinkDelay	= 0.2f;
		
		// Getter & Setter
		CBaseEntity@ Owner
		{
			get { return @m_pOwner.GetEntity(); }
			set { m_pOwner = EHandle( @value ); }
		}
		CSprite@ Sprite
		{
			get { return @m_pSprite; }
			//set { @m_pSprite = @value; }
		}
		string Model
		{
			get const { return m_szModel; }
			set { m_szModel = value; }
		}
		Vector Origin
		{
			get const { return m_vecOrigin; }
			set { m_vecOrigin = value; }
		}
		float MaxFrames
		{
			get const { return m_flMaxFrames; }
			set { m_flMaxFrames = value; }
		}
		
		// Constructor
		private void Init( CBaseEntity@ owner , const string& in model , const Vector& in origin , const float maxframes = 100.0f )
		{
			@this.Owner = @owner;
			this.Model  = model;
			this.Origin = origin;
			this.MaxFrames = maxframes;
		}
		HealthBar()
		{
			Init( null , DEFAULT_HEALTHBAR_MODEL , g_vecZero );
		}
		HealthBar( CBaseEntity@ owner , const Vector& in origin )
		{
			Init( @owner , DEFAULT_HEALTHBAR_MODEL , origin );
		}
		HealthBar( CBaseEntity@ owner , const string& in model , const Vector& in origin )
		{
			Init( @owner , model , origin );
		}
		HealthBar( CBaseEntity@ owner , const string& in model , const Vector& in origin , const float maxframes )
		{
			Init( @owner , model , origin , maxframes );
		}
		
		bool isOwnerNull()
		{
			return m_pOwner.GetEntity() is null;
		}
		bool isSpriteNull()
		{
			return m_pSprite is null;
		}
		
		void CreateSprite()
		{
			if( isSpriteNull() )
			{
				@m_pSprite = g_EntityFuncs.CreateSprite( m_szModel, m_vecOrigin, /*animated?*/ false );
				m_pSprite.pev.nextthink = 0;
				m_pSprite.pev.groupinfo = 1;
			}	
		}
		void RemoveSprite()
		{
			StopThink();
			
			if( !isSpriteNull() )
				g_EntityFuncs.Remove( m_pSprite );
		}
		
		void AttachToOwner( int iAttachment = 0 )
		{
			if( m_pSprite !is null && !isOwnerNull() )
				m_pSprite.SetAttachment( m_pOwner.GetEntity().edict(), iAttachment );
		}
		
		void CheckVisibleState( const float flMultiplier = 4.0f )
		{
			if( isSpriteNull() || isOwnerNull() )
				return;
			
			m_pSprite.pev.groupinfo = 1;
			
			CBaseEntity@ pOwner = m_pOwner.GetEntity();
			
			Vector entity_mins = pOwner.pev.mins;
			entity_mins = entity_mins.opMul( flMultiplier );
			entity_mins = entity_mins.opAdd( pOwner.pev.origin );
			
			Vector entity_maxs = pOwner.pev.maxs;
			entity_maxs = entity_maxs.opMul( flMultiplier );
			entity_maxs = entity_maxs.opAdd( pOwner.pev.origin );
			
			array<CBaseEntity@> arrPlayer = ClientInBox( entity_mins , entity_maxs );
			
			int entgrinfo = m_pSprite.pev.groupinfo;
			
			for( uint i = 0; i < arrPlayer.length(); i++ )
			{
				if ( arrPlayer[i] !is null && arrPlayer[i].IsPlayer() )
				{
					int bitmask   = Bit_GroupInfo_Mask( arrPlayer[i].entindex() );
					
					if( ( entgrinfo & bitmask ) == 0 )
					{
						entgrinfo |= bitmask;
					}
				}
			}
			
			m_pSprite.pev.groupinfo = entgrinfo;
		}
		
		void Think()
		{
			StopThink();
			
			if( isSpriteNull() )
				return;
			
			if( !isOwnerNull() )
			{
				float owner_health = m_pOwner.GetEntity().pev.health;
				
				if( owner_health > 0.0 )
					m_pSprite.pev.frame = Math.max( 0.0f , Math.Floor( ( ( owner_health - 1.0f ) * m_flMaxFrames ) / m_pOwner.GetEntity().pev.max_health ) );
				else
				{
					RemoveSprite();
					return;
				}
				
				CheckVisibleState();
			}
			else
			{
				RemoveSprite();
				return;
			}
			
			StartThink();
		}
		
		void StartThink()
		{
			@m_pNextThink = g_Scheduler.SetTimeout( @this, "Think", m_flThinkDelay );
		}
		void StopThink()
		{
			if( m_pNextThink !is null )
				g_Scheduler.RemoveTimer( m_pNextThink );
		}
	}
	
	class EntityDuplicator
	{
		private string			m_szTemplateTargetname;
		private CBaseEntity@	m_pTemplateEntPointer;
		private KeyValueMap		m_pResultKeyvalues;
		
		// Getter & Setter
		KeyValueMap Keyvalues
		{
			get const { return m_pResultKeyvalues; }
			set { m_pResultKeyvalues = value; }
		}
		
		// Constuctor
		EntityDuplicator()
		{
			@this.m_pTemplateEntPointer = null;
		}
		
		EntityDuplicator( const string &in targetnames )
		{
			this.m_szTemplateTargetname	=	targetnames;
			AssignTemplateToPointer();
			GenerateTemplateKeyValue();
		}
		
		CBaseEntity@ Spawn( const Vector &in origin , const Vector &in angles )
		{
			CBaseEntity@ temp = g_EntityFuncs.Create( "trigger_createentity", origin, angles, true );
			
			//g_EntityFuncs.DispatchKeyValue( temp.edict(), "-angles", Vector2String( angles, true ) );
			
			for( int j = 0; j < m_pResultKeyvalues.Length; j++ )
				g_EntityFuncs.DispatchKeyValue( temp.edict(), m_pResultKeyvalues.GetKey(j), m_pResultKeyvalues.GetValue(j) );
			
			g_EntityFuncs.DispatchSpawn( temp.edict() );
			
			temp.Use( temp, temp, USE_ON );
			
			g_EntityFuncs.Remove( temp );
			
			return FindFirstEntityByTargetname( m_pResultKeyvalues.GetValue( "m_iszCrtEntChildName" ) );
		}
		
		void AssignTemplateToPointer()
		{
			@m_pTemplateEntPointer = FindFirstEntityByTargetname( m_szTemplateTargetname );
		}
		
		void GenerateTemplateKeyValue()
		{
			if( m_pTemplateEntPointer is null )
				return;
			
			m_pResultKeyvalues = GetKeyvaluesByClassname( m_pTemplateEntPointer );
		}
		
		KeyValueMap GetKeyvaluesByClassname( CBaseEntity@ pEntity )
		{
			entvars_t@ vars = pEntity.pev;
			
			string tempText;
			
			KeyValueMap temp;
			
			temp.Add( "m_iszCrtEntChildClass",	vars.classname );
			
			do 
			{
				snprintf( tempText, "copied_%1",	string(vars.targetname).Length() + Math.RandomLong( 0, Math.INT32_MAX ) + g_EngineFuncs.NumberOfEntities() + 1 );
			}
			while( g_EntityFuncs.RandomTargetname( tempText ) !is null );
			
			temp.Add( "m_iszCrtEntChildName",   tempText );
			temp.Add( "+model",					vars.targetname );
			temp.Add( "+spawnflags",			vars.targetname );
			//temp.Add( "+angles",				vars.targetname );
			temp.Add( "+rendermode",			vars.targetname );
			temp.Add( "+renderfx",				vars.targetname );
			temp.Add( "+rendercolor",			vars.targetname );
			temp.Add( "+target",				vars.targetname );
			temp.Add( "-classify",				pEntity.Classify() );
			temp.Add( "+dmg",					vars.targetname );
			temp.Add( "+health",				vars.targetname );
			temp.Add( "+speed",					vars.targetname );
			
			if( vars.classname == "func_tankrocket" )
			{
				CBaseTank@ pTank = cast<CBaseTank@>( pEntity );
				temp.Add( "-yawrate",					pTank.m_yawRate );
				temp.Add( "-yawrange",					pTank.m_yawRange );
				temp.Add( "-yawtolerance",				pTank.m_yawTolerance );
				temp.Add( "-pitchrate",					pTank.m_pitchRate );
				temp.Add( "-pitchrange",				pTank.m_pitchRange );
				temp.Add( "-pitchtolerance",			pTank.m_pitchTolerance );
				temp.Add( "-barrel",					pTank.m_barrelPos.x );
				temp.Add( "-barrely",					pTank.m_barrelPos.y );
				temp.Add( "-barrelz",					pTank.m_barrelPos.z );
				temp.Add( "-spritescale",				pTank.m_spriteScale );
				temp.Add( "-firerate",					pTank.m_fireRate );
				temp.Add( "-firespread",				pTank.m_spread );
				temp.Add( "-bullet_damage",				pTank.m_iBulletDamage );
				temp.Add( "-persistence",				pTank.m_persist );
				temp.Add( "-minRange",					pTank.m_minRange );
				temp.Add( "-maxRange",					pTank.m_maxRange );
			}
			else if( vars.classname == "func_door" )
			{
				CBaseToggle@ pDoor = cast<CBaseToggle@>( pEntity );
				temp.Add( "-tinfiltertype",					pDoor.targetnameInFilterType );
				temp.Add( "-cinfiltertype",					pDoor.classnameInFilterType );
				temp.Add( "-toutfiltertype",				pDoor.targetnameOutFilterType );
				temp.Add( "-coutfiltertype",				pDoor.classnameOutFilterType );
				temp.Add( "-delay",							pDoor.m_flDelay );
				temp.Add( "-wait",							pDoor.m_flWait );
			}
			else if( vars.classname == "func_button" )
			{
				CBaseToggle@ pButton = cast<CBaseToggle@>( pEntity );
				temp.Add( "-delay",							pButton.m_flDelay );
				temp.Add( "-wait",							pButton.m_flWait );
			}
			
			return temp;
		}
	}
	
	class KeyValueMap
	{
		private array<string> m_arrKey;
		private array<string> m_arrValue;
		
		int Length
		{
			get const { return m_arrKey.length(); }
		}
		array<string> Keys
		{
			get const { return m_arrKey; }
		}
		array<string> Values
		{
			get const { return m_arrValue; }
		}
	
		string GetKey( const int index )
		{
			return m_arrKey[ index ];
		}
		void SetKey( const int index, const string &in value )
		{
			m_arrKey[ index ] = value;
		}
		
		string GetValue( const string &in keyname )
		{
			return GetValue( GetIndex( keyname ) );
		}
		
		string GetValue( const int index )
		{
			//g_Game.AlertMessage( at_console, "KeyValueMap: %1 %2\n", index , m_arrValue.length() );
			return m_arrValue[ index ];
		}
		
		void SetValue( const string &in keyname, const string &in value )
		{
			SetValue( GetIndex( keyname ), value );
		}
		
		void SetValue( const int index, const string &in value )
		{
			m_arrValue[ index ] = value;
		}
		
		int GetIndex( const string &in keyname )
		{
			return m_arrKey.find( keyname );
		}
		
		void Add( const string &in key, const string &in value )
		{
			m_arrKey.insertLast( key );
			m_arrValue.insertLast( value );
		}
		
		void Clear()
		{
			m_arrKey.removeRange( 0, m_arrKey.length()-1 );
			m_arrValue.removeRange( 0, m_arrValue.length()-1 );
		}
	}
	
	CBaseEntity@ FindFirstEntityByTargetname( const string &in targetname )
	{
		return g_EntityFuncs.FindEntityByTargetname( null, targetname );
	}
	
	array<CBaseEntity@> ClientInBox( const Vector &in mins , const Vector &in maxs )
	{
		array<CBaseEntity@> temp ( g_Engine.maxClients + 1 );
		g_EntityFuncs.EntitiesInBox( temp, mins, maxs, FL_CLIENT );
		return temp;
	}
	
	int Bit_GroupInfo_Mask( const int entity_index )
	{
		return ( 1 << ( entity_index & 31 ) );
	}
	
	void FixEntityBoundingBox( CBaseEntity@ ent )
	{
		if (ent is null)
			return;

		Vector mins, maxs;
		entvars_t@ entvars = @ent.pev;

		// Get sequence bbox
		mins = entvars.mins;
		maxs = entvars.maxs;
		
		// expand box for rotation
		// find min / max for rotations
		float yaw = entvars.angles.y * (Math.PI / 180.0);
		
		Vector xvector, yvector;
		xvector.x = cos(yaw);
		xvector.y = sin(yaw);
		yvector.x = -sin(yaw);
		yvector.y = cos(yaw);
		array<Vector> bounds( 2, g_vecZero );

		bounds[0] = mins;
		bounds[1] = maxs;
		
		Vector rmin( 9999, 9999, 9999 );
		Vector rmax( -9999, -9999, -9999 );
		Vector base, transformed;

		for (int i = 0; i <= 1; i++ )
		{
			base.x = bounds[i].x;
			for ( int j = 0; j <= 1; j++ )
			{
				base.y = bounds[j].y;
				for ( int k = 0; k <= 1; k++ )
				{
					//base.z = bounds[k].z;
					
					// transform the point
					transformed.x = xvector.x*base.x + yvector.x*base.y;
					transformed.y = xvector.y*base.x + yvector.y*base.y;
					//transformed.z = base.z;

					if (transformed.x < rmin.x)
						rmin.x = transformed.x;
					if (transformed.x > rmax.x)
						rmax.x = transformed.x;
					if (transformed.y < rmin.y)
						rmin.y = transformed.y;
					if (transformed.y > rmax.y)
						rmax.y = transformed.y;
					/*if (transformed.z < rmin.z)
						rmin.z = transformed.z;
					if (transformed.z > rmax.z)
						rmax.z = transformed.z;*/
				}
			}
		}
		//rmin.z = 0;
		//rmax.z = rmin.z + 1;

		rmin.z = mins.z;
		rmax.z = maxs.z;

		if (!ent.IsBSPModel())
		{
			g_EntityFuncs.SetSize( entvars, rmin, rmax );
			g_EntityFuncs.SetOrigin( ent, entvars.origin );
		}
		else
		{
			entvars.absmin.x = entvars.origin.x + rmin.x;
			entvars.absmin.y = entvars.origin.y + rmin.y;
			entvars.absmax.x = entvars.origin.x + rmax.x;
			entvars.absmax.y = entvars.origin.y + rmax.y;
		}
	}

	string Vector2String( const Vector &in vector, bool toInteger = false )
	{
		string tempText;
		
		if( toInteger )
			snprintf( tempText, "%1 %2 %3", int( vector.x ), int( vector.y ), int( vector.z )  );
		else
			snprintf( tempText, "%1 %2 %3", vector.x, vector.y, vector.z );
		
		return tempText;
	}
	
	int fabs( const int x )
	{
		return ( (x) > 0 ? (x) : 0 - (x) );
	}
	float fabs( const float x )
	{
		return ( (x) > 0.0 ? (x) : 0.0 - (x) );
	}
}
