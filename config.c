#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "config.h"

FILE *config_file;
static int baselen;
static int c;
char opt[MAXNAME];
char var[MAXNAME];
char val[MAXNAME];

struct opts options;

int opt_args(char *var, char *val)
{
    if(!strcmp("ssh", var)) {
        strcpy(options.sshargs,val);
        return 0;
    }
    if(!strcmp("pix", var)) {
        strcpy(options.pixargs,val);
        return 0;
    }
    if(!strcmp("rdp", var)) {
        strcpy(options.rdpargs,val);
        return 0;
    }
    if(!strcmp("vnc", var)) {
        strcpy(options.vncargs,val);
        return 0;
    }
    return 1;
}

int handle_option(char *opt, char *var, char *val)
{
    static struct opt_struct {
        const char *opt;
        int (*fn)(char *, char *);
    } options[] = {
        { "args", opt_args },
    };

    int i;
    for (i = 0; i < ARRAY_SIZE(options); i++) {
        struct opt_struct *o = options+i;
        if (strcmp(o->opt, opt))
            continue;
        return o->fn(var, val);
    }
    printf("Unrecognized config file option: %s.%s\n", opt, var);
    return 1;
}

void parse_config_file()
{
    config_file = fopen("/home/bharris/src/neo/neoconfig", "r");
    do {
        memset(opt,0,MAXNAME);
        baselen = 0;
    
        do {
            c = get_next_char();
            if(c == EOF) {
                config_file = NULL;
                break;
            }
            } while (c != '[');
    
        if(config_file == NULL)
            continue;
    
        do {
            c = get_next_char();
            opt[baselen] = c;
            baselen++;
        } while (c != ']');
        baselen--;
        opt[baselen] = 0;

        baselen = 0;
        memset(var,0,MAXNAME);
    
        do c = get_next_char();
            while (!isalnum(c));
        do {
            var[baselen] = c;
            baselen++;
            c = get_next_char();
        } while (isalnum(c));
    
        memset(val,0,MAXNAME);
        baselen=0;
    
        do c = get_next_char();
            while (c != '=');
    
        do c = get_next_char();
            while (isspace(c));
        val[baselen] = c;
        baselen++;
    
        do {
            c = get_next_char();
            if(c == '\\') {
                c = get_next_char();
                if(c == '\n')
                    do c = get_next_char();
                        while (isspace(c));
            }
            val[baselen] = c;
            baselen++;
        } while (c != '\n');
        baselen--;
        val[baselen] = 0;
        baselen++;
    
        handle_option(opt, var, val);
    } while (config_file != NULL);
}

int get_next_char(void)
{
    int c;
    FILE *f;

    c = '\n';
    if ((f = config_file) != NULL) {
        c = fgetc(f);
        if (c == EOF)
            config_file = NULL;
    }
    return c;
}
