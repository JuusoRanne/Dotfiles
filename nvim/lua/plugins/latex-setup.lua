return {
  {
    "lervag/vimtex",
    lazy = false,
    ft = "tex",
    config = function()
      -- Use zathura as PDF viewer with synctex support
      vim.g.vimtex_view_method = "zathura"

      -- Compiler settings
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        bibtex_backend = "biber",
        options = {
          "-pdf",
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }

      -- Quickfix settings
      vim.g.vimtex_quickfix_mode = 0

      -- Enable conceal for prettier display (e.g., \alpha -> α)
      vim.g.vimtex_syntax_conceal = {
        accents = 1,
        cites = 1,
        fancy = 1,
        greek = 1,
        math_bounds = 1,
        math_delimiters = 1,
        math_fracs = 1,
        math_super_sub = 1,
        math_symbols = 1,
        sections = 0,
        styles = 1,
      }

      -- Set local leader key
      vim.g.maplocalleader = ","

      -- <leader>c to compile
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function()
          vim.keymap.set("n", "<leader>c", "<cmd>VimtexCompile<CR>", {
            buffer = true,
            desc = "Compile LaTeX document",
          })
        end,
      })

      -- Basic LaTeX template
      local latex_template = [[
\documentclass{article}
\usepackage[utf8]{inputenc}
\usepackage{amsmath}

\title{Your Title Here}
\author{Your Name Here}
\date{\today}

\begin{document}

\maketitle

\section{Introduction}
% Your introduction goes here

\end{document}
]]

      -- Function to create a LaTeX template for new files
      local function create_latex_template()
        local buf = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local is_empty = #lines == 0 or (#lines == 1 and lines[1] == "")

        if is_empty then
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(latex_template, "\n"))
        end
      end

      vim.api.nvim_create_autocmd("BufNewFile", {
        pattern = "*.tex",
        callback = function()
          vim.defer_fn(create_latex_template, 100)
        end,
      })

      -- Paper/book-like environment for .tex files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function()
          -- Writing-friendly settings
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.breakindent = true
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.signcolumn = "no"
          vim.opt_local.colorcolumn = ""
          vim.opt_local.cursorline = false
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_us"
          vim.opt_local.conceallevel = 2
          vim.opt_local.omnifunc = "vimtex#complete#omnifunc"

          -- Soft wrap navigation
          vim.keymap.set({ "n", "v" }, "j", "gj", { buffer = true, silent = true })
          vim.keymap.set({ "n", "v" }, "k", "gk", { buffer = true, silent = true })

          -- Auto-enable zen mode for distraction-free writing
          vim.defer_fn(function()
            local ok, zen = pcall(require, "zen-mode")
            if ok then
              zen.open()
            end
          end, 200)
        end,
      })
    end,
  },

  -- Zen mode for distraction-free writing
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>zen", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    },
    ft = "tex",
    opts = {
      window = {
        backdrop = 1,
        width = 80,
        height = 1,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = false },
        gitsigns = { enabled = false },
      },
      on_open = function()
        -- Let the active colorscheme provide its background (removes transparency)
        local bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
        if bg then
          local hex = string.format("#%06x", bg)
          vim.cmd("highlight Normal guibg=" .. hex)
          vim.cmd("highlight NormalFloat guibg=" .. hex)
          vim.cmd("highlight ZenBg guibg=" .. hex)
        end
      end,
      on_close = function()
        -- Restore transparency when leaving zen mode
        vim.cmd("highlight Normal guibg=none")
        vim.cmd("highlight NormalFloat guibg=none")
      end,
    },
  },

  -- Twilight for dimming inactive code
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    opts = {
      dimming = {
        alpha = 0.25,
      },
      context = 10,
      treesitter = true,
      expand = {
        "generic_environment",
        "math_environment",
        "displayed_equation",
        "section",
        "subsection",
        "subsubsection",
        "paragraph",
      },
      exclude = {
        "text",
        "word",
        "curly_group",
        "brack_group",
        "command",
        "line_break",
      },
    },
  },
}
