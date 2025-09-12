# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive Neovim configuration built with modern Lua-based architecture, featuring extensive plugin management via lazy.nvim, AI integration with multiple providers, and a highly customized development environment focused on productivity and ergonomics.

## Architecture and Structure

### Core Configuration Structure
- **`init.lua`** - Main entry point that loads all configuration modules in sequence
- **`lua/config/`** - Core configuration modules loaded at startup
  - `options.lua` - Vim options and settings (leader key, UI, performance)
  - `keymaps.lua` - Global key mappings and navigation shortcuts
  - `autocommands.lua` - Vim autocommands and event handlers
  - `lazy-bootstrap.lua` - Lazy.nvim plugin manager installation
  - `lazy-plugins.lua` - Plugin loading configuration (`{ import = 'plugins' }`)
  - `copilot_controls.lua` - Copilot-specific controls and mappings
  - `cmp_highlights.lua` - Completion highlighting configuration

### Plugin Organization
Plugins are organized in **`lua/plugins/`** with each file representing a logical grouping:

#### Core Development Plugins
- **`lsp.lua`** - LSP configuration with Mason, multiple language servers (ts_ls, gopls, pyright, lua_ls, etc.), diagnostics, and keymaps
- **`autocompletion.lua`** - nvim-cmp with multiple sources and snippet support
- **`telescope.lua`** - Fuzzy finder with custom configurations and keymaps
- **`treesitter.lua`** - Syntax highlighting and parsing
- **`autoformatting.lua`** - Code formatting via conform.nvim
- **`linter.lua`** - Linting configuration

#### AI and Code Assistance
- **`ai.lua`** - Comprehensive AI integration including:
  - Minuet AI for completions
  - GitHub Copilot with custom configuration
  - VectorCode for semantic code search
  - MCPHub for MCP server integration
  - CodeCompanion with multiple adapters (local Ollama, Copilot) and extensive customization

#### UI and Navigation
- **`neo-tree.lua`** - File explorer with extensive customization
- **`bufferline.lua`** - Buffer/tab management
- **`lualine.lua`** - Status line configuration
- **`alpha.lua`** - Dashboard/start screen
- **`ui.lua`** - UI enhancements and appearance

#### Specialized Tools
- **`git.lua`** - Git integration (gitsigns, fugitive)
- **`test.lua`** - Testing framework integration
- **`code.lua`** - Code-specific utilities and enhancements
- **`misc.lua`** - Various utility plugins
- **`which-key.lua`** - Key mapping help system

### Key Configuration Patterns

#### Plugin Management
Uses lazy.nvim with modular loading - each plugin file returns a table that lazy.nvim imports. Plugins are lazy-loaded by default with specific event triggers, key mappings, or commands.

#### LSP Architecture
Centralized LSP configuration in `lsp.lua` with:
- Mason for automatic tool installation
- Server-specific configurations (especially comprehensive Go and TypeScript setups)
- Unified keymaps via LspAttach autocmd
- Telescope integration for definitions, references, and symbols

#### AI Integration Strategy
Multi-provider approach with local and remote models:
- Local: Ollama with unsloth/Devstral-Small-2505-GGUF
- Remote: GitHub Copilot with Claude Sonnet 4 (primary) and GPT-5
- MCP integration for extensibility
- VectorCode for semantic code understanding

## Common Commands and Workflows

### Plugin Management
- **`:Lazy`** - Open plugin manager interface
- **`:Lazy update`** - Update all plugins
- **`:Lazy sync`** - Sync plugin state
- **`:Mason`** - Manage LSP servers, formatters, and linters

### LSP and Development
- **`:LspInfo`** - Show LSP client status
- **`:LspRestart`** - Restart LSP servers
- **`<leader>ca`** - Code actions
- **`<leader>cr`** - Rename symbol
- **`gd`** - Go to definition (via Telescope)
- **`gr`** - Find references (via Telescope)

### AI Assistance
- **`<leader>aa`** - CodeCompanion actions menu
- **`<leader>ac`** - Toggle CodeCompanion chat
- **`<leader>ai`** - Open inline CodeCompanion
- **`<leader>am`** - Open MCPHub interface
- **`<leader>ad`** - Generate documentation for selected code
- **`<leader>ar`** - Refactor selected code

### File Navigation and Management
- **`<leader>ff`** - Find files (Telescope)
- **`<leader>fg`** - Live grep (Telescope)
- **`<leader>fb`** - Find buffers (Telescope)
- **`<leader>e`** - Toggle Neo-tree file explorer
- **`<Tab>`/`<S-Tab>`** - Navigate between buffers

### Code Formatting and Quality
- **`:Format`** - Format current buffer (conform.nvim)
- **`:Lint`** - Run linters on current buffer
- Code formatting happens automatically on save for most file types

## Development Environment

### Language Support
Comprehensive LSP support for:
- **TypeScript/JavaScript** (ts_ls) with completion triggers
- **Go** (gopls) with extensive settings for code lenses, hints, and analysis  
- **Python** (pyright) with type checking
- **Lua** (lua_ls) with Neovim-specific configuration
- **C/C++** (clangd)
- **Web Technologies** (html, css, json, yaml)
- **Docker** (dockerls)

### Tool Integration
- **mise** integration - PATH modification for tool version management
- **Git** integration with gitsigns and fugitive
- **Terminal** integration with floaterm
- **Session management** with auto-session

### Performance Optimizations
- Lazy loading for most plugins
- Efficient LSP configuration with capability management  
- Fast startup with deferred clipboard and UI setup
- Optimized diff algorithms and backup handling

## Key Bindings Philosophy

### Leader Key Patterns
- **`<leader>a*`** - AI and assistance functions
- **`<leader>c*`** - Code-related actions (LSP functions)
- **`<leader>f*`** - File and search operations (Telescope)
- **`<leader>g*`** - Git operations
- **`<leader>w*`** - Window and buffer management
- **`<leader>d*`** - Diagnostics and debugging

### Navigation Enhancements
- Scroll commands center the cursor (`<C-d>zz`, `<C-u>zz`)
- Search results center automatically (`nzzzv`)
- Arrow keys resize windows instead of navigation
- `<C-hjkl>` for window navigation

### Visual Mode Optimizations
- Indentation maintains visual selection (`<>` keys)
- Paste preserves yanked content (`p` doesn't replace register)
- Delete without register pollution (`x` key)