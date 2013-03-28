#!/bin/bash

###########################################################################
#   This script provides easy and simple backup solution.                 #
#   It is primarily written for backing up Linux configuration files,     #
#   so called 'dotfiles'.                                                 #
#   The script's main purpose is to simplify the process of backing up    #
#   dotfiles from multiple locations and changing their names, so that    #
#   they are not hidden when viewing contents of the backup location.     #
#                                                                         #
#   How does it work?                                                     #
#   I. In the first step user should review variables used in script,     #
#      mainly $backup_dir and $backup array.                              #
#      User can edit following variables to their liking:                 #
#       $backup_dir - location to which files should be copied.           #
#       $log - location of the log file, used for logging errors.         #
#       $dots - defines whether or not to rename dotfiles in following    #
#               manner: .file => dot.file; value '1' enables this option. #
#       $backup - the most important variable of the script. It's an      #
#                 array containing paths to files and folders to back up. #
#                 Script uses rsync to copy files, so user must remember  #
#                 that trailing slash defines wheter to copy whole folder #
#                 or just its contents. With slash ( "dir/" ) only the    #
#                 contents of the catalogue will be copied, while without #
#                 it ( "dir" ) whole directory by name will be copied.    #
#                 Using rsync also allows us to pass various useful       #
#                 options to it, e.g. --include and --exclude to copy     #
#                 only selected files from a given directory.             #
#                                                                         #
#   II. Script begins with checking if backup destination exists and      #
#       creates directory if needed. Failure to do so results in          #
#       immediate termination of the program.                             #
#                                                                         #
#   III. Next step is creating or clearing a previous error log. Failure  #
#        to do so is most likely due to lack of write permission in       #
#        backup location, so the script terminates.                       #
#                                                                         #
#   IV. If renaming dotfiles is enabled, script renames them to their     #
#       original filenames. That way we won't have to copy files that are #
#       already up-to-date, thanks to using rsync.                        #
#                                                                         #
#   V.  Backing up! Script executes rsync on items from $backup array.    #
#       rsync output is supressed and all errors are written to $log.     #
#       This command must be executed like so:                            #
#         bash -c ' rsync ... '                                           #
#       That's because user can provide additional options for rsync,     #
#       which can include quote characters. Simply executing rsync        #
#       results in improperly resolved quotes that won't be parsed        #
#       correctly.                                                        #
#                                                                         #
#   VI. In the last step, if renaming dots is enabled, script finds all   #
#       files and directories in root backup directory and renames them   #
#       from ".file" to "dot.file" for easy viewing with 'ls' command     #
#       or in graphical file browser.                                     #
#                                                                         #
#   In every step the script tries to provide useful output.              #
###########################################################################

### Variables 

# backup location
backup_dir=$HOME'/linux-dotfiles'

# error log
log=$backup_dir'/err.log'

# rename leading dots? ".file => dot.file"
dots=1

# array of items to backup
# --exclude & --include with rsync syntax are allowed
backup=(
  $HOME"/.i3"
  $HOME"/.config/awesome --include=awesome/rc.lua --exclude=\"awesome/*\""
  $HOME"/.Xdefaults"
  $HOME"/.Xresources"
  $HOME"/.mplayer"
  $HOME"/.gtkrc-2.0"
  $HOME"/.config/gtk-3.0"
  $HOME"/.zshrc"
  $HOME"/.scripts"
  $HOME"/woods"
  $HOME"/solarized"
)

### End of variables

# check if backup dir exists, create if necessary
if [ ! -d $backup_dir ]; then
  echo -en "\e[0;31m!! No backup directory;\n!! creating one in "
  echo -e  "\e[0;32m$backup_dir\e[00m"
  mkdir $backup_dir || { echo -en "\e[0;31m!! ERROR - can't create directory.";
                         echo -e  "Insufficient rights?\e[00m"; exit 1; }
fi

# clean error log before continuing
echo > $log || { echo -en "\e[0;31m!! ERROR creating/cleaning error log. ";
            echo -e  "Insufficient rights?\e[00m"; exit 1; } 

echo -e "\e[0;36m++ Reconverting dots (if any)\e[00m"

# rename dots (if any) "dot.file => .file"
if [ $dots=1 ]; then
  for item in `find $backup_dir -maxdepth 1 -name "dot.*" -printf "%f\n"`; do
    mv $backup_dir'/'$item $backup_dir'/'`echo $item | sed 's/^dot\./\./g'` &&
       echo -e "\e[0;32m++ Reconverted $item\e[00m" || 
       { echo -e "!\e[0;31m!! ERROR reconverting dots in $item\e[00m";
         echo    "!! ERROR reconverting dots in $item" >> err.log; }
  done
fi

# backup!
echo -e "\e[0;36m++ Starting backup\e[00m\n"

for item in "${backup[@]}"
do
  bash -c "rsync -qa $item $backup_dir &>> err.log" && 
            echo -e "\e[0;32m:: $item\e[00m" ||
            echo -e "\e[0;31m!! ERROR copying $item, see $log for details!\e[00m"
done

# rename dots ".file => dot.file"
if [ $dots=1 ]; then
  # we need to ignore backup directory if its name begins with a dot
  ignore=`echo $backup_dir | sed 's,'"$HOME\/"',,'`
  for item in `find $backup_dir -maxdepth 1 \( -name .\* ! -name .git \
                                ! -name $ignore \) -printf "%f\n"`; do
    mv $backup_dir'/'$item $backup_dir'/'`echo $item | sed 's/^\./dot\./g'` &&
       echo -e "\e[0;32m++ Converted dots in $item\e[00m" ||
       { echo -e "\e[0;31m!! ERROR converting dots in $item\e[00m";
         echo -n "!! ERROR could not convert dots in ";
         echo    "$backup_dir/$item" >> err.log; }
  done
fi

exit 0
