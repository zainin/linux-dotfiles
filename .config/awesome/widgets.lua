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
function boxwidget(w, b, c, color)
    b:set_widget(c)
    b:set_bg(color)
    w:set_widget(b)
    w:set_margins(4)
    return w
end

--- Load widget
-- 1 minute avg sys load
loadwidget = wibox.layout.margin()
local u_background, u_content = wibox.widget.background(),
                                wibox.widget.textbox()
local u_content = wibox.widget.textbox()
vicious.register(u_content, vicious.widgets.uptime,
                "<span color='#080808'><span font='FontAwesome 9'>  </span>$4 </span>")
loadwidget = boxwidget(loadwidget, u_background, u_content, '#94738c')


--- Internet widget
-- enable caching
vicious.cache(vicious.widgets.net)

netdownwidget = wibox.layout.margin()
local ndown_background, ndown_content = wibox.widget.background(),
                                        wibox.widget.textbox()
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
netdownwidget = boxwidget(netdownwidget, ndown_background, ndown_content, '#ce5666')

netupwidget = wibox.layout.margin()
local nup_background, nup_content = wibox.widget.background(),
                                    wibox.widget.textbox()
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
netupwidget = boxwidget(netupwidget, nup_background, nup_content, '#87af5f')

--- RAM widget

memwidget = wibox.layout.margin()
local m_background, m_content = wibox.widget.background(),
                                wibox.widget.textbox()
vicious.register(m_content, vicious.widgets.mem,
                "<span color='#080808'><span font='FontAwesome 9'> </span> $1% </span>")
memwidget = boxwidget(memwidget, m_background, m_content, '#7788af')

--- Battery widget

batwidget = wibox.layout.margin()
local b_background, b_content = wibox.widget.background(),
                                wibox.widget.textbox()
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
    batwidget = boxwidget(batwidget, b_background, b_content, cc)
else
    badwidget = ""
end

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
                batwidget = boxwidget(batwidget, b_background, b_content, cc)
                return ""
            else
                cc = '#6dd900'
                batwidget = boxwidget(batwidget, b_background, b_content, cc)
                return ""
            end
        end, 10, "BAT0")
--}}

--- FS widget

fswidget = wibox.layout.margin()
local fs_background, fs_content = wibox.widget.background(),
                                  wibox.widget.textbox()
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
fswidget = boxwidget(fswidget, fs_background, fs_content, '#9c6523')

--- Clock widget

clockwidget = wibox.layout.margin()
local c_background, c_content = wibox.widget.background(),
                                wibox.widget.textbox()
vicious.register(c_content, vicious.widgets.date,
                "<span color='#080808'><span font='FontAwesome 9'>  </span>%a %d/%m/%y %R </span>")
clockwidget = boxwidget(clockwidget, c_background, c_content, '#9999aa')

-- clicking the clock toggles a calander
clockwidget:connect_signal("button::press", function()
       awful.util.spawn_with_shell("gsimplecal")
    end)
