local highlight_group = vim.api.nvim_create_augroup('yankhighlight', { clear = true })
vim.api.nvim_create_autocmd('textyankpost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local function lint_yaml_selection()
  local start_line, end_line = unpack(vim.fn.getpos("'<"), 2, 3), unpack(vim.fn.getpos("'>"), 2, 3)
  local temp_file = "/tmp/nvim_selected_yaml.yaml"
  vim.cmd(start_line .. "," .. end_line .. "write! " .. temp_file)
  local output = vim.fn.system("prettier " .. temp_file)
  vim.api.nvim_echo({ { output, "Normal" } }, false, {})
end

vim.api.nvim_create_user_command(
  "FormatYaml",
  function() lint_yaml_selection() end,
  { range = true }
)

-- -----------------------------------------------------------------------------
-- filetype functions
-- -----------------------------------------------------------------------------
local ft_lsp_group = vim.api.nvim_create_augroup("ft_lsp_group", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = "*docker-compose*.{yml,yaml}",
  group = ft_lsp_group,
  desc = "Fix the issue where the LSP does not start with docker-compose.",
  callback = function()
    vim.bo.filetype = "yaml.docker-compose"
  end
})
vim.api.nvim_create_user_command("LintDockeCompose", function()
  local file = vim.fn.expand("%")
  vim.fn.system('/home/mshnwq/.nvm/versions/node/v20.18.1/bin/dclint --fix ' .. file)
  vim.notify("dclint auto-fix applied to: " .. file, vim.log.levels.INFO)
end, { desc = "Fix docker-compose" })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = "*.gitlab-ci*.{yml,yaml}",
  group = ft_lsp_group,
  desc = "Fix the issue where the LSP does not start with gitlab-ci.",
  callback = function()
    vim.bo.filetype = "yaml.gitlab"
  end
})
-- Handeled from vim-helm plugin
-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
--   pattern = { "*/templates/*.yaml", "helmfile*.yaml" },
--   group = ft_lsp_group,
--   desc = "Fix the issue where the LSP does not start with helm type.",
--   callback = function()
--     vim.opt_local.filetype = "yaml.helm"
--   end
-- })

