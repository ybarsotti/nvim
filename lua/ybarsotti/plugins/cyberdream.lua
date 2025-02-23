return {
  {
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('cyberdream').setup {
        transparent = false,
        italic_comments = false,
        hide_fillchars = true,
        terminal_colors = true
      }
      vim.cmd 'colorscheme cyberdream'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
