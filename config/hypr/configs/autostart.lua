-- https://wiki.hypr.land/Configuring/Basics/Autostart/
local exec = os.getenv("HOME") .. "/.local/bin/executer/"
hl.on("hyprland.start", function()
	hl.exec_cmd("cliphist wipe; wl-paste --watch cliphist store")
	for _, daemon in ipairs({
		"awww-daemon",
		"hyprsunset",
		"hypridle",
	}) do
		hl.exec_cmd(daemon)
	end
	for _, cmd in ipairs({
		"waybar.sh --bluetooth stop",
		"daemons.sh --syncthing stop",
		"clean.sh --off",
	}) do
		hl.exec_cmd(exec .. cmd)
	end
end)
