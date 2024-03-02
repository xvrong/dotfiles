#!/usr/bin/env bash
drop=`ps -aux | grep alacritty-dropdown | grep -v grep`
if [ -z "$drop" ]; then
    hyprctl dispatch -- exec '[workspace special; float;size 60% 75%; center 1] alacritty  --class alacritty-dropdown --command fish'
else
    hyprctl dispatch togglespecialworkspace
    activeStatus=`hyprctl activewindow | grep "class: alacritty-dropdown"`
    if [ -n "$activeStatus" ]; then
        hyprctl dispatch resizeactive exact 60% 75%
        hyprctl dispatch centerwindow 1
    fi
fi