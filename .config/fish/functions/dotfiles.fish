function dotfiles --wraps='GIT_WORK_TREE=~ GIT_DIR=/home/xv_rong/.config/dotfiles' --description 'alias dotfiles=GIT_WORK_TREE=~ GIT_DIR=/home/xv_rong/.config/dotfiles'
  GIT_WORK_TREE=~ GIT_DIR=/home/xv_rong/.config/dotfiles $argv; 
end
