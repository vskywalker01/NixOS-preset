#!/run/current-system/sw/bin/bash

## Load VM variables
source "/var/lib/libvirt/hooks/qemu.d/win11/vm-vars.conf"

## Return CPU cores as per set variable
systemctl set-property --runtime -- user.slice AllowedCPUs=$SYS_TOTAL_CPUS
systemctl set-property --runtime -- system.slice AllowedCPUs=$SYS_TOTAL_CPUS
systemctl set-property --runtime -- init.scope AllowedCPUs=$SYS_TOTAL_CPUS

sleep 1
