#include <YSI\y_hooks>

/**
 * Variables
 */

// http://gtastuff.com/skinsall/
// http://gamemode.x.yiin.lt/list-skins.php?models=58,190,202,151,101,12,35,55,168,298,37,41,249,79,152

// TODO: Skins definitions, get rid of magic numbers
static const models[] = {
	58, 190, 202, 151, 101, 12, 35, 
	55, 168, 298, 37, 41, 249, 79, 152
};

static Float:actors_positions[][4] = {
	 {-564.5436,2369.6616,77.7350,114.7205}
	,{-562.2312,2363.0566,77.5467,133.5208}
	,{-554.6909,2360.1243,76.2686,206.0059}
	,{-550.1262,2363.6936,75.9591,216.8682}
	,{-543.7626,2358.2278,75.1132,221.9860}
	,{-549.1489,2358.9683,75.4656,204.7525}
	,{-553.1791,2356.3665,76.1099,181.6701}
	,{-543.2001,2355.3569,74.8150,212.6092}
	,{-574.2022,2370.3555,79.1887,121.9506}
};
static ActorsIds[MAX_PLAYERS][MAX_CHARACTERS];
static Text3D:ActorsInfo[MAX_PLAYERS][MAX_CHARACTERS];
static ActorsNames[MAX_PLAYERS][MAX_CHARACTERS][MAX_PLAYER_NAME];
static AmountOfActors[MAX_PLAYERS];

static selected_skin_index[MAX_PLAYERS];
static selected_character_index[MAX_PLAYERS];
static ShouldCameraCut[MAX_PLAYERS char];

/**
 * Public methods
 */
CreateNewCharacter(playerid) {
	CreateNewCharacter_impl(playerid);
}

DeleteCharacter(playerid, index = -1) {
	DeleteCharacter_impl(playerid, index);
}

DespawnCharacter(playerid, update_position = false) {
	call OnCharacterDespawn(playerid, update_position);

	PrepareForCharacterSelection(playerid);

	ShowCharacterSelection(playerid, .reset_selected_character_index = false);
}

ShowCharacterSelection(playerid, bool:reset_selected_character_index = true, bool:show_last_character = false) {
	ShowCharacterSelection_impl(playerid, reset_selected_character_index, show_last_character);
}

/**
 * Events
 */

hook OnCharacterStateUpdate(playerid, newstate) {
	switch(newstate) {
		case CHARACTER_SELECTION_STATE_SELECTING_NAME: M:P:I(playerid, "CHARACTER_SELECTION_STATE_SELECTING_NAME");
		case CHARACTER_SELECTION_STATE_SELECTING_CHARACTER: M:P:I(playerid, "CHARACTER_SELECTION_STATE_SELECTING_CHARACTER");
		case CHARACTER_SELECTION_STATE_SELECTING_SKIN: M:P:I(playerid, "CHARACTER_SELECTION_STATE_SELECTING_SKIN");
		case CHARACTER_SELECTION_STATE_WAITING_FOR_SPECTATE: M:P:I(playerid, "CHARACTER_SELECTION_STATE_WAITING_FOR_SPECTATE");
		case CHARACTER_SELECTION_STATE_WAITING_FOR_NEW_CHARACTER: M:P:I(playerid, "CHARACTER_SELECTION_STATE_WAITING_FOR_NEW_CHARACTER");
		case CHARACTER_SELECTION_STATE_NEW_CHARACTER_JUST_CREATED: M:P:I(playerid, "CHARACTER_SELECTION_STATE_NEW_CHARACTER_JUST_CREATED");
		case CHARACTER_STATE_NONE: M:P:I(playerid, "CHARACTER_STATE_NONE");
	}
}

hook OnPlayerConnect(playerid) {
	if(IsPlayerNPC(playerid)) {
		return;
	}
	ResetActors(playerid);
}

