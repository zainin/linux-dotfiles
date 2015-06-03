#!/bin/bash
maim -m on --hidecursor /tmp/screen.png
convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png
lockimg="/media/storage-ext/Images/lock.png"
[[ -f $lockimg ]] && convert /tmp/screen.png $lockimg -gravity center -composite -matte /tmp/screen.png

i3lock -e -t -u -n -i /tmp/screen.png
