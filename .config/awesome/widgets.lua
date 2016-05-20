local vicious = require("vicious")

--- Detect if we're on PC or laptop
local handle = io.popen("grep 4690 /proc/cpuinfo")
local tmp = handle:read("*a")
handle:close()
isLAPTOP = true
if (string.len(tmp) >= 1) then
    isLAPTOP = false
end

--- Pack the widget in a box
function boxwidget(w, color)
    local background = wibox.widget.background()
    local margin = wibox.layout.margin()
    background:set_widget(w)
    background:set_bg(color)
    margin:set_widget(background)
    margin:set_margins(4)
    return margin
end

--- Systray
-- create a systray with smaller icons

systray = wibox.layout.margin()
systray:set_widget(wibox.widget.systray())
systray:set_margins(4)

--- Load widget
-- 1 minute avg sys load
local load_content = wibox.widget.textbox()
vicious.register(load_content, vicious.widgets.uptime,
                "<span color='#080808'><span font='FontAwesome 9'>  </span>$4 </span>")
loadwidget = boxwidget(load_content, '#94738c')


--- Internet widget
-- enable caching
vicious.cache(vicious.widgets.net)

local ndown_content = wibox.widget.textbox()
-- laptop and PC have different interface names, plus wifi
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
netdownwidget = boxwidget(ndown_content, '#ce5666')

local nup_content = wibox.widget.textbox()
-- like with the previous one, laptop and pc
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
netupwidget = boxwidget(nup_content, '#87af5f')

--- RAM widget

local m_content = wibox.widget.textbox()
vicious.register(m_content, vicious.widgets.mem,
                "<span color='#080808'><span font='FontAwesome 9'> </span> $1% </span>")
memwidget = boxwidget(m_content, '#7788af')

--- Battery widget

if isLAPTOP then
    local b_content = wibox.widget.textbox()
    local cc = '#ce5666'
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
    batwidget = boxwidget(b_content, cc)

    --{{ ugly hack for color background change, based on battery capacity
    local bat_aux = wibox.widget.textbox()
    vicious.register(bat_aux, vicious.widgets.bat,
            function (widget, x)
                if x[1] == "−" then
                    if x[2] <= 20 then
                        cc = '#ce5666'
                    else
                        cc = '#5151ca'
                    end
                    batwidget = boxwidget(b_content, cc)
                    return ""
                else
                    cc = '#6dd900'
                    batwidget = boxwidget(b_content, cc)
                    return ""
                end
            end, 10, "BAT0")
end
--}}

--- FS widget

local fs_content = wibox.widget.textbox()
-- different mounts on laptop and PC
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
fswidget = boxwidget(fs_content, '#9c6523')

--- Clock widget

local c_content = wibox.widget.textbox()
vicious.register(c_content, vicious.widgets.date,
                "<span color='#080808'><span font='FontAwesome 9'>  </span>%a %d/%m/%y %R </span>")
clockwidget = boxwidget(c_content, '#9999aa')

-- clicking the clock toggles a calander
clockwidget:connect_signal("button::press", function()
       awful.spawn.with_shell("gsimplecal")
    end)
