-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  transparency = true,
  -- theme = "tokyonight",
  -- use tokyonight when initializing
  -- then python3 ~/.config/nvim/pywal/chadwal.py
  theme = "chadwal", 

  -- start replace from rice
  hl_override = {
    St_NormalMode = { bg = "#98837C" },
    St_NormalModeSep = { fg = "#98837C", bg = "#121212" },
    St_InsertMode = { bg = "#A99289" },
    St_InsertModeSep = { fg = "#A99289", bg = "#121212" },
    St_VisualMode = { bg = "#757575" },
    St_VisualModeSep = { fg = "#757575", bg = "#121212" },
    St_CommandMode = { bg = "#8B7871" },
    St_CommandModeSep = { fg = "#8B7871", bg = "#121212" },
    St_TerminalMode = { bg = "#7E8181" },
    St_TerminalModeSep = { fg = "#7E8181", bg = "#121212" },
    St_NTerminalMode = { bg = "#7E8181" },
    St_NTerminalModeSep = { fg = "#7E8181", bg = "#121212" },
    St_EmptySpace = { fg = "#98837C", bg = "#121212" },
    St_file = { fg = "#121212", bg = "#6e5959" },
    St_file_sep = { fg = "#6e5959" },
    St_pos_icon = { fg = "#121212", bg = "#98837C" },
    St_pos_sep = { fg = "#98837C", bg = "none" },
    St_pos_text = { fg = "#121212", bg = "#6e5959" },
    St_Lsp = { fg = "#98837C" },
    St_LspMsg = { fg = "#98837C" },
    TbTabOn = { fg = "#98837C", bg = "#6e5959" },
    TbTabOff = { fg = "#121212", bg = "#6e5959" },
  },
  hl_add = {
    St_Lint = { fg = "#8B7871", bg = "none" },
    NotifyINFOIcon = { fg = "green" },
    NotifyINFOTitle = { fg = "green" },
    NotifyINFOBorder = { fg = "grey_fg" },
    NotifyERRORIcon = { fg = "red" },
    NotifyERRORTitle = { fg = "red" },
    NotifyERRORBorder = { fg = "grey_fg" },
    NotifyWARNIcon = { fg = "yellow" },
    NotifyWARNTitle = { fg = "yellow" },
    NotifyWARNBorder = { fg = "grey_fg" },
    TodoError = { fg = "red" },
    TodoWarn = { fg = "#BFA1FF" },
    TodoInfo = { fg = "yellow" },
    TodoHint = { fg = "green" },
    TodoTest = { fg = "cyan" },
    TodoDefault = { fg = "grey_fg" },
  },
  -- end replace from rice
  -- print(dofile(vim.g.base46_cache .. "colors").yellow)
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
          local small_btn = btn(" ", "TabTitle", "ToggleTabs")
          local new_tabtn = btn("%#St_file_sep#" .. sep_ul .. "%#St_pos_text# 󰐕 ", "TabNewBtn", "NewTab")
          local tabstoggleBtn = btn("%#St_pos_text# TABS ", "TabTitle", "ToggleTabs")
          return g.TbTabsToggled == 1 and small_btn or new_tabtn .. result .. tabstoggleBtn
        end
        return ""
      end,
    },
  },
  
  statusline = {
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lint", "lsp", "cursor" },
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
        return current_mode .. mode_sep1
      end,
      file = function()
        local x = require("nvchad.stl.utils").file()
        local name = " " .. x[2] .. " "
        return "%#St_file_sep#" .. sep_ul .. "%#St_file# " .. x[1] .. name .. "%#St_file_sep#" .. sep_dr
      end,
      lint = function()
        local linters = require("lint").get_running()
        if #linters == 0 then
          return "%#St_Lint# 󰦕 "
        end
        return "%#St_Lint# 󱉶 " .. table.concat(linters, ", ")
      end,
      cursor = function()
        if vim.bo.filetype == "alpha" then
          return ""
        end
        return "%#St_file_sep#"
            .. sep_dl
            .. "%#St_pos_text#"
            .. " %P %l:%c "
            .. "%#St_file_sep#"
            .. sep_ur
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
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠟⠛⠛⠛⠛⠛⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠙⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢀⣀⣀⣄⣤⣤⣦⣶⣶⣤⣀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⣰⠿⡏⠁⠕⢚⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠰⠠⠀⠀⠀⠀⠲⠚⠉⠓⢿⣿⣧⣄⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠔⠀⠂⠀⠀⠀⠀⠀⠀⠐⠠⠈⢻⣿⣷⡀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡋⢀⠀⠀⠀⢰⣾⠀⠀⠀⠀⠀⠀⠔⠐⠛⣿⠆⠀⢀⠔⢀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠠⠀⢠⣺⣿⡀⠀⠀⠀⠲⣷⡊⠨⢲⡩⠇⠀⣈⠁⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢳⠀⢀⠸⠭⠅⠲⠀⠀⠐⠀⢄⠉⠊⠙⠀⠀⠀⢸⣁⡁⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡜⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⠀⠀⠀⠀⠀⠀⠈⣡⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⠁⠀⠐⠀⠠⠠⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣾⢟⣽⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠁⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣟⣿⣿⣿⣿⣿⣿⣇⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⣄⣀⣀⣀⣀⠀⠀⢛⣏⣽⣿⣿⣿⣾⣿⣿⣿⣿⣾⣶⣯⣍⡛⡛⠿⢿⣿⣿⣿⣿⣿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢹⡕⠀⠀⠸⣿⣿⣽⣿⣿⣿⣿⣿⣿⣿⣽⣿⠟⢫⠘⢑⠴⣢⣄⡉⠛⠻⢿",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣶⡀⠀⢺⣿⠟⣹⣿⣿⣿⣿⣿⣿⣿⣷⣇⠀⠀⠀⠀⠘⡵⠫⢴⡗⠄",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣻⣕⢾⣿⣿⣦⠀⠘⠫⠐⣿⣿⣿⣾⣿⣿⣿⣿⣿⢗⣅⠀⠀⠀⠀⠀⠐⢼⠟⠇",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢫⣶⢛⡟⡍⢸⣟⡼⡘⠀⠀⠀⠈⢹⣿⠃⠉⠈⠁⠙⢑⣉⣁⣀⣤⣤⣤⣤⣶⣶⠔⠀⠀",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣫⣞⠵⡕⣮⣬⣴⡾⡿⢶⣷⠀⠀⠀⡆⠈⣁⡠⠔⢶⡞⢫⢻⢿⠙⠛⠋⣻⢿⡿⣿⠃⠀⡠⣴",
    -- "⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢟⣭⣷⣶⣦⢠⡿⣠⣿⣶⣧⣴⣐⣠⡬⠉⠃⠀⡜⡠⠾⠙⠃⠀⠀⠀⠠⢄⢆⡐⠤⢑⠟⠟⠏⠀⠀⣼⣿⣿",
    -- "⣿⣿⣿⡿⢟⣻⣭⣶⣾⣿⣿⣿⣿⣿⣟⣁⣽⡏⢝⢿⣯⢷⣝⠋⠀⠀⠉⠛⡗⠁⠀⠀⠀⢀⡠⣴⣾⡻⠞⠾⣨⡀⡀⠀⠀⠀⠈⢿⣿⣻",
    -- "⣿⠟⣫⣾⣿⣿⣿⣿⣿⡿⢻⣿⣿⣷⣿⣿⣼⣿⡡⣘⠚⠏⠀⠀⠀⠀⠀⠀⠈⠄⠀⡄⢠⣀⡋⣷⣿⣿⣖⡁⢔⡅⠂⠀⠀⠀⠀⠀⠋⠞",
    -- "⣡⣾⣿⣿⣿⣿⣿⡿⠋⣴⣿⣿⣿⣿⣿⣻⡻⠿⠑⡽⢿⠖⡝⠁⠀⠀⠀⠀⠀⠂⢀⠤⣘⣙⣽⣻⡿⣈⡆⠭⠀⠈⠨⠡⠀⠀⠀⠀⠀⠀",
    -- "⣿⣿⣿⣿⣿⣿⡿⠓⢇⢾⣿⣿⣿⢛⣿⣷⣿⣿⢻⡧⣝⠏⠀⠀⠀⠀⠀⣀⢀⡂⣲⢢⢨⣭⣼⡣⡉⠁⠀⠁⠄⠀⠀⠈⠀⠀⠀⠀⠀⠀",
    -- "⣿⣿⣿⣿⣿⣿⡇⠀⢠⡿⢿⢿⣇⡿⠛⢻⢻⠐⠘⠈⠀⢀⠀⠀⠀⠀⢠⠷⢋⡛⣆⣭⡪⠦⠍⠃⠀⠀⠀⠀⠊⠀⠀⠀⠀⠀⢑⣶⣆⣄",
    ---
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
  -- buttons = {
  -- { "  Find File", "Spc f f", "Telescope find_files" },
  -- { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
  -- { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
  -- { "  Bookmarks", "Spc m a", "Telescope marks" },
  -- { "  Themes", "Spc t h", "Telescope themes" },
  -- { "  Mappings", "Spc c h", "NvCheatsheet" },
  -- },
}

M.term = {
  winopts = { number = false, relativenumber = false },
  float = {
    relative = "editor",
    row = 0.5,
    col = 0.5,
    width = 0.5,
    height = 0.5,
    border = "single",
  },
}

return M
