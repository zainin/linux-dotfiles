#!/bin/bash
#
# volume - dzen volume bar
# original at: http://dotshare.it/dots/5/
#

#Customize this stuff
IF="Master"         # audio channel: Master|PCM
TIMEOUT="1.5s"      # sleep $TIMEOUT
BG="#080808"        # background colour of window
FG="#eeeeee"        # foreground colour of text/icon
BAR_FG="#CC474B"    # foreground colour of volume bar
BAR_BG="#ffffff"    # background colour of volume bar
HEIGHT="30"         # window height
WIDTH="250"         # window width
BAR_WIDTH="180"     # width of volume bar
XPOS="$(($(xrandr -q | grep DVI-I-2 | awk '{print $4}' | cut -d 'x' -f1) - $WIDTH))" # positioned at right edge
YPOS="20"          # vertical positioning

#Probably do not customize
PIPE="/tmp/dvolpipe"

err() {
  echo "$1"
  exit 1
}

usage() {
  echo "usage: $0 [-i PERCENT] [-d PERCENT] [-t]"
  echo
  echo "Options:"
  echo -e "   -i\t\tIncrease volume by PERCENT"
  echo -e "   -d\t\tDecrease volume by PERCENT"
  echo -e "   -t\t\tToggle volume on/off"
  echo -e "   -h, --help\tdisplay this help"
  exit
}

#Argument Parsing
case "$1" in
  '-i')
    [ -z "$2" ] && err "No argument specified for increase."
    [ -n "$(tr -d [0-9] <<<$2)" ] && err "The argument needs to be an integer."
    AMIXARG="${2}%+"
    ;;
  '-d')
    [ -z "$2" ] && err "No argument specified for decrease."
    [ -n "$(tr -d [0-9] <<<$2)" ] && err "The argument needs to be an integer."
    AMIXARG="${2}%-"
    ;;
  '-t')
    AMIXARG="toggle"
    ;;
  ''|'-h'|'--help')
    usage
    ;;
  *)
    err "Unrecognized option '$1'"
    ;;
esac

#Actual volume changing (readability low)
AMIXOUT="$(amixer set "$IF" "$AMIXARG" | tail -n 1)"
VOL="$(cut -d '[' -f 2 <<<"$AMIXOUT" | sed 's/%.*//g')"

#If volume is muted change bar color to grey
amixer | grep off -q && BAR_FG="#808080"

#Using named pipe to determine whether previous call still exists
#Also prevents multiple volume bar instances
if [ ! -e "$PIPE" ]; then
  mkfifo "$PIPE"
  (dzen2 -tw "$WIDTH" -h "$HEIGHT" -x "$XPOS" -y "$YPOS" -bg "$BG" -fg "$FG" < "$PIPE"
   rm -f "$PIPE") &
fi

#Feed the pipe!
(echo "$VOL" | gdbar -fg "$BAR_FG" -bg "$BAR_BG" -w "$BAR_WIDTH" ; sleep "$TIMEOUT") > "$PIPE"
