#!/usr/bin/env bash 

WALLPAPER_DIR="$HOME/.local/share/wallpapers"

if ! pgrep -s swww >/dev/null; then
    swww-daemon 
    sleep 1
fi 

while true; do
    IMG=$(find "$WALLPAPER_DIR" -type -f | shuf -n 1)
    swww img "$IMG" --transition-type fade --transition-duration 2
    sleep 3600
done 
