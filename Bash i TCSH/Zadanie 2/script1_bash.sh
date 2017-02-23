#!/bin/bash
#Jakub Jas, grupa 2

echo

for i in `seq 1 9`;
do 
	for j in `seq 1 9`;
	do
		printf %4d $((i*j))
	done

	echo
done

echo