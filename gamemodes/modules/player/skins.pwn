#include <YSI\y_hooks>

/**
 * Variables
 */

static available_skins[MAX_PLAYERS][400 char]; // 0.3.7 skinø yra 312, bet kad ateityje nereikëtø keisti uþdëjau daugiau
static current_skin[MAX_PLAYERS];
static default_skin[MAX_PLAYERS];

/**
 * Events
 */

hook OnCreateCharacterORM(ORM:ormid, playerid) {
	orm_addvar_string(ormid, available_skins[playerid], 400, "available_skins");
	orm_addvar_int(ormid, current_skin[playerid], "current_skin");
	orm_addvar_int(ormid, default_skin[playerid], "default_skin");
}

/**
 * Public methods
 */

stock ToggleCharacterAvailableSkin(playerid, skin, toggle) {
	if(0 <= skin < 400) {
		available_skins[playerid]{skin} = toggle;
	}
}
stock IsCharacterSkinAvailable(playerid, skin) {
	if(0 <= skin < 400) {
		return available_skins[playerid]{skin};
	}
	return false;
}

stock CharacterCurrentSkin(playerid, skin = -1) {
	if(0 <= skin < 400) {
		if(IsCharacterSkinAvailable(playerid, skin)) {
			current_skin[playerid] = skin;
		}
	}
	return current_skin[playerid];
}

stock CharacterDefaultSkin(playerid, skin = -1) {
	if(0 <= skin < 400) {
		if(IsCharacterSkinAvailable(playerid, skin)) {
			default_skin[playerid] = skin;
		}
	}
	return default_skin[playerid];
}