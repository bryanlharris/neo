#!/usr/bin/perl -w

use strict;

my @quote = <<'        FINIS' =~ /\s*,(.*)/g;;
,NAME
,       neo - NeoSpire utility to search the pinky file and login to computers
,
,SYNOPSIS
,       neo [ modifiers ] [ options ] [ regular expression ]
,       neo [ modifiers ] [ options ] [ IP address ]
,
,DESCRIPTION
,
,       To use this, you will have to install the necessary modules.
,       E.g. perl -MCPAN -eshell and then ``install Getopt::Lucid'' at the prompt.
,
,OPTIONS
,
,       help, -h, --help
,           Print the help message
,
,       mkpass, --mkpass
,           Create a random password.  Requires the ``apg'' package.
,
,       search [QUERY], --search=[QUERY]
,           Search the passwords file on pinky for [QUERY], which is a regular
,           expression.  All searches are case insensitive.
,           Files searched: {mds,nix,win,domain-trust,netdev}-passwords
,
,       [ssh|rdp|pix] [IP], --login=[IP]
,           Login to a device at [IP].  To prevent multiple matches, a space
,           character is appended to the [IP] string.
,
,MODIFIERS
,
,       screen, --screen
,           Valid for ssh login.  Run screen inside remote ssh session.
,
,       showpasswords, --showpasswords
,           Valid for searches.  Show passwords for search results.  If you don't
,           this, you will only see pound signs in the password field.
,
,EXAMPLES
,
,       To search for the ns1 server and subsequently login to it.
,
,           $ neo search ns1
,           NeoSpire cns1.neospire.net 66.111.111.3 ###### xx root
,           NeoSpire ns1.neospire.net 66.111.111.5 ###### xx root
,           NeoSpire rns1-1.neospire.net 64.74.122.162 ###### xx root
,           NeoSpire rns1-2.neospire.net 64.74.122.163 ###### xx root
,           $ neo ssh 66.111.111.5
,           spawn ssh -p 22 -Y -l root -o StrictHostKeyChecking=no 66.111.111.5
,           Password: 
,           Last login: Thu Apr  9 06:29:55 2009 from xob.neospire.net
,           Linux ns1.neospire.net 2.6.10-fai-p3 #1 SMP Thu Jan 20 10:24:53 CST 2005 i686 GNU/Linux
,
,           The programs included with the Debian GNU/Linux system are free software;
,           the exact distribution terms for each program are described in the
,           individual files in /usr/share/doc/*/copyright.
, 
,           Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
,           permitted by applicable law.
,           ns1# 
,
,       To search using a regular expression pattern instead of just a string of
,       text.
,
,           $ neo search \ ns1[.]neospire[.]net
,           NeoSpire ns1.neospire.net 66.111.111.5 N+uR/hv4ph xx root
,
,           $ neo search ^NeoSpire.*lvs[12]
,           NeoSpire lvs1.neospire.net 66.111.111.61 B8**ep7?yH xx root
,           NeoSpire lvs2.neospire.net 66.111.111.62 /kE@PH&@d^ xx root
,
,       To login to a pix.
,
,           $ neo pix 10.2.136.1
,           spawn ssh pix@10.2.136.1
,           pix@10.2.136.1's password:
,           Type help or '?' for a list of available commands.
,           fw1> en
,           Password: **********
,           fw1# (Now you are logged in)
,
,       To RDP to a server.
,
,           $ neo rdp 4.2.2.2
,           (A remote desktop window pops up)
,
,NOTES/CAVEATS
,
,       * During either a pix or an ssh session, you can type ctrl-x ctrl-z to put
,         the remote session into the background.
,
,THE END
        FINIS

open LESS, "|less";
print LESS " $_\n" foreach (@quote);
close LESS;
