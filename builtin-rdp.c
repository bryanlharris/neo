#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdlib.h>
#include "usage.h"
#include "check-ip.h"
#include "config.h"

struct rdp_opt {
    unsigned ip:1;
};

int cmd_rdp(int argc, char **argv, char **envp)
{
    struct rdp_opt opt;
    char *qry = argv[1];
    char *ip = malloc(16*sizeof(char));
    char **dst, **src;
    char args[50] = "";
    int no_more_arg = 0;

    printf("not allowed to use this\n");
    return 1;

    memset(ip, 0, 16*sizeof(char));
    memset(&opt, 0, sizeof(opt));
    for (dst = src = &argv[1]; src < argc + argv; ) {
        char *arg = *src++;
        if (!no_more_arg) {
            if (!strcmp("--", arg)) {
                no_more_arg = 1;
                *dst++ = arg;
                continue;
            }
            if (!strcmp("--ip", arg)) {
                opt.ip = 1;
                arg = *src++;
                strcpy(ip, arg);
                continue;
            }
        } else {
            strcat(args,arg);
            strcat(args, " ");
        }
        *dst++ = arg;
    }

    if (opt.ip && check_ip(ip)) {
        printf("not a valid ip.\n");
        return 1;
    }
    if (!opt.ip && !check_ip(qry)) {
        printf("specified an ip withouth the --ip flag, aborting\n");
        return 1;
    }

    execlp("neo-rdp.tcl",
           "neo-rdp.tcl",
           opt.ip ? "128" : "64",
           opt.ip ? ip : qry,
           args,
           NULL
          );

    return 0;
}
