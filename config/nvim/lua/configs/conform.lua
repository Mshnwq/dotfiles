-- https://github.com/stevearc/conform.nvim
local conform = require("conform")
local options = {
  default_format_opts = {
    timeout_ms = 3000,
    async = false,           -- not recommended to change
    quiet = false,           -- not recommended to change
    lsp_format = "fallback", -- not recommended to change
  },
  -- format_on_save = {
  -- 	lsp_fallback = true,
  -- 	async = false,
  -- 	timeout_ms = 500,
  -- },
  formatters_by_ft = {
    lua = { "stylua" },
    -- use the lsp
    -- go = { "gofumpt", "goimports-reviser", "golines" },
    -- gomod = { "gofumpt", "goimports-reviser" },
    -- gowork = { "gofumpt", "goimports-reviser" },
    -- gotmpl = { "gofumpt", "goimports-reviser" },
    yaml = { "prettier" },
    yml = { "prettier" },
    -- javascript = { { "prettierd", "prettier" } },
    -- typescript = { { "prettierd", "prettier" } },
    -- javascriptreact = { { "prettierd", "prettier" } },
    -- typescriptreact = { { "prettierd", "prettier" } },
    -- css = { { "prettierd", "prettier" } },
    -- css = { "prettier" },
    -- scss = { { "prettierd", "prettier" } },
    -- html = { { "prettierd", "prettier" } },
    -- json = { { "prettierd", "prettier" } },
    -- jsonc = { { "prettierd", "prettier" } },
    -- html = { "prettier" },
  },
  formatters = {
  },
}

-- https://github.com/mvdan/sh
conform.formatters_by_ft.bash = { "shfmt" }
conform.formatters_by_ft.sh = { "shfmt" }
conform.formatters.shfmt = {
  inherit = false,
  command = "shfmt",
  args = { "-ci", "-i", "2", "-filename", "$FILENAME" },
}

local venv = vim.env.HOME .. "/.nix-profile/bin/"
conform.formatters_by_ft.python = { "isort", "ruff_format" }
conform.formatters.isort = {
  command = venv .. "isort",
}

-- use the lsp
-- conform.formatters["goimports-reviser"] = {
--   prepend_args = { "-rm-unused" },
-- }
-- conform.formatters.golines = {
--   prepend_args = { "--max-len=80" },
-- }

return options
