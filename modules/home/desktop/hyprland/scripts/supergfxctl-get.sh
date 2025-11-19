#!/usr/bin/env bash 

graphics_mode=$(supergfxctl -g 2>/dev/null)
case "$graphics_mode" in
    "Hybrid")
        graphics="󰈐 Hybrid"
        ;;
    "Integrated")
        graphics="󰢮 iGPU"
        ;;
    "Dedicated")
        graphics="󰢹 dGPU"
        ;;
    *)
        graphics=""
        ;;
esac

echo "{\"text\": \"${graphics}\", \"tooltip\": \"Graphics mode: ${graphics}\"}"
