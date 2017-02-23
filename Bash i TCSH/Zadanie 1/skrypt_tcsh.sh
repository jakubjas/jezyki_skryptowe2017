#!/usr/bin/tcsh
#Jakub Jas, grupa 2

set login = `getent passwd $USER | cut -d: -f1`
set name_surname = `getent passwd $USER | cut -d: -f5 | cut -d, -f1`

set help_flag = 0
set quiet_flag = 0
set unknown_flag = 0

set unknown_arguments = ( )

while ( $#argv != 0 ) 

	switch($argv[1])

		case -h:
		case --help:
			set help_flag = 1
			breaksw

		case -q:
		case --quiet:
			set quiet_flag = 1
			breaksw

		case -*:
			set unknown_flag = 1
			set unknown_arguments = ( $unknown_arguments "$argv[1]" )
			breaksw

	endsw

	shift

end

if ( $help_flag == 1 ) then

	set str = "Displays login, name and surname of the user who executed the script"
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
	echo "-h | --help : display help"
	echo "-q | --quiet : quiet mode"
	echo
	exit 0

else if ( $quiet_flag == 1 && $help_flag == 0 ) then
	exit 0

else if ( $unknown_flag == 1 && $help_flag == 0 && $quiet_flag == 0 ) then

	echo
	echo "Unknown argument(s): $unknown_arguments"

	set str = "Displays login, name and surname of the user who executed the script"
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
	echo "-h | --help : display help"
	echo "-q | --quiet : quiet mode"
	echo
	exit 1

else
	if ( "$name_surname" == "" ) then
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
	endif

	exit 0

endif