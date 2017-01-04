#include <YSI\y_hooks>

/**
 * Variables
 */

static Text:TD_LoadingPreviewSkin;
static Text:TD_CreateCharacterKeyInfo;
static Text:TD_SpawnKeyInfo;
static Text:TD_ArrowLeft;
static Text:TD_ArrowRight;
static PlayerText:PlayerTD_CharacterName[MAX_PLAYERS];

/**
 * Events
 */

hook OnPlayerEvent(playerid, event) {
	switch(event) {
		case EVENT_LOADING_PREVIEW_SKIN: {
			TextDrawShowForPlayer(playerid, TD_LoadingPreviewSkin);
		}
		case EVENT_LOADED_PREVIEW_SKIN: {
			TextDrawHideForPlayer(playerid, TD_LoadingPreviewSkin);
		}
	}
}

hook OnCharacterStateUpdate(playerid, new_state) {
	HideEverything(playerid);

	switch(new_state) {
		case CHARACTER_SELECTION_STATE_SELECTING_CHARACTER: {
			TextDrawShowForPlayer(playerid, TD_CreateCharacterKeyInfo);
			TextDrawShowForPlayer(playerid, TD_SpawnKeyInfo);
			TextDrawShowForPlayer(playerid, TD_ArrowLeft);
			TextDrawShowForPlayer(playerid, TD_ArrowRight);
		}
		case CHARACTER_SELECTION_STATE_SELECTING_SKIN: {
			TextDrawShowForPlayer(playerid, TD_SpawnKeyInfo);
			TextDrawShowForPlayer(playerid, TD_ArrowLeft);
			TextDrawShowForPlayer(playerid, TD_ArrowRight);

			static playerName[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playerName);

			PlayerTextDrawSetString(playerid, PlayerTD_CharacterName[playerid], playerName);
			PlayerTextDrawShow(playerid, PlayerTD_CharacterName[playerid]);
		}
	}
}

hook OnGameModeInit() {
	TD_LoadingPreviewSkin = TextDrawCreate(320.000000, 215.250000, "Palaukite...");
	TextDrawLetterSize(TD_LoadingPreviewSkin, 0.298000, 1.640832);
	TextDrawAlignment(TD_LoadingPreviewSkin, 2);
	TextDrawColor(TD_LoadingPreviewSkin, -1);
	TextDrawSetShadow(TD_LoadingPreviewSkin, 0);
	TextDrawSetOutline(TD_LoadingPreviewSkin, 1);
	TextDrawBackgroundColor(TD_LoadingPreviewSkin, 51);
	TextDrawFont(TD_LoadingPreviewSkin, 2);
	TextDrawSetProportional(TD_LoadingPreviewSkin, 1);

	TD_CreateCharacterKeyInfo = TextDrawCreate(476.333190, 337.259399, "~Y~~k~~PED_FIREWEAPON~~W~~H~~H~ - Kurti nauja veikeja");
	TextDrawLetterSize(TD_CreateCharacterKeyInfo, 0.229000, 1.438222);
	TextDrawAlignment(TD_CreateCharacterKeyInfo, 2);
	TextDrawColor(TD_CreateCharacterKeyInfo, -1);
	TextDrawSetShadow(TD_CreateCharacterKeyInfo, 0);
	TextDrawSetOutline(TD_CreateCharacterKeyInfo, 1);
	TextDrawBackgroundColor(TD_CreateCharacterKeyInfo, 255);
	TextDrawFont(TD_CreateCharacterKeyInfo, 2);
	TextDrawSetProportional(TD_CreateCharacterKeyInfo, 1);
	TextDrawSetShadow(TD_CreateCharacterKeyInfo, 0);

	TD_SpawnKeyInfo = TextDrawCreate(471.666503, 357.585662, "~Y~~k~~VEHICLE_ENTER_EXIT~~W~~H~~H~ - Pradeti zaidima");
	TextDrawLetterSize(TD_SpawnKeyInfo, 0.229000, 1.438222);
	TextDrawAlignment(TD_SpawnKeyInfo, 2);
	TextDrawColor(TD_SpawnKeyInfo, -1);
	TextDrawSetShadow(TD_SpawnKeyInfo, 0);
	TextDrawSetOutline(TD_SpawnKeyInfo, 1);
	TextDrawBackgroundColor(TD_SpawnKeyInfo, 255);
	TextDrawFont(TD_SpawnKeyInfo, 2);
	TextDrawSetProportional(TD_SpawnKeyInfo, 1);
	TextDrawSetShadow(TD_SpawnKeyInfo, 0);

	TD_ArrowLeft = TextDrawCreate(191.333389, 229.666671, "LD_BEAT:left");
	TextDrawLetterSize(TD_ArrowLeft, 0.000000, 0.000000);
	TextDrawTextSize(TD_ArrowLeft, 25.000000, 25.000000);
	TextDrawAlignment(TD_ArrowLeft, 1);
	TextDrawColor(TD_ArrowLeft, -1);
	TextDrawSetShadow(TD_ArrowLeft, 0);
	TextDrawSetOutline(TD_ArrowLeft, 0);
	TextDrawBackgroundColor(TD_ArrowLeft, 255);
	TextDrawFont(TD_ArrowLeft, 4);
	TextDrawSetProportional(TD_ArrowLeft, 0);
	TextDrawSetShadow(TD_ArrowLeft, 0);

	TD_ArrowRight = TextDrawCreate(415.666656, 229.666687, "LD_BEAT:right");
	TextDrawLetterSize(TD_ArrowRight, 0.000000, 0.000000);
	TextDrawTextSize(TD_ArrowRight, 25.000000, 25.000000);
	TextDrawAlignment(TD_ArrowRight, 1);
	TextDrawColor(TD_ArrowRight, -1);
	TextDrawSetShadow(TD_ArrowRight, 0);
	TextDrawSetOutline(TD_ArrowRight, 0);
	TextDrawBackgroundColor(TD_ArrowRight, 255);
	TextDrawFont(TD_ArrowRight, 4);
	TextDrawSetProportional(TD_ArrowRight, 0);
	TextDrawSetShadow(TD_ArrowRight, 0);
}

hook OnPlayerConnect(playerid) {
	PlayerTD_CharacterName[playerid] = CreatePlayerTextDraw(playerid, 315.666412, 352.607330, "Vardas_Pavarde");
	PlayerTextDrawLetterSize(playerid, PlayerTD_CharacterName[playerid], 0.593667, 2.404741);
	PlayerTextDrawAlignment(playerid, PlayerTD_CharacterName[playerid], 2);
	PlayerTextDrawColor(playerid, PlayerTD_CharacterName[playerid], -1);
	PlayerTextDrawSetShadow(playerid, PlayerTD_CharacterName[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PlayerTD_CharacterName[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD_CharacterName[playerid], 255);
	PlayerTextDrawFont(playerid, PlayerTD_CharacterName[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerTD_CharacterName[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerTD_CharacterName[playerid], 0);
}

/**
 * Methods
 */

static HideEverything(playerid) {
	TextDrawHideForPlayer(playerid, TD_LoadingPreviewSkin);
	TextDrawHideForPlayer(playerid, TD_CreateCharacterKeyInfo);
	TextDrawHideForPlayer(playerid, TD_SpawnKeyInfo);
	TextDrawHideForPlayer(playerid, TD_ArrowLeft);
	TextDrawHideForPlayer(playerid, TD_ArrowRight);
	PlayerTextDrawHide(playerid, PlayerTD_CharacterName[playerid]);
}