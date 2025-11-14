#!/usr/bin/env bash 
STATE_FILE="/tmp/caffeina_enabled"

if [ -f "$STATE_FILE" ]; then
    hyprctl dispatch hypridle on
    rm "$STATE_FILE"
else
    hyprctl dispatch hypridle off
    touch "$STATE_FILE"
fi

# Aggiorna Waybar
pkill -SIGRTMIN+1 waybar
