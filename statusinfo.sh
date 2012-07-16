#!/usr/bin/env sh
# expects a line from monsterwm's output as argument ("$1")
# prints formatted output to be used as input for bar
# reference: bar by LemonBoy -- https://github.com/LemonBoy/bar

# desktop status
for desk; do
    d="${desk%%:*}" desk="${desk#*:}" # desktop id
    w="${desk%%:*}" desk="${desk#*:}" # window count
    m="${desk%%:*}" desk="${desk#*:}" # layout mode
    c="${desk%%:*}" desk="${desk#*:}" # is current desktop
    u="$desk"                         # has urgent hint
    case "$d" in
        0) d="web" ;; 1) d="dev" ;;
        2) d="foo" ;; 3) d="nil" ;;
    esac
    [ $c -ne 0 ] && fg="\f5" && case "$m" in
        0) l="T" ;; 1) l="M" ;; 2) l="B" ;;
        3) l="G" ;; 4) l="#" ;; 5) l="F" ;;
    esac || fg="\f9"
    [ $w -eq 0 ] && w="\f8-"; [ $u -ne 0 ] && w="$w\f9!"
    left="$left$fg$d $w \f8:: "
done

# music status
music="$(mpc current -f "%title% #\f8by #\f9%artist%")"
if [ -z "$music" ]; then music="[stopped]" mstat="\uE5"
else
    mstat="$(mpc | sed -rn '2s/\[([[:alpha:]]+)].*/\1/p')"
    [ "$mstat" == "paused" ] && mstat="\uE7" || mstat="\uEA"
fi

# volume status
if [ "$(amixer get Master | sed -nr '$ s:.*\[(.+)]$:\1:p')" == "off" ]
then vstat="\uEB"
else
    vol="$(amixer get PCM | sed -nr '$ s:.*\[(.+%)].*:\1:p')"
    if [ "${vol%\%}" -le 20 ]; then vstat="\uEC"; else vstat="\uED"; fi
fi

# date and time
date="$(date +"%a %d/%m %R")" dstat="\uC9"

printf " \\\l%s \\\f9[ \\\f5%s\\\f9 ] \\\r" "$left" "$l"
printf " \\\f5%b \\\f9%s" "$mstat" "$music" "$vstat" "$vol" "$dstat" "$date"
printf "\n"

