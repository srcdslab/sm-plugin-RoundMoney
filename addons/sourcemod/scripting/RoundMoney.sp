#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

// CS:S caps a player's money at 16000 (CCSPlayer::AddAccount)
#define CSS_MAX_MONEY 16000

ConVar g_cvEnable;
ConVar g_cvAmount;

public Plugin myinfo =
{
	name = "RoundMoney",
	author = ".Rushaway",
	description = "Gives every player a fixed amount of money at each round start",
	version = "1.0.0",
	url = "https://github.com/srcdslab/sm-plugin-RoundMoney"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	if (GetEngineVersion() != Engine_CSS)
	{
		strcopy(error, err_max, "This plugin only supports Counter-Strike: Source");
		return APLRes_Failure;
	}

	return APLRes_Success;
}

public void OnPluginStart()
{
	g_cvEnable = CreateConVar("sm_roundmoney_enable", "1", "Give every player a fixed amount of money when they spawn, 0 = off/1 = on", _, true, 0.0, true, 1.0);
	g_cvAmount = CreateConVar("sm_roundmoney_amount", "16000", "Amount of money given to every player when they spawn", _, true, 0.0, true, float(CSS_MAX_MONEY));

	AutoExecConfig(true);

	HookEvent("player_spawn", Event_PlayerSpawn);
}

// Every player spawns at round start (and a late joiner on his first spawn), so this sets the
// money once per round and never touches it while players buy during the round.
// mp_startmoney is not enough: it only applies to a player's first join and to mp_restartgame.
public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	if (g_cvEnable.BoolValue)
		RequestFrame(Frame_SetMoney, event.GetInt("userid"));
}

// Next frame: the game is done with the spawn and its own money changes
void Frame_SetMoney(int userid)
{
	int client = GetClientOfUserId(userid);

	// player_spawn also fires for players put in the server without a team
	if (!client || !IsClientInGame(client) || !IsPlayerAlive(client) || GetClientTeam(client) < 2)
		return;

	if (g_cvEnable.BoolValue)
		SetEntProp(client, Prop_Send, "m_iAccount", g_cvAmount.IntValue);
}
