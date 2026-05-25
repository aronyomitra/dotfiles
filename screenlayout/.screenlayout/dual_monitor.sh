#!/bin/sh
xrandr --output eDP-1 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal --scale 0.99x0.99
xrandr --output HDMI-1 --set "Broadcast RGB" "Full"
xrandr --output HDMI-1 --gamma 0.75:0.75:0.75
xset r rate 300 30
