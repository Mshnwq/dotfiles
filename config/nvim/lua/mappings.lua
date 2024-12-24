require("nvchad.mappings")

-- <tab>
-- <S-tab>
-- <A-tab>

local map = vim.keymap.set
-- Disable mappings
local nomap = vim.keymap.del

vim.api.nvim_set_keymap("n", "S", "A", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "A", "I", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "a", "i", { noremap = true, silent = true })

map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "<C-w>.", "<cmd> tabnext <cr>", { desc = "Next Tab" })
map("n", "<C-w>,", "<cmd> tabprev <cr>", { desc = "Prev Tab" })
--nomap("n", "<C-w>c", true)
-- vim.keymap.del("n", "<C-w>c")
map("n", "<C-w>C", "<cmd> tabedit <cr>", { desc = "New Tab", noremap = true })

map("n", "<leader>mp", function()
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
end, { desc = "Format file or range (in visual mode)" })

map("n", "<leader>tt", function()
  require("base46").toggle_transparency()
end, { desc = "Toggle transparency" })

map("n", "<leader>do", "<cmd> lua vim.diagnostic.open_float() <cr>", { desc = "Show diagnostic" })

-- nomap("n", "<C-w>s")
-- nomap("n", "<C-w>v")
map("n", "<C-w>c", "<cmd> sp <cr>", { desc = "Split window horizontally" })
map("n", "<C-w>-", "<cmd> sp <cr>", { desc = "Split window horizontally" })
map("n", "<C-w>\\", "<cmd> vsp <cr>", { desc = "Split window vertically" })

-- nomap("n", "<C-e>")
map("n", "<C-e>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })

-- NeoGit
map("n", "<leader>gs", "<cmd>Neogit<CR>", { desc = "Open NeoGit" })


-- Terraform
-- map("n", "<leader>ti", ":!terraform init<CR>", { desc = "Terraform Init" })
-- map("n", "<leader>tv", ":!terraform validate<CR>", { desc = "Terraform Validate" })
-- map("n", "<leader>tf", ":!terraform fmt<CR>", { desc = "Terraform Format" })
-- map("n", "<leader>tp", ":!terraform plan<CR>", { desc = "Terraform Plan" })
-- map("n", "<leader>taa", ":!terraform apply -auto-approve<CR>", { desc = "Terraform Apply" })

-- K
local kube_utils_mappings = {
  { "<leader>k",   group = "Kubernetes" }, -- Main title for all Kubernetes related commands
  -- Helm Commands
  { "<leader>kh",  group = "Helm" },
  { "<leader>khT", "<cmd>HelmDryRun<CR>",                     desc = "Helm DryRun Buffer" },
  { "<leader>khb", "<cmd>HelmDependencyBuildFromBuffer<CR>",  desc = "Helm Dependency Build" },
  { "<leader>khd", "<cmd>HelmDeployFromBuffer<CR>",           desc = "Helm Deploy Buffer to Context" },
  { "<leader>khr", "<cmd>RemoveDeployment<CR>",               desc = "Helm Remove Deployment From Buffer" },
  { "<leader>kht", "<cmd>HelmTemplateFromBuffer<CR>",         desc = "Helm Template From Buffer" },
  { "<leader>khu", "<cmd>HelmDependencyUpdateFromBuffer<CR>", desc = "Helm Dependency Update" },
  -- Kubectl Commands
  { "<leader>kk",  group = "Kubectl" },
  { "<leader>kkC", "<cmd>SelectSplitCRD<CR>",                 desc = "Download CRD Split" },
  { "<leader>kkD", "<cmd>DeleteNamespace<CR>",                desc = "Kubectl Delete Namespace" },
  { "<leader>kkK", "<cmd>OpenK9s<CR>",                        desc = "Open K9s" },
  { "<leader>kka", "<cmd>KubectlApplyFromBuffer<CR>",         desc = "Kubectl Apply From Buffer" },
  { "<leader>kkc", "<cmd>SelectCRD<CR>",                      desc = "Download CRD" },
  { "<leader>kkk", "<cmd>OpenK9sSplit<CR>",                   desc = "Split View K9s" },
  { "<leader>kkl", "<cmd>ToggleYamlHelm<CR>",                 desc = "Toggle YAML/Helm" },
  -- Logs Commands
  { "<leader>kl",  group = "Logs" },
  { "<leader>klf", "<cmd>JsonFormatLogs<CR>",                 desc = "Format JSON" },
  { "<leader>klv", "<cmd>ViewPodLogs<CR>",                    desc = "View Pod Logs" },
}

-- Register the Kube Utils keybindings
require('which-key').add(kube_utils_mappings)
