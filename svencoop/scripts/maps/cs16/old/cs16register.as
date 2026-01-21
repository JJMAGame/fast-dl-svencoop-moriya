#include "cs16common"

void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor( "KernCore" );
	g_Module.ScriptInfo.SetContactInfo( "https://discord.gg/0wtJ6aAd7XOGI6vI" );
}

void MapInit()
{
	RegisterCS16();
}