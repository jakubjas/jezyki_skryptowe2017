#!/bin/bash
#Jakub Jas, grupa 2

box() 
{
    str="$@"
    len=$((${#str}+4))

    for i in $(seq $len) 
    do 
    	echo -n '*'
    done

    echo 
    echo "* "$str" *"

    for i in $(seq $len) 
    do 
    	echo -n '*' 
    done

    echo
}

usage() 
{
	echo 
	box "Script that serves as a counter for the amount of client's connections to server"
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
}

check_if_valid_ip()
{
	local ip=$1
    local stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];
    then

        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
       
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]

        stat=$?

    fi

    echo "$stat"
}

#DEFAULT
PORT=1024
TYPE=-1
IP="127.0.0.1"
CONFIG=${HOME}/.licznik.rc
TMP=${HOME}/.licznik_tmp

if [ ! -f $CONFIG ];
then
	set -f
	echo -e "PORT=1024\nTYPE=-1\nIP=\"127.0.0.1\"\nTMP_PATH=${HOME}/.licznik_tmp" > $CONFIG
	set +f
fi

. $CONFIG

file_name=$(basename $0 .sh)

if [[ $file_name == "server" ]];
then
	TYPE=0
fi

if [[ $file_name == "client" ]];
then
	TYPE=1
fi

skip_arg=""

if [ $# -eq 0 ];
then
	echo
	echo "Not enough arguments"
	usage
	exit 1
fi

for i in "$@"
do
	if [ ! -z "$skip_arg" ];
	then
		case $skip_arg in
		    -p)
		    	PORT=$i
		    ;;
		    -i)
				IP=$i
		    ;;
		    -f)
		    	CONFIG=$i
		    ;;
		esac
		skip_arg=""
		continue
	fi 

	case $i in
	    -p)
	    	skip_arg="-p"
	    ;;
	    -s)
	    	if [ "$TYPE" -eq -1 ];
	    	then
	    		TYPE=0
	    	fi
	    ;;
	    -c)
	    	if [ "$TYPE" -eq -1 ];
	    	then
	    		TYPE=1
	    	fi
	    ;;
	    -i)
			skip_arg="-i"
	    ;;
	    -f)
	    	skip_arg="-f"
	    ;;
	    *)
			echo
			echo "Invalid argument(s)"
			usage
			exit 2
		;;
	esac
done

if [ "$TYPE" -eq -1 ];
then
	echo
	echo "Please specify mode: server (-s) or client (-c)"
	usage
	exit 3
fi

if [[ "$PORT" =~ ^[0-9]+$ ]];
then
	if [ "$PORT" -lt 1024 ] || [ "$PORT" -gt 49151 ]; 
	then
		echo
		echo "Port number out of range"
		echo
	fi
else
	echo
	echo "Invalid port value"
	usage
	exit 4
fi

if [ ! -z "$IP" ];
then
	if [[ `check_if_valid_ip "$IP"` -ne 0 ]];
	then
		echo
	    echo "$IP is not a valid IP address"
	    echo
	fi
fi

if [ "$TYPE" -eq 0 ];
then
	echo "Starting server..."

	if [ ! -d "$TMP" ];
	then
		mkdir $TMP
	fi

	if [ ! -f "$TMP/$PORT" ];
	then
		echo 0 > $TMP/$PORT
	fi

	while true
	do
		cat $TMP/$PORT | nc -l -p $PORT $IP
		if [ $? -eq 1 ];
		then
			echo "Port number $PORT is busy"
			exit 5
		fi

		counter=$(cat $TMP/$PORT)
		counter=$((counter+1))
		echo $counter > $TMP/$PORT
	done
else
	echo "Starting client..."

	echo "" | nc -q 1 $IP $PORT
	if [ $? -eq 1 ];
	then
		echo "Can't connect to $IP:$PORT"
		exit 6
	fi
fi