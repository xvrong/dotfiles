#!/usr/bin/env bash
size="50% 50%"

drop=`ps -aux | grep alacritty-dropdown | grep -v grep`
if [ -z "$drop" ]; then
    hyprctl dispatch -- exec '[workspace special; float; size '"$size"'; center 1] alacritty  --class alacritty-dropdown --command fish'

else
    hyprctl dispatch togglespecialworkspace
    activeStatus=`hyprctl activewindow | grep "class: alacritty-dropdown"`
    if [ -n "$activeStatus" ]; then
        hyprctl dispatch resizeactive exact $size
        hyprctl dispatch centerwindow 1
        # hyprctl dispatch moveactive exact 100% 3%
    fi
fi