-- zainin
-- awesome 3.4

require("vicious")
-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Widget and layout library
require("wibox")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

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
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/zainin/.config/awesome/themes/default/theme.lua")

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
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
--    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "一", "二", "三", "四", "五", "六"  }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- }}}

-- {{{ ICONS
upicon = wibox.widget.imagebox()
upicon:set_image("/home/zainin/.icons/xbm8x8/arch_10x10.png")
cpuicon = wibox.widget.imagebox()
cpuicon:set_image("/home/zainin/.icons/xbm8x8/cpu.png")
memicon = wibox.widget.imagebox()
memicon:set_image("/home/zainin/.icons/xbm8x8/mem.png")
batFicon = wibox.widget.imagebox()
batFicon:set_image("/home/zainin/.icons/xbm8x8/bat_full_02.png")
fsicon = wibox.widget.imagebox()
fsicon:set_image("/home/zainin/.icons/xbm8x8/fs_02.png")
mpdicon = wibox.widget.imagebox()
mpdicon:set_image("/home/zainin/.icons/xbm8x8/phones.png")
--- }}}

--- {{{ COMMANDS
local commands = {}
--volbar = awful.widget.progressbar()
--volbar:set_width(10)
--volbar:set_height(18)
--volbar:set_vertical(true)
--volbar:set_background_color("#1a1918")
--volbar:set_color("#ff6500")

--{ audio raise/lower volume
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
--}

--{ brightness
function get_brightness()
	local f = io.popen("xbacklight -get | awk -F. '{print $1 }'")
	local aux = f:read("*all")
	f.close(f)
	return aux
end
function bright(x)
	local level
	if x == "up" then
		awful.util.spawn("xbacklight +20")
		level = " +20% brightness [" .. get_brightness() .. "]"
	else
		awful.util.spawn("xbacklight -20")
		level = " -20% brightness [" .. get_brightness() .. "]"
	end
	level = level:gsub('\n', '')
	naughty.notify({ text = level, title = 'Screen brightness', position = 'top_right', timeout = 5, replaces_id=777 }).id=777
end
--}
commands.www = "opera"
commands.home = "pcmanfm ~"
-- }}}

-- {{{ WIDGETS
local separator = wibox.widget.textbox()
separator:set_markup("<span foreground='red'> |</span>")

local uptimewidget = wibox.widget.textbox()
vicious.register(uptimewidget, vicious.widgets.uptime, "<span foreground='white'>$1d$2h$3m</span>")
local cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, "<span foreground='white'>$2%</span> / <span foreground='white'>$3%</span> / <span foreground='white'>$4%</span> / <span foreground='white'>$5%</span>")
local memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, "<span foreground='white'>$1% $2/$3</span><span foreground='red'>/</span><span foreground='white'>$5% $6/$7</span>")
local batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat, "<span foreground='#FF6600'>bat: </span><span foreground='white'>$1$2% </span><span foreground='gray'>left: </span><span foreground='white'>$3</span>", 60, "BAT0")
local fswidget = wibox.widget.textbox()
vicious.register(fswidget, vicious.widgets.fs,
	function (widget, args)
		return '<span foreground=\'gray\'>/ </span><span foreground=\'white\'>'..args["{/ used_p}"]..'%['..args["{/ avail_gb}"]..'GB]</span><span foreground=\'gray\'> /home </span><span foreground=\'white\'>'..args["{/home used_p}"]..'%['..args["{/home avail_gb}"]..'GB]</span>'
	end)
local mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd,
	function (widget, args)
		if args["{state}"] == "Stop" then
			return '<span foreground=\'gray\'>MPD stopped</span>'
		else
			if args["{state}"] == "Pause" then
				return '<span foreground=\'white\'>^'..args["{Artist}"]..' - '..args["{Title}"]..'</span>'
			else
				--return '<span foreground=\'white\'>'..args[\"{Artist}\"]..' - '..args[\"{Title}\"]..'</span>'
				return args["{Artist}"]..' - '.. args["{Title}"]
			end
		end
	end)
local clockwidget = wibox.widget.textbox()
vicious.register(clockwidget, vicious.widgets.date, "%d/%m/%g %R")
--local volwidget = wibox.widget.textbox()
--vicious.register(volwidget, vicious.widgets.volume, "Master", "Master")
--local gmailwidget = wibox.widget.textbox()
--vicious.register(gmailwidget, vicious.widgets.gmail, "GMail: ${count}| ")

--local netspeedwidget = wibox.widget.textbox()
--vicious.register(netspeedwidget, vicious.widgets.net, 
--	function (widget, args)
--		return args["{eth0 down_kb}"]..'<span foreground=\'#FF6600\'>↓</span>'
--	end)

--local wifiwidget = wibox.widget.textbox()
--vicious.register(wifiwidget, vicious.widgets.wifi, "${link}", 5, "wlan0")
-- }}}


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
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
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
	left_statusbar:add(upicon) left_statusbar:add(uptimewidget) left_statusbar:add(separator)
	left_statusbar:add(cpuicon) left_statusbar:add(cpuwidget) left_statusbar:add(separator)
	left_statusbar:add(memicon) left_statusbar:add(memwidget) left_statusbar:add(separator)
	left_statusbar:add(batwidget) left_statusbar:add(separator)
	left_statusbar:add(fsicon) left_statusbar:add(fswidget)

	local right_statusbar = wibox.layout.fixed.horizontal()
	right_statusbar:add(mpdwidget)

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
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

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
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

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
	awful.key({}, "XF86HomePage",	function () awful.util.spawn_with_shell(commands.www) end),
	awful.key({ modkey,			}, "a",	function () awful.util.spawn_with_shell("exec ncmpcpp toggle") end),
	awful.key({ modkey,			}, "z",	function () awful.util.spawn_with_shell("exec ncmpcpp stop") end),
	awful.key({ modkey,			}, "c",	function () awful.util.spawn_with_shell("exec ncmpcpp next") end),
	awful.key({}, "XF86AudioRaiseVolume",function () vol("up") end),
	awful.key({}, "XF86AudioLowerVolume",function () vol("down") end),
	awful.key({}, "XF86AudioMute",function () vol("toggle") end),
	awful.key({}, "XF86MonBrightnessUp", function () bright("up") end),
	awful.key({}, "XF86MonBrightnessDown", function () bright("down") end),
	awful.key({ modkey, "Control" }, "h", function () awful.util.spawn_with_shell(commands.home) end),
	awful.key({ modkey, "Control" }, "l",	function () awful.util.spawn_with_shell("exec xscreensaver-command -lock") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
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
   keynumber = math.min(9, math.max(#tags[s], keynumber));
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
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
	{ rule = { class = "Firefox" },
	  properties = { tag = tags[1][1] } },
	{ rule = { class = "Opera" },
	  properties = { tag = tags[1][1] } },
	{ rule = { class = "Chromium" },
	  properties = { tag = tags[1][1] } },
	{ rule = { class = "Wine" },
	  properties = { tag = tags[1][5] } },
	{ rule = { class = "Pidgin" },
	  properties = { tag = tags[1][4] } },
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
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
