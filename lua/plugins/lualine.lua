return {
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      local mode = {
        'mode',
        fmt = function(str)
          return ' ' .. str
          -- return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
        end,
      }

      local filename = {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
      }

      local hide_in_width = function()
        return vim.fn.winwidth(0) > 100
      end

      local diagnostics = {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        sections = { 'error', 'warn' },
        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        colored = true,
        update_in_insert = false,
        always_visible = false,
        cond = hide_in_width,
      }

      local diff = {
        'diff',
        colored = true,
        symbols = { added = ' ', modified = ' ', removed = ' ' }, -- changes diff symbols
        cond = hide_in_width,
      }

      local copilot = {
        'copilot',
        symbols = {
          spinners = 'bouncing_ball',
        },
        show_colors = true,
      }

      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto', -- Set theme based on environment variable
          -- Some useful glyphs:
          -- https://www.nerdfonts.com/cheat-sheet
          --        
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          disabled_filetypes = { 'alpha', 'neo-tree' },
          always_divide_middle = true,
        },
        sections = {
          lualine_a = { mode },
          lualine_b = { 'branch', diff, diagnostics },
          lualine_c = {
            filename,
            -- vim.tbl_extend('force', filename , {
            --   symbols.get,
            --   cond = symbols.has,
            -- }),
          },
          lualine_x = {
            copilot,
            {
              function()
                return vim.g.mcphub_status or ''
              end,
              cond = function()
                return vim.g.mcphub_status ~= nil and vim.g.mcphub_status ~= ''
              end,
            },
            {
              function()
                return require('vectorcode.integrations').lualine()[1]()
              end,
              cond = function()
                if package.loaded['vectorcode'] == nil then
                  return false
                else
                  return require('vectorcode.integrations').lualine().cond()
                end
              end,
            },
            'lsp_status',
            { 'filetype', cond = hide_in_width },
            { 'encoding', cond = hide_in_width },
          },
          lualine_y = {
            'location',
          },
          lualine_z = { 'progress' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = { { 'location', padding = 0 } },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { 'fugitive' },
      }
    end,
  },
  { 'AndreM222/copilot-lualine' },
}
