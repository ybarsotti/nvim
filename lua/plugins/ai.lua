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
      'jellydn/spinner.nvim',
    },
    keys = {
      { '<leader>aa', '<Esc><cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Actions' },
      { 'ga', '<Esc><cmd>CodeCompanionChat Add<cr>', mode = { 'v' }, desc = 'CodeCompanion: Add selected into chat buffer' },
      { '<leader>ai', '<Esc><cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Open Inline mode' },
      { '<leader>ac', '<Esc><cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Toggle Chat' },
      { '<leader>ad', '<Esc><cmd>CodeCompanion /doc<cr>', mode = { 'v' }, desc = 'CodeCompanion: Write document for code' },
      { '<leader>ar', '<Esc><cmd>CodeCompanion /refactor<cr>', mode = { 'v' }, desc = 'CodeCompanion: Refactor code' },
      { '<leader>aR', '<Esc><cmd>CodeCompanion /review<cr>', mode = { 'v' }, desc = 'CodeCompanion: Review code' },
      { '<leader>an', '<Esc><cmd>CodeCompanion /naming<cr>', mode = { 'v' }, desc = 'CodeCompanion: Better naming' },
    },
    config = function(_, options)
      require('codecompanion').setup(options)

      -- Show loading spinner when request is started
      local spinner = require 'spinner'
      local group = vim.api.nvim_create_augroup('CodeCompanionHooks', {})
      vim.api.nvim_create_autocmd({ 'User' }, {
        pattern = 'CodeCompanionRequest*',
        group = group,
        callback = function(request)
          if request.match == 'CodeCompanionRequestStarted' then
            spinner.show()
          end
          if request.match == 'CodeCompanionRequestFinished' then
            spinner.hide()
          end
        end,
      })
    end,
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
      },
    },
  },
}
