return {
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
        },
        messages = {
          enabled = true,
        },
        popupmenu = {
          enabled = true,
        },
        lsp = {
          progress = {
            enabled = true,
            view = "mini", -- Unobtrusive bottom-right corner
            throttle = 1000 / 30,
          },
          -- BUG: noice's LSP signature/hover handling steals focus while typing in insert mode
          -- Known issue: https://github.com/folke/noice.nvim/issues/1016
          -- Disabling noice's LSP handlers; using native LSP + blink.cmp instead
          signature = {
            enabled = false,
          },
          hover = {
            enabled = false,
          },
          -- Override markdown rendering so that **blink.cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
      })
    end,
  }
}
