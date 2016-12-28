#include <YSI\y_hooks>

/**
 * Variables
 */

static s_PlayerAccountName[MAX_PLAYERS][MAX_PLAYER_NAME];
static s_PlayerEmail[MAX_PLAYERS][200];
static s_StatusMessage[500];

/**
 * Public methods
 */

stock GetPlayerAccountName(playerid, name[] = "", len = sizeof name) {
	format(name, len, s_PlayerAccountName[playerid]);

	return s_PlayerAccountName[playerid];
}

stock PlayerHasEmail(playerid) {
	return !isnull(s_PlayerEmail[playerid]);
}

stock GetPlayerEmail(playerid, email[] = "", len = sizeof email) {
	format(email, len, s_PlayerEmail[playerid]);

	return s_PlayerEmail[playerid];
}

stock AuthStatusMessage(const text[], va_args<>) {
	va_formatex(s_StatusMessage, _, text, va_start<1>);
}

/**
 * Events
 */

hook OnPlayerConnect(playerid) {
	// iðsisaugom þaidëjo acc name
	GetPlayerName(playerid, s_PlayerAccountName[playerid], MAX_PLAYER_NAME);

	SetPVarInt(playerid, "cache", _:mysql_query("SELECT uid, email, password FROM users WHERE username = '%s'", s_PlayerAccountName[playerid]));
}

hook OnPlayerFullyConnected(playerid) {
	new Cache:cache = Cache:GetPVarInt(playerid, "cache");
	DeletePVar(playerid, "cache");

	cache_set_active(cache);

	if(cache_num_rows()) {
		// iðsisaugom þaidëjo el. paðtà
		cache_get_value_name(0, "email", s_PlayerEmail[playerid]);

		login(playerid, cache);
	}
	else {
		cache_delete(cache);
		register(playerid);
	}
}

hook OnPlayerDisconnect(playerid, reason) {
	if(GetPVarType(playerid, "cache")) {
		cache_delete(Cache:GetPVarInt(playerid, "cache"));
	}
}

/**
 * Methods
 */

static login(playerid, Cache:cache, fails = 0) {
	AuthStatusMessage("Norëdamas prisijungti ávesk savo slaptaþodá.");

	if(fails) {
		call OnPlayerLoginFailed(playerid, fails);

		if(fails == 3) {
			cache_delete(cache);

			call OnPlayerLeaveServer(playerid);
			defer Kick(playerid);
			return;
		}
	}
	inline OnPlayerEnterPassword(response) {
		if(response) {
			static hashed_input_password[129];
			WP_Hash(hashed_input_password, sizeof hashed_input_password, GetInputText());

			static hashed_real_password[129];
			cache_get_value_name(0, "password", hashed_real_password);

			if( ! strcmp(hashed_input_password, hashed_real_password)) {
				new user_id = cache_get_value_name_int(0, "uid");
				cache_delete(cache);

				call OnPlayerLogin(playerid, user_id);
			}
			else {
				login(playerid, cache, fails + 1);
			}
		}
		else {
			// Jeigu þaidëjas buvo blogai ávedæs slaptaþodá, siunèiam slaptaþodþio priminimo laiðkà
			if(fails && PlayerHasEmail(playerid)) {
				inline OnPlayerRequestNewPassword(send) {
					if(send) {
						call OnPlRequestNewPassword(playerid);
					}
					call OnPlayerLeaveServer(playerid);
					defer Kick(playerid);
				}
				SetDialogHeader("Naujo slaptaþodþio praðymas");
				SetDialogBody("\
					Naujo slaptaþodþio patvirtinimo laiðkas bus iðsiøstas el. paðtu [highlight]%s[].\n\
					\n\
					Patvirtinus naujo slaptaþodþio siuntimà, tavo slaptaþodis bus automatiðkai sugeneruotas á kità, \n\
					ir atsiøstas á tà patá el. paðto adresà.\
				", GetPlayerEmail(playerid));

				ShowDialog(playerid, using inline OnPlayerRequestNewPassword, DIALOG_STYLE_MSGBOX, 
					"Naujo slaptaþodþio praðymas",
					"Siøsti", "Iðeiti");
			}
			else { // Kitu atveju paklausiam ar jis tikrai nori palikti serverá
				inline ExitWarningResponse(stay) {
					if(stay) {
						login(playerid, cache, fails);
					}
					else {
						cache_delete(cache);

						call OnPlayerLeaveServer(playerid);
						defer Kick(playerid);
					}
				}
				SetDialogHeader("Ar tikrai nori palikti serverá?");
				SetDialogBody("\
					Norint þaisti serveryje, privaloma prisijungti, \n\
					taèiau jeigu nori palikti serverá - paspausk mygtukà \"Iðeiti\"\
				");

				ShowDialog(playerid, using inline ExitWarningResponse, DIALOG_STYLE_MSGBOX, 
					"Iðëjimas ið serverio",
					"Prisijungti", "Iðeiti");
			}
		}
	}
	SetDialogHeader("Prisijungimas prie serverio");
	SetDialogBody(s_StatusMessage);

	ShowDialog(playerid, using inline OnPlayerEnterPassword, DIALOG_STYLE_PASSWORD, "Prisijungimas", "Prisijungti", (fails && PlayerHasEmail(playerid)) ? ("Pamirðau") : ("Iðeiti"));
}

