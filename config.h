#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXNAME 256
#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))

extern int get_next_char(void);
extern int opt_args(char *var, char *val);
extern int handle_option(char *opt, char *var, char *val);
extern void parse_config_file();

struct opts {
    unsigned tty:1;
    unsigned dco:1;
    unsigned uber:1;
    char uberuser[MAXNAME];
    char uberpass[MAXNAME];
    char dcouser[MAXNAME];
    char dcopass[MAXNAME];
    char sshargs[MAXNAME];
    char pixargs[MAXNAME];
    char rdpargs[MAXNAME];
    char vncargs[MAXNAME];
};
