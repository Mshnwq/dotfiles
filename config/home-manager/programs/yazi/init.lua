-- Get back old tabs but with new style and style cwd
function Tabs.height()
	return 0
end

Header:children_add(function()
	if #cx.tabs == 1 then
		return ""
	end
	local lines = {
		ui.Line(th.tabs.sep_outer.open):fg(th.tabs.inactive.bg),
	}
	for i = 1, #cx.tabs do
		local name = ya.truncate(cx.tabs[i].name, { max = 12 })
		if i == cx.tabs.idx then
			if i == #cx.tabs then
				lines[#lines + 1] = ui.Line({
					ui.Span(th.tabs.sep_inner.open):bg(th.tabs.inactive.bg):fg(th.tabs.active.bg),
					ui.Span(" " .. i .. " " .. name .. " "):style(th.tabs.active),
					ui.Span(th.tabs.sep_inner.close):bg(th.tabs.active.bg):fg(th.tabs.active.bg),
				})
			else
				lines[#lines + 1] = ui.Line({
					ui.Span(th.tabs.sep_inner.open):bg(th.tabs.inactive.bg):fg(th.tabs.active.bg),
					ui.Span(" " .. i .. " " .. name .. " "):style(th.tabs.active),
					ui.Span(th.tabs.sep_inner.close):bg(th.tabs.inactive.bg):fg(th.tabs.active.bg),
				})
			end
		else
			lines[#lines + 1] = ui.Line(" " .. i .. " " .. name .. " "):style(th.tabs.inactive)
		end
	end
	return ui.Line(lines)
end, 9000, Header.RIGHT)

function Header:cwd()
	return ""
end

Header:children_add(function(state)
	local opener = ya.truncate(th.status.sep_left.open, { max = 1 })
	local closer = ya.truncate(th.tabs.sep_outer.close, { max = 1 })

	local cwd = tostring(cx.active.current.cwd)
	local home = os.getenv("HOME") or ""
	cwd = cwd:gsub("^" .. home, "~")

	local path_spans = {}

	-- Helper to add a segment with optional style overrides
	local function add_span(text, style)
		table.insert(path_spans, ui.Span(text):style(style))
	end

	-- Helper to add styled opener/closer
	local function add_opener(fg, bg)
		add_span(opener, { fg = fg, bg = bg })
	end

	local function add_closer(fg, bg)
		add_span(closer, { fg = fg, bg = bg })
	end

	if cwd == "~" then
		-- Home directory
		add_opener(th.tabs.active.bg, th.tabs.inactive.bg)
		add_span("   ", th.tabs.active)
		add_closer(th.tabs.active.bg, th.tabs.inactive.bg)
	elseif cwd == "/" then
		-- Root directory
		add_opener(th.tabs.active.bg, th.tabs.inactive.bg)
		add_span(" ", th.tabs.active)
		add_closer(th.tabs.active.bg, th.tabs.inactive.bg)
	else
		-- Normal path
		cwd = " " .. cwd:gsub("/+$", "")
		local parent, leaf = cwd:match("^(.*)/([^/]+)$")
		if not parent or parent == " " or parent == "" then
			-- Path like `/usr` → no parent
			add_opener(th.tabs.active.bg, th.tabs.inactive.bg)
			add_span(" /" .. leaf, th.tabs.active)
			add_closer(th.tabs.active.bg, th.tabs.inactive.bg)
		else
			-- Path like `/home/user/dev` or `~/Desktop`
			add_opener(th.tabs.inactive.bg, th.tabs.inactive.bg)
			add_span(parent, th.tabs.inactive)
			add_closer(th.tabs.inactive.bg, th.tabs.active.bg)
			add_span("/" .. leaf, th.tabs.active)
			add_closer(th.tabs.active.bg, th.tabs.inactive.bg)
		end
	end

	local lines = {
		-- ui.Line(th.tabs.sep_outer.open):fg(th.tabs.inactive.bg),
		-- ui.Line(" "):style(th.tabs.inactive),
		ui.Line(path_spans),
		ui.Line(th.tabs.sep_outer.close):fg(th.tabs.inactive.bg),
	}

	return ui.Line(lines)
end, 9000, Header.LEFT)
