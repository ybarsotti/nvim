-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
local opts = { noremap = true, silent = true }

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Save and format
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', vim.tbl_extend('force', opts, { desc = 'Save' }))

-- Quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', vim.tbl_extend('force', opts, { desc = 'Quit file' }))

-- Delete char without saving it into register
vim.keymap.set({'n', 'v'}, 'x', '"_x', vim.tbl_extend('force', opts, { desc = 'Delete char without saving it into register' }))

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', vim.tbl_extend('force', opts, { desc = 'Scroll down and center screen' }))
vim.keymap.set('n', '<C-u>', '<C-u>zz', vim.tbl_extend('force', opts, { desc = 'Scroll up and center screen' }))

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', vim.tbl_extend('force', opts, { desc = 'Find next and center' }))
vim.keymap.set('n', 'N', 'Nzzzv', vim.tbl_extend('force', opts, { desc = 'Find previous and center' }))

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', vim.tbl_extend('force', opts, { desc = 'Resize top' }))
vim.keymap.set('n', '<Down>', ':resize +2<CR>', vim.tbl_extend('force', opts, { desc = 'Resize down' }))
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', vim.tbl_extend('force', opts, { desc = 'Resize left' }))
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', vim.tbl_extend('force', opts, { desc = 'Resize right' }))

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', vim.tbl_extend('force', opts, { desc = 'Goto next buffer' }))
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', vim.tbl_extend('force', opts, { desc = 'Close previous buffer'}))
vim.keymap.set('n', '<leader>xb', ':bdelete!<CR>', vim.tbl_extend('force', opts, { desc = 'Close buffer'})) -- close buffer
vim.keymap.set('n', '<leader>nb', '<cmd> enew <CR>', vim.tbl_extend('force', opts, { desc = 'New buffer'})) -- new buffer

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', vim.tbl_extend('force', opts, { desc = 'Split vertically'})) -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', vim.tbl_extend('force', opts, { desc = 'Split horizontally'})) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', vim.tbl_extend('force', opts, { desc = 'Make split windows equal'})) -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', vim.tbl_extend('force', opts, { desc = 'Close current split window'})) -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', vim.tbl_extend('force', opts, { desc = 'Move to window above'}))
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', vim.tbl_extend('force', opts, { desc = 'Move to window below'}))
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', vim.tbl_extend('force', opts, { desc = 'Move to left window'}))
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', vim.tbl_extend('force', opts, { desc = 'Move to right window'}))

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', vim.tbl_extend('force', opts, { desc = 'Open new tab'})) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', vim.tbl_extend('force', opts, { desc = 'Close tab'})) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', vim.tbl_extend('force', opts, { desc = 'Go to next tab'})) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', vim.tbl_extend('force', opts, { desc = 'Go to previous tab'})) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', vim.tbl_extend('force', opts, { desc = 'Toggle line wrap'}))

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', vim.tbl_extend('force', opts, { desc = 'Indent to left'}))
vim.keymap.set('v', '>', '>gv', vim.tbl_extend('force', opts, { desc = 'Indent to right'}))

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', vim.tbl_extend('force', opts, { desc = 'Paste and keep last yanked'}))

-- Diagnostic keymaps
-- Managed by Trouble.nvim
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
