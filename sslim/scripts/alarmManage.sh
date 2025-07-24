#!/bin/bash

# Manage running alarms and convert times

cache_dir="$HOME/.cache/eww/alarms"
alarm_file="${cache_dir}/current.alarm"

mkdir -p "$cache_dir"

function converttimes {

file_check=$(cat $alarm_file; echo $?)
if [[ $(echo "$file_check" | tail -1) == "1" ]]; then
  echo "Failed."
  exit 1
fi

seconds=$(cat $alarm_file)

minutes=0
hours=0

while [[ "$seconds" -ge "3600" ]]; do
  hours=$((hours+1))
  seconds=$((seconds-3600))
done
while [[ "$seconds" -ge "60" ]]; do
  minutes=$((minutes+1))
  seconds=$((seconds-60))
done

case $1 in
h) echo $hours ;;
m) echo $minutes ;;
s) echo $seconds ;;
esac
}

function stopalarm {
  rm "$alarm_file"
}

case $1 in
--convert) converttimes $2 ;;
--stop) stopalarm ;;
esac
