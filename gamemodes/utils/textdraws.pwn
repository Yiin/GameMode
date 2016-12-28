

stock FilterLetters(_text[], uppercase = false) {
	new text[100];

	strcat(text, _text);

	static lt_arr[][2] = {
		"À","È","Æ","Ë","Á","Ð","Ø","Û","Þ",
		"à","è","æ","ë","á","ð","ø","û","þ"
	};
	static en_arr[][2] = { // 2 because fuck you
		"A","C","E","E","I","S","U","U","Z",
		"a","c","e","e","i","s","u","u","z"
	};
	for(new i; i < sizeof lt_arr; ++i) {
		strreplace(text, lt_arr[i], en_arr[i]);
	}

	if(uppercase) {
		new i;
		while(text[i]) {
			text[i] = toupper(text[i]);
			++i;
		}
	}

	return text;
}