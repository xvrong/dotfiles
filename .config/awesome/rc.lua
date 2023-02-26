-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

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
-- Declarative object management
local ruled = require("ruled")
-- local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened" .. (startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

awful.screen.set_auto_dpi_enabled(true)

screen.connect_signal("added", function(s) awesome.restart() end)
screen.connect_signal("removed", function(s) awesome.restart() end)

local xrandr = require("xrandr")
-- {{{ Autostart
local is_restart
do
    local restart_detected
    is_restart = function()
        -- If we already did restart detection: Just return the result
        if restart_detected ~= nil then
            return restart_detected
        end

        -- Register a new boolean
        awesome.register_xproperty("awesome_restart_check", "boolean")
        -- Check if this boolean is already set
        restart_detected = awesome.get_xproperty("awesome_restart_check") ~= nil
        -- Set it to true
        awesome.set_xproperty("awesome_restart_check", true)
        -- Return the result
        return restart_detected
    end
end

local autorun = {
    app = {
    },
    cmd = {
        "fcitx5",
        "picom --daemon",
        "~/Projects/Script/link_DLUT/python_env_linux/bin/python ~/Projects/Script/link_DLUT/link_dlut.py",
        "greenclip daemon"
    }
}


if not is_restart() then
    for i = 1, #autorun.app do
        awful.spawn(autorun.app[i], false)
    end

    for i = 1, #autorun.cmd do
        awful.spawn.with_shell(autorun.cmd[i])
    end
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- }}}

-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,
        awful.layout.suit.floating,
        -- awful.layout.suit.tile.left,
        -- awful.layout.suit.tile.bottom,
        -- awful.layout.suit.tile.top,
        -- awful.layout.suit.fair,
        -- awful.layout.suit.fair.horizontal,
        -- awful.layout.suit.spiral,
        -- awful.layout.suit.spiral.dwindle,
        -- awful.layout.suit.max,
        -- awful.layout.suit.max.fullscreen,
        -- awful.layout.suit.magnifier,
        -- awful.layout.suit.corner.nw,
    })
end)
-- }}}

-- {{{ Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            {
                image     = beautiful.wallpaper,
                upscale   = true,
                downscale = true,
                widget    = wibox.widget.imagebox,
            },
            valign = "center",
            halign = "center",
            tiled  = false,
            widget = wibox.container.tile,
        }
    }
end)
-- }}}

-- {{{ Wibar

-- Create a textclock widget
mytextclock = wibox.widget.textclock(" %b%d %a %T", 0.9)

local sharedtags = require("sharedtags")
local tags = sharedtags({
    { name = "1 main", screen = 1, layout = awful.layout.layouts[1] },
    { name = "2 www",  screen = 2, layout = awful.layout.layouts[1] },
    { name = "3 misc", screen = 1, layout = awful.layout.layouts[1] },
    { name = "4 chat", screen = 2, layout = awful.layout.layouts[1] },
    { name = "5 game", screen = 1, layout = awful.layout.layouts[1] },
})

screen.connect_signal("request::desktop_decoration", function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc( -1) end),
            awful.button({}, 4, function() awful.layout.inc( -1) end),
            awful.button({}, 5, function() awful.layout.inc(1) end),
        }
    }
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({}, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end),
            awful.button({}, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end),
            awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            -- awful.button({}, 1, function(c)
            --     c:activate { context = "tasklist", action = "toggle_minimization" }
            -- end),
            awful.button({}, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({}, 4, function() awful.client.focus.byidx( -1) end),
            awful.button({}, 5, function() awful.client.focus.byidx(1) end),
        }
    }
    local battery_widget = require("awesome-wm-widgets.battery-widget.battery")

    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "top",
        screen   = s,
        widget   = {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                s.mytaglist,
                s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                wibox.widget.systray(),
                mytextclock,
                battery_widget({
                    font = beautiful.font,
                    margin_right = 4,
                    margin_left = 5,
                    show_current_level = true
                }),
                s.mylayoutbox,
            },
        }
    }
end)

-- }}}

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings({
    -- awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewprev),
    awful.button({}, 5, awful.tag.viewnext),
})
-- }}}

