/*
* They Hunger: Escape (th_escape)
* Handles spawning of a random items from breakables
*
* Created by Tomas "GeckoN" Slavotinek
*/

namespace RndBreakables
{

enum AREA_TYPE
{
	AREA_TYPE_GENERIC = 0,
	AREA_TYPE_SEWER,
	AREA_TYPE_POLICE,
	AREA_TYPE_CHURCH,
	AREA_TYPE_RATS
};

array<array<string>> g_itemAreas =
{
	// area_name,	large_weapon_rules,											small_weapon_rules,											
	{ "generic",	"1:weapon_greasegun|weapon_tommygun|weapon_sawedoff",		"0-1:weapon_colt1911|weapon_357;0-1:weapon_medkit;1:weapon_handgrenade" },
	{ "sewer",		"0-1:weapon_greasegun|weapon_tommygun|weapon_sawedoff",		"0-1:weapon_colt1911|weapon_357;0-1:weapon_handgrenade" },
	{ "police",		"0-1:weapon_m16a1",											"1:weapon_medkit;0-1:weapon_colt1911|weapon_357" },
	{ "church",		"1:weapon_crossbow",										"0-1:weapon_medkit;0-1:weapon_handgrenade" },
	{ "rats",		"",															"" }
};

enum BRK_TYPE
{
	BRK_TYPE_UNSPECIFIED = 0,
	BRK_TYPE_SMALL,
	BRK_TYPE_LARGE
};

const int ITEM_LARGE_SIZE = 48; // everything 48x48x48u or larger is considered as a "large" box

class CBrkItem
{
	string m_strName;
	BRK_TYPE m_type;
	
	CBrkItem()
	{
		m_strName = "";
		m_type = BRK_TYPE_UNSPECIFIED;
	}

