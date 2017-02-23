#!/bin/bash
#Jakub Jas, grupa 2

login=$(getent passwd $USER | cut -d: -f1)
name_surname=$(getent passwd $USER | cut -d: -f5 | cut -d, -f1)

help_flag=0
quiet_flag=0
unknown_flag=0

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
	box "Displays login, name and surname of the user who executed the script"
	echo 
	echo "Usage: $0 <options>"
	echo 
	echo "Options:"
	echo "-h | --help : display help"
	echo "-q | --quiet : quiet mode"
	echo 
}

display_userdata() 
{
	if [ -z "$name_surname" ];
	then
		echo
		echo "Login: $login"
		echo
		exit 1
	else
		echo
		echo "Login: $login"
		echo "Name and surname: $name_surname"
		echo
		exit 0
	fi
}

i=0

while [ $# -gt 0 ]
do
	case $1 in
		-h|--help)
			help_flag=1
			;;
		-q|--quiet)
			quiet_flag=1
			;;
		-*)
			unknown_flag=1
			unknown_arguments[i]=$1
			;;
	esac

	shift

	i=$((i+1))
done

if [ "$help_flag" -eq 1 ];
then
	usage
	exit 0

elif [ "$quiet_flag" -eq 1 ] && [ "$help_flag" -eq 0 ];
then
	exit 0

elif [ "$unknown_flag" -eq 1 ] && [ "$help_flag" -eq 0 ] && [ "$quiet_flag" -eq 0 ];
then
	echo
	echo "Unknown argument(s): ${unknown_arguments[@]}"
	usage
	exit 1

else
	display_userdata
	exit 0

fi