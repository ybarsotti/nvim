return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
    { 'fredrikaverpil/neotest-golang', version = '*' },
    'nvim-neotest/neotest-jest',
    'marilari88/neotest-vitest',
  },
  opts = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-jest',
        require 'neotest-python',
        require 'neotest-golang',
        require 'neotest-vitest',
      },
    }
  end,
}
