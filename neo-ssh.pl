#!/usr/bin/perl -w

use strict;

sub get_info {
    my ($query) = @_;
    my @results = `neo-search.pl 192 $query`;
    my $line;
    /\b$query\b/ and $line = $_ and last foreach (@results);
    my ($computername,$ip,$password) = (split / +/, $line)[1,2,3];
    $ip = $1 if $ip =~
        /((?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))/;
    return ($computername,$ip,$password);
}

sub ssh_login {
    my ($computername,$ip,$password,$screen) = @_;

    my @boulevards = qw/
        66.111.96.222
        66.111.96.224
        66.111.96.225
        66.111.96.223
        66.111.96.221
        66.111.96.226
        66.111.96.227
        66.111.96.228
        66.111.96.229
        /;

    my @quote = <<'        FINIS' =~ /\s*(.*)/g;
        #!/usr/bin/expect -f
        set timeout -1
        spawn ssh -k -t -2 -4 -a -q -x \
            -l root \
            -o StrictHostKeyChecking=no \
            -o Compression=no \
            -o CheckHostIP=no \
            -o PasswordAuthentication=yes \
            -o PubkeyAuthentication=no \
            -o RhostsRSAAuthentication=no \
            -o RSAAuthentication=no \
            -p _PORT_ _IP_ _SCREEN_
        match_max 100000
        expect -re "assword"
        send -- "_PASSWORD_\r"
        expect -re "(#.* )|(Press Space or Return to end)"
        send -- "exec bash\r"
        expect -re "# "
        send -- "export PS1='\\n\[\$USER\@\$(echo \$HOSTNAME | cut -d. -f1):\$PWD\]\\n# '\r"
        expect -re "# "
        set CTRLX \030
        interact {
            -reset $CTRLX {exec kill -STOP [pid]}
        }
        exit
        FINIS

    $screen == 1 and s/_SCREEN_/ screen/g foreach (@quote);
    $screen != 1 and s/_SCREEN_//g foreach (@quote);
    grep { $ip =~ /$_/ } @boulevards and s/_PORT_/1022/g foreach (@quote);
    grep { $ip =~ /$_/ } @boulevards or s/_PORT_/22/g foreach (@quote);
    s/_IP_/$ip/g foreach (@quote);
    $password =~ s/\$/\\\$/g;
    s/_PASSWORD_/$password/g foreach (@quote);

    open TMP, ">/tmp/neo";
    print TMP "$_\n" foreach (@quote);
    system("/usr/bin/expect -f /tmp/neo");
}

&ssh_login(&get_info($ARGV[1]),1) if $ARGV[0] eq "96" and $ARGV[1];
&ssh_login(&get_info($ARGV[1]),0) if $ARGV[0] eq "64" and $ARGV[1];
