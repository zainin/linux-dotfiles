#!/bin/bash

autorun=(
  "urxvtd"
  "keepassx"
  "setxkbmap pl"
  "feh --bg-fill /home/zainin/Images/wallpapers/windy.png"
  "solaar"
  "pasystray"
  "xrdb /home/zainin/cmr"
  "devmon"
)

laptop=(
  "xcompmgr"
  "connman-ui-gtk"
)

pc=(
  "compton --backend glx --paint-on-overlay --vsync opengl-swc"
  "start-pulseaudio-x11"
)

grep -q Q9550 /proc/cpuinfo && \
  #PC
  autorun=("${autorun[@]}" "${pc[@]}") || \
  #laptop
  autorun=("${autorun[@]}" "${laptop[@]}")

run_once() {
  pgrep -u $USER -x ${1% *} &> /dev/null || $1&
}

for i in "${autorun[@]}"
do
  run_once "$i"
done
