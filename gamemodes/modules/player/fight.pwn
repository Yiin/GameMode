#include <YSI\y_hooks>

/**
 * Public methods
 */
CharacterLastTimeInFight(playerid, time = -1) {
	static times[MAX_PLAYERS];

	if(time != -1) {
		times[playerid] = time;
	}
	return times[playerid];
}

/**
 * Events
 */

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart) {
	CharacterLastTimeInFight(playerid, gettime());
}

hook OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart) {
	CharacterLastTimeInFight(playerid, gettime());
}

hook OnPlayerGiveDamageActor(playerid, damaged_actorid, Float:amount, weaponid, bodypart) {
	CharacterLastTimeInFight(playerid, gettime());
}