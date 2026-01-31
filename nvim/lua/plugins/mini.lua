return {
  "echasnovski/mini.nvim",
  config = function()
    require('mini.surround').setup({
      -- Use vim-surround style mappings (ys, ds, cs)
      mappings = {
        add = 'ys',
        delete = 'ds',
        replace = 'cs',
        find = '',
        find_left = '',
        highlight = '',
        update_n_lines = '',
      },
    })
  end,
}
