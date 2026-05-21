-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
	input = {
		kb_options = "caps:swapescape", -- grp:alt_caps_toggle # idk this broke my kitty
		numlock_by_default = true,
		follow_mouse = 1,
		sensitivity = 0.175, -- -1.0 - 1.0, 0 means no modification.
		touchpad = {
			natural_scroll = true,
		},
	},
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#gestures
-- gestures {
--     workspace_swipe_use_r = true
-- }
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({
	fingers = 4,
	direction = "up",
	action = function()
		hl.dispatch(hl.dsp.window.fullscreen({ action = "toggle" }))
	end,
})
hl.gesture({
	fingers = 4,
	direction = "down",
	action = function()
		hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	end,
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
	name = "at-translated-set-2-keyboard",
	resolve_binds_by_sym = 0,
})
