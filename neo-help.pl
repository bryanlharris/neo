#!/usr/bin/perl -w

use strict;

my @quote = <<'        FINIS' =~ /\s*,(.*)/g;;
,usage: neo [COMMAND] [option] [ARG]
,
,Commands are
,       version                             Show the version
,       help                                Show this page
,       search [--showpasswords] [pattern]  Search pinky password files (case insensitive)
,       ssh [ipaddr]                        Login to linux
,       rdp [ipaddr]                        Login to windows
,       pix [ipaddr]                        Login to cisco
,       mkpass                              Generate random password
,
,Note
,       During an ssh session, you can type ctrl-x to put the remote session into the background.
        FINIS

print "$_\n" foreach (@quote);
