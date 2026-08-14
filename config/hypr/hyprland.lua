-- Hyprland Lua config. Hyprland 0.56+ prefers hyprland.lua over
-- hyprland.conf, avoiding the legacy/soon-to-be-obsolete Hyprlang config path.

local home = os.getenv("HOME") or ""
local gpu_lua = home .. "/.config/hypr/gpu.lua"
local gpu_file = io.open(gpu_lua, "r")
if gpu_file then
    gpu_file:close()
    dofile(gpu_lua)
else
    -- Fallback for machines that already have the old generated gpu.conf but
    -- have not rerun symlink_arch.sh yet.
    local gpu_conf = home .. "/.config/hypr/gpu.conf"
    gpu_file = io.open(gpu_conf, "r")
    if gpu_file then
        local contents = gpu_file:read("*a")
        gpu_file:close()
        local devices = contents:match("env%s*=%s*AQ_DRM_DEVICES%s*,%s*([^\n]+)")
        if devices then
            hl.env("AQ_DRM_DEVICES", devices)
        end
    end
end

local mod = "SUPER"

local function run_once(cmd)
    hl.exec_cmd(cmd)
end

local function bind(keys, cmd, opts)
    hl.bind(keys, hl.dsp.exec_cmd(cmd), opts or {})
end

local function monitor(output, mode, position, scale, mirror)
    local rule = {
        output = output,
        mode = mode,
        position = position,
        scale = scale,
    }
    if mirror then
        rule.mirror = mirror
    end
    hl.monitor(rule)
end

-- Environment
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Theme environment variables
hl.env("GTK_THEME", "catppuccin-mocha-blue-standard+default")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("XCURSOR_THEME", "catppuccin-mocha-dark-cursors")
hl.env("XCURSOR_SIZE", "24")

-- Monitors
monitor("eDP-1", "1920x1080@60", "0x0", 1)
monitor("HDMI-A-1", "1920x1080@60", "auto", 1, "eDP-1")
monitor("", "preferred", "auto", 1)

-- Lid switch handling - mirror laptop to HDMI at 1080p when lid closes
bind("switch:on:Lid Switch", [[hyprctl keyword monitor "eDP-1, 1920x1080@60, auto, 1" && hyprctl keyword monitor "HDMI-A-1, 1920x1080@60, auto, 1, mirror, eDP-1"]], { locked = true })
bind("switch:off:Lid Switch", [[hyprctl keyword monitor "eDP-1, 1920x1200@60, 0x0, 1"]], { locked = true })

-- Autostart
hl.on("hyprland.start", function()
    run_once("/usr/lib/polkit-kde-authentication-agent-1")
    run_once("hypridle")
    run_once("awww-daemon")
    run_once("bash -lc 'until awww img ~/Pictures/Wallpapers/wallpaper.png; do sleep 0.2; done'")
    run_once("mako")
    run_once("~/.local/bin/launch-waybar")
    run_once("wl-paste --type text --watch cliphist store")
    run_once("wl-paste --type image --watch cliphist store")
    run_once("~/.local/bin/battery-monitor")
    run_once("sway-audio-idle-inhibit")
end)

-- Catppuccin Mocha with black backgrounds
local base = "rgb(000000)"
local text = "rgb(cdd6f4)"
local surface1 = "rgb(45475a)"
local blue = "rgb(89b4fa)"
local mauve = "rgb(cba6f7)"

hl.config({
    input = {
        kb_layout = "us,se,pl",
        kb_variant = ",,legacy",
        follow_mouse = 0,
        repeat_rate = 30,
        repeat_delay = 233,
    },

    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = { colors = { mauve, blue }, angle = 45 },
            inactive_border = surface1,
        },
        layout = "dwindle",
    },

    dwindle = {
        preserve_split = true,
    },

    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
        },
        shadow = {
            enabled = true,
            range = 15,
            render_power = 3,
            color = "rgba(000000aa)",
        },
    },

    animations = {
        enabled = true,
    },

    cursor = {
        no_hardware_cursors = true,
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})

hl.curve("easeInOutQuad", { type = "bezier", points = { { 0.45, 0 }, { 0.55, 1 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "easeInOutQuad" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "easeInOutQuad", style = "popin 80%" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "easeInOutQuad" })
hl.animation({ leaf = "workspaces", enabled = false })

-- Window rules
hl.window_rule({ name = "float-thunar", match = { class = "thunar" }, float = true })
hl.window_rule({ name = "float-xarchiver", match = { class = "xarchiver" }, float = true })
hl.window_rule({ name = "float-audacious", match = { class = "Audacious" }, float = true })

-- Key bindings
bind(mod .. " + Return", "kitty")
bind(mod .. " + E", "thunar")
bind(mod .. " + R", "wofi --show drun")
bind(mod .. " + space", "hyprctl switchxkblayout all next")
bind(mod .. " + Escape", "hyprlock")
bind(mod .. " + SHIFT + Escape", "~/.local/bin/powermenu")
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.float({ action = "toggle" }))

-- Mouse binds for floating windows
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Minimize window (move to special workspace)
hl.bind(mod .. " + M", hl.dsp.window.move({ workspace = "special:minimized", silent = true }))
hl.bind(mod .. " + SHIFT + M", hl.dsp.workspace.toggle_special("minimized"))

-- Window focus (vim-style)
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move windows
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Toggle split direction (horizontal/vertical)
hl.bind(mod .. " + T", hl.dsp.layout("togglesplit"))

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Workspace navigation
hl.bind(mod .. " + Prior", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + Next", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + SHIFT + Prior", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mod .. " + SHIFT + Next", hl.dsp.window.move({ workspace = "e+1" }))

-- Power profiles (F7/F8/F9)
bind("F7", [[powerprofilesctl set power-saver && notify-send "Power Profile" "Power Saver"]])
bind("F8", [[powerprofilesctl set balanced && notify-send "Power Profile" "Balanced"]])
bind("F9", [[powerprofilesctl set performance && notify-send "Power Profile" "Performance"]])

-- Screen capture
bind("Print", "~/.local/bin/capture --fullscreen")
bind("SHIFT + Print", "~/.local/bin/capture")

-- Clipboard history - SUPER+V
bind(mod .. " + V", "cliphist list | wofi --dmenu | cliphist decode | wl-copy")

-- Volume
bind("XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
bind("XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
bind("XF86AudioRaiseVolume", "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+")
bind("XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
bind(mod .. " + SHIFT + A", [[systemctl --user restart pipewire pipewire-pulse wireplumber && notify-send "Audio" "PipeWire restarted"]])

-- Brightness
bind("XF86MonBrightnessDown", "brightnessctl set 5%-")
bind("XF86MonBrightnessUp", "brightnessctl set 5%+")

-- Media
bind("XF86AudioPlay", "playerctl play-pause")
bind("XF86AudioNext", "playerctl next")
bind("XF86AudioPrev", "playerctl previous")
bind("XF86AudioStop", "playerctl stop")
