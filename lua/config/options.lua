-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
vim.opt.completeopt:append("popup")

vim.opt.number = true
vim.opt.relativenumber = true

-- Search
vim.opt.hlsearch = true  -- Highlight search results
vim.opt.incsearch = true -- Incremental search

-- Better folding
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99
vim.opt.foldenable = false  -- Start with folds open

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- For the markdown plugin
vim.g.mkdp_filetypes = { 'markdown' }
vim.g.mkdp_auto_start = 1

-- Theme
vim.opt.termguicolors = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 15

-- Spaces after indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Remove text wrap
vim.opt.wrap = false

-- Change tab to space
vim.opt.expandtab = true

-- Added to improve exp with rmagatti/auto-session
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-- Enable blinking cursor
vim.opt.guicursor = 'n-v-sm:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,c-ci-ve:ver20,r-cr-o:hor20,i:ver25-blinkon500-blinkoff500'

-- Performance improvements
vim.opt.ttyfast = true

-- Better diff mode
vim.opt.diffopt:append('vertical,algorithm:patience')

-- Better backup and swap handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Spell checking (useful for comments and docs)
vim.opt.spelllang = 'en_us'

-- Better command line completion
vim.opt.history = 1000
vim.opt.wildmenu = true

-- Tool version management integration
local function setup_tool_integrations()
  -- mise integration for go, zig, and other languages
  if vim.fn.executable('mise') == 1 then
    -- Add mise shims to PATH
    local mise_shims = vim.fn.expand('~/.local/share/mise/shims')
    if vim.fn.isdirectory(mise_shims) == 1 then
      vim.env.PATH = mise_shims .. ':' .. vim.env.PATH
    end
    
    -- Auto-execute mise hook on directory change
    vim.api.nvim_create_autocmd('DirChanged', {
      callback = function()
        vim.fn.system('mise hook-env')
      end,
    })
  end

  -- nvm integration for Node.js projects
  local nvm_dir = os.getenv('NVM_DIR') or (os.getenv('HOME') .. '/.nvm')
  if vim.fn.isdirectory(nvm_dir) == 1 then
    local function activate_nvm()
      local cwd = vim.fn.getcwd()
      if vim.fn.filereadable(cwd .. '/.nvmrc') == 1 then
        local handle = io.popen('bash -c "source ' .. nvm_dir .. '/nvm.sh && nvm use 2>/dev/null && which node"')
        if handle then
          local node_path = handle:read("*a"):gsub("\n$", "")
          handle:close()
          if node_path and node_path ~= "" then
            local node_dir = vim.fn.fnamemodify(node_path, ':h')
            vim.env.PATH = node_dir .. ':' .. vim.env.PATH
          end
        end
      end
    end
    
    -- Activate nvm on startup and directory change
    activate_nvm()
    vim.api.nvim_create_autocmd({'DirChanged', 'VimEnter'}, {
      callback = activate_nvm,
    })
  end

  -- uv integration for Python projects
  if vim.fn.executable('uv') == 1 then
    local function activate_uv()
      local cwd = vim.fn.getcwd()
      if vim.fn.filereadable(cwd .. '/pyproject.toml') == 1 then
        local handle = io.popen('cd ' .. cwd .. ' && uv run python -c "import sys; print(sys.executable)" 2>/dev/null')
        if handle then
          local python_path = handle:read("*a"):gsub("\n$", "")
          handle:close()
          if python_path and python_path ~= "" then
            local python_dir = vim.fn.fnamemodify(python_path, ':h')
            vim.env.PATH = python_dir .. ':' .. vim.env.PATH
          end
        end
      end
    end
    
    -- Activate uv on startup and directory change
    activate_uv()
    vim.api.nvim_create_autocmd({'DirChanged', 'VimEnter'}, {
      callback = activate_uv,
    })
  end
end

setup_tool_integrations()

-- vim: ts=2 sts=2 sw=2 et
