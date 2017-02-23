#!/bin/bash
#Jakub Jas, grupa 2

ip_to_int()
{
	local ip=$1
	local ip_num=0

	for (( i=0 ; i<4 ; ++i )); 
	do
		((ip_num+=${ip%%.*}*$((256**$((3-${i}))))))
		ip=${ip#*.}
	done

	echo "$ip_num"
}

int_to_ip()
{
	local ip_address=`echo -n $(($(($(($((${1}/256))/256))/256))%256)).`
	ip_address+=`echo -n $(($(($((${1}/256))/256))%256)).`
	ip_address+=`echo -n $(($((${1}/256))%256)).`
	ip_address+=`echo $((${1}%256))`

	echo "$ip_address"
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

get_network_address()
{
	IFS=. read -r i1 i2 i3 i4 <<< "$1"
	IFS=. read -r m1 m2 m3 m4 <<< "$2"

	local network_address=`printf "%d.%d.%d.%d\n" "$((i1 & m1))" "$((i2 & m2))" "$((i3 & m3))" "$((i4 & m4))"`

	echo "$network_address"
}

if [[ $# < 2 ]];
then
	echo
    echo "Not enough arguments"
    echo
    exit 1

elif [[ `check_if_valid_ip "$1"` -ne 0 || `check_if_valid_ip "$2"` -ne 0 ]];
then
	if [[ `check_if_valid_ip "$1"` -ne 0 && `check_if_valid_ip "$2"` -eq 0 ]];
	then
		echo
	    echo "$1 is not a valid IP address"
	    echo

	elif [[ `check_if_valid_ip "$1"` -eq 0 && `check_if_valid_ip "$2"` -ne 0 ]];
	then
		echo
	    echo "$2 is not a valid IP address"
	    echo

	else
		echo
	    echo "Invalid arguments"
	    echo
	fi

	exit 2

else

	if [ "$(uname -s)" == "Darwin" ];
	then
		broadcast=`/sbin/ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{print $6}'`
		mask_hex=`/sbin/ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{print $4}'`
		mask_dec=$(printf "%d" $mask_hex)
		mask=$(int_to_ip $mask_dec)
		inet=`/sbin/ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{print $2}'`
		network_address=$(get_network_address "$inet" "$mask")

	else
		broadcast=`/sbin/ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{print $3}' | cut -d ":" -f 2`
		mask=`/sbin/ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{print $4}' | cut -d ":" -f 2`
		inet=`/sbin/ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{print $2}' | cut -d ":" -f 2`
		network_address=$(get_network_address "$inet" "$mask")

	fi

	ip1_int=$(ip_to_int $1)
	ip2_int=$(ip_to_int $2)

	if [ "$ip1_int" -gt "$ip2_int" ];
	then
		temp=$ip1_int
		ip1_int=$ip2_int
		ip2_int=$temp
	fi

	echo 

	for (( i=$ip1_int; i<=$ip2_int; ++i )); 
	do
		ip_address=$(int_to_ip $i)

		if [ "$ip_address" == "$broadcast" ];
		then
			echo "$ip_address broadcast"

		elif [ "$ip_address" == "$network_address" ]; 
		then
			echo "$ip_address network address"

		else
			ping -c 1 -t 1 $ip_address > /dev/null 2> /dev/null 

		    if [ $? -eq 0 ]; 
		    then  
		        echo "$ip_address up"
		    else
		        echo "$ip_address down"
		    fi
		fi
	done

	echo

	exit 0
fi