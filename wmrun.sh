#!/usr/bin/env sh

: "${wm:=monsterwm}"
: "${ff:="/tmp/${wm}.fifo"}"
[ -p "$ff" ] || mkfifo -m 600 "$ff"

# run some_sorta_bar
while read -t 60 -r line || true; do
    echo "$line" | grep -Ex "(([[:digit:]]+:)+[[:digit:]]+ ?)+" 2>/dev/null 1>&2 && prev="$line" || line=
    statusinfo.sh ${line:-$prev}
done < "$ff" | bar &

# run mopag
#mopag < "$ff" &

"$wm" > "$ff"
