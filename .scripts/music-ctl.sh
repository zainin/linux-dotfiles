#!/bin/sh
# Music Control
# ncmpcpp/Spotify

case $1 in
  "play")
    key="XF86AudioPlay"
    cmd="toggle"
    ;;
  "stop")
    key="XF86AudioStop"
    cmd="stop"
    ;;
  "next")
    key="XF86AudioNext"
    cmd="next"
    ;;
  "prev")
    key="XF86AudioPrev"
    cmd="prev"
    ;;
  *)
    echo "Usage: $0 play|stop|next|prev"
    exit 1
    ;;
esac

xdotool key --window $(xdotool search --name "Spotify Free"|head -n1) $key &&\
 exit 0

nmcpcpp $cmd

exit 0
