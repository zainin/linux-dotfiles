-------------------
--    zainin     --
--  awesome 3.5  --
-------------------

--- {{{ Libraries

vicious = require("vicious")

-- Custom menu generator
--local menu_gen = require("menu")

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
-- lain
local lain = require("lain")

-- Applications menu
--local xdg_menu = require("archmenu")

-- dynamic tagging
local eminent = require("eminent")

local scratch = require("scratch")

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

--- Detect if we're on PC or laptop
local handle = io.popen("grep 4690 /proc/cpuinfo")
local tmp = handle:read("*a")
handle:close()
isLAPTOP = true
if (string.len(tmp) >= 1) then
    isLAPTOP = false
end

-- Themes define colours, icons, and wallpapers
active_theme = themes .. "/rv1"
beautiful.init(active_theme .. "/theme.lua")

widget_bg_alt = "#1c1c1c"
widget_font_alt = "#8f8d8d"

-- This is used later as the default terminal and editor to run.
--terminal = "urxvtc"
terminal = "termite"
terminal_light = "termite -c ~/.config/termite/solarized"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    --awful.layout.suit.tile,
    lain.layout.uselesstile,
    --awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.max,
    lain.layout.termfair,
    lain.layout.centerfair,
    --lain.layout.cascade,
    --lain.layout.cascadetile,
    lain.layout.centerwork,
}
awful.layout.layouts = layouts

lain.layout.termfair.nmaster = 2
lain.layout.termfair.ncol = 1

lain.layout.centerfair.nmaster = 3
lain.layout.centerfair.ncol = 1

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
	names		= { "一", "二", "三", "四", "五" },
	--names		= { "", "", "", "", "" },
   -- names   = { "α", "β", "γ", "δ", "ε" },
	layout	= { layouts[4], layouts[2], layouts[2], layouts[2], layouts[1] }
}
--theme.taglist_font = "IPAPGothic 9"


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

--cheatSheets = menu_gen.gen( 'zathura', home .. '/studia/cisco/', '*pdf', '/usr/share/icons/oxygen/16x16/mimetypes/application-pdf.png')

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal },
                                    { "applications", xdgmenu }
                                  }
                        })

mylauncher = awful.widget.launcher({ --image = beautiful.awesome_icon,
                                     menu = mymainmenu })


--Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}


--- {{{ Music controls
mctl = {}
mctl.play = scripts .. "/music-ctl.sh play"
mctl.next = scripts .. "/music-ctl.sh next"
mctl.stop = scripts .. "/music-ctl.sh stop"
--- }}}

-- {{{ volume controls
vol = {}
vol.up = scripts .. "/vol-ctl.sh -i 5"
vol.down = scripts .. "/vol-ctl.sh -d 5"
vol.mute = scripts .. "/vol-ctl.sh -t"
--- }}}

--- {{{ brightness
--function get_brightness()
--    local f = io.popen("sudo light -c | awk -F. '{print $1 }'")
--	local aux = f:read("*all")
--	f.close(f)
--	return aux
--end
--function bright(x)
--	local level
--	if x == "up" then
--		awful.util.spawn("sudo light -a 12")
--		level = " brightness up [" .. get_brightness() .. "%]"
--	else
--		awful.util.spawn("sudo light -s 12")
--		level = " brightness down [" .. get_brightness() .. "%]"
--	end
--	level = level:gsub('\n', '')
--	naughty.notify({ text = level, title = 'Screen brightness', position = 'top_right', timeout = 5, replaces_id=777 }).id=777
--end
-- }}}

