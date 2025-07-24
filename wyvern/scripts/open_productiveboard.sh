#!/bin/bash

if [[ "$($(which eww) active-windows)" == *"productiveboard"* || "$($(which eww) active-windows)" == "" ]]; then

  if [[ "$($(which eww) active-windows)" == *"productiveboard"* ]]; then
    $(which eww) close productiveboard
  else
    killall eww

    eww_window_id=0
    
    $(which eww) daemon

    for eww_monitor in $(xrandr -q | grep " connected" | cut -d ' ' -f1); do
      $(which eww) bar --id "$eww_window_id" --screen $eww_monitor
      eww_window_id+=1
    done
    if [[ $(xrandr -q | grep "HDMI-1 connected") ]]; then
      $(which eww) open currentnotificationsbox --screen "HDMI-1" 
	else
      $(which eww) open currentnotificationsbox --screen "eDP-1"
    fi
    $(which eww) open keepopen
  fi
  $(which eww) update reveal_pb=false
else
  if [[ $(xrandr -q | grep "HDMI-1 connected") ]]; then
    $(which eww) open productiveboard --screen HDMI-1
  else
    $(which eww) open productiveboard --screen eDP-1
  fi
  
  sleep 0.3
  eww update reveal_pb=true
fi
