/**
 * config.pwn
 *
 * Serverio konfiguracijos valdymas
 *
 * Dependencies:
 *  - djson
 */

#include <YSI_Coding\y_hooks>

static configFileName[] = "config.json";

hook OnGameModeInit() {
    DJSON_cache_ReloadFile(configFileName);
}

config(key[], value[] = "", keyLength = sizeof key, valueLength = sizeof value, module[] = "") {
	// syntax-sugar, kad bûtø galima raðyti pvz "mysql.password" vietoj "mysql/password"
	strreplace(key, ".", "/", .maxlength = keyLength);

	if(!isnull(module)) {
	    DJSON_cache_ReloadFile(module);
	}

	format(value, valueLength, "%s", dj(isnull(module) ? configFileName : module, key));
	
	return djInt(isnull(module) ? configFileName : module, key);
}