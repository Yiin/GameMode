// OnCharacterSelection(playerid)
#define ALS_DO_CharacterSelection<%0> %0<CharacterSelection,i>(end:playerid)

// OnCharCreationStart(playerid)
#define ALS_DO_CharCreationStart<%0> %0<CharCreationStart,i>(end:playerid)

// OnPlayerSelectsCharName(playerid, name[])
#define ALS_DO_PlayerSelectsCharName<%0> %0<PlayerSelectsCharName,is>(more:playerid, end_string:name[])

// OnCharacterCreated(playerid)
#define ALS_DO_CharacterCreated<%0> %0<CharacterCreated,i>(end:playerid)

// OnCharCreationError(playerid, error)
#define ALS_DO_CharCreationError<%0> %0<CharCreationError,ii>(more:playerid, end:error)

// OnCharacterDeleted(playerid, index)
#define ALS_DO_CharacterDeleted<%0> %0<CharacterDeleted,ii>(more:playerid, end:index)

// OnCharacterSpawn(playerid)
#define ALS_DO_CharacterSpawn<%0> %0<CharacterSpawn,i>(end:playerid)