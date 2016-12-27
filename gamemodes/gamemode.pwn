#include <a_samp>

/**
 * Iðjungiam warning 213: tag mismatch
 * dël y_inline pakeitimø, kad callback: parametras funkcijoje bûtø optional
 */
#pragma warning disable 213

/**
 * YSI (http://forum.sa-mp.com/showthread.php?t=570884)
 */
#include <YSI\y_testing> // modified
#include <YSI\y_va>
#include <YSI\y_iterate>
#include <YSI\y_inline>
#include <YSI\y_timers>
#include <YSI\y_commands>
#include <YSI\y_dialog> // modified

/**
 * Vendor
 */
#include <a_mysql> // http://forum.sa-mp.com/showthread.php?t=56564
#include <noclass> // http://forum.sa-mp.com/showthread.php?t=574072
#include <streamer> // http://forum.sa-mp.com/showthread.php?t=102865
#include <djson> // http://forum.sa-mp.com/showthread.php?t=48439
#include <attachments-fix> // http://forum.sa-mp.com/showthread.php?t=584708
#include <formatex> // http://forum.sa-mp.com/showthread.php?t=313488
#include <strlib> // http://forum.sa-mp.com/showthread.php?t=85697
#include <whirlpool> // http://forum.sa-mp.com/showthread.php?t=570945
#include <sscanf2> // http://forum.sa-mp.com/showthread.php?t=570927

/**
 * Testai
 */
#define RUN_TESTS

#include <YSI\y_testing>
#include "..\gamemodes\tests\database.pwn"

/**
 * Nustatymai
 */
#include "..\gamemodes\config.pwn"

/**
 * Duomenø bazë
 */
#include "..\gamemodes\database\hooks.pwn"
#include "..\gamemodes\database\database.pwn"

main() {
	
}