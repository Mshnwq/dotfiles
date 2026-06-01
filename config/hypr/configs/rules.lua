-- ============================================================
-- Window Rules  (converted from hyprlang → Lua / Hyprland 0.55+)
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- ============================================================

-- ── Workspace layout rules ───────────────────────────────────
hl.workspace_rule({ workspace = "2", layout = "master" })
hl.workspace_rule({ workspace = "6", layout = "master" })

-- ── Opacity ─────────────────────────────────────────────────
-- active / inactive / fullscreen
for _, rule in ipairs({
	{ match = { class = ".*" }, opacity = "1 override 1 override 1 override" },
	{ match = { class = "firefox", title = "^Mozilla Firefox$" }, opacity = "0.8 override 0.9 override 1 override" },
	{ match = { class = "org.pwmt.zathura" }, opacity = "0.9 override 0.95 override 1 override", float = true, },
	{ match = { class = "obsidian", title = ".*Obsidian.*" }, opacity = "0.93 override 0.91 override 1 override" },
}) do
	hl.window_rule(rule)
end

-- ── Workspace assignments ─────────────────────────────────────
for _, rule in ipairs({
	{ match = { class = "InitTerm" }, workspace = "2" },
	{ match = { class = "discord" }, workspace = "4" },
	{ match = { class = "anki" }, workspace = "5" },
	{ match = { class = "obsidian", title = ".*Obsidian.*" }, workspace = "6" },
}) do
	hl.window_rule(rule)
end

-- ── Floating / size ───────────────────────────────────────────
-- "Desktop" apps: float with a comfortable default size
hl.window_rule({
	name = "desktops",
	match = {
		class = "org.(kde.gwenview|fkoehler.KTailctl|telegram.desktop|pulseaudio.pavucontrol|qbittorrent.qBittorrent|rncbc.qpwgraph|keepassxc.KeePassXC)",
	},
	float = true,
	size = { 1080, 620 },
})
hl.window_rule({
	name = "zap",
	match = {
		class = "com.rtosta.zapzap",
	},
	float = true,
	size = { 1080, 620 },
})
for _, rule in ipairs({
	-- KeePassXC password generator
	{
		name = "keepass",
		match = { class = "org.keepassxc.KeePassXC", title = "^Generate Password$" },
		size = { 540, 360 },
		center = true,
	},
	-- XDG portal file-picker
	{
		name = "xdg-desktop-portal-gtk",
		match = { class = "xdg-desktop-portal-gtk" },
		size = { 720, 480 },
		float = true,
	},
	-- qBittorrent removal dialog
	{
		name = "qbittorrent",
		match = { class = "org.qbittorrent.qBittorrent", title = "^Remove.*$" },
		size = { 540, 360 },
		center = true,
	},
	-- Anki modal dialogs: float + centre
	{
		name = "anki",
		match = { class = "anki", title = "^(Options|Import).*$" },
		size = { 620, 620 },
		center = true,
	},
	--LMMS settings
	{
		match = { class = "lmms", title = "Settings" },
		size = { 640, 570 },
		float = true,
	},
	-- ZapZap Download
	{
		name = "zapzap",
		match = { class = "com.rtosta.zapzap", title = "Download" },
		size = { 540, 360 },
		center = true,
	},
}) do
	hl.window_rule(rule)
end

-- ── mpv ─────────────────────────────────────────────────────
for _, rule in ipairs({
	{ center = true, float = true },
	{ name = "mpv-video", match = { title = ".*\\.(mkv|mp4|m4v|wmv|avi|mov)$" }, size = { 1080, 620 } },
	{ name = "mpv-audio", match = { title = ".*\\.(m4a|mp3|aac)$" }, size = { 480, 480 } },
}) do
	rule.match = rule.match or {}
	rule.match.class = "mpv"
	hl.window_rule(rule)
end

-- ── Terminal / blur rules ────────────────────────────────────
-- kitty: never float when launched as the main terminal
hl.window_rule({ match = { class = "^kitty$", title = "^kitty$" }, float = false })
-- Keep blur on for named terminals, even without focus
for _, class in ipairs({ ".*Term", "kitty", "alacritty" }) do
	hl.window_rule({ match = { class = class }, no_blur = false, no_focus = false })
end
-- Disable blur on everything that currently lacks focus
-- hl.window_rule({ match = { focus = false }, no_blur = true })

-- ── FloaTerm windows ─────────────────────────────────────────
hl.window_rule({ match = { class = "FloaTerm" }, float = true })
for _, t in ipairs({
	{ "FloaTerm", { 720, 480 } },
	{ "ExecTerm", { 740, 480 } },
	{ "MusicTerm", { 920, 540 } },
	{ "SoundTerm", { 720, 480 } },
	{ "DiskTerm", { 860, 215 } },
	{ "FetchTerm", { 860, 600 } },
	{ "TopTerm", { 1080, 620 } },
	{ "K9Term", { 1080, 620 } },
	{ "TranTerm", { 1080, 620 } },
	{ "FileTerm", { 1080, 620 } },
	{ "CavaTerm", { 920, 480 } },
}) do
	local rule = { match = { class = "FloaTerm", title = t[1] }, size = t[2] }
	if t[1] == "FileTerm" then
		rule.workspace = "3"
	end
	if t[1] == "CavaTerm" then
		rule.border_size = 0
	end
	hl.window_rule(rule)
end

-- ── Layer rules ──────────────────────────────────────────────
hl.layer_rule({
	match = { namespace = "rofi" },
	dim_around = true,
})

-- ── Misc / global rules ──────────────────────────────────────
-- Suppress maximize requests from every app
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix XWayland drag-and-drop ghost windows
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		fullscreen = false,
		xwayland = true,
		float = true,
		class = "^$",
		title = "^$",
		pin = false,
	},
	no_focus = true,
})

-- hyprland-run: pin to bottom-left corner
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = { 20, "monitor_h-120" },
	float = true,
})
