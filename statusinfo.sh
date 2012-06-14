#!/usr/bin/env sh
# expects a line from monsterwm's output as argument ("$1")
# prints formatted output to be used as input for some_sorta_bar

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
    [ $c -ne 0 ] && fg="&4" && case "$m" in
        0) l="T" ;; 1) l="M" ;; 2) l="B" ;;
        3) l="G" ;; 4) l="#" ;; 5) l="F" ;;
    esac || fg="&3"
    [ $w -eq 0 ] && w="&8-"; [ $u -ne 0 ] && w="$w&5!"
    left="$left$fg$d $w &9| "
done

# music status
music="$(mpc current -f "%title% #&4by #&3%artist%")"
if [ -z "$music" ]; then music="[stopped]" mstat="å"
else
    mstat="$(mpc | sed -rn '2s/\[([[:alpha:]]+)].*/\1/p')"
    [ "$mstat" == "paused" ] && mstat="ç" || mstat="ê"
fi

# volume status
if [ "$(amixer get Master | sed -nr '$ s:.*\[(.+)]$:\1:p')" == "off" ]
then vstat="ë"
else
    vol="$(amixer get PCM | sed -nr '$ s:.*\[(.+%)].*:\1:p')"
    if [ "${vol%\%}" -le 20 ]; then vstat="ì"; else vstat="í"; fi
fi

# date and time
date="$(date +"%a %d/%m %R")" dstat="É"

# right status info
right="&9| &4$mstat &3$music &9| &4$vstat &3$vol &9| &4$dstat &3$date"

printf "&L%s&R%s\n" "$left&9[&2$l&9]" "$right"

