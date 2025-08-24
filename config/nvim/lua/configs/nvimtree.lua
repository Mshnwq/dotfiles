return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    dofile(vim.g.base46_cache .. "nvimtree")

    local map = vim.keymap.set
    local nvtree = require "nvim-tree"
    local api = require "nvim-tree.api"

    -- Add custom mappings
    local function custom_on_attach(bufnr)
      local function opts(desc)
        return {
          desc = "nvim-tree: " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true
        }
      end

      api.config.mappings.default_on_attach(bufnr)
      map("n", "+", api.tree.change_root_to_node, opts "CD")
      map("n", "?", api.tree.toggle_help, opts "Help")
      map("n", "<ESC>", api.tree.close, opts "Close")
      map("n", "<C-e>", api.tree.close, opts "Close")
    end

    -- Automatically open file upon creation
    api.events.subscribe(api.events.Event.FileCreated, function(file)
      vim.cmd("edit " .. file.fname)
    end)

    local HEIGHT_RATIO = 0.8
    local WIDTH_RATIO = 0.5

    nvtree.setup {
      on_attach = custom_on_attach,
      sync_root_with_cwd = true,
      disable_netrw = true,
      hijack_cursor = true,
      update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {}
      },
      filters = {
        custom = { "^.git$" }
      },
      git = {
        enable = true,
        ignore = false,
      },
      renderer = {
        root_folder_label = false,
        highlight_git = true,
        indent_markers = {
          enable = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "├",
            none = " "
          }
        },
        icons = {
          glyphs = {
            default = "󰈚",
            folder = {
              default = "",
              empty = "",
              empty_open = "",
              open = "",
              symlink = "",
            },
            git = {
              unstaged = "",
              staged = "",
              unmerged = "",
              renamed = "",
              untracked = "",
              deleted = "",
              ignored = "󰴲"
            }
          }
        }
      },
      view = {
        width = 30,
        preserve_window_proportions = true,
      },
      filesystem_watchers = {
        ignore_dirs = { "node_modules" }
      }
    }
  end
}
