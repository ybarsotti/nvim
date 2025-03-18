return {
  {
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    config = function()
      require('cyberdream').setup {
        transparent = false,
        italic_comments = false,
        hide_fillchars = true,
        terminal_colors = true,
      }
      -- vim.cmd 'colorscheme cyberdream'
    end,
  },
  {
    'savq/melange-nvim',
    lazy = false,
  },
  {
    'sainnhe/everforest',
    lazy = false,
    opts = {},
  },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    config = function()
      vim.cmd 'colorscheme gruvbox-material'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
