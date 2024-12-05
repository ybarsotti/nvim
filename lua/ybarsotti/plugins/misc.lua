-- Standalone plugins with less than 10 lines of configuration
return {
  { -- Autoclose parentheses, brackets, quotes, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    -- Tmux & split window navigation
    'christoomey/vim-tmux-navigator',
  },
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },
  { -- Highlight TODO, FIXME etc
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  { 'mrjones2014/smart-splits.nvim', lazy = false },
  { -- Complete tags <div></div> for example
    'windwp/nvim-ts-autotag',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'windwp/nvim-ts-autotag',
    },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
  { -- Helps updating tags "(), ''"
    -- Keybind: cs<current_tag><new_tag>
    'tpope/vim-surround',
    lazy = false,
  },
  { -- Better looking input commands
    'stevearc/dressing.nvim',
    -- event = 'VeryLazy',
    opts = {},
  },
  { -- Allows to repeat non native commands
    'tpope/vim-repeat'
  }
}
