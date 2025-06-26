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
    build = 'cd app && npm ci',
    enabled = false,
    opts = {},
  },
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = '[Image]($FILE_PATH)',
          use_absolute_path = true,
        },
      },
    },
    keys = {
      { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Img clip: [P]aste image from system clipboard' },
    },
  },
  {
    'OXY2DEV/markview.nvim',
    enabled = false,
    lazy = false,
    opts = function()
      local function conceal_tag(icon, hl_group)
        return {
          on_node = { hl_group = hl_group },
          on_closing_tag = { conceal = '' },
          on_opening_tag = {
            conceal = '',
            virt_text_pos = 'inline',
            virt_text = { { icon .. ' ', hl_group } },
          },
        }
      end

      return {
        preview = {
          filetypes = { 'markdown', 'codecompanion' },
          icon_provider = 'devicons',
          ignore_buftypes = {},
        },

        html = {
          container_elements = {
            ['^buf$'] = {
              on_closing_tag = {
                conceal = '',
              },
              on_node = {
                hl_group = 'CodeCompanionChatVariable',
              },
              on_opening_tag = {
                conceal = '',
                virt_text = { { ' ', 'CodeCompanionChatVariable' } },
                virt_text_pos = 'inline',
              },
            },
            ['^file$'] = {
              on_closing_tag = {
                conceal = '',
              },
              on_node = {
                hl_group = 'CodeCompanionChatVariable',
              },
              on_opening_tag = {
                conceal = '',
                virt_text = { { ' ', 'CodeCompanionChatVariable' } },
                virt_text_pos = 'inline',
              },
            },
            ['^group$'] = {
              on_closing_tag = {
                conceal = '',
              },
              on_node = {
                hl_group = 'CodeCompanionChatToolGroup',
              },
              on_opening_tag = {
                conceal = '',
                virt_text = { { ' ', 'CodeCompanionChatToolGroup' } },
                virt_text_pos = 'inline',
              },
            },
            ['^help$'] = {
              on_closing_tag = {
                conceal = '',
              },
              on_node = {
                hl_group = 'CodeCompanionChatVariable',
              },
              on_opening_tag = {
                conceal = '',
                virt_text = { { '󰘥 ', 'CodeCompanionChatVariable' } },
                virt_text_pos = 'inline',
              },
            },
            ['^image$'] = {
              on_closing_tag = {
                conceal = '',
              },
              on_node = {
                hl_group = 'CodeCompanionChatVariable',
              },
              on_opening_tag = {
                conceal = '',
                virt_text = { { ' ', 'CodeCompanionChatVariable' } },
                virt_text_pos = 'inline',
              },
            },
            ['^symbols$'] = {
              on_closing_tag = {
                conceal = '',
              },
              on_node = {
                hl_group = 'CodeCompanionChatVariable',
              },
              on_opening_tag = {
                conceal = '',
                virt_text = { { ' ', 'CodeCompanionChatVariable' } },
                virt_text_pos = 'inline',
              },
            },
            ['^tool$'] = {
              on_closing_tag = {
                conceal = '',
              },
              on_node = {
                hl_group = 'CodeCompanionChatTool',
              },
              on_opening_tag = {
                conceal = '',
                virt_text = { { ' ', 'CodeCompanionChatTool' } },
                virt_text_pos = 'inline',
              },
            },
            ['^url$'] = {
              on_closing_tag = {
                conceal = '',
              },
              on_node = {
                hl_group = 'CodeCompanionChatVariable',
              },
              on_opening_tag = {
                conceal = '',
                virt_text = { { '󰖟 ', 'CodeCompanionChatVariable' } },
                virt_text_pos = 'inline',
              },
            },
            ['^user_prompt$'] = {
              on_closing_tag = {
                conceal = '',
              },
              on_node = {
                hl_group = 'CodeCompanionChatTool',
              },
              on_opening_tag = {
                conceal = '',
                virt_text = { { ' ', 'CodeCompanionChatTool' } },
                virt_text_pos = 'inline',
              },
            },
            ['^var$'] = {
              on_closing_tag = {
                conceal = '',
              },
              on_node = {
                hl_group = 'CodeCompanionChatVariable',
              },
              on_opening_tag = {
                conceal = '',
                virt_text = { { ' ', 'CodeCompanionChatVariable' } },
                virt_text_pos = 'inline',
              },
            },
          },
        },
        markdown_inline = {},
      }
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'codecompanion' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
