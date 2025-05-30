#!/run/current-system/sw/bin/bash

## Load VM variables
source "/var/lib/libvirt/hooks/qemu.d/win11/vm-vars.conf"

## Kill Looking Glass
echo "Killing Looking Glass..."
killall looking-glass-client

sleep 1
