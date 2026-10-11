#!/usr/bin/env bash 

perf=" Performance"
balanced=" Balanced"
powersave=" Power saver"
quiet=" Quiet"
lowpower=" Low power"
custom=" Custom"


igpu="󰍹 Integrated"
smart=" Smart"
manual=" Manual"
hybrid="󰍺 Hybrid"

if command -v powerprofilesctl >/dev/null 2>&1; then
    power_mode=$(powerprofilesctl get)
    power_text=""
    case "$power_mode" in 
        "performance") 
            power_text="$perf";
            ;;
        "balanced")
            power_text="$balanced";
            ;;
        "power-saver") 
            power_text="$powersave";
            ;; 
        *)
            power_text="";
            ;;
    esac
else
    if command -v asusctl >/dev/null 2>&1; then
        power_mode=$(asusctl profile get | awk '/Active profile:/ {print $3}')
        power_text=""
        case "$power_mode" in 
            "Performance") 
                power_text="$perf";
                ;;
            "Balanced")
                power_text="$balanced";
                ;;
            "Quiet") 
                power_text="$quiet";
                ;;
            "LowPower") 
                power_text="$quiet";
                ;; 
            "Custom") 
                power_text="$custom";
                ;; 
            *)
                power_text="";
                ;;
        esac
    fi 
fi 

graphics_mode="Default"
gpu_status="N/A"
if command -v cardwire >/dev/null 2>&1; then  
    graphics_mode=$(cardwire get |  awk '/Current Mode:/ {print $3}')
    case "$graphics_mode" in
        "Hybrid")
            graphics_mode="$hybrid"
            ;;
        "Integrated")
            graphics_mode="$igpu"
            ;;
        "Smart")
            graphics_mode="$smart"
            ;;
        "Manual")
            graphics_mode="$manual"
            ;;
        *)
            graphics_mode=""
            ;;
    esac
    gpu=$(cat /proc/driver/nvidia/gpus/0000*/power |  awk '/Video Memory:/ {print $3}')

    if [ -n "$gpu" ]; then
        if [ "$gpu" = "Active" ]; then
            gpu_status="ON"
        fi
        if [ "$gpu" = "Off" ]; then 
            gpu_status="OFF"
        fi 
    fi
fi

echo "{\"text\": \"${power_text}\", \"tooltip\": \"Graphics mode:\t${graphics_mode}\nStatus:\t\t${gpu_status}\"}"
