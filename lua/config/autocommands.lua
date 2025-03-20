local augroup = vim.api.nvim_create_augroup

-- local SottiGroup = augroup('Sotti', { clear = true })
local yank_group = augroup('HighlightYank', {})

local autocmd = vim.api.nvim_create_autocmd

autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = yank_group,
  callback = function()
    vim.highlight.on_yank {
      higroup = 'IncSearch',
      timeout = 40,
    }
  end,
})

-- vim: ts=2 sts=2 sw=2 et
