-- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
hl.config({
	dwindle = {
		-- pseudotile = true, deprecated https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/#dispatchers
		preserve_split = true, -- You probably want this
		force_split = 2, -- right
		-- default_split_ratio = 1.5
		split_bias = 1,
	},
	-- https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
	master = {
		new_status = "slave",
		orientation = "left",
		mfact = 0.66,
		new_on_top = false,
		-- always_keep_position = true
	},
})
