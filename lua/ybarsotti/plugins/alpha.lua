return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.startify'

    dashboard.section.header.val = {
      [[____________________  _______________________________]],
      [[\______   \______   \/   _____/\__    ___/\__    ___/]],
      [[ |    |  _/|       _/\_____  \   |    |     |    |   ]],
      [[ |    |   \|    |   \/        \  |    |     |    |   ]],
      [[ |______  /|____|_  /_______  /  |____|     |____|   ]],
      [[        \/        \/        \/                       ]],
    }

    alpha.setup(dashboard.opts)
  end,
}
