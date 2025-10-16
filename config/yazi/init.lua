require("relative-motions"):setup({ show_numbers="none", show_motion = true })


require("yamb"):setup {
  jump_notify = true,
  cli = "fzf",
  keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
  path = (os.getenv("HOME") .. "/.config/yazi/bookmark"),
}

require("projects"):setup({
    save = {
        method = "yazi", -- yazi | lua
        yazi_load_event = "@projects-load", -- event name when loading projects in `yazi` method
        lua_save_path = "", -- path of saved file in `lua` method, comment out or assign explicitly
                            -- default value:
                            -- windows: "%APPDATA%/yazi/state/projects.json"
                            -- unix: "~/.local/state/yazi/projects.json"
    },
    last = {
        update_after_save = true,
        update_after_load = true,
        load_after_start = false,
    },
    merge = {
        event = "projects-merge",
        quit_after_merge = false,
    },
    event = {
        save = {
            enable = true,
            name = "project-saved",
        },
        load = {
            enable = true,
            name = "project-loaded",
        },
        delete = {
            enable = true,
            name = "project-deleted",
        },
        delete_all = {
            enable = true,
            name = "project-deleted-all",
        },
        merge = {
            enable = true,
            name = "project-merged",
        },
    },
    notify = {
        enable = true,
        title = "Projects",
        timeout = 3,
        level = "info",
    },
})

-- Get back old tabs but with new style and style cwd
function Tabs.height() return 0 end

Header:children_add(function()
        if #cx.tabs == 1 then return "" end
        local lines = {
                ui.Line(th.tabs.sep_outer.open):fg(th.tabs.inactive.bg)
        }
        for i = 1, #cx.tabs do
                local name = ya.truncate(cx.tabs[i].name, { max = 12 })
                if i == cx.tabs.idx then
                        lines[#lines + 1] = ui.Line {
                                ui.Span(th.tabs.sep_inner.open):bg(th.tabs.inactive.bg):fg(th.tabs.active.bg),
                                ui.Span(" "..i.." "..name.." "):style(th.tabs.active),
                                ui.Span(th.tabs.sep_inner.close):bg(th.tabs.inactive.bg):fg(th.tabs.active.bg),
                        }
                else
                        lines[#lines + 1] = ui.Line(" "..i.." "..name.." "):style(th.tabs.inactive)
                end
        end
        lines[#lines + 1] = ui.Line(th.tabs.sep_outer.close):fg(th.tabs.inactive.bg)
        return ui.Line(lines)
end, 9000, Header.RIGHT)

function Header:cwd()
	return ""
end

Header:children_add(function(state)
    local opener = ya.truncate(th.status.sep_left.open, { max = 1 })
    local closer = ya.truncate(th.status.sep_left.close, { max = 1 })

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
        --add_opener(th.tabs.inactive.bg, th.tabs.inactive.bg)
        --table.insert(path_spans, ui.Span("   "):fg(th.tabs.active.bg):bg(th.tabs.inactive.bg))
        --add_closer(th.tabs.inactive.bg, th.tabs.inactive.bg)
        add_opener(th.tabs.active.bg, th.tabs.inactive.bg)
        add_span("   ", th.tabs.active)
        add_closer(th.tabs.active.bg, th.tabs.inactive.bg)

    elseif cwd == "/" then
        -- Root directory
        add_opener(th.tabs.active.bg, th.tabs.inactive.bg)
        add_span("/", th.tabs.active)
        add_closer(th.tabs.active.bg, th.tabs.inactive.bg)

    else
        -- Normal path
        -- Trim trailing slashes
        cwd = cwd:gsub("/+$", "")
        local parent, leaf = cwd:match("^(.*)/([^/]+)$")

        if not parent or parent == "" then
            -- Path like `/usr` → no parent
            add_opener(th.tabs.active.bg, th.tabs.inactive.bg)
            add_span("/" .. leaf, th.tabs.active)
            add_closer(th.tabs.active.bg, th.tabs.inactive.bg)
        else
            -- Path like `/home/user/dev`
            add_opener(th.tabs.inactive.bg, th.tabs.inactive.bg)
            add_span(parent, th.tabs.inactive)
            add_closer(th.tabs.inactive.bg, th.tabs.active.bg)
            add_span("/" .. leaf, th.tabs.active)
            add_closer(th.tabs.active.bg, th.tabs.inactive.bg)
        end
    end

    local lines = {
        ui.Line(th.status.sep_left.open):fg(th.tabs.inactive.bg),
        ui.Line(path_spans),
        ui.Line(th.status.sep_left.close):fg(th.tabs.inactive.bg)
    }

    return ui.Line(lines)
end, 9000, Header.LEFT)

-- mshnwq/dupes.yazi
require("dupes"):setup {
	-- global args
	save_op = false, -- profiles will inherit save_op unless overridden
	-- auto_confirm = true, -- auto confirms apply operation
	profiles = {
		interactive = {
			-- add extra args
			args = { "-r" },
		},
		apply = {
			args = { "-r", "-N", "-d" },
			save_op = true, -- overrides global
		},
		-- custom = {
		-- 	args = { "-r", "-s" },
		-- },
	},
}
