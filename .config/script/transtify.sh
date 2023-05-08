#! /bin/bash
# transout=$(crow -t zh-CN $(wl-paste -p) -b)
transout=$(trans -j -b $(wl-paste -p))
notify-send "$transout"