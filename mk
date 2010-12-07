#!/usr/bin/env bash

# Makes directory then moves into it
#function mkcdr() { 
#	    mkdir -vp "$1" && cd "$_";
#}   
# creates an archive from given directory
function mktar() { 
	    tar cvf  "${1%%/}.tar"     "${1%%/}/" && exit 0
}
function mktgz() {
	    tar cvzf "${1%%/}.tar.gz"  "${1%%/}/" && exit 0
}
function mktbz() {
	    tar cvjf "${1%%/}.tar.bz2" "${1%%/}/" && exit 0
}

if [ -n "$1" ]
then
	case $1 in
#		dir)	shift; mkcdr "$1" ;;
		tar)	shift; mktar "$1" ;;
		tgz)	shift; mktgz "$1" ;;
		tbz)	shift; mktbz "$1" ;;
	esac
else
	echo "mk: error: $1 is not valid"
fi

exit 1
