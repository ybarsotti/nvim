return {
  {
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
    opts = {
      status = { virtual_text = true },
      output = { open_on_run = true },
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-python',
          require 'neotest-jest',
          require 'neotest-golang',
          require 'neotest-vitest',
        },
      }
    end,
    keys = {
      {
        '<leader>tt',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = 'Neotest: Run File',
      },
      {
        '<leader>tT',
        function()
          require('neotest').run.run(vim.uv.cwd())
        end,
        desc = 'Neotest: Run All Test Files',
      },
      {
        '<leader>tr',
        function()
          require('neotest').run.run()
        end,
        desc = 'Neotest: Run Nearest',
      },
      {
        '<leader>tl',
        function()
          require('neotest').run.run_last()
        end,
        desc = 'Neotest: Run Last',
      },
      {
        '<leader>ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = 'Neotest: Toggle Summary',
      },
      {
        '<leader>to',
        function()
          require('neotest').output.open { enter = true, auto_close = true }
        end,
        desc = 'Neotest: Show Output',
      },
      {
        '<leader>tO',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = 'Neotest: Toggle Output Panel',
      },
      {
        '<leader>tS',
        function()
          require('neotest').run.stop()
        end,
        desc = 'Neotest: Stop',
      },
      {
        '<leader>tw',
        function()
          require('neotest').watch.toggle(vim.fn.expand '%')
        end,
        desc = 'Neotest: Toggle Watch',
      },
    },
  },
  { -- Debugger
    'mfussenegger/nvim-dap',
    -- stylua: ignore
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap-python",
      "mfussenegger/nvim-dap-vscode-js",
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      require('dapui').setup()
      require('dap-go').setup {
        dap_configurations = {
          {
            type = 'go',
            name = 'Attach remote',
            mode = 'remote',
            request = 'attach',
          },
        },
        delve = {
          port = '40000',
        },
      }
      require('nvim-dap-virtual-text').setup {}
      require('dap-python').setup 'python3'

      -- Eval var under cursor
      vim.keymap.set('n', '<space>t?', function()
        require('dapui').eval(nil, { enter = true })
      end, { desc = "DAP: Eval under cursor" })

      vim.keymap.set('n', '<space>tb', dap.toggle_breakpoint, { desc = "DAP: [T]oggle [B]reakpoint" })
      vim.keymap.set('n', '<space>tc', dap.run_to_cursor, { desc = "DAP: Run [C]ursor" })

      vim.keymap.set('n', '<F1>', dap.continue, { desc = "DAP: Continue" })
      vim.keymap.set('n', '<F2>', dap.step_into, { desc = "DAP: Step Into" })
      vim.keymap.set('n', '<F3>', dap.step_over, { desc = "DAP: Step Over" })
      vim.keymap.set('n', '<F4>', dap.step_out, { desc = "DAP: Step Out" })
      vim.keymap.set('n', '<F5>', dap.step_back, { desc = "DAP: Step Back" })
      vim.keymap.set('n', '<F13>', dap.restart, { desc = "DAP: Restart" })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
