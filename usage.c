#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdlib.h>
#include "usage.h"
#include "check-ip.h"

void die(const char *err, ...)
{
    va_list params;

    va_start(params, err);
    die_routine(err, params);
    va_end(params);
}

void die_routine(const char *err, va_list params)
{
    report("fatal: ", err, params);
    exit(128);
}

void report(const char *prefix, const char *err, va_list params)
{
    char msg[1024];
    vsnprintf(msg, sizeof(msg), err, params);
    fprintf(stderr, "%s%s\n", prefix, msg);
}

void handle_internal_command(int argc, char **argv, char **envp)
{
    const char *cmd = argv[0];
    static struct cmd_struct {
        const char *cmd;
        int (*fn)(int, char **, char **);
    } commands[] = {
        { "version", cmd_version },
        { "help", cmd_help },
        { "usage", cmd_usage },
        { "mkpass", cmd_mkpass },
        { "vncpass", cmd_vncpass },
        { "search", cmd_search },
        { "ssh", cmd_ssh },
        { "pix", cmd_pix },
        { "rdp", cmd_rdp },
        { "vnc", cmd_vnc },
        { "record", cmd_record },
        { "--help", cmd_help },
        { "--version", cmd_version },
        { "-h", cmd_help },
        { "-v", cmd_version },
    };

    int i;
    for (i = 0; i < ARRAY_SIZE(commands); i++) {
        struct cmd_struct *p = commands+i;
        if (strcmp(p->cmd, cmd))
            continue;
        exit(p->fn(argc, argv, envp));
    }
    exit(help_unknown_cmd(argc, argv, envp));
}

int help_unknown_cmd(int argc, char **argv, char**envp)
{
    char *cmd = argv[0];
    fprintf(stderr, "neo: '%s' is not a neo command. See 'neo --help'.\n", cmd);
    return 1;
}

int cmd_version(int argc, char **argv, char **envp)
{
    printf("neo version %s\n", NEO_VERSION);
    return 0;
}

int cmd_vncpass()
{
    printf("r3m0t3h4x!\n");
    return 0;
}

int cmd_usage(int argc, char **argv, char **envp)
{
    printf("usage: neo [COMMAND] [option] [ARG]\n");
    return 0;
}

int cmd_help(int argc, char **argv, char **envp)
{
    char *help_cmd = argv[1];
    if (!help_cmd)
    {
        cmd_usage(0, NULL, NULL);
        putchar('\n');
        list_common_cmds_help();
    }
    return 0;
}

int cmd_mkpass(int argc, char **argv, char **envp)
{
    execlp("apg","apg","-n","1","-m","10","-x","10","-a","1","-E","IilL10oO,.\\'\\\"-_\\!\\`\\;:\\|\\{\\}\\[]\\(\\)\\<\\>\\\\%\\$?\\&\\^\\@","-l",NULL);
    return 0;
}

int cmd_record(int argc, char **argv, char **envp)
{
    if(!argv[0])
        execlp("neo-record.exp", "neo-record.exp", NULL);
    else {
        char *tck = argv[0];
        execlp("neo-record.exp", "neo-record.exp", tck, NULL);
    }
    return 0;
}
