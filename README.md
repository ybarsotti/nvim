# 🚀 Modern Neovim Configuration

A comprehensive, AI-enhanced Neovim configuration built with modern Lua architecture, featuring intelligent code assistance, seamless development workflows, and extensive customization.

## ✨ Key Features

- **🤖 Multi-Provider AI Integration**: CodeCompanion with GitHub Copilot (Claude Sonnet 4, GPT-5) + local Ollama models
- **🔍 Semantic Code Search**: VectorCode integration for intelligent code understanding
- **📦 Modern Plugin Management**: Lazy.nvim with optimized loading and performance
- **🛠️ Comprehensive LSP**: Support for 10+ languages with Mason auto-installation
- **🎨 Beautiful UI**: Custom themes, statusline, and dashboard with modern aesthetics
- **⚡ Performance Optimized**: Fast startup times with lazy loading and efficient configurations

## 🏗️ Architecture Overview

```
├── init.lua                 # Main entry point
├── lua/
│   ├── config/             # Core configuration
│   │   ├── options.lua     # Vim settings & options
│   │   ├── keymaps.lua     # Global key mappings
│   │   ├── lazy-plugins.lua # Plugin loader
│   │   └── ...
│   └── plugins/            # Plugin configurations
│       ├── ai.lua          # AI integrations (CodeCompanion, Copilot)
│       ├── lsp.lua         # Language server setup
│       ├── telescope.lua   # Fuzzy finder
│       └── ...
```

## 📋 Prerequisites

- **Neovim 0.9+** (required for modern Lua features)
- **Git** (for plugin management)
- **Node.js** (for some language servers)
- **Python 3** (for Python tooling)
- **mise** (optional, for tool version management)

## 🚀 Installation

### Linux and macOS

```bash
# Backup existing config (optional)
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null

# Clone configuration
git clone git@github.com:ybarsotti/nvim-config.git ~/.config/nvim

# Start Neovim (plugins will auto-install)
nvim
```

### Windows

<details><summary>PowerShell</summary>

```powershell
# Backup existing config (optional)
Rename-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak -ErrorAction SilentlyContinue

# Clone configuration
git clone git@github.com:ybarsotti/nvim-config.git "$env:LOCALAPPDATA\nvim"

# Start Neovim
nvim
```

</details>

<details><summary>Command Prompt</summary>

```cmd
# Backup existing config (optional)
ren %LOCALAPPDATA%\nvim %LOCALAPPDATA%\nvim.bak

# Clone configuration
git clone git@github.com:ybarsotti/nvim-config.git "%LOCALAPPDATA%\nvim"

# Start Neovim
nvim
```

</details>

## 🔧 Post-Installation Setup

### 1. Plugin Installation
On first launch, plugins will automatically install via Lazy.nvim:
```
:Lazy
```

### 2. LSP Servers & Tools
Language servers and formatters auto-install via Mason:
```
:Mason
```

### 3. AI Integration Setup
- **GitHub Copilot**: Sign in with `:Copilot auth`
- **Local Models**: Configure Ollama endpoint in `lua/plugins/ai.lua`
- **MCP Servers**: Configure in `~/.config/mcphub/servers.json`

## 🎯 Language Support

| Language       | LSP Server | Formatter | Linter    | AI Support |
|----------------|------------|-----------|-----------|------------|
| TypeScript/JS  | ts_ls      | Prettier  | ESLint    | ✅ |
| Go             | gopls      | gofumpt   | golint    | ✅ |
| Python         | pyright    | ruff      | ruff      | ✅ |
| Lua            | lua_ls     | stylua    | luacheck  | ✅ |
| Rust           | rust_analyzer | rustfmt | clippy   | ✅ |
| C/C++          | clangd     | clang-format | cpplint | ✅ |
| Docker         | dockerls   | -         | hadolint  | ✅ |
| YAML/JSON      | yamlls/jsonls | prettier | -       | ✅ |

## ⌨️ Complete Keymap Reference

### 🎯 Core Navigation & Editing
| Key | Mode | Description |
|-----|------|-------------|
| `<Esc>` | n | Clear search highlights |
| `<C-s>` | n | Save file |
| `<C-q>` | n | Quit file |
| `<C-d>` / `<C-u>` | n | Scroll down/up and center screen |
| `n` / `N` | n | Find next/previous and center |
| `x` | n, v | Delete char without saving to register |

### 🪟 Window & Buffer Management
| Key | Mode | Description |
|-----|------|-------------|
| `<Tab>` / `<S-Tab>` | n | Next/previous buffer |
| `<leader>wx` | n | Close buffer |
| `<leader>wX` | n | Close all buffers |
| `<leader>wo` | n | Close all except current |
| `<leader>wv` / `<leader>wh` | n | Split window vertically/horizontally |
| `<leader>we` | n | Make split windows equal |
| `<C-hjkl>` | n | Navigate between windows |
| `<Up>/<Down>/<Left>/<Right>` | n | Resize windows |

