#!/usr/bin/env python3

from os import getenv, walk
import re

def gen_entry(x):
  print(' { ', end='')
  print('"' + re.sub(match, '', x) + '", ', end='')
  print('"' + command + ' ' + path + '/' + x + '", ', end='')
  print(icon, end='')
  print(' },')


menu = 'cheatSheets'
command = 'zathura'
icon = '"/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png"'
path = getenv('HOME') + '/studia/cisco'
match = r'\.pdf$'

files = []

for (dirpath, dirname, filenames) in walk(path):
  files.extend(filenames)

print(menu, '= {')
for i in sorted(files, key=str.lower):
  gen_entry(i)
print('}')
