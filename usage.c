#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdlib.h>
#include "usage.h"

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
        { "search", cmd_search },
        { "ssh", cmd_ssh },
        { "pix", cmd_pix },
        { "rdp", cmd_rdp },
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
    exit(cmd_usage(argc, argv, envp));
}

int cmd_pix(int argc, char **argv, char **envp)
{
    execlp("neo-pix.exp", "neo-pix.exp", argv[0], NULL);
    return 0;
}

int cmd_rdp(int argc, char **argv, char **envp)
{
    execlp("neo.pl", "neo.pl", argv[0], argv[1], NULL);
    return 0;
}

int cmd_version(int argc, char **argv, char **envp)
{
    printf("neo version %s\n", NEO_VERSION);
    return 0;
}

int cmd_usage(int argc, char **argv, char **envp)
{
    printf("usage: neo [version|help] [modifiers] [options] [regex|ipaddr]\n");
    return 0;
}

int cmd_help(int argc, char **argv, char **envp)
{
    char *help_cmd = argv[1];
    if (!help_cmd)
        cmd_usage(argc, argv, envp);
    execlp("neo-help.pl","neo-help.pl",NULL);
    return 0;
}

int cmd_mkpass(int argc, char **argv, char **envp)
{
    execlp("apg","apg","-n","1","-m","10","-x","10","-a","1","-E","IilL10oO,.\\'\\\"-_\\!\\`\\;:\\|\\{\\}\\[]\\(\\)\\<\\>\\\\%\\$?\\&\\^\\@","-l",NULL);
    return 0;
}
