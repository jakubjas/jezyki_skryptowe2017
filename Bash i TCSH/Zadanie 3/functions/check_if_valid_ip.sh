#!/bin/tcsh
#Jakub Jas, grupa 2

set ip = $1
set octets = ( )
set valid_flag = 0

foreach i (`seq 1 4`)
	
	set octets = ( $octets "`echo "$ip" | cut -d. -f $i`" )

end

foreach octet ($octets)
	
	set test = `echo "$octet" | grep '^[0-9]*$'`

	if !( (($test) || ($test == 0)) ) then
		set valid_flag = 1
    	break
	endif

end

if ( "$valid_flag" == "1" ) then
	echo "1"

else if ( ($octets[1] <= 255) && ($octets[2] <= 255) && ($octets[3] <= 255) && ($octets[4] <= 255) ) then
	echo "0"

else
	echo "1"

endif

