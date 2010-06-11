#!/bin/bash

WIRELESS_INTERFACE="wlan0"
ESSID="OTERNET_6398"
MAC="00:15:56:b6:0d:61"
LAN_IP="192.168.2.4"
ROUTER_IP="192.168.2.1"

ifconfig $WIRELESS_INTERFACE down
ifconfig  up
iwconfig $WIRELESS_INTERFACE essid $ESSID
iwconfig $WIRELESS_INTERFACE ap $MAC
ifconfig $WIRELESS_INTERFACE $LAN_IP netmask 255.255.255.0 up
route add default gw $ROUTER_IP 
echo -e "nameserver $ROUTER_IP" > /etc/resolv.conf
