#!/bin/bash

case $1 in
  "up")
    pulseaudio-ctl up
    ;;
  "down")
    pulseaudio-ctl down
    ;;
  "mute")
    pulseaudio-ctl mute
    ;;
  *)
    echo "Usage: $0 up|down|mute"
    ;;
esac

duration=3

x=1530
y=20
w=150
h=20

amixer get Master | grep '\[off\]' && bar_bg="#ff1F1F1D" || \
bar_bg="#ff000000"

bar_fg="#ffffffff"

bar_font='-*-gohufont-medium-*-*--11-*-*-*-*-*-iso10646-1'

char='─'

get_volume=`amixer get Master | sed -n 's/^.*\[\([0-9]\+\)%.*$/\1/p'| uniq`
simple_volume=$(($get_volume/5))
volume=''

if [[ $simple_volume -lt 6 ]]; then
  bar_fg="#ff287BB2"
elif [[ $simple_volume -gt 14 ]]; then
  bar_fg="#ff9C1717"
elif [[ $simple_volume -gt 9 ]]; then
  bar_fg="#ffE15500"
fi

#echo $simple_volume
for i in `seq 1 $simple_volume`
do
  volume+=$char
done

barcmd="-d -g ${w}x${h}+${x}+${y} -B${bar_bg} -F${bar_fg} -f ${bar_font}"
(echo " $volume"; sleep ${duration}) | bar ${barcmd}
