#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdlib.h>
#include "usage.h"
#include "config.h"

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

    while (argc > 1) {
        cmd = *++argv;
        argc--;

        if (strncmp(cmd, "--", 2))
            break;

        cmd += 2;

        if (!strcmp(cmd, "help"))
            break;
        if (!strcmp(cmd, "version"))
            break;

        cmd_usage(0, NULL, NULL);
    }

    parse_config_file();
    handle_internal_command(argc, argv, envp);

    return 0;
}