	CBrkItem( const string& in strName, BRK_TYPE brkType )
	{
		m_strName = strName;
		m_type = brkType;
	}
}

array<array<CBrkItem@>> g_brkItems;

int g_iMode = 0;

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
bool RandomBool( int iProb = 50 )
{
	return Math.RandomLong( 1, 100 ) <= iProb;
}

//-----------------------------------------------------------------------------
// Purpose: Calculates origin of a bmodel from absmin/size
// (bmodel origins are 0 0 0)
//-----------------------------------------------------------------------------
Vector VecBModelOrigin( entvars_t@ pevBModel )
{
	return pevBModel.absmin + ( pevBModel.size * 0.5 );
}

//-----------------------------------------------------------------------------
// Purpose: 
//-----------------------------------------------------------------------------
Vector VecOrigin( entvars_t@ pev )
{
	string strModel = pev.model;

	if ( strModel.Length() > 0 && strModel[ 0 ] == "*" )
		return VecBModelOrigin( pev );
	else
		return pev.origin;
}

//-----------------------------------------------------------------------------
// Purpose: Item Spawner entity (shared by all "brk_" entities)
//-----------------------------------------------------------------------------
CBaseEntity@ SpawnItemSpawner()
{
	dictionary keyvalues =
	{
		{ "m_iszScriptFunctionName", "RndBreakables::SpawnBoxItem" },
		{ "m_iMode", "1" }
	};
	
	CBaseEntity@ pEntity = g_EntityFuncs.CreateEntity( "trigger_script", keyvalues, false );
	pEntity.pev.origin = Vector( 1600, -1600, 100 );
	pEntity.pev.targetname = "item_spawner";
	g_EntityFuncs.DispatchSpawn( pEntity.edict() );
	
	return pEntity;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
CBaseEntity@ SpawnEntityFromObject( CBaseEntity@ pObject, const string & in strName, dictionary & in keyvalues = dictionary() )
{
	if ( pObject is null )
		return null;

	Vector vecOrig = VecOrigin( pObject.pev );

	CBaseEntity@ pEntity = g_EntityFuncs.CreateEntity( strName, keyvalues, false ); // Delayed spawn
	if ( pEntity is null )
		return null;
	
	pEntity.pev.origin = vecOrig;
	pEntity.pev.angles = pObject.pev.angles;
	g_EntityFuncs.DispatchSpawn( pEntity.edict() );
	
	return pEntity;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
CBaseEntity@ SpawnCrab( CBaseEntity@ pObject )
{
	dictionary keyvalues =
	{
		{ "displayname", "Zombie Head" },
		{ "bloodcolor", "1" },
		{ "soundlist", "../hunger/hungercrab.txt" },
		{ "new_model", "models/hunger/hungercrab.mdl" }
	};

	return SpawnEntityFromObject( pObject, "monster_headcrab", keyvalues );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
CBaseEntity@ SpawnRat( CBaseEntity@ pObject )
{
	dictionary keyvalues =
	{
		{ "displayname", "Zombie Rat" },
		{ "bloodcolor", "1" },
		{ "classify", "7" }
	};

	return SpawnEntityFromObject( pObject, "monster_snark", keyvalues );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
CBaseEntity@ SpawnRoach( CBaseEntity@ pObject )
{
	dictionary keyvalues =
	{
		{ "displayname", "Cockroach" }
	};

	return SpawnEntityFromObject( pObject, "monster_cockroach", keyvalues );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void SpawnRoaches( CBaseEntity@ pObject )
{
	Vector vecSize = pObject.pev.size;
	
	int iNum;
	if ( IsObjectLarge( pObject.pev.size ) )
		iNum = Math.RandomLong( 3, 5 );
	else
		iNum = Math.RandomLong( 1, 2 );
	
	for ( int i = 0; i < iNum; i++ )
	{
		CBaseEntity@ pRoach = SpawnRoach( pObject );
		if ( pRoach !is null )
		{
			pRoach.pev.origin[ 0 ] += Math.RandomFloat( -0.4 * vecSize[ 0 ], +0.4 * vecSize[ 0 ] );
			pRoach.pev.origin[ 1 ] += Math.RandomFloat( -0.4 * vecSize[ 1 ], +0.4 * vecSize[ 1 ] );
			
			pRoach.pev.angles[ 1 ] = Math.RandomFloat( 0, 360 );
			
			pRoach.pev.message = "killme";
		}
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void DamageRoaches()
{
	CBaseEntity@ pEntity = null;
	while ( ( @pEntity = g_EntityFuncs.FindEntityByClassname( pEntity, "monster_cockroach" ) ) !is null )
	{
		if ( !pEntity.IsAlive() || pEntity.pev.message != "killme" )
			continue;
			
		edict_t@ worldspawn = g_EntityFuncs.IndexEnt( 0 );
		float flDamage = Math.RandomFloat( 0.05, 0.2 );
		pEntity.TakeDamage( worldspawn.vars, worldspawn.vars, flDamage, DMG_CRUSH );
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void SpawnRandomEntityFromBModel( CBaseEntity@ pCaller, CBaseEntity@ pActivator )
{
	const string strName = pCaller.pev.netname;
	if ( !IsRndBrk( strName ) )
		return;
	
	int iArea = GetBrkAreaByName( strName );
	if ( iArea < 0 )
		return;
		
	// Rats only
	if ( iArea == AREA_TYPE_RATS )
	{
		if ( RandomBool() )
			SpawnRat( pCaller );
		return;
	}
	
	bool fLarge = IsObjectLarge( pCaller.pev.size );
	
	int iChanceAny = ( g_iMode == 0 ) ? 90 : 70;
	if ( !RandomBool( iChanceAny ) )
	{
		if ( RandomBool( 80 ) )
			SpawnRoaches( pCaller );
		
		return;
	}
	
	int iChanceMonster = 15;
	switch ( iArea )
	{
	case AREA_TYPE_SEWER: iChanceMonster = 40; break;
	case AREA_TYPE_GENERIC: iChanceMonster = 25; break;
	}
	
	if ( g_iMode == 0 )
		iChanceMonster /= 2;
	
	if ( RandomBool( iChanceMonster ) )
	{
		if ( fLarge && RandomBool() )
			SpawnCrab( pCaller );
		else
			SpawnRat( pCaller );
		return;
	}
	int iChanceHealth = 15;
	if ( pActivator !is null && pActivator.IsPlayer() )
	{
		if ( pActivator.pev.health <= 25 )
			iChanceHealth = 70;
		else if ( pActivator.pev.health <= 50 )
			iChanceHealth = 40;
	}
	
	if ( RandomBool( iChanceHealth ) )
	{
		SpawnEntityFromObject( pCaller, "item_healthkit" );
		return;
	}
	
	array<string> ammoTypes;
	if ( pActivator !is null && pActivator.IsPlayer() )
	{
		CBasePlayer@ pPlayer = cast<CBasePlayer@>( pActivator );
		if ( pPlayer.HasNamedPlayerItem( "weapon_colt1911" ) !is null )
			ammoTypes.insertLast( "ammo_9mmclip" );
		if ( pPlayer.HasNamedPlayerItem( "weapon_greasegun" ) !is null )
			ammoTypes.insertLast( "ammo_9mmAR" );
		if ( pPlayer.HasNamedPlayerItem( "weapon_tommygun" ) !is null )
			ammoTypes.insertLast( "ammo_9mmAR" );
		if ( pPlayer.HasNamedPlayerItem( "weapon_sawedoff" ) !is null )
			ammoTypes.insertLast( "ammo_buckshot" );
		if ( pPlayer.HasNamedPlayerItem( "weapon_m16a1" ) !is null )
			ammoTypes.insertLast( "ammo_556clip" );
		if ( pPlayer.HasNamedPlayerItem( "weapon_357" ) !is null )
			ammoTypes.insertLast( "ammo_357" );
		if ( pPlayer.HasNamedPlayerItem( "weapon_crossbow" ) !is null )
			ammoTypes.insertLast( "ammo_crossbow" );
	}
	
	int iChanceDesiredAmmo = 30 + ammoTypes.length() * 10;
	
	if ( ammoTypes.length() == 0 || !RandomBool( iChanceDesiredAmmo ) )
	{
		ammoTypes.insertLast( "ammo_9mmclip" );
		ammoTypes.insertLast( "ammo_9mmAR" );
		ammoTypes.insertLast( "ammo_buckshot" );
		ammoTypes.insertLast( "ammo_556clip" );
		ammoTypes.insertLast( "ammo_357" );
		ammoTypes.insertLast( "ammo_crossbow" );
	}
	
	int iAmmoType = Math.RandomLong( 0, ammoTypes.length() - 1 );
	string strItemName = ammoTypes[ iAmmoType ];
	SpawnEntityFromObject( pCaller, strItemName );
}

//-----------------------------------------------------------------------------
// Purpose: [called by trigger_script]
//-----------------------------------------------------------------------------
void SpawnBoxItem( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
	if ( pCaller is null || pCaller.pev.classname != "func_breakable" )
		return;
	
	// Fire the original target, if any
	if ( pCaller.pev.noise != "" )
	{
		g_EntityFuncs.FireTargets( pCaller.pev.noise, pActivator, pCaller, USE_TOGGLE, 0.0f, 0.0f );
	}
	
	if ( pCaller.pev.message != "" )
	{
		// Spawn the predetermined item, if set
		SpawnEntityFromObject( pCaller, pCaller.pev.message );
	}
	else
	{
		// Spawn something random on the fly, if lucky
		SpawnRandomEntityFromBModel( pCaller, pActivator );
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
int GetNumBreakables( int iArea, BRK_TYPE brktype )
{
	if ( brktype == BRK_TYPE_UNSPECIFIED )
		return g_brkItems[ iArea ].length();
		
	int iCount = 0;
	for ( uint i = 0; i < g_brkItems[ iArea ].length(); i++ )
	{
		if ( g_brkItems[ iArea ][ i ].m_type == brktype )
			iCount++;
	}
	
	return iCount;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
int GetRandomBreakable( int iArea, BRK_TYPE brktype )
{
	const int iNumBrk = GetNumBreakables( iArea, brktype );
	if ( iNumBrk == 0 )
		return -1;
	
	const int iRndBrk = Math.RandomLong( 0, iNumBrk - 1 );
	
	int iCount = 0;
	for ( uint i = 0; i < g_brkItems[ iArea ].length(); i++ )
	{
		if ( brktype == BRK_TYPE_UNSPECIFIED || g_brkItems[ iArea ][ i ].m_type == brktype )
		{
			if ( iCount == iRndBrk )
				return int( i );
			
			iCount++;
		}
	}
	
	return -1;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void AssignStaticItems( const string & in strItems, int iArea, BRK_TYPE brktype )
{
	if ( strItems.Length() == 0 )
		return;
		
	array<string>@ items = strItems.Split( ";" );
	
	dictionary keyvalues = {}; 
	
	uint i = 0;
	while( i < items.length() ) 
	{
		string strItemName = items[ i ];
		
		int iBrk = GetRandomBreakable( iArea, brktype );
		if ( iBrk < 0 )
		{
			g_Game.AlertMessage( at_console, "Out of breakables!\n" );
			break;
		}
		
		string strBrkName = g_brkItems[ iArea ][ iBrk ].m_strName;
		g_brkItems[ iArea ].removeAt( iBrk );
		
		CBaseEntity@ pEntity = g_EntityFuncs.FindEntityByTargetname( null, strBrkName );
		if ( pEntity is null )
		{
			g_Game.AlertMessage( at_console, "Can't find breakable \"%1\"!\n", strBrkName );
			continue;
		}
		
		pEntity.pev.message = strItemName;
		//g_Game.AlertMessage( at_console, "Hiding item \"%1\" in \"%2\"\n", strItemName, pEntity.pev.targetname );
		
		i++;
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void InitAreas()
{
	for ( uint i = 0; i < g_itemAreas.length(); i++ )
	{
		InitArea( i );
	}
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void InitArea( int iArea )
{
	array<string> @area = g_itemAreas[ iArea ];
	
	string strLarge = ParseRules( area[ 1 ] );
	AssignStaticItems( strLarge, iArea, BRK_TYPE_LARGE );
	
	string strSmall = ParseRules( area[ 2 ] );
	AssignStaticItems( strSmall, iArea, BRK_TYPE_UNSPECIFIED );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
string ParseRules( const string & in strRules )
{
	string result;
	array<string>@ rules = strRules.Split( ";" );
	
	for ( uint i = 0; i < rules.length(); i++ )
	{
		result += ParseRule( rules[ i ] );
	}
	
	result.Trim( ";" );
	
	return result;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
string ParseRule( const string & in strRule )
{
	string result;
	array<string>@ rule = strRule.Split( ":" );
	
	// Parse item count
	
	int iCount = 0;
	string strRange = rule[ 0 ];
	if ( strRange.Find( "-" ) != String::INVALID_INDEX )
	{
		array<string>@ range = strRange.Split( "-" );
		iCount = Math.RandomLong( atoi( range[ 0 ] ), atoi( range[ 1 ] ) );
	}
	else
	{
		iCount = atoi( strRange );
	}
	
	if ( iCount <= 0 )
		return "";
		
	// Parse item names
	
	string strItems = rule[ 1 ];
	array<string> items;
	
	if ( strItems.Find( "|" ) != String::INVALID_INDEX )
	{
		items = strItems.Split( "|" );
	}
	else
	{
		items.insertLast(strItems);
	}
	
	if ( items.length() == 0 )
		return "";
		
	for ( int i = 0; i < iCount; i++ )
	{
		int iItem = Math.RandomLong( 0, items.length() - 1 );
		string strItem = items[ iItem ];
		result += strItem + ";";
	}
	
	return result;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
int GetAreaIdByName( const string & in strName )
{
	for ( uint i = 0; i < g_itemAreas.length(); i++ )
	{
		if ( g_itemAreas[ i ][ 0 ] == strName )
			return int( i );
	}
	
	return -1;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
string GetAreaNameById( int iArea )
{
	if ( iArea < 0 || iArea >= int ( g_itemAreas.length() ) )
		return "";
	
	return g_itemAreas[ iArea ][ 0 ];
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
bool IsRndBrk( const string & in strName )
{
	return ( strName.Length() >= 4 && strName.SubString( 0, 4 ) == "brk_" );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
int GetBrkAreaByName( const string & in strName )
{
	array<string>@ params = strName.Split( "_" ); // <-- Free emoji right there. Don't make it smile tho, or you will break the map!
		
	if ( params.length() < 2 )
	{
		g_Game.AlertMessage( at_warning, "Breakable \"%1\" - Invalid name!\n", strName );
		return -1;
	}
	const string strArea = params[ 1 ];
	int iArea = GetAreaIdByName( strArea );
	if ( iArea < 0 )
	{
		g_Game.AlertMessage( at_warning, "Breakable \"%1\" - Unknown area \"%2\"!\n", strName, strArea );
		return -1;
	}
	
	return iArea;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
bool IsObjectLarge( const Vector & in vecSize )
{
	return ( vecSize[ 0 ] >= ITEM_LARGE_SIZE &&
		vecSize[ 1 ] >= ITEM_LARGE_SIZE &&
		vecSize[ 2 ] >= ITEM_LARGE_SIZE );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void ScanBreakables()
{
	const int iNumAreas = g_itemAreas.length();

	g_brkItems.resize( iNumAreas );
	int iNum = 0;
	
	CBaseEntity@ pEntity = null;
	while ( ( @pEntity = g_EntityFuncs.FindEntityByClassname( pEntity, "func_breakable" ) ) !is null )
	{
		const string strName = pEntity.pev.targetname;
		if ( !IsRndBrk( strName ) )
			continue;
			
		int iArea = GetBrkAreaByName( strName );
		if ( iArea < 0 )
			continue;
		
		const Vector vecSize = pEntity.pev.size;
		bool fLarge = IsObjectLarge( vecSize );
		
		CBrkItem@ pBrkItem = CBrkItem( strName, fLarge ? BRK_TYPE_LARGE : BRK_TYPE_SMALL );
		g_brkItems[ iArea ].insertLast( pBrkItem );
		
		iNum++;
		
		/*g_Game.AlertMessage( at_console, "Breakable \"%1\" - Added to area \"%2\", size \"%3\" (%4 %5 %6)\n",
			strName, GetAreaNameById( iArea ), fLarge ? "large" : "small", vecSize[ 0 ], vecSize[ 1 ], vecSize[ 2 ] );*/
		
		if ( pEntity.pev.noise != "" )
		{
			g_Game.AlertMessage( at_warning, "Breakable \"%1\" - Already has a noise variable (\"%2\")!\n", strName, pEntity.pev.noise );
			pEntity.pev.noise = "";
		}
		
		if ( pEntity.pev.message != "" )
		{
			g_Game.AlertMessage( at_warning, "Breakable \"%1\" - Already has a message variable (\"%2\")!\n", strName, pEntity.pev.message );
			pEntity.pev.message = "";
		}
		
		if ( pEntity.pev.target != "" )
		{
			pEntity.pev.noise = pEntity.pev.target; // noise is used to save the original target
		}
		
		pEntity.pev.netname = pEntity.pev.targetname; // GeckoN: HACK
		pEntity.pev.target = "item_spawner";
	}

	//g_Game.AlertMessage( at_console, "%1 breakables found\n", iNum );
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void Periodic()
{
	DamageRoaches();
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void SetMode( int iMode )
{
	g_iMode = iMode;
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
void Init()
{
	const int iNumAreas = g_itemAreas.length();
	if ( iNumAreas == 0 )
	{
		g_Game.AlertMessage( at_error, "Item areas not defined!\n" );
		return;
	}
	
	SpawnItemSpawner();
	
	ScanBreakables();
	
	InitAreas();

	g_Scheduler.SetInterval( "Periodic", 2, g_Scheduler.REPEAT_INFINITE_TIMES );
}

} // end of namespace
