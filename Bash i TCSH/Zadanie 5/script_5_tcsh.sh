#!/bin/tcsh
#Jakub Jas, grupa 2

#DEFAULT
set PORT=1024
set TYPE=-1
set IP="127.0.0.1"
set CONFIG=${HOME}/.licznik.csh
set TMP=${HOME}/.licznik_tmp

if ( ! -f $CONFIG ) then
	set noglob
	printf "set PORT=1024\nset TYPE=-1\nset IP="127.0.0.1"\nset TMP_PATH=${HOME}/.licznik_tmp" > $CONFIG
	unset noglob
endif

source $CONFIG

set file_name=`basename $0 .sh`

if ( $file_name == "server" ) then
	set TYPE=0
endif

if ( $file_name == "client" ) then
	set TYPE=1
endif

if ( $#argv == 0 ) then
	echo
	echo "Not enough arguments"

	set str="Script that serves as a counter for the amount of client's connections to server"
	@ len = ${%str} + 4

	echo

	foreach i (`seq $len`)
		echo -n '*'
	end

	echo
	echo "* "$str" *"

	foreach i (`seq $len`)
		echo -n '*'
	end

	echo
	echo 
	echo "Usage: $0 <options>"
	echo 
	echo "Options:"
	echo "-p <port> : display help"
	echo "-s : server mode"
	echo "-c : client mode"
	echo "-i <IP> : connect to given IP address"
	echo "-f <configuration file> : specify configuration file"
	echo

	exit 1
endif

set skip_arg = ""

foreach i ($*)

	if ( "$skip_arg" != "" ) then

		switch ($skip_arg)
			case -p: 
				set PORT=$i
				breaksw

			case -i:
				set IP=$i
				breaksw

			case -f:
				set CONFIG=$1
				breaksw
		endsw

		set skip_arg = ""

		continue

	endif 

	switch ($i)
		case -p: 
			set skip_arg = "-p"
			breaksw

		case -s:
			if ( "$TYPE" == -1 ) then
	    		set TYPE=0
	    	endif
			breaksw

		case -c:
			if ( "$TYPE" == -1 ) then
	    		set TYPE=1
	    	endif
			breaksw

		case -i:
			set skip_arg = "-i"
			breaksw

		case -f:
			set skip_arg = "-f"
			breaksw

		case *:
			echo
			echo "Invalid argument(s)"

			set str = "Script that serves as a counter for the amount of client's connections to server"
			@ len = ${%str} + 4

			echo

			foreach i (`seq $len`)
				echo -n '*'
			end

			echo
			echo "* "$str" *"

			foreach i (`seq $len`)
				echo -n '*'
			end

			echo
			echo 
			echo "Usage: $0 <options>"
			echo 
			echo "Options:"
			echo "-p <port> : display help"
			echo "-s : server mode"
			echo "-c : client mode"
			echo "-i <IP> : connect to given IP address"
			echo "-f <configuration file> : specify configuration file"
			echo
			exit 2
			breaksw
	endsw
end

if ($TYPE == -1) then
	echo
	echo "Please specify mode: server (-s) or client (-c)"
	
	set str = "Script that serves as a counter for the amount of client's connections to server"
	@ len = ${%str} + 4

	echo

	foreach i (`seq $len`)
		echo -n '*'
	end

	echo
	echo "* "$str" *"

	foreach i (`seq $len`)
		echo -n '*'
	end

	echo
	echo 
	echo "Usage: $0 <options>"
	echo 
	echo "Options:"
	echo "-p <port> : display help"
	echo "-s : server mode"
	echo "-c : client mode"
	echo "-i <IP> : connect to given IP address"
	echo "-f <configuration file> : specify configuration file"
	echo
	exit 3
endif

set test = `echo "$PORT" | grep '^[0-9]*$'`

if !( (($test) || ($test == 0)) ) then
	echo
	echo "Invalid port value"
	usage
	exit 4
else
	if ( ( "$PORT" < 1024 ) || ("$PORT" > 49151) ) then
		echo
		echo "Port number out of range"
		echo
	endif
endif

if ( "$IP" != "" ) then
	if ( `functions/check_if_valid_ip.sh $IP` != 0 ) then
		echo
	    echo "$IP is not a valid IP address"
	    echo
	endif
endif

if ("$TYPE" == 0) then

	echo "Starting server..."

	if (! -d "$TMP") then
		mkdir $TMP
	endif

	if ( ! -f "$TMP/$PORT" ) then
		echo 0 > $TMP/$PORT
	endif

	while (1)
		cat $TMP/$PORT | nc -l -p $PORT $IP
		if ( $? == 1 ) then
			echo "Port number $PORT is busy"
			exit 5
		endif

		set counter=`cat $TMP/$PORT`
		@ counter++
		echo $counter > $TMP/$PORT
	end
else
	echo "Starting client..."

	echo "" | nc -q 1 $IP $PORT
	if ( $? == 1 ) then
		echo "Can't connect to $IP:$PORT"
		exit 6
	endif
endif