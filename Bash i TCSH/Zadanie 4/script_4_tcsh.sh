#!/bin/tcsh
#Jakub Jas, grupa 2

cd "$cwd"

if ( $#argv < 3 ) then
	echo
    echo "Not enough arguments"
    echo
    exit 1

else if ( (`functions/check_if_valid_ip.sh $1` != 0) || (`functions/check_if_valid_ip.sh $2` != 0) ) then

	if ( (`functions/check_if_valid_ip.sh $1` != 0) && (`functions/check_if_valid_ip.sh $2` == 0) ) then
		echo
	    echo "$1 is not a valid IP address"
	    echo

	else if ( (`functions/check_if_valid_ip.sh $1` == 0) && (`functions/check_if_valid_ip.sh $2` != 0) ) then
		echo
	    echo "$2 is not a valid IP address"
	    echo

	else
		echo
	    echo "Invalid arguments"
	    echo

	endif

	exit 2

else if ( `functions/check_if_valid_ports.sh $3` != 0 ) then
	echo
    echo "Invalid port list"
    echo
    exit 3


else

	if ( `uname -s` == "Darwin" ) then
		set broadcast = `/sbin/ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{print $6}'`
		set mask_hex = `/sbin/ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{print $4}'`
		set mask_dec = `printf "%d" $mask_hex`
		set mask = `functions/int_to_ip.sh $mask_dec`
		set inet = `/sbin/ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{print $2}'`
		set network_address = `functions/get_network_address.sh "$inet" "$mask"`

	else
		set broadcast = `/sbin/ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{print $3}' | cut -d ":" -f 2`
		set mask = `/sbin/ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{print $4}' | cut -d ":" -f 2`
		set inet = `/sbin/ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{print $2}' | cut -d ":" -f 2`
		set network_address = `functions/get_network_address.sh "$inet" "$mask"`

	endif

	@ ip1_int = `functions/ip_to_int.sh $1`
	@ ip2_int = `functions/ip_to_int.sh $2`

	if ( $ip1_int > $ip2_int ) then

		set temp = $ip1_int
		set ip1_int = $ip2_int
		set ip2_int = $temp

	endif

	echo 

	@ i = $ip1_int

	while ($i <= $ip2_int)
		
		set ip_address = `functions/int_to_ip.sh $i`

		if ( "$ip_address" == "$broadcast" ) then
			echo "$ip_address broadcast"

		else if ( "$ip_address" == "$network_address" ) then
			echo "$ip_address network address"

		else
			set ports = `echo "$3" | sed 's/,/ /g'`

			foreach port ($ports)
				
				nc -z -w1 $ip_address $port

				if ( "$?" == "0" ) then 
					set service = `echo 'QUIT' | nc -n -v -w1 "$ip_address" "$port" |& cat | awk '{ print $4 }' | tr -d '()'`

					if ( "$port" == "22" ) then
						set version = `echo 'QUIT' | nc -n -v -w1 $ip_address $port |& cat | awk 'NR==2{print $1}'`
						set os = `echo 'QUIT' | nc -n -v -w1 $ip_address $port |& cat | awk 'NR==2{print $2}'`
						echo "${ip_address}:${port}: $service - $version, OS - $os"
					else
						echo "${ip_address}:${port}: open"
					endif
			    else
			        echo "${ip_address}:${port}: closed"
			    endif

			end

		endif

		@ i += 1
	end

	echo

	exit 0

endif