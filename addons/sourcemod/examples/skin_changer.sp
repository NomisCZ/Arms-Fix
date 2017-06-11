#include <sourcemod>
#include <sdktools>
#include <n_arms_fix>

public Plugin myinfo =
{
	name = "Example: My basic player skin changer",
	author = "NomisCZ",
	description = "Skin for players",
	version = "1.0",
	url = "http://steamcommunity.com/id/olympic-nomis-p"
}

public void OnPluginStart() {

	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
}

public Action Event_PlayerSpawn(Handle event,  const char[] name, bool dontBroadcast) {

	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	PlayerArmsModel(client);
	CreateTimer(1.5, PlayerModel, client); //1.5 is optimal!
}

public void PlayerArmsModel(int client) {

	if(!IsValidClient(client))
		return;

	ArmsFix_SetDefaults(client);
	SetEntPropString(client, Prop_Send, "m_szArmsModel", "models/player/custom_player/xxx/yyy_arms.mdl");
}

public Action PlayerModel(Handle timer, any client) {

	if(!IsValidClient(client))
		return;

	SetEntityModel(client, "models/player/custom_player/xxx/yyy.mdl");
	SetEntityRenderColor(client, 255, 255, 255, 255);
}

bool IsValidClient(int client) {

	return (client > 0 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client)) ? true : false;
}
