--- {{{ Libraries

vicious = require("vicious")

-- Custom menu generator
--local menu_gen = require("menu")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
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
                         text = tostring(err) })
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
beautiful.useless_gap = 5

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
awful.layout.layouts = {
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

lain.layout.termfair.nmaster = 2
lain.layout.termfair.ncol = 1

lain.layout.centerfair.nmaster = 3
lain.layout.centerfair.ncol = 1

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    awful.screen.connect_for_each_screen(function(s)
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end)
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
	names		= { "一", "二", "三", "四", "五" },
	--names		= { "", "", "", "", "" },
   -- names   = { "α", "β", "γ", "δ", "ε" },
	layout	= { awful.layout.layouts[4], awful.layout.layouts[2], awful.layout.layouts[2], awful.layout.layouts[2], awful.layout.layouts[1] }
}
--theme.taglist_font = "IPAPGothic 9"


awful.screen.connect_for_each_screen(function(s)
	tags[s] = awful.tag(tags.names, s, tags.layout)
end)
--for s = 1, screen.count() do
--    -- Each screen has its own tag table.
--    tags[s] = awful.tag({ "一", "二", "三", "四", "五", "六"  }, s, layouts[1])
--end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
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

-- Menubar configuration
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


--- {{{ box the widget
function boxwidget(w, b, c, color)
    b:set_widget(c)
    b:set_bg(color)
    w:set_widget(b)
    w:set_margins(4)
    return w
end
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

local uptimewidget, u_background, u_content = wibox.layout.margin(), wibox.widget.background(), wibox.widget.textbox()
local u_content = wibox.widget.textbox()
vicious.register(u_content, vicious.widgets.uptime, "<span color='#080808' font='Cantarell 9'><span font='FontAwesome 9'>  </span>$4 </span>")
uptimewidget = boxwidget(uptimewidget, u_background, u_content, '#94738c')

--local uptime_margin = wibox.layout.margin()
--local uptimewidget = wibox.widget.background()
--local uptimewidget_content = wibox.widget.textbox()
--vicious.register(uptimewidget_content, vicious.widgets.uptime, "<span color='#080808' font='Cantarell 10'><span font='FontAwesome 9'>  </span>$4 </span>")
--uptimewidget:set_widget(uptimewidget_content)
--uptimewidget:set_bg("#94738c")
--uptime_margin:set_margins(3)
--uptime_margin:set_widget(uptimewidget)

--- {{{ Internet widget

--caching
vicious.cache(vicious.widgets.net)

netdownwidget, ndown_background, ndown_content = wibox.layout.margin(), wibox.widget.background(), wibox.widget.textbox()
--vicious.register(netdownwidget_content, vicious.widgets.net, "<span color='#ce5666'><span font='FontAwesome 9'>  </span>${eth0 down_mb}MB/s</span>", 1)
vicious.register(ndown_content, vicious.widgets.net,
    function (widget, args)
            if isLAPTOP then
                return "<span color='#080808'><span font='FontAwesome 9'>  </span>"
                        .. args["{enp0s25 down_mb}"] + args["{wlp3s0 down_mb}"]
                        .. "MB/s </span>"
            else
                return "<span color='#080808'><span font='FontAwesome 9'>  </span>"
                        .. args["{enp3s0 down_mb}"]
                        .. "MB/s </span>"
            end
    end, 1)
netdownwidget = boxwidget(netdownwidget, ndown_background, ndown_content, '#ce5666')
--netdownwidget:set_bg('#ce5666')

netupwidget, nup_background, nup_content = wibox.layout.margin(), wibox.widget.background(), wibox.widget.textbox()
--vicious.register(netupwidget_content, vicious.widgets.net, "<span color='#87af5f'><span font='FontAwesome 9'>  </span>${eth0 up_mb}MB/s</span> ", 1)
vicious.register(nup_content, vicious.widgets.net,
    function (widget, args)
            if isLAPTOP then
                return "<span color='#080808'><span font='FontAwesome 9'>  </span>"
                        .. args["{enp0s25 up_mb}"] + args["{wlp3s0 up_mb}"]
                        .. "MB/s </span>"
            else
                return "<span color='#080808'><span font='FontAwesome 9'>  </span>"
                        .. args["{enp3s0 up_mb}"]
                        .. "MB/s </span>"
            end
    end, 1)
netupwidget = boxwidget(netupwidget, nup_background, nup_content, '#87af5f')
--netupwidget:set_bg('#87af5f')

--- }}}

--- {{{ CPU temperature widget

--cputempicon = wibox.widget.imagebox()
--cputempicon:set_image(beautiful.widget_temp)
--local cputempwidget = wibox.widget.textbox()
--vicious.register(cputempwidget, vicious.widgets.thermal, "<span color='#ffaf5f'>$1°C</span> ", 10,{"coretemp.0","core"} )

--- }}}

--- {{{ RAM widget

local memwidget, m_background, m_content = wibox.layout.margin(), wibox.widget.background(), wibox.widget.textbox()
vicious.register(m_content, vicious.widgets.mem, "<span color='#080808'><span font='FontAwesome 9'> </span> $1% </span>")
memwidget = boxwidget(memwidget, m_background, m_content, '#7788af')
--memwidget:set_bg('#7788af')

--- }}}

--- {{{ Battery widget

local batwidget, b_background, b_content = wibox.layout.margin(), wibox.widget.background(), wibox.widget.textbox()
local cc = '#ce5666'
if isLAPTOP then
    vicious.register(b_content, vicious.widgets.bat,
        function (widget, x)
            if x[1] == "−" then
                return "<span color='#080808'>  " .. x[2] .. "% "
                        .. x[3] .. " </span>"
            else
                if x[3] == "N/A" then
                    return "<span color='#080808'> " .. x[2] .. "% </span>"
                else
                    return "<span color='#080808'> " .. x[2] .. "% "
                            .. x[3] .. " </span>"
                end
            end
        end, 10, "BAT0")
end
batwidget = boxwidget(batwidget, b_background, b_content, cc)

--{{<< UGLY HACK
local bat_aux = wibox.widget.textbox()
vicious.register(bat_aux, vicious.widgets.bat,
        function (widget, x)
            if x[1] == "−" then
                if x[2] <= 20 then
                    cc = '#ce5666'
                else
                    cc = '#5151ca'
                end
                batwidget = boxwidget(batwidget, b_background, b_content, cc)
                return ""
            else
                cc = '#6dd900'
                batwidget = boxwidget(batwidget, b_background, b_content, cc)
                return ""
            end
        end, 10, "BAT0")
--}}<< END OF UGLY HACK
--- }}}

--- {{{ FS widget

local fswidget, fs_background, fs_content = wibox.layout.margin(), wibox.widget.background(), wibox.widget.textbox()
--vicious.register(fswidget_content, vicious.widgets.fs, "<span color='#9c6523'><span font='FontAwesome 9'>  </span>${/ used_p}%, ${/home used_p}%, ${/media/storage-ext used_p}%</span> ", 10)
vicious.register(fs_content, vicious.widgets.fs,
    function (widget, args)
        if isLAPTOP then
            return "<span color='#080808'><span font='FontAwesome 9'>  </span>"
                    .. args["{/ used_p}"] .. "%, "
                    .. args["{/home used_p}"] .. "% </span>"
        else
            return "<span color='#080808'><span font='FontAwesome 9'>  </span>"
                    .. args["{/ used_p}"] .. "%, "
                    .. args["{/home used_p}"] .. "%, "
                    .. args["{/media/storage-ext used_p}"] .. "% </span> "
        end
    end, 10)
fswidget = boxwidget(fswidget, fs_background, fs_content, '#9c6523')
--fswidget:set_bg('#9c6523')

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

local clockwidget, c_background, c_content = wibox.layout.margin(), wibox.widget.background(), wibox.widget.textbox()
vicious.register(c_content, vicious.widgets.date, "<span color='#080808'><span font='FontAwesome 9'>  </span>%a %d/%m/%y %R </span>")
clockwidget = boxwidget(clockwidget, c_background, c_content, '#9999aa')
--clockwidget:set_bg('#9999aa')

clockwidget:connect_signal("button::press", function()
       awful.util.spawn_with_shell("gsimplecal")
    end)
--clockwidget:connect_signal("mouse::leave", function() end)

--- }}}

---- }}}


-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibox
-- Create a textclock widget
--mytextclock = awful.widget.textclock()

local systray = wibox.widget.systray()
local systray_margin = wibox.layout.margin()
systray_margin:set_margins(5)
systray_margin:set_widget(systray)
--right_layout:add(systray_margin)


-- Create a wibox for each screen and add it
mywibox = {}
status_bar = {} --bar with vicious widgets
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
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
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

awful.screen.connect_for_each_screen(function(s)
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Add widgets to the wibox
    mywibox[s]:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
        },
        mytasklist[s], -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            --wibox.widget.systray(),
            systray_margin,
            netdownwidget,
            netupwidget,
            uptimewidget,
            memwidget,
            fswidget,
            --if isLAPTOP then
            --    right_layout:add(batwidget)
            --end
            clockwidget,
            --mytextclock,
            mylayoutbox[s],
        },
    }
