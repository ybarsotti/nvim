return {
  'folke/zen-mode.nvim',
  config = function()
    vim.keymap.set('n', '<leader>zz', function()
      require('zen-mode').setup {
        window = {
          width = 0.80,
          options = {},
        },
        plugins = {
          tmux = { enabled = false },
        },
      }
      require('zen-mode').toggle()
      vim.wo.wrap = false
      vim.wo.number = true
      vim.wo.rnu = true
    end, { desc = "Toggle [z]en mode"})

    vim.keymap.set('n', '<leader>zZ', function()
      require('zen-mode').setup {
        window = {
          width = 80,
          options = {},
        },
      }
      require('zen-mode').toggle()
      vim.wo.wrap = false
      vim.wo.number = false
      vim.wo.rnu = false
      vim.opt.colorcolumn = '0'
    end, { desc = "Toggle [z]en mode (Simple)"})
  end,
}
