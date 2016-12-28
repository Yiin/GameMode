// OnPlayerLoginFailed(playerid, fails)
#define ALS_DO_PlayerLoginFailed<%0> %0<PlayerLoginFailed,ii>(more:playerid, end:fails)

// OnPlayerLogin(playerid, user_id)
#if defined ALS_DO_PlayerLogin
	#undef ALS_DO_PlayerLogin // YSI pas save naudoja OnPlayerLogin
#endif
#define ALS_DO_PlayerLogin<%0> %0<PlayerLogin,ii>(more:playerid, end:user_id)

// OnPlEnterNewPassword(playerid)
#define ALS_DO_PlEnterNewPassword<%0> %0<PlEnterNewPassword,i>(end:playerid)

// OnPlayerRegister(playerid, user_id)
#define ALS_DO_PlayerRegister<%0> %0<PlayerRegister,ii>(more:playerid, end:user_id)

// OnPlRequestNewPassword(playerid)
#define ALS_DO_PlRequestNewPassword<%0> %0<PlRequestNewPassword,ii>(end:playerid)

// OnPlayerLeaveServer(playerid)
#define ALS_DO_PlayerLeaveServer<%0> %0<PlayerLeaveServer,i>(end:playerid)