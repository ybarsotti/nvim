-- [[ Setting options ]]
require 'config.options'

-- [[ Keymaps ]]
require 'config.keymaps'

-- [[ Autommands ]]
require 'config.autocommands'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'config.lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'config.lazy-plugins'

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. '/.local/share/mise/shims:' .. vim.env.PATH

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
