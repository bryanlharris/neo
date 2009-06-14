#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdlib.h>

#define NEO_VERSION "0.08"
#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))

extern void die(const char *err, ...);
extern void die_routine(const char *err, va_list params);
extern void report(const char *prefix, const char *err, va_list params);
extern void handle_internal_command(int argc, char **argv, char **envp);
extern int cmd_version(int argc, char **argv, char **envp);
extern int cmd_help(int argc, char **argv, char **envp);
extern int cmd_usage(int argc, char **argv, char **envp);
extern int cmd_mkpass(int argc, char **argv, char **envp);
extern int cmd_record(int argc, char **argv, char **envp);
extern int cmd_search(int argc, char **argv, char **envp);
extern int cmd_ssh(int argc, char **argv, char **envp);
extern int cmd_pix(int argc, char **argv, char **envp);
extern int cmd_rdp(int argc, char **argv, char **envp);
extern int cmd_vnc(int argc, char **argv, char **envp);
extern int cmd_vncpass();
extern int help_unknown_cmd(int argc, char **argv, char**envp);
extern int list_common_cmds_help();
