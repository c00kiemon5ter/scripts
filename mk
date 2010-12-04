#!/usr/bin/env bash

# Makes directory then moves into it
function mkcdr() { 
	    mkdir -vp "$@" && cd "$_";
}   
# creates an archive from given directory
function mktar() { 
	    tar cvf  "${1%%/}.tar"     "${1%%/}/";
}
function mktgz() {
	    tar cvzf "${1%%/}.tar.gz"  "${1%%/}/";
}
function mktbz() {
	    tar cvjf "${1%%/}.tar.bz2" "${1%%/}/";
}

if [ -f "$1" ]
then
	case $1 in
		dir)	mkcdr $@	;;
		tar)	mktar $@	;;
		tgz)	mktgz $@	;;
		tbz)	mktbz $@	;;
	esac
else
	echo "mk: error: $1 is not valid"
fi

