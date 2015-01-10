#!/bin/bash
echo 1 > /proc/sys/net/ipv4/ip_forward
rc.d start iptables dnsmasq
ipconfig eth0 192.168.0.1 up
