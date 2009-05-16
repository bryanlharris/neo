#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdlib.h>
#include "usage.h"
#include "check-ip.h"

struct ssh_opt {
    unsigned ip:1;
};

int cmd_ssh(int argc, char **argv, char **envp)
{
    struct ssh_opt opt;
    char *qry = argv[1];
    char *ip = argv[1];
    char **dst, **src;
    int no_more_arg = 0;

    memset(&opt, 0, sizeof(opt));
    for (dst = src = &argv[1]; src < argc + argv; ) {
        char *arg = *src++;
        if (!no_more_arg) {
            if (!strcmp("--", arg)) {
                no_more_arg = 1;
                *dst++ = arg;
                continue;
            }
            if (!strcmp("--ip", arg) ||
                !strcmp("ip", arg)) {
                opt.ip = 1;
                if (src < argc + argv) {
                    arg = *src++;
                    ip = arg;
                }
                else
                {
                    printf("not a valid ip.\n");
                    return 1;
                }
                continue;
            }
        }
        *dst++ = arg;
    }

    if (opt.ip && check_ip(ip)) {
        printf("not a valid ip.\n");
        return 1;
    }

    if (opt.ip)
        execlp("neo-ssh.exp", "neo-ssh.exp", "192", ip, NULL);

    execlp("neo-ssh.exp", "neo-ssh.exp", "128", qry, NULL);

    return 0;
}
