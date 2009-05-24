#!/usr/bin/env tclsh

set cmd [lindex $argv 0]
set rdpargs {2>/dev/null -a 16 -g 1152x864 -u sqltest}

if {$cmd == 128} {
    set ipaddr [lindex $argv 1]
    set pass [exec neo search showpasswords "$ipaddr " | awk {{print $4}}]
    set numargs [llength $argv]
    set curarg 2
    while {$curarg < $numargs} {
        lappend rdpargs [lindex $argv $curarg]
        incr curarg
    }
    set argstr [join $rdpargs " "]
} elseif {$cmd == 64} {
    set regex [lindex $argv 1]
    set ipaddr [exec neo search "$regex" | awk {{print $3}}]
    set pass [exec neo search showpasswords "$regex" | awk {{print $4}}]
    set numargs [llength $argv]
    set curarg 2
    while {$curarg < $numargs} {
        lappend rdpargs [lindex $argv $curarg]
        incr curarg
    }
    set argstr [join $rdpargs " "]
}
append argstr "-p \'$pass\'"

exec rdesktop {*}[split $argstr] $ipaddr &
