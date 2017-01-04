#include <YSI\y_hooks>

/**
 * Declarations
 */
forward LoadCharacter(playerid);
forward SaveCharacter(playerid, bool:update_position = false);
forward ORM:CharacterORM(playerid, ORM:value = ORM:-1);
forward CharacterID(playerid, value = -1);
forward CharacterPosition(playerid, &Float:x = 0.0, &Float:y = 0.0, &Float:z = 0.0, &Float:a = 0.0);
forward UpdateCharacterPosition(playerid);
forward SetCharacterPosition(playerid, &Float:x = 0.0, &Float:y = 0.0, &Float:z = 0.0, &Float:a = 0.0);
forward CharacterCreatedAt(playerid, value = -1);
forward CharacterUpdatedAt(playerid, value = -1);

/**
 * Variables
 */

static ORM:character_orm[MAX_PLAYERS];

static user_id[MAX_PLAYERS];
static character_id[MAX_PLAYERS];
static name[MAX_PLAYERS][MAX_PLAYER_NAME];

static created_at[MAX_PLAYERS];
static updated_at[MAX_PLAYERS];

/**
 * Events
 */

hook OnCreateCharacterORM(ORM:ormid, playerid) {
	CharacterUserID(playerid, GetPlayerAccountID(playerid));
	GetPlayerName(playerid, name[playerid]);

	orm_addvar_int(ormid, character_id[playerid], "id");
	orm_addvar_int(ormid, user_id[playerid], "user_id");

	// Syncinam veikëjo duomenis su duomenø baze pagal veikëjo vardà
	orm_addvar_string(ormid, name[playerid], MAX_PLAYER_NAME, "name");
}

hook OnCharacterDespawn(playerid, bool:update_position) {
	SaveCharacter(playerid, .update_position = update_position);
	
	printf("OnCharacterDespawn %i: orm_destroy %i", playerid, _:CharacterORM(playerid));
	orm_destroy(CharacterORM(playerid));
}

hook OnCharacterDataLoad(playerid) {
	switch(orm_errno(CharacterORM(playerid))) 
	{
		case ERROR_OK: {
			call OnCharacterDataLoaded(playerid);
		}
		case ERROR_NO_DATA: {
			print("OnCharacterDataLoad: ERROR_NO_DATA");
		}
	}
}

/**
 * Public methods
 */

stock CreateCharacter(playerid) {
	new ORM:ormid = orm_create("characters");
	CharacterORM(playerid, ormid);
	printf("CreateCharacter: ormid %i", _:CharacterORM(playerid));

	call OnCreateCharacterORM(ormid, playerid);

	orm_setkey(CharacterORM(playerid), "id");
	orm_insert(CharacterORM(playerid), "OnCharacterCreated", "i", playerid);
}

stock LoadCharacter(playerid) {
	new ORM:ormid = orm_create("characters");
	CharacterORM(playerid, ormid);
	printf("LoadCharacter: ormid %i", _:CharacterORM(playerid));

	call OnCreateCharacterORM(ormid, playerid);

	orm_setkey(ormid, "name");
	orm_select(ormid, "OnCharacterDataLoad", "d", playerid);
}

stock SaveCharacter(playerid, bool:update_position = false) {
	if(CharacterID(playerid)) {
		if(update_position && GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) {
			UpdateCharacterPosition(playerid);
		}
		orm_update(CharacterORM(playerid));

		return true;
	}
	return false;
}

stock ORM:CharacterORM(playerid, ORM:value = ORM:-1) {
	if(value != ORM:-1) {
		character_orm[playerid] = value;
	}
	return character_orm[playerid];
}

stock CharacterID(playerid, value = -1) {
	if(value != -1) {
		character_id[playerid] = value;
	}
	return character_id[playerid];
}

stock CharacterUserID(playerid, value = -1) {
	if(value != -1) {
		user_id[playerid] = value;
	}
	return user_id[playerid];
}

stock CharacterCreatedAt(playerid, value = -1) {
	if(value != -1) {
		created_at[playerid] = value;
	}
	return created_at[playerid];
}

stock CharacterUpdatedAt(playerid, value = -1) {
	if(value != -1) {
		updated_at[playerid] = value;
	}
	return updated_at[playerid];
}