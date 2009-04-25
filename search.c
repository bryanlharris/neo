#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdlib.h>
#include "usage.h"

struct search_opt {
    unsigned showpasswords:1;
};

int cmd_search(int argc, char **argv, char **envp)
{
    int no_more_arg = 0;
    char **dst, **src;
    struct search_opt opt;

    memset(&opt, 0, sizeof(opt));
    
    for (dst = src = &argv[1]; src < argc + argv; ) {
        char *arg = *src++;
        if (!no_more_arg) {
            if (!strcmp("--", arg)) {
                no_more_arg = 1;
                *dst++ = arg;
                continue;
            }
            if (!strcmp("--showpasswords", arg) ||
                !strcmp("showpasswords", arg)) {
                opt.showpasswords = 1;
                continue;
            }
        }
        *dst++ = arg;
    }

    if (opt.showpasswords)
        execlp("search.pl", "search.pl", "192", argv[1], NULL);

    execlp("search.pl", "search.pl", "128", argv[1], NULL);
    return 0;
}
