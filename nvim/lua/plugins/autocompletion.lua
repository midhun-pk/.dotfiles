vim.pack.add({
  {
    src = "https://github.com/Saghen/blink.cmp",
    version = vim.version.range("*"),
  },
})

require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "hide" },
		["<C-y>"] = { "accept", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = { menu = { auto_show = true } },
	sources = { default = { "lsp", "path", "buffer" } },

	fuzzy = {
		implementation = "prefer_rust",
		prebuilt_binaries = { download = true },
	},
})
