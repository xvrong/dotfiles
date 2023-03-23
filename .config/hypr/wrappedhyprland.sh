#!/bin/sh

cd ~

# 中文化
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US

# XDG Specifications
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland

# Log WLR errors and logs to the hyprland log. Recommended
export HYPRLAND_LOG_WLR=1

# Tell XWayland to use a cursor theme
export XCURSOR_THEME=Bibata-Modern-Classic

# Set a cursor size
export XCURSOR_SIZE=24

# Example IME Support: fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus

# Fix Nvidia
export LIBVA_DRIVER_NAME=nvidia
export XDG_SESSION_TYPE=wayland
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export WLR_NO_HARDWARE_CURSORS=1

export EDITOR=nvim

# 对于诸如 sway 的一些混成器，在运行 Qt 程序时可能会遇到一些功能缺失。例如，KeepassXC 会无法最小化到托盘。通过安装 qt5ct包 并在程序运行前设置好 QT_QPA_PLATFORMTHEME=qt5ct 环境变量，可以解决此问题。
export QT_QPA_PLATFORMTHEME=qt5ct

exec Hyprland
