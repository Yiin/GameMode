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

static character_id[MAX_PLAYERS];
static name[MAX_PLAYERS][MAX_PLAYER_NAME];
static Float:position_x[MAX_PLAYERS];
static Float:position_y[MAX_PLAYERS];
static Float:position_z[MAX_PLAYERS];
static Float:position_a[MAX_PLAYERS];

static created_at[MAX_PLAYERS];
static updated_at[MAX_PLAYERS];

/**
 * Events
 */

hook OnCreateCharacterORM(ORM:ormid, playerid) {
	orm_addvar_int(ormid, character_id[playerid], "id");
	orm_addvar_float(ormid, position_x[playerid], "x");
	orm_addvar_float(ormid, position_y[playerid], "y");
	orm_addvar_float(ormid, position_z[playerid], "z");
	orm_addvar_float(ormid, position_a[playerid], "a");
	orm_addvar_int(ormid, created_at[playerid], "created_at");
	orm_addvar_int(ormid, updated_at[playerid], "updated_at");
}

hook OnCharacterDespawn(playerid, bool:update_position) {
	SaveCharacter(playerid, .update_position = update_position);
	
	orm_destroy(CharacterORM(playerid));
}

/**
 * Public methods
 */

stock LoadCharacter(playerid) {
	GetPlayerName(playerid, name[playerid]);

	new ORM:ormid = CharacterORM(playerid, orm_create("characters"));

	// Syncinam veikëjo duomenis su duomenø baze pagal veikëjo vardà
	orm_addvar_string(ormid, name[playerid], MAX_PLAYER_NAME, "name");
	orm_setkey(ormid, "name");

	call OnCreateCharacterORM(ormid, playerid);

	orm_select(ormid, "OnPlayerDataLoad", "d", playerid);
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

stock CharacterPosition(playerid, &Float:x = 0.0, &Float:y = 0.0, &Float:z = 0.0, &Float:a = 0.0) {
	if(x && y && z) {
		position_x[playerid] = x;
		position_y[playerid] = y;
		position_z[playerid] = z;
	}
	if(a) {
		position_a[playerid] = a;
	}
	x = position_x[playerid];
	y = position_y[playerid];
	z = position_z[playerid];
	a = position_a[playerid];
}

stock UpdateCharacterPosition(playerid) {
	static Float:x, Float:y, Float:z, Float:a;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	CharacterPosition(playerid, x, y, z, a);
}

stock SetCharacterPosition(playerid, &Float:x = 0.0, &Float:y = 0.0, &Float:z = 0.0, &Float:a = 0.0) {
	CharacterPosition(playerid, x, y, z, a);

	Streamer_UpdateEx(playerid, x, y, z);

	SetPlayerPos(playerid, x, y, z);
	SetPlayerFacingAngle(playerid, a);
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