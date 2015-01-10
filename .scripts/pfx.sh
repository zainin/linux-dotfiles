#!/bin/bash
TMP='/media/storage-ext/tmp/'

urxvt --hold -e peerflix "$1" -v -r -f $TMP
