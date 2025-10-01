-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()
local nvlsp = require("nvchad.configs.lspconfig")
local lspconfig = require("lspconfig")
local map = vim.keymap.set
-- local nomap = vim.keymap.del
local custom_on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end
  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "gs", vim.lsp.buf.hover, opts "Show Info")
  map("n", "gh", vim.lsp.buf.signature_help, opts "Show signature help")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wd", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")
  map("n", "gt", vim.lsp.buf.type_definition, opts "Go to type definition")
  map("n", "<leader>ra", require "nvchad.lsp.renamer", opts "NvRenamer")
  -- map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "<leader>ca", function()
    require("tiny-code-action").code_action()
  end, opts "Code action")
  map("i", "<A-Return>", function()
    require("tiny-code-action").code_action()
  end, opts "Code action")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
end

-- list of all servers configured.
lspconfig.servers = {
  "nil_ls",  -- nil_ls (rust) or nixd (c++)
  "lua_ls",
  "bashls",
  "pyright",
  -- "gopls",
  -- "nginx_language_server", -- needs python 3.12 or below
  "lemminx",
  -- WebDev
  "svelte",
  "eslint",
  "ts_ls",
  -- DevOps
  "yamlls",
  "helm_ls",
  "gitlab_ci_ls",
  "docker_compose_language_service",
  "dockerls",
  "terraformls",
}


lspconfig.nil_ls.setup({
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

lspconfig.lua_ls.setup({
  on_attach = custom_on_attach,
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

lspconfig.gopls.setup({
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  -- cmd_env = { PATH = "$HOME/.gvm/gos/go1.23.4/bin" }
  -- no reason garbage
  --   on_attach = function(client, bufnr)
  --     client.server_capabilities.documentFormattingProvider = false
  --     client.server_capabilities.documentRangeFormattingProvider = false
  --     custom_on_attach(client, bufnr)
  --   end,
  --   on_init = nvlsp.on_init,
  --   capabilities = nvlsp.capabilities,
  --   cmd = { "gopls" },
  --   filetypes = { "go", "gomod", "gotmpl", "gowork" },
  --   root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
  --   settings = {
  --     gopls = {
  --       analyses = {
  --         unusedparams = true,
  --       },
  --       completeUnimported = true,
  --       usePlaceholders = true,
  --       staticcheck = true,
  --     },
  --   },
})

-- Handeled from vim-helm plugin
lspconfig.helm_ls.setup({
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  -- settings = {
  --   ['helm-ls'] = {
  --     yamlls = {
  --       path = "yaml-language-server",
  --     }
  --   }
  -- }
  -- filetypes = { "yaml.helm" },
  -- cmd = { "helm_ls", "serve" },
  -- root_dir = function(fname)
  --   return require('lspconfig.util').root_pattern("Chart.yaml")(fname)
  -- end,
})

lspconfig.terraformls.setup({
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

lspconfig.yamlls.setup {
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  -- cmd = with_nvm("20", "yaml-language-server --stdio"),
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml" },
  settings = {
    yaml = {
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        -- use this if you want to match all '*.yaml' files
        [require('kubernetes').yamlls_schema()] = { "*manifest.yaml", "*/manifests/*.yaml" },
        -- ArgoCD ApplicationSet CRD
        -- ["https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/crds/applicationset-crd.yaml"] = "*/argo/*.yaml",
        -- ArgoCD Application CRD
        ["https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/crds/application-crd.yaml"] = "*/argo/*.yaml",
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

lspconfig.bashls.setup({
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "bash-language-server", "start" }
})

lspconfig.docker_compose_language_service.setup({
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  -- cmd = with_nvm("20", "docker-compose-langserver --stdio"),
  cmd = { "docker-compose-langserver", "--stdio" },
  filetypes = { "yaml.docker-compose" },
})

lspconfig.dockerls.setup({
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  -- cmd = with_nvm("20", "docker-langserver --stdio"),
  cmd = { "docker-langserver", "--stdio" },
})

lspconfig.pyright.setup({
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "pyright-langserver", "--stdio" }
  -- settings = {
  --   python = {
  --     analysis = {
  --       typeCheckingMode = "off",
  --     },
  --   },
  -- },
})

-- list of servers configured with default config.
local default_servers = {
  -- "html",
  -- "cssls",
  -- "nginx_language_server", -- needs python 3.12 or below
  "lemminx",
  "svelte",
  -- "eslint",
  "ts_ls",
}

-- lsps with default config
for _, lsp in ipairs(default_servers) do
  lspconfig[lsp].setup({
    on_attach = custom_on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    -- cmd_env = {
    --   PATH = "/home/mshnwq/.nvm/versions/node/v20.18.1/bin",
    --   NVM_BIN = "/home/mshnwq/.nvm/versions/node/v20.18.1/bin",
    --   NVM_INC = "/home/mshnwq/.nvm/versions/node/v20.18.1/include/node",
    --   NVM_DIR = "/home/mshnwq/.nvm",
    -- },
  })
end

lspconfig.gitlab_ci_ls.setup({
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "gitlab-ci-ls" },
  filetypes = { "yaml.gitlab" },
})
