return {
  {
    'milanglacier/minuet-ai.nvim',
    config = function()
      require('minuet').setup {}
    end,
  },
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
  {
    'Davidyz/VectorCode',
    version = '*',
    build = 'uv tool upgrade vectorcode', -- This helps keeping the CLI up-to-date
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local cacher = require('vectorcode.config').get_cacher_backend()
      local cacher_utils = require('vectorcode.cacher').utils
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          cacher_utils.async_check('config', function()
            cacher.register_buffer(bufnr, {
              n_query = 10,
            })
          end, nil)
        end,
        desc = 'Register buffer for VectorCode',
      })
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
      require('mcphub').setup {
        config = vim.fn.expand '~/.config/mcphub/servers.json',
        auto_toggle_mcp_servers = true,
        extensions = {
          avante = {
            make_slash_commands = true,
          },
        },
        native_servers = {}, -- add your custom lua native servers here
        ui = {
          window = {
            width = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
            height = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
            align = 'center', -- "center", "top-left", "top-right", "bottom-left", "bottom-right", "top", "bottom", "left", "right"
            relative = 'editor',
            zindex = 50,
            border = 'rounded', -- "none", "single", "double", "rounded", "solid", "shadow"
          },
          wo = { -- window-scoped options (vim.wo)
            winhl = 'Normal:MCPHubNormal,FloatBorder:MCPHubBorder',
          },
        },
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = 'MCPHub',
        },
      }
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'ravitemer/mcphub.nvim',
      'ravitemer/codecompanion-history.nvim',
    },
    keys = {
      { '<leader>aa', '<Esc><cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Actions' },
      { '<leader>aA', '<Esc><cmd>CodeCompanionChat Add<cr>', mode = { 'v' }, desc = 'CodeCompanion: Add selected into chat buffer' },
      { '<leader>ai', '<Esc><cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Open Inline mode' },
      { '<leader>ac', '<Esc><cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Toggle Chat' },
      { '<leader>ad', '<Esc><cmd>CodeCompanion /doc<cr>', mode = { 'v' }, desc = 'CodeCompanion: Write document for code' },
      { '<leader>ar', '<Esc><cmd>CodeCompanion /refactor<cr>', mode = { 'v' }, desc = 'CodeCompanion: Refactor code' },
      { '<leader>aR', '<Esc><cmd>CodeCompanion /review<cr>', mode = { 'v' }, desc = 'CodeCompanion: Review code' },
      { '<leader>an', '<Esc><cmd>CodeCompanion /naming<cr>', mode = { 'v' }, desc = 'CodeCompanion: Better naming' },
      { '<leader>ah', '<Esc><cmd>CodeCompanionHistory<cr>', mode = { 'n' }, desc = 'CodeCompanion extension: History' },
    },
    config = function(_, opts)
      local spinner = require 'plugins.code-companion.spinner'
      spinner:init()
      require('codecompanion').setup(opts)
    end,
    opts = function()
      local PROMPTS = require 'plugins.code-companion.prompts'
      return {
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
          copilot = function()
            return require('codecompanion.adapters').extend('copilot', {
              schema = {
                model = {
                  default = 'claude-sonnet-4',
                  -- default = 'gpt-5'
                  -- default = 'claude-3.7-sonnet',
                },
              },
            })
          end,
        },
        strategies = {
          chat = {
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
                callback = function(chat)
                  vim.cmd 'stopinsert'
                  chat:submit()
                  chat:add_buf_message { role = 'llm', content = '' }
                end,
                index = 1,
                description = 'Send',
              },
              close = {
                modes = { n = '<Esc>', i = '<Esc>' },
                opts = {},
              },
              stop = {
                modes = {
                  n = '<C-c>',
                },
                index = 4,
                callback = 'keymaps.stop',
                description = 'Stop Request',
              },
            },
          },
          opts = {
            completion_provider = 'cmp', -- blink|cmp|coc|default
            log_level = 'DEBUG',
            system_prompt = PROMPTS.SYSTEM_PROMPT,
          },
          inline = {
            adapter = 'copilot',
          },
          cmd = {
            adapter = 'copilot',
          },
        },
        prompt_library = PROMPTS.PROMPT_LIBRARY,
        display = {
          chat = {
            intro_message = 'Hey Barsotti ✨! How can I help You? Press ? for options',
            show_header_separator = true, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
            separator = '─', -- The separator between the different messages in the chat buffer
            show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
            show_settings = true, -- Show LLM settings at the top of the chat buffer?
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
          history = {
            enabled = true,
            opts = {
              -- Keymap to open history from chat buffer (default: gh)
              keymap = 'gh',
              -- Keymap to save the current chat manually (when auto_save is disabled)
              save_chat_keymap = 'sc',
              -- Save all chats by default (disable to save only manually using 'sc')
              auto_save = true,
              -- Number of days after which chats are automatically deleted (0 to disable)
              expiration_days = 90,
              -- Picker interface ("telescope" or "snacks" or "fzf-lua" or "default")
              picker = 'telescope',
              -- Customize picker keymaps (optional)
              picker_keymaps = {
                rename = { n = 'r', i = '<M-r>' },
                delete = { n = 'd', i = '<M-d>' },
                duplicate = { n = '<C-y>', i = '<C-y>' },
              },
              ---Automatically generate titles for new chats
              auto_generate_title = true,
              title_generation_opts = {
                ---Number of user prompts after which to refresh the title (0 to disable)
                refresh_every_n_prompts = 10, -- e.g., 3 to refresh after every 3rd user prompt
                ---Maximum number of times to refresh the title (default: 3)
                max_refreshes = 3,
              },
              ---On exiting and entering neovim, loads the last chat on opening chat
              continue_last_chat = true,
              ---When chat is cleared with `gx` delete the chat from history
              delete_on_clearing_chat = true,
              ---Directory path to save the chats
              dir_to_save = vim.fn.stdpath 'data' .. '/codecompanion-history',
              ---Enable detailed logging for history extension
              enable_logging = false,
              ---Optional filter function to control which chats are shown when browsing
              chat_filter = nil, -- function(chat_data) return boolean end
            },
          },
          vectorcode = {
            ---@type VectorCode.CodeCompanion.ExtensionOpts
            opts = {
              tool_group = {
                -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
                enabled = true,
                -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
                -- if you use @vectorcode_vectorise, it'll be very handy to include
                -- `file_search` here.
                extras = {},
                collapse = false, -- whether the individual tools should be shown in the chat
              },
              tool_opts = {
                ---@type VectorCode.CodeCompanion.LsToolOpts
                ls = {},
                ---@type VectorCode.CodeCompanion.VectoriseToolOpts
                vectorise = {},
                ---@type VectorCode.CodeCompanion.QueryToolOpts
                query = {
                  max_num = { chunk = -1, document = -1 },
                  default_num = { chunk = 50, document = 10 },
                  include_stderr = false,
                  use_lsp = true,
                  no_duplicate = true,
                  chunk_mode = false,
                  ---@type VectorCode.CodeCompanion.SummariseOpts
                  summarise = {
                    ---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
                    enabled = false,
                    adapter = nil,
                    query_augmented = true,
                  },
                },
                files_ls = {},
                files_rm = {},
              },
            },
          },
        },
      }
    end,
  },
}