hook OnPlayerFullyConnected(playerid) {
	// Parodom ferrie wheel ið cinematic pozicijos
	SetPlayerCameraPos(playerid, 362.1511, -2048.9016, 8.7793);
	SetPlayerCameraLookAt(playerid, 362.8162, -2048.1565, 9.0893);

	ShouldCameraCut{playerid} = true;
}

// Kai þaidëjas uþsiregistruoja, rodom jam veikëjo kûrimo langà
hook OnPlayerRegister(playerid, user_id) {
	PrepareForCharacterSelection(playerid);

	CreateNewCharacter(playerid);
}

// Jeigu þaidëjas prisijungia prie acc, leidþiam jam pasirinkti norimà veikëjà
hook OnPlayerLogin(playerid, user_id) {
	PrepareForCharacterSelection(playerid);

	ShowCharacterSelection(playerid);
}

// Kai þaidëjui pakraunamas aktorius
hook OnActorStreamIn(actorid, forplayerid) {
	switch(CharacterState(forplayerid)) {
		// Jeigu ðiuo metu þaidëjas renkasi veikëjo skinà,
		// patikrinam ar uþkrautas veikëjas yra tas, kurio skinà þaidëjas renkasi
		case CHARACTER_SELECTION_STATE_SELECTING_SKIN: {
			new newCharacterIndex = AmountOfActors[forplayerid];

			if(actorid == ActorsIds[forplayerid][newCharacterIndex]) {
				call OnPlayerEvent(forplayerid, EVENT_LOADED_PREVIEW_SKIN);
			}
		}
		// Jeigu þaidëjui kraunami jo veikëjai, patikrinam ar pakrautas dabartinis pasirinktas veikëjas
		case CHARACTER_SELECTION_STATE_SELECTING_CHARACTER: {
			new currentSelectedCharacterIndex = GetSelectedCharacterIndex(forplayerid);

			if(currentSelectedCharacterIndex < sizeof (ActorsIds[])) {
				if(actorid == ActorsIds[forplayerid][currentSelectedCharacterIndex]) {
					call OnPlayerEvent(forplayerid, EVENT_LOADED_PREVIEW_SKIN);
				}
			}
		}
	}
	return true;
}

hook OnCharacterSpawn(playerid) {
	ResetActors(playerid);
}

hook OnPlayerDisconnect(playerid, reason) {
	switch(CharacterState(playerid)) {
		case CHARACTER_SELECTION_STATE_SELECTING_NAME,
			 CHARACTER_SELECTION_STATE_SELECTING_CHARACTER,
			 CHARACTER_SELECTION_STATE_SELECTING_SKIN,
			 CHARACTER_SELECTION_STATE_WAITING_FOR_SPECTATE: {
			// do nothing
		}
		default: {
			DespawnCharacter(playerid, .update_position = true);
		}
	}
	ResetActors(playerid);
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
	if(newstate == PLAYER_STATE_SPECTATING) {
		// gráþtam á veikëjo pasirinkimà ið þaidimo
		if(CharacterState(playerid) == CHARACTER_SELECTION_STATE_WAITING_FOR_SPECTATE) {
			ShouldCameraCut{playerid} = true;

			defer ResetToCharSelectionState(playerid);
		}
	}
}

timer ResetToCharSelectionState[100](playerid) {
	CharacterState(playerid, CHARACTER_SELECTION_STATE_SELECTING_CHARACTER);
	SetCameraInFrontOfActor(playerid, GetSelectedCharacterIndex(playerid), false);
}

hook OnCharCreationStart(playerid) {
	ResetActors(playerid);
	PopulateActors(playerid);
}

hook OnPlayerUpdate(playerid) {
	if(CharacterState(playerid) == CHARACTER_SELECTION_STATE_SELECTING_CHARACTER) {
		SelectingCharacterTick(playerid);
	}
	if(CharacterState(playerid) == CHARACTER_SELECTION_STATE_SELECTING_SKIN) {
		SelectingSkinTick(playerid);
	}
	return true;
}

hook OnCharacterCreated(playerid) {
	CharacterState(playerid, CHARACTER_SELECTION_STATE_NEW_CHARACTER_JUST_CREATED);

	defer TestStuff(playerid);
}

