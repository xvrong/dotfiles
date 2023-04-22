#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US

# solve with XDG Base Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

export EDITOR=nvim

exec Hyprland
# exec ~/.config/awesome/wrappedawesome.sh

