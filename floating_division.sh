#!/bin/bash
# c00kiemon5ter (ivan.kanak@gmail.com) ~ under c00kie License
#
# Division returning floating point results
# using only bash/coreutils 

a=$1				# dividend
b=$2				# divider
dacc=2				# default accuracy
acc=${3:-$dacc}		# accuracy - number of floating point digits


result=$(( $a/$b ))

if (( $a%$b )); then
	if (( $a<0 )); then
		a=$((a-2*$a))
	fi
	if (( $b<0 )); then
		b=$(($b-2*$b))
	fi
	if (( $acc<0 )); then
		acc=$dacc
	fi
	result=$result.$(( ($a%$b)*(10**$acc)/$b ))
fi

if echo $result | grep [.]- &>/dev/null; then
	echo "$(basename $0): error: register overflow"
	exit 1
fi

echo $result | sed "s/0*$//"
exit 0
