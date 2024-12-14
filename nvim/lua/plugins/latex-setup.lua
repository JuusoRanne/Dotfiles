-- Lua configuration for Neovim
return {
  -- Vimtex plugin
  "lervag/vimtex",

  -- Vimtex settings
  config = function()
    -- Set the view method to 'general' and configure it to use 'evince'
    vim.g.vimtex_view_method = 'general'
    vim.g.vimtex_view_general_viewer = 'evince'
    vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'

    -- Configure folding for Vimtex
    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "vimtex#fold#level(v:lnum)"
    vim.o.foldtext = "vimtex#fold#text()"
    vim.o.foldlevel = 2

    -- Set local leader key
    vim.g.maplocalleader = ","

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

    -- Function to create a LaTeX template
    local function create_latex_template()
      local buf = vim.api.nvim_get_current_buf()
      local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
      local filename = vim.api.nvim_buf_get_name(buf)

      print("create_latex_template called for file: " .. filename)
      vim.api.nvim_command("filetype detect") -- Ensure filetype detection

      -- Recheck filetype
      filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
      print("Rechecked filetype: " .. filetype)

      if filetype == 'tex' then
        -- Check if the buffer is empty
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local is_empty = true
        for _, line in ipairs(lines) do
          if not vim.fn.empty(vim.fn.trim(line)) then
            is_empty = false
            break
          end
        end

        print("Is buffer empty: " .. tostring(is_empty))

        if is_empty then
          -- Insert the LaTeX template
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(latex_template, "\n"))
          vim.api.nvim_command("write") -- Save the buffer to persist changes
          print("LaTeX template inserted")
        else
          print("Buffer is not empty, no template inserted")
        end
      else
        print("Filetype is not 'tex', no template inserted")
      end
    end

    -- Function to compile LaTeX file if Vimtex is not active
    local function compile_latex_file()
      vim.cmd("VimtexCompile")
    end

    -- Create an autocommand group for LaTeX file creation
    vim.api.nvim_create_augroup("LatexFileCreation", { clear = true })
    vim.api.nvim_create_autocmd("BufNewFile", {
      group = "LatexFileCreation",
      pattern = "*.tex",
      callback = function()
        -- Delay to ensure filetype is set and buffer is correctly initialized
        vim.defer_fn(create_latex_template, 100) -- Delay for 100 milliseconds
      end,
    })

    -- Create an autocommand group for compiling LaTeX files
    vim.api.nvim_create_augroup("LatexCompile", { clear = true })
    vim.api.nvim_create_autocmd("BufReadPost", {
      group = "LatexCompile",
      pattern = "*.tex",
      callback = function()
        -- Delay to ensure filetype and Vimtex setup
        vim.defer_fn(function()
          if vim.api.nvim_buf_get_option(0, 'filetype') == 'tex' then
            vim.defer_fn(compile_latex_file, 100) -- Delay for 100 milliseconds
          end
        end, 100)                                 -- Delay for 100 milliseconds
      end,
    })
  end
}
