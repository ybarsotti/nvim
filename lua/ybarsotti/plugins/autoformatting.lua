return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local conform = require 'conform'
    conform.setup {
      formatters_by_ft = {
        javascript = { 'prettier' },
        clang = { 'clang_format ' },
        cpp = { 'clang_format ' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        go = {'gofmt', 'goimports', 'golines'},
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        graphql = { 'prettier' },
        lua = { 'stylua' },
        python = { 'isort', 'black', 'autopep8' },
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>ff', function()
      conform.format {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      }
    end, { desc = 'Format file or range (in visual mode) - (Conform)' })
  end,
}

-- diagnostic == linting
-- formatting == format
