-- keybindings.lua
-- Full keybindings config — Hyprland 0.55+ Lua API
-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local home = os.getenv("HOME")
local open = home .. "/.local/bin/OpenApps"
local media = home .. "/.local/bin/MediaControl"
local waybar = home .. "/.config/waybar/scripts"
local execute = home .. "/.local/bin/executer"
local M = "SUPER"

-- ─────────────────────────────────────────────
-- Terminals
-- ─────────────────────────────────────────────
hl.bind(M .. " + return", hl.dsp.exec_cmd(open .. " --terminal"))
hl.bind(M .. " + ALT + return", hl.dsp.exec_cmd(open .. " --terminal-float"))
hl.bind(M .. " + CTRL + return", hl.dsp.exec_cmd(open .. " --terminal-init"))

-- ─────────────────────────────────────────────
-- Terminal apps
-- ─────────────────────────────────────────────
hl.bind(M .. " + e", hl.dsp.exec_cmd(open .. " --yazi"))
hl.bind(M .. " + ALT + e", hl.dsp.exec_cmd(open .. " --yazi-tmux"))
hl.bind(M .. " + l", hl.dsp.exec_cmd(open .. " --mail"))
hl.bind(M .. " + n", hl.dsp.exec_cmd(open .. " --news"))
hl.bind(M .. " + m", hl.dsp.exec_cmd(open .. " --music"))
hl.bind(M .. " + t", hl.dsp.exec_cmd(open .. " --translate"))
hl.bind(M .. " + p", hl.dsp.exec_cmd(open .. " --top"))
hl.bind(M .. " + slash", hl.dsp.exec_cmd(open .. " --disk"))
hl.bind(M .. " + ALT + v", hl.dsp.exec_cmd(open .. " --nvim"))
hl.bind(M .. " + ALT + 9", hl.dsp.exec_cmd(open .. " --k9s"))
hl.bind(M .. " + ALT + o", hl.dsp.exec_cmd(open .. " --fetch"))
hl.bind(M .. " + ALT + l", hl.dsp.exec_cmd(open .. " --lazydocker"))
hl.bind(M .. " + ALT + semicolon", hl.dsp.exec_cmd(open .. " --hm"))

-- ─────────────────────────────────────────────
-- Web
-- ─────────────────────────────────────────────
hl.bind(M .. " + b", hl.dsp.exec_cmd(open .. " --firefox"))
hl.bind(M .. " + ALT + y", hl.dsp.exec_cmd(open .. " --firefox 'https://www.youtube.com/'"))
hl.bind(M .. " + ALT + g", hl.dsp.exec_cmd(open .. " --github"))

-- ─────────────────────────────────────────────
-- Desktop Apps
-- ─────────────────────────────────────────────
hl.bind(M .. " + SHIFT + e", hl.dsp.exec_cmd(open .. " --files"))

-- ─────────────────────────────────────────────
-- Applets
-- ─────────────────────────────────────────────
hl.bind(M .. " + w", hl.dsp.exec_cmd("wlr-which-key"))
hl.bind(M .. " + ALT + a", hl.dsp.exec_cmd(open .. " --menu"))
hl.bind(M .. " + ALT + w", hl.dsp.exec_cmd(open .. " --wall"))
hl.bind(M .. " + ALT + x", hl.dsp.exec_cmd(open .. " --execute"))
hl.bind(M .. " + ALT + d", hl.dsp.exec_cmd(open .. " --android"))
hl.bind(M .. " + v", hl.dsp.exec_cmd(open .. " --clipboard"))
hl.bind(M .. " + F8", hl.dsp.exec_cmd(open .. " --bluetooth"))
hl.bind(M .. " + F2", hl.dsp.exec_cmd(open .. " --netmanager"))
hl.bind(M .. " + ALT + slash", hl.dsp.exec_cmd(execute .. "/.mnts.sh"))
hl.bind(M .. " + ALT + m", hl.dsp.exec_cmd(execute .. "/.mpd.sh"))
hl.bind(M .. " + ALT + t", hl.dsp.exec_cmd(execute .. "/.gtt.sh --select"))
hl.bind(M .. " + ALT + b", hl.dsp.exec_cmd(open .. " --buku"))
hl.bind(M .. " + ALT + k", hl.dsp.exec_cmd(open .. " --keyboard"))
hl.bind(M .. " + ALT + p", hl.dsp.exec_cmd(open .. " --powermenu"))
hl.bind(M .. " + ALT + s", hl.dsp.exec_cmd(open .. " --screenshot"))
hl.bind(M .. " + Print", hl.dsp.exec_cmd(open .. " --screenshot --override full"))

