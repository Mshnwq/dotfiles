-- Get back old tabs but with new style and style cwd

-- clear new
function Tabs.height()
	return 0
end
function Header:cwd()
	return ""
end

-- replaces tabs
Header:children_add(function()
	if #cx.tabs == 1 then
		return ""
	end
	local lines = {
		ui.Line(th.tabs.sep_outer.open):style(th.tabs.inactive),
	}
	for i = 1, #cx.tabs do
		local name = ui.truncate(cx.tabs[i].name, { max = 12 })
		if i == cx.tabs.idx then
			if i == #cx.tabs then
				lines[#lines + 1] = ui.Line({
					ui.Span(th.tabs.sep_inner.open):style(th.help.footer),
					ui.Span(" " .. i .. " " .. name .. " "):style(th.mode.normal_main),
				})
			else
				lines[#lines + 1] = ui.Line({
					ui.Span(th.tabs.sep_inner.open):style(th.help.footer),
					ui.Span(" " .. i .. " " .. name .. " "):style(th.mode.normal_main),
					ui.Span(th.tabs.sep_inner.close):style(th.help.footer),
				})
			end
		else
			lines[#lines + 1] = ui.Line(" " .. i .. " " .. name .. " "):style(th.mode.normal_alt)
		end
	end
	return ui.Line(lines)
end, 9000, Header.RIGHT)

-- replaces cwd
Header:children_add(function()
	local opener = ui.truncate(th.status.sep_left.open, { max = 1 })
	local closer = ui.truncate(th.tabs.sep_outer.close, { max = 1 })

	local cwd = tostring(cx.active.current.cwd)
	local home = os.getenv("HOME") or ""
	cwd = cwd:gsub("^" .. home, "~")

	local path_spans = {}

	-- Helper to add a segment with optional style overrides
	local function add_span(text, style)
		table.insert(path_spans, ui.Span(text):style(style))
	end

	if cwd == "~" then
		-- Home directory
		add_span(opener, th.tabs.active)
		add_span("   ", th.mode.normal_main)
		add_span(closer, th.help.footer)
	elseif cwd == "/" then
		-- Root directory
		add_span(opener, th.tabs.active)
		add_span(" ", th.mode.normal_main)
		add_span(closer, th.help.footer)
	else
		-- Normal path
		cwd = " " .. cwd:gsub("/+$", "")
		local parent, leaf = cwd:match("^(.*)/([^/]+)$")
		if not parent or parent == " " or parent == "" then
			-- Path like `/usr` → no parent
			add_span(opener, th.tabs.active)
			add_span(" /" .. leaf, th.mode.normal_main)
			add_span(closer, th.help.footer)
		else
			-- Path like `/home/user/dev` or `~/Desktop`
			add_span(opener, th.mode.normal_main)
			add_span(parent, th.mode.normal_alt)
			add_span(closer, th.help.desc)
			add_span("/" .. leaf, th.mode.normal_main)
			add_span(closer, th.help.footer)
		end
	end

	local lines = {
		ui.Line(path_spans),
		ui.Line(th.tabs.sep_outer.close):style(th.tabs.inactive),
	}

	return ui.Line(lines)
end, 9000, Header.LEFT)
