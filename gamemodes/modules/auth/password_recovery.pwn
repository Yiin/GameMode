#include <YSI\y_hooks>

hook OnPlRequestNewPassword(playerid) {
	static post[300];

	static url[100];
	static key[100];
	static email[100];

	config("api.base_url", url);
	config("api.key", key);
	GetPlayerEmail(playerid, email);

	strcat(url, "/request-new-password");

	format(post, sizeof post, "key=%s&email=%s", key, email);

	HTTP(0, HTTP_POST, url, post, "");
}