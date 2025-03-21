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
  { -- Allows to repeat non native commands
    'tpope/vim-repeat',
  },
  { -- Code screenshots
    'mistricky/codesnap.nvim',
    build = 'make',
    keys = {
      { '<leader>cs', '<Esc><cmd>CodeSnap<cr>', mode = 'x', desc = 'Codesnap: Save selected code snapshot into clipboard' },
      { '<leader>cS', '<Esc><cmd>CodeSnapSave<cr>', mode = 'x', desc = 'Codesnap: Save selected code snapshot in ~/Pictures' },
    },
    opts = {
      save_path = '~/Pictures',
      has_breadcrumbs = true,
      bg_theme = 'grape',
      watermark = '',
    },
  },
  { -- Improve this f vim motionssss, just run :VimBeGood in an empty file
    'ThePrimeagen/vim-be-good',
  },
  { -- File Manager
    'mikavilpas/yazi.nvim',
    lazy = true,
    keys = {
      {
        '<leader>y',
        '<cmd>Yazi<cr>',
        desc = 'Yazi: Open',
      },
    },
    opts = {
      open_for_directories = true,
    },
  },
  { -- Markdown previewer
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = "cd app && npm ci",
    opts = {}
  },
}
