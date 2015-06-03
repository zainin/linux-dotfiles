#!/bin/bash

autorun=(
  "feh --no-xinerama --bg-scale /home/zainin/Images/wallpapers/wallpaper"
  "keepassx"
  "setxkbmap pl"
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
  "deluge"
  "nvidia-settings -l"
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
