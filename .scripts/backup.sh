#!/bin/bash

### Variables

# backup location
BACKUP_DIR=$HOME'/linux-dotfiles'

# error log
LOGFILE=$HOME'/dotfiles-backup.log'

# array of items to backup
# directories or files
TO_BACKUP=(
  $HOME"/.config/awesome/rc.lua"
  $HOME"/.config/awesome/widgets.lua"
  $HOME"/.config/awesome/helpers.lua"
  $HOME"/.config/awesome/themes/rv1/"
  $HOME"/.config/bspwm/bspwmrc"
  $HOME"/.config/sxhkd/sxhkdrc"
  $HOME"/.config/gtk-3.0/"
  $HOME"/.config/tint2/tint2rc"
  $HOME"/.config/compton.conf"
  $HOME"/.config/termite/"
  $HOME"/.scripts/"
  $HOME"/.mpv/input.conf"
  $HOME"/.mpv/config"
  $HOME"/.Xresources"
  $HOME"/.gtkrc-2.0"
  $HOME"/.zshrc"
  $HOME"/.vimrc"
)

file_list=()
### End of variables

# check if backup dir exists, create if necessary

log(){
  case "$1" in
    error) color="\e[0;31m";;
    warning) color="\e[0;33m";;
    info) color="\e[0;36m";;
    *) color="";;
  esac
  NC="\e[00m"

  echo -en "${color}$2${NC}"
}

is_backdir(){
  if [ ! -d $BACKUP_DIR ]; then
    log "error" "!! No backup directory;\n!! creating one in "
    log "warning" "$BACKUP_DIR\n"
    mkdir $BACKUP_DIR || { log "error" "!! ERROR - can't create directory.";
                           log" error" " Insufficient rights?"; exit 1; }
  fi
}

gen_file_list(){
  # generate a list of files to check
  # get into directories as well
  for item in "${TO_BACKUP[@]}"; do
    if [ -d "$item" ]; then
      for i in $(find "$item" | xargs); do
        if [ -d $i ]; then continue; fi
        file_list+=("$i")
      done
    else
      file_list+=("$item")
    fi
  done
}

# backup!
backup-quick(){
  log "info" "++ Backing up!\n"
  log "warning" "!! Backing up without checking!\n"
  log "info" "++ Backup dir is $BACKUP_DIR\n"

  log "info" "++ Copying files/directories\n"

  for item in "${TO_BACKUP[@]}"
  do
    back_path=$BACKUP_DIR${item##$HOME}
    echo $item " -> " $back_path
    bash -c "rsync -qa $item $back_path &>> $LOGFILE" &&
              echo -e "\e[0;32m:: $item -> $back_path\e[00m" ||
              echo -e "\e[0;31m!! ERROR copying $item, see $LOGFILE for details!\e[00m"
  done
}

backup(){
  gen_file_list

  #let user see what's changed before writing to backup
  for i in "${file_list[@]}"; do
    backed_up_file="$BACKUP_DIR"${i##$HOME}

    # if files exist, are text and different
    if [ -f $backed_up_file ] &&
       file -b --mime-type "$i" | grep -qE "^text/" &&
       ! cmp --quiet "$i" $backed_up_file; then
      log "info" ":: ${i##$HOME} is different\n"
      vimdiff $i "$backed_up_file"
      continue
    fi

    # if the loop is still going, then file is not backup or not text
    bash -c "rsync -qa $i $backed_up_file &>> $LOGFILE" ||
              #log "info" "$i -> $backed_up_file\n" ||
              log "error" "!! ERROR copying $i, check log ($LOGFILE)\n"
  done
}

restore(){
  log "info" ":: Starting backup restore\n"
  gen_file_list

  # if backed up and local files both and are different exist, let user decide
  # what to do
  for i in "${file_list[@]}"; do
    backed_up_file="$BACKUP_DIR"${i##$HOME}

    # if files exist, are text and different
    if [ -f $backed_up_file ] &&
       file -b --mime-type "$i" | grep -qE "^text/" &&
       ! cmp --quiet "$i" $backed_up_file; then
      log "info" ":: ${i##$HOME} is different\n"
      vimdiff "$i" "$backed_up_file"
      continue
    fi
    bash -c "rsync -qa $backed_up_file $i &>> $LOGFILE" ||
              #log "info" "$backed_up_file -> $i\n" ||
              log "error" "!! ERROR copying $backed_up_file, check log ($LOGFILE)\n"

  done
}

# clean error log before continuing
echo -en "\n\n$(date)" >> $LOGFILE ||
            { echo -en "\e[0;31m!! ERROR creating/cleaning error log. ";
              echo -e  "Insufficient rights?\e[00m"; exit 1; }

if [[ "$1" == "backup" ]]; then
  is_backdir
  backup
elif [[ "$1" == "backup-quick" ]]; then
  is_backdir
  backup-quick
elif [[ "$1" == "restore" ]]; then
  restore
fi
exit 0
