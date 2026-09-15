-- #######################################################################################
-- MIGRATED FROM hyprland.conf (hyprlang) TO hyprland.lua, Hyprland 0.55+
-- Generated from your existing config. Save this as ~/.config/hypr/hyprland.lua
--
-- IMPORTANT before you switch over:
-- 1. Keep your old hyprland.conf as a backup (e.g. rename it hyprland.conf.bak).
--    Once hyprland.lua exists, Hyprland loads it INSTEAD of the .conf, so the .conf
--    stops being a live fallback.
-- 2. Test with `Hyprland --config /path/to/this/file --verify-config` if available,
--    or just reload (`hyprctl reload`) from an existing session so you can recover
--    if something errors.
-- 3. A few lines below are flagged with "VERIFY:" -- these are spots where the old
--    hyprlang syntax doesn't have a single unambiguous Lua equivalent I could confirm
--    from current docs/examples. Check them against https://wiki.hypr.land before
--    relying on them. Everything else is based on the current wiki and the official
--    example config.
-- #######################################################################################

------------------
---- MONITORS ----
------------------
-- See https://wiki.hypr.land/configuring/core/monitors/

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- Desktop
hl.monitor({
	output = "desc:LG Electronics LG ULTRAFINE 406NTBK57165",
	mode = "3840x2160",
	position = "0x1440",
	scale = 1.5,
	transform = 2,
})
hl.monitor({
	output = "desc:LG Electronics LG ULTRAFINE 406NTQD57172",
	mode = "3840x2160",
	position = "0x0",
	scale = 1.5,
})
-- Alternate desktop layout (both monitors side by side, no rotation):
-- hl.monitor({ output = "desc:LG Electronics LG ULTRAFINE 406NTBK57165", mode = "3840x2160", position = "0x0", scale = 1.5, transform = 2 })
-- hl.monitor({ output = "desc:LG Electronics LG ULTRAFINE 406NTQD57172", mode = "3840x2160", position = "2560x0", scale = 1.5 })

-- Laptop
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

---------------------
---- MY PROGRAMS ----
---------------------
-- See https://wiki.hypr.land/configuring/core/keywords/

local terminal = "kitty"
local fileManager = "nautilus"
local menu = "rofi -show drun"
local menuNetwork = "bash ~/.local/bin/power.sh"
local menuMedia = "bash ~/.local/bin/media.sh"

-------------------
---- AUTOSTART ----
-------------------
-- exec-once becomes hl.on("hyprland.start", ...); each hl.exec_cmd() call
-- inside it runs once, at startup.

hl.on("hyprland.start", function()
	hl.exec_cmd("QT_SCALE_FACTOR=1 noctalia-shell")
	-- hl.exec_cmd("hyprpanel")
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("xrdb ~/.Xresources")
	hl.exec_cmd("~/.local/bin/randomized-bg.sh ~/Pictures/Wallpapers")
end)

-----------------------------
---- ENVIRONMENT VARIABLES ----
-----------------------------
-- See https://wiki.hypr.land/configuring/core/environment-variables/

hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1.5")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_SCALE_FACTOR", "1.5")

-- Desktop
hl.env("GDK_SCALE", "1")
-- Laptop
-- hl.env("GDK_SCALE", "2")

hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "18")
hl.env("HYPRCURSOR_SIZE", "18")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

---------------------
---- LOOK AND FEEL ----
---------------------
-- See https://wiki.hypr.land/configuring/core/variables/

hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 6,

		border_size = 1,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		resize_on_border = false,
		allow_tearing = false,

		-- layout = "master",
		-- layout = "scrolling",
	},
})

hl.config({
	decoration = {
		rounding = 5,

		active_opacity = 1.0,
		inactive_opacity = 1.0,

		-- shadow = {
		--     range = 4,
		--     render_power = 3,
		--     color = "rgba(1a1a1aee)",
		-- },

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},
})

-- Curves for the animations below
hl.curve("fastInSlowOut", { type = "bezier", points = { { 0, 0.51 }, { 0.5, 1 } } })
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "fastInSlowOut" })
-- animation "windowsOut" was commented out in your original conf; left out here too.
hl.animation({ leaf = "border", enabled = false }) -- was disabled (0) in your conf
hl.animation({ leaf = "borderangle", enabled = true, speed = 6, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 6, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default" })

hl.config({
	dwindle = {
		-- pseudotile was removed as a global dwindle setting in 0.55+.
		-- Pseudotiling is now per-window, via the `pseudo` dispatcher
		-- (e.g. hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())) --
		-- not added here since mainMod+P is already bound to your menu.
		preserve_split = true,
	},
	master = {
		new_status = "master",
	},
	scrolling = {
		column_width = 0.5,
		focus_fit_method = 1,
		fullscreen_on_one_column = false,
		explicit_column_widths = "0.5, 1.0",
	},
	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = true,
	},
})

---------------
---- INPUT ----
---------------
-- See https://wiki.hypr.land/configuring/core/input/

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		repeat_delay = 300,
		repeat_rate = 50,

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification

		touchpad = {
			disable_while_typing = true,
			natural_scroll = false,
			clickfinger_behavior = true,
			-- Renamed from the old hyphenated "tap-to-click" to the underscored
			-- key the Lua config registry uses.
			tap_to_click = true,
		},
	},
})

