CMD:kurti(playerid, unused[]) {
	if(CharacterState(playerid) == CHARACTER_SELECTION_STATE_SELECTING_CHARACTER) {
		CreateNewCharacter(playerid);
	}
	return true;
}

CMD:trinti(playerid, unused[]) {
	if(CharacterState(playerid) == CHARACTER_SELECTION_STATE_SELECTING_CHARACTER) {
		inline ConfirmCharacterDeletion(confirmed) {
			if(confirmed) {
				if(ConfirmPlayerPassword(playerid, GetInputText())) {
					DeleteCharacter(playerid);
				}
			}
		}
		SetDialogHeader("Veikëjo trynimas");
		SetDialogBody("Norëdamas patvirtinti veikëjo iðtrynimà ávesk savo slaptaþodá.");
		ShowDialog(playerid, using inline ConfirmCharacterDeletion, DIALOG_STYLE_PASSWORD, "Patvirtinimas", "Trinti", "Atðaukti");
	}
	return true;
}

CMD:veikejai(playerid, params[]) {
	if(CharacterState(playerid) != CHARACTER_STATE_NONE) {
		return true;
	}
	if(gettime() > CharacterLastTimeInFight(playerid) + DURATION(10 seconds)) {
		DespawnCharacter(playerid, .update_position = true);
	}
	else {
		M:P:E(playerid, "Turi palaukti nekovodamas dar [number]%i[] sec.", CharacterLastTimeInFight(playerid) + DURATION(10 seconds) - gettime());
	}
	return true;
}