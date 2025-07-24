#!/bin/bash

hours=$1
minutes=$2
seconds=$3
message="${4:-Time is up!}"

cache_dir="$HOME/.cache/eww/alarms"
alarm_file="${cache_dir}/current.alarm"

mkdir -p "$cache_dir"

hours_to_sec=$((hours*60*60))
mins_to_sec=$((minutes*60))
total_secs=$((hours_to_sec+mins_to_sec+seconds))

if [[ "$total_secs" -lt "600" ]]; then
  sleep_interval=1
else
  sleep_interval=4
fi


notify-send -t 0 -a Alarm "Alarm" "Will ring at $(date -d "${total_secs}sec" +%I:%M)"

secs_left=$total_secs
current_secs="$(date +%s)"
deadline_timestamp=$((current_secs + total_secs))

echo "$secs_left" > $alarm_file

while [[ "$(date +%s)" -lt "$deadline_timestamp" ]]; do
  sleep "$sleep_interval"
  if [[ ! -f "$alarm_file" ]]; then
    notify-send -a Alarm "Alarm" "Alarm stopped"
    exit 0
  fi
  now="$(date +%s)"
  secs_left=$((deadline_timestamp - now))
  echo $secs_left > $alarm_file
done

notify-send -t 0 -a Alarm "Alarm" "$message"

rm "$alarm_file"
