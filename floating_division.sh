#!/usr/bin/env bash
# c00kiemon5ter (ivan.kanak@gmail.com) ~ under c00kie License
#
# Division returning floating point results
# using only bash/coreutils 

function usage(){
	echo "usage is: $(basename $0) dividend divider [accuracy]"
	echo "	divider should be different than 0"
	echo "	accuracy is the number of floating"
	echo "	point digits default accuracy is 2"
	exit 1
}

(( $# < 2 )) && usage

a=$1			# dividend
b=$2			# divider
dacc=2			# default accuracy
acc=${3:-$dacc}	# accuracy - number of floating point digits

if (( $b == 0 )); then
	echo "OMFG you divided by zero, ROFLOLMAO BOMBS are falling, WTF!"
	exit 1
fi

result=$(( $a / $b ))
float=$(( $a % $b ))

function calc_float(){
	float=$(( $a % $b * (10**$acc) / $b ))
	if (( ${#float} != $acc )); then
		zeros=$(( $acc - ${#float} ))
		for i in $(seq 1 $zeros); do
			float="0$float"
		done
	fi
	float=$(echo $float | sed "s/0*$//")
}

if (( $float )); then
	if (( $a < 0 )); then
		a=$(( a - 2 * $a ))
	fi
	if (( $b < 0 )); then
		b=$(( $b - 2 * $b ))
	fi
	if (( $acc < 0 )); then
		acc=$dacc
	fi
	until calc_float; (( ${#float} )); do
		let acc+=1
	done
fi

if echo $float | grep - &>/dev/null; then
	echo "$(basename $0): error: register overflow"
	exit 1
fi

echo $result.$float
exit 0
