return {
  'rmagatti/auto-session',
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { '<leader>wr', '<cmd>SessionSearch<CR>', desc = 'Autosession: Session search' },
    { '<leader>wS', '<cmd>SessionSave<CR>', desc = 'Autosession: Save session' },
    { '<leader>wa', '<cmd>SessionToggleAutoSave<CR>', desc = 'Autosession: Toggle autosave' },
    { '<leader>wd', '<cmd>SessionPurgeOrphaned<CR>', desc = 'Autosession: Purge orphaned sessions' },
    { '<leader>wD', '<cmd>SessionDelete<CR>', desc = 'Autosession: [D]elete session' },
  },
  opts = {
    bypass_save_filetypes = { 'alpha', 'dashboard' },
    auto_restore_last_session = false,
    auto_restore = false,
    use_git_branch = true,
    show_auto_restore_notif = true,
  },
}
