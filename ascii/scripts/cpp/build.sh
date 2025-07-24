#!/bin/bash

function build_test()
{
	g++ -o ./sslim.out ./sslim.cpp ./class_pri.hpp ./class_pub.hpp && compiled=true
	if [[ "$1" == "--run" ]] && [[ "$complied" == "true" ]]; then
		./sslim.out $2
	fi
}

function build_fin()
{
	killall eww
	g++ -o ../sslim ./sslim.cpp ./class_pri.hpp ./class_pub.hpp && compiled=true
	if [[ "$1" == "--run" ]] && [[ "$complied" == "true" ]]; then
		../sslim $2
	fi
	
	eww_window_id=1

	for eww_monitor in $(xrandr -q | grep " connected" | cut -d ' ' -f1); do
		$(which eww) open bar --id "$eww_window_id" --screen $eww_monitor
		eww_window_id+=1
	done

	if [[ "$(xrandr -q | grep 'HDMI-1 connected')" != "" ]]; then
		$(which eww) open currentnotificationsbox --screen 1
	else
		$(which eww) open currentnotificationsbox --screen 0
	fi

	$(which eww) open keepopen
}

case $1 in
release) build_fin $2 $3 ;;
debug) build_test $2 $3 ;;
esac
