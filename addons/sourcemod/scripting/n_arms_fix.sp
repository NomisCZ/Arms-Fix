#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cstrike>

#pragma newdecls required

char defaultArms[][] = { "models/weapons/ct_arms.mdl", "models/weapons/t_arms.mdl" };
char defaultModels[][] = { "models/player/ctm_fbi.mdl", "models/player/tm_phoenix.mdl" };

public Plugin myinfo = {

	name = "Skin & Arms Fix",
	author = "NomisCZ (-N-)",
	description = "Arms fix",
	version = "1.0",
	url = "http://steamcommunity.com/id/olympic-nomis-p"
}

public void OnMapStart() {

	PrecacheModels();
}

public void OnPluginStart() {
	
    HookEvent("player_spawn", Event_Spawn, EventHookMode_Post);
} 

public void PrecacheModels() {

	for (int i; i < sizeof(defaultArms); i++) {
		
		PrecacheModel(defaultArms[i])
	}
	
	for (int i; i < sizeof(defaultModels); i++) {
		
		PrecacheModel(defaultModels[i])
	}
}

public Action Event_Spawn(Event gEventHook, const char[] gEventName, bool iDontBroadcast) {

	int client = GetClientOfUserId(gEventHook.GetInt("userid"));
	
	if (isValidClient(client) && IsPlayerAlive(client)) {
	
		CS_UpdateClientModel(client);

		SetEntPropString(client, Prop_Send, "m_szArmsModel", "");
		
		int team = GetClientTeam(client);
		
		if (team == CS_TEAM_T) {
			
			SetEntityModel(client, defaultModels[1]);
			SetEntPropString(client, Prop_Send, "m_szArmsModel", defaultArms[1]);

		} else if (team == CS_TEAM_CT) {
			
			SetEntityModel(client, defaultModels[0]);
			SetEntPropString(client, Prop_Send, "m_szArmsModel", defaultArms[0]);
		}
		
	}

	return Plugin_Continue;
} 

bool isValidClient(int client, bool bot = false) {

	if (client > 0 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && (bot ? IsFakeClient(client) : !IsFakeClient(client))) 
		return true;
	return false;
}