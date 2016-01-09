--- AwesomeWM 3.5.2 rc.lua ---
-- =====================================================================
-- {{{ s_libs
-- =====================================================================
-- Internal libraries
local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
                  require("awful.autofocus")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local menubar   = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup.widget")
-- External libraries
local drop      = require("scratchdrop")
local lain      = require("lain")
-- }}}

-- =====================================================================
-- {{{ s_error
-- =====================================================================
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

-- =====================================================================
-- {{{ s_utilities
-- =====================================================================
-- Toggle the wibox
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

-- Execute a command once at start of awesome
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end
-- }}}

-- =====================================================================
-- {{{ s_autostart
-- =====================================================================
run_once("urxvtd")
run_once("unclutter -root")
run_once("sh ~/.xprofile")
-- }}}

-- =====================================================================
-- {{{ s_vars
-- =====================================================================
-- Apps
terminal   = "urxvt" or "xterm"
editor     = os.getenv("EDITOR") or "vim" or "vi"
editor_cmd = terminal .. " -e " .. editor
gui_editor = "gvim"
browser    = "firefox"
mail       = "thunderbird"
graphics   = "gimp"

-- Env
home       = os.getenv("HOME")
config     = awful.util.getdir("config")
hostname   = io.lines("/proc/sys/kernel/hostname")()

-- Appearance
barheight   = 20
borderwidth = 0

-- Widgets
weather_city = 2857807 -- Find out via http://openweathermap.org/find

-- Lain
lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol    = 1

-- Shortcuts
exec       = awful.util.spawn
sexec      = awful.util.spawn_with_shell
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey     = "Mod4"
altkey     = "Mod1"
k_m        = { modkey }
k_ms       = { modkey, "Shift" }
k_mc       = { modkey, "Control" }
k_mcs      = { modkey, "Control", "Shift" }
k_a        = { altkey }
k_ac       = { altkey, "Control" }
k_as       = { altkey, "Shift" }
k_acs      = { altkey, "Control", "Shift" }
k_am       = { altkey, modkey }
k_ams      = { altkey, modkey, "Shift" }
-- }}}

-- =====================================================================
-- {{{ s_theme
-- =====================================================================
shared_themes_dir = "/usr/share/awesome/themes/"
themes_dir        = config .. "/themes"
theme             = "/redhalo/theme.lua"

if hostname == "htpc" then
    theme = "/rainbow/theme.lua"
end

if not awful.util.file_readable(themes_dir..theme) then
    themes_dir  = sharedthemes
end
beautiful.init(themes_dir..theme)

-- }}}

-- =====================================================================
-- {{{ s_tags
-- =====================================================================
local layouts = {
    awful.layout.suit.tile,             --1
    awful.layout.suit.tile.left,        --2
    awful.layout.suit.tile.top,         --3
    awful.layout.suit.fair.horizontal,  --4
    awful.layout.suit.max,              --5
    lain.layout.uselesstile,            --6
    lain.layout.uselessfair,            --7
    lain.layout.centerwork,             --8
    awful.layout.suit.floating,         --9
    --~ awful.layout.suit.tile.bottom,
    --~ awful.layout.suit.fair,
    --~ awful.layout.suit.spiral,
    --~ awful.layout.suit.spiral.dwindle,
    --~ lain.layout.centerfair,
    --~ lain.layout.cascade,
    --~ lain.layout.cascadetile,
    --~ lain.layout.centerfair,
    --~ lain.layout.centerhwork,
    --~ lain.layout.termfair,
    --~ lain.layout.uselessfair,
    --~ lain.layout.uselesspiral,
    --~ lain.layout.uselesstile,
}
tags = {
    names = { "web", "dev", "docs", "vlc", "irc", "play" },
    --names = { "♏", "♐", "⌘", "☊", "♓", "⌥", "♒" },
    layouts = { layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[9] }
}
for s = 1, screen.count() do
-- Each screen has its own tag table.
   tags[s] = awful.tag(tags.names, s, tags.layouts)
end
-- }}}

-- =====================================================================
-- {{{ s_wallpaper
-- =====================================================================
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- =====================================================================
-- {{{ s_menu
-- =====================================================================
myawesomemenu = {
    { "open terminal", terminal },
    { "hotkeys", function() return false, hotkeys_popup.show_help end},
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. config .. "/rc.lua"},
    { "run", function() mypromptbox[mouse.screen]:run() end },
    { "restart", awesome.restart },
    { "quit", awesome.quit }
}

mygeneratedmenu = require("menugen").build_menu()

mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu },
        { "apps", mygeneratedmenu }
    }
})

-- Instead of using separate submenus like above you can also simply
-- insert the awesome_menu into the generated menu.
--~ table.insert(generated_menu, 1, { "awesome", awesome_menu })
--~ mymainmenu = awful.menu({ items = generated_menu })
-- }}}

-- =====================================================================
-- {{{ s_widgets
-- =====================================================================
markup = lain.util.markup

-- Textclock
clockicon = wibox.widget.imagebox(beautiful.widget_clock)
--mytextclock = awful.widget.textclock(markup("#7788af", "%A %d %B ") .. markup("#343639", ">") .. markup("#de5e1e", " %H:%M "))
mytextclock = lain.widgets.abase({
    timeout  = 60,
    cmd      = "date +'%A %d %B %R'",
    settings = function()
        local t_output = ""
        local o_it = string.gmatch(output, "%S+")

        for i=1,3 do t_output = t_output .. " " .. o_it(i) end

        widget:set_markup(markup("#7788af", t_output) .. markup("#343639", " > ") .. markup("#de5e1e", o_it(1)) .. " ")
    end
})

-- Calendar
lain.widgets.calendar:attach( mytextclock, { font_size = 10, followmouse = true } )

-- Weather
weathericon = wibox.widget.imagebox(beautiful.widget_weather)
myweather = lain.widgets.weather({
    city_id = weather_city,
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup("#eca4c4", descr .. " @ " .. units .. "°C "))
    end
})

-- Filesystem
fsicon = wibox.widget.imagebox(beautiful.widget_fs)
fswidget = lain.widgets.fs({
    settings  = function()
        widget:set_markup(markup("#80d9d8", fs_now.used .. "% "))
    end
})

-- CPU
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuwidget = lain.widgets.cpu({
    settings = function()
        widget:set_markup(markup("#e33a6e", cpu_now.usage .. "% "))
    end
})

-- Coretemp
tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widgets.temp({
    settings = function()
        widget:set_markup(markup("#f1af5f", coretemp_now .. "°C "))
    end
})

-- Battery
baticon = wibox.widget.imagebox(beautiful.widget_batt)
batwidget = lain.widgets.bat({
    settings = function()
        if bat_now.perc == "N/A" then
            perc = "AC "
        else
            perc = bat_now.perc .. "% "
        end
        widget:set_text(perc)
    end
})

-- ALSA volume
volicon = wibox.widget.imagebox(beautiful.widget_vol)
volumewidget = lain.widgets.alsa({
    settings = function()
        if volume_now.status == "off" then
            volume_now.level = volume_now.level .. "M"
        end

        widget:set_markup(markup("#7493d2", volume_now.level .. "% "))
    end
})

-- Net
netdownicon = wibox.widget.imagebox(beautiful.widget_netdown)
--netdownicon.align = "middle"
netdowninfo = wibox.widget.textbox()
netupicon = wibox.widget.imagebox(beautiful.widget_netup)
--netupicon.align = "middle"
netupinfo = lain.widgets.net({
    settings = function()
        if iface ~= "network off" and
           string.match(myweather._layout.text, "N/A")
        then
            myweather.update()
        end

        widget:set_markup(markup("#e54c62", net_now.sent .. " "))
        netdowninfo:set_markup(markup("#87af5f", net_now.received .. " "))
    end
})

-- MEM
memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = lain.widgets.mem({
    settings = function()
        widget:set_markup(markup("#e0da37", mem_now.used .. "M "))
    end
})

-- Spacer
spacer = wibox.widget.textbox(" ")
-- }}}

