#!/usr/bin/tcsh
#Jakub Jas, grupa 2

set number_of_args = $#argv
set number_args = ( )
set operator_args = ( )

while ( $#argv != 0 )

	set test = `echo $1 | grep '^[0-9]*$'`

    if ( (($test) || ($test == 0)) ) then
        set number_args = ( $number_args "$1" )

    else if ( ("$1" == "+") || ("$1" == "-") || ("$1" == "/") || ("$1" == "%") || ("$1" == "^") ) then
			set operator_args = ( $operator_args "$1" )

	else if ( "$1" == '*' ) then
			set operator_args = ( $operator_args "multiply" )
    endif
	
	shift
end

if ( $#number_args < 2 ) then

	echo
    echo "Not enough arguments"
    echo
    exit 4

else if ( ($#operator_args == 0) && ($#number_args >= 2) ) then

	echo
    echo "No operator specified / Incorrect operator"
    echo "If you tried to print multiplication table, please use '*' instead of *"
    echo
    exit 2

else if !( (`expr "$number_args[1]" : '^[0-9]\+$'`) && (`expr "$number_args[2]" : '^[0-9]\+$'`) ) then

	echo
    echo "Argument is not an integer"
    echo
    exit 1

else
	if ( $number_of_args != 3 ) then
		
		set oper = $operator_args[1]

		if ( $number_args[1] < $number_args[2] ) then
			@ step = 1
		else
			@ step = -1
		endif

		echo

		foreach i (`seq $number_args[1] $step $number_args[2]`)

			set values = ()

			foreach j (`seq $number_args[1] $step $number_args[2]`)

				if ( "$oper" == "^" ) then
					@ r = `echo $i^$j | bc`
				else if ( "$oper" == "multiply" ) then
					@ r = $i * $j
				else
					@ r = $i $oper $j
				endif

				set values = ( $values "$r" )
			end

			printf %4d $values
			echo

		end

		echo

		exit 3

	else

		set oper = $operator_args[1]

		if ( $number_args[1] < $number_args[2] ) then
			@ step = 1
		else
			@ step = -1
		endif

		echo

		foreach i (`seq $number_args[1] $step $number_args[2]`)

			set values = ()

			foreach j (`seq $number_args[1] $step $number_args[2]`)

				if ( "$oper" == "^" ) then
					@ r = `echo $i^$j | bc`
				else if ( "$oper" == "multiply" ) then
					@ r = $i * $j
				else
					@ r = $i $oper $j
				endif

				set values = ( $values "$r" )
			end

			printf %4d $values
			echo

		end

		echo

		exit 0

	endif

endif
