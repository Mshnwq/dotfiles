require("mason-conform").setup({
  ignore_install = { 'isort' },
  ensure_installed = {
    "prettier",
    "stylua",
    "nixfmt",
    "shfmt",
    "ruff",
    "ruff_format",
  },
})
