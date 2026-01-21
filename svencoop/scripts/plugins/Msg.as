const string g_MessagesFile = "scripts/plugins/cfg/Msg.txt";
int num_messages = 0;
int i_msg = 0;
dictionary g_MessagesList;
CCVar@ g_Interval;

CScheduledFunction@ g_pThinkFunc = null;

void ReadMessages()
{
  File@ file = g_FileSystem.OpenFile(g_MessagesFile, OpenFile::READ);
  if (file !is null && file.IsOpen()) {
    string sLine;
    int i = 0;
    while(!file.EOFReached()) {
      file.ReadLine(sLine);
      if (sLine.SubString(0,1) == "#" || sLine.IsEmpty())
        continue;
      g_MessagesList[i] = sLine;
      i+=1;
    }
    file.Close();
    num_messages = i;
  }
}

void PluginInit() {
  g_Module.ScriptInfo.SetAuthor("gvazdas");
  g_Module.ScriptInfo.SetContactInfo("https://knockout.chat/user/3022");
  g_Module.ScriptInfo.SetMinimumAdminLevel(ADMIN_YES);
  @g_Interval = CCVar("interval", 180.0f, "Repeat every x seconds", ConCommandFlag::AdminOnly);
}

void MapInit() {

  ReadMessages();

  if (g_pThinkFunc !is null) 
    g_Scheduler.RemoveTimer(g_pThinkFunc);
    
  if (num_messages>0)
     @g_pThinkFunc = g_Scheduler.SetInterval("msgthink", g_Interval.GetFloat());
}

void msgthink() {
  if (i_msg<0 || i_msg>=num_messages)
     i_msg=0;
  string print_str = string(g_MessagesList[i_msg]);
  g_PlayerFuncs.ClientPrintAll(HUD_PRINTTALK, "[Info] " + print_str + "\n");
  i_msg+=1;
}
