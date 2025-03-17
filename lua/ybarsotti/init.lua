-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- For the markdown plugin
vim.g.mkdp_filetypes = { 'markdown' }
vim.g.mkdp_auto_start = 1

-- Codeium Autocomplete
vim.g.codeium_enabled = false
vim.g.codeium_disable_bindings = 1

-- [[ Setting options ]]
require 'ybarsotti.options'

-- [[ Keymaps ]]
require 'ybarsotti.keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'ybarsotti.lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'ybarsotti.lazy-plugins'

-- [[ Autommands ]]
require 'ybarsotti.autocommands'

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. '/.local/share/mise/shims:' .. vim.env.PATH

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
