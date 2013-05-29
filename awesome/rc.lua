-------------------
--    zainin     --
--  awesome 3.5  --
-------------------

--- {{{ Libraries

vicious = require("vicious")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

--- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

--- Useful paths
home = os.getenv("HOME")
scripts = home .. "/.scripts"
confdir = home .. "/.config/awesome"
themes = confdir .. "/themes"

-- Themes define colours, icons, and wallpapers
active_theme = themes .. "/colored"
beautiful.init(active_theme .. "/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
	names		= { "一", "二", "三", "四", "五", "六" },
	layout	= { layouts[1], layouts[2], layouts[1], layouts[12], layouts[1], layouts[1] }
}


for s = 1, screen.count() do
	tags[s] = awful.tag(tags.names, s, tags.layout)
end
--for s = 1, screen.count() do
--    -- Each screen has its own tag table.
--    tags[s] = awful.tag({ "一", "二", "三", "四", "五", "六"  }, s, layouts[1])
--end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

cheatSheets = {
 { "BGP", "zathura /home/zainin/studia/cisco/BGP.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "Cisco_IOS_Versions", "zathura /home/zainin/studia/cisco/Cisco_IOS_Versions.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "common_ports", "zathura /home/zainin/studia/cisco/common_ports.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "EIGRP", "zathura /home/zainin/studia/cisco/EIGRP.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "First_Hop_Redundancy", "zathura /home/zainin/studia/cisco/First_Hop_Redundancy.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "IEEE_802.11_WLAN", "zathura /home/zainin/studia/cisco/IEEE_802.11_WLAN.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "IEEE_802.1X", "zathura /home/zainin/studia/cisco/IEEE_802.1X.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "IOS_IPv4_Access_Lists", "zathura /home/zainin/studia/cisco/IOS_IPv4_Access_Lists.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "IPsec", "zathura /home/zainin/studia/cisco/IPsec.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "IPv4_Multicast", "zathura /home/zainin/studia/cisco/IPv4_Multicast.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "IPv4_Subnetting", "zathura /home/zainin/studia/cisco/IPv4_Subnetting.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "IPv6", "zathura /home/zainin/studia/cisco/IPv6.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "IS-IS", "zathura /home/zainin/studia/cisco/IS-IS.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "NAT", "zathura /home/zainin/studia/cisco/NAT.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "OSPF", "zathura /home/zainin/studia/cisco/OSPF.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "physical_terminations", "zathura /home/zainin/studia/cisco/physical_terminations.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "PPP", "zathura /home/zainin/studia/cisco/PPP.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "RIP", "zathura /home/zainin/studia/cisco/RIP.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "RJ45-Guide", "zathura /home/zainin/studia/cisco/RJ45-Guide.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "Spanning_Tree", "zathura /home/zainin/studia/cisco/Spanning_Tree.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
 { "VLANs", "zathura /home/zainin/studia/cisco/VLANs.pdf", "/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png" },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal },
                                    { "cheat sheets", cheatSheets }
                                  }
                        })

mylauncher = awful.widget.launcher({ --image = beautiful.awesome_icon,
                                     menu = mymainmenu })


--Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

--- {{{ COMMANDS
local commands = {}


--- {{{ Spotify controls

spotify = {}
spotify.play = scripts .. "/spotify.sh play"
spotify.nxt = scripts .. "/spotify.sh next"
spotify.prev = scripts .. "/spotify.sh prev"

--- {{ check if we're on laptop
function is_laptop()
	local f = io.popen(scripts .. "/if_laptop.sh")
  local res = f:read("*all")
  io.close(f)
  if res == "yes" then
    return true
  else
    return false
  end
end
--- }}

--- {{ get cpu frequency once (because it won't change)

function get_freq()
  local f = io.popen("grep -m 1 MHz /proc/cpuinfo | awk '{ printf \"%.2fGHz\",$4/1000 }'")
  local res = f:read("*all")
  io.close(f)
  return res
end

--- }}

--- {{ audio raise/lower volume
function getvol(x)
	local f
	if x == "toggle" then
		f = io.popen("amixer get Master | awk '{ print $6 }' | grep o")
	else
		f = io.popen("amixer get Master | awk '{ print $4 }' | grep \\%")
	end
	local level = f:read("*all")
	f.close(f)
	return level
end
function vol(x)
	--local level = getvol()
	local level
	if x == "up" then
		awful.util.spawn("amixer -q set Master 2+ unmute")
		level = ' +5 ' .. getvol()
	elseif x == "down" then
		awful.util.spawn("amixer -q set Master 2- unmute")
		level = ' -5 ' .. getvol()
	else
		awful.util.spawn("amixer -q set Master toggle")
		level = getvol("toggle")
	end
	naughty.notify({ text = level, title = 'Volume', position = 'top_right', timeout = 5, icon = "/usr/share/pixmaps/volume.png", replaces_id=666 }).id=666
end
--- }}

--- {{ brightness
function get_brightness()
	local f = io.popen("sudo light -c | awk -F. '{print $1 }'")
	local aux = f:read("*all")
	f.close(f)
	return aux
end
function bright(x)
	local level
	if x == "up" then
		awful.util.spawn("sudo light -a 12")
		level = " brightness up [" .. get_brightness() .. "%]"
	else
		awful.util.spawn("sudo light -s 12")
		level = " brightness down [" .. get_brightness() .. "%]"
	end
	level = level:gsub('\n', '')
	naughty.notify({ text = level, title = 'Screen brightness', position = 'top_right', timeout = 5, replaces_id=777 }).id=777
end
--- }}

commands.home = "pcmanfm ~"

-- }}}

-- {{{ WIDGETS

local separator = wibox.widget.textbox()
separator:set_text(" ")

---- {{{ bottom bar

--- {{{ Uptime widget

uptimeicon = wibox.widget.imagebox()
uptimeicon:set_image(beautiful.widget_uptime)
local uptimewidget = wibox.widget.textbox()
vicious.register(uptimewidget, vicious.widgets.uptime, "<span color='#94738c'>$1.$2:$3'</span>")

--- }}}

--- {{{ Internet widget

netdownicon = wibox.widget.imagebox()
netdownicon:set_image(beautiful.widget_netdown)
netdownwidget = wibox.widget.textbox()
if is_laptop() then
	vicious.register(netdownwidget, vicious.widgets.net, "<span color='#ce5666'>${wlan0 down_kb}</span>", 1)
else
	vicious.register(netdownwidget, vicious.widgets.net, "<span color='#ce5666'>${eth0 down_kb}</span>", 1)
end

netupicon = wibox.widget.imagebox()
netupicon:set_image(beautiful.widget_netup)
netupwidget = wibox.widget.textbox()
if is_laptop() then
	vicious.register(netupwidget, vicious.widgets.net, "<span color='#87af5f'>${wlan0 up_kb}</span>", 1)
else
	vicious.register(netupwidget, vicious.widgets.net, "<span color='#87af5f'>${eth0 up_kb}</span>", 1)
end

--- }}}

--- {{{ CPU widget

cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
local cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, "<span color='#94738c'>$2%</span>/<span color='#94738c'>$3%</span>")

--- }}}

--- {{{ CPU frequency widget

local cpufreqwidget = wibox.widget.textbox()
if is_laptop() then
  vicious.register(cpufreqwidget, vicious.widgets.cpufreq, "<span color='#94738c'>$2GHz</span>", 1, "cpu0")
else
  cpufreqwidget:set_markup("<span color='#94738c'>" .. get_freq() .. "</span>") 
end

--- }}}

--- {{{ CPU temperature widget

cputempicon = wibox.widget.imagebox()
cputempicon:set_image(beautiful.widget_temp)
local cputempwidget = wibox.widget.textbox()
vicious.register(cputempwidget, vicious.widgets.thermal, "<span color='#ffaf5f'>$1°C</span>", 10,{"coretemp.0","core"} )

--- }}}

--- {{{ RAM widget

memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
local memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, "<span color='#7788af'>$1% $2/$3</span>")

--- }}}

--- {{{ Battery widget

baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batt)
local batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat, "<span color='#ce5666'> $1$2% </span><span color='gray'>. </span><span color='#ce5666'>$3</span>", 60, "BAT0")

--- }}}

--- {{{ FS widget

fsicon = wibox.widget.imagebox()
fsicon:set_image(beautiful.widget_fs)
local fswidget = wibox.widget.textbox()
vicious.register(fswidget, vicious.widgets.fs, "<span color='gray'>/ </span><span color='#7788af'>${/ used_p}%[${/ avail_gb}GB]</span><span color='gray'> /home </span><span color='#7788af'>${/home used_p}%[${/home avail_gb}GB]</span>", 10)

--- }}}

--- {{{ MPD widget

local mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd,
	function (widget, args)
		if args["{state}"] == "Stop" then
			return '<span color=\'gray\'>MPD stopped</span>'
		else
			if args["{state}"] == "Pause" then
				return '<span color=\'gray\'>^'..args["{Artist}"]..' - '..args["{Title}"]..'</span>'
			else
				--return '<span color=\'white\'>'..args[\"{Artist}\"]..' - '..args[\"{Title}\"]..'</span>'
				return args["{Artist}"]..' - '.. args["{Title}"]
			end
		end
	end)

--- }}}

--- {{{ Volume widget

local volwidget = wibox.widget.textbox()
vicious.register(volwidget, vicious.widgets.volume, " [$2$1]", 1, "Master")

--- }}}

---- }}}

---- {{{ top bar

--- {{{ Weather widget

local weatherwidget = wibox.widget.textbox()
vicious.register(weatherwidget, vicious.widgets.weather,
  function (widget, args)
    return ' '..args["{tempc}"]..'°C | '
  end, 1800, "EPWR")

--- }}}

--- {{{ Clock widget

local clockwidget = wibox.widget.textbox()
vicious.register(clockwidget, vicious.widgets.date, "%d/%m/%g %R")

--- }}}

---- }}}






-- {{{ Wibox
-- Create a textclock widget
--mytextclock = awful.widget.textclock()


-- Create a wibox for each screen and add it
mywibox = {}
status_bar = {} --bar with vicious widgets
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
	status_bar[s] = awful.wibox({ position = "bottom", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(uptimeicon) right_layout:add(uptimewidget) 
    right_layout:add(weatherwidget)
    right_layout:add(clockwidget)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

	  -- status_bar, widget left side
	  local left_statusbar = wibox.layout.fixed.horizontal()
	
	  left_statusbar:add(netdownicon) left_statusbar:add(netdownwidget)
    left_statusbar:add(separator)
    left_statusbar:add(netupicon) left_statusbar:add(netupwidget)
    left_statusbar:add(separator)
    left_statusbar:add(cpuicon) left_statusbar:add(cpuwidget)
    left_statusbar:add(separator)
    left_statusbar:add(cpufreqwidget) 
    left_statusbar:add(separator)
    left_statusbar:add(cputempicon) left_statusbar:add(cputempwidget)
	  left_statusbar:add(separator)
	  left_statusbar:add(memicon) left_statusbar:add(memwidget) left_statusbar:add(separator)
	  if is_laptop() then
      left_statusbar:add(baticon) left_statusbar:add(batwidget)
      left_statusbar:add(separator)
    end
	  left_statusbar:add(fsicon) left_statusbar:add(fswidget)

	  local right_statusbar = wibox.layout.fixed.horizontal()
	  right_statusbar:add(mpdwidget) right_statusbar:add(volwidget)

	  local layout_statusbar = wibox.layout.align.horizontal()
	  layout_statusbar:set_left(left_statusbar)
	  layout_statusbar:set_right(right_statusbar)
	  status_bar[s]:set_widget(layout_statusbar)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "e", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

	-- CUSTOM KEYS
	awful.key({ modkey,			}, "F1",function () awful.util.spawn_with_shell(commands.www) end),
	awful.key({ modkey,			}, "a",	function () awful.util.spawn_with_shell("exec ncmpcpp toggle") end),
	awful.key({ modkey,			}, "z",	function () awful.util.spawn_with_shell("exec ncmpcpp stop") end),
	awful.key({ modkey,			}, "c",	function () awful.util.spawn_with_shell("exec ncmpcpp next") end),
  awful.key({ modkey,     }, "q", function () awful.util.spawn_with_shell(spotify.play) end),
	awful.key({ modkey,			}, "F4",function () vol("up") end),
	awful.key({ modkey,			}, "F3" ,function () vol("down") end),
	awful.key({ modkey,			}, "F2" ,function () vol("toggle") end),
	awful.key({}, "XF86MonBrightnessUp", function () bright("up") end),
	awful.key({}, "XF86MonBrightnessDown", function () bright("down") end),
	awful.key({ modkey, "Control" }, "h", function () awful.util.spawn_with_shell(commands.home) end),
	awful.key({ modkey, "Control" }, "l",	function () awful.util.spawn_with_shell("exec i3lock -c 000000 -d") end),

  --Menubar
  awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
	{ rule = { class = "Firefox" },
	  properties = { tag = tags[1][1], border_width = 0 } },
	{ rule = { class = "Opera" },
	  properties = { tag = tags[1][1], border_width = 0 } },
	{ rule = { class = "Chromium" },
	  properties = { tag = tags[1][1], border_width = 0 } },
	{ rule = { class = "Wine" },
	  properties = { tag = tags[1][5] } },
	{ rule = { class = "Pidgin" },
	  properties = { tag = tags[1][4] } },
	{ rule = { class = "VirtualBox" },
	  properties = { border_width = 0 } },
	{ rule = { class = "Wine" },
	  properties = { border_width = 0 } },
  { rule = { class = "Psychonauts" },
    properties = { border_width = 0 } },
  { rule = { class = "Amnesia" },
    properties = { border_width = 0 } },
  { rule = { class = "Hammerfight" },
    properties = { border_width = 0 } },
  { rule = { class = "Gratuitous Space Battles" },
    properties = { border_width = 0 } },
  { rule = { instance = "plugin-container" },
    properties = { floating = true } },
  { rule = { instance = "Steam", name = "Steam" },
    properties = { maximized_vertical=true, maximized_horizontal=true } },
  { rule = { class = "Steam" },
    properties = { tag = tags[1][3] } },

    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

autorun = true
autorunApps = {}
if is_laptop() then
	autorunApps = 
	{ 
		"urxvtd",
		"xcompmgr",
		"keepassx",
		"wicd-client",
  	scripts .. "/wallpaper.sh",
	}
else
	autorunApps =
	{
		"urxvtd",
		"keepassx",
		scripts .. "/wallpaper.sh",
	}
end

function run_once(cmd)
	findme = cmd
	firstspace = cmd:find(" ")
	if firstspace then
		findme = cmd:sub(0, firstspace-1)
	end
	awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

if autorun then
		for app = 1, #autorunApps do
--			awful.util.spawn_with_shell(autorunApps[app])
			run_once(autorunApps[app])
		end
end

-- disable startup-notification globally
local oldspawn = awful.util.spawn
awful.util.spawn = function (s)
  oldspawn(s, false)
end
