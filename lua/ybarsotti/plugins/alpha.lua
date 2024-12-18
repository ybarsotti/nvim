return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.theta'

    dashboard.header.val = {
      [[____________________  _______________________________]],
      [[\______   \______   \/   _____/\__    ___/\__    ___/]],
      [[ |    |  _/|       _/\_____  \   |    |     |    |   ]],
      [[ |    |   \|    |   \/        \  |    |     |    |   ]],
      [[ |______  /|____|_  /_______  /  |____|     |____|   ]],
      [[        \/        \/        \/                       ]],
    }
    dashboard.file_icons.provider = "devicons"
    alpha.setup(dashboard.config)
  end,
}
