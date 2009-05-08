CFLAGS=-g -O3 -Wall
CC=gcc

SCRIPTS=neo-help.pl neo-search.pl neo-pix.exp neo-ssh.exp neo-rdp.pl
PROG=neo

all: clean $(PROG)

install: uninstall $(PROG) $(SCRIPTS)
	install -s $(PROG) /usr/local/bin && \
		install $(SCRIPTS) /usr/local/bin && \
		make clean

uninstall:
	rm -fv /usr/local/bin/neo && \
		rm -fv /usr/local/bin/neo{-help,-search,-rdp}.pl && \
		rm -fv /usr/local/bin/neo{-pix,-ssh}.exp

LIBS= -I /usr/lib64/expect5.44.1.11 -Lexpect5.44.1.11 -ltcl -lm -lssl

neo: usage.o search.o builtin-ssh.o builtin-pix.o neo.o check-ip.o config.o
	$(CC) $(CFLAGS) -o neo usage.o search.o builtin-ssh.o builtin-pix.o neo.o check-ip.o config.o $(LIBS)

check-ip.c: check-ip.re
	re2c --case-insensitive check-ip.re > check-ip.c

clean:
	rm -f *.o $(PROG) check-ip.c
