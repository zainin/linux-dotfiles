#!/bin/bash

if [ -z $1 ]; then
  WINEPREFIX=~/.wine_dota2/ wine explorer /desktop=DOTA2,1680x1014 "C:\Program Files (x86)\Steam\Steam.exe" -applaunch 570 -gl -novid -net_graph 1 -net_graphproportionalfont 0 -net_graphinsetbottom -38 -net_graphinsetright -170 -w 1680 -h 1014 -console
elif [ "$1" = "laptop" ]; then
  WINEPREFIX=~/.wine_dota2/ wine explorer /desktop=DOTA2,1366x768 "C:\Program Files (x86)\Steam\Steam.exe" -applaunch 570 -gl -novid -net_graph 1 -net_graphproportionalfont 0 -net_graphinsetbottom -38 -net_graphinsetright -170 -w 1366 -h 731
else
  echo 'wut'
fi
