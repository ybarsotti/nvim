return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
      python = { 'pylint' },
      cpp = { 'cpplint' },
      dockerfile = { 'hadolint' },
      go = { 'golangcilint' },
      lua = { 'selene' },
      markdown = { 'markdownlint-cli2' },
      yaml = { 'yamllint' },
    }

    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set('n', '<leader>lf', function()
      lint.try_lint()
    end, { desc = 'Trigger linting for current file' })
  end,
}
