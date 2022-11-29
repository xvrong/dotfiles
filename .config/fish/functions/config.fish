function config --wraps='git --git-dir=/home/xv_rong/.config/dotfiles --work-tree=/home/xv_rong/.config' --wraps='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' --wraps='git --git-dir=$HOME/.config/.dotfiles/ --work-tree=$HOME' --wraps='git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME/.config' --wraps='git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME/' --description 'alias config=git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME/'
  git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME/ $argv; 
end
