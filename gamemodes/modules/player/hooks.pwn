// OnPlayerEvent(playerid, event)
#define ALS_DO_PlayerEvent<%0> %0<PlayerEvent,ii>(more:playerid, end:event)

// OnCharacterDespawn(playerid, bool:update_position)
#define ALS_DO_CharacterDespawn<%0> %0<CharacterDespawn,ii>(more:playerid, end_tag:bool:update_position)

// OnCreateCharacterORM(ORM:ormid, playerid)
#define ALS_DO_CreateCharacterORM<%0> %0<CreateCharacterORM,ii>(ORM:ormid, end:playerid)