timer TestStuff[1000](playerid) {
	new Cache:cache = mysql_query("SELECT * FROM characters WHERE user_id = %i", GetPlayerAccountID(playerid));
	new count = cache_num_rows();
	cache_delete(cache);

	if(!count) {
		defer TestStuff(playerid);
	}
	else {
		ShowCharacterSelection(playerid, false, true);
	}
}

hook OnCharacterDeleted(playerid, index) {
	ResetActors(playerid);

	ShouldCameraCut{playerid} = false;
	ShowCharacterSelection(playerid, false);
}

/**
 * Methods
 */

// Minimaliai paruoðiam þaidëjà veikëjo pasirinkimui
static PrepareForCharacterSelection(playerid) {
	// Nukeliam þaidëjà á jam unikalø virtual world
	new uniqueVirtualWorld = playerid + VW_OFFSET_CHARSELECT;

	if(GetPlayerVirtualWorld(playerid) != uniqueVirtualWorld) {
		SetPlayerVirtualWorld(playerid, uniqueVirtualWorld);
	}

	// Nustatom þaidëjo state á spectate (þaidëjas jau buvo þaidime)
	if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) {
		TogglePlayerSpectating(playerid, true);
		CharacterState(playerid, CHARACTER_SELECTION_STATE_WAITING_FOR_SPECTATE);
	}
	// pakeièiam vardà á accounto, o ne veikëjo
	SetPlayerName(playerid, GetPlayerAccountName(playerid));
}

static CreateNewCharacter_impl(playerid) {
	call OnCharCreationStart(playerid);

	// pasiþymim, kad þaidëjas ðiuo metu kuria naujà veikëjà
	CharacterState(playerid, CHARACTER_SELECTION_STATE_SELECTING_NAME);

	new characters_count = AmountOfActors[playerid] = mysql_count_in_table("characters", "where user_id = %i", GetPlayerAccountID(playerid));

	// jeigu þaidëjas pasiekë turimø veikëjø limità, gràþinam atgal á veikëjø pasirinkimo state 
	if(characters_count >= MAX_CHARACTERS) {
		call OnCharCreationError(playerid, CHARACTER_CREATION_ERROR_CHARACTERS_LIMIT_REACHED);

		ShowCharacterSelection(playerid);
		return;
	}

	// nustatom kamerà á tà vietà kurioje bus naujas veikëjas
	SetCameraInFrontOfActor(playerid, AmountOfActors[playerid], false);

	inline OnPlayerEnterCharName(re) {
		if(! re) {
			// jeigu þaidëjas atðaukë veikëjo kûrimà, taèiau neturi sukûræs jokiø kitø veikëjø, papraðom susikurti arba iðeiti
			if( ! AmountOfActors[playerid]) {
				WarnAboutExit(playerid);
			}
			else {
				// kitu atveju tiesiog gràþinam á veikëjø pasirinkimo screen
				ShowCharacterSelection(playerid);
			}
		}
		else {
			// Jeigu blogas nick, rodom dialogà ið naujo
			if(InvalidNick(playerid, GetInputText())) {
				call OnCharCreationError(playerid, CHARACTER_CREATION_ERROR_INVALID_NAME);
				CreateNewCharacter(playerid);
			}
			else {
				// patikrinam ar veikëjo vardas yra uþimtas
				if(mysql_exists_in_table("characters", "WHERE name = '%s' LIMIT 1", GetInputText())) {
					ClearChat(playerid, .everything = false);

					call OnCharCreationError(playerid, CHARACTER_CREATION_ERROR_NAME_ALREADY_EXISTS);

					// gràþinam á kûrimo langà
					CreateNewCharacter(playerid);
					return;
				}
				// nustatom þaidëjui veikëjo vardà
				SetPlayerName(playerid, GetInputText());

				call OnPlayerSelectsCharName(playerid, GetInputText());

				// iðsaugom vardà naujam aktoriui
				strcpy(ActorsNames[playerid][characters_count], GetInputText());
				
				// duodam pasirinkti skinà
				CharacterState(playerid, CHARACTER_SELECTION_STATE_SELECTING_SKIN);
				call OnPlayerEvent(playerid, EVENT_LOADING_PREVIEW_SKIN);

				// nuo paèio pirmo
				ResetSelectedSkinIndex(playerid);
				
				// ir parodom pirmà skinà
				SetCameraInFrontOfActor(playerid, AmountOfActors[playerid]);

				M:P:I(playerid, "Pasirinkus norimà iðvaizdà, raðyk [highlight]/kurti[] arba spausk [highlight]ENTER[].");
			}
		}
	}

	SetDialogHeader("Áraðyk veikëjo vardà ir pavardæ");
	SetDialogBody("\
		Vardà ir pavardæ gali sudaryti maþiausiai 3 simboliai.\n\
		Vardà ir pavardæ reikia áraðyti [highlight]Vardas_Pavardë[] formatu.\
	");

	ShowDialog(playerid, using inline OnPlayerEnterCharName, DIALOG_STYLE_INPUT, "Veikëjo kûrimas", "Kurti", characters_count ? "Atgal" : "Iðeiti");
}
 
