#!/usr/bin/env sh

: "${wm:=monsterwm}"
: "${ff:="/tmp/${wm}.fifo"}"
[ -p "$ff" ] || mkfifo -m 600 "$ff"

# spawn a statusbar
while read -t 60 -r line || true; do
    echo "$line" | grep -qEx "(([[:digit:]]+:){4,6}[[:digit:]]+ ?)+" && prev="$line" || line=
    statusinfo.sh ${line:-$prev}
done < "$ff" | bar &

# spawn a pager
#mopag < "$ff" &

"$wm" > "$ff"
