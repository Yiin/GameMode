#include <YSI\y_hooks>

hook OnCharacterDataLoaded(playerid) {
	SetPVarInt(playerid, "spawn", 1);

	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) {
		TogglePlayerSpectating(playerid, false);
	}
	SpawnPlayer(playerid);
}

hook OnPlayerSpawn(playerid) {
	if(GetPVarType(playerid, "spawn")) {
		DeletePVar(playerid, "spawn");
		call OnCharacterSpawn(playerid);
	}
}