CFLAGS=-g -O3 -Wall
CC=gcc

SCRIPTS=neo-search.pl neo-pix.exp neo-ssh.exp neo-rdp.tcl neo-vnc.tcl
PROG=neo
CONFIG=neoconfig

all: $(PROG)

config: $(CONFIG)
	install -m 0600 $(CONFIG) ~/.$(CONFIG)

install: $(PROG)
	install -s $(PROG) /usr/local/bin && \
		install $(SCRIPTS) /usr/local/bin

uninstall:
	rm -fv /usr/local/bin/neo && \
		rm -fv /usr/local/bin/neo{-help,-search}.pl && \
		rm -fv /usr/local/bin/neo{-pix,-ssh}.exp && \
		rm -fv /usr/local/bin/neo{-rdp}.tcl

LIBS= -I/usr/lib64/expect5.44.1.11 -Lexpect5.44.1.11 -ltcl -lm -lssl

neo: usage.o builtin-vnc.o builtin-rdp.o builtin-search.o builtin-ssh.o builtin-pix.o neo.o check-ip.o config.o builtin-help.o
	$(CC) $(CFLAGS) -o neo builtin-vnc.o usage.o builtin-rdp.o builtin-search.o builtin-ssh.o builtin-pix.o neo.o check-ip.o config.o builtin-help.o $(LIBS)

check-ip.c: check-ip.re
	re2c --case-insensitive check-ip.re > check-ip.c

clean:
	rm -f *.o $(PROG) check-ip.c
