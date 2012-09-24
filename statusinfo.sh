#!/usr/bin/env sh
# expects a line from monsterwm's output as argument ("$1")
# prints formatted output to be used as input for bar
# reference: bar by LemonBoy -- https://github.com/LemonBoy/bar

# desktop status
for desk; do
    m="${desk%%:*}" desk="${desk#*:}" # monitor id
    n="${desk%%:*}" desk="${desk#*:}" # is current monitor
    d="${desk%%:*}" desk="${desk#*:}" # desktop id
    w="${desk%%:*}" desk="${desk#*:}" # window count
    l="${desk%%:*}" desk="${desk#*:}" # layout mode
    c="${desk%%:*}" desk="${desk#*:}" # is current desktop
    u="$desk"                         # has urgent hint

    # desktop id
    case "$d" in
        0) d="" ;; 1) d="" ;;
        2) d="" ;; 3) d="" ;;
    esac

    # current desktop on active monitor
    if [ $n -ne 0 -a $c -ne 0 ]
    then bg="\b2" un="\u2"
        case "$l" in
            0) s="T" ;; 1) s="M" ;; 2) s="B" ;;
            3) s="G" ;; 4) s="#" ;; 5) s="F" ;;
        esac && s="\u2\b2 [$s] \br\ur"
    # current desktop on inactive monitor
    elif [ $c -ne 0 ]
    then bg="\b4" un="\u4"
    fi

    # has urgent hint or no windows
    [ $u -ne 0 ] && un="\u3"
    [ $w -eq 0 ] && w="\f6-"

    left="$left$bg$fg$un $d $w \ur\br\fr"
    unset bg fg un
done

# music status
music="$(mpc current -f "%title% #\f8by #\f1%artist%")"
if [ -z "$music" ]; then music="[stopped]" mstat=""
else
    mstat="$(mpc | sed -rn '2s/\[([[:alpha:]]+)].*/\1/p')"
    [ "$mstat" == "paused" ] && mstat="" || mstat=""
fi

# volume status
if [ "$(amixer get Master | sed -nr '$ s:.*\[(.+)]$:\1:p')" == "off" ]
then vol="[m]" vstat=""
else
    vol="$(amixer get PCM | sed -nr '$ s:.*\[(.+%)].*:\1:p')"
    if   [ "${vol%\%}" -le 10 ]; then vstat=""
    elif [ "${vol%\%}" -le 20 ]; then vstat=""; else vstat=""; fi
fi

# date and time
date="$(date +"%a %d/%m %R")" dstat=""

printf '%s %s %s' "$left" "$s" "\r"
printf ' \\u2\\b2 %s \\br\\ur %s' "$mstat" "$music" "$vstat" "$vol" "$dstat" "$date"
printf '\n'

