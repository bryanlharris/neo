#!/usr/bin/perl -w

use strict;
use Getopt::Lucid qw( :all );

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
    Param("rdp"),
    Switch("screen"),
    Switch("mkpass"),
    Switch("help|h")->anycase(),
);

my $options = Getopt::Lucid->getopt( \@specs );

my $rdp_ip          = $options->get_rdp;
my $screen          = $options->get_screen;

&rdp_login(&get_info($rdp_ip))          if $options->get_rdp;
&mkpass                                 if $options->get_mkpass;
