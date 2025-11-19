#!/usr/bin/env bash

gpu=$(sensors | awk '/gpu_fan:/ {print $2 $3}')
cpu=$(sensors | awk '/cpu_fan:/ {print $2 $3}')

output=""

if [ -n "$cpu" ]; then
    output="󱑲 $cpu"
fi

if [ -n "$gpu" ]; then
    if [ -n "$output" ]; then
        output="$output "
    fi
    output="$output 󱑳 $gpu"
fi
echo "$output"
