#!/usr/bin/env bash 

if ! command -v supergfxctl >/dev/null 2>&1; then
    exit 1
fi

options=($(supergfxctl -s 2>/dev/null | sed 's/[][]//g; s/,//g'))

options+=("Cancel")

choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "Select GPU mode:")

[[ -z "$choice" || "$choice" == "Cancel" ]] && exit 0

supergfxctl -m "$choice"
