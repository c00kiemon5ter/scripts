#!/bin/sh

name="scratchpad"
class="URxvt"

# print the window id of the window with the given
# instance name as the first argument '$1' and
# class name as the second argument '$2'
get_win_id() {
	xwininfo -root -children -int | awk -v n="$1" -v c="$2" '$3 == "(\""n"\"" && $4 == "\""c"\")" { print $1 }'
}

# get the window id
winid="$(get_win_id "$name" "$class")"

# if the window was not found
if [ -z "$winid" ]
then
	# spawn it
	urxvtdc -name "$name"
	# get the window id again
	winid="$(get_win_id)"
	# if the window was not found then something is really wrong. give up.
	[ -z "$winid" ] && exit 1
fi

# if the window is hidden show it, else hide it
if ! xwininfo -id "$winid" | awk '$1 == "Map" && $2 == "State:" { exit ($3 == "IsUnMapped") }'
then xdotool windowmap   "$winid"
else xdotool windowunmap "$winid"
fi

