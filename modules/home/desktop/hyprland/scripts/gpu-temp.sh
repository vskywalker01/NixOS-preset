#!/usr/bin/env bash

if ! command -v nvidia-smi >/dev/null 2>&1; then
    echo "{\"text\": \"\", \"tooltip\": \"GPU Temperature: Not detected\"}"
    exit 0
fi

gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1)

if [[ -z "$gpu_usage" || "$gpu_usage" -eq 0 ]]; then
    echo "{\"text\": \"󰢮 N/A\", \"tooltip\": \"GPU Temperature: Inactive\"}"
    exit 0
fi

temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1)

if [[ -z "$temp" ]]; then
    echo "{\"text\": \"󰢮 N/A\", \"tooltip\": \"GPU Temperature: Cannot read temperature\"}"
    exit 0
fi

# Output JSON per Waybar
echo "{\"text\": \"󰢮 ${temp}°C\", \"tooltip\": \"GPU Temperature: ${temp}°C\"}"
