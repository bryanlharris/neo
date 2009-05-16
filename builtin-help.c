#include <stdio.h>
#include "usage.h"

int list_common_cmds_help()
{
    char *msg[] = {
        "Commands are",
        "       version                             Show the version",
        "       help                                Show this page",
        "       search [showpasswords] [regex]      Search pinky password files",
        "       ssh [ipaddr|regex]                  Login to linux",
        "       rdp [ipaddr]                        Login to windows",
        "       pix [ipaddr]                        Login to cisco",
        "       mkpass                              Generate random password",
        "",
        "Notes",
        "       During an ssh session, you can type ctrl-x to put the remote session into the background.",
        "       All searching is case insensitive.",
        NULL
    };

    int i = 0;
    while(msg[i] != NULL)
        printf("%s\n", msg[i++]);
    return 0;
}
