#!/bin/bash

if [[ "$(~/eww-source/target/release/eww active-windows)" == *"dashboard"* ]]; then

  if [[ "$(~/eww-source/target/release/eww active-windows)" == *"dashboard"* ]]; then
    killall eww
    ~/eww-source/target/release/eww close dashboard
  else
    killall eww
  fi
  bspc config right_padding 15
else
  if [[ $(xrandr -q | grep "HDMI-1 connected") ]]; then
    ~/eww-source/target/release/eww open dashboard --screen HDMI-1
  else
    ~/eww-source/target/release/eww open dashboard --screen eDP-1
  fi
  bspc config right_padding 555
fi
