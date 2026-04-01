#!/usr/bin/env bash 

# Dependency checks
command -v powerprofilesctl >/dev/null 2>&1 || { echo "powerprofilesctl not found"; exit 1; }
command -v rofi >/dev/null 2>&1 || { echo "rofi not found"; exit 1; }

ROFI_ARGS=(-dmenu -i -p "Change profile: " -markup-rows -no-search)

# Menu entries
cancel=" \tCancel"
perf=" \tPerformance"
balanced=" \tBalanced"
powersave=" \tPower Saver"

igpu="󰍹 \tiGPU"
dgpu="󰢮 \tdGPU"
vfio=" \tVfio"
hybrid="󰍺 \tHybrid"

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

if command -v supergfxctl >/dev/null 2>&1; then 
    chosen="$(echo -e "$options" | rofi "${ROFI_ARGS[@]}")"
    submenu="${chosen%% *}"
else 
    submenu="Power"
fi

case $submenu in 
    "GPU")
        submenu_options="$cancel"

        if supergfxctl --get | grep -q "Integrated"; then
            submenu_options="$submenu_options\n$igpu"
        fi
        if supergfxctl --get | grep -q "Hybrid"; then
            submenu_options="$submenu_options\n$hybrid"
        fi
        if supergfxctl --get | grep -q "AsusMuxDgpu"; then
            submenu_options="$submenu_options\n$dgpu"
        fi
        if supergfxctl --get | grep -q "vfio"; then
            submenu_options="$submenu_options\n$vfio"
        fi

        chosen="$(echo -e "$submenu_options" | rofi "${ROFI_ARGS[@]}")"
        case $chosen in
            "$igpu")
                supergfxctl -m Integrated 
                ;;
            "$hybrid")
                supergfxctl -m Hybrid
                ;;
            "$dgpu")
                supergfxctl -m AsusMuxDgpu
                ;;
            "$vfio")
                supergfxctl -m vfio
                ;;
            *)
                exit 0
                ;;
        esac 

        ;;

    "Power")
        submenu_options="$cancel"
        if  powerprofilesctl list | grep -q "performance"; then 
            submenu_options="$submenu_options\n$perf"
        fi
        if  powerprofilesctl list | grep -q "balanced"; then
            submenu_options="$submenu_options\n$balanced"
        fi
        if  powerprofilesctl list | grep -q "power-saver"; then
            submenu_options="$submenu_options\n$powersave"
        fi
        chosen="$(echo -e "$submenu_options" | rofi "${ROFI_ARGS[@]}")"
        case $chosen in
            "$perf")
                powerprofilesctl set performance 
                ;;
            "$balanced")
                powerprofilesctl set balanced
                ;;
            "$powersave")
                powerprofilesctl set power-saver
                ;;
            *)
                exit 0
                ;;
        esac 
        ;;
        
    *) 
        exit 0
        ;;
        
esac 