-- Example per-device config
-- See https://wiki.hypr.land/configuring/core/devices/
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

--------------------
---- KEYBINDINGS ----
--------------------
-- See https://wiki.hypr.land/configuring/core/binds/

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(menuNetwork))
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd(menuMedia))

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(0))
hl.bind(mainMod .. " + SPACE", hl.dsp.window.fullscreen(1))
-- VERIFY: layoutmsg equivalent -- hl.dsp.layout() takes the raw layoutmsg string.
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.layout("colresize +conf"))

hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ next = true }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ prev = true }))

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))

-- Switch workspaces with mainMod + [0-9], move window with mainMod + SHIFT + [0-9]
-- (key "0" maps to workspace 10, same as your original conf)
local workspaceKeys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
for i, key in ipairs(workspaceKeys) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
-- VERIFY: bind-string form of mouse scroll ("mouse_down"/"mouse_up") carried over
-- as-is here; confirm against https://wiki.hypr.land/Configuring/Basics/Binds/
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys
hl.bind("XF86KbdBrightnessUp", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s 10%+"))
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s 10%-"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 10%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { repeating = true })

-- hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("amixer -q sset Master 10%+"), { repeating = true })
-- hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("amixer -q sset Master 10%-"), { repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("CTRL + XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

hl.bind("CTRL + SHIFT + 4", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy -t "image/png"'))

------------------------------
---- WINDOWS AND WORKSPACES ----
------------------------------
-- See https://wiki.hypr.land/configuring/core/rules/

-- Desktop
-- VERIFY: "layout" as a workspace-rule field (to force scrolling layout per
-- workspace) -- confirm the field name against Workspace Rules on the wiki.
hl.workspace_rule({
	workspace = "1",
	monitor = "desc:LG Electronics LG ULTRAFINE 406NTQD57172",
	default = true,
	layout = "scrolling",
})
hl.workspace_rule({ workspace = "2", monitor = "desc:LG Electronics LG ULTRAFINE 406NTQD57172", layout = "scrolling" })
hl.workspace_rule({ workspace = "3", monitor = "desc:LG Electronics LG ULTRAFINE 406NTQD57172", layout = "scrolling" })
hl.workspace_rule({ workspace = "4", monitor = "desc:LG Electronics LG ULTRAFINE 406NTQD57172", layout = "scrolling" })
hl.workspace_rule({ workspace = "5", monitor = "desc:LG Electronics LG ULTRAFINE 406NTQD57172", layout = "scrolling" })
hl.workspace_rule({ workspace = "6", monitor = "desc:LG Electronics LG ULTRAFINE 406NTBK57165", layout = "scrolling" })
hl.workspace_rule({ workspace = "7", monitor = "desc:LG Electronics LG ULTRAFINE 406NTBK57165", layout = "scrolling" })
hl.workspace_rule({ workspace = "8", monitor = "desc:LG Electronics LG ULTRAFINE 406NTBK57165", layout = "scrolling" })
hl.workspace_rule({ workspace = "9", monitor = "desc:LG Electronics LG ULTRAFINE 406NTBK57165", layout = "scrolling" })
hl.workspace_rule({ workspace = "10", monitor = "desc:LG Electronics LG ULTRAFINE 406NTBK57165", layout = "scrolling" })

-- Laptop
-- hl.workspace_rule({ workspace = "1", monitor = "eDP-1" })
-- hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
-- ... etc for 3-10

hl.window_rule({
	name = "windowrule-1",
	match = { class = ".*" }, -- You'll probably like this.
	suppress_event = "maximize",
})

-- VERIFY: "monitor" as a plain integer effect on a window rule (assign-to-monitor-
-- index) carried over as-is; confirm this still resolves the same way in Lua.
hl.window_rule({
	name = "windowrule-2",
	match = { class = "^(kitty)$" },
	workspace = 1,
	monitor = 1,
})

hl.window_rule({
	name = "windowrule-3",
	match = { class = "^(ferdium)$" },
	workspace = 2,
	monitor = 1,
})

hl.window_rule({
	name = "windowrule-4",
	match = { class = "^(firefox)$" },
	workspace = 6,
	monitor = 2,
})

hl.window_rule({
	name = "windowrule-5",
	match = { title = "^Picture-in-Picture$" },
	float = true,
	pin = true,
	size = "640 360",
	move = "monitor_w-window_w-6 monitor_h-window_h-6",
})

hl.window_rule({
	name = "windowrule-thunderbird",
	match = { class = "^(thunderbird)$" },
	workspace = 2,
	monitor = 1,
})

hl.window_rule({
	name = "screeps-tiling-fix",
	match = { class = "^(Screeps)$" },
	tile = true,
})

hl.window_rule({
	name = "darktide-fix",
	match = { class = "^(steam_app_1361210)$" },
	workspace = 5,
	-- Games often fail to render if they are tiled but "think" they are fullscreen.
	-- Start by forcing it to float to see if the window appears.
	float = true,
})
