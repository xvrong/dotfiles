#!/usr/bin/env bash
drop=`ps -aux | grep alacritty-dropdown | grep -v grep`
if [ -z "$drop" ]; then
    hyprctl dispatch -- exec '[workspace special dropdown; size 75% 50%] alacritty  --class alacritty-dropdown --command fish'
    sleep 0.5
    hyprctl dispatch togglespecialworkspace dropdown
else
    hyprctl dispatch togglespecialworkspace dropdown
fi