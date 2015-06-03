#!/bin/bash

duration=3

#x=1530
#x=$(($(xdpyinfo | grep dimensions | awk '{print $2}' | cut -d 'x' -f1) - 150))
w=300
x=$(($(xrandr -q | grep DVI-I-2 | awk '{print $4}' | cut -d 'x' -f1) - $w))
y=20
h=20

bar_bg="#ff000000"

bar_fg="#ffffffff"

#bar_font='-*-gohufont-medium-*-*--11-*-*-*-*-*-iso10646-1'
bar_font="DejaVu Sans-5"

barcmd="-d -g ${w}x${h}+${x}+${y} -B${bar_bg} -F${bar_fg} -f \"DejaVu Sans-5\""
#(echo "%{c}"$(mpc | head -1); sleep ${duration}) | bar ${barcmd}
not=$(mpc | head -1)
notify-send "$not"
