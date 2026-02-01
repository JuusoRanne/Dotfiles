return {

  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "hrsh7th/cmp-omni",
    ft = "tex",
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        check_ts = true,
        -- Disable for tex since we'll handle it via snippets
        disable_filetype = {},
      })

      -- Integration with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets'
    },
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      require("luasnip.loaders.from_vscode").lazy_load()

      -- Explicit LaTeX snippets
      ls.add_snippets("tex", {
        s("cite", { t("\\cite{"), i(1), t("}") }),
        s("ref", { t("\\ref{"), i(1), t("}") }),
        s("eqref", { t("\\eqref{"), i(1), t("}") }),
        s("label", { t("\\label{"), i(1), t("}") }),
        s("textbf", { t("\\textbf{"), i(1), t("}") }),
        s("textit", { t("\\textit{"), i(1), t("}") }),
        s("emph", { t("\\emph{"), i(1), t("}") }),
        s("frac", { t("\\frac{"), i(1), t("}{"), i(2), t("}") }),
        s("sec", { t("\\section{"), i(1), t("}") }),
        s("sub", { t("\\subsection{"), i(1), t("}") }),
      })
    end,
  },
  {
    "rafamadriz/friendly-snippets"
  },

  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require 'cmp'

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<Tab>'] = cmp.mapping(function(fallback)
            local luasnip = require('luasnip')
            if cmp.visible() then
              cmp.confirm({ select = true })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            local luasnip = require('luasnip')
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })

      -- LaTeX-specific completion
      cmp.setup.filetype('tex', {
        sources = cmp.config.sources({
          { name = 'luasnip', priority = 1000 },
          { name = 'omni', priority = 800 },
          { name = 'buffer', priority = 500 },
        })
      })
    end,
  }
}
