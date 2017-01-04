#include <YSI\y_hooks>

/**
 * Definitions
 */

#define CHARACTER_STATE_NONE (0)
#define CHARACTER_STATE_SAME (1)

#if defined CHARACTER_STATE_LAST
	#undef CHARACTER_STATE_LAST
#endif
#define CHARACTER_STATE_LAST (2)

/**
 * Public methods
 */

stock CharacterState(playerid, currentState = CHARACTER_STATE_SAME) {
	static states[MAX_PLAYERS];

	if(currentState != CHARACTER_STATE_SAME) {
		states[playerid] = currentState;
		call OnCharacterStateUpdate(playerid, currentState);
	}

	return states[playerid];
}

/**
 * Events
 */

hook OnPlayerConnect(playerid) {
	CharacterState(playerid, CHARACTER_STATE_NONE);
}

hook OnCharacterSpawn(playerid) {
	CharacterState(playerid, CHARACTER_STATE_NONE);
}