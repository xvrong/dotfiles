function ls --wraps=lsd --wraps='exa --icons' --description 'alias ls=exa --icons'
  exa --icons $argv
        
end
