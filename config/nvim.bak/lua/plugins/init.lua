return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("configs.treesitter")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { 'diogo464/kubernetes.nvim' },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require("configs.lspconfig")
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lspconfig" },
    config = function()
      require("configs.lspconfig-mason")
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("configs.lint")
    end,
  },
  {
    "rshkarin/mason-nvim-lint",
    event = "VeryLazy",
    dependencies = { "nvim-lint" },
    config = function()
      require("configs.lint-mason")
    end,
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("configs.conform")
    end,
  },
  {
    "zapling/mason-conform.nvim",
    event = "VeryLazy",
    dependencies = { "conform.nvim" },
    config = function()
      require("configs.conform-mason")
    end,
  },


  -- My Plugins --
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- config = function()
    --   require("todo-comments").setup()
    -- end,
    opts = {
      signs = true,      -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        HACK = { icon = " ", color = "hint" },
        PERF = { icon = " ", color = "hint", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "󰂓 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      colors = {
        error = { "TodoError" },
        warning = { "TodoWarn" },
        info = { "TodoInfo" },
        hint = { "TodoHint" },
        test = { "TodoTest" },
        default = { "TodoDefault" },
      },
    },
  },
  -- {
  --   "OXY2DEV/markview.nvim",
  --   lazy = false,
  --   config = function()
  --     require("markview").setup({
  --       preview = {
  --         enable = false,
  --       },
  --       markdown = {
  --         headings = require("markview.presets").headings.glow
  --       }
  --     });
  --     require("markview.extras.checkboxes").setup();
  --   end,
  -- },
  {
    'towolf/vim-helm',
    ft = 'helm'
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
    opts = {
      lang = {
        terraform = { "# %s" },
        yuck = { "; %s" },
        ron = { "// %s" },
      },
    },
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    event = "LspAttach",
    config = function()
      require('tiny-code-action').setup()
    end
  },

  -- https://github.com/b0o/nvim-tree-preview.lua

  {
    require("configs.nvimtree")
  },

  {
    require("configs.neominimap")
  },

  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
      })
    end
  },
  {
    "folke/noice.nvim",
    enabled = true,
    lazy = false, -- NOTE: NO NEED to Lazy load
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      return require("configs.noice")
    end,
  },

  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
      require('neogit').setup()
    end,
  },
  {
    "Juksuu/worktrees.nvim",
    event = "VeryLazy",
    config = function()
      require("worktrees").setup()
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    opts = function()
      return require("configs.cmp")
    end,
  },
  --{
  --  "zbirenbaum/copilot.lua",
  --  cmd = "Copilot",
  --  event = "InsertEnter",
  --  config = function()
  --    return require("configs.copilot")
  --  end,
  --},
  --{
  --  "zbirenbaum/copilot-cmp",
  --  event = "InsertEnter",
  --  config = function()
  --    require("copilot_cmp").setup()
  --  end,
  --  dependencies = {
  --    "zbirenbaum/copilot.lua",
  --    -- cmd = "Copilot",
  --    -- config = function()
  --    --   require("copilot").setup({
  --    --     suggestion = { enabled = false },
  --    --     panel = { enabled = false },
  --    --   })
  --    -- end,
  --  },
  --},

  -- {
  --   "jackMort/ChatGPT.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("chatgpt").setup()
  --     require("chatgpt").setup({
  --       api_key_cmd = 'pass show mshnwq/chatgpt-api',
  --     })
  --   end,
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "folke/trouble.nvim", -- optional
  --     "nvim-telescope/telescope.nvim"
  --   }
  -- },

}
