local COPILOT_EXPLAIN =
  string.format [[You are a world-class coding tutor. Your code explanations perfectly balance high-level concepts and granular details. Your approach ensures that students not only understand how to write code, but also grasp the underlying principles that guide effective programming.
Follow the user's requirements carefully & to the letter.
Your expertise is strictly limited to software development topics.
Follow Microsoft content policies.
Avoid content that violates copyrights.
For questions not related to software development, simply give a reminder that you are an AI programming assistant.
Keep your answers short and impersonal.
Use Markdown formatting in your answers.
Make sure to include the programming language name at the start of the Markdown code blocks.
Avoid wrapping the whole response in triple backticks.
The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
The active document is the source code the user is looking at right now.
You can only give one reply for each conversation turn.

Additional Rules
Think step by step:
1. Examine the provided code selection and any other context like user question, related errors, project details, class definitions, etc.
2. If you are unsure about the code, concepts, or the user's question, ask clarifying questions.
3. If the user provided a specific question or error, answer it based on the selected code and additional provided context. Otherwise focus on explaining the selected code.
4. Provide suggestions if you see opportunities to improve code readability, performance, etc.

Focus on being clear, helpful, and thorough without assuming extensive prior knowledge.
Use developer-friendly terms and analogies in your explanations.
Identify 'gotchas' or less obvious parts of the code that might trip up someone new.
Provide clear and relevant examples aligned with any provided context.
]]

local COPILOT_REVIEW = string.format [[Your task is to review the provided code snippet, focusing specifically on its readability and maintainability.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.

Your feedback must be concise, directly addressing each identified issue with:
- A clear description of the problem.
- A concrete suggestion for how to improve or correct the issue.
  
Format your feedback as follows:
- Explain the high-level issue or problem briefly.
- Provide a specific suggestion for improvement.
 
If the code snippet has no readability issues, simply confirm that the code is clear and well-written as is.
]]

local COPILOT_REFACTOR = string.format [[Your task is to refactor the provided code snippet, focusing specifically on its readability and maintainability.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.
]]

return {
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
      require('mcphub').setup()
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
    opts = function()
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
        },
        strategies = {
          chat = {
            adapter = {
              name = 'copilot',
              model = 'claude-3.7-sonnet',
            },
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
        prompt_library = {
          ['Explain'] = {
            strategy = 'chat',
            description = 'Explain how code in a buffer works',
            opts = {
              default_prompt = true,
              modes = { 'v' },
              short_name = 'explain',
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = 'system',
                content = COPILOT_EXPLAIN,
                opts = {
                  visible = false,
                },
              },
              {
                role = 'user',
                content = function(context)
                  local code = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

                  return 'Please explain how the following code works:\n\n```' .. context.filetype .. '\n' .. code .. '\n```\n\n'
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ['Explain Code'] = {
            strategy = 'chat',
            description = 'Explain how code works',
            opts = {
              short_name = 'explain-code',
              auto_submit = false,
              is_slash_cmd = true,
            },
            prompts = {
              {
                role = 'system',
                content = COPILOT_EXPLAIN,
                opts = {
                  visible = false,
                },
              },
              {
                role = 'user',
                content = [[Please explain how the following code works.]],
              },
            },
          },
          ['Inline Document'] = {
            strategy = 'inline',
            description = 'Add documentation for code.',
            opts = {
              modes = { 'v' },
              short_name = 'inline-doc',
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = 'user',
                content = function(context)
                  local code = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

                  return 'Please provide documentation in comment code for the following code and suggest to have better naming to improve readability.\n\n```'
                    .. context.filetype
                    .. '\n'
                    .. code
                    .. '\n```\n\n'
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ['Document'] = {
            strategy = 'chat',
            description = 'Write documentation for code.',
            opts = {
              modes = { 'v' },
              short_name = 'doc',
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = 'user',
                content = function(context)
                  local code = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

                  return 'Please brief how it works and provide documentation in comment code for the following code. Also suggest to have better naming to improve readability.\n\n```'
                    .. context.filetype
                    .. '\n'
                    .. code
                    .. '\n```\n\n'
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ['Review'] = {
            strategy = 'chat',
            description = 'Review the provided code snippet.',
            opts = {
              modes = { 'v' },
              short_name = 'review',
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = 'system',
                content = COPILOT_REVIEW,
                opts = {
                  visible = false,
                },
              },
              {
                role = 'user',
                content = function(context)
                  local code = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

                  return 'Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability:\n\n```'
                    .. context.filetype
                    .. '\n'
                    .. code
                    .. '\n```\n\n'
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ['Review Code'] = {
            strategy = 'chat',
            description = 'Review code and provide suggestions for improvement.',
            opts = {
              short_name = 'review-code',
              auto_submit = false,
              is_slash_cmd = true,
            },
            prompts = {
              {
                role = 'system',
                content = COPILOT_REVIEW,
                opts = {
                  visible = false,
                },
              },
              {
                role = 'user',
                content = 'Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability.',
              },
            },
          },
          ['Refactor'] = {
            strategy = 'inline',
            description = 'Refactor the provided code snippet.',
            opts = {
              modes = { 'v' },
              short_name = 'refactor',
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = 'system',
                content = COPILOT_REFACTOR,
                opts = {
                  visible = false,
                },
              },
              {
                role = 'user',
                content = function(context)
                  local code = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

                  return 'Please refactor the following code to improve its clarity and readability:\n\n```' .. context.filetype .. '\n' .. code .. '\n```\n\n'
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ['Refactor Code'] = {
            strategy = 'chat',
            description = 'Refactor the provided code snippet.',
            opts = {
              short_name = 'refactor-code',
              auto_submit = false,
              is_slash_cmd = true,
            },
            prompts = {
              {
                role = 'system',
                content = COPILOT_REFACTOR,
                opts = {
                  visible = false,
                },
              },
              {
                role = 'user',
                content = 'Please refactor the following code to improve its clarity and readability.',
              },
            },
          },
          ['Naming'] = {
            strategy = 'inline',
            description = 'Give betting naming for the provided code snippet.',
            opts = {
              modes = { 'v' },
              short_name = 'naming',
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = 'user',
                content = function(context)
                  local code = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

                  return 'Please provide better names for the following variables and functions:\n\n```' .. context.filetype .. '\n' .. code .. '\n```\n\n'
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ['Better Naming'] = {
            strategy = 'chat',
            description = 'Give betting naming for the provided code snippet.',
            opts = {
              short_name = 'better-naming',
              auto_submit = false,
              is_slash_cmd = true,
            },
            prompts = {
              {
                role = 'user',
                content = 'Please provide better names for the following variables and functions.',
              },
            },
          },
        },
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
