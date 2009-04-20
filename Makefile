CFLAGS=-g -O3 -Wall
CC=gcc

LINKS=neo-help neo-usage neo-mkpass
SCRIPTS=neo.pl neo-help.pl
PROG=neo

all: $(PROG) $(LINKS)

install: $(PROG) $(SCRIPTS)
	install $(PROG) $(SCRIPTS) /usr/local/bin && \
		( cd /usr/local/bin && ln -s neo neo-help && \
		ln -s neo neo-usage && ln -s neo neo-mkpass )

uninstall:
	rm -fv /usr/local/bin/{neo,neo-help,neo-usage,neo-mkpass,neo.pl,neo-help.pl}

LIBS= -lssl

neo: usage.o neo.o
	$(CC) $(CFLAGS) -o neo usage.o neo.o $(LIBS)

usage.o: usage.h
neo.o: usage.h

neo-help:
	ln -f -s neo neo-help

neo-usage:
	ln -f -s neo neo-usage

neo-mkpass:
	ln -f -s neo neo-mkpass

clean:
	rm -f *.o $(PROG) && find . -type l -maxdepth 1 -exec rm -rf {} \;
