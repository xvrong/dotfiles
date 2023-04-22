#! /usr/bin/bash
export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority
export XINITRC=$XDG_CONFIG_HOME/X11/xinitrc

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]];
then
  sudo /usr/bin/prime-switch
  autorandr &
  exec startx
fi
