#!/usr/bin/env sh

: "${wm:=monsterwm}"
: "${ff:="/tmp/${wm}.fifo"}"
[ -p "$ff" ] || mkfifo -m 600 "$ff"

while read -t 60 -r line || true; do
    echo "$line" | grep -Ex "(([[:digit:]]+:)+[[:digit:]]+ ?)+" && prev="$line" || line=
    statusinfo.sh "${line:-"$prev"}"
done < "$ff" | some_sorta_bar &

"$wm" | tee -a "$ff"
