#!/usr/bin/env bash
OLLAMA="docker-open-webui"
options=()
options+=("Audio")
options+=("Displays")
options+=("Wallpaper")
options+=("Printers")

if command -v otd >/dev/null 2>&1; then
    options+=("Graphics tablet")
fi

if systemctl list-unit-files --type=service --no-pager | grep -q "$OLLAMA"; then 
    options+=("Open WebUI")
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
    "Open WebUI")
        service_choice=$(printf "Start\nStop\nOpen web interface\n" | rofi -dmenu -p "Open WebUI")
        case "$service_choice" in
            "Start")
                systemctl start $OLLAMA
                ;;
            "Stop")
                systemctl stop $OLLAMA
                ;;
            "Open web interface")
                xdg-open "http://localhost:8080"
                ;;
            *)
                exit 0
                ;;
        esac &
        ;;
    *)
        exit 0
        ;;
esac



