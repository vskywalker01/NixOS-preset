#!/usr/bin/env bash 

# Dependency checks
#command -v powerprofilesctl >/dev/null 2>&1 || { echo "powerprofilesctl not found"; exit 1; }
command -v rofi >/dev/null 2>&1 || { echo "rofi not found"; exit 1; }

ROFI_ARGS=(-dmenu -i -p "Change profile: " -markup-rows -no-search)

# Menu entries
cancel="   Cancel"
perf="   Performance"
balanced="   Balanced"
powersave="   Power Saver"
quiet="  Quiet"
lowpower="   Low power"
custom="   Custom"

igpu="󰍹   Integrated"
smart="   Smart"
manual="   Manual"
hybrid="󰍺   Hybrid"

pp_perf="Power profile\t\t$perf"
pp_bal="Power profile\t\t$balanced"
pp_ps="Power profile\t\t$powersave"
pp_qt="Power profile\t\t$quiet"
pp_lp="Power profile\t\t$lowpower"
pp_cs="Power profile\t\t$custom"


cw_igpu="GPU profile\t\t$igpu"
cw_hybrid="GPU profile\t\t$hybrid"
cw_smart="GPU profile\t\t$smart"
cw_manual="GPU profile\t\t$manual"

# sets chancel to be on top
options="$cancel"

if command -v powerprofilesctl >/dev/null 2>&1; then
    if powerprofilesctl get | grep -q "performance"; then
        options="$options\n$pp_perf"
    fi
    if powerprofilesctl get | grep -q "balanced"; then
        options="$options\n$pp_bal"
    fi
    if powerprofilesctl get | grep -q "power-saver"; then
        options="$options\n$pp_ps"
    fi
else 
    if command -v asusctl >/dev/null 2>&1; then  
        if asusctl profile get |  awk '/Active profile:/ {print $3}' | grep -q "Performance"; then
            options="$options\n$pp_perf"
        fi
        if asusctl profile get |  awk '/Active profile:/ {print $3}' | grep -q "Balanced"; then
            options="$options\n$pp_bal"
        fi
        if asusctl profile get |  awk '/Active profile:/ {print $3}' | grep -q "Quiet"; then
            options="$options\n$pp_qt"
        fi
        if asusctl profile get |  awk '/Active profile:/ {print $3}' | grep -q "LowPower"; then
            options="$options\n$pp_lp"
        fi
        if asusctl profile get |  awk '/Active profile:/ {print $3}' | grep -q "Custom"; then
            options="$options\n$pp_cs"
        fi


    fi  
fi 

if command -v cardwire >/dev/null 2>&1; then  
    if cardwire get |  awk '/Current Mode:/ {print $3}' | grep -q "Integrated"; then
        options="$options\n$cw_igpu"
    fi
    if cardwire get |  awk '/Current Mode:/ {print $3}' | grep -q "Hybrid"; then
        options="$options\n$cw_hybrid"
    fi
    if cardwire get |  awk '/Current Mode:/ {print $3}' | grep -q "Smart"; then
        options="$options\n$cw_smart"
    fi
    if cardwire get |  awk '/Current Mode:/ {print $3}' | grep -q "Manual"; then
        options="$options\n$cw_manual"
    fi
fi 

if command -v cardwire >/dev/null 2>&1; then 
    chosen="$(echo -e "$options" | rofi "${ROFI_ARGS[@]}")"
    submenu="${chosen%% *}"
else 
    submenu="Power"
fi

case $submenu in 
    "GPU")
        submenu_options="$cancel"
        if cardwire get | grep  "Available" | grep -qo "integrated"; then
            submenu_options="$submenu_options\n$igpu"
        fi
        if cardwire get | grep  "Available" | grep -qo "hybrid"; then
            submenu_options="$submenu_options\n$hybrid"
        fi
        if cardwire get | grep  "Available" | grep -qo "smart"; then
            submenu_options="$submenu_options\n$smart"
        fi
        if cardwire get | grep  "Available" | grep -qo "manual"; then
            submenu_options="$submenu_options\n$manual"
        fi

        chosen="$(echo -e "$submenu_options" | rofi "${ROFI_ARGS[@]}")"
        case "$chosen" in
            "$igpu")
                cardwire set integrated 
                ;;
            "$hybrid")
                cardwire set hybrid
                ;;
            "$smart")
                cardwire set smart
                ;;
            "$manual")
                cardwire set manual
                ;;
            *)
                exit 0
                ;;
        esac 

        ;;

    "Power")
        submenu_options="$cancel"

        if command -v powerprofilesctl >/dev/null 2>&1; then
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
            case "$chosen" in
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
        else 
            if command -v asusctl >/dev/null 2>&1; then  
                if  asusctl profile list | grep -q "Performance"; then 
                    submenu_options="$submenu_options\n$perf"
                fi
                if  asusctl profile list | grep -q "Balanced"; then
                    submenu_options="$submenu_options\n$balanced"
                fi
                if  asusctl profile list | grep -q "Quiet"; then
                    submenu_options="$submenu_options\n$quiet"
                fi
                if  asusctl profile list | grep -q "LowPower"; then
                    submenu_options="$submenu_options\n$lowpower"
                fi
                if  asusctl profile list | grep -q "Custom"; then
                    submenu_options="$submenu_options\n$custom"
                fi

                chosen="$(echo -e "$submenu_options" | rofi "${ROFI_ARGS[@]}")"
                case "$chosen" in
                    "$perf")
                        asusctl profile set Performance
                        ;;
                    "$balanced")
                        asusctl profile set Balanced
                        ;;
                    "$quiet")
                        asusctl profile set Quiet
                        ;;
                    "$lowpower")
                        asusctl profile set LowPower
                        ;;
                    "$custom")
                        asusctl profile set Custom
                        ;;
                    *)
                        exit 0
                        ;;
                esac 

            fi

        fi 

        ;;
        
    *) 
        exit 0
        ;;
        
esac 

