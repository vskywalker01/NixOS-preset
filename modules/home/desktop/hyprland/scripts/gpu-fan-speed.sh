#!/usr/bin/env bash
gpu=$(sensors | awk '/gpu_fan:/ {print $2 $3}')

output=""

if [ -n "$gpu" ]; then
    output="󱑲 $gpu"
fi

echo "$output"
