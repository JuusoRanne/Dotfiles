-- basic settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set relativenumber")
vim.cmd("set clipboard=unnamedplus")
vim.g.mapleader = "å"
vim.api.nvim_set_keymap('i', '<C-l>', '<Esc>la', { noremap = true, silent = true })



-- Copilot mapping
vim.api.nvim_set_keymap('i', '<Leader><Tab>', 'copilot#Accept("<CR>")', {expr = true, silent = true})
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "Clear search highlight on Esc" })


vim.keymap.set("n", "<leader>gp", function()
  vim.cmd("silent !prettier --write " .. vim.fn.expand("%"))
  vim.cmd("edit!") -- reload the file after formatting
end, { desc = "Format file with Prettier" })

-- Keybinds for Copilot chat
vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChatOpen<CR>", { desc = "Open Copilot chat" })
-- Copilot chat prompts:CopilotChatPrompts
vim.keymap.set("n", "<leader>cp", "<cmd>Copilot chat prompts<CR>", { desc = "Open Copilot chat prompts" })


-- Set additional filetypes
vim.filetype.add({
  extension = {
    tfvars = "text"  -- tfvars is not supported by terraformls, this is workaround
  }
})
