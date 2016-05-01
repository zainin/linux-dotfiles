--- music controls
mctl = {}
mctl.play = scripts .. "/music-ctl.sh play"
mctl.next = scripts .. "/music-ctl.sh next"
mctl.stop = scripts .. "/music-ctl.sh stop"

-- volume controls
vol = {}
vol.up = scripts .. "/vol-ctl.sh -i 5"
vol.down = scripts .. "/vol-ctl.sh -d 5"
vol.mute = scripts .. "/vol-ctl.sh -t"

-- take a screenshot
take_screenshot = 'sleep 0.1; maim -m on -s "/media/storage-ext/Images/screenshots/$(date +%F-%T).png"'
