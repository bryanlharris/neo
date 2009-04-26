#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int scan(char *s, int l)
{
    char *p = s;
    char *q = 0;
#define YYCTYPE         char
#define YYCURSOR        p
#define YYLIMIT         (s+l)
#define YYMARKER        q
#define YYFILL(n)

    for(;;)
    {
/*!re2c
    ([0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-4][0-9]|[2][5][0-5]).([0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-4][0-9]|[2][5][0-5]).([0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-4][0-9]|[2][5][0-5]).([0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-4][0-9]|[2][5][0-5]) { return 0; }
    [^] { return 1; }
*/
    }
}

int check_ip(char *ip)
{
    return scan(ip, strlen(ip));
}
