/**
 * auth/messages.pwn
 *
 * Þaidëjo slaptodþio priminimas
 *
 * Dependencies:
 *  - a_http
 *  - config
 *  - auth/auth
 */

#include <YSI\y_hooks>

hook OnPlRequestNewPassword(playerid) {
	static post[300];

	static url[100];
	static key[100];
	static email[100];

	config("api.url", url);
	config("api.key", key);
	GetPlayerEmail(playerid, email);

	strcat(url, "/request-new-password");

	format(post, sizeof post, "key=%s&email=%s", key, email);

	printf("Sending POST request to %s with data: %s", url, post);
	HTTP(0, HTTP_POST, url, post, "");
}