-- {{{ WIDGETS

local separator = wibox.widget.textbox()
separator:set_text(" ")

--- {{{ Uptime widget

local uptimewidget = wibox.widget.textbox()
vicious.register(uptimewidget, vicious.widgets.uptime, "<span color='#94738c'><span font='FontAwesome 9'>  </span>$4 </span>")

--- }}}

--- {{{ Internet widget

--caching
vicious.cache(vicious.widgets.net)

netdownwidget = wibox.widget.textbox()
--vicious.register(netdownwidget, vicious.widgets.net, "<span color='#ce5666'><span font='FontAwesome 9'>  </span>${eth0 down_mb}MB/s</span>", 1)
vicious.register(netdownwidget, vicious.widgets.net,
    function (widget, args)
            if isLAPTOP then
                return "<span color='#ce5666'><span font='FontAwesome 9'>  </span>"
                        .. args["{enp0s25 down_mb}"] + args["{wlp3s0 down_mb}"]
                        .. "MB/s</span>"
            else
                return "<span color='#ce5666'><span font='FontAwesome 9'>  </span>"
                        .. args["{enp3s0 down_mb}"]
                        .. "MB/s</span>"
            end
    end, 1)

netupwidget = wibox.widget.textbox()
--vicious.register(netupwidget, vicious.widgets.net, "<span color='#87af5f'><span font='FontAwesome 9'>  </span>${enp3s0 up_mb}MB/s</span> ", 1)
vicious.register(netupwidget, vicious.widgets.net,
    function (widget, args)
            if isLAPTOP then
                return "<span color='#87af5f'><span font='FontAwesome 9'>  </span>"
                        .. args["{enp0s25 up_mb}"] + args["{wlp3s0 up_mb}"]
                        .. "MB/s</span>"
            else
                return "<span color='#87af5f'><span font='FontAwesome 9'>  </span>"
                        .. args["{enp3s0 up_mb}"]
                        .. "MB/s</span>"
            end
    end, 1)

--- }}}

--- {{{ CPU temperature widget

--cputempicon = wibox.widget.imagebox()
--cputempicon:set_image(beautiful.widget_temp)
--local cputempwidget = wibox.widget.textbox()
--vicious.register(cputempwidget, vicious.widgets.thermal, "<span color='#ffaf5f'>$1°C</span> ", 10,{"coretemp.0","core"} )

--- }}}

--- {{{ RAM widget

local memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, "<span color='#7788af'><span font='FontAwesome 9'></span> $1% </span>")

--- }}}

--- {{{ Battery widget

local batwidget = wibox.widget.textbox()
if isLAPTOP then
    vicious.register(batwidget, vicious.widgets.bat,
        function (widget, x)
            if x[1] == "−" then
                return "<span color='#ce5666'>  " .. x[2] .. "% "
                        .. x[3] .. "</span>"
            else
                if x[3] == "N/A" then
                    return "<span color='#ce5666'> " .. x[2] .. "%</span>"
                else
                    return "<span color='#ce5666'> " .. x[2] .. "% "
                            .. x[3] .. "</span>"
                end
            end
        end, 10, "BAT0")
end

--- }}}

--- {{{ FS widget

local fswidget = wibox.widget.textbox()
--vicious.register(fswidget, vicious.widgets.fs, "<span color='#9c6523'><span font='FontAwesome 9'>  </span>${/ used_p}%, ${/home used_p}%, ${/media/storage-ext used_p}%</span> ", 10)
vicious.register(fswidget, vicious.widgets.fs,
    function (widget, args)
        if isLAPTOP then
            return "<span color='#9c6523'><span font='FontAwesome 9'>  </span>"
                    .. args["{/ used_p}"] .. "%, "
                    .. args["{/home used_p}"] .. "%</span>"
        else
            return "<span color='#9c6523'><span font='FontAwesome 9'>  </span>"
                    .. args["{/ used_p}"] .. "%, "
                    .. args["{/home used_p}"] .. "%, "
                    .. args["{/media/storage-ext used_p}"] .. "%</span> "
        end
    end, 10)

fswidget:connect_signal("button::press", function()
        awful.util.spawn_with_shell('notify-send "$(df -h)"')
    end)

--- }}}

--- {{{ MPD widget

--local mpdwidget_content = wibox.widget.textbox()
--local mpdwidget = wibox.widget.background()
--vicious.register(mpdwidget_content, vicious.widgets.mpd,
--	function (widget, args)
--		if args["{state}"] == "Stop" then
--			return '<span color=\''..widget_font_alt..'\'>MPD stopped</span>'
--		else
--			if args["{state}"] == "Pause" then
--				return '<span color=\''..widget_font_alt..'\'>^'..args["{Artist}"]..' - '..args["{Title}"]..'</span>'
--			else
--				--return '<span color=\'white\'>'..args[\"{Artist}\"]..' - '..args[\"{Title}\"]..'</span>'
--				return args["{Artist}"]..' - '.. args["{Title}"]
--			end
--		end
--	end)
--mpdwidget:set_widget(mpdwidget_content)
--mpdwidget:set_bg(widget_bg_alt)

--- }}}

--- {{{ Volume widget

--local volwidget = wibox.widget.textbox()
--vicious.register(volwidget, vicious.widgets.volume, "[$2$1]", 1, "Master")

--- }}}

---- }}}

