#!/bin/bash

custom

while getopts "p" option
do
	case $option in
	p) set

function set {
	`amixer -D equal -q set '01. 31 Hz' $1`
	`amixer -D equal -q set '02. 63 Hz' $2`
	`amixer -D equal -q set '03. 125 Hz' $3`
	`amixer -D equal -q set '04. 250 hZ' $4`
	`amixer -D equal -q set '05. 500 Hz' $5`
	`amixer -D equal -q set '06. 1 kHz' $6`
	`amixer -D equal -q set '07. 2 kHz' $7`
	`amixer -D equal -q set '08. 4 kHz' $8`
	`amixer -D equal -q set '09. 8 kHz' $9`
	`amixer -D equal -q set '10. 16 kHz' $10`
}
