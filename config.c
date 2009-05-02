#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "config.h"

FILE *config_file;
static int baselen;
static int c;
static int comment;
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

int opt_uber(char *var, char *val)
{
    if(!strcmp("user", var)) {
        strcpy(options.uberuser,val);
        return 0;
    }
    if(!strcmp("pass", var)) {
        strcpy(options.uberpass,val);
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
        { "uber", opt_uber },
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
    c = 0;
    comment = 0;
    config_file = fopen("/home/bharris/src/neo/neoconfig", "r");
    do {
        if(comment == 1) {
            do c = get_next_char();
                while(c != '\n');
            comment = 0;
            continue;
        }
        memset(opt,0,MAXNAME);
        baselen = 0;
    
        do {
            c = get_next_char();
            if(c == EOF) {
                config_file = NULL;
                break;
            }
        } while (c != '[' && c != '#');

        newopt:
        if(config_file == NULL)
            continue;
        if(c == '#') {
            comment = 1;
            continue;
        }
    
        do {
            c = get_next_char();
            opt[baselen] = c;
            baselen++;
        } while (c != ']');
        baselen--;
        opt[baselen] = 0;

        newvar:
        if(comment == 1) {
            do c = get_next_char();
                while(c != '\n');
            comment = 0;
        }
        baselen = 0;
        memset(var,0,MAXNAME);
        do c = get_next_char();
            while (!isalnum(c) && c != '[' && c != EOF && c != '#');
        if(c == '[')
            goto newopt;
        if(c == EOF)
            break;
        if(c == '#') {
            comment = 1;
            goto newvar;
        }
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
        goto newvar;
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
