return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",     -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
    event_handlers = {
      {
        event = "file_opened",
        handler = function ()
          require("neo-tree").close_all()
        end
        }
      }
    })
    vim.keymap.set('n', '<space>n', ':Neotree filesystem reveal left<CR>', {})
    vim.keymap.set('n', '<Space>n', ':Neotree filesystem reveal left<CR>', {})
  end,
}
