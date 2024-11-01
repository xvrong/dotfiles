#!/usr/bin/env bash
mode=$1
size="50% 80%"

drop=`hyprctl clients | grep "initialTitle: ChatGPT"`
if [ -z "$drop" ]; then
    if [ "$mode" == "silent" ]; then
        notify-send "Opening ChatGPT in silent mode"
        hyprctl dispatch -- exec '[workspace special:gpt silent; float; size '"$size"'; center 1] /opt/microsoft/msedge/microsoft-edge "--profile-directory=Profile 1" --app-id=cadlkienfkclaiaibeoongdcgmdikeeg --app-url=https://chatgpt.com/ --ozone-platform-hint=auto --enable-wayland-ime'
    else
        hyprctl dispatch -- exec '[workspace special:gpt; float; size '"$size"'; center 1] /opt/microsoft/msedge/microsoft-edge "--profile-directory=Profile 1" --app-id=cadlkienfkclaiaibeoongdcgmdikeeg --app-url=https://chatgpt.com/ --ozone-platform-hint=auto --enable-wayland-ime'
    fi
else
    hyprctl dispatch togglespecialworkspace gpt
    activeStatus=`hyprctl activewindow | grep "initialTitle: ChatGPT"`
    if [ -n "$activeStatus" ]; then
        hyprctl dispatch resizeactive exact $size
        hyprctl dispatch centerwindow 1
    fi
fi