### 🔍 Telescope (Search & Navigation)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>sh` | n | Search Help |
| `<leader>sk` | n | Search Keymaps |
| `<leader>sf` | n | Search Files |
| `<leader>sw` | n | Search current Word |
| `<leader>sg` | n | Search by Grep |
| `<leader>sb` | n | Search existing Buffers |
| `<leader>sd` | n | Search Diagnostics |
| `<leader>sr` | n | Search Resume |
| `<leader>s.` | n | Search Recent Files |
| `<leader>/` | n | Fuzzily search in current buffer |

### 🧠 LSP (Language Server Protocol)
| Key | Mode | Description |
|-----|------|-------------|
| `gd` | n | Go to Definition |
| `gD` | n | Go to Declaration |
| `gO` | n | Get document symbols |
| `grn` | n | Rename symbol |
| `gra` | n | Code Action |
| `grr` | n | Find References |
| `gri` | n | Go to Implementation |
| `grt` | n | Go to Type Definition |
| `<leader>cr` | n | Code Rename |
| `<leader>ca` | n, x | Code Action |
| `<leader>ch` | n | Toggle Code Hints |
| `<leader>cds` | n | Code Document Symbols |
| `<leader>cws` | n | Code Workspace Symbols |

### 🤖 AI Assistance (CodeCompanion & MCPHub)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>aa` | n, v | CodeCompanion Actions |
| `<leader>ac` | n, v | CodeCompanion Toggle Chat |
| `<leader>ai` | n, v | CodeCompanion Inline mode |
| `<leader>aA` | v | Add selected into chat buffer |
| `<leader>ad` | v | Write documentation for code |
| `<leader>ar` | v | Refactor code |
| `<leader>aR` | v | Review code |
| `<leader>an` | v | Better naming suggestions |
| `<leader>ah` | n | CodeCompanion History |
| `<leader>am` | n | MCPHub Open |

### 📁 File Explorer (Neo-tree)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>e` | n | Toggle Neo-tree |
| `<leader>ge` | n | Open git status |
| `\` | n | Reveal current file in tree |

### 🌿 Git Operations
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>gl` | n | LazyGit |
| `<leader>gd` / `<leader>gx` | n | Git Diff Open/Close |
| `]c` / `[c` | n | Next/previous git change |
| `gh` / `gH` | n | Apply/Reset hunks |
| `<leader>gs` / `<leader>gr` | n, v | Stage/reset hunk |
| `<leader>gS` / `<leader>gR` | n | Stage/reset buffer |
| `<leader>gu` | n | Undo stage hunk |
| `<leader>gp` | n | Preview hunk |
| `<leader>gb` | n | Toggle blame line |

### 🧪 Testing (Neotest)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>tt` | n | Run File |
| `<leader>tT` | n | Run All Test Files |
| `<leader>tr` | n | Run Nearest |
| `<leader>tl` | n | Run Last |
| `<leader>ts` | n | Toggle Summary |
| `<leader>to` / `<leader>tO` | n | Show/Toggle Output |
| `<leader>tS` | n | Stop tests |
| `<leader>tw` | n | Toggle Watch |
| `<leader>td` | n | Debug Nearest |

### 🐛 Debugging (DAP)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>db` | n | Toggle Breakpoint |
| `<leader>dc` | n | Continue |
| `<leader>di` / `<leader>do` / `<leader>dO` | n | Step Into/Over/Out |
| `<leader>dr` | n | Toggle REPL |
| `<leader>du` | n | Toggle UI |
| `<leader>dt` | n | Terminate |
| `<leader>dp` | n | Pause |

### 📋 Diagnostics (Trouble)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>qx` | n | Diagnostics |
| `<leader>qX` | n | Buffer Diagnostics |
| `<leader>qs` | n | Symbols |
| `<leader>ql` | n | LSP Definitions/References |
| `<leader>qL` / `<leader>qQ` | n | Location/Quickfix List |

### 🎯 Code Navigation & Utilities
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>cm` | n | Harpoon Mark file |
| `<leader>1` - `<leader>4` | n | Go to Harpoon file 1-4 |
| `<leader>ce` | n | Harpoon window |
| `<leader>cz` | n | Toggle code outline |
| `<leader>cf` | n, v | Format file/range |
| `<leader>cF` | n | Trigger linting |

### 🔄 Find & Replace (GrugFar)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>RG` | n | Open find replace window |
| `<leader>Rg` | n | Limit to current file |
| `<leader>Rw` | n | Search word under cursor |
| `<leader>Rs` | v | Search selection |

