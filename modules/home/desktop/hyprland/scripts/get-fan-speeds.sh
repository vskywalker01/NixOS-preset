#!/usr/bin/env bash
lines=$(sensors | awk '/fan/')
top_fan_value=""
tooltip=""

while IFS= read -r line; do 
    name=$(echo "$line" | awk '{print $1}')
    value=$(echo "$line" | awk '{print $2}')
    if [ -z "$top_fan_name" ]; then 
        top_fan_name="$name"
        top_fan_value="$value"
    else 
        if [ "$name" == "cpu_fan" ]; then 
            top_fan_name="$name"
            top_fan_value="$value"
        fi 
    fi
    if [ -n "$tooltip" ]; then
        tooltip+="\n"
    fi 
    tooltip+="${name}\t${value} RPM"
done <<< "$lines"

echo  "{\"text\": \"󰈐 ${top_fan_value} RPM\", \"tooltip\":\"${tooltip}\"}"
