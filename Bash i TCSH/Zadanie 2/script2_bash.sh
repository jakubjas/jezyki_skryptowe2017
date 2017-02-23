#!/bin/bash
#Jakub Jas, grupa 2

display_table()
{
	if [ "$1" -lt "$2" ];
	then
		step=1
	else
		step=-1
	fi

	echo

	for i in `seq $1 $step $2`;
	do 
		for j in `seq $1 $step $2`;
		do
			printf %4d $((i*j))
		done

		echo
	done

	echo
}

if [[ $# < 2 ]];
then
	echo
    echo "Not enough arguments"
    echo
    exit 3

elif ! [[ "$1" =~ ^[0-9]+$ && "$2" =~ ^[0-9]+$ ]];
then
	echo
    echo "Argument is not an integer"
    echo
    exit 1
else
	if [ "$#" -ne 2 ];
	then
		display_table "$1" "$2"
		exit 2
	else
		display_table "$1" "$2"
		exit 0
	fi
fi