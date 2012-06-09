#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdlib.h>
#include "usage.h"

int cmd_search(int argc, char **argv, char **envp)
{
    int no_more_arg = 0;
    char **dst, **src;

    for (dst = src = &argv[1]; src < argc + argv; ) {
        char *arg = *src++;
        if (!no_more_arg) {
            if (!strcmp("--", arg)) {
                no_more_arg = 1;
                *dst++ = arg;
                continue;
            }
            if (!strcmp("showpasswords", arg)) {
                arg = *src++;
                execlp("neo-search.pl", "neo-search.pl", "192", arg, NULL);
            }
        }
        *dst++ = arg;
    }

    execlp("neo-search.pl", "neo-search.pl", "128", argv[1], NULL);
    return 0;
}
