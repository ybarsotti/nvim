return {
  -- {
  --   'Exafunction/codeium.vim',
  --   event = 'BufEnter',
  --   config = function()
  --     vim.keymap.set('i', '<C-]>', function()
  --       return vim.fn['codeium#Accept']()
  --     end, { expr = true, silent = true })
  --     vim.keymap.set('i', '<c-[>', function()
  --       return vim.fn['codeium#Clear']()
  --     end, { expr = true, silent = true })
  --   end,
  -- },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = false,
        },
      }
    end,
  },
  -- Code completion plugin that integrates with mcphub
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'ravitemer/mcphub.nvim',
    },
  },
  {
    'HakonHarnes/img-clip.nvim',
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = '[Image]($FILE_PATH)',
          use_absolute_path = true,
        },
      },
    },
  },
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    opts = {
      preview = {
        filetypes = { 'markdown', 'codecompanion' },
        ignore_buftypes = {},
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'codecompanion' },
  },
  {
    'olimorris/codecompanion.nvim',
    opts = {
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },
}
