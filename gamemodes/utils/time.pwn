/*
 * Compile-time duration.
 *
 * Example:
 *   DURATION(1 hour, 20 minutes) -> 4800
 */
#define DURATION_MS(%1)     (DURATION(%1) * 1000)
#define DURATION(%1)        (DURATION_PT:%1,0)
#define DURATION_PT:%1,     (%1:DURATION)+_:DURATION_PT:

#define second%1:DURATION
#define seconds%1:DURATION
#define minute%1:DURATION   * DURATION_MINUTE
#define minutes%1:DURATION  * DURATION_MINUTE
#define hour%1:DURATION     * DURATION_HOUR
#define hours%1:DURATION    * DURATION_HOUR
#define day%1:DURATION      * DURATION_DAY
#define days%1:DURATION     * DURATION_DAY
#define week%1:DURATION     * DURATION_WEEK
#define weeks%1:DURATION    * DURATION_WEEK
#define month%1:DURATION    * DURATION_MONTH
#define months%1:DURATION   * DURATION_MONTH
#define year%1:DURATION     * DURATION_YEAR
#define years%1:DURATION    * DURATION_YEAR

stock SecondsToTime(secs, &days = 0, &hours = 0, &minutes = 0, &seconds = 0) {
    if (secs<0)
        return;

    minutes = secs / 60;
    hours = minutes / 60;
    days = hours / 24;

    seconds = secs % 60;
    minutes = minutes % 60;
    hours = hours % 24;
}