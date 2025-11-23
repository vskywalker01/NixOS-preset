#!/usr/bin/env bash 
grim -g "$(slurp -c#ffffffcc  -b 00000080 -w 2)" - | wl-copy
