-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()
local nvlsp = require("nvchad.configs.lspconfig")

local lspconfig = require("lspconfig")

-- list of all servers configured.
lspconfig.servers = {
  "lua_ls",
  "bashls",
  "pyright",
  "terraformls",
  "yamlls",
  "gopls",
  "gitlab_ci_ls",
  -- "nginx_language_server", -- needs python 3.12 or below
  "lemminx",
  "helm_ls",
  "dockerls",
  "docker_compose_language_service",
  -------
  "svelte",
  "eslint",
  "ts_ls",
}

lspconfig.lua_ls.setup({
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        enable = false, -- Disable all diagnostics from lua_ls
        -- globals = { "vim" },
      },
      workspace = {
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
          vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/love2d/library",
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
})

-- lspconfig.pyright.setup({
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
--   -- settings = {
--   --   python = {
--   --     analysis = {
--   --       typeCheckingMode = "off",         -- Disable type checking diagnostics
--   --     },
--   --   },
--   -- },
-- })

-- lspconfig.terraformls.setup({
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- })

lspconfig.yamlls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  -- #TODO: 
  --filetypes = { 'yaml' },
  settings = {
    yaml = {
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        -- use this if you want to match all '*.yaml' files
        [require('kubernetes').yamlls_schema()] = "*manifest.yaml",
        -- or this to only match '*.<resource>.yaml' files. ex: 'app.deployment.yaml', 'app.argocd.yaml', ...
        -- [require('kubernetes').yamlls_schema()] = require('kubernetes').yamlls_filetypes()
        -- ArgoCD ApplicationSet CRD
        -- ["https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/crds/applicationset-crd.yaml"] =
        -- "/home/h4ckm1n/Documents/K8s/apps/templates/*.yaml",
        -- -- ArgoCD Application CRD
        -- ["https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/crds/application-crd.yaml"] =
        -- "/home/h4ckm1n/Documents/K8s/apps/templates/*.yaml",
        -- -- Kubernetes strict schemas
        -- ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.3-standalone-strict/all.json"] = "",
      },
      validate = true,
      completion = true,
      hover = true,
      format = {
        enable = true,
        bracketSpacing = true,
        printWidth = 80,
        proseWrap = "preserve",
        singleQuote = true,
      },
      customTags = {
        "!Ref",
        "!Sub sequence",
        "!Sub mapping",
        "!GetAtt",
      },
      disableAdditionalProperties = false,
      maxItemsComputed = 5000,
      trace = {
        server = "verbose",
      },
    },
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
  },
}

-- lspconfig.gopls.setup({
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
--   -- no reason garbage
--   --   on_attach = function(client, bufnr)
--   --     client.server_capabilities.documentFormattingProvider = false
--   --     client.server_capabilities.documentRangeFormattingProvider = false
--   --     nvlsp.on_attach(client, bufnr)
--   --   end,
--   --   on_init = nvlsp.on_init,
--   --   capabilities = nvlsp.capabilities,
--   --   cmd = { "gopls" },
--   --   filetypes = { "go", "gomod", "gotmpl", "gowork" },
--   --   root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
--   --   settings = {
--   --     gopls = {
--   --       analyses = {
--   --         unusedparams = true,
--   --       },
--   --       completeUnimported = true,
--   --       usePlaceholders = true,
--   --       staticcheck = true,
--   --     },
--   --   },
-- })

lspconfig.gitlab_ci_ls.setup({
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "gitlab-ci-ls" },
  filetypes = { "yaml.gitlab", "gitlab-ci.yml" },  -- Ensure it only applies to .gitlab-ci.yml
  root_dir = lspconfig.util.root_pattern(".gitlab*", ".git"),
})

lspconfig.docker_compose_language_service.setup({
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "docker-compose-langserver", "--stdio" },
  filetypes = { "yaml.docker-compose" },
})


-- list of servers configured with default config.
local default_servers = {
  -- "html",
  -- "cssls",
  "pyright",
  "terraformls",
  "gopls",
  "bashls",
  -- "nginx_language_server", -- needs python 3.12 or below
  "lemminx",
  "helm_ls",
  "dockerls",
  ----------
  "svelte",
  -- "eslint",
  "ts_ls",
}

-- lsps with default config
for _, lsp in ipairs(default_servers) do
  lspconfig[lsp].setup({
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
end
