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


# Get current condition
get_cond() {
  if [[ "$(is_online)" == "limited" ]] || [[ "$(is_online)" == "full" ]]; then
    raw_cond=$(curl -s wttr.in/$location\?format=%C)
    printf "%s\n" "$raw_cond"
    printf "%s" "$raw_cond" >"${CACHE_FILE_COND}"
  else
    cat "$CACHE_FILE_COND"
  fi
}

# Get current condition's icon
get_icon() {
  if [[ "$(is_online)" == "limited" ]] || [[ "$(is_online)" == "full" ]]; then
    raw_icon=$(curl -s wttr.in/$location\?format=%c | tr -d ' ')
    printf "%s\n" "$raw_icon"
    printf "%s" "$raw_icon" >"${CACHE_FILE_ICON}"
  else
    cat "$CACHE_FILE_ICON"
  fi
}

# Get current temperature
get_temp() {
  if [[ "$(is_online)" == "limited" ]] || [[ "$(is_online)" == "full" ]]; then
    raw_temp=$(curl -s wttr.in/$location\?format=%t | tr -d '+')
    printf "%s\n" "$raw_temp"
    printf "%s" "$raw_temp" >"${CACHE_FILE_TEMP}"
  else
    cat "$CACHE_FILE_TEMP"
  fi
}

case $2 in
--temp) get_temp ;;
--cond) get_cond ;;
--icon) get_icon ;;
esac
