AC=$(cat /sys/class/power_supply/AC*/online 2>/dev/null | head -n1)
MODE=$(supergfxctl -g)

if [ "$AC" = "1" ] && [ "$MODE" != "Hybrid" ]; then
  supergfxctl -m Hybrid
elif [ "$AC" = "0" ] && [ "$MODE" != "Integrated" ]; then
  supergfxctl -m Integrated
fi
