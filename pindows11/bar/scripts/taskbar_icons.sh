#!/bin/bash

icon_loc="/home/$(whoami)/.config/eww/pindows11/assets/taskbaricons/"

bspc subscribe node_focus node_add node_remove desktop_focus | while read -r _; do

#workspace=""

#if [[ $(xrandr -q | grep "HDMI-1 connected") ]]; then
#  for index in {1..8}; do
#    if [[ $(bspc query -D -d "^${index}.focused") ]]; then
#      workspace="${index}"
#    fi
#  done
#else
#  for index in {1..5}; do
#    if [[ $(bspc query -D -d "^${index}.focused") ]]; then
#      workspace="${index}"
#    fi
#  done
#fi

#workspace="$(($workspace-1))"
IFS=$'\n'
icon_number=0
output="(box :orientation \"h\" "
knownwindows="$(cat /home/catdealer/.config/eww/pindows11/assets/taskbaricons/knownwindows.txt)"
knownwindowused="false"

for line in  $(xprop -root -notype _NET_ACTIVE_WINDOW _NET_CLIENT_LIST | wmctrl -lx); do
	id=$(echo "$line" | head -c+10)
	windowclass="$(xprop -id $id -notype WM_CLASS | cut -d '"' -f2)"
	if [[ "$windowclass" != *"nemo"* ]] && [[ "$windowclass" != *"Navigator"* ]] && [[ "$windowclass" != *"gnome-text-editor"* ]]; then
		for window in $knownwindows; do 
			if [[ "$windowclass" == *"$window"* ]]; then
				#echo "already known."
				if [[ "$id" == "$(bspc query -N -n .focused | tr '[:upper:]' '[:lower:]')" ]]; then
					output="$output (taskbar_item :icon \"${icon_loc}${window}.png\" :id \"$id\" :class \"indicator-focused\" :name \"$windowclass\")"
				else
					output="$output (taskbar_item :icon \"${icon_loc}${window}.png\" :id \"$id\" :class \"indicator\" :name \"$windowclass\")"
				fi

				knownwindowused="true"
			fi
		done
		if [[ "$knownwindowused" == "false" ]]; then
			#echo "dumping!"
			xprop -id $id -notype 32c _NET_WM_ICON |
  			perl -0777 -pe '@_=/\d+/g;
    			printf "P7\nWIDTH %d\nHEIGHT %d\nDEPTH 4\nMAXVAL 255\nTUPLTYPE RGB_ALPHA\nENDHDR\n", splice@_,0,2;
    			$_=pack "N*", @_;
    			s/(.)(...)/$2$1/gs' > "${windowclass}.pam"
    			magick "${windowclass}.pam" "${windowclass}.png"
    			rm "${windowclass}.pam"
    			mv "${windowclass}.png" "$icon_loc"
			if [[ "$id" == "$(bspc query -N -n .focused | tr '[:upper:]' '[:lower:]')" ]]; then
				output="$output (taskbar_item :icon \"${icon_loc}${windowclass}.png\" :id \"$id\" :class \"indicator-focused\" :name \"$windowclass\")"
			else
				output="$output (taskbar_item :icon \"${icon_loc}${windowclass}.png\" :id \"$id\" :class \"indicator\" :name \"$windowclass\")"
			fi
    			printf "${windowclass}\n" >> "/home/catdealer/.config/eww/pindows11/assets/taskbaricons/knownwindows.txt"
    		else
			knownwindowused="false"
		fi
	fi
        icon_number=$(($icon_number+1))
done
output="${output})"
echo "$output"
sleep 0.3
done
