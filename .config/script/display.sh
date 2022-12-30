#! /bin/bash

# 1. 使用xrandr -q --current获取当前屏幕的数量
number=`xrandr -q --current | grep " connected" | wc -l`
# 2. 如果是1个屏幕，则判断是笔记本屏幕还是外接屏幕
if [[ $number == "1" ]]; then
    screen=`xrandr -q --current | grep " connected" | grep "eDP-1-1"`
    if [[ $screen == "" ]] ; then
        # 2.1 如果是外接屏幕，则关闭笔记本屏幕
        `xrandr --dpi 96 --output eDP-1-1 --off --output HDMI-0 --mode 1920x1080 --rate 60 --primary`
    else
        # 2.2 如果是笔记本屏幕，则关闭外接屏幕
        `xrandr --dpi 96 --output HDMI-0 --off --output eDP-1-1 --mode 1920x1080 --rate 120 --primary`
    fi
# 3. 如果是2个屏幕，则设置笔记本屏幕在右边，外接屏幕在左边
else
    `xrandr --dpi 96 --output HDMI-0 --mode 1920x1080 --rate 60 --pos 1920x0 --primary --output eDP-1-1 --mode 1920x1080 --rate 120 --pos 0x0`
fi

