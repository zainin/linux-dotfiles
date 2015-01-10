#!/usr/bin/env python

import os
import os.path
import sys

os.system("killall xscreensaver")
os.system("echo -e 'xscreensaver [\033[0;32mKILLED\033[0m]'")
os.system("aticonfig --set-dispattrib=lvds,brightness:-5")
os.system("echo -e 'change colors [\033[0;32mMOVIE\033[0m]'")

command = '/usr/bin/mplayer.org %s "%s"' % (' '.join(sys.argv[1:-1]), os.path.normpath(sys.argv[-1]))

os.system(command)

os.system("nohup xscreensaver -no-splash &")
os.system("rm nohup.out")
os.system("echo -e 'xscreensaver restored [\033[0;32mDONE\033[0m]'")
os.system("aticonfig --set-dispattrib=lvds,brightness:-23")
os.system("echo -e 'change colors [\033[0;32mSTANDARD\033[0m]'")

