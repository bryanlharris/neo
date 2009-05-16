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
    char *ip = argv[1];
    if (check_ip(ip)) {
        printf("not a valid ip.\n");
        return 1;
    }

    execlp("neo-ssh.exp", "neo-ssh.exp", ip, NULL);

    return 0;
}
