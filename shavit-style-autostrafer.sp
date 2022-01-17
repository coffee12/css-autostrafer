#include <sourcemod>
#include <shavit>

public Plugin myinfo = 
{
	name = "shavit autostrafer style",
	author = "appa",
	description = "",
	version = "1.0",
	url = ""
}

bool gB_AutostraferEnabled[MAXPLAYERS+1];
ConVar gCV_SpecialString;
char gS_SpecialString[32];

public void OnPluginStart()
{
	gCV_SpecialString = CreateConVar("ss_autostrafer_specialstring", "autostrafer", "Special string value to use in shavit-styles.cfg");
	gCV_SpecialString.AddChangeHook(ConVar_OnSpecialStringChanged);
	gCV_SpecialString.GetString(gS_SpecialString, sizeof(gS_SpecialString));

	AutoExecConfig();
}

public void ConVar_OnSpecialStringChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	convar.GetString(gS_SpecialString, sizeof(gS_SpecialString));
}

public void OnClientDisconnect(int client)
{
	gB_AutostraferEnabled[client] = false;
}

public void Shavit_OnStyleChanged(int client, int oldstyle, int newstyle, int track, bool manual)
{
	char sSpecial[128];
	Shavit_GetStyleStrings(newstyle, sSpecialString, sSpecial, sizeof(sSpecial));

	gB_AutostraferEnabled[client] = (StrContains(sSpecial, gS_SpecialString) != -1);
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
	if (!IsPlayerAlive(client) || IsFakeClient(client) || !gB_AutostraferEnabled[client])
		return Plugin_Continue;

	MoveType hMoveType = GetEntityMoveType(client);
	if(hMoveType == MOVETYPE_NOCLIP || hMoveType == MOVETYPE_LADDER)
		return Plugin_Continue;

    if (GetEntityFlags(client) & FL_ONGROUND) 
        return Plugin_Continue;

	if(mouse[0] > 0.0)
    {
        vel[1] = 450.0;
		buttons |= IN_MOVERIGHT;
    }
    else if(mouse[0] < 0.0)
    {
        vel[1] = -450.0;
		buttons |= IN_MOVELEFT;
    }

	return Plugin_Continue;
}