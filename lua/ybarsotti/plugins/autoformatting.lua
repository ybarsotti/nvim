return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
    'gbprod/none-ls-shellcheck.nvim',
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    -- Formatters & linters for mason to install
    require('mason-null-ls').setup {
      ensure_installed = {
        'prettier', -- ts/js formatter
        'stylua', -- lua formatter
        'eslint_d', -- ts/js linter
        'shfmt', -- Shell formatter
        'checkmake', -- linter for Makefiles
        'ruff', -- Python linter and formatter
      },
      automatic_installation = true,
    }

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    local function on_attach(client, bufnr)
      -- if client.supports_method 'textDocument/formatting' then
      --   vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      --   vim.api.nvim_create_autocmd('BufWritePre', {
      --     group = augroup,
      --     buffer = bufnr,
      --     callback = function()
      --       vim.lsp.buf.format { async = false }
      --     end,
      --   })
      -- end
    end

    local sources = {
      -------------------        LUA       ------------------------
      formatting.stylua,
      ----------------                              ----------------

      -------------------        BASH       ------------------------
      formatting.shfmt,
      require 'none-ls-shellcheck.diagnostics',
      require 'none-ls-shellcheck.code_actions',
      ----------------                              ----------------

      -------------------        TS | JS       ------------------------
      require 'none-ls.diagnostics.eslint_d', -- TS | JS
      require 'none-ls.code_actions.eslint_d',
      require 'none-ls.formatting.beautysh',
      require 'none-ls.formatting.eslint_d',
      require 'none-ls.formatting.jq',
      ----------------                              ----------------

      -------------------        PRETTIER FORMATTER       ------------------------
      null_ls.builtins.formatting.prettierd.with {
        filetypes = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
          'vue',
          'css',
          'scss',
          'less',
          'html',
          'json',
          'jsonc',
          'yaml',
          'markdown',
          'markdown.mdx',
          'graphql',
        },
        extra_filetypes = { 'toml' },
      },
      ----------------                              ----------------

      -------------------        CSS       ------------------------
      diagnostics.stylelint,
      ----------------                              ----------------

      -------------------        GO       ------------------------
      diagnostics.staticcheck,
      formatting.asmfmt,
      ----------------                              ----------------

      -------------------        PYTHON       ------------------------
      formatting.black,
      formatting.isort,
      diagnostics.flake8,
      ----------------                              ----------------
    }

    null_ls.setup {
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = on_attach,
    }
    vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, {})
  end,
}

-- diagnostic == linting
-- formatting == format
