function tatt --wraps='tmux attatch -t' --wraps='tmux attach -t' --description 'alias tatt=tmux attach -t'
  tmux attach -t $argv
        
end
