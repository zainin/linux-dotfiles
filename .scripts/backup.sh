#!/bin/bash
# simple dotfiles backup script

# backup folder
backup_dir=$HOME'/linux-dotfiles'

# command with which to backup
function back {
  rsync -a $1 $2
}

# files/folder to backup
i3=$HOME/'.i3'
awesome=$HOME'/.config/awesome'
xdefaults=$HOME'/.Xdefaults'
xresources=$HOME'/.Xresources'
mplayer=$HOME'/.mplayer'
gtkrc=$HOME'/.gtkrc-2.0'
zshrc=$HOME'/.zshrc'
dzen=$HOME'/.dzen2'
conky=$HOME'/.conkyrc'
scripts=$HOME'/.scripts'
wallpaper=$HOME'/Images/zixpk.jpg'

# array of items to backup
backup=($i3 $awesome $xdefaults $xresources $mplayer $gtkrc $zshrc \
$dzen $conky $scripts $wallpaper)

if [ -d $backup_dir ];
then
  echo ':: Backup directory exists...'
else
  echo ':: No backup directory, creating...'
  mkdir $backup_dir
fi

for item in ${backup[*]}
do
  echo $item
  back $item $backup_dir
done

