#!/usr/bin/env bash 

perf=" Performance"
balanced=" Balanced"
powersave=" Power Saver"

igpu="󰍹 iGPU"
dgpu="󰢮 dGPU"
vfio=" Vfio"
hybrid="󰍺 Hybrid"

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

graphics_mode="Default"
gpu_status="N/A"
if command -v supergfxctl >/dev/null 2>&1; then  
    graphics_mode=$(supergfxctl -g 2>/dev/null)
    case "$graphics_mode" in
        "Hybrid")
            graphics_mode="󰍺 Hybrid"
            ;;
        "Integrated")
            graphics_mode="󰍹 iGPU"
            ;;
        "Dedicated")
            graphics_mode="󰢮 dGPU"
            ;;
        "Vfio")
            graphics_mode=" Vfio"
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
