// OnPlayerEvent(playerid, event)
#define ALS_DO_PlayerEvent<%0> %0<PlayerEvent,ii>(more:playerid, end:event)

// OnCharacterDespawn(playerid, bool:update_position)
#define ALS_DO_CharacterDespawn<%0> %0<CharacterDespawn,ii>(more:playerid, end_tag:bool:update_position)

// OnCreateCharacterORM(ORM:ormid, playerid)
#define ALS_DO_CreateCharacterORM<%0> %0<CreateCharacterORM,ii>(ORM:ormid, end:playerid)

// OnCharacterDataLoad(playerid)
#define ALS_DO_CharacterDataLoad<%0> %0<CharacterDataLoad,i>(end:playerid)

// OnCharacterDataLoaded(playerid)
#define ALS_DO_CharacterDataLoaded<%0> %0<CharacterDataLoaded,i>(end:playerid)

// OnCharacterStateUpdate(playerid, newstate)
#define ALS_DO_CharacterStateUpdate<%0> %0<CharacterStateUpdate,ii>(more:playerid, end:newstate)