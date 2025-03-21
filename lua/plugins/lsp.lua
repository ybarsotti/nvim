return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },

    -- Allows extra capabilities provided by nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('Sotti', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>ctd', require('telescope.builtin').lsp_type_definitions, '[C]ode [T]ype [D]efinition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>cds', require('telescope.builtin').lsp_document_symbols, '[C]ode [D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('<leader>cws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[C]ode [W]orkspace [S]ymbols')

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('sotti', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('sotti', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'sotti', buffer = event2.buf }
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>ch', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, 'Toggle [C]ode [H]ints')
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    local servers = {
      ts_ls = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          client.server_capabilities.completionProvider = {
            triggerCharacters = { '.', '"', "'", '`', '/', '@', '<' },
          }

          vim.keymap.set('i', '<C-S>', vim.lsp.buf.completion, { buffer = bufnr })
        end,
      },
      clangd = {},
      gopls = {
        settings = {
          gofumpt = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            fieldalignment = true,
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
          semanticTokens = true,
        },
      },
      pyright = {
        filetypes = { 'python' },
      },
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      cssls = {},
      dockerls = {},
      jsonls = {},
      yamlls = {
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        },
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            schemaStore = {
              enable = true,
              url = 'https://www.schemastore.org/api/json/catalog.json',
            },
            format = { enabled = false },
            -- enabling this conflicts between Kubernetes resources, kustomization.yaml, and Helmreleases
            validate = false,
            schemas = {
              kubernetes = '*.yaml',
              ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*',
              ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
              ['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = 'azure-pipelines*.{yml,yaml}',
              ['https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/tasks'] = 'roles/tasks/*.{yml,yaml}',
              ['https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook'] = '*play*.{yml,yaml}',
              ['http://json.schemastore.org/prettierrc'] = '.prettierrc.{yml,yaml}',
              ['http://json.schemastore.org/kustomization'] = 'kustomization.{yml,yaml}',
              ['http://json.schemastore.org/chart'] = 'Chart.{yml,yaml}',
              ['https://json.schemastore.org/dependabot-v2'] = '.github/dependabot.{yml,yaml}',
              ['https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json'] = '*gitlab-ci*.{yml,yaml}',
              ['https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json'] = '*api*.{yml,yaml}',
              ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = '*docker-compose*.{yml,yaml}',
              ['https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json'] = '*flow*.{yml,yaml}',
            },
          },
        },
      },
      lua_ls = {
        settings = {
          format = {
            enable = false, -- let conform handle the formatting
          },
          telemetry = { enable = false },
          hint = { enable = true },
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = { globals = { 'vim' } },
            workspace = {
              checkThirdParty = false,
            },
            codeLens = {
              enable = true,
            },
            doc = {
              privateName = { '^_' },
            },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = 'Disable',
              semicolon = 'Disable',
              arrayIndex = 'Disable',
            },
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu.
    require('mason').setup()
    require('ufo').setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
      'prettier',
      'eslint_d',
      'pylint',
      'cpplint',
      'ruff',
      'mypy',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
} -- LSP Plugins
