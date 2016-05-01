#!/bin/bash

autorun=(
  "feh --bg-fill /home/zainin/Images/wallpapers/wallpaper"
  "keepassx"
  "setxkbmap pl"
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

grep -q 4690 /proc/cpuinfo && \
  #PC
  autorun=("${autorun[@]}" "${pc[@]}") || \
  #laptop
  autorun=("${autorun[@]}" "${laptop[@]}")

run_once() {
    pgrep -u $USER -f $(cut -f1 -d " " <<<"$1") &> /dev/null || $1&
}

for i in "${autorun[@]}"
do
  run_once "$i"
done
