#define M: msg
#define msgP: msgp
#define msgpE: msgpE
#define msgpI: msgpI
#define msgpX: msgpX
#define msgpD: msgpD
#define msgG: msgg
#define msgpT: msgpT

ClearChat(playerid, everything = true) {
	for(new i, j = everything ? 50 : 16; i < j; i++) {
		SendClientMessage(playerid, -1, " ");
	}
}

convert_colors(text[], backgroundColor[], size = sizeof text) {
	enum color_e_INFO {
		name[16],
		color[9]
	};
	static const colors[][color_e_INFO] = {
		{"[name]",          "{f39c12}"},
		{"[number]",        "{f1c40f}"},
		{"[highlight]",     "{1abc9c}"}
	};

	strreplace(text, "[]", backgroundColor, .maxlength = size);
	for(new i; i < sizeof colors; ++i) {
		strreplace(text, colors[i][name], colors[i][color], .maxlength = size);
	}
}

new do_newline = true, Timer:do_newline_timer_id = Timer:-1;

timer do_newline_timer[0]() {
	do_newline = true;
	do_newline_timer_id = Timer:-1;
}

stock M:G:I(const text[], va_args<>) {
	static buffer[250];
	va_formatex(buffer, _, text, va_start<1>);

	format(buffer, _, "{bdc3c7}» []%s", buffer);
	convert_colors(buffer, "{ecf0f1}");

	SendClientMessageToAll(-1, buffer);

	return true;
}

stock M:P:E(pid, const text[], va_args<>)
{
	static buffer[250];
	va_formatex(buffer, _, text, va_start<2>);

	format(buffer, sizeof buffer, "{c0392b}» []%s", buffer);
	convert_colors(buffer, "{ecf0f1}");

	if(do_newline) {
		do_newline = false;
		if(do_newline_timer_id == Timer:-1) {
			do_newline_timer_id = defer do_newline_timer();
		}

		SendClientMessage(pid, -1, " ");
	}
	SendClientMessage(pid, -1, buffer);

	return true;
}

stock M:P:I(pid, const text[], va_args<>)
{
	static buffer[250];
	va_formatex(buffer, _, text, va_start<2>);

	format(buffer, _, "{bdc3c7}» []%s", buffer);
	convert_colors(buffer, "{ecf0f1}");

	if(do_newline) {
		do_newline = false;
		if(do_newline_timer_id == Timer:-1) {
			do_newline_timer_id = defer do_newline_timer();
		}

		SendClientMessage(pid, -1, " ");
	}
	SendClientMessage(pid, -1, buffer);
	return true;
}

stock M:P:G(pid, const text[], va_args<>)
{
	static buffer[250];
	va_formatex(buffer, _, text, va_start<2>);

	format(buffer, sizeof buffer, "{27ae60}» []%s", buffer);
	convert_colors(buffer, "{2ecc71}");

	if(do_newline) {
		do_newline = false;
		if(do_newline_timer_id == Timer:-1) {
			do_newline_timer_id = defer do_newline_timer();
		}

		SendClientMessage(pid, -1, " ");
	}
	SendClientMessage(pid, -1, buffer);
	return true;
}

stock M:P:X(pid, const text[], va_args<>)
{
	static buffer[250];
	va_formatex(buffer, _, text, va_start<2>);


	format(buffer, sizeof buffer, "{2c3e50}••• []%s", buffer);
	convert_colors(buffer, "{ecf0f1}");

	if(do_newline) {
		do_newline = false;
		if(do_newline_timer_id == Timer:-1) {
			do_newline_timer_id = defer do_newline_timer();
		}

		SendClientMessage(pid, -1, " ");
	}
	SendClientMessage(pid, -1, buffer);
	return true;
}

stock M:P:D(pid, const text[], va_args<>)
{
	#if defined _DEBUG && _DEBUG != 0
		static buffer[250];
		va_formatex(buffer, _, text, va_start<2>);

		format(buffer, sizeof buffer, "{c0392b}DEBUG • []%s", buffer);
		convert_colors(buffer, "{ecf0f1}");

		if(do_newline) {
			do_newline = false;
			if(do_newline_timer_id == Timer:-1) {
				do_newline_timer_id = defer do_newline_timer();
			}

			SendClientMessage(pid, -1, " ");
		}
		SendClientMessage(pid, -1, buffer);
	#else
		#pragma unused text, pid
	#endif
	return true;
}