# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="sporty_256"
ZSH_THEME="miloshadzic"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
#CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(vi-mode git extract colorize fbterm)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/android-sdk/tools:/usr/bin/vendor_perl:/usr/bin/core_perl:/opt/qt/bin

#alias ls='ls --color=auto'
alias sudo='nocorrect sudo'
alias yaourt='nocorrect yaourt'
alias duH='du -hs * | sort -h'
alias ati-movie='aticonfig --set-dispattrib=lvds,brightness:-10'
alias ati-standard='aticonfig --set-dispattrib=lvds,brightness:-23'
alias irc='screen irssi'
alias debug-wm='Xephyr :1 -ac -br -noreset -screen 1280x780&'
alias debug-wm-run='DISPLAY=:1.0'
#serwis matrix
alias serwis-zdalny='ssh zdalny@178.19.98.7'
alias serwis='ssh user@178.19.98.7'
alias mtunnel='ssh -L 8080:172.16.0.223:8291 user@mserwis'

alias svim='sudoedit'
alias subs='subliminal -l en --'
alias pfx='peerflix -v -r -f /media/storage-ext/tmp/'

alias xcat='colorize'

fortune -as
echo
export EDITOR=vim
eval $(dircolors ~/.dir_colors)

[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh
#. /usr/share/zsh/site-contrib/powerline.zsh

#vi mode faster normal mode
export KEYTIMEOUT=1

#syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#colored man
source ~/.mancolor.sh

#reverse history search
bindkey "^R" history-incremental-search-backward
