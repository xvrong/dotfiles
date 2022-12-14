#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority
export XINITRC=$XDG_CONFIG_HOME/X11/xinitrc

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx

export EDITOR=nvim
export PATH=$XDG_CONFIG_HOME/rofi/rofi-translate:$PATH

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]];
then
  sudo /usr/bin/prime-switch
  exec startx
fi

