return {

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        nix = { "alejandra" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      {
        "artemave/workspace-diagnostics.nvim",
      },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.diagnostic.config({
        underline = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        inlay_hints = {
          enabled = true,
          exclude = {},
        },
        codelens = {
          enabled = false,
        },
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
            didChangeWatchedFiles = true,
          },
        },
      })

      require("lspconfig").lua_ls.setup({})

      if vim.fn.executable("lua-language-server") == 1 then
        require("lspconfig").lua_ls.setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
          end,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
                fileOperations = {
                  didRename = true,
                  willRename = true,
                },
                didChangeWatchedFiles = true,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              telemetry = {
                enable = false,
              },
            },
          },
        })
        -- else
        -- vim.notify("lua-language-server not found: Lua LSP will not be configured.", vim.log.levels.INFO)
      end

      if vim.fn.executable("nixd") == 1 then
        require("lspconfig").nixd.setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
          end,
        })
        -- else
        -- vim.notify("nixd not found: Nix LSP will not be configured.", vim.log.levels.INFO)
      end
    end,
  },
}