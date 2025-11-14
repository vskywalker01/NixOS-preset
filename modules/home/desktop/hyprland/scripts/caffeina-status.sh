#!/usr/bin/env bash 

if [ -f /tmp/hypridle_disabled ]; then
    ICON="enabled"
else
    ICON="disabled"
fi

echo "{\"icon\": \"$ICON\"}"
