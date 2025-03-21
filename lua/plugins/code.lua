local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' 󰁂 %d ------------------------------'):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'MoreMsg' })
    return newVirtText
end

return {
  { -- Easy Find Replace
    'MagicDuck/grug-far.nvim',
    cmd = 'GrugFar',
    opts = {},
    keys = {
      -- stylua: ignore start
      { "<leader>RG", "<cmd>GrugFar<cr>", desc = "Open find replace window [GrugFar]" },
      { "<leader>Rg", "<cmd>lua require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })<cr>", desc = "Open (Limit to current file) [GrugFar]"},
      { "<leader>Rw", "<cmd>lua require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })<cr>", desc = "Search word under cursor [GrugFar]", },
      { "<leader>Rs", mode = "v", "<cmd>lua require('grug-far').with_visual_selection({ prefills = { paths = vim.fn.expand('%') } })<cr>", desc = "Search selection [GrugFar]", },
      -- stylua: ignore end
    },
  },
  {
    'kevinhwang91/nvim-ufo',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'kevinhwang91/promise-async', { 'neoclide/coc.nvim', branch = 'master', run = 'yarn install --frozen-lockfile' } },
    config = function()
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = "Ufo: Open all folds"})
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = "Ufo: Close all folds"})
      vim.keymap.set('n', 'zK', function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.fn.CocActionAsync 'definitionHover'
          vim.lsp.buf.hover()
        end
      end)

      require('ufo').setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
        fold_virt_text_handler = handler,
      }
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      local harpoon_extensions = require 'harpoon.extensions'
      local conf = require('telescope.config').values
      harpoon.setup {}
      harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader>cm', function()
        harpoon:list():add()
      end, { desc = 'Harpoon: [C]ode [M]ark' })
      vim.keymap.set('n', '<leader>1', function()
        harpoon:list():select(1)
      end, { desc = 'Harpoon: Go to file 1' })
      vim.keymap.set('n', '<leader>2', function()
        harpoon:list():select(2)
      end, { desc = 'Harpoon: Go to file 2' })
      vim.keymap.set('n', '<leader>3', function()
        harpoon:list():select(3)
      end, { desc = 'Harpoon: Go to file 3' })
      vim.keymap.set('n', '<leader>4', function()
        harpoon:list():select(4)
      end, { desc = 'Harpoon: Go to file 4' })
      vim.keymap.set('n', '<leader>ce', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Harpoon: Open window' })
    end,
  },
  { -- Improve commenting frontend files
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      -- import comment plugin safely
      local comment = require 'Comment'

      local ts_context_commentstring = require 'ts_context_commentstring.integrations.comment_nvim'

      -- enable comment
      comment.setup {
        -- for commenting tsx, jsx, svelte, html files
        pre_hook = ts_context_commentstring.create_pre_hook(),
      }
    end,
  },
}
