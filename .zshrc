# Set up the prompt

autoload -Uz promptinit
promptinit
#prompt redhat
setopt correctall
PROMPT="%F{red}[%f%n@%m %~%F{red}]%f
%F{red}>%f "
RPROMPT="%F{blue}[%f%D %*%F{blue}]%f"

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


alias mpd_eq='sudo -H -u mpd alsamixer -D equal'
alias ls='ls --color=auto'
alias sudo='nocorrect sudo'
alias duH='du -hs * | sort -h'
alias ati-movie='aticonfig --set-dispattrib=lvds,brightness:-10'
alias ati-standard='aticonfig --set-dispattrib=lvds,brightness:-23'
alias irc='screen irssi'
alias pacman='pacmatic'
alias debug-wm='Xephyr :1 -ac -br -noreset -screen 1280x780&'
alias debug-wm-run='DISPLAY=:1.0'

cowsay -f kosh `fortune -a`
export EDITOR=vim
eval `dircolors -b ~/.dir_colors`
