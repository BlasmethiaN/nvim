return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "j-hui/fidget.nvim", opts = {} },
      "saghen/blink.cmp", -- Auto-completion capabilities
    },
    lazy = false,
    config = function()
      -- 1. Diagnostics Global Config
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- 2. LspAttach: Keymaps & Autocmds
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
        callback = function(event)
          local buf = event.buf
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = buf, desc = "LSP: " .. desc })
          end

          local border = "rounded"

          vim.lsp.util.open_floating_preview = (function(orig)
            return function(contents, syntax, opts, ...)
              opts = opts or {}
              opts.border = opts.border or border
              return orig(contents, syntax, opts, ...)
            end
          end)(vim.lsp.util.open_floating_preview)

          vim.diagnostic.config({
            float = { border = border },
          })

          map("gd", vim.lsp.buf.definition, "Goto Definition")
          map("gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("gh", vim.lsp.buf.hover, "Hover Documentation")
          map("gs", vim.lsp.buf.signature_help, "Signature Help")
          map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

          map("grr", require("telescope.builtin").lsp_references, "Search References")
          map("gri", require("telescope.builtin").lsp_implementations, "Search Implementations")
          map("grd", require("telescope.builtin").lsp_definitions, "Search Definition (Preview)")
          map("grt", require("telescope.builtin").lsp_type_definitions, "Search Type Definition")

          map("gO", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
          map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

          map("<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, "Format Buffer")

          -- Highlight references under cursor
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method("textDocument/documentHighlight") then
            local highlight_augroup = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
          end

          -- Toggle inlay hints
          if client and client.supports_method("textDocument/inlayHint") then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }))
            end, "Toggle Inlay Hints")
          end
        end,
      })

      -- 3. Capabilities from blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- 4. Server Configuration List
      local servers = {
        bashls = {},
        cssls = {},
        html = {},
        pyright = {},
        rust_analyzer = {},
        terraformls = {},
        ts_ls = {},
        jsonls = {},
        yamlls = {},
        vimls = {},
        marksman = {},
        clangd = {},
        taplo = {},
        haskell_language_server = {},
        nil_ls = {},
        lua_ls = {
          settings = {
            Lua = { diagnostics = { globals = { "vim" } } },
          },
        },
      }

      for server, opts in pairs(servers) do
        opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})

        vim.lsp.config(server, opts)
        vim.lsp.enable(server)
      end
    end,
  },
}
