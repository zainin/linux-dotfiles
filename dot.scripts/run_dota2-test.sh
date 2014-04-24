#!/bin/bash

if [ -z $1 ]; then
  echo 'no laptop'
elif [ "$1" = "laptop" ]; then
  echo 'laptop'
else
  echo 'wut'
fi

#WINEPREFIX=~/.wine_dota2/ wine explorer /desktop=DOTA2,1680x1014 "C:\Program Files (x86)\Steam\Steam.exe" -applaunch 570 -gl -novid -net_graph 1 -net_graphproportionalfont 0 -net_graphinsetbottom -38 -net_graphinsetright -170
