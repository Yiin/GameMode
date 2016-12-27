/**
 * config.pwn
 *
 * Serverio konfiguracijos valdymas
 *
 * Dependencies:
 *  - config
 *  - a_mysql
 */

#include <YSI\y_hooks>

static MySQL:database;

hook OnGameModeInit() { 
    mysql_log();

    new 
        host[YSI_MAX_STRING], 
        database_name[YSI_MAX_STRING], 
        user[YSI_MAX_STRING], 
        password[YSI_MAX_STRING]
    ;

    config("mysql.host", host);
    config("mysql.database", database_name);
    config("mysql.user", user);
    config("mysql.password", password);

    database = mysql_connect(host, user, password, database_name);
    
    if(!mysql_errno()) {
        printf("Successfully connected to database");

        call OnDatabaseConnection(database);
    }
    else {
    	printf("Could not connect to database");
    }
}

hook OnGameModeExit() {
    mysql_close(database);
}

stock MySQL:GetDatabase() {
    return database;
}

stock mysql_count_in_table(table_name[], const where[], va_args<>) {
    static _where[500];
    va_formatex(_where, _, where, va_start<2>);

    mysql_format(database, query, sizeof query, "SELECT * FROM %s %s", table_name, _where);
    new Cache:cache = mysql_query(database, query);

    static count =: cache_num_rows();
    cache_delete(cache);

    return count;
}

stock mysql_exists_in_table(table_name[], const where[], va_args<>) {
    static _where[500];
    va_formatex(_where, _, where, va_start<2>);

    return mysql_count_in_table(table_name, _where) > 0;
}

stock Cache:mysql_query_format(const _query[], va_args<>) {
    static query[2000];
    va_formatex(query, _, _query, va_start<1>);
    return mysql_query(database, query);
}
#define mysql_query mysql_query_format