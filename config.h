#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXNAME 256
#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))

extern int get_next_char(void);
extern int opt_ssh(char *var, char *val);
extern int opt_rdp(char *var, char *val);
extern int opt_pix(char *var, char *val);
extern int opt_vnc(char *var, char *val);
extern int handle_option(char *opt, char *var, char *val);
extern void parse_config_file();

struct opts {
    unsigned tty:1;
    unsigned dco:1;
    unsigned uber:1;
    unsigned background:1;
    char user[MAXNAME];
    char pass[MAXNAME];
    char args[MAXNAME];
};
