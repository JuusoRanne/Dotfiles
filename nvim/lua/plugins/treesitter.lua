return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "terraform", "go", "gotmpl", "html", "css", "javascript", "yaml"},
        auto_install = true,
        highlight = {
          enable = true,
          disable = { "latex" },
        },
        indent = { enable = true },
      })

      -- nvim-treesitter is archived. In Neovim 0.12, add_directive() dropped the
      -- `all` option — handlers always receive TSNode[] (arrays). nvim-treesitter
      -- registered set-lang-from-info-string! expecting a single TSNode, so it
      -- crashes calling :range() on the array. Require query_predicates first to
      -- ensure it has registered its version, then override it synchronously.
      require("nvim-treesitter.query_predicates")
      vim.treesitter.query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
        local capture_id = pred[2]
        local raw = match[capture_id]
        if not raw then return end
        local node = type(raw) == "table" and raw[1] or raw
        if not node then return end
        local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
        if not ok or not text then return end
        local lang = text:lower():match("^(%S+)") or ""
        local resolved = vim.filetype.match({ filename = "a." .. lang })
        local aliases = { ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript" }
        metadata["injection.language"] = resolved or aliases[lang] or lang
      end, { force = true })
    end
  }
}


-- Treesitter is used for syntax support
