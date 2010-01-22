#!/bin/bash

if ifconfig | grep -q wlan0 ; then
  essid=`iwconfig wlan0 | awk -F '"' '/ESSID/ {print $2}'`
  stngth=`iwconfig wlan0 | awk -F '=' '/Quality/ {print $2}' | cut -d '/' -f 1`
  bars=`expr $stngth / 10`

  case $bars in
    0)  bar='[----------]' ;;
    1)  bar='[/---------]' ;;
    2)  bar='[//--------]' ;;
    3)  bar='[///-------]' ;;
    4)  bar='[////------]' ;;
    5)  bar='[/////-----]' ;;
    6)  bar='[//////----]' ;;
    7)  bar='[///////---]' ;;
    8)  bar='[////////--]' ;;
    9)  bar='[/////////-]' ;;
    10) bar='[//////////]' ;;
    *)  bar='[----!!----]' ;;
  esac

  echo ${essid:-none} $bar
elif ifconfig | grep -q eth0 ; then
  echo wired
else
  echo none
fi
