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
    char *ip = malloc(16*sizeof(char));
    char **dst, **src;
    char rmt[50] = "";
    int no_more_arg = 0;

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
            strcat(rmt,arg);
            strcat(rmt, " ");
        }
        *dst++ = arg;
    }

    if (opt.ip && check_ip(ip)) {
        printf("not a valid ip.\n");
        return 1;
    }

    if (no_more_arg) {
        if (opt.ip)
            execlp("neo-ssh.exp", "neo-ssh.exp", "240", ip, rmt, NULL);
        else
            execlp("neo-ssh.exp", "neo-ssh.exp", "224", qry, rmt, NULL);
    } else {
        if (opt.ip)
            execlp("neo-ssh.exp", "neo-ssh.exp", "192", ip, NULL);
        else
            execlp("neo-ssh.exp", "neo-ssh.exp", "128", qry, NULL);
    }

    return 0;
}
