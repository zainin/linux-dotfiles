#!/bin/bash

### Variables

# backup location
backup_dir=$HOME'/linux-dotfiles'

# error log
log=$HOME'/dotfiles-backup.log'

# array of items to backup
# --exclude & --include with rsync syntax are allowed
backup=(
  $HOME"/.config/awesome/rc.lua"
  $HOME"/.config/awesome/themes/rv1/"
  $HOME"/.config/bspwm/bspwmrc"
  $HOME"/.config/sxhkd/sxhkdrc"
  $HOME"/.config/gtk-3.0/"
  $HOME"/.config/tint2/tint2rc"
  $HOME"/.config/compton.conf"
  $HOME"/.scripts/"
  $HOME"/.mpv/"
  $HOME"/.Xresources"
  $HOME"/.gtkrc-2.0"
  $HOME"/.zshrc"
  $HOME"/.vimrc"
)

### End of variables

# check if backup dir exists, create if necessary
backdir(){
  if [ ! -d $backup_dir ]; then
    echo -en "\e[0;31m!! No backup directory;\n!! creating one in "
    echo -e  "\e[0;32m$backup_dir\e[00m"
    mkdir $backup_dir || { echo -en "\e[0;31m!! ERROR - can't create directory.";
                           echo -e  "Insufficient rights?\e[00m"; exit 1; }
  fi
}

# backup!
backup(){
  echo -e "\e[0;36m++ Backing up!\e[00m\n"
  echo -e "Backup dir is $backup_dir\n"

  echo -e "\e[0;36m++ Copying files\e[00m"

  for item in "${backup[@]}"
  do
    back_path=$backup_dir`echo $item | sed "s|$HOME||g"`
#    echo $back_path
    bash -c "rsync -qa $item $back_path &>> $log" &&
              echo -e "\e[0;32m:: $item -> $back_path\e[00m" ||
              echo -e "\e[0;31m!! ERROR copying $item, see $log for details!\e[00m"
  done
}

backdir

# clean error log before continuing
echo `date` > $log || { echo -en "\e[0;31m!! ERROR creating/cleaning error log. ";
            echo -e  "Insufficient rights?\e[00m"; exit 1; }

backup

exit 0
