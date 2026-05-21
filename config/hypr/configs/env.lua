-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
for k, v in pairs({
	XCURSOR_THEME = "Catppuccin Mocha Pywal",
	XCURSOR_SIZE = 18,
	HYPRCURSOR_THEME = "Catppuccin Mocha Pywal",
	HYPRCURSOR_SIZE = 18,
	QT_QPA_PLATFORMTHEME = "qt6ct",
	QT_STYLE_OVERRIDE = "kvantum",
	XDG_SESSION_TYPE = "wayland",
	XDG_CURRENT_DESKTOP = "Hyprland",
}) do
	hl.env(k, v)
end
