#!/bin/tcsh
#Jakub Jas, grupa 2

set octets1 = ( )
set octets2 = ( )

foreach i (`seq 1 4`)
	
	set octets1 = ( $octets1 "`echo "$1" | cut -d. -f $i`" )

end

foreach i (`seq 1 4`)
	
	set octets2 = ( $octets2 "`echo "$2" | cut -d. -f $i`" )

end

@ network_address1 = ($octets1[1] & $octets2[1])
@ network_address2 = ($octets1[2] & $octets2[2])
@ network_address3 = ($octets1[3] & $octets2[3])
@ network_address4 = ($octets1[4] & $octets2[4])

set network_address = `printf "%d.%d.%d.%d\n" "$network_address1" "$network_address2" "$network_address3" "$network_address4"`

echo "$network_address"