static SelectingSkinTick(playerid) {
	static keys, lr, ud;
	static lastState[MAX_PLAYERS];
	GetPlayerKeys(playerid, keys, ud, lr);

	// Jei paspaudþia enter
	if(keys & KEY_SECONDARY_ATTACK) {
		LoadCreatedCharacter(playerid);
		return;
	}

	if(lastState[playerid] != lr) {
		if(lr) {
			if(lr > 0) { // RIGHT = NEXT
				IncreaseSelectedSkinIndex(playerid);
			}
			else if(lr < 0) { // LEFT = PREV
				DecreaseSelectedSkinIndex(playerid);
			}
			SetCameraInFrontOfActor(playerid, AmountOfActors[playerid]);
		}
	}
	lastState[playerid] = lr;
}

static SelectingCharacterTick(playerid) {
	static keys, lr, ud;
	static lastState[MAX_PLAYERS];
	GetPlayerKeys(playerid, keys, ud, lr);

	if(keys & KEY_SECONDARY_ATTACK) {
		SetPlayerName(playerid, ActorsNames[playerid][ GetSelectedCharacterIndex(playerid) ]);

		LoadCharacter(playerid);
		return;
	}

	if(lastState[playerid] != lr) {
		if(lr) {
			if(lr > 0) { // RIGHT
				IncreaseSelectedCharacterIndex(playerid);
			}
			else if(lr < 0) { // LEFT
				DecreaseSelectedCharacterIndex(playerid);
			}
			SetCameraInFrontOfActor(playerid, GetSelectedCharacterIndex(playerid), false);
		}
	}
	lastState[playerid] = lr;
}

static WarnAboutExit(playerid) {
	inline response(re, li) {
		#pragma unused li
		if(re) {
			CreateNewCharacter(playerid);
		}
		else {
			Kick(playerid);
		}
	}
	SetDialogHeader("Ar tikrai nori palikti serverá?");
	SetDialogBody("\
		Norint þaisti serveryje, privaloma susikurti veikëjà, \n\
		taèiau jeigu nori palikti serverá - paspausk mygtukà \"Iðeiti\"\
	");
	ShowDialog(playerid, using inline response, DIALOG_STYLE_MSGBOX, 
		"Iðëjimas ið serverio",
		"Kurti veikëjà", "Iðeiti");
}

