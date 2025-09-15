return {
  {
    'sindrets/diffview.nvim',
    lazy = true,
    keys = {
      { '<leader>gd', '<cmd>:DiffviewOpen<cr>', desc = 'DiffView: [G]it [D]iff Open' },
      { '<leader>gx', '<cmd>:DiffviewClose<cr>', desc = 'DiffView: [G]it Diff Close' },
    },
  },
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>gl', '<cmd>LazyGit<cr>', desc = '[G]it[L]azy' },
    },
  },
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>gs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>gr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode  
        map('n', 'gh', gitsigns.stage_hunk, { desc = 'Apply hunks' })
        map('n', 'gH', gitsigns.reset_hunk, { desc = 'Reset hunks' })
        map('n', '<leader>gs', gitsigns.stage_hunk, { desc = '[g]it [s]tage hunk' })
        map('n', '<leader>gr', gitsigns.reset_hunk, { desc = '[g]it [r]eset hunk' })
        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = '[g]it [S]tage buffer' })
        map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = '[g]it [u]ndo stage hunk' })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = '[g]it [R]eset buffer' })
        map('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[g]it [p]review hunk' })
        map('n', '<leader>gb', gitsigns.toggle_current_line_blame, { desc = '[g]it [b]lame line' })
        -- map('n', '<leader>gd', gitsigns.diffthis, { desc = '[g]it [d]iff against index' })
        -- map('n', '<leader>gD', function()
        --   gitsigns.diffthis '@'
        -- end, { desc = '[g]it [D]iff against last commit' })
        -- Toggles
        -- map('n', '<leader>gb', gitsigns.toggle_current_line_blame, { desc = 'Toggle [g]it show [b]lame line' })
        -- map('n', '<leader>gD', gitsigns.toggle_deleted, { desc = 'Toggle [g]it show [D]eleted' })
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
