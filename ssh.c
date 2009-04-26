#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdlib.h>
#include "usage.h"

struct ssh_opt {
    unsigned screen:1;
};

int cmd_ssh(int argc, char **argv, char **envp)
{
    int no_more_arg = 0;
    char **dst, **src;
    struct ssh_opt opt;

    memset(&opt, 0, sizeof(opt));
    
    for (dst = src = &argv[1]; src < argc + argv; ) {
        char *arg = *src++;
        if (!no_more_arg) {
            if (!strcmp("--", arg)) {
                no_more_arg = 1;
                *dst++ = arg;
                continue;
            }
            if (!strcmp("--screen", arg) ||
                !strcmp("screen", arg)) {
                opt.screen = 1;
                continue;
            }
        }
        *dst++ = arg;
    }

    if (opt.screen)
        execlp("neo-ssh.pl", "neo-ssh.pl", "96", argv[1], NULL);

    execlp("neo-ssh.pl", "neo-ssh.pl", "64", argv[1], NULL);
    return 0;
}
