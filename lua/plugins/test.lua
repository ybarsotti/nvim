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
      {"theHamsta/nvim-dap-virtual-text", opts = {}},
      {
        'microsoft/vscode-js-debug',
        -- Run cd ~/.local/share/nvim/lazy/vscode-js-debug && rm -rf package-lock.json if this fails
        build = 'npm i && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out',
      },
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap-python",
      "mxsdev/nvim-dap-vscode-js",
    },
    config = function()
      local dap = require 'dap'
      require('dap-vscode-js').setup {
        debugger_path = vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug',
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      }
      require('nvim-dap-virtual-text').setup {}
      require('dap-python').setup 'python3'
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

      if not dap.adapters['node'] then
        dap.adapters['node'] = function(cb, config)
          if config.type == 'node' then
            config.type = 'pwa-node'
          end
          local nativeAdapter = dap.adapters['pwa-node']
          if type(nativeAdapter) == 'function' then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      if not dap.adapters['pwa-node'] then
        dap.adapters['pwa-node'] = {
          type = 'server',
          host = 'localhost',
          port = '${port}',
          executable = {
            command = 'node',
            args = {
              os.getenv 'HOME' .. '/.local/share/nvim/vscode-js-debug/out/src/vsDebugServer.js',
              '${port}',
            },
          },
        }
      end

      local dap_vscode = require 'dap.ext.vscode'
      local js_filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }
      local json = require 'plenary.json'
      ---@diagnostic disable-next-line: duplicate-set-field
      dap_vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str, {}))
      end
      dap_vscode.type_to_filetypes['node'] = js_filetypes

      for _, language in ipairs(js_filetypes) do
        dap.configurations[language] = {
          -- Debug single nodejs files
          {
            name = 'Launch file',
            type = 'pwa-node',
            request = 'launch',
            program = '${file}',
            cwd = '${workspaceFolder}',
            args = { '${file}' },
            sourceMaps = true,
            sourceMapPathOverrides = {
              ['./*'] = '${workspaceFolder}/src/*',
            },
          },
          -- Debug nodejs processes (make sure to add --inspect when you run the process)
          {
            name = 'Attach',
            type = 'pwa-node',
            request = 'attach',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
            sourceMaps = true,
          },
          {
            name = 'Debug Jest Tests',
            type = 'pwa-node',
            request = 'launch',
            runtimeExecutable = 'node',
            runtimeArgs = { '${workspaceFolder}/node_modules/.bin/jest', '--runInBand' },
            rootPath = '${workspaceFolder}',
            cwd = '${workspaceFolder}',
            console = 'integratedTerminal',
            internalConsoleOptions = 'neverOpen',
            -- args = {'${file}', '--coverage', 'false'},
            -- sourceMaps = true,
            -- skipFiles = {'node_internals/**', 'node_modules/**'},
          },
          {
            name = 'Debug Vitest Tests',
            type = 'pwa-node',
            request = 'launch',
            cwd = vim.fn.getcwd(),
            program = '${workspaceFolder}/node_modules/vitest/vitest.mjs',
            args = { 'run', '${file}' },
            autoAttachChildProcesses = true,
            smartStep = true,
            skipFiles = { '<node_internals>/**', 'node_modules/**' },
          },
          -- Debug web applications (client side)
          {
            name = 'Launch & Debug Chrome',
            type = 'pwa-chrome',
            request = 'launch',
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({ prompt = 'Enter URL: ', default = 'http://localhost:3000' }, function(url)
                  if url == nil or url == '' then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = 'inspector',
            sourceMaps = true,
            userDataDir = false,
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },

            -- From https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/plugins/dap.lua
            -- To test how it behaves
            rootPath = '${workspaceFolder}',
            cwd = '${workspaceFolder}',
            console = 'integratedTerminal',
            internalConsoleOptions = 'neverOpen',
            sourceMapPathOverrides = {
              ['./*'] = '${workspaceFolder}/src/*',
            },
          },
          {
            name = '----- ↑ launch.json configs (if available) ↑ -----',
            type = '',
            request = 'launch',
          },
        }
      end

      require('dapui').setup {
        floating = { border = 'single' },
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.25 },
              { id = 'breakpoints', size = 0.25 },
              { id = 'stacks', size = 0.25 },
              { id = 'watches', size = 0.25 },
            },
            position = 'left',
            size = 40,
          },
          {
            elements = {
              { id = 'console', size = 0.6 },
              { id = 'repl', size = 0.4 },
            },
            position = 'bottom',
            size = 10,
          },
        },
      }
      local dapui = require 'dapui'
      vim.keymap.set('n', '<leader>t?', function()
        require('dapui').eval(nil, { enter = true })
      end, { desc = 'DAP: Eval under cursor' })
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP: Toggle [B]reakpoint' })
      vim.keymap.set('n', '<leader>dC', dap.run_to_cursor, { desc = 'DAP: Run [C]ursor' })
      vim.keymap.set('n', '<leader>dj', dap.down, { desc = 'DAP: Go down' })
      vim.keymap.set('n', '<leader>dk', dap.up, { desc = 'DAP: Go up' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'DAP: Continue' })
      vim.keymap.set('n', '<leader>dp', dap.pause, { desc = 'DAP: Pause' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'DAP: Step Into' })
      vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'DAP: Step Over' })
      vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'DAP: Step Out' })
      vim.keymap.set('n', '<leader>ds', dap.session, { desc = 'DAP: Session' })
      vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'DAP: Terminate' })
      vim.keymap.set('n', '<leader>dr', dap.repl.toggle, { desc = 'DAP: Toggle REPL' })
      vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'DAP: Toggle [U]i' })
      vim.keymap.set('n', '<leader>dw', require('dap.ui.widgets').hover, { desc = 'DAP: Widget - Hover' })
      vim.keymap.set('n', '<leader>td', function()
        require('neotest').run.run { strategy = 'dap' }
      end, { desc = 'Neotest: Debug nearest' })

      vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open { reset = true }
      end
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
    end,
  },
}