-- =====================================================================
-- {{{ s_wibox
-- =====================================================================
-- Create a wibox for each screen and add it
mywibox = {}
mybottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button(k_m, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button(k_m, 3, awful.client.toggletag),
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

    -- Create the upper wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 20 })
    --border_width = 0, height =  20 })

    -- Widgets that are aligned to the upper left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the upper right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    --right_layout:add(mailicon)
    --right_layout:add(mailwidget)
    right_layout:add(netdownicon)
    right_layout:add(netdowninfo)
    right_layout:add(netupicon)
    right_layout:add(netupinfo)
    right_layout:add(volicon)
    right_layout:add(volumewidget)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(fsicon)
    right_layout:add(fswidget)
    right_layout:add(weathericon)
    right_layout:add(myweather)
    right_layout:add(tempicon)
    right_layout:add(tempwidget)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(clockicon)
    right_layout:add(mytextclock)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    --layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

    -- Create the bottom wibox
    mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, border_width = 0, height = 20 })
    --mybottomwibox[s].visible = false

    -- Widgets that are aligned to the bottom left
    bottom_left_layout = wibox.layout.fixed.horizontal()

    -- Widgets that are aligned to the bottom right
    bottom_right_layout = wibox.layout.fixed.horizontal()
    bottom_right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_left(bottom_left_layout)
    bottom_layout:set_middle(mytasklist[s])
    bottom_layout:set_right(bottom_right_layout)
    mybottomwibox[s]:set_widget(bottom_layout)
end
-- }}}

