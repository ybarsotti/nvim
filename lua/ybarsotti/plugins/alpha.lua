return {
  {
    'rubiin/fortune.nvim',
  },
  {
    'goolord/alpha-nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },

    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'
      local theta = require 'alpha.themes.theta'
      local fortune = require('fortune').get_fortune()

      local buttons = {
        { type = 'text', val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
        { type = 'padding', val = 1 },
        dashboard.button('s', '󱣴  > Open session', ':SessionSearch <CR>'),
        dashboard.button('r', '  > Recent used files', ':Telescope oldfiles <CR>'),
        dashboard.button('f', '󰈞  > Find file', ':Telescope find_files <CR>'),
        dashboard.button('g', '󰊄  > Live grep', ':Telescope live_grep <CR>'),
        dashboard.button('b', '  > Bookmarks', ':Telescope marks <CR>'),
        dashboard.button('u', '  > Update plugins', '<cmd>Lazy sync <CR>'),
        dashboard.button('q', '󰈆  > Quit NVIM', ':qa<CR>'),
        { type = 'padding', val = 1 },
        { type = 'text', val = 'Quote of the day', opts = { hl = 'SpecialComment', position = 'center' } },
        { type = 'text', val = fortune, opts = { position = 'center' } },
      }

      theta.buttons.val = buttons
      theta.header.val = {
        [[____________________  _______________________________]],
        [[\______   \______   \/   _____/\__    ___/\__    ___/]],
        [[ |    |  _/|       _/\_____  \   |    |     |    |   ]],
        [[ |    |   \|    |   \/        \  |    |     |    |   ]],
        [[ |______  /|____|_  /_______  /  |____|     |____|   ]],
        [[        \/        \/        \/                       ]],
      }
      theta.file_icons.provider = 'devicons'
      alpha.setup(theta.config)
    end,
  },
}
