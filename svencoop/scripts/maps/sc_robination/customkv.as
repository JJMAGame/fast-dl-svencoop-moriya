int GetCustomInt(CBaseEntity@ ent, const string&in key)
{
	CustomKeyvalues@ cks = ent.GetCustomKeyvalues();
	CustomKeyvalue ck = cks.GetKeyvalue(key);
	
	if (ck.Exists())
		return ck.GetInteger();
	
	return 0;
}

void SetCustomInt(CBaseEntity@ ent, const string&in key, const int value)
{
	CustomKeyvalues@ cks = ent.GetCustomKeyvalues();
	cks.SetKeyvalue(key, value);
}

float GetCustomFloat(CBaseEntity@ ent, const string&in key)
{
	CustomKeyvalues@ cks = ent.GetCustomKeyvalues();
	CustomKeyvalue ck = cks.GetKeyvalue(key);
	
	if (ck.Exists())
		return ck.GetFloat();
		
	return 0.0f;
}

void SetCustomFloat(CBaseEntity@ ent, const string&in key, const float value)
{
	CustomKeyvalues@ cks = ent.GetCustomKeyvalues();
	cks.SetKeyvalue(key, value);
}

Vector GetCustomVec(CBaseEntity@ ent, const string&in key)
{
	CustomKeyvalues@ cks = ent.GetCustomKeyvalues();
	CustomKeyvalue ck = cks.GetKeyvalue(key);
	
	if (ck.Exists())
		return ck.GetVector();
	
	return Vector(0.0f, 0.0f, 0.0f);
}

void SetCustomVec(CBaseEntity@ ent, const string&in key, const Vector&in value)
{
	CustomKeyvalues@ cks = ent.GetCustomKeyvalues();
	cks.SetKeyvalue(key, value);
}

string GetCustomString(CBaseEntity@ ent, const string&in key)
{
	CustomKeyvalues@ cks = ent.GetCustomKeyvalues();
	CustomKeyvalue ck = cks.GetKeyvalue(key);
	if (ck.Exists())
		return ck.GetString();
	
	return "";
}

void SetCustomString(CBaseEntity@ ent, const string&in key, const string&in value)
{
	CustomKeyvalues@ cks = ent.GetCustomKeyvalues();
	cks.SetKeyvalue(key, value);
}
