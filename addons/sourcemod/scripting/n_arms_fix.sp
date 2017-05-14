/*
 * THANKS:
 	- Headline - https://forums.alliedmods.net/member.php?u=258953
	- SHUFEN.jp - https://forums.alliedmods.net/member.php?u=250145
	- andi67 - https://forums.alliedmods.net/member.php?u=26100
*/

#include <sourcemod>
#include <sdktools>
#include <cstrike>

#pragma semicolon 1
#pragma newdecls required

#define LEGACY_MODELS_PATH 	"models/player/custom_player/legacy/"
#define CURRENT_MODELS_PATH 	"models/player/"

Handle armsHandle;
Handle modelHandle;

char defaultCTFbiModels[][] = {
	"ctm_fbi.mdl",
	"ctm_fbi_variantA.mdl",
	"ctm_fbi_variantB.mdl",
	"ctm_fbi_variantC.mdl",
	"ctm_fbi_variantD.mdl"
};

char defaultCTGignModels[][] = {
	"ctm_gign.mdl",
	"ctm_gign_variantA.mdl",
	"ctm_gign_variantB.mdl",
	"ctm_gign_variantC.mdl",
	"ctm_gign_variantD.mdl"
};

char defaultTAnarchistModels[][] = {
	"tm_anarchist.mdl",
	"tm_anarchist_variantA.mdl",
	"tm_anarchist_variantB.mdl",
	"tm_anarchist_variantC.mdl",
	"tm_anarchist_variantD.mdl"
};

char defaultTPirateModels[][] = {
	"tm_pirate.mdl",
	"tm_pirate_variantA.mdl",
	"tm_pirate_variantB.mdl",
	"tm_pirate_variantC.mdl",
	"tm_pirate_variantD.mdl"
};

char defaultArms[][] = {
	"models/weapons/t_arms.mdl",
	"models/weapons/ct_arms.mdl"
};

public Plugin myinfo = {
	name = "Arms Fix",
	author = "NomisCZ (-N-)",
	description = "Arms fix",
	version = "1.5",
	url = "http://steamcommunity.com/id/olympic-nomis-p"
}

public void OnPluginStart() {

	HookEvent("player_spawn", Event_PlayerSpawn);
}

public void OnConfigsExecuted() {

	PrecacheModels();
	PrecacheModels(true);
	PrecacheArms();
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) {

	RegPluginLibrary("CSGO_ArmsFix");

	armsHandle = CreateGlobalForward("ArmsFix_OnArmsSafe", ET_Ignore, Param_Cell);
	modelHandle = CreateGlobalForward("ArmsFix_OnModelSafe", ET_Ignore, Param_Cell);
	CreateNative("ArmsFix_SetDefaults", Native_SetDefault);
	CreateNative("ArmsFix_HasDefaultArms", Native_HasDefaultArms);

	return APLRes_Success;
}

public Action Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast) {

	int client = GetClientOfUserId(event.GetInt("userid"));

	if ((!IsValidClient(client) && !IsPlayerAlive(client) || IsFakeClient(client))) return;

	SetDefault(client);
	CallForwards(client);
}

