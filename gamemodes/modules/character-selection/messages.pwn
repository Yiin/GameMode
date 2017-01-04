#include <YSI\y_hooks>

hook OnCharacterSelection(playerid) {
	ClearChat(playerid);
	
	M:P:X(playerid, "Pasirinkus norimà veikëjà, raðyk arba spausk");
	M:P:X(playerid, "[highlight]/zaisti[] (arba [highlight]ENTER[] arba [highlight]SPACE[]) norëdamas pradëti þaidimà,");
	M:P:X(playerid, "[highlight]/kurti[] (arba [highlight]ALT[]) norëdamas kurti naujà veikëjà,");
	M:P:X(playerid, "[highlight]/trinti[] iðtrinti pasirinktà veikëjà.");
}

hook OnPlayerSelectsCharName(playerid, name[]) {
	M:P:G(playerid, "Veikëjo vardas \"[name]%s[]\" yra laisvas! Dabar iðsirink savo veikëjo iðvaizdà.", name);
}

hook OnCharacterCreated(playerid) {
	M:P:G(playerid, "Veikëjas [name]%s[] sëkmingai sukurtas!", GetPlayerName(playerid));
}

hook OnCharacterDeleted(playerid, index) {
	M:P:G(playerid, "Veikëjas sëkmingai iðtrintas!");
}

hook OnCharCreationError(playerid, error) {
	switch(error) {
		case CHARACTER_CREATION_ERROR_CHARACTERS_LIMIT_REACHED: {
			M:P:E(playerid, "Pasiektas maksimalus veikëjø skaièius.");
		}
		case CHARACTER_CREATION_ERROR_NAME_ALREADY_EXISTS: {
			M:P:E(playerid, "Ðis veikëjo vardas jau yra uþimtas.");
		}
	}
}

hook OnCharacterSpawn(playerid) {
	ClearChat(playerid);
}