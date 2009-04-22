#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdlib.h>
#include "usage.h"

int main(int argc, char **argv, char **envp)
{
    char *cmd = argv[0] ? argv[0] : "neo-help";
    char *slash = strrchr(cmd, '/');
    const char *exec_path = NULL;

    if (slash) {
        *slash++ = 0;
        if (*cmd == '/')
            exec_path = cmd;
        cmd = slash;
    }

    if (!strncmp(cmd, "neo-", 4)) {
        cmd += 4;
        argv[0] = cmd;
        handle_internal_command(argc, argv, envp);
        die("cannot handle %s internally", cmd);
    }

    /* Set a default command */
    cmd = "help";

    return 0;
}
