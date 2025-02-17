return {
  'rmagatti/auto-session',
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { '<leader>wr', '<cmd>SessionSearch<CR>', desc = 'Session search (autosession)' },
    { '<leader>wS', '<cmd>SessionSave<CR>', desc = 'Save session (autosession)' },
    { '<leader>wa', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave (autosession)' },
    { '<leader>wd', '<cmd>SessionPurgeOrphaned<CR>', desc = 'Purge orphaned sessions (autosession)' },
  },
  opts = {
    bypass_save_filetypes = { 'alpha', 'dashboard' },
    auto_restore_last_session = false,
    auto_restore = false,
    use_git_branch = true,
    show_auto_restore_notif = true,
  },
}
