#!/bin/bash

if [[ "$(~/eww-source/target/release/eww active-windows)" == *"dashboard"* || "$(/home/catdealer/eww-source/target/release/eww active-windows)" == "" ]]; then

  if [[ "$(~/eww-source/target/release/eww active-windows)" == *""* ]]; then
    killall eww

    eww_window_id=0

    for eww_monitor in $(xrandr -q | grep " connected" | cut -d ' ' -f1); do
      ~/eww-source/target/release/eww -c ~/.config/eww/ open --toggle bar_top --id "$eww_window_id" --screen $eww_monitor &
      disown
      eww_window_id+=1
    done
    for eww_monitor in $(xrandr -q | grep " connected" | cut -d ' ' -f1); do
      ~/eww-source/target/release/eww -c ~/.config/eww/ open --toggle fakecornerstop --id "$eww_window_id" --screen $eww_monitor &
      disown
      eww_window_id+=1
    done
  else
    ~/eww-source/target/release/eww close dashboard
  fi
else
  if [[ $(xrandr -q | grep "HDMI-1 connected") ]]; then
    ~/eww-source/target/release/eww open dashboard --screen HDMI-1
  else
    ~/eww-source/target/release/eww open dashboard --screen eDP-1
  fi
fi