### 💻 Terminal (FloaTerm)
| Key | Mode | Description |
|-----|------|-------------|
| `<F7>` | n | New terminal |
| `<F8>` / `<F9>` | n | Previous/Next terminal |
| `<F12>` | n | Toggle terminal |
| `<F5>` | n, i | Run Python file (Python only) |

### 📝 Session Management
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>wr` | n | Search sessions |
| `<leader>wS` | n | Save session |
| `<leader>wa` | n | Toggle autosave |
| `<leader>wd` / `<leader>wD` | n | Purge/Delete sessions |

### 🛠️ Utilities & Miscellaneous
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>cs` / `<leader>cS` | x | Code screenshot to clipboard/file |
| `<leader>y` | n | Yazi file manager |
| `<leader>p` | n | Paste image from clipboard |
| `<leader>zz` / `<leader>zZ` | n | Zen mode |

### ✏️ Visual Mode Enhancements
| Key | Mode | Description |
|-----|------|-------------|
| `<` / `>` | v | Indent left/right (stay in visual) |
| `p` | v | Paste and keep yanked content |

### 🎨 Surround Operations (Mini.surround)
| Key | Mode | Description |
|-----|------|-------------|
| `sa` | n, v | Add surrounding |
| `sd` / `sr` | n | Delete/Replace surrounding |
| `sf` / `sF` | n | Find right/left surrounding |
| `sh` | n | Highlight surrounding |

### 🎪 Comment Operations
| Key | Mode | Description |
|-----|------|-------------|
| `gc` | n, v | Toggle comment |
| `gcc` | n | Comment line |

### 📝 Key Pattern Groups:
- **`<leader>a*`** - AI and assistance functions
- **`<leader>c*`** - Code-related actions
- **`<leader>d*`** - Debugging operations
- **`<leader>g*`** - Git operations
- **`<leader>q*`** - Diagnostics and quickfix
- **`<leader>s*`** - Search operations
- **`<leader>t*`** - Testing operations
- **`<leader>w*`** - Window, buffer, and session management
- **`<leader>R*`** - Find and replace

> **💡 Pro Tip**: Press `<leader>` and wait to see all available keybindings with which-key!

## 🎛️ Customization

### Changing Themes
Themes are configured in `lua/plugins/theme/`. To switch themes:
1. Edit the active theme in the theme directory
2. Restart Neovim or `:source %`

### Adding Language Support
1. Add LSP server to `servers` table in `lua/plugins/lsp.lua`
2. Add formatter in `lua/plugins/autoformatting.lua`
3. Add linter in `lua/plugins/linter.lua`
4. Restart Neovim and run `:Mason` to install tools

### Custom AI Models
To add custom Ollama models:
```lua
-- In lua/plugins/ai.lua
schema = {
  model = {
    default = 'your-model-name',
  },
}
```

## 🛠️ Troubleshooting

### Common Issues

**Plugins not loading:**
```
:Lazy sync
:Lazy clean
```

**LSP not working:**
```
:LspInfo
:Mason
```

**AI features not available:**
- Check `:Copilot status` for GitHub Copilot
- Verify Ollama is running on localhost:8080
- Check MCP servers in `:MCPHub`

### Health Check
```
:checkhealth
:checkhealth nvim
:checkhealth telescope
```

## 🎯 Vim Motions & Advanced Tips

### Text Objects
| Motion | Description |
|--------|--------------|
| `vib`/`viB` | Select within parentheses/braces |
| `vit` | Select within XML/HTML tags |
| `vi"` | Select within quotes |
| `va{motion}` | Select around (including delimiters) |

### Advanced Editing
| Command | Description |
|---------|-------------|
| `<C-v>` → `I` → edit → `<Esc>` | Multi-line editing |
| `gg=G` | Re-indent entire file |
| `~` / `g~{motion}` | Toggle case |
| `gx` | Open URL under cursor |
| `gf` | Open file under cursor |
| `m{letter}` → `'{letter}` | Mark and jump to location |
| `:%s/old/new/gc` | Interactive find/replace |
| `"{register}y` | Yank to specific register |

### Window Management
| Key | Action |
|-----|--------|
| `<C-w>v` | Vertical split |
| `<C-w>s` | Horizontal split |
| `<C-hjkl>` | Navigate windows |
| `<leader>we` | Equalize windows |

## 📚 Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lua Guide for Neovim](https://github.com/nanotee/nvim-lua-guide)
- [Lazy.nvim Documentation](https://github.com/folke/lazy.nvim)
- [Mason.nvim](https://github.com/williamboman/mason.nvim)