---- {{{ top bar

--- {{{ Weather widget

--local weatherwidget = wibox.widget.textbox()
--vicious.register(weatherwidget, vicious.widgets.weather,
--  function (widget, args)
--    return ' '..args["{tempc}"]..'°C | '
--  end, 1800, "EPWR")

--- }}}

--- {{{ Clock widget

local clockwidget = wibox.widget.textbox()
vicious.register(clockwidget, vicious.widgets.date, "<span font='FontAwesome 9'>  </span>%a %d/%m/%g %R ")

clockwidget:connect_signal("button::press", function()
       awful.util.spawn_with_shell("notify-send clock")
    end)
--clockwidget:connect_signal("mouse::leave", function() end)

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
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
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
	--status_bar[s] = awful.wibox({ position = "bottom", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    --if s == 1 then right_layout:add(wibox.widget.systray()) end
    if s == 1 then
        local systray = wibox.widget.systray()
        local systray_margin = wibox.layout.margin()
        systray_margin:set_margins(5)
        systray_margin:set_widget(systray)
        right_layout:add(systray_margin)
    end
    -- My widgets
    right_layout:add(netdownwidget)
    right_layout:add(netupwidget)
    right_layout:add(uptimewidget)
    right_layout:add(memwidget)
    right_layout:add(fswidget)
    if isLAPTOP then
        right_layout:add(batwidget)
    end
    right_layout:add(clockwidget)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
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
    --awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    --awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey,           }, "Tab", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "`",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Directional Navigation
    awful.key({ modkey }, "Down",
        function () awful.client.focus.bydirection("down")
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ modkey }, "Up",
        function () awful.client.focus.bydirection("up")
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ modkey }, "Left",
        function () awful.client.focus.bydirection("left")
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ modkey }, "Right",
        function () awful.client.focus.bydirection("right")
            if client.focus then
                client.focus:raise()
            end
        end),


    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "/", function () awful.util.spawn_with_shell(terminal_light) end),
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
    -- [[ Volume keys
    -- [[[ mute
	awful.key({ modkey,			}, "F1" ,function () awful.util.spawn_with_shell(vol.mute) end),
	awful.key({}, "XF86AudioMute" ,function () awful.util.spawn_with_shell(vol.mute) end),
    -- [[[ up
	awful.key({ modkey,			}, "F3",function () awful.util.spawn_with_shell(vol.up) end),
	awful.key({}, "XF86AudioRaiseVolume",function () awful.util.spawn_with_shell(vol.up) end),
    -- [[[ down
	awful.key({ modkey,			}, "F2" ,function () awful.util.spawn_with_shell(vol.down) end),
	awful.key({}, "XF86AudioLowerVolume" ,function () awful.util.spawn_with_shell(vol.down) end),
    -- [[ Music control
    -- [[[ play/pause
	awful.key({ modkey,			}, "a",	function () awful.util.spawn_with_shell(mctl.play) end),
	awful.key({}, "XF86AudioPlay",	function () awful.util.spawn_with_shell(mctl.play) end),
    -- [[[ next
	awful.key({ modkey,			}, "c",	function () awful.util.spawn_with_shell(mctl.next) end),
	awful.key({}, "XF86AudioNext",	function () awful.util.spawn_with_shell(mctl.next) end),
    -- [[[ stop
	awful.key({}, "XF86AudioStop",	function () awful.util.spawn_with_shell(mctl.stop) end),
	awful.key({ modkey,			}, "z",	function () awful.util.spawn_with_shell(mctl.stop) end),
    -- [[ Brightness control
	--awful.key({}, "XF86MonBrightnessUp", function () bright("up") end),
	--awful.key({}, "XF86MonBrightnessDown", function () bright("down") end),
    -- [[ Screen lock
	--awful.key({ modkey, "Control" }, "l",	function () awful.util.spawn_with_shell("exec i3lock -c 000000 -d") end),
    -- [[ Multiscreen reload
	awful.key({ modkey, "Control" }, "m", function () awful.util.spawn_with_shell("exec autorandr -c --force") end),
    -- [[ Screenshot
    awful.key({}, "Print", function () awful.util.spawn_with_shell("maim -m on \'/media/storage-ext/Images/screenshots/'$(date +%f-%t)'.png\'") end),
    --awful.key({}, "Print", function () awful.util.spawn_with_shell("maim -m on -s \'/media/storage-ext/Images/screenshots/%'$(date +%f-%t)'.png\'") end),
    awful.key({}, "F12", function () scratch.drop("termite -e 'vim /home/zainin/notes'", "top", "right", 500, 700) end),

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
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
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
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false } },
    --{ rule = { class = "MPlayer" },
    --  properties = { floating = true } },
    --{ rule = { class = "mplayer2" },
    --  properties = { floating = true } },
    { rule = { class = "mpv" },
      properties = { floating = true } },
    --{ rule = { class = "gimp" },
    --  properties = { floating = true } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][1], border_width = 0 } },
    { rule = { class = "Opera" },
      properties = { tag = tags[1][1], border_width = 0 } },
    { rule = { class = "Chromium" },
      properties = { tag = tags[1][1], border_width = 0 } },
    { rule = { class = "Wine" },
      properties = { tag = tags[1][5] } },
	--{ rule = { class = "Pidgin" },
	--  properties = { tag = tags[1][4] } },
    { rule = { class = "VirtualBox" },
      properties = { border_width = 0 } },
    { rule = { class = "Wine" },
      properties = { border_width = 0 } },
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
    --  { rule = { instance = "Steam", name = "Steam" },
    --    properties = { maximized_vertical=true, maximized_horizontal=true } },
    { rule = { class = "Steam" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Kodi" },
      properties = { tag = tags[1][2] } }, --, fullscreen = true } },
    { rule = { class = "Keepassx" },
      properties = { floating = true }},

    --{ rule = { name = "Timer" },
    --properties = { floating = true } },
    { rule = { type = "dock" },
    properties = { floating = true } },

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
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
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
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

awful.util.spawn_with_shell(scripts .. "/autostart.sh")

-- disable startup-notification globally
local oldspawn = awful.util.spawn
awful.util.spawn = function (s)
    oldspawn(s, false)
end
