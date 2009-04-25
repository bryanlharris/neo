#!/usr/bin/perl -w

use strict;

my $ip = $1 if $ARGV[0] =~
    /((?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))/;

chomp(my @lines = `neo-search.pl 192 new0`);
s/\015//g foreach @lines;
my ($password,$enable) = @lines;
my $stars = "*" x length $enable;
my @quote = <<'    FINIS' =~ /\s*(.*)/g;;
    #!/usr/bin/expect -f

    set timeout -1
    spawn ssh -k -t -2 -4 -a -q -x \
        -p 22 \
        -l pix \
        -o StrictHostKeyChecking=no \
        -o Compression=no \
        -o CheckHostIP=no \
        -o PasswordAuthentication=yes \
        -o PubkeyAuthentication=no \
        -o RhostsRSAAuthentication=no \
        -o RSAAuthentication=no \
        _IP_
   match_max 100000
    expect -exact "pix@_IP_'s password: "
    send -- "_PASSWORD_\r"
    expect -exact "\r
    Type help or '?' for a list of available commands.\r"
    expect -exact "> "
    send -- "en\r"
    expect -exact "en\r
    Password: "
    send -- "_ENABLE_"
    expect -exact "_STARS_"
    send -- "\r"
    expect -exact "\r"
    expect -exact "# "
    set CTRLX \030
    interact {
        -reset $CTRLX {exec kill -STOP [pid]}
    }
    FINIS

s/_IP_/$ip/g foreach (@quote);
s/_PASSWORD_/$password/g foreach (@quote);
s/_ENABLE_/$enable/g foreach (@quote);
s/_STARS_/$stars/ foreach (@quote);

open TMP, ">/tmp/neo";
print TMP "$_\n" foreach (@quote);
system("/usr/bin/expect -f /tmp/neo");
