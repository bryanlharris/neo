CFLAGS=-g -O3 -Wall
CC=gcc

LINKS=neo-help neo-usage neo-mkpass neo-search neo-ssh neo-pix
SCRIPTS=neo.pl neo-help.pl neo-search.pl
PROG=neo

all: clean $(PROG)

install: $(PROG) $(SCRIPTS)
	install -s $(PROG) /usr/local/bin && \
		install $(SCRIPTS) /usr/local/bin && \
		( cd /usr/local/bin && ln -f -s neo neo-help && \
		ln -f -s neo neo-usage && ln -f -s neo neo-mkpass && \
		ln -f -s neo neo-search && ln -f -s neo neo-ssh && \
		ln -f -s neo neo-pix )

uninstall:
	rm -fv /usr/local/bin/neo && \
		rm -fv /usr/local/bin/{neo,neo-help,neo-search}.pl && \
		rm -fv /usr/local/bin/neo-{help,usage,mkpass,search,ssh,pix}

LIBS= -lssl

neo: usage.o search.o ssh.o neo.o
	$(CC) $(CFLAGS) -o neo usage.o search.o ssh.o neo.o $(LIBS)

usage.o: usage.h
neo.o: usage.h
search.o: usage.h
ssh.o: usage.h

neo-help:
	ln -f -s neo neo-help

neo-usage:
	ln -f -s neo neo-usage

neo-mkpass:
	ln -f -s neo neo-mkpass

neo-search:
	ln -f -s neo neo-search

neo-ssh:
	ln -f -s neo neo-ssh

neo-pix:
	ln -f -s neo neo-pix

clean:
	rm -f *.o $(PROG) && find . -type l -maxdepth 1 -exec rm -rf {} \;
