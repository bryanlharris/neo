#include <stdio.h>
#include "usage.h"

int list_common_cmds_help()
{
    char *msg[] = {
        "Commands are",
        "       version                             Show the version",
        "       help                                Show this page",
        "       search                              Search pinky password files",
        "       ssh                                 Login to linux",
        "       rdp                                 Login to windows",
        "       pix                                 Login to cisco",
        "       mkpass                              Create random password (requires apg)",
        "       vncpass                             Print out the current vnc password",
        "",
        "Notes",
        "       During an ssh session, you can type ctrl-x to put the remote session into the background.",
        "       All searching is case insensitive.",
        "       Run a remote ssh command by placing it after the -- on the command line.",
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
