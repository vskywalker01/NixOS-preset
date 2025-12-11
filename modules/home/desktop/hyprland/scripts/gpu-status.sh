#!/usr/bin/env bash

gpu=$(cat /proc/driver/nvidia/gpus/0000*/power |  awk '/Video Memory:/ {print $3}')

output=""

if [ -n "$gpu" ]; then
    if [ "$gpu" = "Active" ]; then
        output="󰢮 ON"
    fi
    if [ "$gpu" = "Off" ]; then 
        output="󰢮 OFF"
    fi 
fi

echo "$output"
