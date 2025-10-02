require "nvchad.mappings"

-- <tab>
-- <S-tab>
-- <A-tab>

local map = vim.keymap.set
local nomap = vim.keymap.del

vim.api.nvim_set_keymap("n", "S", "A", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "A", "I", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "s", "a", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "a", "i", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "E", "W", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "e", "w", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "W", "B", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "w", "b", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "E", "W", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "e", "w", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "W", "B", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "w", "b", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "J", "L", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "J", "L", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "K", "H", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "K", "H", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "L", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "L", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "H", "^", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "H", "^", { noremap = true, silent = true })


map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "<A-k>", "<cmd>t-1<CR>")
map("n", "<A-j>", "<cmd>t.<CR>")

map({ "n", "i" }, "<C-x>", "<cmd>d<CR>")

nomap("n", "<leader>n")
nomap("n", "<leader>rn")
map("n", "<leader>nn", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>nr", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

map("n", "<leader>mp", function()
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
end, { desc = "Format file or range" })
map("v", "<leader>mp", "<cmd>FormatYaml<CR>", { desc = "Format yaml range" })

map("n", "<leader>tt", function()
  require("base46").toggle_transparency()
end, { desc = "Toggle transparency" })

map("n", "<leader>do", "<cmd> lua vim.diagnostic.open_float() <cr>", { desc = "Show diagnostic" })

nomap("n", "<leader>ma")
nomap("n", "<leader>fm")
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
nomap("n", "<leader>cm")
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })

-- Tabs
map("n", "<leader><A-.>", "<cmd> tabnext <cr>", { desc = "Next Tab" })
map("n", "<leader><A-,>", "<cmd> tabprev <cr>", { desc = "Prev Tab" })
map("n", "<leader><A-c>", "<cmd> tabnew <cr>", { desc = "New Tab" })
map("n", "<leader><A-C>", "<cmd> tabedit % <cr>", { desc = "New Tab on file" })
map("n", "<leader><A-q>", "<cmd> tabclose <cr>", { desc = "Close Tab" })

-- Windows
map("n", "<leader><A-->", "<cmd> sp <cr>", { desc = "Split window horizontally" })
map("n", "<leader><A-\\>", "<cmd> vsp <cr>", { desc = "Split window vertically" })
map("n", "<leader><A-w>", "<C-w>q", { desc = "Close Window" })
map("n", "<leader>X", "<cmd> %bd|e# <cr>", { desc = "buffer close all" })

-- Navigate windows
vim.keymap.set({ "n", "t" }, "<A-Left>", function()
  if vim.fn.mode() == "t" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>h", true, false, true), "n", true)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>h", true, false, true), "n", true)
  end
end, { desc = "Switch window left" })
vim.keymap.set({ "n", "t" }, "<A-Right>", function()
  if vim.fn.mode() == "t" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>l", true, false, true), "n", true)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>l", true, false, true), "n", true)
  end
end, { desc = "Switch window right" })
vim.keymap.set({ "n", "t" }, "<A-Down>", function()
  if vim.fn.mode() == "t" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>j", true, false, true), "n", true)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>j", true, false, true), "n", true)
  end
end, { desc = "Switch window down" })
vim.keymap.set({ "n", "t" }, "<A-Up>", function()
  if vim.fn.mode() == "t" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>k", true, false, true), "n", true)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>k", true, false, true), "n", true)
  end
end, { desc = "Switch window up" })
 
-- NvimTree
nomap("n", "<C-n>")
map("n", "<C-e>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })

-- Notifications
map("n", "<leader>cn", "<cmd>lua require('notify').dismiss()<CR>", { desc = "Dismiss notifications" })
 
-- Terminal mappings
nomap("n", "<leader>h")
nomap("n", "<leader>v")
nomap({ "n", "t" }, "<A-v>")
nomap({ "n", "t" }, "<A-h>")
nomap({ "n", "t" }, "<A-i>")
nomap("n", "<leader>pt")
 
-- map("n", "<A-=>", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map({ "n", "t" }, "<A-\\>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm", size = 0.325 }
end, { desc = "vterm" })
map({ "n", "t" }, "<A-->", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm", size = 0.275 }
end, { desc = "hterm" })
map({ "n", "t" }, "<A-f>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "floating term" })
map({ "n", "t" }, "<A-|>", function()
  require("nvchad.term").toggle {
    pos = "float", id = "vfloatTerm",
    float_opts = {
      row = 0.05,
      col = 0.8,
      width = 0.3,
      height = 0.9
    }
  }
end, { desc = "floating vterm" })
map({ "n", "t" }, "<A-_>", function()
  require("nvchad.term").toggle {
    pos = "float", id = "hfloatTerm",
    float_opts = {
      row = 0.9,
      col = 0.15,
      width = 0.9,
      height = 0.3
    }
  }
end, { desc = "floating hterm" })

-- NeoGit
map("n", "<leader>gn", "<cmd>Neogit<CR>", { desc = "Open NeoGit" })
-- Worktree
require("telescope").load_extension("worktrees")
map("n", "<leader>gws", "<cmd>lua require('telescope').extensions.worktrees.list_worktrees(opts)<CR>",
  { desc = "Manage Worktree" })
map("n", "<leader>gwb", "<cmd>GitWorktreeCreateExisting<CR>", { desc = "Create Existing Worktree" })
map("n", "<leader>gwc", "<cmd>GitWorktreeCreate<CR>", { desc = "Create New Worktree" })
 
-- ScratchPad Term
map("n", "<leader>tc", "<cmd>ScratchTermCreate<CR>", { desc = "Create ScratchTerm" })
map("n", "<leader>gb", "<cmd>ScratchTermBranch<CR>", { desc = "Serie Branch ScratchTerm" })
map("n", "<leader>gl", "<cmd>ScratchTermLazyGit<CR>", { desc = "LazyGit ScratchTerm" })

-- -- Copilot
-- map("n", "<leader>cs", "<cmd>Copilot<CR>", { desc = "Copilot Status" })
-- map("n", "<leader>cd", "<cmd>Copilot disable<CR>", { desc = "Disable Copilot" })
-- map("n", "<leader>ce", "<cmd>Copilot enable<CR>", { desc = "Enable Copilot" })

-- Todo
map("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
map("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })
map("n", "<leader>tdt", "<cmd>TodoTelescope<CR>", { desc = "Telescope TODO" })
map("n", "<leader>tdl", "<cmd>TodoLocList<CR>", { desc = "Local TODO" })
map("n", "<leader>tdg", "<cmd>TodoQuickFix<CR>", { desc = "Global TODO" })

map("n", "<leader>mv", "<cmd>Markview toggle<CR>", { desc = "Toggle Markview" })
