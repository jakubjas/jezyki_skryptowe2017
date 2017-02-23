#!/usr/bin/tcsh
#Jakub Jas, grupa 2

if ( $#argv < 2 ) then

	echo
    echo "Not enough arguments"
    echo
    exit 3

else if !( (`expr "$1" : '^[0-9]\+$'`) && (`expr "$2" : '^[0-9]\+$'`) ) then

	echo
    echo "Argument is not an integer"
    echo
    exit 1

else

	if ( $#argv != 2 ) then

		if ( $1 < $2 ) then
			set step = 1
		else
			set step = -1
		endif

		echo

		foreach i (`seq $1 $step $2`)

			set values = ()

			foreach j (`seq $1 $step $2`)
				@ r = $i * $j
				set values = ( $values "$r" )
			end

			printf %4d $values
			echo

		end

		echo

		exit 2

	else

		if ( $1 < $2 ) then
			set step = 1
		else
			set step = -1
		endif

		echo

		foreach i (`seq $1 $step $2`)

			set values = ()

			foreach j (`seq $1 $step $2`)
				@ r = $i * $j
				set values = ( $values "$r" )
			end

			printf %4d $values
			echo

		end

		echo

		exit 0

	endif
	
endif