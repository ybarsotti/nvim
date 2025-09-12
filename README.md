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

## ⌨️ Essential Keybindings

### AI & Code Assistance
| Key | Action | Description |
|-----|--------|--------------|
| `<leader>aa` | CodeCompanion Actions | Open AI actions menu |
| `<leader>ac` | Toggle Chat | Open/close AI chat |
| `<leader>ai` | Inline AI | AI inline completion |
| `<leader>ar` | Refactor | AI-powered refactoring |
| `<leader>ad` | Document | Generate documentation |

### Navigation & Search
| Key | Action | Description |
|-----|--------|--------------|
| `<leader>ff` | Find Files | Telescope file finder |
| `<leader>fg` | Live Grep | Search in files |
| `<leader>fb` | Find Buffers | Switch between buffers |
| `<leader>e` | File Explorer | Toggle Neo-tree |
| `gd` | Go to Definition | Jump to symbol definition |
| `gr` | Find References | Find all references |

### LSP & Development
| Key | Action | Description |
|-----|--------|--------------|
| `<leader>ca` | Code Actions | Show available actions |
| `<leader>cr` | Rename Symbol | Rename under cursor |
| `<leader>ch` | Toggle Hints | Toggle inlay hints |
| `K` | Hover Info | Show documentation |

> **💡 Tip**: Press `<leader>` and wait to see all available keybindings with which-key!

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