public void CallForwards(int client) {

	CallArmsForward(client);
	CreateTimer(0.5, Timer_CallModelForward, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_CallModelForward(Handle timer, int client) {

	CallModelForward(GetClientOfUserId(client));
}

public void CallModelForward(int client) {

	Call_StartForward(modelHandle);
	Call_PushCell(client);
	Call_Finish();
}

public void CallArmsForward(int client) {

	Call_StartForward(armsHandle);
	Call_PushCell(client);
	Call_Finish();
}

public int Native_SetDefault(Handle plugin, int numParams) {

    int client = GetNativeCell(1);
    SetDefault(client);
}

public int Native_HasDefaultArms(Handle plugin, int numParams) {

    int client = GetNativeCell(1);
    return view_as<bool>(hasDefaultArms(client));
}

void PrecacheModels(bool legacy = false) {

	char modelsPath[256];
	char tempModel[256];
	Format(modelsPath, sizeof(modelsPath), "%s", (legacy) ? LEGACY_MODELS_PATH : CURRENT_MODELS_PATH);

	for (int i = 0; i < sizeof(defaultCTFbiModels); i++)
	{
		Format(tempModel, sizeof(tempModel), "%s%s", modelsPath, defaultCTFbiModels[i]);
		if(defaultCTFbiModels[i][0] && !IsModelPrecached(tempModel))
			PrecacheModel(tempModel);
	}

	for (int i = 0; i < sizeof(defaultCTGignModels); i++)
	{
		Format(tempModel, sizeof(tempModel), "%s%s", modelsPath, defaultCTGignModels[i]);
		if(defaultCTGignModels[i][0] && !IsModelPrecached(tempModel))
			PrecacheModel(tempModel);
	}

	for (int i = 0; i < sizeof(defaultTAnarchistModels); i++)
	{
		Format(tempModel, sizeof(tempModel), "%s%s", modelsPath, defaultTAnarchistModels[i]);
		if(defaultTAnarchistModels[i][0] && !IsModelPrecached(tempModel))
			PrecacheModel(tempModel);
	}

	for (int i = 0; i < sizeof(defaultTPirateModels); i++)
	{
		Format(tempModel, sizeof(tempModel), "%s%s", modelsPath, defaultTPirateModels[i]);
		if(defaultTPirateModels[i][0] && !IsModelPrecached(tempModel))
			PrecacheModel(tempModel);
	}
}

void PrecacheArms() {

	for (int i = 0; i < sizeof(defaultArms); i++) {

		if (defaultArms[i][0] && !IsModelPrecached(defaultArms[i])) {

			PrecacheModel(defaultArms[i]);
		}
	}
}

public void SetDefault(int client) {

	if ((!IsValidClient(client) && !IsPlayerAlive(client) || IsFakeClient(client))) return;

	int clientTeam = (GetClientTeam(client) == CS_TEAM_T ? 0 : 1);
	char newModel[256];
	newModel = GetNewRandomModel(client);

	if (IsModelPrecached(newModel)) {

		CS_UpdateClientModel(client);
		SetEntityModel(client, newModel);
	} else {

		PrintToChat(client, "There is a problem with skin %s precaching. Please contact server administrator", newModel);
		return;
	}

	if (!hasDefaultArms(client)) {
		SetEntPropString(client, Prop_Send, "m_szArmsModel", "");
		SetEntPropString(client, Prop_Send, "m_szArmsModel", defaultArms[clientTeam]);
	}
}

char GetNewRandomModel(int client) {

	char clientModel[256];
	GetEntPropString(client, Prop_Data, "m_ModelName", clientModel, sizeof(clientModel));

	char modelBits[5][64];
	char modelSubBits[2][64];
	char modelSubBitsType[2][15];
	char newModelPath[256];

	ExplodeString(clientModel, "/", modelBits, sizeof(modelBits), sizeof(modelBits[]));

	if (StrEqual(modelBits[2], "custom_player", true) && StrContains(modelBits[4], ".mdl", true)) {

		Format(newModelPath, sizeof(newModelPath), "models/player/custom_player/legacy/");
		ExplodeString(modelBits[4], "_", modelSubBits, sizeof(modelSubBits), sizeof(modelSubBits[]));

	} else if (StrContains(modelBits[2], ".mdl", true)) {

		Format(newModelPath, sizeof(newModelPath), "models/player/");
		ExplodeString(modelBits[2], "_", modelSubBits, sizeof(modelSubBits), sizeof(modelSubBits[]));
	}

	ExplodeString(modelSubBits[1], ".", modelSubBitsType, sizeof(modelSubBitsType), sizeof(modelSubBitsType[]));

	if (StrEqual(modelSubBits[0], "ctm", true)) {

		if (StrEqual(modelSubBitsType[0], "fbi", true)) {
			Format(newModelPath, sizeof(newModelPath), "%s%s", newModelPath, defaultCTGignModels[GetRandomInt(0 , sizeof(defaultCTGignModels) - 1)]);
		} else if (StrEqual(modelSubBitsType[0], "gign", true)) {
			Format(newModelPath, sizeof(newModelPath), "%s%s", newModelPath, defaultCTFbiModels[GetRandomInt(0 , sizeof(defaultCTFbiModels) - 1)]);
		} else if (StrEqual(modelSubBitsType[0], "gsg9", true)) {
			Format(newModelPath, sizeof(newModelPath), "%s%s", newModelPath, defaultCTFbiModels[GetRandomInt(0 , sizeof(defaultCTFbiModels) - 1)]);
		} else if (StrEqual(modelSubBitsType[0], "idf", true)) {
			Format(newModelPath, sizeof(newModelPath), "%s%s", newModelPath, defaultCTFbiModels[GetRandomInt(0 , sizeof(defaultCTFbiModels) - 1)]);
		} else if (StrEqual(modelSubBitsType[0], "sas", true)) {
			Format(newModelPath, sizeof(newModelPath), "%s%s", newModelPath, defaultCTGignModels[GetRandomInt(0 , sizeof(defaultCTGignModels) - 1)]);
		} else if (StrEqual(modelSubBitsType[0], "st6", true)) {
			Format(newModelPath, sizeof(newModelPath), "%s%s", newModelPath, defaultCTFbiModels[GetRandomInt(0 , sizeof(defaultCTFbiModels) - 1)]);
		} else if (StrEqual(modelSubBitsType[0], "swat", true)) {
			Format(newModelPath, sizeof(newModelPath), "%s%s", newModelPath, defaultCTGignModels[GetRandomInt(0 , sizeof(defaultCTGignModels) - 1)]);
		}

	} else if (StrEqual(modelSubBits[0], "tm", true)) {

		if (StrEqual(modelSubBitsType[0], "anarchist", true)) {
			Format(newModelPath, sizeof(newModelPath), "%s%s", newModelPath, defaultTPirateModels[GetRandomInt(0 , sizeof(defaultTPirateModels) - 1)]);
		} else if (StrEqual(modelSubBitsType[0], "balkan", true)) {
			Format(newModelPath, sizeof(newModelPath), "%s%s", newModelPath, defaultTAnarchistModels[GetRandomInt(0 , sizeof(defaultTAnarchistModels) - 1)]);
		} else if (StrEqual(modelSubBitsType[0], "leet", true)) {
			Format(newModelPath, sizeof(newModelPath), "%s%s", newModelPath, defaultTAnarchistModels[GetRandomInt(0 , sizeof(defaultTAnarchistModels) - 1)]);
		} else if (StrEqual(modelSubBitsType[0], "phoenix", true)) {
			Format(newModelPath, sizeof(newModelPath), "%s%s", newModelPath, defaultTPirateModels[GetRandomInt(0 , sizeof(defaultTPirateModels) - 1)]);
		} else if (StrEqual(modelSubBitsType[0], "pirate", true)) {
			Format(newModelPath, sizeof(newModelPath), "%s%s", newModelPath, defaultTAnarchistModels[GetRandomInt(0 , sizeof(defaultTAnarchistModels) - 1)]);
		} else if (StrEqual(modelSubBitsType[0], "professional", true)) {
			Format(newModelPath, sizeof(newModelPath), "%s%s", newModelPath, defaultTAnarchistModels[GetRandomInt(0 , sizeof(defaultTAnarchistModels) - 1)]);
		} else if (StrEqual(modelSubBitsType[0], "separatist", true)) {
			Format(newModelPath, sizeof(newModelPath), "%s%s", newModelPath, defaultTAnarchistModels[GetRandomInt(0 , sizeof(defaultTAnarchistModels) - 1)]);
		}
	}

	return newModelPath;
}

bool IsValidClient(int client) {

	return (client > 0 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client)) ? true : false;
}

bool hasDefaultArms(int client) {

	char clientModel[256];
	GetEntPropString(client, Prop_Send, "m_szArmsModel", clientModel, sizeof(clientModel));

	return (StrEqual(clientModel, defaultArms[0]) || StrEqual(clientModel, defaultArms[1]) || StrEqual(clientModel, "")) ? true : false;
}
