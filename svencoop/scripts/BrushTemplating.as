/*
* Author: Sam "Solokiller" Vanheer
* This script allows you to use brushes as templates for other entities
* This works by making a map of templates and their brush model
* The template brushes can be removed afterwards
*
* DO NOT MODIFY THIS SCRIPT
*/

namespace BrushTemplating
{
/*
* A pair of an entity name, and a template name
*/
class BrushTemplatePair
{
	private string m_szEntityName;
	private string m_szTemplateName;
	
	string EntityName
	{
		get const { return m_szEntityName; }
	}
	
	string TemplateName
	{
		get const { return m_szTemplateName; }
	}
	
	BrushTemplatePair( const string& in szEntityName, const string& in szTemplateName = "" )
	{
		m_szEntityName = szEntityName;
		m_szTemplateName = szTemplateName;
	}
}

/*
* This class stores templates. You give it an entity name, and it looks up the entity, retrieves its model, and stores it, optionally giving it a name other than its entity name.
* The first entity found with the given name is used, not the first brush entity.
*/
class BrushTemplates
{
	private dictionary m_Templates;
	
	BrushTemplates()
	{
	}
	
	uint GetTemplateCount() const
	{
		return m_Templates.getSize();
	}
	
	string FindTemplate( string szTemplateName ) const
	{
		szTemplateName.Trim();
		
		if( szTemplateName.IsEmpty() )
			return "";
			
		string szModelName;
		
		m_Templates.get( szTemplateName, szModelName );
		
		return szModelName;
	}
	
	bool TemplateExists( const string& in szTemplateName ) const
	{
		return !FindTemplate( szTemplateName ).IsEmpty();
	}
	
	/*
	* Adds a new template. If the template already exists, it is overwritten.
	* If szTemplateName is not empty, it will be used as the name of the template, instead of the entity name.
	* if fRemoveTemplate is true, the template is removed.
	* Returns true if the template was added, false otherwise.
	*/
	bool AddTemplate( string szEntityName, const bool fRemoveTemplate = false, string szTemplateName = "" )
	{
		szEntityName.Trim();
		
		if( szEntityName.IsEmpty() )
		{
			g_Game.AlertMessage( at_console, "BrushTemplates::AddTemplate: Empty name!\n" );
			return false;
		}
			
		CBaseEntity@ pEntity = g_EntityFuncs.FindEntityByTargetname( null, szEntityName );
		
		if( pEntity is null )
		{
			g_Game.AlertMessage( at_console, "BrushTemplates::AddTemplate: Could not find template '%1'!\n", szEntityName );
			return false;
		}
			
		const string szModelName = pEntity.pev.model;
		
		//Can now remove the template
		/*if( fRemoveTemplate )
			g_EntityFuncs.Remove( pEntity );*/
		
		//Brush models start with a '*'
		if( szModelName.IsEmpty() || szModelName[ 0 ] != "*" )
		{
			g_Game.AlertMessage( at_console, "BrushTemplates::AddTemplate: Template '%1' is not a brush entity!\n", szEntityName );
			return false;
		}
			
		szTemplateName.Trim();
		
		if( szTemplateName.IsEmpty() )
			szTemplateName = szEntityName;
			
		m_Templates.set( szTemplateName, szModelName );
		
		return true;
	}
	
	/*
	* Adds a set of templates to the container.
	* Returns the number of templates that have been added. This is not necessarily the same as the number of templates that are actually in the container, if duplicates were in the set.
	*/
	uint AddTemplates( const array<BrushTemplatePair@>@ pTemplatePairs, const bool fRemoveTemplates = false )
	{
		if( pTemplatePairs is null )
			return 0;
			
		uint uiCount = 0;
		
		for( uint uiIndex = 0; uiIndex < pTemplatePairs.length(); ++uiIndex )
		{
			const BrushTemplatePair@ pPair = pTemplatePairs[ uiIndex ];
			
			if( pPair is null )
				continue;
				
			if( AddTemplate( pPair.EntityName, fRemoveTemplates, pPair.TemplateName ) )
				++uiCount;
		}
		
		return uiCount;
	}
	
	void RemoveTemplate( string szTemplateName )
	{
		szTemplateName.Trim();
		
		if( szTemplateName.IsEmpty() )
			return;
		
		m_Templates.delete( szTemplateName );
	}
	
	void RemoveAllTemplates()
	{
		m_Templates.deleteAll();
	}
}

/*
* Create a brush entity using a template from the given template container.
* You will have to initialize and spawn the entity yourself.
*/
CBaseEntity@ CreateBrushEntityFromTemplate( const BrushTemplates@ pTemplates, const string& in szTemplateName, const string& in szEntityName )
{
	if( pTemplates is null )
		return null;
	
	const string szModelName = pTemplates.FindTemplate( szTemplateName );
	
	if( szModelName.IsEmpty() )
	{
		g_Game.AlertMessage( at_console, "CreateBrushEntityFromTemplate: Could not find template '%1'!\n", szTemplateName );
		return null;
	}
		
	CBaseEntity@ pEntity = g_EntityFuncs.CreateEntity( szEntityName, null, false );
	
	if( pEntity is null )
	{
		g_Game.AlertMessage( at_console, "CreateBrushEntityFromTemplate: Could not create entity '%1'!\n", szEntityName );
		return null;
	}
		
	g_EntityFuncs.DispatchKeyValue( pEntity.edict(), "model", szModelName );
	
	return pEntity;
}
}