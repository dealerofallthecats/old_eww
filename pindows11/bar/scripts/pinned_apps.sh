#!/bin/bash

get-id() {
	if [[ "$1" == "nemo" ]] || [[ "$1" == "gnome-text-editor" ]]; then
		id=$(wmctrl -lx | grep $1 | tail -1 | head -c+10)
	else
		id=$(wmctrl -lx | grep $1 | head -1 | head -c+10)
	fi
	class=$(xprop -id ${id} -notype WM_CLASS)
	if [[ "$class" == *"$1"* ]]; then
		echo "$id"
	else
		echo "0"
	fi
}

get-class() {
	id=$(get-id $1)
	focusedid=$(bspc query -N -n .focused | tr '[:upper:]' '[:lower:]')
	if [[ "$id" == "$focusedid" ]]; then
		echo "indicator-focused"
	elif [[ "$id" != "$focusedid" ]] && [[ "$id" != "0" ]]; then
		echo "indicator"
	else
		echo "indicator-off"
	fi
}

open_or_focus () {
	echo $1
	echo $2
	echo $3
	if [[ "$1" == "gnome-text-editor" ]]; then
		if [[ "$(pgrep -f $1)" == "" ]]; then
			wmctrl -ia $3 &
		else
			gnome-text-editor &
		fi
	else
		grep=$(pidof $1) 
		echo $grep
		if [ $? -eq 0 ]; then
			wmctrl -ia "$3" &
		elif [ $? -eq 1 ]; then
			$2 &
		fi
	fi
}

case $1 in
	--zen-id) get-id zen;;
	--zen-class) get-class zen;;
	--nemo-id) get-id nemo ;;
	--nemo-class) get-class nemo;;
	--text-id) get-id gnome-text-editor ;;
	--text-class) get-class gnome-text-editor;;
	--open_or_focus) open_or_focus $2 $3 $4;;
esac
