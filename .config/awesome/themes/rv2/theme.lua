---------
-- rv2 --
---------

theme = {}
theme.confdir = os.getenv("HOME") .. "/.config/awesome/themes/rv2"

--== Fonts
theme.font          = "Roboto Mono 9"
theme.tasklist_font = "Roboto 8.5"
theme.taglist_font  = "binfont 13"

--== Colors
theme.bg_normal   = "#17191a"
theme.bg_focus    = theme.bg_normal
theme.bg_urgent   = theme.bg_normal
theme.bg_minimize = theme.bg_normal
theme.bg_systray  = theme.bg_normal

theme.bg_image_focus = theme.confdir .. "/tasklist/sel.png"

theme.fg_normal   = "#9999aa"
theme.fg_focus    = "#7788af"
theme.fg_urgent   = "#9c6523"
theme.fg_minimize = "#444444"

--== Taglist
theme.taglist_bg_focus = "#ffffff00"
theme.taglist_fg_focus = theme.fg_normal

--== Borders
theme.border_width  = 1
theme.border_normal = "#202020"
theme.border_focus  = "#758589"
theme.border_marked = "#17191a"

--== Menu
theme.menu_height       = 15
theme.menu_width        = 155
theme.menu_border_width = 0
theme.menu_fg_normal    = "#aaaaaa"
theme.menu_fg_focus     = "#7788af"
theme.menu_bg_normal    = "#080808"   --background menu
theme.menu_bg_focus     = "#080808"

--== Awesome icon
theme.awesome_icon      = "/usr/share/awesome/icons/awesome16.png"

--== Taglist icons
theme.taglist_squares_sel   = theme.confdir .. "/taglist/sel.png"
theme.taglist_squares_unsel = theme.confdir .. "/taglist/unsel.png"

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

--== titlebar
theme.titlebar_close_button_normal = theme.confdir .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = theme.confdir .. "/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal_inactive = theme.confdir .. "/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus_inactive  = theme.confdir .. "/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = theme.confdir .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = theme.confdir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = theme.confdir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = theme.confdir .. "/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = theme.confdir .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = theme.confdir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = theme.confdir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = theme.confdir .. "/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = theme.confdir .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = theme.confdir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = theme.confdir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = theme.confdir .. "/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme.confdir .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.confdir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = theme.confdir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = theme.confdir .. "/titlebar/maximized_focus_active.png"

return theme
