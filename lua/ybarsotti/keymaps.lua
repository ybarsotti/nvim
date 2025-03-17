-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
local opts = { noremap = true, silent = true }

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Save
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
vim.keymap.set('n', '<leader>wx', ':Bdelete!<CR>', vim.tbl_extend('force', opts, { desc = 'Close buffer'})) -- close buffer

-- Window management
vim.keymap.set('n', '<leader>wv', '<C-w>v', vim.tbl_extend('force', opts, { desc = 'Split window vertically'})) -- split window vertically
vim.keymap.set('n', '<leader>wh', '<C-w>s', vim.tbl_extend('force', opts, { desc = 'Split window horizontally'})) -- split window horizontally
vim.keymap.set('n', '<leader>we', '<C-w>=', vim.tbl_extend('force', opts, { desc = 'Make split windows equal'})) -- make split windows equal width & height

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', vim.tbl_extend('force', opts, { desc = 'Move to window above'}))
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', vim.tbl_extend('force', opts, { desc = 'Move to window below'}))
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', vim.tbl_extend('force', opts, { desc = 'Move to left window'}))
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', vim.tbl_extend('force', opts, { desc = 'Move to right window'}))

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', vim.tbl_extend('force', opts, { desc = 'Indent to left'}))
vim.keymap.set('v', '>', '>gv', vim.tbl_extend('force', opts, { desc = 'Indent to right'}))

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', vim.tbl_extend('force', opts, { desc = 'Paste and keep last yanked'}))

-- vim: ts=2 sts=2 sw=2 et
