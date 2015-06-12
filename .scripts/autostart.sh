#!/bin/bash

autorun=(
  "feh --no-xinerama --bg-scale /home/zainin/Images/wallpapers/wallpaper"
  "keepassx"
  "setxkbmap pl"
  "solaar"
  "pasystray"
  "compton --vsync opengl"
)

laptop=(
  "setxkbmap pl"
  "nm-applet"
)

pc=(
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