end)
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
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    --awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
    --          {description = "view previous", group = "tag"}),
    --awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
    --          {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey,           }, "Tab", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "`",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
        --end),

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
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "/", function () awful.util.spawn_with_shell(terminal_light) end,
              {description = "open a solarized terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "e", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[awful.screen.focused()]:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[awful.screen.focused()].widget,
                  awful.util.eval, nil,
                  awful.util.get_cache_dir() .. "/history_eval")
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

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
    awful.key({}, "F12", function () scratch.drop("termite -e 'vim /home/zainin/notes'", "top", "right", 500, 700) end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
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
                     size_hints_honor = false,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    { rule_any = {
        instance = {},
        class = {
            "Firefox",
            "Opera",
            "Chromium",
        },
        name = {},
        role = {}
      }, properties = { screen = 1, tag = tags[screen[1]][1],
                        border_width = 0 }
    },

    { rule = {
        class = "Wine"
        },
      properties = { screen = 1, tag = tags[screen[1]][5] }
    },

    { rule_any = {
        class = {
            "VirtualBox",
            "Wine"
        }
      }, properties = { border_width = 0 }
    },

    { rule_any = {
        class = {
            "Keepassx"
        },
        instance = {
            "plugin-container"
        },
      }, properties = { floating = true }
    },

    { rule = {
        class = "Steam"
        },
      properties = { screen = 1, tag = tags[screen[1]][3] }
    },

    { rule = {
        class = "Kodi"
      },
      properties = { screen = 1, tag = tags[screen[1]][2] }
    },

    -- Add titlebars to normal clients and dialogs
    --{ rule_any = {type = { "normal", "dialog" }
    --  }, properties = { titlebars_enabled = true }
    --},
    { rule_any = {type = { "dialog" }
      }, properties = { titlebars_enabled = true }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
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

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
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
