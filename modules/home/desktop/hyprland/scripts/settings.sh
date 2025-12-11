#!/usr/bin/env bash

options=()
options+=("Audio")
options+=("Displays")
options+=("Wallpaper")
options+=("Printers")

if command -v otd >/dev/null 2>&1; then
    options+=("Graphics tablet")
fi

choice=$(printf "%s\n" "${options[@]}" | rofi -dmenu -p "Settings")

case "$choice" in
    "Audio") 
        pavucontrol &
        ;;
    "Displays")
        nwg-displays &
        ;;
    "Wallpaper")
        waypaper &
        ;;
    "Printers") 
        system-config-printer &  
        ;;
    "Graphics tablet")
        otd-gui &
        ;;
    *)
        exit 0
        ;;
esac

