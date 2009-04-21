#!/usr/bin/perl -w

use strict;
use Getopt::Lucid qw( :all );

sub save_local_cache {
    my @passwords = `ssh pinky sudo cat a/{pix,mds,nix,win,domain-trust,netdev}-passwords`;
    open PASSWORDS, ">$ENV{HOME}/passwords";
    print PASSWORDS $_ foreach (@passwords);
    close PASSWORDS;
    chmod 0600, "$ENV{HOME}/passwords";
}

sub search {
    my ($query,$show_passwords) = @_;
    &save_local_cache unless -e "$ENV{HOME}/passwords";
    open PASSWORDS, "$ENV{HOME}/passwords";
    my @info = grep /$query/i, <PASSWORDS>;
    close PASSWORDS;

    if ($show_passwords and $query =~ /new0/i) {
        /^(new0) +(.*?)$/i and printf "%s\n", $2 foreach (@info);
        exit 0;
    }

    print "-" x 80 . "\n";
    /^(.*?) +(.*?) +(.*?) +(.*?) +(.*?) +(.*?)$/ and
        printf "%-14.14s %-28.28s %-15.15s %-12.12s %-7.7s\n",
            $1,
            $2,
            $3,
            $show_passwords ? $4 : "############",
            $6
        foreach (@info);
    print "-" x 80 . "\n";
}

sub get_info {
    my ($query) = @_;
    my @results = `neo.pl --showpasswords search $query`;
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
        spawn ssh -k -t -Y -2 -4 -a -q -x \
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

sub pix_login {
    my ($ip) = @_;

    chomp(my @lines = `neo.pl showpasswords search new0`);
    s/\015//g foreach @lines;
    my ($password,$enable) = @lines;
    my $stars = "*" x length $enable;
    my @quote = <<'        FINIS' =~ /\s*(.*)/g;;
        #!/usr/bin/expect -f

        set timeout -1
        spawn ssh -p 22 -o StrictHostKeyChecking=no pix@_IP_
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
}

sub rdp_login {
    my ($computername,$ip,$password) = @_;
    $computername = $1 if $computername =~ /.*?\.(.*?)/;

    my @isn = qw/
        10.2.38.
        /;
    my @informed = qw/
        10.2.18.
        10.2.37.
        /;

    my $user = "sqltest";
    grep { $ip =~ /$_/ } @isn and $user = "ISN-PUBLIC\\\\sqltest";
    grep { $ip =~ /$_/ } @isn and $password = `neo.pl showpasswords search isn.*dc1 | grep -v ^- | awk '{print \$4}'`;
    grep { $ip =~ /$_/ } @informed and $user = "IDC\\\\sqltest";
    grep { $ip =~ /$_/} @informed and $password = `neo.pl showpasswords search informed.*dc1\\  | grep -v ^- | awk '{print \$4}'`;
    system("echo '$password' | rdesktop -a 16 -g 1024x768 -u $user -p - $ip &");
}

my @specs = (
    Param("search"),
    Param("ssh"),
    Param("pix"),
    Param("rdp"),
    Switch("screen"),
    Switch("showpasswords"),
    Switch("mkpass"),
    Switch("help|h")->anycase(),
);

my $options = Getopt::Lucid->getopt( \@specs );

my $query           = $options->get_search;
my $ssh_ip          = $options->get_ssh;
my $pix_ip          = $options->get_pix;
my $rdp_ip          = $options->get_rdp;
my $screen          = $options->get_screen;
my $show_passwords  = $options->get_showpasswords;

&search($query,$show_passwords)         if $options->get_search;
&ssh_login(&get_info($ssh_ip),$screen)  if $options->get_ssh;
&pix_login($pix_ip)                     if $options->get_pix;
&rdp_login(&get_info($rdp_ip))          if $options->get_rdp;
&mkpass                                 if $options->get_mkpass;

