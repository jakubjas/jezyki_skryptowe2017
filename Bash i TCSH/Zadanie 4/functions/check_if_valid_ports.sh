#!/bin/tcsh
#Jakub Jas, grupa 2

set ports = `echo "$1" | sed 's/,/ /g'`
set valid_flag = 0

foreach port ($ports)
	
	set test = `echo "$port" | grep '^[0-9]*$'`

	if !( (($test) || ($test == 0)) ) then
		set valid_flag=1
    	break
	endif

end

echo "$valid_flag"