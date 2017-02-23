#!/bin/bash
#Jakub Jas, grupa 2

number_of_args=$#

display_table()
{
	oper=$3

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
			if [ "$oper" == "^" ];
			then
				printf %4d $(bc <<< $i^$j)
			else
				printf %4d $((i $oper j))
			fi	
		done

		echo
	done

	echo
}

while [ $# -gt 0 ]
do
	if [[ "$1" =~ ^[0-9]+$ ]];
	then
		number_args[i]=$1
		i=$((i+1))
	else
		case $1 in
		+|-|/|%|^)
			operator_args[j]=$1
			j=$((j+1))
			;;
		'*')
			operator_args[j]="*"
			j=$((j+1))
			;;
		esac
	fi

	shift
done

if [[ ${#number_args[@]} -lt 2 ]];
then
	echo
    echo "Not enough arguments"
    echo
    exit 4

elif [[ "${#operator_args[@]}" -eq 0 && ${#number_args[@]} -ge 2 ]]; 
then
	echo
    echo "No operator specified / Incorrect operator"
    echo "If you tried to print multiplication table, please use '*' instead of *"
    echo
    exit 2

elif ! [[ "${number_args[0]}" =~ ^[0-9]+$ && "${number_args[1]}" =~ ^[0-9]+$ ]];
then
	echo
    echo "Argument is not an integer"
    echo
    exit 1

else
	if [ "$number_of_args" -ne 3 ];
	then
		display_table "${number_args[0]}" "${number_args[1]}" "${operator_args[0]}"
		exit 3
	else
		display_table "${number_args[0]}" "${number_args[1]}" "${operator_args[0]}"
		exit 0
	fi
fi