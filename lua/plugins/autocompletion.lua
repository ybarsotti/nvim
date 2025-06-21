local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match '^%s*$' == nil
end

return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'
      luasnip.config.setup {}

      local kind_icons = {
        Class = ' ',
        Color = ' ',
        Constant = ' ',
        Constructor = ' ',
        Enum = ' ',
        EnumMember = ' ',
        Event = ' ',
        Field = ' ',
        File = ' ',
        Folder = ' ',
        Function = ' ',
        Interface = ' ',
        Keyword = ' ',
        Method = ' ',
        Module = ' ',
        Operator = ' ',
        Property = ' ',
        Reference = ' ',
        Snippet = ' ',
        Struct = ' ',
        Text = ' ',
        TypeParameter = ' ',
        Unit = ' ',
        Value = ' ',
        Variable = ' ',
        Copilot = '',
      }

      local source_names = {
        nvim_lsp = 'LSP',
        nvim_lua = 'Lua',
        buffer = 'Buffer',
        path = 'Path',
        luasnip = 'Snippet',
        copilot = 'Copilot',
        cmdline = 'Cmd',
      }

      local select_next_item = function(fallback)
        if cmp.visible() then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end

      local select_prev_item = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-t>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
          ['<C-j>'] = cmp.mapping(select_next_item, { 'i', 's' }),
          ['<C-k>'] = cmp.mapping(select_prev_item, { 'i', 's' }),
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'codecompanion', group_index = 2 },
          { name = 'copilot', group_index = 2 },
          { name = 'nvim_lsp', group_index = 2 },
          { name = 'luasnip', group_index = 2 },
          { name = 'buffer', group_index = 2 },
          { name = 'emoji', group_index = 2 },
          { name = 'path', group_index = 2 },
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            require('copilot_cmp.comparators').prioritize,

            -- Below is the default comparitor list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = lspkind.cmp_format {
            mode = 'symbol_text',
            symbol_map = kind_icons,
            maxwidth = {
              menu = 80,
              abbr = 80,
            },
            ellipsis_char = '...',
            show_labelDetails = true,
            before = function(entry, vim_item)
              vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
              vim_item.dateMDYenu = source_names[entry.source.name]
              return vim_item
            end,
          },
        },
      }
    end,
  },
  -- Transforms AI into a auto-completion source for nvim-cmp
  {
    'zbirenbaum/copilot-cmp',
    config = function()
      require('copilot_cmp').setup()
    end,
    dependencies = {
      'zbirenbaum/copilot.lua',
    },
  },
}
