#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdlib.h>
#include "usage.h"
#include "check-ip.h"

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

    char *ip = argv[1];
    if (check_ip(ip)) {
        printf("not a valid ip.\n");
        return 1;
    }

    execlp("neo-ssh.exp", "neo-ssh.exp", ip, NULL);

    return 0;
}
