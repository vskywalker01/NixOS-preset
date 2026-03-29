#!/usr/bin/env bash 

# Dependency checks
command -v powerprofilesctl >/dev/null 2>&1 || { echo "powerprofilesctl not found"; exit 1; }
command -v rofi >/dev/null 2>&1 || { echo "rofi not found"; exit 1; }

ROFI_ARGS=(-dmenu -i -p "Current Power settings: " -markup-rows -no-search)

# Menu entries
cancel="  Cancel"
perf=" Performance"
balanced="  Balanced"
powersave=" Power Saver"

igpu="󰍹  iGPU"
dgpu="󰢮  dGPU"
vfio="  Vfio"
hybrid="󰍺  Hybrid"

ppd_perf="Power profile\t\t$perf"
ppd_bal="Power profile\t\t$balanced"
ppd_ps="Power profile\t\t$powersave"

sfg_igpu="GPU profile\t\t$igpu"
sfg_hybrid="GPU profile\t\t$hybrid"
sfg_vfio="GPU profile\t\t$vfio"
sfg_dgpu="GPU profile\t\t$dgpu"
# sets chancel to be on top
options="$cancel"

if powerprofilesctl get | grep -q "performance"; then
    options="$options\n$ppd_perf"
fi
if powerprofilesctl get | grep -q "balanced"; then
    options="$options\n$ppd_bal"
fi
if powerprofilesctl get | grep -q "power-saver"; then
    options="$options\n$ppd_ps"
fi
if command -v supergfxctl >/dev/null 2>&1; then  
    if supergfxctl --get | grep -q "Integrated"; then
        options="$options\n$sfg_igpu"
    fi
    if supergfxctl --get | grep -q "Hybrid"; then
        options="$options\n$sfg_hybrid"
    fi
    if supergfxctl --get | grep -q "AsusMuxDgpu"; then
        options="$options\n$sfg_dgpu"
    fi
    if supergfxctl --get | grep -q "vfio"; then
        options="$options\n$sfg_vfio"
    fi
fi 


chosen="$(echo -e "$options" | rofi "${ROFI_ARGS[@]}")"
case $chosen in 
    "GPU")
        echo "gpu"
        ;;

    "Power")
        echo = "power"
        ;;
    *) 
        exit 0
        ;;
        
esac 