-- =====================================================================
-- {{{ s_mouse_bindings
-- =====================================================================
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

    --~ -- Show/Hide Wibox
    --~ awful.key(k_m, "b", function ()
        --~ mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
        --~ mybottomwibox[mouse.screen].visible = not mybottomwibox[mouse.screen].visible
    --~ end),
    --~ -- Standard program
    --~ awful.key(k_m, "Return", function () awful.util.spawn(terminal .. " -e tmux") end),
    --~ awful.key(k_mc, "r",      awesome.restart),
    --~ awful.key(k_ms, "q",      awesome.quit),

    --~ -- Dropdown terminal
    --~ awful.key(k_m, "a",      function () drop(terminal) end),

    --~ -- Copy to clipboard
    --~ awful.key(k_m, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

    --~ -- User programs
    --~ awful.key(k_m, "q", function () awful.util.spawn(browser) end),
    --~ awful.key(k_m, "s", function () awful.util.spawn(gui_editor) end),
    --~ awful.key(k_m, "g", function () awful.util.spawn(graphics) end),
-- =====================================================================
-- {{{ s_key_bindings
-- =====================================================================
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
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
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
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
                  c = awful.client.restore()
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
                  awful.util.getdir("cache") .. "/history_eval")
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = awful.util.table.join(
    awful.key(k_m, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key(k_ms, "c",      function (c) c:kill()                         end),
    awful.key(k_mc, "space",  awful.client.floating.toggle                     ),
    awful.key(k_mc, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key(k_m, "o",      awful.client.movetoscreen                        ),
    awful.key(k_m, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key(k_m, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key(k_m, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key(k_m, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag.
        awful.key(k_mc, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key(k_ms, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag.
        awful.key(k_mcs, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ },  1, function (c) client.focus = c; c:raise() end),
    awful.button(k_a,  1, function (c) client.focus = c; c:lower() end),
    awful.button(k_m,  1, awful.mouse.client.move),
    awful.button(k_m,  3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = {},
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     --~ maximized_horizontal = false,
                     --~ maximized_vertical = false,
                     --~ size_hints_honor = false
        }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "urxvt_drop",
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer",
          "Blockify",
          "Thunderbird",
          "Deluge",
          "Zenity",
          "Plugin-container",
        },
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true } },

    -- General
    { rule_any = { class = { "Plugin-container" }, instance = { "urxvt_drop" } },
        properties = { border_width = 0, above = true }
    },
    --~ { rule_any = { class = { "Plugin-container" } },
        --~ properties = { maximized_horizontal = true, maximized_vertical = true }
    --~ },
    { rule_any = { class = { "Thunderbird", "Deluge" } },
        properties = { geometry = { width = 1200, height = 800 } },
        callback = awful.placement.centered
    },
    { rule_any = { class = { "Copyq", "Zenity" } },
        properties = { sticky = true, ontop = true, above = true },
        callback = awful.placement.centered
    },

    -- 1:web
   { rule_any = { class = { "Firefox", "Chromium", "Dwb" } },
        properties = { tag = tags[1][1] }
    },
    { rule = { class = "Firefox" }, except = { instance = "Navigator" },
        properties = { floating = true },
        callback = awful.placement.centered
    },

    -- 2:dev
   { rule_any = { class = { "jetbrains-*", "Eclipse", "Gvim", "urxvt_edit", "Geany", "Gedit", "medit" } },
        properties = { tag = tags[1][2] }
    },
    { rule_any = { class = { "Geany", "Gedit", "medit" }, instance = { "urxvt_edit" } },
        properties = { switchtotag = true }
    },

    -- 3:vm
   { rule_any = { class = { "VirtualBox", "Wine", "Vncviewer", "Nxplayer.bin" } },
        properties = { tag = tags[1][3], floating = true }
    },
    { rule = { class = "VirtualBox" },
        callback = awful.placement.centered
    },
    { rule_any = { class = { "Vncviewer", "VirtualBox" } },
        properties = { switchtotag = true },
        callback = awful.placement.centered
    },

    -- 4:vlc
   { rule_any = { class = { "Vlc", "Spotify" } },
        properties = { tag = tags[1][4], switchtotag = true }
    },
    { rule = { class = "Vlc", role = "vlc-main" },
        callback = awful.client.setmaster
    },

    -- 5:irc
   { rule_any = { class = { "Pidgin", "Hexchat" } },
        properties = { tag = tags[1][5] }
    },
    { rule_any = { class = { "Hexchat" } },
        callback = awful.client.setmaster
    },

    -- 6:work
   { rule_any = { class = { "Gimp", "Zeal", "LibreOffice", "AbiWord" } },
        properties = { tag = tags[1][6], switchtotag = true}
    },
    { rule = { class = "Gimp", role = "gimp-image-window" },
        callback = awful.client.setmaster
    }
}
-- }}}

-- =====================================================================
-- {{{ s_signals
-- =====================================================================
client.connect_signal("manage", function (c)
    if not awesome.startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they do not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    elseif not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
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

    awful.client.movetoscreen(c, mouse.screen)
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
