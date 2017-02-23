#!/usr/bin/tcsh
#Jakub Jas, grupa 2

echo

foreach i (`seq 1 9`)

	set values = ()

	foreach j (`seq 1 9`)

		@ r = $i * $j
		set values = ( $values "$r" )

	end

	printf %4d $values

	echo

end

echo