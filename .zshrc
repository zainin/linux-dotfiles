source "$HOME/.zgen/zgen.zsh"
if ! zgen saved; then
    zgen oh-my-zsh
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/extract
    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh plugins/sudo

    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-completions

    zgen oh-my-zsh themes/gallois

    zgen save
fi

if [ -d $HOME/bin ]; then
    export PATH=$PATH:$HOME/bin
fi

alias sudo='nocorrect sudo'
alias duH='du -hs * | sort -h'
alias ati-movie='aticonfig --set-dispattrib=lvds,brightness:-10'
alias ati-standard='aticonfig --set-dispattrib=lvds,brightness:-23'
alias debug-wm='Xephyr :1 -ac -br -noreset -screen 1280x780&'
alias debug-wm-run='DISPLAY=:1.0'

alias svim='sudoedit'
alias subs='subliminal download -l en --'
alias pfx='peerflix -v -r -f /media/storage-ext/tmp/'

alias xcat='colorize'
alias pa='pacaur'

alias irc='mosh pbr -- tmux a'

alias windows='sudo systemctl --firmware-setup reboot'

alias kden='GTK2_RC_FILES=gns3-gtk-rc kdenlive'

fortune -as
echo
export EDITOR=vim
eval $(dircolors ~/.dir_colors)

# vi mode faster normal mode
export KEYTIMEOUT=1

# colored man
source ~/.mancolor.sh
