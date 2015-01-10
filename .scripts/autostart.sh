#!/bin/bash

autorun=(
  "urxvtd"
  "keepassx"
  "setxkbmap pl"
  "feh --bg-tile /home/zainin/Images/wallpapers/thingy-pattern.png"
  "solaar"
  "pasystray"
)

laptop=(
  "xcompmgr"
  "connman-ui-gtk"
)

pc=(
  "compton --vsync opengl"
  "start-pulseaudio-x11"
  "nm-applet"
  "deluge"
)

grep -q Q9550 /proc/cpuinfo && \
  #PC
  autorun=("${autorun[@]}" "${pc[@]}") || \
  #laptop
  autorun=("${autorun[@]}" "${laptop[@]}")

run_once() {
  pgrep -u $USER -f ${1% *} &> /dev/null || $1&
}

for i in "${autorun[@]}"
do
  run_once "$i"
done
