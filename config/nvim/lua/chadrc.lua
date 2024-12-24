-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "catppuccin",
	transparency = true,

	hl_override = {
		St_NormalMode = { bg = "cyan" },
		St_NormalModeSep = { fg = "cyan" },
		St_InsertMode = { bg = "#BFA1FF" },
		St_InsertModeSep = { fg = "#BFA1FF" },
		St_VisualMode = { bg = "green" },
		St_VisualModeSep = { fg = "green" },
		St_CommandMode = { bg = "yellow" },
		St_CommandModeSep = { fg = "yellow" },
		-- St_pos_text = { bg = "none" }
	},
}

_G.sep_ul = ""
_G.sep_dr = ""
_G.sep_ur = ""
_G.sep_dl = ""

M.ui = {
	cmp = {
		-- style = "default", -- default/flat_light/flat_dark/atom/atom_colored
		style = "atom", -- default/flat_light/flat_dark/atom/atom_colored
	},
	tabufline = {
		order = { "treeOffset", "buffers", "tabs" },
		modules = {
			tabs = function()
				local g = vim.g
				g.TbTabsToggled = 0

				local fn = vim.fn
				local btn = require("nvchad.tabufline.utils").btn
				local result, tabs = "", fn.tabpagenr("$")

				if tabs > 1 then
					for nr = 1, tabs, 1 do
						local tab_hl = "TabO" .. (nr == fn.tabpagenr() and "n" or "ff")
						result = result .. btn(" " .. nr .. " ", tab_hl, "GotoTab", nr)
					end

					local new_tabtn = btn("%#St_file_sep#" .. sep_ul .. "%#St_pos_text# 󰐕 ", "TabNewBtn", "NewTab")
					local tabstoggleBtn = btn("%#St_pos_text# TABS ", "TabTitle", "ToggleTabs")
					local small_btn = btn(" 󰅁 ", "TabTitle", "ToggleTabs")

					return g.TbTabsToggled == 1 and small_btn or new_tabtn .. result .. tabstoggleBtn
				end

				local d
				return ""
			end,
		},
	},

	statusline = {
		order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cursor" },
		modules = {
			mode = function()
				local utils = require("nvchad.stl.utils")
				if not utils.is_activewin() then
					return ""
				end

				local modes = utils.modes

				local m = vim.api.nvim_get_mode().mode

				local current_mode = "%#St_" .. modes[m][2] .. "Mode# " .. modes[m][1] .. " "
				local mode_sep1 = "%#St_" .. modes[m][2] .. "ModeSep#" .. sep_dr
				return current_mode .. mode_sep1 .. "%#ST_EmptySpace#" .. sep_dr
			end,
			file = function()
				local x = require("nvchad.stl.utils").file()
				local name = " " .. x[2] .. " "
				return "%#St_file# " .. x[1] .. name .. "%#St_file_sep#" .. sep_dr
			end,
			cursor = function()
				if vim.bo.filetype == "alpha" then
					return ""
				end
				return "%#St_file_sep#"
					.. sep_dl
					.. "%#St_pos_text#"
          .. " %P %l:%c "
					.. "%#St_pos_sep#"
					.. sep_dl
					.. "%#St_pos_icon#  "
			end,
		},
	},
}

M.colorify = {
	mode = "bg", -- fg, bg, virtual
}

M.nvdash = {
	load_on_startup = false,
	header = {
		"           ▄ ▄                   ",
		"       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
		"       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
		"    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
		"  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
		"  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
		"▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
		"█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
		"    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
		"                                 ",
	},
}

-- M.term = {
--   winopts = { number = true, relativenumber = false },
--   float = {
--     relative = "editor",
--     row = 0.6,
--     col = 0.25,
--     width = 0.9,
--     height = 0.4,
--     border = "single",
--   },
-- }

return M
