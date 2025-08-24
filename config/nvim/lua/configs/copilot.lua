require('copilot').setup({
  -- auto_start = false,
  panel = {
    enabled = false,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right | horizontal | vertical
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = false,
    auto_trigger = false,
    hide_during_completion = true,
    debounce = 75,
    trigger_on_accept = true,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    python = true,
    lua = true,
    terraform = true,
    markdown = true,
    yaml = false,
    sh = function()
      if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
        -- disable for .env files
        return false
      end
      return true
    end,
    ["*"] = false,         -- disable for all other filetypes and ignore default `filetypes`
  },
  auth_provider_url = nil, -- URL to authentication provider, if not "https://github.com/"
  logger = {
    file = vim.fn.stdpath("log") .. "/copilot-lua.log",
    file_log_level = vim.log.levels.OFF,
    print_log_level = vim.log.levels.WARN,
    trace_lsp = "off", -- "off" | "messages" | "verbose"
    trace_lsp_progress = false,
    log_lsp_messages = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 20
  workspace_folders = {},
  copilot_model = "",
  root_dir = function()
    return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
  end,
  should_attach = function(_, _)
    if not vim.bo.buflisted then
      logger.debug("not attaching, buffer is not 'buflisted'")
      return false
    end

    if vim.bo.buftype ~= "" then
      logger.debug("not attaching, buffer 'buftype' is " .. vim.bo.buftype)
      return false
    end

    return true
  end,
  server = {
    type = "nodejs", -- "nodejs" | "binary"
    custom_server_filepath = nil,
  },
  server_opts_overrides = {},
})
