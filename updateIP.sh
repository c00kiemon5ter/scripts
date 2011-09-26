#!/usr/bin/env sh

cacheipfile="/etc/ip.cache"
checkurl='http://freedns.afraid.org/dynamic/check.php'
updateurl='http://freedns.afraid.org/dynamic/update.php?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

if [ -f $cacheipfile ]; then
    cip="$(head -1 $cacheipfile | sed 's/.*: \(.\+\)/\1/')"
fi

ip="$(wget $checkurl -o /dev/null -O /dev/stdout \
    | sed -n 's/^Detected.*: \(.\+\)/\1/p')"

if [ "$ip" == "$cip" ]; then
    printf "IP has not changed: %s\n" "$ip"
else
    printf "updating IP: %s %s\n" "$cip" "$ip"

    if wget -q --waitretry=5 --tries=4 $updateurl -o /dev/null -O /dev/stdout;
    then
        printf "%s: %s\n" "$(date +"%F @ %R")" "$ip" > "$cacheipfile"
        printf "IP updated: %s\n" "$ip"
    fi
fi

