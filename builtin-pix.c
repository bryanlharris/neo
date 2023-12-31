#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdlib.h>
#include "usage.h"
#include "check-ip.h"
#include "config.h"

int cmd_pix(int argc, char **argv, char **envp)
{
    extern struct opts options;
    char *ip = argv[1];
    if (check_ip(ip)) {
        printf("not a valid ip\n");
        return 1;
    }

    execlp("neo-pix.exp", "neo-pix.exp", ip, options.dcouser, options.dcopass, NULL);
    return 0;
}
