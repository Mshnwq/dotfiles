-- ============================================================
-- LOOK AND FEEL  (converted from hyprlang → Lua / Hyprland 0.55+)
-- https://wiki.hypr.land/Configuring/Basics/Variables/
-- ============================================================

-- ── Pywal colors ─────────────────────────────────────────────
-- Fallback palette (Tokyo Night) used when the wal cache is absent.
-- The actual wal output goes to ~/.cache/wal/colors-hyprland.lua;
-- `source` has no Lua equivalent, so we pcall-require it instead and
-- fall back gracefully if it doesn't exist yet.

color0 = "rgba(1a1b26ff)"
color1 = "rgba(f7768eff)"
color2 = "rgba(9ece6aff)"
color3 = "rgba(e0af68ff)"
color4 = "rgba(7aa2f7ff)"
color5 = "rgba(bb9af7ff)"
color6 = "rgba(7dcfffff)"
color7 = "rgba(a9b1d6ff)"
-- color8–color11 are used below for borders; define sensible fallbacks.
-- Override all of these inside your wal output file.
color8 = "rgba(414868ff)" -- inactive border fallback
color10 = "rgba(7aa2f7ff)" -- active border start fallback
color11 = "rgba(bb9af7ff)" -- active border end fallback

-- Load wal colours if available; they should reassign the locals above.
pcall(require, "configs.pywal")

-- General
hl.config({
	general = {
		gaps_in = 4,
		gaps_out = 12,
		border_size = 1,
		col = {
			active_border = { colors = { color11, color10 }, angle = 90 },
			inactive_border = color8,
		},
		resize_on_border = false,
		allow_tearing = false,
	},
	-- Decoration
	decoration = {
		rounding = 2,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 0.85,
		dim_inactive = false,
		shadow = {
			enabled = false,
		},
		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},
	-- Animations
	animations = {
		enabled = true,
		workspace_wraparound = true,
	},
	-- Misc
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
	-- Debug
	debug = {
		vfr = true,
	},
})

-- Curves  (replaces `bezier = name, x1,y1,x2,y2`)
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Animations  (replaces `animation = leaf, enabled, speed, bezier[, style]`)
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
