#!/bin/bash

TASKLOCATION="${HOME}/.tasklist"
TASKFILE="${TASKLOCATION}/tasks"

ADDTASK="-add"
REMTASK="-del"
LISTTASK="-list"
SHOWTASK="-show"
HELP="-help"

function usage() {
cat << EOF
Usage: $(basename $0) -[add|del|show <num> | list | help] 

  Options:
    ${LISTTASK}		list all tasks
    ${ADDTASK}	<task>	add a new task to the list
    ${REMTASK}	<task>	remove the task from the list
    ${SHOWTASK}	<task>	show selected task
    ${HELP}		show this help message
EOF
exit 0
}

# check for necessary folders and files
if [ ! -e ${TASKLOCATION} ]
then
	mkdir -p ${TASKLOCATION}
fi

if [ ! -e ${TASKFILE} ]
then
	touch ${TASKFILE}
fi

# default option is to list all tasks
if [ $# == 0 -o "$1" == "$LISTTASK" ]
then
	cat ${TASKFILE}
	exit 0
fi

# help option
if [ "$1" == "$HELP" ]
then
	usage
	exit 0
fi

# add task action
if [ "$1" == "$ADDTASK" ]
then
	num=$(tail -1 $TASKFILE | cut -d"." -f1)
	[[ $? != 0 ]] && num=0
	((num++))
	shift
	echo "$num. $@" >> $TASKFILE
	exit 0
fi

# remove task action 
if [ "$1" == "$REMTASK" ]
then
	if [[ "$2" == [[:digit:]] ]]
	then
		sed -i "s/^$2.*$//" $TASKFILE 
		sed -i '/^\s*$/d' $TASKFILE
		#TODO reorder
	else
		usage
	fi
	exit 0
fi

# show a task
if [ "$1" == "$SHOWTASK" ]
then
	if [[ "$2" == [[:digit:]] ]]
	then
		cat $TASKFILE | grep "^$2" 
		[ $? != 0 ] && echo "No such task" >&2
	else
		usage
	fi
	exit 0
fi

echo "Uknown option: $1" >&2 && usage

# vim: nospell
