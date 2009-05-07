#!/usr/bin/perl -w

use strict;

sub save_local_cache {
    my @passwords = `ssh pinky sudo cat a/{nix,win,domain-trust,netdev}-passwords`;
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
     /^([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?)$/ and
        printf "%-14.14s %-28.28s %-15.15s %-12.12s %-7.7s\n",
            $1,
            $2,
            $3,
            $show_passwords ? $4 : "############",
            $10
            foreach (@info);
    /^([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?)$/ and
        printf "%-14.14s %-28.28s %-15.15s %-12.12s %-7.7s\n",
            $1,
            $2,
            $3,
            $show_passwords ? $4 : "############",
            $6
            foreach (@info);
    /^([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?)$/ and
        printf "%-14.14s %-28.28s %-15.15s %-12.12s %-7.7s\n",
            $1,
            $2,
            $3,
            $show_passwords ? $4 : "############",
            $6
            foreach (@info);
    /^([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?)$/ and
        printf "%-14.14s %-28.28s %-15.15s %-12.12s %-7.7s\n",
            $1,
            $2,
            $3,
            $show_passwords ? $4 : "############",
            $6
            foreach (@info);
    /^([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?) +([^ ]+?)$/ and
        printf "%-14.14s %-28.28s %-15.15s %-12.12s %-7.7s\n",
            $1,
            $2,
            $3,
            $show_passwords ? $4 : "############",
            $5
            foreach (@info);
    print "-" x 80 . "\n";
}

&search($ARGV[1],1) if $ARGV[0] eq "192" and $ARGV[1];
&search($ARGV[1],0) if $ARGV[0] eq "128" and $ARGV[1];
