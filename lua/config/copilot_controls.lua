local create_user_cmd = vim.api.nvim_create_user_command

create_user_cmd('CopilotEnable', function()
  require('copilot').setup {
    suggestion = { enabled = false },
    panel = { enabled = false },
  }

  local cmp = require 'cmp'
  cmp.setup {
    sources = cmp.config.sources {
      {
        name = 'lazydev',
        group_index = 0,
      },
      { name = 'nvim_lsp', group_index = 2 },
      { name = 'luasnip', group_index = 2 },
      { name = 'buffer', group_index = 2 },
      { name = 'path', group_index = 2 },
      { name = 'copilot', group_index = 2 },
    },
  }

  vim.notify('Copilot activated', vim.log.levels.INFO, { title = 'Copilot' })
end, {})

create_user_cmd('CopilotDisable', function()
  require('copilot').setup {
    suggestion = { enabled = false },
    panel = { enabled = false },
  }

  local cmp = require 'cmp'
  cmp.setup {
    sources = cmp.config.sources {
      {
        name = 'lazydev',
        group_index = 0,
      },
      { name = 'nvim_lsp', group_index = 2 },
      { name = 'luasnip', group_index = 2 },
      { name = 'buffer', group_index = 2 },
      { name = 'path', group_index = 2 },
    },
  }

  vim.notify('Copilot deactivated ❌', vim.log.levels.WARN, { title = 'Copilot' })
end, {})

-- vim: ts=2 sts=2 sw=2 et
