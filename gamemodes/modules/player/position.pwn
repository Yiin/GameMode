#include <YSI\y_hooks>

/**
 * Variables
 */

static Float:position_x[MAX_PLAYERS];
static Float:position_y[MAX_PLAYERS];
static Float:position_z[MAX_PLAYERS];
static Float:position_a[MAX_PLAYERS];

/**
 * Events
 */

hook OnCreateCharacterORM(ORM:ormid, playerid) {
	orm_addvar_float(ormid, position_x[playerid], "x");
	orm_addvar_float(ormid, position_y[playerid], "y");
	orm_addvar_float(ormid, position_z[playerid], "z");
	orm_addvar_float(ormid, position_a[playerid], "a");
}

hook OnCharacterSpawn(playerid) {
	SetPlayerVirtualWorld(playerid, VW_DEFAULT);

	SetPlayerPos(playerid, position_x[playerid], position_y[playerid], position_z[playerid]);
	SetPlayerFacingAngle(playerid, position_a[playerid]);
}

/**
 * Public methods
 */

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