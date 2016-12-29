/**
 * auth/messages.pwn
 *
 * Þaidëjo autentifikavimo þinuèiø valdymas
 *
 * Dependencies:
 *  - auth/auth
 */

#include <YSI\y_hooks>

hook OnPlayerFullyConnected(playerid) {
	ClearChat(playerid);
	M:P:I(playerid, "[name]%s[], sveikas prisijungæs prie [highlight]Story of Cities[] serverio!", GetPlayerAccountName(playerid));
	M:P:I(playerid, "Linkime gerai praleisti laikà! :)");
}

hook OnPlayerLoginFailed(playerid, fails) {
	switch(fails) {
		case 1: {
			static const message[] = "Hm, panaðu, kad suklydai ávesdamas slaptaþodá, pamëgink dar kartà!";
			AuthStatusMessage(message);

			M:P:E(playerid, message);
		}
		case 2: {
			static const message[][] = {
				"Ir vël nepataikei :(",
				"Jeigu neatsimeni savo slaptaþodþio, spausk [highlight]Pamirðau[] ir pasiûlysim atsiøsti naujà.",
				"Jeigu neatsimeni savo slaptaþodþio susisiek su administracija.",
				"Þinoma jeigu manai kad ðá kartà tikrai tas, gali bandyti dar vienà kartà."
			};
			AuthStatusMessage("%s\n%s\n%s", message[0], PlayerHasEmail(playerid) ? message[1] : message[2], message[3]);

			M:P:E(playerid, message[0]);
			M:P:I(playerid, PlayerHasEmail(playerid) ? message[1] : message[2]);
			M:P:I(playerid, message[3]);
		}
		default: {
			static const message[][200] = {
				"Well shit, panaðu, kad ir ne ðitas.",
				"Galime atsiøsti naujà slaptaþodá el. paðtu [highlight]%s[] arba susisiek su administracija.",
				"Dël naujo slaptaþodþio susisiek su administracija."
			};
			static message1[200];
			format(message1, sizeof message1, message[1], GetPlayerEmail(playerid));

			AuthStatusMessage("%s\n%s", message[0], PlayerHasEmail(playerid) ? message1 : message[2]);

			M:P:E(playerid, message[0]);

			if(PlayerHasEmail(playerid)) {
				M:P:I(playerid, message1);
			}
			else {
				M:P:I(playerid, message[2]);
			}
		}
	}
}

hook OnPlayerLogin(playerid, user_id) {
	M:P:G(playerid, "Slaptaþodis teisingas, prisijungei sëkmingai!");
}

hook OnPlEnterNewPassword(playerid) {
	M:P:G(playerid, "Puiku, tik nepamirðk savo pasirinkto slaptþodþio!");
	M:P:I(playerid, "Pamirðus slaptaþodá, já galime atsiøsti naujà á pasirinktà el. paðto adresà.");
}

hook OnPlayerRegister(playerid, user_id) {
	M:P:G(playerid, "Uþsiregistravai sëkmingai, sëkmës þaidime!");
}

hook OnPlRequestNewPassword(playerid) {
	M:P:I(playerid, "Naujo slaptaþodþio patvirtinimo laiðkas buvo iðsiøstas el. paðtu [highlight]%s[].", GetPlayerEmail(playerid));
	M:P:I(playerid, "Patvirtinus siuntimà, á tà patá el. paðto adresà bus atsiøstas naujas slaptaþodis.");
}

hook OnPlayerLeaveServer(playerid) {
	M:P:I(playerid, "Lauksim sugráþtant!");
}