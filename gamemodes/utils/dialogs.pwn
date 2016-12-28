#define ShowDialog Dialog_ShowCallback

// Sets dialog header
stock SetDialogHeader(text[], va_args<>) {
	g_DialogHeader[0] = EOS;

	strcat(g_DialogHeader, "{2ecc71}");
	strcat(g_DialogHeader, text);

	va_formatex(g_DialogHeader, _, g_DialogHeader, va_start<1>);
	convert_colors(g_DialogHeader, "{2ecc71}");

	strcat(g_DialogHeader, "\n \n");

	// reset dialog body
	g_DialogBody[0] = EOS;
}

// Sets dialog body
stock SetDialogBody(text[], va_args<>) {
	g_DialogBody[0] = EOS;

	strcat(g_DialogBody, "[]");
	strcat(g_DialogBody, text);

	va_formatex(g_DialogBody, _, g_DialogBody, va_start<1>);
	convert_colors(g_DialogBody, "{ecf0f1}");

	AddDialogEmptyLine();
}

// Appends styled option line to dialog body
stock AddDialogOption(text[], va_args<>) {
	new sz_OptionText[100];

	strcat(sz_OptionText, "\n{2ecc71}» []");
	strcat(sz_OptionText, text);

	va_formatex(sz_OptionText, _, sz_OptionText, va_start<1>);
	convert_colors(sz_OptionText, "{ecf0f1}");

	strcat(g_DialogBody, sz_OptionText);
}

stock AddDialogEmptyLine() {
	strcat(g_DialogBody, "\n ");
}