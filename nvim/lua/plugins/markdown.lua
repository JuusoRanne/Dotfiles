return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },
    {
        'iamcco/markdown-preview.nvim',
        build = 'cd app && npm install',
        ft = { 'markdown' },
        cmd = { 'MarkdownPreview', 'MarkdownPreviewStop' },
        init = function()
            vim.g.mkdp_browser = 'safari'
            vim.g.mkdp_markdown_css = vim.fn.expand('~/.config/nvim/markdown-preview.css')
        end,
        keys = {
            { '<leader>mp', '<cmd>MarkdownPreview<CR>', desc = 'Markdown preview open' },
        },
    },
}
