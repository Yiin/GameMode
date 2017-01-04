#include <YSI\y_hooks>

/**
 * Events
 */

hook OnCharacterSpawn(playerid) {
	SetCameraBehindPlayer(playerid);
}