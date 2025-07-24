#!/bin/bash

# Main variables
location="$1"
CACHE_FILE_COND="$HOME/.cache/$(whoami)/weather_eww_cache/cond"
CACHE_FILE_TEMP="$HOME/.cache/$(whoami)/weather_eww_cache/temp"
CACHE_FILE_ICON="$HOME/.cache/$(whoami)/weather_eww_cache/icon"

mkdir -p "$(dirname "$CACHE_FILE_COND")"

# Check wifi
is_online() {
  nmcli networking connectivity
}

get_cache_data() {
  if [[ "$1" == "cond" ]]; then
    cat "$CACHE_FILE_COND"
  elif [[ "$1" == "temp" ]]; then
    cat "$CACHE_FILE_TEMP"
  elif [[ "$1" == "icon" ]]; then
    cat "$CACHE_FILE_ICON"
  else
    echo ""
  fi
}

# Get current condition
get_cond() {
  if [[ "$(is_online)" == "limited" ]] || [[ "$(is_online)" == "full" ]]; then
    raw_cond=$(curl -s wttr.in/$location\?format=%C)
    printf "%s\n" "$raw_cond"
    printf "%s\n" "$raw_cond" >"${CACHE_FILE_COND}"
  else
    get_cache_data cond
  fi
}

# Get current condition's icon
get_icon() {
  if [[ "$(is_online)" == "limited" ]] || [[ "$(is_online)" == "full" ]]; then
    raw_icon=$(curl -s wttr.in/$location\?format=%c | tr -d ' ')
    printf "%s\n" "$raw_icon"
    printf "%s\n" "$raw_icon" >"${CACHE_FILE_ICON}"
  else
    get_cache_data icon
  fi
}

# Get current temperature
get_temp() {
  if [[ "$(is_online)" == "limited" ]] || [[ "$(is_online)" == "full" ]]; then
    raw_temp=$(curl -s wttr.in/$location\?format=%t | tr -d '+')
    printf "%s\n" "$raw_temp"
    printf "%s\n" "$raw_temp" >"${CACHE_FILE_TEMP}"
  else
    get_cache_data temp
  fi
}

case $2 in
--temp) get_temp ;;
--cond) get_cond ;;
--icon) get_icon ;;
esac
