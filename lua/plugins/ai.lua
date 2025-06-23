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
    'ravitemer/mcphub.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    build = 'npm install -g mcp-hub@latest', -- Installs `mcp-hub` node binary globally
    keys = {
      { '<leader>am', '<Esc><cmd>MCPHub<cr>', desc = 'MCPHub: Open' },
    },
    config = function()
      require('mcphub').setup()
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    opts = {
      adapters = {
        -- Local model adapter for Ollama
        llama3 = function()
          return require('codecompanion.adapters').extend('ollama', {
            name = 'llama3',
            env = {
              url = 'http://localhost:8080',
              chat_url = '/v1/chat/completions',
              models_endpoint = '/v1/models',
            },
            schema = {
              model = {
                default = 'unsloth/Devstral-Small-2505-GGUF',
              },
              num_ctx = {
                default = 128000,
              },
              num_predict = {
                default = -1,
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'copilot',
          roles = {
            ---The header name for the LLM's messages
            ---@type string|fun(adapter: CodeCompanion.Adapter): string
            llm = function(adapter)
              return 'CodeCompanion (' .. adapter.formatted_name .. ')'
            end,

            ---The header name for your messages
            ---@type string
            user = 'Barsotti',
          },
          keymaps = {
            send = {
              modes = { n = '<C-s>', i = '<C-s>' },
              opts = {},
            },
            close = {
              modes = { n = '<Esc>', i = '<Esc>' },
              opts = {},
            },
            -- Add further custom keymaps here
          },
        },
        opts = {
          completion_provider = 'cmp', -- blink|cmp|coc|default
        },
        inline = {
          adapter = 'copilot',
        },
        cmd = {
          adapter = 'copilot',
        },
      },
      display = {
        chat = {
          intro_message = 'Hey Barsotti ✨! How can I help You? Press ? for options',
          show_header_separator = true, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
          separator = '─', -- The separator between the different messages in the chat buffer
          show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
          show_settings = false, -- Show LLM settings at the top of the chat buffer?
          show_token_count = true, -- Show the token count for each response?
          start_in_insert_mode = false, -- Open the chat buffer in insert mode?
        },
      },
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
    keys = {
      { '<leader>aa', '<Esc><cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Actions' },
      { '<leader>ai', '<Esc><cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Open Inline mode' },
      { '<leader>ac', '<Esc><cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Toggle Chat' },
      { 'ga', '<Esc><cmd>CodeCompanionChat Add<cr>', mode = { 'v' }, desc = 'CodeCompanion: Add selected into chat buffer' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'ravitemer/mcphub.nvim',
    },
  },
}