-- ─────────────────────────────────────────────
-- Environment
-- ─────────────────────────────────────────────
hl.bind("Caps_Lock", hl.dsp.exec_cmd(execute .. "/.lock.sh --caps"))
hl.bind("Num_Lock", hl.dsp.exec_cmd(execute .. "/.lock.sh --num"))
hl.bind(M .. " + Scroll_Lock", hl.dsp.exec_cmd("hyprlock"))
hl.bind(M .. " + KP_Home", hl.dsp.exec_cmd(execute .. "/clean.sh --off"))
hl.bind(M .. " + KP_End", hl.dsp.exec_cmd(execute .. "/clean.sh --on"))
hl.bind(M .. " + ALT + h", hl.dsp.exec_cmd(execute .. "/waybar.sh --kill"))
hl.bind(M .. " + ALT + u", hl.dsp.exec_cmd(execute .. "/waybar.sh --start"))
hl.bind(M .. " + SHIFT + t", hl.dsp.exec_cmd(execute .. "/.gtt.sh --extract"))

-- ─────────────────────────────────────────────
-- Multimedia / Brightness  { locked = true } keeps them active on lockscreen
-- ─────────────────────────────────────────────
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(waybar .. "/volume-control.sh --inc"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(waybar .. "/volume-control.sh --dec"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(waybar .. "/volume-control.sh --mute"), { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(execute .. "/.brightness.sh --up"), { locked = true, repeating = true })
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(execute .. "/.brightness.sh --down"),
	{ locked = true, repeating = true }
)

hl.bind("F3", hl.dsp.exec_cmd("hyprctl hyprsunset temperature -500"), { repeating = true })
hl.bind("F4", hl.dsp.exec_cmd("hyprctl hyprsunset temperature +500"), { repeating = true })
hl.bind("F5", hl.dsp.exec_cmd("hyprctl hyprsunset identity"))

hl.bind(M .. " + F7", hl.dsp.exec_cmd("hyprpicker | wl-copy"))
hl.bind(M .. " + XF86AudioMute", hl.dsp.exec_cmd(open .. " --soundmixer"))
hl.bind(M .. " + F9", hl.dsp.exec_cmd(open .. " --soundcontrol"))

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(media .. " --toggle"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(media .. " --stop"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(media .. " --next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(media .. " --previous"), { locked = true })

-- ─────────────────────────────────────────────
-- WM — window control
-- ─────────────────────────────────────────────
hl.bind(M .. " + CTRL + q", hl.dsp.window.close({ force = true }))
hl.bind(M .. " + CTRL + w", hl.dsp.window.close())
hl.bind(M .. " + CTRL + r", hl.dsp.exec_cmd("hyprctl reload"))

-- Node states
hl.bind(M .. " + CTRL + f", hl.dsp.window.fullscreen())
hl.bind(M .. " + CTRL + t", hl.dsp.window.float({ action = "toggle" }))
hl.bind(M .. " + CTRL + p", hl.dsp.window.pseudo())
hl.bind(M .. " + CTRL + l", hl.dsp.layout("togglesplit")) -- dwindle

-- Node flags
hl.bind(M .. " + CTRL + s", hl.dsp.window.pin()) -- sticky

--Hide / restore (niflveil plugin)
hl.bind(M .. " + CTRL + h", hl.dsp.exec_cmd("niflveil minimize"))
hl.bind(M .. " + CTRL + u", hl.dsp.exec_cmd("niflveil restore-last"))

-- ─────────────────────────────────────────────
-- Focus / Swap
-- ─────────────────────────────────────────────
hl.bind(M .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(M .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(M .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(M .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(M .. " + CTRL + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(M .. " + CTRL + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(M .. " + CTRL + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(M .. " + CTRL + down", hl.dsp.window.swap({ direction = "down" }))

-- Cycles
hl.bind(M .. " + Tab", hl.dsp.window.cycle_next())
hl.bind(M .. " + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))
hl.bind(M .. " + CTRL + Tab", hl.dsp.window.swap({ next = true }))
hl.bind(M .. " + CTRL + SHIFT + Tab", hl.dsp.window.swap({ prev = true }))

-- ─────────────────────────────────────────────
-- Workspaces
-- ─────────────────────────────────────────────
-- Switch last
hl.bind(M .. " + space", hl.dsp.focus({ workspace = "previous" }))

-- Directional
hl.bind(M .. " + comma", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(M .. " + period", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(M .. " + ALT + comma", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(M .. " + ALT + period", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(M .. " + SHIFT + comma", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(M .. " + SHIFT + period", hl.dsp.window.move({ workspace = "r+1" }))

-- Switch + move to numbered workspaces 1-9
for i = 1, 9 do
	hl.bind(M .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(M .. " + CTRL + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- ─────────────────────────────────────────────
-- Mouse — move / resize windows
-- ─────────────────────────────────────────────
hl.bind(M .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(M .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
