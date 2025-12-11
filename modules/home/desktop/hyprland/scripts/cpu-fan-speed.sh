#!/usr/bin/env bash
cpu=$(sensors | awk '/cpu_fan:/ {print $2 $3}')

output=""

if [ -n "$cpu" ]; then
    output="$cpu 󱑲 "
fi

echo "$output"