static register(playerid) {
	static serial[128];
	gpci(playerid, serial, sizeof serial);

	inline OnPlayerEnterNewPassword(response) {
		if(response) {
			call OnPlEnterNewPassword(playerid);

			static password[129];
			WP_Hash(password, sizeof password, GetInputText());

			inline OnPlayerEnterEmail(accepted) {
				new email[200];

				if(accepted) {
					format(email, sizeof email, GetInputText());
				}

				new Cache:cache = mysql_query("\
					INSERT INTO                \
						users (                \
							username,          \
							password,          \
							email,             \
							last_gpci,         \
							last_ip            \
						)                      \
					VALUES (                   \
						'%s',                  \
						'%s',                  \
						'%s',                  \
						'%s',                  \
						%i                     \
					)                          \
				", GetPlayerAccountName(playerid), password, email, serial, compressPlayerIP(playerid));
				
				new user_id = cache_insert_id();
				cache_delete(cache);

				call OnPlayerRegister(playerid, user_id);
			}
			SetDialogHeader("Naujo þaidëjo registracija");
			SetDialogBody("\
				Norint ateityje susigràþinti pamirðtà slaptaþodá, praðome ávesti savo el. paðto adresà.\n\
				Jis nëra privalomas, taèiau gali labai praversti. \n\
				\n\
				Patvirtinus el. paðtà, [highlight]nemokamai gausi 300€[]\n\
				ir [highlight]galimybæ 24 valandas nemokamai naudotis dviraèiø nuomos paslauga[].");
			ShowDialog(playerid, using inline OnPlayerEnterEmail, DIALOG_STYLE_INPUT, "Registracija", "Iðsaugoti", "Iðeiti");
		}
		else {
			inline ExitWarningResponse(stay) {
				if(stay) {
					register(playerid);
				}
				else {
					call OnPlayerLeaveServer(playerid);
					defer Kick(playerid);
				}
			}
			SetDialogHeader("Ar tikrai nori palikti serverá?");
			SetDialogBody("\
				Norint þaisti serveryje, privaloma prisijungti, \n\
				taèiau jeigu nori palikti serverá - paspausk mygtukà \"Iðeiti\"\
			");

			ShowDialog(playerid, using inline ExitWarningResponse, DIALOG_STYLE_MSGBOX, 
				"Iðëjimas ið serverio",
				"Registruotis", "Iðeiti");
		}
	}
	SetDialogHeader("Naujo þaidëjo registracija");
	SetDialogBody("Norëdamas uþsiregistruoti, ávesk savo norimà slaptaþodá.");
	ShowDialog(playerid, using inline OnPlayerEnterNewPassword, DIALOG_STYLE_PASSWORD, "Registracija", "Patvirtinti", "Iðeiti");
}

static compressPlayerIP(playerid) {
	static ip_address[16];
	GetPlayerIp(playerid, ip_address, 16);

	static ip[4];
	sscanf(ip_address, "p<.>a<i>[4]", ip);

	return (ip[0] * 16777216) + (ip[1] * 65536) + (ip[2] * 256) + (ip[3]);
}