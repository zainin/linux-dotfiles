local vicious = require("vicious")

--- Detect if we're on PC or laptop
local handle = io.popen("grep 4690 /proc/cpuinfo")
local tmp = handle:read("*a")
handle:close()
isLAPTOP = true
if (string.len(tmp) >= 1) then
    isLAPTOP = false
end

--- Detect available network interfaces
local handle = io.popen("ip -o link | awk '{sub(\":$\", \"\", $2); if ($2!=\"lo\") print $2}' | xargs")
local tmp = handle:read("*a")
handle:close()
local ifaces = {}
for i in string.gmatch(tmp, '%w+') do
    table.insert(ifaces, i)
end

--- Get speeds from all available interfaces - helper for vicious widget
function netspeed(direction, args)
    local speed = 0.0
    for _, i in pairs(ifaces) do
        speed = speed + args["{" .. i .. " " .. direction .. "}"]
    end
    return speed
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

--- Widget with an underline
function underline(w, ucolor)
    local bg = wibox.widget.background()
    bg:set_widget(w)
    bg:set_bg(theme.bg_normal)
    local margin = wibox.layout.margin()
    margin:set_widget(bg)
    margin:set_bottom(1)
    local bg2 = wibox.widget.background()
    bg2:set_widget(margin)
    bg2:set_bg(ucolor)
    local margin2 = wibox.layout.margin()
    margin2:set_widget(bg2)
    margin2:set_bottom(2)

    return margin2
end

--- seperator
separator = wibox.widget.textbox()
separator:set_text(" ")
--- Systray
-- create a systray with smaller icons

systray_widget = wibox.layout.margin()
systray_widget:set_widget(wibox.widget.systray())
systray_widget:set_margins(4)
systray_widget = underline(systray_widget, '#d9007b')

-- workaround - otherwise there's bit of an underline on the other screen
function systray(s)
    if s.index == 1 then
        return systray_widget
    end
end

--- layoutbox with underline
function underline_box(b)
    return underline(b, '#9999aa')
end

--- Load widget
-- 1 minute avg sys load
local load_content = wibox.widget.textbox()
vicious.register(load_content, vicious.widgets.uptime,
                "<span color='#94738c'><span font='FontAwesome 9'>  </span>$4 </span>")
loadwidget = underline(load_content, '#94738c')


--- Internet widget
-- enable caching
vicious.cache(vicious.widgets.net)

local ndown_content = wibox.widget.textbox()
-- laptop and PC have different interface names, plus wifi
vicious.register(ndown_content, vicious.widgets.net,
    function (widget, args)
        return "<span color='#ce5666'><span font='FontAwesome 9'>  </span>"
                .. netspeed('down_mb', args)
                .. "MB/s </span>"
    end, 1)
netdownwidget = underline(ndown_content, '#ce5666')

local nup_content = wibox.widget.textbox()
-- like with the previous one, laptop and pc
vicious.register(nup_content, vicious.widgets.net,
    function (widget, args)
        return "<span color='#87af5f'><span font='FontAwesome 9'>  </span>"
                .. netspeed('up_mb', args)
                .. "MB/s </span>"
    end, 1)
netupwidget = underline(nup_content, '#87af5f')

--- RAM widget

local m_content = wibox.widget.textbox()
vicious.register(m_content, vicious.widgets.mem,
                "<span color='#7788af'><span font='FontAwesome 9'> </span> $1% </span>")
memwidget = underline(m_content, '#7788af')

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
            return "<span color='#9c6523'><span font='FontAwesome 9'>  </span>"
                    .. args["{/ used_p}"] .. "%, "
                    .. args["{/home used_p}"] .. "% </span>"
        else
            return "<span color='#9c6523'><span font='FontAwesome 9'>  </span>"
                    .. args["{/ used_p}"] .. "%, "
                    .. args["{/home used_p}"] .. "%, "
                    .. args["{/media/storage-ext used_p}"] .. "% </span>"
        end
    end, 10)
fswidget = underline(fs_content, '#9c6523')

--- Clock widget

local c_content = wibox.widget.textbox()
vicious.register(c_content, vicious.widgets.date,
                "<span color='#4299d5'><span font='FontAwesome 9'>  </span>%a %d/%m/%y %R </span>")
clockwidget = underline(c_content, '#4299d5')

-- clicking the clock toggles a calander
clockwidget:connect_signal("button::press", function()
       awful.spawn.with_shell("gsimplecal")
    end)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
