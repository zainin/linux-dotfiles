---------
-- RV1 --
---------

theme = {}
theme.confdir = os.getenv("HOME") .. "/.config/awesome/themes/rv1"

--== Fonts
theme.font          = "Cantarell 9"
theme.taglist_font  = "FontAwesome 9"

--== Colors
theme.bg_normal     = "#080808"
--theme.bg_normal     = "#1A1A1A"
theme.bg_focus      = "#080808"
theme.bg_urgent     = "#080808"
theme.bg_minimize   = "#080808"
theme.bg_systray = theme.bg_normal

theme.fg_normal     = "#9999aa"
theme.fg_focus      = "#7788af"
--theme.fg_normal     = "#686868"
--theme.fg_focus      = "#d1d1e8"
theme.fg_urgent     = "#94738c"
theme.fg_minimize   = "#444444"

--== Taglist
theme.taglist_bg_focus = "#ce5666"
theme.taglist_fg_focus = "#000000"

--== Borders
theme.border_width  = 1
theme.border_normal = "#202020"
theme.border_focus  = "#ce5666"
theme.border_marked = "#91231c"

--== Menu
theme.menu_height       = 15
theme.menu_width        = 155
theme.menu_border_width = 0
theme.menu_fg_normal    = "#aaaaaa"
theme.menu_fg_focus     = "#7788af"
theme.menu_bg_normal    = "#080808"   --background menu
theme.menu_bg_focus     = "#080808"

--[[
-- {{{  Widget icons

theme.arrow_right       = theme.confdir .. "/icons/arrow-right.png"
theme.arrow_right_alt   = theme.confdir .. "/icons/arrow-right-alt.png"
theme.arrow_left        = theme.confdir .. "/icons/arrow-left.png"
theme.arrow_left_alt    = theme.confdir .. "/icons/arrow-left-alt.png"

theme.widget_uptime     = theme.confdir .. "/widgets/magenta/ac_01.png"
theme.widget_cpu        = theme.confdir .. "/widgets/magenta/cpu.png"
theme.widget_temp       = theme.confdir .. "/widgets/yellow/temp.png"
theme.widget_mem        = theme.confdir .. "/widgets/cyan/mem.png"
theme.widget_fs         = theme.confdir .. "/widgets/cyan/fs_02.png"
theme.widget_netdown    = theme.confdir .. "/widgets/red/net_down_03.png"
theme.widget_netup      = theme.confdir .. "/widgets/green/net_up_03.png"
theme.widget_gmail      = theme.confdir .. "/widgets/magenta/mail.png"
theme.widget_sys        = theme.confdir .. "/widgets/green/dish.png"
theme.widget_pac        = theme.confdir .. "/widgets/green/pacman.png"
theme.widget_batt       = theme.confdir .. "/widgets/red/bat_full_01.png"
theme.widget_clock      = theme.confdir .. "/widgets/cyan/clock.png"
theme.widget_vol        = theme.confdir .. "/widgets/cyan/spkr_01.png"
-- }}}
--]]

--== Awesome icon
theme.awesome_icon      = "/usr/share/awesome/icons/awesome16.png"

--== Taglist icons
theme.taglist_squares_sel   = theme.confdir .. "/taglist/squaref_b.png"
theme.taglist_squares_unsel = theme.confdir .. "/taglist/square_b.png"

--theme.taglist_squares_resize = "false"

--== Tasklist icons
theme.tasklist_floating_icon = theme.confdir .. "/tasklist/floating.png"

--== Layout icons
theme.layout_tile       = theme.confdir .. "/layouts/tile.png"
theme.layout_tileleft   = theme.confdir .. "/layouts/tileleft.png"
theme.layout_tilebottom = theme.confdir .. "/layouts/tilebottom.png"
theme.layout_tiletop    = theme.confdir .. "/layouts/tiletop.png"
theme.layout_fairv      = theme.confdir .. "/layouts/fairv.png"
theme.layout_fairh      = theme.confdir .. "/layouts/fairh.png"
theme.layout_spiral     = theme.confdir .. "/layouts/spiral.png"
theme.layout_dwindle    = theme.confdir .. "/layouts/dwindle.png"
theme.layout_max        = theme.confdir .. "/layouts/max.png"
theme.layout_fullscreen = theme.confdir .. "/layouts/fullscreen.png"
theme.layout_magnifier  = theme.confdir .. "/layouts/magnifier.png"
theme.layout_floating   = theme.confdir .. "/layouts/floating.png"

--== lain config
theme.useless_gap_width  = 25
theme.layout_termfair    = theme.confdir .. "/layouts/termfair.png"
theme.layout_centerfair  = theme.confdir .. "/layouts/centerfair.png"
theme.layout_cascade     = theme.confdir .. "/layouts/cascade.png"
theme.layout_cascadetile = theme.confdir .. "/layouts/cascadebrowse.png"
theme.layout_centerwork  = theme.confdir .. "/layouts/centerwork.png"
theme.layout_uselesstile = theme.confdir .. "/layouts/uselesstile.png"

return theme
