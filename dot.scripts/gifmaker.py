#!/usr/bin/env python3

import sys
from subprocess import call, Popen, PIPE
from os import walk

time,duration,height = '', '', '640'
fps = '20'
delay = '5'

def get_args(t, d, h):
  if t != '':
    tmp = input('Time [[hh:]mm:]ss[.ms] ( ' + t + ' ) = ')
    if tmp != '': t = tmp
  else:
    t = input('Time [[hh:]mm:]ss[.ms] = ')

  if d != '':
    tmp = input('Duration [[hh:]mm:]ss[.ms] ( '+ d + ' ) = ')
    if tmp != '': d = tmp
  else:
    d = input('Duration [[hh:]mm:]ss[.ms] = ')
  
  tmp = input('Height in px ( ' + h + ' ) = ') 
  if tmp != '': h = tmp

  return t, d, h

argc = len(sys.argv)

if argc < 3:
  print('Usage: gifmaker filename output [ time ] [ duration ] [ height in px ]')
  print(' time and duration format: [[hh:]mm:]ss[.ms]')
  print(' (height is optional, default is 640px)')
  print('Example: video.mkv out.gif 00:13:23 5')
  sys.exit()

filename = sys.argv[1]
output = sys.argv[2]

if argc == 3:
  time, duration, height = get_args(time, duration, height)
else:
  time = sys.argv[3]
  duration = sys.argv[4]
  if argc == 6:
    height = sys.argv[5]


while True:
  mplayer = 'mplayer -ao null --loop=0 --really-quiet'
  mplayer += ' --xy=' + height
  mplayer += ' -ss ' + time
  mplayer += ' --endpos=' + duration
  mplayer += ' --xy=' + height
  mplayer += ' "' + filename + '"'

  print('\nShowing preview... Press [q] to exit')
  #os.system(mplayer)
  call(mplayer, shell=True)
  if input('Change something? [y/n] ') == 'n': break
  time, duration, height = get_args(time, duration, height)

print('\n=====\nWill now attempt to create a gif with following parameters:')
print('Filename: ' + filename)
print('Output file: ' + output)
print('Gif starts at: ' + time)
print('Duration of the gif: ' + duration)
print('Height: ' + height)

#Create tempdir
proc = Popen('mktemp -d', shell=True, stdout=PIPE)
tempdir = proc.stdout.read().decode('utf-8').rstrip()

#ffmpeg - get frames for gif
ffmpeg = 'ffmpeg -loglevel panic'
ffmpeg += ' -ss ' + time
ffmpeg += ' -i "' + filename + '"'
ffmpeg += ' -vf scale=' + height + ':-1'
ffmpeg += ' -t ' + duration
ffmpeg += ' -r ' + fps + ' ' 
ffmpeg += tempdir + '/%3d.png'
#print(ffmpeg)
call(ffmpeg, shell=True)

#convert png to gif for gifsicle
files = []
for (dirpath, dirname, filenames) in walk(tempdir):
  files.extend(filenames)
for i in files:
  convert = 'convert ' + tempdir + '/' + i
  convert += ' ' + tempdir + '/' + i + '.gif'
  call(convert, shell=True)

#convert frames to a gif
call('gifsicle --no-warnings --delay ' + delay + ' --loop ' + tempdir + '/*.gif > ' + output, shell=True)

#Remove tempdir
print('\nCleaning temp files...')
call('rm -r ' + tempdir, shell=True)

print('Done!')