static LoadCreatedCharacter(playerid) {
	new skin = GetSkinModel(GetSelectedSkinIndex(playerid));

	// pridedam tà skinà prie available skinø
	ToggleCharacterAvailableSkin(playerid, skin, true);

	// nustatom veikëjo iðvaizdà
	CharacterCurrentSkin(playerid, skin);
	CharacterDefaultSkin(playerid, skin);

	// þaidëjo pradinæ pozicijà
	static const spawn[][4] = {
		{691.7983,-456.3943,21.1520,205.2159},
		{690.8474,-457.6801,21.1520,138.4986},
		{689.4923,-457.0272,21.1520,55.9868},
		{689.3723,-454.9702,21.1520,1.3618},
		{690.7418,-454.3200,21.1520,276.1344},
		{692.5672,-454.1240,21.1520,276.1344},
		{694.3040,-454.6622,21.1520,252.7386}
	};
	new index = random(sizeof spawn);
	CharacterPosition(playerid, spawn[index][0], spawn[index][1], spawn[index][2], spawn[index][3]);

	// kada jis sukurtas
	CharacterCreatedAt(playerid, gettime());

	// sukuriam veikëjà
	CreateCharacter(playerid);

	CharacterState(playerid, CHARACTER_SELECTION_STATE_WAITING_FOR_NEW_CHARACTER);
}

static ShowCharacterSelection_impl(playerid, bool:reset_selected_character_index = true, bool:show_last_character = false) {
	// jeigu þaidëjas neturi susikûræs jokiø veikëjø, pradedam veikëjo kûrimà
	if(PopulateActors(playerid) == 0) {
		if(ActorsIds[playerid][0] == INVALID_ACTOR_ID) {
			CreateNewCharacter(playerid);
			return;
		}
	}
	call OnCharacterSelection(playerid);

	if(reset_selected_character_index) {
		ResetSelectedCharacterIndex(playerid);
	}
	else {
		if(GetSelectedCharacterIndex(playerid) >= AmountOfActors[playerid]
			|| show_last_character) {
			ResetSelectedCharacterIndex(playerid, AmountOfActors[playerid] - 1);
		}
	}

	if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) {
		TogglePlayerSpectating(playerid, true);
		CharacterState(playerid, CHARACTER_SELECTION_STATE_WAITING_FOR_SPECTATE);
	}
	else { // þaidëjas kà tik prisijungë, specatate jau ájungtas nuo OnPlayerConnect
		SetCameraInFrontOfActor(playerid, GetSelectedCharacterIndex(playerid), false);
		CharacterState(playerid, CHARACTER_SELECTION_STATE_SELECTING_CHARACTER);
	}

	call OnPlayerEvent(playerid, EVENT_LOADING_PREVIEW_SKIN);
}

static DeleteCharacter_impl(playerid, index) {
	if(index == -1) {
		index = GetSelectedCharacterIndex(playerid);
	}
	cache_delete(mysql_query("DELETE FROM characters WHERE name = '%s'", ActorsNames[playerid][index]));

	call OnCharacterDeleted(playerid, index);
}

static ResetActors(playerid) {
	for(new i; i < MAX_CHARACTERS; ++i) {
		if(IsValidActor(ActorsIds[playerid][i])) {
			DestroyActor(ActorsIds[playerid][i]);
		}
		if(IsValidDynamic3DTextLabel(ActorsInfo[playerid][i])) {
			DestroyDynamic3DTextLabel(ActorsInfo[playerid][i]);
		}
		ActorsIds[playerid][i] = INVALID_ACTOR_ID;
		ActorsInfo[playerid][i] = Text3D:INVALID_3DTEXT_ID;
	}
}

