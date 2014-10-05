# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="sporty_256"

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
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/android-sdk/tools:/usr/bin/vendor_perl:/usr/bin/core_perl:/opt/qt/bin

alias mpd_eq='sudo -H -u mpd alsamixer -D equal'
alias ls='ls --color=auto'
alias sudo='nocorrect sudo'
alias yaourt='nocorrect yaourt'
alias duH='du -hs * | sort -h'
alias ati-movie='aticonfig --set-dispattrib=lvds,brightness:-10'
alias ati-standard='aticonfig --set-dispattrib=lvds,brightness:-23'
alias irc='screen irssi'
alias debug-wm='Xephyr :1 -ac -br -noreset -screen 1280x780&'
alias debug-wm-run='DISPLAY=:1.0'
alias hera='ssh -t i241605@tryglaw.ii.uni.wroc.pl ssh hera'
#serwis matrix
alias serwis='ssh zdalny@178.19.98.7'
alias serwis-user='ssh user@178.19.98.7'
alias svim='sudoedit'
alias subs='subliminal -l en --'
alias mtunnel='ssh -L 8080:172.16.0.223:8291 user@mserwis'

fortune -a
echo
export EDITOR=vim
#eval `dircolors -b ~/.dir_colors`

[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh
#. /usr/share/zsh/site-contrib/powerline.zsh

#no rehash
setopt nohashdirs

#syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#colored man
source ~/.mancolor.sh
