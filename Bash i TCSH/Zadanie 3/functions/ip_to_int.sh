#!/bin/tcsh
#Jakub Jas, grupa 2

set ip = $1
set ip_num = 0

@ i = 0

while ($i < 4)
	
	@ power = 3 - $i
	set first_octet = `echo "$ip" | cut -d. -f1`
	set ip = `echo "$ip" | cut -d. -f 2-`
	@ ip_num += $first_octet * `echo 256^$power | bc`
	@ i += 1
end

echo "$ip_num"