static PopulateActors(playerid) {
	new Cache:cache = mysql_query("SELECT * FROM characters WHERE user_id = %i", GetPlayerAccountID(playerid));
	AmountOfActors[playerid] = cache_num_rows();

	new i = 0;
	if(AmountOfActors[playerid]) do {
		static name[MAX_PLAYER_NAME];
		cache_get_value_name(i, "name", name);
		if( ! isnull(name)) {
			ActorsNames[playerid][i][0] = EOS;
			strcat(ActorsNames[playerid][i], name);
		}
		new charactermodel = cache_get_value_name_int(i, "current_skin");

		static Float:x, Float:y, Float:z, Float:a;
		GetActorDefinedPosition(i, x, y, z, a);
		
		if(IsValidDynamic3DTextLabel(ActorsInfo[playerid][i])) {
			DestroyDynamic3DTextLabel(ActorsInfo[playerid][i]);
		}
		ActorsInfo[playerid][i] = CreateDynamic3DTextLabel(name, 0x00FF00FF, x, y, z + 1.2, 30, .playerid = playerid);

		if(IsValidActor(ActorsIds[playerid][i])) {
			DestroyActor(ActorsIds[playerid][i]);
		}
		new current_actor = ActorsIds[playerid][i] = CreateActor(charactermodel, x, y, z, a);
		SetActorVirtualWorld(current_actor, playerid + VW_OFFSET_CHARSELECT);
		SetActorInvulnerable(current_actor);
	}
	while(++i < AmountOfActors[playerid] && i < MAX_CHARACTERS);

	Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);

	cache_delete(cache);
	return AmountOfActors[playerid];
}

static SetCameraInFrontOfActor(playerid, i, bool:update_skin = true) {
	static Float:x, Float:y, Float:z, Float:a;
	GetActorDefinedPosition(i, x, y, z, a);

	if(update_skin) {
		if(IsValidActor(ActorsIds[playerid][i])) {
			DestroyActor(ActorsIds[playerid][i]);
		}

		ActorsIds[playerid][i] = CreateActor(GetSkinModel(GetSelectedSkinIndex(playerid)), x, y, z, a);
		SetActorVirtualWorld(ActorsIds[playerid][i], VW_OFFSET_CHARSELECT + playerid);

		call OnPlayerEvent(playerid, EVENT_LOADING_PREVIEW_SKIN);
	}
	new
		Float:cam_x = x,
		Float:cam_y = y,
		Float:cam_z = z,
		Float:cam_a = a
	;
	GetXYInFrontOfPoint(cam_x, cam_y, cam_z, cam_a, update_skin ? 3.2 : 4.5);
	SetPlayerCameraPos(playerid, cam_x, cam_y, cam_z + 1.3);
	SetPlayerCameraLookAt(playerid, x, y, z, ShouldCameraCut{playerid} ? CAMERA_CUT : CAMERA_MOVE);
	ShouldCameraCut{playerid} = false;
}

/**
 * Methods
 */

static GetActorDefinedPosition(index, &Float:x, &Float:y, &Float:z, &Float:a) {
	x = actors_positions[index][0];
	y = actors_positions[index][1];
	z = actors_positions[index][2];
	a = actors_positions[index][3];
}

static GetSelectedSkinIndex(playerid) {
	return selected_skin_index[playerid];
}

static ResetSelectedSkinIndex(playerid) {
	selected_skin_index[playerid] = 0;
}

static IncreaseSelectedSkinIndex(playerid) {
	selected_skin_index[playerid]++;

	if(selected_skin_index[playerid] >= sizeof models) {
		selected_skin_index[playerid] = 0;
	}
}

static DecreaseSelectedSkinIndex(playerid) {
	selected_skin_index[playerid]--;

	if(selected_skin_index[playerid] < 0) {
		selected_skin_index[playerid] = sizeof models - 1;
	}
}

static GetSkinModel(index) {
	if(index < 0 || index >= sizeof models){
		index = 0;
	}
	return models[index];
}

static GetSelectedCharacterIndex(playerid) {
	return max(0, selected_character_index[playerid]);
}

static ResetSelectedCharacterIndex(playerid, index = 0) {
	selected_character_index[playerid] = max(0, index);
}

static IncreaseSelectedCharacterIndex(playerid) {
	selected_character_index[playerid]++;

	if(selected_character_index[playerid] >= AmountOfActors[playerid]) {
		selected_character_index[playerid] = 0;
	}
}

static DecreaseSelectedCharacterIndex(playerid) {
	selected_character_index[playerid]--;

	if(selected_character_index[playerid] < 0) {
		selected_character_index[playerid] = max(0, AmountOfActors[playerid] - 1);
	}
}