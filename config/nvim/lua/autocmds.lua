require "nvchad.autocmds"

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
  pattern = "*compose*.{yml,yaml}",
  group = ft_lsp_group,
  desc = "Fix the issue where the LSP does not start with docker-compose.",
  callback = function()
    vim.bo.filetype = "yaml.docker-compose"
  end
})
vim.api.nvim_create_user_command("DockerComposeLint", function()
  local file = vim.fn.expand("%")
  vim.fn.system(
    string.format(
      "bash -c '$HOME/.asdf/installs/nodejs/20.18.1/bin/dclint --fix %s'",
      file
    )
  )
  vim.notify("dclint auto-fix applied to: " .. file, vim.log.levels.INFO)
end, { desc = "Fix docker-compose" })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = { "*.gitlab-ci*.{yml,yaml}", "*/.gitlab-ci/*.{yml,yaml}" },
  group = ft_lsp_group,
  desc = "Fix the issue where the LSP does not start with gitlab-ci.",
  callback = function()
    vim.bo.filetype = "yaml.gitlab"
  end
})
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = "*.{yml,yaml}.tftpl",
  group = ft_lsp_group,
  desc = "Fix the issue where the LSP for yaml.tftpl.",
  callback = function()
    vim.bo.filetype = "yaml"
  end
})
-- Handled from vim-helm plugin
-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
--   pattern = { "*/templates/*.yaml", "helmfile*.yaml" },
--   group = ft_lsp_group,
--   desc = "Fix the issue where the LSP does not start with helm type.",
--   callback = function()
--     vim.opt_local.filetype = "yaml.helm"
--   end
-- })

-- vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
--   pattern = { "*.ron" },
--   callback = function()
--     vim.bo.filetype = "ron"
--   end
-- })

-- -----------------------------------------------------------------------------
-- scratchterm functions
-- -----------------------------------------------------------------------------
local uv = vim.loop

-- Determine the project name based on Git worktrees or normal directories
local function get_project_name()
  local cwd = vim.fn.getcwd()
  -- Check if the parent directory ends with `.git` (Git worktree case)
  local parent_dir = vim.fn.fnamemodify(cwd, ":h") -- Parent directory of `cwd`
  if vim.endswith(parent_dir, ".git") then
    return vim.fn.fnamemodify(parent_dir, ":t:r")  -- Get the base name without `.git`
  end
  -- Fallback to the name of the current working directory (normal case)
  return vim.fn.fnamemodify(cwd, ":t")
end

local function get_socket_path()
  local project_name = get_project_name()
  return string.format("/tmp/nvim-kitty-%s.sock", project_name)
end
local function socket_exists(socket_path)
  return uv.fs_stat(socket_path) ~= nil
end

-- Initialize a Kitty terminal listening on the project-specific socket
local function init_term()
  local socket_path = get_socket_path()

  if not socket_exists(socket_path) then
    vim.fn.system({
      "hyprctl",
      "dispatch",
      "layoutmsg",
      "setlayout",
      "master",
    })

    local job = uv.spawn("kitty", {
      args = {
        "--class", "nvScratchTerm",
        "--listen-on", "unix:" .. socket_path,
        "--config", vim.env.HOME .. "/.config/kitty/kitty-scratch.conf",
      },
      stdio = { nil, nil, nil },
      detached = true
    }, function(code, signal)
      -- Callback after the process exits
      if code == 0 then
        print("Kitty terminal ended successfully.")
      else
        print("Failed to start Kitty terminal. Exit code:", code, "Signal:", signal)
      end
    end)

    -- Detach the process immediately to avoid blocking
    if job then
      uv.unref(job)
      print("Kitty terminal initialized in the background with socket:", socket_path)

      -- Use a timer to wait for 2 seconds before sending commands
      local timer = io.popen("sleep " .. 2)
      timer:close()

      vim.fn.system({
        "kitty", "@", "--to",
        "unix:" .. socket_path,
        "set-tab-title", get_project_name(),
      })
    else
      print("Failed to spawn Kitty terminal.")
    end
  else
    print("Socket already exists:", socket_path)
  end
end

