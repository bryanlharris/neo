#!/usr/bin/env tclsh

set cmd [lindex $argv 0]
set vncargs {-geometry 1152x864 -FullColor}

if {$cmd == 128} {
    set ipaddr [lindex $argv 1]
    set pass [exec neo search showpasswords "$ipaddr " | awk {{print $4}}]
    set numargs [llength $argv]
    set curarg 2
    while {$curarg < $numargs} {
        lappend vncargs [lindex $argv $curarg]
        incr curarg
    }
    set argstr [join $vncargs " "]
} elseif {$cmd == 64} {
    set regex [lindex $argv 1]
    set ipaddr [exec neo search "$regex" | awk {{print $3}}]
    set pass [exec neo search showpasswords "$regex" | awk {{print $4}}]
    set numargs [llength $argv]
    set curarg 2
    while {$curarg < $numargs} {
        lappend vncargs [lindex $argv $curarg]
        incr curarg
    }
    set argstr [join $vncargs " "]
}

exec vncviewer {*}[split $argstr] $ipaddr &
