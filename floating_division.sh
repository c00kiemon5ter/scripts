#!/bin/bash
# c00kiemon5ter (ivan.kanak@gmail.com) ~ under c00kie License
#
# Division returning floating point results
# using only bash/coreutils 

a=$1				# dividend
b=$2				# divider
ACCURACY=${3:-2}	# number of floating point digits

result=$(( $a/$b ))

if (( $a%$b != 0 )); then
	result=$result.$(( ($a%$b)*(10**$ACCURACY)/$b ))
fi

echo $result | sed "s/0*$//"