local function get_kitty_window_id(socket_path, title)
  -- Fetch the current Kitty window state
  local command = string.format("kitty @ --to unix:%s ls", socket_path)
  local result = vim.fn.system(command)

  -- Parse the JSON response
  local ok, data = pcall(vim.json.decode, result)
  if not ok or type(data) ~= "table" then
    print("Failed to parse Kitty response or invalid response.")
    return nil
  end

  -- Search for the window with the given title
  for _, os_window in ipairs(data) do
    for _, tab in ipairs(os_window.tabs or {}) do
      for _, window in ipairs(tab.windows or {}) do
        if window.title == title then
          return window.id -- Return the window ID if found
        end
      end
    end
  end

  return nil -- Return nil if no matching window is found
end

local function send_to_kitty(command, title, dir)
  local socket_path = get_socket_path()

  if not socket_exists(socket_path) then
    init_term()
  end

  -- Check if a window with the desired title already exists
  local window_id = get_kitty_window_id(socket_path, title)

  if not window_id then
    -- Launch a new tab if it doesn't exist
    vim.fn.system(string.format(
      "kitty @ --to unix:%s launch --type tab --cwd %s --title %s sh -c 'exec zsh;'",
      socket_path, dir, title
    ))
    print("Create a new Kitty tab with title:", title)

    -- Add a delay to ensure the new tab is initialized
    local timer = io.popen("sleep " .. 1)
    timer:close()

    -- Recheck to get the new window ID after launching
    window_id = get_kitty_window_id(socket_path, title)
    if not window_id then
      print("Failed to create a new Kitty tab with title:", title)
      return
    end
  end

  -- Send the command to the tab
  vim.fn.system(string.format(
    "kitty @ --to unix:%s send-text --match id:%s '%s\n'",
    socket_path, window_id, command
  ))
end

-- Function: ScratchTermCreate
local function ScratchTermCreate()
  local cwd = vim.fn.getcwd()
  local project_name = get_project_name()
  local cwd_name = vim.fn.fnamemodify(cwd, ":t")
  local function ternary(cond, T, F)
    if cond then return T else return F end
  end
  local title = ternary(project_name == cwd_name, "root", cwd_name)
  send_to_kitty("lta", title, cwd)
end
-- Function: ScratchTermBranch
local function ScratchTermBranch()
  send_to_kitty("serie", "serie", vim.fn.getcwd())
end
-- Function: ScratchTermLazyGit
local function ScratchTermLazyGit()
  send_to_kitty("lazygit", "lazygit", vim.fn.getcwd())
end

-- Create Neovim Commands
vim.api.nvim_create_user_command(
  "ScratchTermCreate", ScratchTermCreate,
  { desc = "Create a scratch terminal" }
)
vim.api.nvim_create_user_command(
  "ScratchTermBranch", ScratchTermBranch,
  { desc = "Show Git branches in scratch terminal" }
)
vim.api.nvim_create_user_command(
  "ScratchTermLazyGit", ScratchTermLazyGit,
  { desc = "Launch LazyGit in scratch terminal" }
)

-- vim.opt.foldmethod = "indent"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

local M = {}
-- function to create a list of commands and convert them to autocommands
-------- This function is taken from https://github.com/norcalli/nvim_utils
function M.nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup ' .. group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten { 'autocmd', def }, ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

local autoCommands = {
  open_folds = {
    { "BufReadPost,FileReadPost,VimEnter", "*", "normal zR" }
  }
}
M.nvim_create_augroups(autoCommands)

-- Notification on macro start
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    local register = vim.fn.reg_recording()
    if register ~= "" then
      local icon = " "
      local message = " Macro started on register: " .. register
      vim.notify(message, vim.log.levels.INFO, { icon = icon, title = "Macro Started" })
    end
  end,
  desc = "Notify macro start",
})

-- Notification on macro end
vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    local register = vim.fn.reg_recording()
    if register ~= "" then
      local icon = " "
      local message = " Macro ended on register: " .. register
      vim.notify(message, vim.log.levels.INFO, { icon = icon, title = "Macro Ended" })
    end
  end,
  desc = "Notify macro end",
})


vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "txt", "env" },
  callback = function(opts)
    -- local cmp = require("cmp")
    -- cmp.setup.buffer({ enabled = false })
    -- have to "re-enable" spellchecking for these files
    vim.opt.spell = true
    vim.opt.spelllang = "en_us"
  end,
})
-- vim.opt.spell = true
-- vim.opt.spelllang = "en_us"

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.spell = false
  end,
})
