local lint = require("lint")

lint.linters.kube_linter = {
  cmd = '/home/mshnwq/.gvm/pkgsets/go1.23.4/global/bin/kube-linter',
  stdin = false,          -- or false if it doesn't support content input via stdin. In that case the filename is automatically added to the arguments.
  append_fname = true,    -- Automatically append the file name to `args` if `stdin = false` (default: true)
  args = { "lint" },      -- list of arguments. Can contain functions with zero arguments that will be evaluated once the linter is used.
  stream = 'stdout',        -- ('stdout' | 'stderr' | 'both') configure the stream to which the linter outputs the linting result.
  ignore_exitcode = true, -- set this to true if the linter exits with a code != 0 and that's considered normal.
  parser = require('lint.parser').from_pattern(
    [[^(.-): %((.-)%) (.+) %((check: (.-), remediation: (.+))%)$]],
    { "file", "code", "message", "remediation" },
    {
      source = "kube-linter",
    }
  )
}

lint.linters_by_ft = {
  lua = { "luacheck" },
  python = { "flake8" },
  terraform = { "tflint" },
  yaml = { "kube_linter" },
  shell = { "shellcheck" },
  javascript = {"eslint_d"},
  typescript = {"eslint_d"},
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
