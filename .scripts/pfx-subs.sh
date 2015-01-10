#!/bin/bash

subliminal -l en -- "$1"
subs=`echo "$1" | sed s/\.mkv/\.en\.srt/g`

mpv http://localhost:8888 --sub-file="$subs"