-- {{{ Key bindings
-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Control" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey }, "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }),
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }),
    -- awful.key({ modkey }, "p", function() menubar.show() end,
    --     { description = "show the menubar", group = "launcher" }),
    awful.key({ modkey }, "p", function() awful.spawn("rofi -combi-modi window,drun,ssh -show combi") end,
        { description = "show rofi", group = "launcher" }),
    awful.key({ modkey }, "v",
        function() awful.spawn("rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'") end,
        { description = "open clipboard", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "s", function() awful.spawn("flameshot gui") end,
        { description = "screen shot", group = "launcher" }),
    awful.key({ modkey }, "b", function() awful.spawn("rofi-bluetooth") end,
        { description = "rofi-bluetooth", group = "launcher" }),
    awful.key({ modkey }, "n", function() awful.spawn("networkmanager_dmenu") end,
        { description = "networkmanager", group = "launcher" }),
    awful.key({ modkey }, "u", function() awful.spawn("/home/xv_rong/.config/script/switch-audio-sink.sh") end,
        { description = "switch-audio-sink", group = "launcher" }),
    awful.key({ modkey, "Control" }, "l", function() awful.spawn("betterlockscreen -l -- -e -u -f") end,
        { description = "lock screen", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "p", function() xrandr.xrandr() end,
        { description = "manage multiple screen", group = "screen" }),

    -- 调整屏幕亮度
    awful.key({}, "XF86MonBrightnessUp", function() awful.spawn("xbacklight -inc 5") end,
        { description = "increase brightness", group = "hotkey" }),
    awful.key({}, "XF86MonBrightnessDown", function() awful.spawn("xbacklight -dec 5") end,
        { description = "decrease brightness", group = "hotkeys" }),
    awful.key({ modkey }, "]", function() awful.spawn("xbacklight -inc 5") end,
        { description = "increase brightness", group = "hotkeys" }),
    awful.key({ modkey }, "[", function() awful.spawn("xbacklight -dec 5") end,
        { description = "decrease brightness", group = "hotkeys" }),

})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
        { description = "go back", group = "tag" }),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "k",
        function()
            awful.client.focus.byidx( -1)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key({ modkey, }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),
    -- awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
    --     { description = "focus the next screen", group = "screen" }),
    -- awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
    --     { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, }, "space", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    --     { description = "select next", group = "layout" }),
    -- awful.key({ modkey, "Control" }, "n",
    --     function()
    --         local c = awful.client.restore()
    --         -- Focus restored client
    --         if c then
    --             c:activate { raise = true, context = "key.unminimize" }
    --         end
    --     end,
    --     { description = "restore minimized", group = "client" }),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "h", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, }, "l", function() awful.client.swap.byidx( -1) end,
        { description = "swap with previous client by index", group = "client" }),
    -- awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
    --     { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incmwfact( -0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "j", function() awful.client.incwfact(0.10) end,
        { description = "increase window factor of client", group = "layout" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.incwfact( -0.10) end,
        { description = "decrease window factor of client", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(1) end,
        { description = "select previous", group = "layout" }),
    --floatingbutton awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
    --     { description = "decrease the number of master clients", group = "layout" }),
    -- awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
    --     { description = "increase the number of columns", group = "layout" }),
    -- awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
    --     { description = "decrease the number of columns", group = "layout" }),
    -- awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
    --     { description = "select next", group = "layout" }),

})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function(index)
            local screen = awful.screen.focused()
            local tag = tags[index]
            if tag then
                sharedtags.viewonly(tag, screen)
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function(index)
            local screen = awful.screen.focused()
            local tag = tags[index]
            if tag then
                sharedtags.viewtoggle(tag, screen)
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function(index)
            if client.focus then
                local tag = tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function(index)
            if client.focus then
                local tag = tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function(index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function(c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function(c)
            c:activate { context = "mouse_click", action = "mouse_move" }
        end),
        awful.button({ modkey }, 3, function(c)
            c:activate { context = "mouse_click", action = "mouse_resize" }
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey, }, "f",
            function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            { description = "toggle fullscreen", group = "client" }),
        awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end,
            { description = "close", group = "client" }),
        awful.key({ modkey, "Control" }, "Return", awful.client.floating.toggle,
            { description = "toggle floating", group = "client" }),
        awful.key({ modkey, "Control" }, "space", function(c) c:swap(awful.client.getmaster()) end,
            { description = "move to master", group = "client" }),
        awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
            { description = "move to screen", group = "client" }),
        awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
            { description = "toggle keep on top", group = "client" }),
        -- awful.key({ modkey, }, "n",
        --     function(c)
        --         -- The client currently has the input focus, so it cannot be
        --         -- minimized, since minimized clients can't have the focus.
        --         c.minimized = true
        --     end,
        --     { description = "minimize", group = "client" }),
        awful.key({ modkey, }, "m",
            function(c)
                c.maximized = not c.maximized
                c:raise()
            end,
            { description = "(un)maximize", group = "client" }),
        awful.key({ modkey, "Control" }, "m",
            function(c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end,
            { description = "(un)maximize vertically", group = "client" }),
        awful.key({ modkey, "Shift" }, "m",
            function(c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end,
            { description = "(un)maximize horizontally", group = "client" }),
    }) -- The first tag defined for each screen will be automatically selected.
    -- @tparam table def A list of tables with the optional keys `name`, `layout`
    -- and `screen`. The `name` value is used to name the tag and defaults to the
    -- list index. The `layout` value sets the starting layout for the tag and
    -- defaults to the first layout. The `screen` value sets the starting screen
    -- for the tag and defaults to the first screen. The tags will be sorted in this
    -- order in the default taglist.
    -- @treturn table A list of all created tags. Tags are assigned numeric values
    -- corresponding to the input list, and all tags with non-numerical names are
    -- also assigned to a key with the same name.
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = {},
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id         = "floating",
        rule_any   = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name     = {
                "Event Tester", -- xev.
            },
            role     = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id         = "titlebars",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = false }
    }

    ruled.client.append_rule {
        rule       = { class = "netease-cloud-music" },
        properties = { tag = tags[3] }
    }

    ruled.client.append_rule {
        rule       = { class = "Microsoft-edge" },
        properties = { tag = tags[2] }
    }

    ruled.client.append_rule {
        rule       = { class = "QQ" },
        properties = { tag = tags[4] }
    }

    ruled.client.append_rule {
        rule       = { class = "Steam" },
        properties = { tag = tags[5] }
    }

    ruled.client.append_rule {
        rule       = { class = "weixin" },
        properties = { tag = tags[4] }
    }
end)
-- }}}

-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({}, 1, function()
            c:activate { context = "titlebar", action = "mouse_move" }
        end),
        awful.button({}, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize" }
        end),
    }

    awful.titlebar(c).widget = {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                halign = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            -- awful.titlebar.widget.floatingbutton(c),
            -- awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.stickybutton(c),
            -- awful.titlebar.widget.ontopbutton(c),
            -- awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
-- }}}

-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = {},
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)

-- }}}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)
