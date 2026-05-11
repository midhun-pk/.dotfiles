vim.pack.add({
  { src = "https://www.github.com/neovim/nvim-lspconfig" },
  -- Automatically install LSPs and related tools to stdpath for Neovim
  { src = "https://www.github.com/mason-org/mason.nvim" },
  -- mason-lspconfig:
  -- - Bridges the gap between LSP config names (e.g. "lua_ls") and actual Mason package names (e.g. "lua-language-server").
  -- - Used here only to allow specifying language servers by their LSP name (like "lua_ls") in `ensure_installed`.
  -- - It does not auto-configure servers — we use vim.lsp.config() + vim.lsp.enable() explicitly for full control.
  { src = "https://www.github.com/mason-org/mason-lspconfig.nvim" },
  -- mason-tool-installer:
  -- - Installs LSPs, linters, formatters, etc. by their Mason package name.
  -- - We use it to ensure all desired tools are present.
  -- - The `ensure_installed` list works with mason-lspconfig to resolve LSP names like "lua_ls".
  { src = "https://www.github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  -- Useful status updates for LSP.
  { src = 'https://www.github.com/j-hui/fidget.nvim' },
})

require("mason").setup()
require("mason-lspconfig").setup()
require("fidget").setup({
  notification = {
    window = {
      winblend = 0,
    },
  },
})

local diagnostic_signs = {
	Error = " ",
	Warn = " ",
	Hint = "",
	Info = "",
}

vim.diagnostic.config({
	virtual_text = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "gd", function()
		require("fzf-lua").lsp_definitions({ jump1 = true })
	end, opts)

	vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)

	vim.keymap.set("n", "<leader>gS", function()
		vim.cmd("vsplit")
		vim.lsp.buf.definition()
	end, opts)

	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

  vim.keymap.set("n", "<leader>td", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  end, { desc = "Toggle diagnostics" })

  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, { desc = "Next diagnostic + float" })

  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, { desc = "Prev diagnostic + float" })

  vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

  vim.keymap.set("n", "<leader>dw", function()
    -- Find the diagnostic float and focus it
    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local config = vim.api.nvim_win_get_config(winid)
      if config.relative ~= "" then
        vim.api.nvim_set_current_win(winid)
        return
      end
    end
  end, { desc = "Jump into existing float" })

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

	vim.keymap.set("n", "<leader>ld", function()
		require("fzf-lua").lsp_definitions({ jump1 = true })
	end, opts)
	vim.keymap.set("n", "<leader>lr", function()
		require("fzf-lua").lsp_references()
	end, opts)
	vim.keymap.set("n", "<leader>lt", function()
		require("fzf-lua").lsp_typedefs()
	end, opts)
	vim.keymap.set("n", "<leader>ls", function()
		require("fzf-lua").lsp_document_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>lw", function()
		require("fzf-lua").lsp_workspace_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>li", function()
		require("fzf-lua").lsp_implementations()
	end, opts)

	if client:supports_method("textDocument/codeAction", bufnr) then
		vim.keymap.set("n", "<leader>oi", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true,
				bufnr = bufnr,
			})
			vim.defer_fn(function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, 50)
		end, opts)
	end
end

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })

vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Enable the following language servers
local servers = {
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
  vtsls = {
    settings = {
      typescript = {
        tsserver = {
          maxTsServerMemory = 4096,
        },
        preferences = {
          includePackageJsonAutoImports = "off",
        },
      },
      javascript = {
        preferences = {
          includePackageJsonAutoImports = "off",
        },
      },
      vtsls = {
        autoUseWorkspaceTsdk = true,
        enableMoveToFileCodeAction = false,
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
            entriesLimit = 10,
          },
        },
      },
    },

    on_attach = function(client, bufnr)
      -- 🔥 BIG performance win
      client.server_capabilities.semanticTokensProvider = nil

      -- optional (recommended if using prettier/biome)
      client.server_capabilities.documentFormattingProvider = false
    end,
  },
  lua_ls = {
    -- cmd = {...},
    -- filetypes { ...},
    -- capabilities = {},
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        workspace = {
          checkThirdParty = false,
          -- Tells lua_ls where to find all the Lua files that you have loaded
          -- for your neovim configuration.
          library = {
            '${3rd}/luv/library',
            unpack(vim.api.nvim_get_runtime_file('', true)),
          },
          -- If lua_ls is really slow on your computer, you can try this instead:
          -- library = { vim.env.VIMRUNTIME },
        },
        completion = {
          callSnippet = 'Replace',
        },
        telemetry = { enable = false },
        diagnostics = { globals = { 'vim' }, disable = { 'missing-fields' } },
      },
    },
  },
  dockerls = {},
  docker_compose_language_service = {},
  rust_analyzer = {
    ['rust-analyzer'] = {
      cargo = {
        features = 'all',
      },
      checkOnSave = true,
      check = {
        command = 'clippy',
      },
    },
  },
  jsonls = {},
  sqlls = {},
  yamlls = {},
  bashls = {},
  cssls = {},
  eslint = {
    settings = {
      run = "onSave",
      workingDirectory = { mode = "location" },
    },
  },
  biome = {},
  taplo = {}, -- toml files
}

-- You can add other tools here that you want Mason to install
-- for you, so that they are available from within Neovim.
local ensure_installed = vim.tbl_keys(servers or {})

require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for server, cfg in pairs(servers) do
  cfg.capabilities = vim.tbl_deep_extend('force', {}, capabilities, cfg.capabilities or {})
  vim.lsp.config(server, cfg)
  vim.lsp.enable(server)
end
