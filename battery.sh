#!/bin/sh

rembat=`acpi | grep -o "[0-9]*%" | sed s/%//`
state=`acpi | awk '{print $3}' | cut -d ',' -f 1 | tr 'A-Z' 'a-z'`
bars=`expr $rembat / 10`

case $bars in
  0)  bar='[----------]!' ;;
  1)  bar='[/---------]'  ;;
  2)  bar='[//--------]'  ;;
  3)  bar='[///-------]'  ;;
  4)  bar='[////------]'  ;;
  5)  bar='[/////-----]'  ;;
  6)  bar='[//////----]'  ;;
  7)  bar='[///////---]'  ;;
  8)  bar='[////////--]'  ;;
  9)  bar='[/////////-]'  ;;
  10) bar='[//////////]'  ;;
  *)  bar='[----!!----]'  ;;
esac

echo $state $bar
