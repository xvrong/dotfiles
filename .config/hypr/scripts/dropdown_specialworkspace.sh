#!/usr/bin/env bash
drop=`ps -aux | grep alacritty-dropdown | grep -v grep`
if [ -z "$drop" ]; then
    hyprctl dispatch -- exec '[workspace special; size 75% 50%] alacritty  --class alacritty-dropdown --command fish'
else
    hyprctl dispatch togglespecialworkspace
fi