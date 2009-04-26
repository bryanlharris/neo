CFLAGS=-g -O3 -Wall
CC=gcc

SCRIPTS=neo-help.pl neo-search.pl neo-pix.exp neo-ssh.pl neo-rdp.pl
PROG=neo

all: clean $(PROG)

install: uninstall $(PROG) $(SCRIPTS)
	install -s $(PROG) /usr/local/bin && \
		install $(SCRIPTS) /usr/local/bin && \

uninstall:
	rm -fv /usr/local/bin/neo && \
		rm -fv /usr/local/bin/neo{-help,-search,-ssh,-rdp}.pl && \
		rm -fv /usr/local/bin/neo{-pix}.exp && \

LIBS= -lssl

neo: usage.o search.o ssh.o neo.o
	$(CC) $(CFLAGS) -o neo usage.o search.o ssh.o neo.o $(LIBS)

usage.o: usage.h
neo.o: usage.h
search.o: usage.h
ssh.o: usage.h

clean:
	rm -f *.o $(PROG) && find . -type l -maxdepth 1 -exec rm -rf {} \;
