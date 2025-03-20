return {
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
}
