local lint = require("lint")

lint.linters_by_ft = {
  lua = { "luacheck" },
  python = { "flake8" },
  shell = { "shellcheck" },
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  terraform = { "tflint" },
  dockerfile = { "hadolint" },
  yaml = { "kubelint" },
  ["yaml.docker-compose"] = { "dclint" },
  helm = { "helmlint" },
}

require("lint").linters.flake8 = {
  cmd = vim.env.HOME .. "/.local/venv/nvim/bin/flake8", -- Ensure the correct venv path
  stdin = true,
  args = {
    '--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s [https://www.flake8rules.com/rules/%(code)s.html]',
    '--no-show-source',
    '--stdin-display-name',
    function() return vim.api.nvim_buf_get_name(0) end,
    '-',
  },
  ignore_exitcode = true,
  parser = require("lint.parser").from_pattern(
    '[^:]+:(%d+):(%d+):(%w+):(.+)',
    { "lnum", "col", "severity", "message" },
    {
      -- https://www.flake8rules.com/rules/XXXX.html
      ['E501'] = vim.diagnostic.severity.WARN,
      ['E303'] = vim.diagnostic.severity.ERROR,
    },
    {
      ['source'] = "flake8",
      ['severity'] = vim.diagnostic.severity.INFO, -- Default severity for unknown codes
    }
  ),
}

lint.linters.dclint = {
  env = {
    ["PATH"] = vim.env.HOME .. '/.asdf/installs/nodejs/20.18.1/bin',
  },
  cmd = vim.env.HOME .. '/.asdf/installs/nodejs/20.18.1/bin/dclint',
  stdin = false,          -- dclint does not take input via stdin
  append_fname = true,    -- Automatically append the filename to args
  args = {},              -- No additional arguments required
  stream = "stdout",      -- dclint outputs to stdout
  ignore_exitcode = true, -- dclint might return non-zero exit codes for warnings/errors
  parser = require("lint.parser").from_pattern(
    [[^%s*(%d+):(%d+)%s+(%w+)%s+(.+)%s+%S+$]],
    { "lnum", "col", "severity", "message" },
    {
      error = vim.diagnostic.severity.ERROR,
      warning = vim.diagnostic.severity.WARN,
    },
    { source = "dclint" }
  ),
}

-- Function to find the Helm chart root directory
local function find_helm_chart_root(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)              -- Get the current buffer's file name
  local dir = vim.fn.fnamemodify(fname, ":h")                 -- Get the directory of the current file
  local root = vim.fn.finddir('Chart.yaml', dir .. ';')       -- Find the nearest Chart.yaml in parent directories
  return root ~= '' and vim.fn.fnamemodify(root, ":h") or nil -- Return the directory if found, nil otherwise
end
-- Define the parser for `helm lint`
local helm_parser = require('lint.parser').from_pattern(
  '^%[([A-Z]+)%]%s+(.-):%s+(.+)$',
  { 'severity', 'file', 'message' },
  {
    information = vim.diagnostic.severity.INFO,
    error = vim.diagnostic.severity.ERROR,
    warning = vim.diagnostic.severity.WARN,
  }
)
lint.linters.helmlint = {
  cmd = '/usr/bin/helm',
  stdin = false,                                 -- dclint does not take input via stdin
  append_fname = true,                           -- Automatically append the filename to args
  args_fn = function()
    local bufnr = vim.api.nvim_get_current_buf() -- Get the current buffer number
    local root = find_helm_chart_root(bufnr)     -- Find the Helm chart root directory
    if root then
      return { 'lint', root }                    -- Use the Helm chart root directory as the argument
    else
      return {}                                  -- Return an empty argument list if no Chart.yaml is found
    end
  end,
  stream = "stdout",      -- dclint outputs to stdout
  ignore_exitcode = true, -- dclint might return non-zero exit codes for warnings/errors
  parser = helm_parser,
}

lint.linters.kubelint = {
  -- cmd = vim.env.HOME .. '/.gvm/pkgsets/go1.23.4/global/bin/kube-linter',
  cmd = 'kube-linter',
  stdin = false,       -- or false if it doesn't support content input via stdin. In that case the filename is automatically added to the arguments.
  append_fname = true, -- Automatically append the file name to `args` if `stdin = false` (default: true)
  args = {
    "lint",
    "--add-all-built-in",
    -- "--output", "json",
  },                      -- list of arguments. Can contain functions with zero arguments that will be evaluated once the linter is used.
  stream = 'stdout',      -- ('stdout' | 'stderr' | 'both') configure the stream to which the linter outputs the linting result.
  ignore_exitcode = true, -- set this to true if the linter exits with a code != 0 and that's considered normal.
  parser = require('lint.parser').from_pattern(
    '([^:]+): %((.-)%) (.+) %(check: ([^,]+), remediation: (.+)%)',
    { "file", "code", "message", "check", "remediation" },
    {
      source = "kube-linter",
    }
  )
}

lint.linters.luacheck.args = {
  "--globals",
  "love",
  "vim",
}

vim.api.nvim_create_autocmd({
  "BufEnter",
  "BufWritePost",
  "InsertLeave",
}, {
  callback = function()
    lint.try_lint()
  end,
})
