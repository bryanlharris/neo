#include <stdio.h>
#include "usage.h"

int list_common_cmds_help()
{
    char *msg[] = {
        "Commands are",
        "       version                             Show the version",
        "       help                                Show this page",
        "       search [showpasswords] [regex]      Search pinky password files",
        "       ssh [--ip=ipaddr|regex] [-- cmd]    Login to linux",
        "       rdp [ipaddr]                        Login to windows",
        "       pix [ipaddr]                        Login to cisco",
        "       mkpass                              Create random password (requires apg)",
        "",
        "Notes",
        "       During an ssh session, you can type ctrl-x to put the remote session into the background.",
        "       All searching is case insensitive.",
        "       Pass a command directly to ssh by placing it after the -- on the command line.",
        "",
        "Caveats",
        "       During an ssh session, you cannot quit from a program like pico, because that would require ctrl-x.",
        NULL
    };

    int i = 0;
    while(msg[i] != NULL)
        printf("%s\n", msg[i++]);
    return 0;
}
